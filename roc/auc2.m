function a = auc2(px, py, M);
% function a = auc2(px, py, M)
%
% helper function to ROC curve generation.  computes the area under the curve in the unit cube,
% described by the points on the curve, px, py.  The curve is assumed to be convex, this calcultion
% will be incorrect if it is not.
px = px(:);
py = py(:);

if(isempty(px))
  a = .5;
  return;
end

if(nargin < 3), M = 1;, end

px = sort(px);
py = sort(py);
px = px(find(px < M));
py = py(1:length(px));

e = [px,py];
a = 0;
de = diff(e);
%% for i=1:(size(de,1))
%%  a = a + de(i,1)*(e(i+1,2) - de(i,2)/2);
%% end
for i = 2:length(px)
  % a = a + (rectangle part) + (triangle part)
  % a = a + (de(i-1,1) * py(i-1)) + (0.5)*(de(i-1,1)*py(i));
  a = a + de(i-1,1) * ( py(i-1) + (0.5)*(de(i-1,2)));
end
return
