function imout = RegionFill_Nearest(im, mask)
% Given input image and mask.  For each selected pixel in mask, replace corresponding
% pixel in image with nearest unmarked pixel value.
%
% A simple, but poor image infilling tool
%
% im = imread('peppers.png');
% mask = zeros([size(im,1),size(im,2)]);
% im(200:250, 250:300, :) = 0
% mask(200:250, 250:300) = 1;
% figure(1), clf, imshow(im);
% figure(2), clf, imshow(RegionFill_Nearest(im, mask));
imout = im;
im(find(mask)) = -inf;
Umask = mask;
for iLayer = 1:size(im,3)
   imThisLayer = im(:,:,iLayer);
   imOutThisLayer = imThisLayer;
   mask = Umask;
   n = 0;
   while(any(mask(:)))
      EMask = imerode(mask,[0,1,0;1,1,1;0,1,0]);
      borderOfMask = mask - EMask;
      imThisLayer = imdilate(imThisLayer,[0,1,0;1,1,1;0,1,0]);
      f = find(borderOfMask);
      imOutThisLayer(f) = imThisLayer(f);
      fprintf('cycle %d\r',n);
      n = n+1;
      mask = EMask;
   end
   imout(:,:,iLayer) = imOutThisLayer;
end