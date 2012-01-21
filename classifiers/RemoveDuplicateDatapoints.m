function  [X1,f1,X2,f2] = RemoveDuplicateDatapoints(X,Xo);
%function  [X1,f1] = RemoveDuplicateDatapoints(X);
%function  [X1,f1,X2,f2] = RemoveDuplicateDatapoints(X,Xo);
%
% assumes datapoints are columns
% if nargin ==1, then points within the matrix which are duplicates are removed
%
% X1 = X(:,f1) where f1 is the first index of each unique column
%
%if nargin == 2, then points in the combined matrix [X,Xo] are removed, but resplit into their original sets
%f1 indicies into X, f2 into xo.
if(nargin == 1)
   [isU,isFE] = find_unique_vecs(X);
   f1 = find(isFE);
   X1 = X(:,f1);
end

if(nargin == 2)
   [isU,isFE] = find_unique_vecs([X,Xo]);
   f = find(isFE);
   f1 = f(find(f <= size(X,2)));
   f2 = f(find(f > size(X,2)));
   f2 = f2 - size(X,2);
   X1 = X(:,f1);
   X2 = Xo(:,f2);
end

function [isU,isFE] = find_unique_vecs(X);
%isU is means the column is unique
%isFE means is the first example
[n,q] = size(X);
hashVec = rand(1,n);
[sh,sih] = sort(hashVec * X);
d = diff(sh) ~= 0;
isFE = [1,d];
isU = isFE & [d,1];
ish = invertpermutation(sih);
isFE = isFE(ish);
isU = isU(ish);