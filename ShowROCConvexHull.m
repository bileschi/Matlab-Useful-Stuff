function NewROC = ShowROCConvexHull(RocStructure, extrastring, Color, LineWidth)
%function NewROC = ShowROC(RocStructure, extrastring, Color, LineWidth)
%
K = convhull([RocStructure.normfp; 1], [RocStructure.normtp; 0]);
sK = sort(K);
sK = sK(1:(end-1));
if(nargin == 1)
  plot(RocStructure.normfp(sK), RocStructure.normtp(sK));
end

if(nargin == 2)
  plot(RocStructure.normfp(sK), RocStructure.normtp(sK), extrastring);
end

if(nargin  == 3)
  plot(RocStructure.normfp(sK), RocStructure.normtp(sK), extrastring, 'Color', Color);
end

if(nargin  == 4)
  plot(RocStructure.normfp(sK), RocStructure.normtp(sK), extrastring, 'Color', Color, 'LineWidth',LineWidth);
end

NewROC = RocStructure;
eer1 = ApproximateEqualErrorRate(RocStructure.normfp(sK), RocStructure.normtp(sK));
% eer2 = ApproximateEqualErrorRate(RocStructure.normtp(sK), RocStructure.normfp(sK));
NewROC.EqualErrorRate_CONVHULL = eer1;% min(eer1,eer2);

function E = ApproximateEqualErrorRate(fp,tp);
%this is an approximation to the equal error rate, which must be calculated as an interpolated value
%between the points where the fp < tp, and where fp > tp, intersects the line tp = (1-fp);
toolow = find(fp < (1-tp));
toohigh = find(fp >= (1-tp));
if(max(toolow) < min(toohigh))
  iLow = max(toolow);
  iHi = min(toohigh);
else
  iHi = min(toolow);
  iLow = max(toohigh);
end
dLow = abs(fp(iLow) - (1-tp(iLow)));
dHi = abs(fp(iHi) - (1-tp(iHi)));
dSum = dLow + dHi;
E = (fp(iLow) * dHi + fp(iHi) * dLow) / (dSum);
