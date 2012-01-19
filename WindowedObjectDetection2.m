function [yEmpl,yEmp,XBootStrap,yEmpBootStrap] = WindowedObjectDetection2(Model, yx_size, im,options);
%function [yEmpl,yEmp,XBootStrap,yEmpBootStrap] = WindowedObjectDetection(Model, yx_size, im,options);
%
%classify every window of size yx_size with SVM Model Model
%pad the sides with the minimum output value to build an image of the same size as the input

D.ClassifierName = 'gentleBoost';
D.ClassifierOptions.KERNEL = 0;
D.ReturnBootstrapExamples = 0;
D.MaxBootstrapExamples = 5000;
D.bNormalizeExamples = 0;
D.ExamplewiseNormalization = 'L2';
D.bNormalizeFeatures = 0;
D.FeaturewiseNormalization = 'outnormalize';
D.FeatureNormalizationParams = [];
D.FeatureSubsample = 1:(prod(yx_size) * size(im,3));
D.NormalizationParams = [];
D.MatchSize = 0;
if(not(exist('options'))),options = [];, end
options = ResolveMissingOptions(options,D);

nFeat = yx_size(1) * yx_size(2) * size(im,3);
nFeat = min(nFeat, length(options.FeatureSubsample));
BXootStrap = [];
yEmpBootStrap = [];
if(options.ReturnBootstrapExamples)
  XBootStrap = zeros(nFeat,options.MaxBootstrapExamples);
else
  XBootStrap = [];
end

USE_HYP_INSTEAD = 0;
if(options.ClassifierOptions.KERNEL == 0)
  n = options.ClassifierName;
  if (strcmpi(n,'osusvm') || strcmpi(n,'libsvm') || strcmpi(n,'svmlight') )
    [hyperplane,beta] = ModelToHyperplane(Model,n);
    USE_HYP_INSTEAD = 1;
  end
end

origsize = size(im);
if(options.MatchSize)
  im = padimage(im, ceil(yx_size/2),'symmetric');
end

nRows = size(im,1) - yx_size(1) + 1;
yEmp =[];
yEmpl =[];
yEmpBootStrap = [];
nBootstrapSoFar = 0;
for i = 1:nRows
   Strip = Windowing_ImageStripToMatrix(im,yx_size,i);
   if(not(isempty(options.FeatureSubsample)))
     Strip = SubSampleFeatures(Strip, options, options.FeatureSubsample);
   end
   if(not(isempty(options.NormalizationParams)))
     Strip = InternalNormalize(Strip, options, options.NormalizationParams);
   end
   if(USE_HYP_INSTEAD)
     ye = (hyperplane' *Strip-beta);
     yel = ye > 0;
   else
     cmd = sprintf('[yel,ye] = CLS%sC(Strip,Model);',options.ClassifierName); 
     eval(cmd); % -->yel,ye
   end
   yel = yel(:)';
   ye = ye(:)';
   yEmp = [yEmp;ye];
   yEmpl = [yEmpl;yel];
   if((options.ReturnBootstrapExamples) && (nBootstrapSoFar < options.MaxBootstrapExamples)  && (nargout > 3))
      f = find(yel == 1);
      if((nBootstrapSoFar + length(f)) > options.MaxBootstrapExamples)
        f = f(1:(options.MaxBootstrapExamples - nBootstrapSoFar));
      end
      XBootStrap(:,(nBootstrapSoFar + 1):(nBootstrapSoFar + length(f))) = Strip(:,f);
      yEmpBootStrap((nBootstrapSoFar + 1):(nBootstrapSoFar + length(f))) = ye(f); 
      nBootstrapSoFar = nBootstrapSoFar + length(f);
   end
   fprintf('Row %d of %d\r',i,nRows);
end
if((options.ReturnBootstrapExamples) && (nBootstrapSoFar < options.MaxBootstrapExamples)  && (nargout > 3))
  XBootStrap = XBootStrap(:,nBootstrapSoFar);   
end
fprintf('\n');

s1 = origsize;
s2 = size(yEmp);
d = s1([1,2]) - s2;
if(options.MatchSize)
  yEmp = imresize(yEmp,origsize(1:2),'bilinear');
  yEmpl = imresize(yEmp,origsize(1:2),'bilinear');
else
  if(not(isempty(yEmp)));
   yEmp = padimage(yEmp, [floor(d(2)/2),floor(d(1)/2),ceil(d(2)/2),ceil(d(1)/2)],min(min(yEmp)));
  end
  if(not(isempty(yEmpl)))
    yEmpl = padimage(yEmpl, [floor(d(2)/2),floor(d(1)/2),ceil(d(2)/2),ceil(d(1)/2)],min(min(yEmpl)));
  end
end
function X = NormalizeStrip(X,options)
if(options.bNormalizeFeatures)
  switch (lower(options.FeaturewiseNormalization))
  case 'outnormalize';
    if(isempty(options.FeatureNormalizationParams))
      X = outnormalizeDataX(X);
    else
      X = outnormalizeDataX(X,options.FeatureNormalizationParams);
    end
  end
end
if(options.bNormalizeExamples)
  switch (lower(options.ExamplewiseNormalization))
  case 'l2';
    s = sqrt(sum(X.^2)) + eps;
    X = X ./ repmat(s,[size(X,1),1]);
  end
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
