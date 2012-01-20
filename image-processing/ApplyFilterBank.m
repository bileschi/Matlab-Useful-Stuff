function FiltIm = ApplyFilterBank(im,filters)
%function FiltIm = ApplyFilterBank(im,filters)
%
%assume im is a single layer image, and filters is a cell array

nFilt = length(filters);
maxsz = 0;
for i = 1:nFilt
  maxsz = max(maxsz,max(size(filters{i})));
end
FiltIm = zeros(size(im,1), size(im,2), nFilt);
im = padimage(im,maxsz,'symmetric');
for i = 1:nFilt
  FiltIm(:,:,i) = unpadimage(imfilter(im,filters{i}),maxsz);
end