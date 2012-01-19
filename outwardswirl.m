function [im2,thim] = outwardswirl(im,radrotate,diammult);
if (nargin < 3)
  diammult = 1/20;
end
if (nargin < 2)
  radrotate = pi/4;
end
sz = size(im);
cx = sz(2)/2;
cy = sz(1)/2;
im2 = zeros(size(im));
thim = zeros(size(im));
for iy = 1:sz(1);
  for ix = 1:sz(2);
    xa = ix + cx - sz(2);
    ya = iy + cy - sz(1);
    r = sqrt(xa*xa+ya*ya);
    th = atan2(ya,xa);
    thim(iy,ix) = th;
    xb = sz(2)*diammult*cos(th+radrotate);
    yb = sz(1)*diammult*sin(th+radrotate);
    xc = min(sz(2),max(1,round(xa+xb)+cx));
    yc = min(sz(1),max(1,round(ya+yb)+cy));    
    im2(yc,xc) = im(iy,ix);
  end
end
