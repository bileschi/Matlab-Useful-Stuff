function [X,ExtractionInfo] = GetCropsFromImage(img, cropsize, NCrops,options);
%function [X,ExtractionInfo] = GetCropsFromImage(img, cropsize, NCrops,options);
%
%collect crops from the image pyramid

D.ScaleRatio = 1.2;
D.MaxNScales = 16;
if(nargin < 4), options = [];, end
options = ResolveMissingOptions(options,D);

cImgPyr{1} = img;
i = 1;
while ((i < options.MaxNScales)  &&  (all(size(cImgPyr{i}) > cropsize)));
  sz = size(cImgPyr{i});
  sz = floor(sz / options.ScaleRatio);
  if(any(sz < cropsize)), break;, end
  cImgPyr{i+1} = imresize(cImgPyr{i},sz);
  i = i+1;
end
nLevs = length(cImgPyr);
X = zeros(prod(cropsize),NCrops);
for i = 1:NCrops
  iScale = ceil(rand*nLevs);
  Scale = options.ScaleRatio ^ (iScale-1);
  bbox = SelectRandomBBox(size(cImgPyr{iScale}), cropsize);
  ExtractionInfo(i).scale = Scale;
  ExtractionInfo(i).scaleIdx = iScale;
  ExtractionInfo(i).bbox = bbox;
  ExtractionInfo(i).bboxOrig = resize_bbox(bbox, size(cImgPyr{iScale}), size(img));
  crop = imcrop(cImgPyr{iScale},bbox);
  X(:,i) = crop(:);
end
