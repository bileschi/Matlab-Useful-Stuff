function H = AdaptiveHistogramApply(X,Model,options)
%function H = AdaptiveHistogramApply(X,Model,options)
%
%Model as output by AdaptiveHistogramTrain and X as used to train it.
%
% options include how to interpolate between bins

defOpts.interpStrat = 'hard';
if(nargin < 3)
    options = [];
end
options = ResolveMissingOptions(options,defOpts);
H = zeros(Model.nFeatures, 1);
thresholdPassed = zeros(size(X));
if(strcmpi(options.interpStrat,'hard'));
   for iFeat = 1:size(X,1)
      for iThresh = 1:length(Model.caBinBoundaries{iFeat})
         thresholdPassed(iFeat,:) = thresholdPassed(iFeat,:) + (X(iFeat,:) >= Model.caBinBoundaries{iFeat}(iThresh));
      end
   end
end
jumpSizes(1) = 1;
for i = 1:length(Model.caBinCenters);
   nInThisDim(i) = length(Model.caBinCenters{i});
   jumpSizes(i+1) = jumpSizes(i) * nInThisDim(i);
end
binNum = thresholdPassed' * jumpSizes(1:length(Model.caBinCenters))' + 1;
H = zeros(Model.nFeatures,1);
for i= 1:length(binNum)
   H(binNum(i)) = H(binNum(i)) + 1;
end