function im = FourLayerColor(fim,respaceFlag);
%function im = FourLayerColor(fim,respaceFlag);
%
%creates an image where each layer can be seen as a different color
%adding up to white, like rgb for 3 layers.
%
%the correct colors are found by dividing up the hue circle into 4 regions
%if respaceFlag is filled in with an empty matrix then the image is respaced from 0 to 1 first
%
%stan Dec 5 2007: feature, if respaceFlag < 0, rather than stretching the gain from 0
% the fixed point now becomes the median value

bRespace = 0;
if(nargin > 1)
  if(isempty(respaceFlag))
    bRespace = 1;
  else
    bRespace = respaceFlag;
  end
end

cl = class(fim);
fim = im2double(fim); 
s = size(fim);
nLays = size(fim,3);
% if(nLays == 1)
%  nLays = 3;
%  fim = repmat(fim,[1 1 3]);
% end
HueMtx = BuildHueMatrix(nLays);
im = zeros(size(fim,1), size(fim,2), 3);
Mat = nLayerImage2MatrixOfPixels(fim);
if(bRespace > 0)
  Mat = myNormalizeImage(Mat,bRespace);
end
if(bRespace < 0)
  Mat = myOtherNormalizeImage(Mat,bRespace);
end

Mat = Mat' * HueMtx;
im = reshape(Mat,[s(1),s(2),3]);
if(strcmpi(cl,'uint8'))
  im = im2uint8(im);
end

function HueMtx = BuildHueMatrix(n);
HueMtx = zeros(n,3);
for i = 1:n
   HueMtx(i,:) = permute(hsv2rgb((i-1)/n,1,1),[1,3,2]);
end
HueMtx = HueMtx ./ repmat(sum(HueMtx),[n,1]);

function Mat = myNormalizeImage(Mat,v)
m = min(min(Mat));
M = max(max(Mat));
s = M - m;
Mat = Mat - m;
Mat = (Mat / s) * v;

function Mat = myOtherNormalizeImage(Mat,v)
v = -v;
myMedian = median(Mat(:));
m = abs(min(Mat(:))-myMedian); %dist from neg peak to median
M = abs(max(Mat(:))-myMedian); %dist from pos peak to median
s = max(M,m);
Mat = Mat - myMedian;
Mat = (Mat / s) * v/2;  % now the extreme peak is at -.5 * v or pos .5 * v
Mat = Mat + .5;
