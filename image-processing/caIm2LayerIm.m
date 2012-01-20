function nlIm = caIm2LayerIm(caIm)
%function nlIm = caIm2LayerIm(caIm)
%
% converts a cell array of images into a single, multi-layer image
%
%resizes all images in the caIm to a common size, and stacks them in nlIm

ncells = length(caIm);
d = 0;
maxX = 0;
maxY = 0;
for i = 1:ncells
  maxX = max(maxX, size(caIm{i},2));
  maxY = max(maxY, size(caIm{i},1));
  d = d+size(caIm{i},3);
end
nlIm = zeros(maxY,maxX,d);
n = 0;
for i = 1:ncells
  subd = size(caIm{i},3);
  if( (maxY ~= size(caIm{i},1)) || (maxX ~= size(caIm{i},2)))
    nlIm(:,:,((n+1):(n+subd))) = imresize(caIm{i},[maxY, maxX],'bilinear');
  else
    nlIm(:,:,((n+1):(n+subd))) = caIm{i};
  end
  n = n+subd;
end
