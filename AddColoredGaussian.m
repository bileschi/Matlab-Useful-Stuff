function imout = AddColoredGaussian(imin,yx_pos,scale,color,strength);
%function imout = AddColoredGaussian(imin,yx_pos,scale,color,strength);
%
%Tints a gaussian region of the image 
%
if(nargin < 5), strength = 1;, end;
if(nargin < 4), color = [1 0 0];, end;
imin = im2double(imin);
if(size(imin,3) == 1)
  imin = cat(3,imin,imin,imin);
end
sz = [size(imin,1),size(imin,2)];
gausim = strength * GausImg(sz,yx_pos,scale);
gausim = cat(3,gausim,gausim,gausim);
colorim = cat(3,color(1)*ones(sz),color(2)*ones(sz),color(3)*ones(sz));
imout = imin .* (1-gausim) + colorim .* gausim;
 