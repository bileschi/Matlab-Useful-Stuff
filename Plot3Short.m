function h = Plot3Short(X,extraString)
%function h = Plot3Short(X,extraString)
%
%like plot3(X(:,1), X(:,2), X(:,3))
% or X' if size(X,1) == 3
%
sz = size(X);
if (sz(1) == 3) && (sz(2) ~= 3)
   X = X';
end
if(nargin < 2)
   h = plot3(X(:,1), X(:,2), X(:,3));
else
   h = plot3(X(:,1), X(:,2), X(:,3),extraString);
end
