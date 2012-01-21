function Y = RetainOnlyMaximumInDepth(X,bNormalizeEachLayer)
%function Y = RetainOnlyMaximumInDepth(X,bNormalizeEachLayer)
%
% returns a matrix Y the same size as 3D input matrix X, except that for each 
% X(i,j,:), Y(i,j,:) is completely 0, except for the maximal value of X(i,j,:)
%
% im = imread('peppers.png')
% Y = RetainOnlyMaximumInDepth(im);
% imshow(Y/256);

if nargin < 2, bNormalizeEachLayer = 0;, end
[m,mi] = max(X,[],3);
Y = zeros(size(X));
Spread = length(mi(:));
f = 1:Spread;
f = f'+(mi(:)-1)*Spread;
Y(f) = m;

if(bNormalizeEachLayer)
  for i = 1:size(Y,3)
    M = max(max(Y(:,:,i)));
    m = min(min(Y(:,:,i)));
    Y(:,:,i) = (Y(:,:,i)-m)/(M-m);
  end
end