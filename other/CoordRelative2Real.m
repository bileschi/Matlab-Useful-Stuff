function [xy] = CoordRelative2Real(rxy,imsize,bound)
%function [xy] = CoordRelative2Real(rxy,imsize,bound)
%
%undo CoordReal2Relative
%if bound == 1 then limit xy to be within [1 1],imsize
%
%rxy should be n x 2, but a 2 x n matrix will work, unless n = 2;


if ((size(rxy,2) ~= 2) && (size(rxy,1) == 2))
   rxy = rxy';
end

npts = size(rxy,1);
xy(:,1) = (rxy(:,1) * imsize(2)) + .5;
xy(:,2) = (rxy(:,2) * imsize(1)) + .5;
if(nargin > 2)
  if (bound == 1)
    xy(:,1) = min(max(xy(:,1),repmat(1,[npts,1])),repmat(imsize(2),[npts,1]));
    xy(:,2) = min(max(xy(:,2),repmat(1,[npts,1])),repmat(imsize(1),[npts,1]));
  end
end
    
