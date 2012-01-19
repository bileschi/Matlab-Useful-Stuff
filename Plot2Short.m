function h = Plot2Short(X,varargin)
%function h = Plot2Short(X,extraString)
%
%like plot3(X(:,1), X(:,2), X(:,3))
% or X' if size(X,1) == 3
%
if(nargin < 2)
   if(size(X,2) == 1)
      h = plot(X(1),X(2));
   else
      h = plot(X(1,:), X(2,:));
   end
else
   if(size(X,2) == 1)
      h = plot(X(1), X(2),varargin{:});
   else
      h = plot(X(1,:), X(2,:),varargin{:});
   end
end
