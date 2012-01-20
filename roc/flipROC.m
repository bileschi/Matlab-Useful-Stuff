function newROC = flipROC(ROC)
%function newROC = flipROC(ROC)
%
%the equivalent of doing exactly what the classifier tells you not to.
newROC = ROC;
newROC.tp = ROC.fp;
newROC.fp = ROC.tp;
newROC.tn = ROC.fn;
newROC.fn = ROC.tn;

 
if newROC.np
  newROC.recall = newROC.tp ./ newROC.np;
else
  newROC.recall = ones(n+1,1);
end

newROC.precision = [newROC.tp(1:(end-1)) ./ newROC.nr(1:end-1);1];

newROC.normfp = newROC.fp./newROC.nn;
newROC.normtp = newROC.tp./newROC.np;

newROC.auc = auc(newROC.normfp,newROC.normtp);
lowfpnodes = find(newROC.normfp < .1);
newROC.lowfpauc = auc(newROC.normfp(lowfpnodes),newROC.recall(lowfpnodes));

newROC.EqualErrorRate = ApproximateEqualErrorRate(newROC.normfp, newROC.normtp);


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
dLow = fp(iLow) - (1-tp(iLow));
dHi = fp(iHi) - (1-tp(iHi));
dSum = dLow + dHi;
E = (fp(iLow) * dHi + fp(iHi) * dLow) / (dSum);