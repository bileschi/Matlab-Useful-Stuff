function myEER = EER_ApproximateFromROC(ROC)
%function myEER = EER_ApproximateFromROC(ROC)
%
% this is just a copy of the ROCetc2 approximate EER code, but there was a mistake before.  It has been fixed in the
% new ROC code, but if you have an old ROC, here is how to use it to correctly compute ROC.

fp = ROC.normfp;
tp = ROC.normtp;
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
myEER = (fp(iLow) * dHi + fp(iHi) * dLow) / (dSum);
