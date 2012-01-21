function o = nLayerImage2MatrixOfPixels(i)
%function o = nLayerImage2MatrixOfPixels(i)
%
% input is a matrix i, size(i) == [N, M, D]
% output is a matrix o, size(o) = [N x M, D]
%
% each [N, M] layer of i is now a column of o 
s = size(i);
if(length(s) == 2)
  s3 = 1;
else
  s3 = s(3);
end
o = reshape(i,[s(1)*s(2),s3])';
