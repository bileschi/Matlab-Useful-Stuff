function X = Windowing_ImageStripToMatrix(Im,yxBoxSize,RowIndex);
%function X = Windowing_ImageStripToMatrix(Im,yxBoxSize,RowIndex);
%
%For use in a windowing procedure, returns a matrix such that each column represents
%a box of size (yxBoxSize(2),yxBoxSize(1),size(Im,3)) within the image.
%the strip is taken starting at RowIndex.
%
%if the Strip as defined would exit the image, [] is returned instead.  
%  (i.e. if RowIndex + yxBoxSize - 1 > size(Im,1))
%

if((RowIndex < 1) | (RowIndex + yxBoxSize(1) - 1 > size(Im,1)))
  fprintf('Windowing_ImageStripToMatrix: BadRowIndex\n')
  X = [];
  return;
end
nfeatsperlayer = prod(yxBoxSize);
nfeats = prod(yxBoxSize) * size(Im,3);
nsamps = size(Im,2) - yxBoxSize(2) + 1;
X = zeros(nfeats,nsamps);
StripIm = Im(RowIndex:(RowIndex+yxBoxSize(1)-1),:,:);
for d = 1:size(Im,3);
   ThisLayerRange = ((d-1)*nfeatsperlayer+1):((d)*nfeatsperlayer);
   X(ThisLayerRange,:) = im2col(StripIm(:,:,d),yxBoxSize,'sliding');
end