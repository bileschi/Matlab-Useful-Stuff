function DetectionMap = WindowedObjectDetectionNaive(img,Model,options);
%function DetectionMap = WindowedObjectDetectionNaive(img,Model,options);
%
% A function to convert an image crop into the appropriate feature vector
% is passed to the windowing function by name.  This function must take only the crop
% as inputs (no additional parameters are allowed), and return a vector response
% appropriate to the Model.  The easiest way to build such a function is to write a wrapper
% for the functino which was used to generate the training data for the Model.

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
D.ImageToFeatureFunction = [];
D.Verbose = 1;
% D.ImageToFeatureFunction = Img2C1Basic;



if(not(exist('options'))),options = [];, end
options = ResolveMissingOptions(options,D);

padsize(1) = floor((options.WindowSize(2)-1)/2);
padsize(2) = floor((options.WindowSize(1)-1)/2);
padsize(3) = floor(options.WindowSize(2)/2);
padsize(4) = floor(options.WindowSize(1)/2);

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
    % fprintf('\n');
    % if(options.Verbose)
    %    fprintf('%d of %d | col %d of %d \r',iRow,nRows, iCol, nCols);
    % end
    cropvec = imcrop(img,[iCol,iRow,options.WindowSize(1)-1,options.WindowSize(2)-1]);
    cropvec = cropvec(:);
    if(not(isempty(options.ImageToFeatureFunction)))
      cmd = sprintf('cropvec = %s(cropvec);',options.ImageToFeatureFunction);
      eval(cmd);
    end
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
