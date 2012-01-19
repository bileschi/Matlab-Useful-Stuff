function imout= ImageMosaic(caIn,options)
%function imout= ImageMosaic(caIn,options)
%
d.Resolution_SubImg = [240,320];
d.QuadFirstImage = 1;
d.NPerRow = 4;
if(nargin < 2)
   options = [];
end
options = ResolveMissingOptions(options,d);

nIn = length(caIn);
gridSize = [options.NPerRow,ceil(nIn/options.NPerRow)];
imout = zeros(gridSize(1)*options.Resolution_SubImg(1), gridSize(2)*options.Resolution_SubImg(2), 3);

imgIdx = 0;
for iRow = 1:gridSize(2)
   myy = (1:options.Resolution_SubImg(1)) + options.Resolution_SubImg(2) * (iRow-1);
   for iCol = 1:gridSize(1),
      myx = (1:options.Resolution_SubImg(2)) + options.Resolution_SubImg(1) * (iCol-1);
      imgIdx = imgIdx + 1;
      imout(myy,myx,:) = imresize(caIn{imgIdx},options.Resolution_SubImg,'bilinear');
      if(imgIdx == nIn)
         return;
      end
   end
end
