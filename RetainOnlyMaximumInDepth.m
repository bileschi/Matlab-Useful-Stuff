function Y = RetainOnlyMaximumInDepth(X,bNormalizeEachLayer)
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