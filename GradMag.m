function gm = GradMag(im);
%function gm = GradMag(im);
%
im = padimage(im,2,'replicate');
dy = im(1:(end-2),2:(end-1)) - im(3:end,2:(end-1));
dx = im(2:(end-1),1:(end-2)) - im(2:(end-1),3:end);
gm = (dy.*dy + dx.*dx).^.5;


