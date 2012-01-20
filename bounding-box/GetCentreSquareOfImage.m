function outimg = GetCentreSquareOfImage(inimg);
%function outimg = GetCentreSquareOfImage(inimg);
%
sz = size(inimg);
if(sz(1)>sz(2))
  %taller than long
  w = sz(2);
  h = sz(2);
  l = 1;
  t = floor((sz(1)-h)/2);
  centerbbox = [l, t, w-1, h-1]; 
else
  %longer than tall
  %taller than long
  w = sz(1);
  h = sz(1);
  l = floor((sz(2)-w)/2);
  t = 1;
  centerbbox = [l, t, w-1, h-1]; 
end 
outimg = imcrop(inimg,centerbbox);
