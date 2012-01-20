function Aprime = genericResize(A,newsize,method);
%function Aprime = genericResize(A,newsize,method);
%
%genericResize is like imresize, but it works on ndimensional matricies.
%certainly there is a better way to do this, but i'm going to do it right now
%with creative reshaping, permuting, and imresize;
if(nargin < 3), method = 'bilinear';,end
ndims = length(size(A));
while(length(newsize) < ndims);
  newsize(end+1) = 1;
end
Aprime = A;
for i = 1:ndims
   Aprime = permute(Aprime,[i,setdiff(1:ndims,i)]);
   szprime = size(Aprime);
   Aprime = reshape(Aprime,[szprime(1),prod(szprime(2:end))]);
   Aprime = imresize(Aprime, [newsize(i),prod(szprime(2:end))],method);
   Aprime = reshape(Aprime,[newsize(i),[szprime(2:end)]]);
   Aprime = ipermute(Aprime,[i,setdiff(1:ndims,i)]);
end