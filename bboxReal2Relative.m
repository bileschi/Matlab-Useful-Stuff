function bbox2 = bboxReal2Relative(bbox1, imsize)
bbox2 = CoordReal2Relative(reshape(bbox1,[2,2])',imsize);
bbox2 = bbox2';
bbox2 = bbox2(:)';
