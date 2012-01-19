function Img3D = ApplyCellArrayOfFilters(img,cfilters);
%function Img3D = ApplyCellArrayOfFilters(img,cfilters);
nFilts = size(cfilters,2);
Img3D = zeros(size(img,1), size(img,2),nFilts);
for i = 1:nFilts
  pimg = padimage(img,max(ceil(size(cfilters{i})/2)),'symmetric');
  pimg = abs(imfilter(pimg, cfilters{i}));
  Img3D(:,:,i) = unpadimage(pimg,max(ceil(size(cfilters{i})/2))); 
end  
   