function bbox2 = bboxReal2Relative(bbox1, imsize)
%function bbox2 = bboxReal2Relative(bbox1, imsize)
%
% converts input boundign box [x, y, width, height] to relative positions, sizes
% within the frame described by imsize.  Relative positions are calculated
% as if the frame imsize stretched from the origin to (1,1)
bbox2 = CoordReal2Relative(reshape(bbox1,[2,2])',imsize);
bbox2 = bbox2';
bbox2 = bbox2(:)';
