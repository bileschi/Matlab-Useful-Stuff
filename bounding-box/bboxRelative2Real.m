function bbox2 = bboxRelative2Real(bbox1, imsize)
%function bbox2 = bboxRelative2Real(bbox1, imsize)
%
% given input bounding box [x, y, width, hight], given in fractions
% of the frame imsize [ysize, xsize], create a new bounding box
% with absolute pixel positions within imsize
bbox2 = CoordRelative2Real(reshape(bbox1,[2,2])',imsize);
bbox2 = bbox2';
bbox2 = bbox2(:)';
