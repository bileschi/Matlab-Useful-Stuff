function outIm = BlueMask(mask,inIm,alpha,color);
%function outIm = BlueMask(mask,inIm,alpha,color);
%
%operates like BlueBox, but uses a mask the same size as inIm instead of a rectangle
%if mask is smaller than im, mask is padded with zeros on right and bottom
if(nargin < 4)
   color = [0 0 1];
end
if(nargin < 3)
   alpha = .5;
end
if(size(inIm,3) == 1)
   inIm = repmat(inIm,[1 1 3]);
end
if(isinteger(inIm))
   inIm = im2double(inIm);
end
if(size(mask,1) < size(inIm,1))
   mask = padimage(mask,[0,0,0,size(inIm,1) - size(mask,1)],0);
end
if(size(mask,2) < size(inIm,2))
   mask = padimage(mask,[0,0,size(inIm,2) - size(mask,2),0],0);
end
mask = alpha * mask;
mask = repmat(mask,[1 1 3]);
tempIm = inIm;
for iColorLayer = 1:3
   tempIm(:,:,iColorLayer) = color(iColorLayer);
end
outIm = (1-mask) .* inIm + (mask) .* tempIm;


