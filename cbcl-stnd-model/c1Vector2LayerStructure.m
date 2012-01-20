function c1Layers = c1Vector2LayerStructure(c1Vector, c1SpaceSS, c1OL, imgy, imgx)
%function c1Layers = c1Vector2LayerStructure(c1Vector, c1SpaceSS, c1OL, imgy, imgx)
% OR function c1Layers = c1Vector2LayerStructure(c1Vector, options)
%
%
%Serre c1 output is a vector, convert to a cell array organized by band
%within each band represent as a 4 layer image, one layer for each orientation.
%
%Preset with the parameters used for the generation of the StreetScenes c1 features.

if(nargin < 2)
  c1SpaceSS = [8:2:22];
  c1OL = 2;
end
if(nargin < 5)
  %imgy = 960;
  %imgx = 1280;
  imgy = 480;
  imgx = 640;
end
if(nargin > 1)
  if(isstruct(c1SpaceSS))
    options = c1SpaceSS;
    d.c1SpaceSS = [8:2:22];
    d.c1OL = 2;
    d.imgy = 480;
    d.imgx = 640;
    options = ResolveMissingOptions(options,d);
    imgx = options.imgx;
    imgy = options.imgy;
    c1OL = options.c1OL;
    c1SpaceSS = options.c1SpaceSS;
    options;
  end
end

numPos   = ceil(imgy/c1SpaceSS(1))*ceil(imgx/c1SpaceSS(1))*c1OL*c1OL;
nBands = length(c1SpaceSS);
for b = 1:nBands
   maxX = ceil(imgy/ceil(c1SpaceSS(b)/c1OL));
   maxY = ceil(imgx/ceil(c1SpaceSS(b)/c1OL));
   for f = 1:4
       n = 4*(b-1)+f;
       c1Layers{b}(:,:,f) = reshape(c1Vector(numPos*(n-1)+1:numPos*(n-1)+maxX*maxY),maxX,maxY);
   end
end

