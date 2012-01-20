function [s2Target, source] = PROC_GetS2Centroids(c1Root, c1FileTemplate, TrainIdxs, scales, nPerScale);
%c1VarName in c1FileTemplate in c1Root has to be already in cell Layer format, not vector format.
for i = 1:length(scales);
  [s2Target{i}, source{i}] = SelectS2Centers(TrainIdxs, nPerScale, scales(i), c1Root, c1FileTemplate);
end

function [s2Target, source] = SelectS2Centers(TrainIndicies, NumPatch, PatchSize, c1Root, c1FileTemplate)
%function [s2Target, source] = SelectS2Centers(TrainIndicies, NumPatch, PatchSize, c1Root, c1FileTemplate)
%
%Extract s2 RBF centers from the training data in fullfile(c1Root,c1FileTemplate)
%.  Extract NumPatches of size PatchSize.

s2Target = zeros(PatchSize * PatchSize * 4, NumPatch);

for i_nPatches = 1:NumPatch
  if(mod(i_nPatches,5) == 1)
    fprintf('.');
  end
  %select a source idx
  idx = ceil(rand*length(TrainIndicies));
  idx = TrainIndicies(idx);
  sourceIdx(i_nPatches) = idx;
  filename = fullfile(c1Root, sprintf(c1FileTemplate, idx));
  load(filename);%-->, Exp
  bbox = SelectRandomBBox(size(Exp.c1structure{1}{1}), [PatchSize, PatchSize]);
  data = imcrop_pad(Exp.c1structure{1}{1},bbox);
  s2Target(:,i_nPatches) = data(:);
  source(i_nPatches).sourceIdx = idx;
  source(i_nPatches).bbox = bbox;
end
