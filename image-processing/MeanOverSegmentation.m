function [ImOut,VecOut] = MeanOverSegmentation(ImIn,IdxSeg)
%function ImOut = MeanOverSegmentation(ImIn,IdxSeg)
%
%returns a new image similar to ImIn where val(pxi) =
%mean(ImIn(find(IdxSeg == val(px))))
%
%for now ImIn, ImOut can only be single layer.


u = unique(IdxSeg);
l = length(u);
ImOut = ImIn;
for i = 1:l
  s = find(IdxSeg == u(i));
  m = mean(ImIn(s));
  ImOut(s) = m;
  VecOut(i) = m;
end
