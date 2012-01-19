function z = NDind2sub(siz,ndx)
%function z = NDind2sub(siz,ndx)
%
%does not require multiple inputs.
%smoother than ind2sub when the dimensionality is unknown.
%

nPoints = length(ndx);
n = length(siz);
z = zeros(nPoints,n);
k = [1 cumprod(siz(1:end-1))];
ndx = ndx - 1;
for i = n:-1:1,
  v = floor(ndx/k(i))+1;  
  z(:,i) = v; 
  ndx = rem(ndx,k(i));
end

