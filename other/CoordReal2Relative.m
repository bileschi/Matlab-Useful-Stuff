function [rxy] = CoordReal2Relative(xy,imsize)
%function [rxy] = CoordReal2Relative(xy,imsize)
%
%intent: represent xy as a loctation relative within an image of imsize
%        the location xy = [1,1] would be the topleftmost pixel, and is representative of the
%        value of the image function at the absolute position .5,5.
%
%        the location xy = [imsize(2), imsize(1)] would be the bottom right most pixel, and would
%        be represntative of the absolute location xy-.5
%rxy should be n x 2, but a 2 x n matrix will work, unless n = 2;


if ((size(xy,2) ~= 2) && (size(xy,1) == 2))
   xy = xy';
end

rxy(:,1) = (xy(:,1) - .5) / imsize(2);
rxy(:,2) = (xy(:,2) - .5) / imsize(1);
 
