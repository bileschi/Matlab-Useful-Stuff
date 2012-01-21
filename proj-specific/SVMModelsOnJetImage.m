function [outLabel, outWeight] =  SVMModelsOnJetImage(jetim, SVMmodels, Normalization)
%function [outLabel, outWeight] =  SVMModelsOnJetImage(jetim, SVMmodels,Normalization)
%
%models may be either a model or a cell array of models
%the output has as many layers as there are classifiers
%all classifiers must be of the same dimensions, and that dimension must be that of the jet image

nJetLayers = size(jetim,3);
Normalize = 1;
if(nargin < 3)
  Normalize = 0;
end
if(not(iscell(SVMmodels)))
   M{1} = SVMmodels;
   if(Normalize)
      N{1} = Normalization;
   end
else
   M = SVMmodels;
   if(Normalize)
       N = Normalization;
   end
end
nModels = size(M,2);
JetSize = size(jetim);
outLabel = zeros(JetSize(1), JetSize(2), nModels);
outWeight = outLabel;
%check that all models match the jetdepth;
for modelidx = 1:nModels
   thisDepth = size(M{modelidx}.SVs,1);
   if(thisDepth ~= nJetLayers)
      error('Model %d does not have %d features\n', modelidx, nJetLayers);      
   end
end
X = reshape(jetim, [JetSize(1) * JetSize(2), JetSize(3)]);
X = X';
for modelidx = 1:nModels
  if(Normalize)
    nX = Normalaize_Mtx_Apply(X,N{modelidx});
  else
    nX = X;
  end
  [l,w] = CLSosusvmC(X,M{modelidx});
  outLabel(:,:,modelidx) = reshape(l,JetSize(1:2));
  outWeight(:,:,modelidx) = reshape(w,JetSize(1:2));
end  