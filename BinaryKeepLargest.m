function b = BinaryKeepLargest(x,fOnPart);
%function b = BinaryKeepLargest(x,fOnPart);
%
% onpart is a fraction between 0 and 1
% perform on columns if x is a matrix
% 
% edited 12/5 so that identical values are not selected first-come.

if(prod(size(x)) > length(x))
  nCol = size(x,2);
else
  nCol = 1;
  x = x(:);
end
p = randperm(size(x,1)); % 12/5
x = x(p,:);              % 12/5
nOn = ceil(fOnPart * size(x,1));
b = zeros(size(x));
for i = 1:nCol
  [sx,sxi] = sort(-x(:,i));
  b(sxi(1:nOn),i) = 1;
end
b(p,:) = b;              % 12/5
