function [H,options] = HistogramMultiDim(X, options,H)
%function [H,options] = HistogramMultiDim(X, options,H);
% X is n*q where n is the number of features and q is the number of points
% H is n dimensional and defaults to 5 bins in each dimension;
% each element votes into the space linearly
% (in a 4 dimensional histogram, each point votes into 2^4 bins.)
% 
% if H is input, then it is assumed that it meets the options
% specifications and histogram(X) will be added to the existing H.
%
% bileschi@alum.mit.edu


%For consistency, ranges should be set manually something like
% min(X,2), max(X,2)];
X = double(X);
if(nargin < 2) 
  options = [];
end

nDim = size(X,1);
%if(nDim > size(X,2))
%   fprintf('are you sure you didnt want the transpose?\n');
%end

d.HSize = repmat(5,[nDim,1]);
d.Ranges = [min(X,[],2), max(X,[],2)]; % [mx,Mx;my,My;mz,Mz...]
d.Method = 'linear'; % can be 'nearest','linear','fatkernelnearest'
d.bDataClamp = 0; 
% clamps data in options.Ranges 0:->data outside will generate error in
% NDsub2ind

options = ResolveMissingOptions(options,d);
if(isempty(options.Ranges))
   options.Ranges = d.Ranges;  % empty ranges is not allowed.
end
if(options.bDataClamp)
   for i = 1:size(X,1)
      X(i,:) = clamp(X(i,:),options.Ranges(i,1),options.Ranges(i,2));
   end
end
for i = 1:nDim
   nu = length(unique(X(i,:)));
   if(nu==1);
      warning('at least one dimension is constant');
   end
   % options.Ranges(i,2) = options.Ranges(i,2) + 1;
end

options.HSize = options.HSize(:);
X = X - repmat(options.Ranges(:,1),[1,size(X,2)]);
X = X ./ repmat(options.Ranges(:,2)-options.Ranges(:,1),[1,size(X,2)]);
X = X .* repmat(options.HSize-1,[1,size(X,2)]) + 1;
% each element in X now contains approximately its bin location
if(nargin < 3)
   H = zeros(options.HSize');
end
Hi = zeros(options.HSize'); % one element to be added to H
siz = options.HSize;
CeilFloorPattern = GenerateCeilFloorPattern(options);
switch lower(options.Method)
  case 'nearest'
     isubs = round(X);
 %    for i = 1:size(X,2)
 %      indicies = NDsub2ind(siz,isubs(:,i)');
 %      H(indicies) = H(indicies) + 1;
 %      if(mod(i,500) == 0)
 %         fprintf('nearest %d of %d\r',i,size(X,2));
 %      end
 %    end
       indicies = sort(NDsub2ind(siz,isubs'));
%       keyboard;
       u = unique(indicies);
       z = indicies(2:end)-indicies(1:(end-1));
       f = [find(z);length(indicies)];% the count of each unique element
       u_count = f(:) - [0;f(1:(end-1))];
%       for i = 1:length(u)
%          H(u(i)) = H(u(i)) + length(find(indicies == u(i)));
%       end
       H(u) = H(u) + u_count;
   case 'linear'
  %  for i = 1:size(X,2)
  %     [isubs,weights] = generateSubsAndWeights(X(:,i),CeilFloorPattern,options);
  %     indicies = NDsub2ind(siz,isubs');
  %     H(indicies) = H(indicies) + weights';
  %     if(mod(i,500) == 0)
  %      fprintf('linear %d of %d\r',i,size(X,2));
  %     end
  %  end
    for i = 1:size(CeilFloorPattern,2)
       isubs = round(X + repmat(CeilFloorPattern(:,i),[1,size(X,2)]));
       isubs = min(isubs, repmat(options.HSize,[1,size(X,2)]));
       Dists = X - isubs;
       Dists = Dists.^2;
       Dists = sum(Dists,1);
       Dists = Dists + .05 * max(Dists); % regularization
       weights(i,:) = Dists.^(-1);
       indicies(i,:) = sort(NDsub2ind(siz,isubs'));
    end
    CNormWeights = sum(weights.*weights,1);
    weights = weights ./ repmat(CNormWeights,[size(weights,1),1]);
    for j = 1:size(CeilFloorPattern,2)
       theseIndicies = indicies(j,:);
       theseWeights = weights(j,:);
       u = unique(theseIndicies);
       for i = 1:length(u)
          f = find(theseIndicies == u(i));
          H(u(i)) = H(u(i)) + sum(theseWeights(f));
       end  
    end
end

function [isubs,weights] = generateSubsAndWeights(v,CeilFloorPattern,options)
ndim = length(v);
nNeighbors = 2^ndim;
isubs = CeilFloorPattern + repmat(floor(v),[1,nNeighbors]);
isubs = min(isubs, repmat(options.HSize,[1,nNeighbors]));
M = isubs - repmat(v,[1,nNeighbors]);
Dists = sqrt(sum(M.*M ,1));
Dists = Dists + .05 * max(Dists); % a bit of regularization
weights = Dists.^(-1);
weights = weights / norm(weights);

function CeilFloorPattern = GenerateCeilFloorPattern(options)
ndim = length(options.HSize);
CeilFloorPattern = zeros(ndim, 2^ndim);
for i = 0:((2^ndim)-1)
   a = dec2bin(i,ndim);
   for j = 1:ndim
     CeilFloorPattern(j,i+1) = str2num(a(j));
   end
end







 