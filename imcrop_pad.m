function [out,needpad] = imcrop_pad(im,bbox,PADmethod)
%function [out,needpad] = imcrop_pad(im,bbox,PADmethod)
%
%imcrop will return a smaller crop when to return values outside the original image.  
%imcrop_pad will pad the original image if necessary.
%
DISP = 0;
wasuint8 = not(isfloat(im));
if(nargin < 3)
  PADmethod = 'replicate';
end
si = size(im);
TLPad = -(min(bbox(1:2)) - 1);
BRPad = max(bbox(1:2) + bbox(3:4) - si([2,1]));
needpad = max(TLPad,BRPad);
needpad = ceil(needpad);
if(needpad <= 0)
  out = im(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3),:);
else
  if DISP, fprintf('padding %d\n',needpad);, end
  im = padimage(im,needpad,PADmethod);
  if(wasuint8)
    im = im2uint8(im / 255.0);
  end
  bbox(1) = bbox(1) + needpad;
  bbox(2) = bbox(2) + needpad;
  out = im(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3),:);
end
  
