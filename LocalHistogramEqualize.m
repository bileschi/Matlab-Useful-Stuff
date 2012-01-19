function HisteqIm = LocalHistogramEqualize(img,yx_wind,grain,options);
%function HisteqIm = LocalHistogramEqualize(img,yx_wind,grain,options);
%
%each pixel is approximately histogram equalized within the yx_window neighborhood.
%d.FastApproximation = 1;

d.FastApproximation = 1;
if(nargin < 4), options = [];,end
options = ResolveMissingOptions(options,d);

if(length(unique(img(:))) == 1)
  % fprintf('LHEQ-- No variation in stimulus\n');
  HisteqIm = ones(size(img));
  return
end

img = im2double(img);
img = (img - min(img(:))) / (max(img(:)) - min(img(:)));
img = img * (grain-1);
img = ceil(img) + 1;
IdxImg = padimage(img,[floor(yx_wind),ceil(yx_wind)],'symmetric');

if(not(options.FastApproximation))
  MLI = zeros(size(IdxImg,1), size(IdxImg,2), grain);
  %nWindsY = size(IdxImg,1) - yx_wind(1) + 1;
  %nWindsX = size(IdxImg,2) - yx_wind(2) + 1;
  T = zeros(size(IdxImg,1), size(IdxImg,2), grain);
  sumrange = [floor((yx_wind(2)-1)/2),ceil((yx_wind(1)-1)/2),ceil((yx_wind(2)-1)/2),floor((yx_wind(1)-1)/2)];
  for i = 1:grain
    T(:,:,i) = (IdxImg == i);
    MLI(:,:,i) = sumfilter(T(:,:,i),sumrange);
  end
  MLI = unpadimage(MLI,[floor(yx_wind),ceil(yx_wind)]);
  %IdxImg = unpadimage(IdxImg,[floor(yx_wind),ceil(yx_wind)]);
  %Cum = (cumsum(MLI,3) - MLI/2)/ prod(yx_wind);
   Cum = (cumsum(MLI,3))/ prod(yx_wind);
  %HisteqIm = DepthSelect(Cum,IdxImg);
  HisteqIm = DepthSelect(Cum,img);
else
  sumrange = [floor((yx_wind(2)-1)/2),ceil((yx_wind(1)-1)/2),ceil((yx_wind(2)-1)/2),floor((yx_wind(1)-1)/2)];
  M = sumfilter(IdxImg,sumrange) / ((sumrange(1)+sumrange(3)+1)*(sumrange(2)+sumrange(4)+1));
  %M = sumfilter(IdxImg,floor(yx_wind(1)/2)) / prod(yx_wind);
  %S = stdfilter(IdxImg,floor(yx_wind(1)/2));
  H = (IdxImg - M);
  S = sumfilter(H.^2,sumrange)/((sumrange(1)+sumrange(3)+1)*(sumrange(2)+sumrange(4)+1));
  H = (H ./ S.^.5);
  H = im2double(H);
  HisteqIm = (H - min(H(:))) / (max(H(:)) - min(H(:)));
  HisteqIm = unpadimage(HisteqIm,[floor(yx_wind),ceil(yx_wind)]);
end
