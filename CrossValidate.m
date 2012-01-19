function [caModels,caTTS,caROCs,options] = CrossValidate(X1,X2,options)
%function [caModels,caTTS,caROCs,optionsOut] = CrossValidate(X1,X2,options)
%
%Ver 4.0
% Nov 2007 added a feature subselection option
% Nov 2007 added a example subselection option
% Dec 2007 added balancing to example subselection
%  d.nSplits = 1;
%  d.TrainPart = .5;
%  d.Classifier = 'gentleBoost';
%  d.FeatureSubset = [];
%  d.PickFeatureSubsetForMe = 0;
%  d.PosExampleSubset = [];
%  d.NegExampleSubset = [];
%  d.PickExampleSubsetForMe = 0;

d.nSplits = 1;
d.TrainPart = .5;
d.Classifier = 'gentleBoost';
d.FeatureSubset = [];
d.PickFeatureSubsetForMe = 0;
d.PosExampleSubset = [];
d.NegExampleSubset = [];
d.PickExampleSubsetForMe = 0;
d.RemoveDuplicateDatapoints = 0;

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

%sPARAMS.Nrounds = 100;
%sPARAMS.R = 0;
%sPARAMS.T = 0;

if(options.RemoveDuplicateDatapoints)
    [X1,X2] = RemoveDuplicateDatapoints(X1,X2);
end
if(strcmpi(options.Classifier,'libsvm') | strcmpi(options.Classifier, 'boostPlusSVM'));
   X1 = double(X1);
   X2 = double(X2);
end
nSplits = options.nSplits;
% If necessary, pick an example subset randomly (the same example subset is used for all trials)
if(options.PickExampleSubsetForMe > 0) && (options.PickExampleSubsetForMe < (size(X1,2)+size(X2,2)))
   if(size(X1,2) < size(X2,2)) % fewer pos
       nPosToTake = min(size(X1,2),options.PickExampleSubsetForMe/2);
       nNegToTake = min(options.PickExampleSubsetForMe-nPosToTake,size(X2,2));
   else % fewer neg
       nNegToTake = min(size(X2,2),options.PickExampleSubsetForMe/2);
       nPosToTake = min(options.PickExampleSubsetForMe-nNegToTake,size(X1,2));
   end
   posToTake = randperm(size(X1,2));
   posToTake = posToTake(1:nPosToTake);
   negToTake = randperm(size(X2,2));
   negToTake = negToTake(1:nNegToTake);
   %options.ExampleSubset = randperm(size(X,2));
   options.PosExampleSubset = posToTake;
   options.NegExampleSubset = negToTake;
else
   options.PosExampleSubset = 1:size(X1,2);
   options.NegExampleSubset = 1:size(X2,2);
end
if(length(options.PosExampleSubset) < 1) || (length(options.NegExampleSubset) < 1)
   error('options.???ExampleSubset must be a set of integers greater than one\n');
end
if(any(not(ismember(options.PosExampleSubset,1:size(X1,2)))))
   error('the options.PosExampleSubset is outside of the actual size of the matricies\n');
end
if(any(not(ismember(options.NegExampleSubset,1:size(X2,2)))))
   error('the options.NegExampleSubset is outside of the actual size of the matricies\n');
end
X = [X1(:,options.PosExampleSubset), X2(:,options.NegExampleSubset)];
y = [ones(1,length(options.PosExampleSubset)),-ones(1,length(options.NegExampleSubset))];
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
      fprintf('warning: TTS and ROC are undefined when no test data\n');
   end
   for iSplit = 1:nSplits
      cmd = ['caModels{iSplit} = CLS',options.Classifier,'(X,y(:),options);'];
      eval(cmd);
   end
else
   for iSplit = 1:nSplits
      caTTS{iSplit} = TTSplit_Make(1:nExamples,options.TrainPart, 1-options.TrainPart);
      nClassesPerPart = [length(unique(y(caTTS{iSplit}.Train))),length(unique(y(caTTS{iSplit}.Test)))];
      nTriesToSplit = 0;
      while(nClassesPerPart(1) ~= nClassesPerPart(2))
         caTTS{iSplit} = TTSplit_Make(1:nExamples,options.TrainPart, 1-options.TrainPart);
         nClassesPerPart = [length(unique(y(caTTS{iSplit}.Train))),length(unique(y(caTTS{iSplit}.Test)))];
         nTriesToSplit = nTriesToSplit + 1;
         if(nTriesToSplit > 100)
            fprintf('Can''t split data, are there too few examples of one class?\n\n');
            iSplit
            nClassesPerPart
            caTTS
            caTTS{iSplit}
            error
         end
      end
      cmd = ['caModels{iSplit} = CLS',options.Classifier,'(X(:,caTTS{iSplit}.Train),y(caTTS{iSplit}.Train)'',options);'];
      eval(cmd);
      if(nargout > 1)
         cmd = ['[caYempl{iSplit},caYemp{iSplit}] = CLS',options.Classifier,'C(X(:,caTTS{iSplit}.Test),caModels{iSplit});'];
         eval(cmd);
         caROCs{iSplit} = ROCetc2(caYemp{iSplit},y(caTTS{iSplit}.Test));
      end
   end
end