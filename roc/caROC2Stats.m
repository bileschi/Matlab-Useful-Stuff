function [m,v] = caROC2Stats(ca);
%function [m,v] = caROC2Stats(ca);
%
%ca is a cell array of ROC curves
%m and v are structures containing the average and std of AUC,  EqualErrorRate, and the
%tp  performance at fp = .1, .01, .001, .0001, and .00001.
%empty cells are ok.

if(isempty(ca))
  m = EmptyROCStruct;
  v = EmptyROCStruct;
  return;
end

fplocs = .1 .^ (1:5);

ncells = length(ca);
nHasROC = 0;
totalAUC = [];
totalAUC10 = [];
totalAUC100 = [];
totalAUC1000 = [];
totalAUC10000 = [];
totalEER = [];
brokenEER = [];
for i = 1:length(fplocs)
  totalTP{i} = [];
end

for i = 1:ncells
  if(isempty(ca{i}))
    continue;
  end
  nHasROC = nHasROC + 1;
  totalAUC(end+1) = ca{i}.ROC.auc;
  if(isfield(ca{i}.ROC,'auc10'))
    totalAUC10(end+1) = ca{i}.ROC.auc10;
    totalAUC100(end+1) = ca{i}.ROC.auc100;
    totalAUC1000(end+1) = ca{i}.ROC.auc1000;
    totalAUC10000(end+1) = ca{i}.ROC.auc10000;
  end
  if (ca{i}.ROC.EqualErrorRate >= 0) && (ca{i}.ROC.EqualErrorRate <= 1)
    totalEER(end+1) = ca{i}.ROC.EqualErrorRate;
  else
    brokenEER = brokenEER + 1;
  end
  for j = 1:length(fplocs)
    totalTP{j}(end+1) = GetTPatFP(ca{i}.ROC, fplocs(j));
  end     
end
m.AUC = mean(totalAUC);
v.AUC = var(totalAUC);
if(isfield(ca{i}.ROC,'auc10'))
  m.AUC10 = mean(totalAUC10); 
  v.AUC10 = var(totalAUC10);
  m.AUC100 = mean(totalAUC100);
  v.AUC100 = var(totalAUC100);
  m.AUC1000 = mean(totalAUC1000);
  v.AUC1000 = var(totalAUC1000);
  m.AUC10000 = mean(totalAUC10000);
  v.AUC10000 = var(totalAUC10000);
end
m.EER = mean(totalEER);
v.EER = var(totalEER);
for j = 1:length(fplocs)
  m.TPatFP(j) = mean(totalTP{j});
  v.TPatFP(j) = var(totalTP{j});
end

function tp = GetTPatFP(ROC,fp)
f = find(ROC.normfp < fp);
if(isempty(f))
  tp = fp;
else
  tp = max(ROC.normtp(f));
end

function s = EmptyROCStruct
s.AUC = NaN;
s.AUC10 = NaN;
s.AUC100 = NaN;
s.AUC1000 = NaN;
s.AUC10000 = NaN;
s.EER = NaN;
s.TPatFP = [NaN,NaN,NaN,NaN,NaN];