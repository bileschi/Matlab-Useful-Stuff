function CascadeStats = BuildDetectorCascade(yemp1, yemp2,ytrue,FractionPass)
%function CascadeStats = BuildDetectorCascade(yemp1, yemp2,ytrue,FractionPass)
%
%the first FractionPass of the yvalues of yemp1 are automatically rejected, those that pass
%are classified as yemp2.  Since osusvmC doesn't necessarily coorelate positively with ytrue,
%both yemp1 and yemp2 are 'rectified' so that the larger values are more likely to be associated with
% the true values 1.

cov1 = cov(yemp1,ytrue);
cov2 = cov(yemp2,ytrue);
if(cov1(1,2) < 0)
  yemp1 = -yemp1;
end
if(cov2(1,2) < 0)
  yemp2 = -yemp2;
end
[s,si] = sort(yemp1);
l = length(yemp1);
nrej = ceil(FractionPass * l);
yemp2(si(1:nrej)) = -inf;
CascadeStats = ROCetc2(yemp2,ytrue);
