function outIm = BlueBox(bbox,inIm,alpha,color);
%function outIm = BlueBox(bbox,inIm,alpha,color);
%
%draws a filled-in alpha-blended box on inIm at the position 
%specified by alpha (def .5) and of the hue 'color'
%(def [0 0 1])  Alpha == 1 signifies an opaque box
%
%Use with OrangeBox to get a nice outline.
%
%Because this function actually changes the pixel color (rather than drawing on top)
%it can not achieve sub-pixel accuracy.  For speed it draws the box on all pixels
%the box would intersect.
%
%out Im will be a color image even if inIm is a BW image.
%out Im will be a double image even if inIm is uint8
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
tempIm = inIm;
minx = max(1,floor(bbox(1)));
maxx = min(size(inIm,2),ceil(bbox(1) + bbox(3)));
miny = max(1,floor(bbox(2)));
maxy = min(size(inIm,1), ceil(bbox(2) + bbox(4)));
rangex = minx:maxx;
rangey = miny:maxy;
for iColorLayer = 1:3
   tempIm(miny:maxy,minx:maxx,iColorLayer) = color(iColorLayer);
end
outIm = (1-alpha) * inIm + (alpha) * tempIm;


