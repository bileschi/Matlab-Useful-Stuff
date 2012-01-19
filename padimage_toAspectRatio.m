function im = padimage_toAspectRatio(i,ratio,method)
%function im = padimage_toAspectRatio(i,ratio,method)
%
%calls pad image to pad an amount to make image i approximately ratio in aspect
% where aspect ratio is defined as height / width

sz = size(i);
sz2 = sz;
ar1 = sz(1) / sz(2);
ar2 = ratio;
i= im2double(i);
if ar2 > ar1 % image too wide, make taller (x1 == x2); 
   sz2(1) = ar2 * sz2(2);
   hdiff = round((sz2(1)-sz(1))/2);
   im = padimage(i,[hdiff,0],method);
   return
end
if ar2 < ar1 % image too tall , make wider (y1 == y2)
   sz2(2) = (ar2)^-1 * sz2(1);
   hdiff = round((sz2(2) - sz(2))/2);
   im = padimage(i,[0,hdiff],method);
   return
end
im = i;

