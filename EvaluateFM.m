function [TopChoices,PartInTopNGuesses] =  EvaluateFM(FM, CorrectValues)
%function [TopChoices,PartInTopNGuesses] =  EvaluateFM(FM, CorrectValues)
%
% given FM the output of the one vs all classifier, and the correct return values on the dat
% which defaults to 1:length(FM)
% return the ordering of the classified indices, per example, and percentile correct, given
% lee-way into the top N choices
%
% FM is [nSamples x nClassifiers];

nSamples = size(FM,1);
nClassifiers = size(FM,2);
if(nargin < 2)
  CorrectValues = 1:nSamples;
end
TopChoices = zeros(size(FM));
PartInTopNGuesses = zeros(nClassifiers);
[SortedVals,TopChoices] = sort(FM,2,'descend');
CorrectChoices = repmat(CorrectValues(:),[1,nClassifiers]);
IsCorrectChoice = (CorrectChoices == TopChoices);
S1 = sum(IsCorrectChoice,1);
PartInTopNGuesses = cumsum(S1) / nClassifiers;
PartInTopNGuesses = PartInTopNGuesses(:);