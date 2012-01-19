function o = nLayerImage2MatrixOfPixels(i)
%function o = nLayerImage2MatrixOfPixels(i)
s = size(i);
if(length(s) == 2)
  s3 = 1;
else
  s3 = s(3);
end
o = reshape(i,[s(1)*s(2),s3])';
