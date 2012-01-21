function outM = spindex(inM,varargin)
%function outM = spindex(inM,varargin)
%
%returns a matrix indexed from inM via index variables contained in varargin
%useful for retreiving multiple values from a large multidimensional matrix
%
%
%inM is an N-d matrix
%the index variables stored in varargin must be as numerous as the number of dimensions in inM
%each index variable must be identical in size
%
%example:
%
%z = reshape(1:(5^4),[5,5,5,5]);
%zid1 = [1,1,5];
%zid2 = [1,2,5];
%zid3 = [1,3,5];
%zid4 = [1,4,5];
%zOut = spindex(z,zid1,zid2,zid3,zid4)
%%   should be like [1,431,625]
%zid1 = [1,2;3,4];
%zid2 = [1,1;1,1];
%zid3 = [1,1;1,1];
%zid4 = [1,1;1,1];
%zOut = spindex(z,zid1,zid2,zid3,zid4)
%%    should be like [[1,2];[3,4]]
sz = size(inM);
ndim = length(sz);
if((ndim == 2) & (sz(2) ==1)) % ndim always returns at least 2
  ndim =1;
end
if(nargin ~= (ndim +1))
   extraDims = setdiff(1:(nargin - 1),1:ndim);
   for iExtraDim = extraDims
      if(any(varargin{iExtraDim}~=1))
         error('must have as many indicies as dimensions\n');
      end
   end
end
szid = size(varargin{1});
for i = 1:ndim
   szid2 = size(varargin{i});
   if(any(szid2 ~= szid))
      error('indicies must have identical shape');
   end
   ndIdxs(:,i) = varargin{i}(:);
end
if(ndim == 1)
   idxs = ndIdxs(:,1);
else
   idxs = myNDsub2ind(size(inM),ndIdxs);
end
outM = nan(1,length(idxs));
outM(find(not(isnan(idxs)))) = inM(idxs(find(not(isnan(idxs)))));
outM = reshape(outM,size(varargin{1}));





function ndx = myNDsub2ind(siz,subs)
%function ndx = NDsub2ind(siz,subs)
%-------------------------------
%works more smoothly when the dimensionality of the mtrx is unknown
%siz should be like [10 10 4 5] if subs is like
% 9 8 3 5
% 1 1 1 1
% 10 10 4 5
% 5 8 3 3
%
% siz will be rotated for you if submit a row vec instead a col vector
% example: NDsub2ind([10 10 4 5],[[9,8,3,5];[1,1,1,1]])
%----------------------------------------------
if(size(siz,1) > 1) && (size(siz,2) > 1)
   error('the siz variable must be a vector');
end
  
if((size(subs,1) ~= 1) && (size(subs,2) == 1))
   subs = subs';
end
siz = siz(:)';
if length(siz)<2
        error('MATLAB:sub2ind:InvalidSize',...
            'Size vector must have at least 2 elements.');
end

if ((length(siz) ~= size(subs,2)))
    error('NDsub2ind: length(siz) must = size(subs,2)');
end

nPoints = size(subs,1);


%Compute linear indices
k = [1 cumprod(siz(1:end-1))];
ndx = ones(nPoints,1);
s = size(subs); %For size comparison
for i = 1:length(siz),
    v = subs;
    fNaN = find(   (v(:,i) < 1) | (v(:,i) > siz(i))   );
    %Verify subscripts are within range
    v(fNaN,i) = nan;
    ndx = ndx + (v(:,i)-1)*k(i);
end
