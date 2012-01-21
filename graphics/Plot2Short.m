function h = Plot2Short(X,varargin)
%function h = Plot2Short(X,extraString)
%
%like plot(X(:,1), X(:,2))
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
