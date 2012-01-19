function im = TwoLayerVectorColor(xim,yim,respaceFlag,confidence)
%function im = TwoLayerVectorColor(xim,yim,respaceFlag,confidence)
%
% hue corresponds to the orientation, 
% saturation corresponds to the magnitude
% value correpsonds to the optional confidence term

bRespace = 0;
if(nargin > 2)
  if(isempty(respaceFlag))
    bRespace = 1;
  else
    bRespace = respaceFlag;
  end
end
if(bRespace > 0)
  [xim,yim] = myNormalizeImage(xim,yim,bRespace);
end
if(bRespace < 0)
  [xim,yim] = myNormalizeImage2(xim,yim,bRespace);
end

ori = clamp(mod(atan2(xim,yim),2*pi) / (2*pi),[0 1]);
mag = clamp((xim.^2 + yim.^2).^.5,0,1);
if(nargin < 4)
   confidence = 1-.5*mag;
end
confidence = clamp(confidence,[0 1]);
hsv = cat(3,ori,mag,confidence);
im = hsv2rgb(hsv);


function [xim,yim] = myNormalizeImage(xim,yim,v)
mx = min(min(xim));
Mx = max(max(xim));
my = min(min(yim));
My = max(max(yim));
M = max([Mx,My,-mx,-my]);
xim = (xim / M) * v;
yim = (yim / M) * v;

function [xim,yim] = myNormalizeImage2(xim,yim,v)
xim = (xim) * -v;
yim = (yim) * -v;
