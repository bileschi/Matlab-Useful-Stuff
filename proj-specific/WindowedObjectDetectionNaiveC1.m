function DetectionMap = WindowedObjectDetectionNaiveC1(img,Model,options);
%function DetectionMap = WindowedObjectDetectionNaive(img,Model,options);
%
% Performs windowing detection in C1 space somewhat more efficiently than
% calculating the c1 vector for all crops of the source image.
% 
% only works for 128 128 windows using regular C1 parameters.


D.ClassifierType = 'gentleBoost';
D.WindowSize = [128 128];
D.bPadBorders = 1;
D.PadStrategy = 'symmetric';
D.yxStep = [1 1];  % must be integers greater than 0
D.FeatureSubsample = [];          % use this subset of the indicies output by the feature function
                                        % empty matrix indicates no subset.
D.bNormalizeDataSamples = 1;      % what type of data normalization
D.NormalizationParams = [];       % modualates type of data normalization
D.caNormalizationRegions = [];  % if different feature sets need to be normd independantly
D.Verbose = 1;


if(not(exist('options'))),options = [];, end
options = ResolveMissingOptions(options,D);

padsize(1) = 100;
padsize(2) = 100;
padsize(3) = 100;
padsize(4) = 100;

if(options.bPadBorders)
  nRows = size(img,1);
  nCols = size(img,2);
  DetectionMap = zeros(floor(size(img) ./ options.yxStep));
  img = padimage(img, padsize,options.PadStrategy);
else
  DetectionMap = zeros(floor((size(img) - options.WindowSize + 1) ./ options.yxStep));
  nRows = (size(img,1) - options.WindowSize(1) + 1)
  nCols = (size(img,2) - options.WindowSize(2) + 1)
end  

%build the c1 representation
c1opts.C1VerRegularC1 = 1;
t1 = clock;
caC1 = c1Img2C1Simple(img, c1opts);
fprintf('time to build c1 representation is %f\n',etime(clock, t1));

inimsize = size(img);
% loop over rows and columns
ir = 0;
for iRow = 1:options.yxStep(1):nRows
  ir = ir+1;
  if(options.Verbose)
    fprintf('%d of %d\r',iRow,nRows);
  end
  ic = 0;
  for iCol = 1:options.yxStep(2):nCols
    ic = ic+1;
    c_yx = [iRow + 100, iCol + 100];
    % if(options.Verbose)
    %    fprintf('%d of %d | col %d of %d \r',iRow,nRows, iCol, nCols);
    %    fprintf('\n'); 
    % end
    % 
    % cropvec = imcrop(img,[iCol,iRow,options.WindowSize(1)-1,options.WindowSize(2)-1]);
    cropvec = GetAppropriateCropvecFromCAC1(caC1,inimsize, c_yx);
    if(not(isempty(options.FeatureSubsample)))
       cropvec = SubSampleFeatures(cropvec, options, options.FeatureSubsample);
    end
    if(options.bNormalizeDataSamples)
      cropvec = InternalNormalize(cropvec,options,options.NormalizationParams);
    end
    cmd = sprintf('[yempl,yemp] = CLS%sC(cropvec,Model);',options.ClassifierType);
    eval(cmd);
    DetectionMap(ir,ic) = yemp;
  end
  if(iRow == 3)
    keyboard;
  end
end
if(options.Verbose)
  fprintf('%d of %d\n',iRow,nRows);
end

function [X,NormalizationParams] = InternalNormalize(X,options,NormalizationParams)
if(nargin < 3)
  NormalizationParams = [];
end
if(options.bNormalizeDataSamples > 0)
  if(isempty(options.caNormalizationRegions))
    caNR{1} = 1:size(X,1);
  else
    caNR = options.caNormalizationRegions;
  end
  [X,NormalizationParams] = normalizeByIndex(X, caNR, options.bNormalizeDataSamples,NormalizationParams,options);
end
   
function [XTrainFull, SelectedFeatures] = SubSampleFeatures(XTrainFull, options, SelectedFeatures);
if(nargin < 3)
  SelectedFeatures = 1:size(XTrainFull,1);
  if(size(XTrainFull,1) > options.nMaxFeatures), 
    seedrand(options.RandSeed);
    p = randperm(size(XTrainFull,1));
    XTrainFull = XTrainFull(p(1:options.nMaxFeatures),:);
    SelectedFeatures = p(1:options.nMaxFeatures);
    fprintf('TOO MANY FEATURES: Randomly sampling %d features\n', options.nMaxFeatures);
  end
else
  XTrainFull = XTrainFull(SelectedFeatures,:);
end  

function cropvec = GetAppropriateCropvecFromCAC1(CAC1,c_yx,inimsize);
%function cropvec = GetAppropriateCropvecFromCAC1(CAC1,c_yx,inimsize);
%
% CAC1 has 8 layers, we need crops of the following sizes at the appropriate centers
% 32, 26, 22, 19, 16, 15, 13, 12
boxsize = [32,26,22,19,16,15,13,12];
hbs =  floor(boxsize/2);
cropvec = [];
for iLay = 1:8
  sz = size(CAC1{iLay});
  c = round(CoordinateRespace(inimsize, c_yx, sz(1:2)));
  % bbox = [c(2) - hbs(iLay), c(1) - hbs(iLay), boxsize(iLay), boxsize(iLay)];
  % cacv{iLay} = imcrop(CAC1{iLay},bbox);
  yrange = (c(1) - hbs(iLay)):(c(1) - hbs(iLay) + boxsize(iLay) - 1);
  xrange = (c(2) - hbs(iLay)):(c(2) - hbs(iLay) + boxsize(iLay) - 1);
  cacv{iLay} = CAC1{iLay}(yrange,xrange,:);
  cropvec = [cropvec;,cacv{iLay}(:)];
end
