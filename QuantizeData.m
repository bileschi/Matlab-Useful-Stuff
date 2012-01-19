function X_Sparse = QuantizeData(X,options)
% function X_Sparse = QuantizeData(X,options)
%
%
if nargin < 2
  options = [];
end
d.percentileShutoff = .5;
options= ResolveMissingOptions(options,d);
nFeatures = size(X,1);
nData = size(X,2);
X_Sparse = zeros(size(X));
for iFeat = 1:nFeatures
   fThresh = percenctile(X(iFeat,:),options.percentileShutoff,1);
   X_Sparse(iFeat,:) = floor(X(iFeat,:) / fThresh);
end