function bbox2 = resize_bbox(bbox,oldsize, newsize)
%function bbox2 = resize_bbox(bbox,oldsize, newsize)
%
%new bbox represents the same rectangle in the new image as old bbox did in the old image.
old_coord = [bbox(1),bbox(2);bbox(1)+bbox(3),bbox(2)+bbox(4)];
rel_coord = CoordReal2Relative(old_coord, oldsize);
new_coord = CoordRelative2Real(rel_coord, newsize,0);%do not bound;
bbox2 = [new_coord(1,1), new_coord(1,2), new_coord(2,1) - new_coord(1,1), new_coord(2,2) - new_coord(1,2)];
bbox2 = round(bbox2);
