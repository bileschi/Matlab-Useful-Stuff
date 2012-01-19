function center_xy = BBoxCenter(myBBox)
%function center_xy = BBoxCenter(myBBox)
%
%returns the center of mass of the bbox;
%

center_xy = [myBBox(1) + .5 * (myBBox(3) + 1), myBBox(2) + .5 * (myBBox(4) + 1)];
