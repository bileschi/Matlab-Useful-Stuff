function H = AdaptiveHistogramApply(X, model, options)
%function H = AdaptiveHistogramApply(X, model, options)
%
% given: N, D-dimensional samples X, size(X) == [D,N] :
%        model as output by AdaptiveHistogramTrain and X as used to train it.
%
% produce a new vector H counting how many samples fall into each bin.
%        size(H) == [k^D, N] where k is the number of bins per dimension, a model param.
%
% options: interpStrat: to interpolate between bins default 
% 			{'hard'} is the the only implemented one.

[D, N] = size(X);
% check data in is ok.
if( (length(model.caBinCenters) ~= D)  | ...
	(length(model.caBinBoundaries) ~= D))
	error('model dimensionality ' + num2str(D) + ' does not match input X')
end
if( length(model.caBinCenters{1}) ~= (length(model.caBinBoundaries{1}) + 1))
	error('model internally inconsistant')
end

defOpts.interpStrat = 'hard';
if(nargin < 3)
    options = [];
end
options = ResolveMissingOptions(options, defOpts);

H = zeros(model.nFeatures, 1);
thresholdPassed = zeros(size(X));
if(strcmpi(options.interpStrat, 'hard'));
   for iFeat = 1:D
      for iThresh = 1:length(model.caBinBoundaries{iFeat})
      	% calculate the index of each sample, in adaptive space.
         thresholdPassed(iFeat,:) = thresholdPassed(iFeat,:) + ...
         	(X(iFeat,:) >= model.caBinBoundaries{iFeat}(iThresh));
      end
   end
end
% jumpSizes(i) helps to calculate histogram bin index from subscripts
jumpSizes(1) = 1;
for i = 1:D
   nInThisDim(i) = length(model.caBinCenters{i});
   jumpSizes(i+1) = jumpSizes(i) * nInThisDim(i);
end
binNum = thresholdPassed' * jumpSizes(1:length(model.caBinCenters))' + 1;
H = zeros(model.nFeatures,1);
for i= 1:length(binNum)
   H(binNum(i)) = H(binNum(i)) + 1;
end
keyboard