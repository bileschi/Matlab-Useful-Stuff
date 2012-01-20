function z = BinIndexImage(img,bins);
%function z = BinIndexImage(img,bins);
%
%img is a grayscale image.
%bins is a vector
%z is an image of the same size as img, wherin the value of pixel i is
% equal to max(find(img(i) >= bins)) unless all(img(i) < bins), then z(i) will be 0
%
% >> img = reshape(1:16,[4,4])
%
% img =
%
%      1     5     9    13
%      2     6    10    14
%      3     7    11    15
%      4     8    12    16
%
% >> BinIndexImage(img, [1,2,4,8])
%
% ans =
%
%      0     3     4     4
%      1     3     4     4
%      2     3     4     4
%      2     3     4     4
z = zeros(size(img,1), size(img,2));
n = 1;
for i = bins
  z(find(img>i)) = n;
  n = n+1;
end