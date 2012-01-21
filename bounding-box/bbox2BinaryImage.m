function bin = bbox2Binary(bbox,imsize)
%function bin = bbox2Binary(bbox,imsize)
%
% creates an image of all zeros, of size imsize.
% points inside the bounding box bbox will be ones.
% bbox is stored as [x, y, width, height]
z = zeros(imsize(1:2));
bbox = BBoxIntersect(bbox, [1, 1, imsize(2)-1, imsize(1)-1]);
z(bbox(2):(bbox(2)+bbox(4)),bbox(1):(bbox(1)+bbox(3))) = 1;
bin = logical(z);
