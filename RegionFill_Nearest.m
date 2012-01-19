function imout = RegionFill_Nearest(im, mask)
% Given input image and mask.  For each selected pixel in mask, replace corresponding
% pixel in image with nearest unmarked pixel value.
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