function [ConfusionMat,keys,PercentCorrect] = GenerateConfusion(lab,y)
keys = unique(union(y,lab));
ConfusionMat = zeros(length(keys));
for i = 1:length(keys)
   key2idx(keys(i)) = i;
end
for j= 1:length(lab)
   ConfusionMat(key2idx(lab(j)),key2idx(y(j))) = ConfusionMat(key2idx(lab(j)),key2idx(y(j)))+1;
end
PercentCorrect = sum(diag(ConfusionMat))/sum(ConfusionMat(:));
%49.68 percent correct just using npoints and object sizes

