function z = BinIndexImage(img,bins);
%function z = BinIndexImage(img,bins);
%
%img is a grayscale image.
%bins is a vector
%z is an image of the same size as img, wherin the value of pixel i is
% equal to max(find(img(i) >= bins)) unless all(img(i) < bins), then z(i) will be 0

z = zeros(size(img,1), size(img,2));
n = 1;
for i = bins
  z(find(img>i)) = n;
  n = n+1;
end