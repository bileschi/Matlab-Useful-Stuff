function outim = gimcrop(inim, bbox);
%function outim = gimcrop(inim, bbox);
%
%generalized image imcrop, works with an arbitrary number of channels per pixel
%bileschi 2005

nlevels = size(inim,3);
outim = zeros(bbox(4)+1, bbox(3)+1, nlevels);
for i = 1:nlevels
   outim(:,:,i) = imcrop(inim(:,:,i), bbox);
end