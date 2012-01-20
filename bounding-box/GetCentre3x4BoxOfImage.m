function [outimg,centerbbox,relativecenterbbox] = GetCentre3x4BoxOfImage(inimg);
%function outimg = GetCentre3x4BoxOfImage(inimg);
%
sz = size(inimg);
if((3*sz(1))==(4*sz(2)))
   outimg = inimg;
end
if((3*sz(1))>(4*sz(2)))
  %taller than long, width stays the same
  w = sz(2);
  h = (3/4)*sz(2);
  l = 1;
  t = floor((sz(1)-h)/2);
  centerbbox = [l, t, w-1, h-1]; 
else
  %longer than tall, height stays the same
  w = (4/3)*sz(1);
  h = sz(1);
  l = floor((sz(2)-w)/2);
  t = 1;
  centerbbox = [l, t, w-1, h-1]; 
end 
outimg = imcrop(inimg,centerbbox);
relativecenterbbox = bboxReal2Relative(centerbbox,size(inimg));