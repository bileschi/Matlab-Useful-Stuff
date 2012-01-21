function h = fig(optionalIdx)
%function h = fig(optionalIdx)
%fig is like figure, except we place it in the top left corner
if(nargin < 1)
 h = figure;
else
 h = figure(optionalIdx);
end
p = get(h,'Position');
p(1) = 0;
set(h,'Position',p);
