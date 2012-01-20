function N = MatrixDecimate_Max(M,dim,span,operation)
%function N = MatrixDecimate_Max(M,dim,span,operation)
%
% returns a matrix N the same size as M except in dimension dim, where it is
% floor(size(M,dim) / span)
% in this dimension the entries correspond to the maximum over a tesselated support where the support
% of each element is equal to span cells

if(nargin < 4)
  operation = 'max';
end
ndim = length(size(M));
permutation = [dim, setdiff(1:ndim,dim)];
M = permute(M,permutation);
oldsize = size(M);
M = reshape(M,[size(M,1), prod(size(M)) / size(M,1)]);
rem = mod(size(M,1),span);
newlength = floor(size(M,1)/span);
t = floor(rem/2);
b = ceil(rem/2);
M = M(t+1:1:(end-b),:);
M = reshape(M,[span, prod(size(M)) / span]);
switch(lower(operation))
  case('max')
    N = max(M);
  case('mean');
    N = mean(M);
end
N = reshape(N,[newlength,oldsize(2:end)]);
N = ipermute(N,permutation);
 