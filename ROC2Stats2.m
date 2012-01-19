function stats = ROC2Stats(ROC)

%stats contains the average and std of AUC,  EqualErrorRate, and the
%tp  performance at fp = .1, .01, .001, .0001, and .00001.
%empty cells are ok.

fplocs = .1 .^ (1:5);
nHasROC = 0;
totalAUC = [];
totalAUC10 = [];
totalAUC100 = [];
totalAUC1000 = [];
totalAUC10000 = [];
TPatFP10 = [];
TPatFP100 = [];
TPatFP1000 = [];
TPatFP10000 = [];
TPatFP100000 = [];
totalEER = [];
brokenEER = [];

for i = 1:length(fplocs)
  totalTP{i} = [];
end
ca{1}.ROC = ROC;
i = 1;
 
  nHasROC = nHasROC + 1;
  totalAUC(end+1) = ca{i}.ROC.auc;
  if(isfield(ca{i}.ROC,'auc10'))
    totalAUC10(end+1) = ca{i}.ROC.auc10;
    totalAUC100(end+1) = ca{i}.ROC.auc100;
    totalAUC1000(end+1) = ca{i}.ROC.auc1000;
    totalAUC10000(end+1) = ca{i}.ROC.auc10000;
  end
  if (ca{i}.ROC.EqualErrorRate >= 0) && (ca{i}.ROC.EqualErrorRate < .75)
    totalEER(end+1) = ca{i}.ROC.EqualErrorRate;
  else
    brokenEER = brokenEER + 1;
  end
  for j = 1:length(fplocs)
    totalTP{j}(end+1) = GetTPatFP(ca{i}.ROC, fplocs(j));
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
stats = m;
stats.TPatFP10 = m.TPatFP(1);
stats.TPatFP100 = m.TPatFP(2);
stats.TPatFP1000 = m.TPatFP(3);
stats.TPatFP10000 = m.TPatFP(4);
stats.TPatFP100000 = m.TPatFP(5);
stats = rmfield(stats, 'TPatFP');

function tp = GetTPatFP(ROC,fp)
fless = find(ROC.normfp < fp);
fmore = find(ROC.normfp >= fp);
if(isempty(fless))
  tp = fp;
else
  fpless = max(ROC.normfp(fless));
  fpmore = min(ROC.normfp(fmore));
  tpless = max(ROC.normtp(fless));
  tpmore = min(ROC.normtp(fmore));
  difflo = fp - fpless;
  diffhi = fpmore - fp;
  a = difflo / (difflo + diffhi);
  tp = (1-a)*tpless + a*tpmore;
end
