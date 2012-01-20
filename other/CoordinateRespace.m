function coord2_xy = CoordinateRespace(coord1_xy, imsize1, imsize2,mode)
%function coord2_xy = CoordinateRespace(coord1_xy, imsize1, imsize2,mode)
%
% translates positions in frame imsize1 to relatively identical positions in frame imsize2
%
%
%takes input of the form [x,y] where x and y are column vectors of equal length
%if mode is defined as bbox, then input is of the form [l,t,w,h]

if(nargin <= 3)
  mode = 'regular';
end
if(strcmpi(mode,'bbox'))
  temp = coord1_xy;
  clear coord1_xy;
  coord1_xy(1,:) = temp([1,3]);
  coord1_xy(2,:) = temp([2,4]);
  clear temp;
end
rel_coord_xy = CoordReal2Relative(coord1_xy, imsize1);
coord2_xy = CoordRelative2Real(rel_coord_xy, imsize2,0);
if(strcmpi(mode,'bbox'))
  temp = coord2_xy;
  clear coord2_xy;
  coord2_xy([1 2]) = [temp(1,1), temp(2,1)];;
  coord2_xy([3 4]) = [temp(1,2), temp(2,2)];;
  clear temp;
end
 