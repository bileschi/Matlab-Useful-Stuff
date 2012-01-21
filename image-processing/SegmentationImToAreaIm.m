function out = SegmentationImToAreaIm(in);
%function out = SegmentationImToAreaIm(in);
%
%input is an index image.  Output has each pixel assigned the number
%of pixels in its same index
u = unique(in);
for i = u';
  f = find(in == i);
  out(f) = length(f);
end
out = reshape(out,size(in));