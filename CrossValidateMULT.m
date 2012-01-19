function [caModels,caTTS,caConf,Perf,options,ccaROCs] = CrossValidateMULT(X,y,options)
%function [caModels,caTTS,caConf,Perf,options,ccaROCs] = CrossValidateMULT(X,y,options)
%
%Ver 1.0
%  
%  d.nSplits = 1;
%  d.TrainPart = .5;
%  d.Classifier = 'gentleBoost';
%  d.FeatureSubset = [];
%  d.PickFeatureSubsetForMe = 0;
%  d.PosExampleSubset = [];
%  d.NegExampleSubset = [];
%  d.PickExampleSubsetForMe = 0;
%  d.TTSGrouping = 1;

d.nSplits = 1;
d.TrainPart = .5;
d.Classifier = 'gentleBoost';
d.FeatureSubset = [];
d.PickFeatureSubsetForMe = 0;
d.PosExampleSubset = [];
d.NegExampleSubset = [];
d.PickExampleSubsetForMe = 0;
d.TTSGrouping = 1;

%gentleBoost
d.Nrounds = 100;
d.R = 0;
d.T = 0;
%libsvm
d.KERNEL = 0;
d.C = 1;
%rls
d.LAMBDA = 1;

if(nargin < 3)
options = [];
end
options = ResolveMissingOptions(options,d);
if(~strcmp(options.Classifier(1:3),'CLS'))
   options.Classifier = ['CLS',options.Classifier];
end
options.CLASSIFIERNAME = options.Classifier;
options.CLASSIFIERsPARAMS.KERNEL = options.KERNEL;
options.CLASSIFIERsPARAMS.C = options.C;
options.CLASSIFIERsPARAMS.Nrounds = options.Nrounds;
options.CLASSIFIERsPARAMS.R = options.R;
options.CLASSIFIERsPARAMS.T = options.T;
options.CLASSIFIERsPARAMS.LAMBDA = options.LAMBDA;

%sPARAMS.Nrounds = 100;
%sPARAMS.R = 0;
%sPARAMS.T = 0;

nSplits = options.nSplits;
nExamples = length(y);
% If necessary, pick a feature subset randomly (the same feature subset is used for all trials)
if(options.PickFeatureSubsetForMe > 0) && (options.PickFeatureSubsetForMe < size(X,1))
   options.FeatureSubset = randperm(size(X,1));
   options.FeatureSubset = options.FeatureSubset(1:options.PickFeatureSubsetForMe);
end
if(not(isempty(options.FeatureSubset)))
   if(length(options.FeatureSubset) < 1)
      error('options.FeatureSubset must be a set of integers greater than one\n');
   end
   if(any(not(ismember(options.FeatureSubset,1:size(X,1)))))
      error('the options.FeatureSubset is outside of the actual size of the matricies\n');
   end
   X = X(options.FeatureSubset,:);
end
nExamples = length(y);
%if there is no test part then don't call the testing stage
if(options.TrainPart == 1)
   if(nargout > 2)
      fprintf('warning: output undefined when no test data\n');
   end
   for iSplit = 1:nSplits
      caModels{iSplit} = MULTonevsall(X,y(:),options);
   end
else
   for iSplit = 1:nSplits
      TTSopts.Grouping = options.TTSGrouping;
      caTTS{iSplit} = TTSplit_Make(1:nExamples,options.TrainPart, 1-options.TrainPart,TTSopts);
      caModels{iSplit} = MULTonevsall(X(:,caTTS{iSplit}.Train),y(caTTS{iSplit}.Train)',options);
      if(nargout > 1)
         [caLab{iSplit},mmax,FM] = MULTonevsallC(X(:,caTTS{iSplit}.Test),caModels{iSplit});
         FM = FM';
         if(nargout > 5) % generate ROCs
            for iClass = 1:size(FM,1)
               ccaROCs{iSplit}{iClass} = ROCetc2(FM(iClass,:),y(caTTS{iSplit}.Test)==caModels{iSplit}.uniquey(iClass));
            end
         end
         [caConf{iSplit},caKeys{iSplit},Perf(iSplit)] = GenerateConfusion(caLab{iSplit},y(caTTS{iSplit}.Test));
      end
   end
end
