function Model = AdaptiveHistogramTrain(X,options)
%function Model = AdaptiveHistogram(X,options);
%
% given N, D-dimensional samples X, size(X) == [D,N] : 
% for each dimension d, select a set of k - 1 thresholds such that the points
% of X projected into d fall into the k bins in approximately the same number each.
%
% These boundaries desribe rasterization of the real space into a set of k^D buckets
% in such a way that bins are smaller where there are more data.
%
%options: k   defaults to 10
%

X = double(X);
nDims = size(X,1);
nPts = size(X,2);
if(nDims > nPts)
    fprintf('error, more features than points, is that what you wanted?\n');
    Model = [];
    return;
end

defOpts.k = 10;

if(nargin < 2)
    options = [];
end
options = ResolveMissingOptions(options,defOpts);

binSpacing = nPts / (options.k);
binBoundaries = binSpacing:binSpacing:(nPts-1);
binCentroids = (binSpacing/2):(binSpacing):nPts;
Model.nFeatures = options.k ^ nDims;

for iDim = 1:nDims
    [s,si] = sort(X(iDim,:));
    Model.caBinCenters{iDim} = linInterpSample(s,binCentroids);
    Model.caBinBoundaries{iDim} = linInterpSample(s,binBoundaries);
end