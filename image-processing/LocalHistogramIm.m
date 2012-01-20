function MLI = LocalHistogramIm(IdxImg,binvals,yx_wind);
%function MLI = LocalHistogramIm(IdxImg,binvals,yx_wind);
%
%returns an image the same size as IdxImg where each pixel now has as many layers as layers in binvals
%and each bin (i) contains the count of the pixels in a window (of size yx_wind) around the current location 
%whos value equals that of binvals(i).
%
%IdxImg should be one layer.
%

IdxImg = padimage(IdxImg,[floor(yx_wind),ceil(yx_wind)],'symmetric');
MLI = zeros(size(IdxImg,1), size(IdxImg,2), length(binvals));
%for i = 1:length(binvals)
%  T = (IdxImg == binvals(i));
%  MLI(:,:,i) = colfilt(T,[yx_wind],'sliding',@sum);
%end

nWindsY = size(IdxImg,1) - yx_wind(1) + 1;
nWindsX = size(IdxImg,2) - yx_wind(2) + 1;
T = zeros(size(IdxImg,1), size(IdxImg,2), length(binvals));
for i = 1:length(binvals)
  T(:,:,i) = (IdxImg == binvals(i));
  MLI(:,:,i) = sumfilter(T(:,:,i),[floor(yx_wind),ceil(yx_wind)]);
end
MLI = unpadimage(MLI,[floor(yx_wind),ceil(yx_wind)]);
