function [TTS,PIndexTrain,PIndexTest] = MakeTTS(nExmpl,nTrain,nTrainParts, nTestParts);
%function [TTS,PIndexTrain,PIndexTest] = MakeTTS(nExmpl,nTrain,nTrainParts, nTestParts);
%
%nExmpl is the total number of examples
%nTrain is the number of examples to reserve for training.
%
% below are optional
%
%nTrain parts is the number of fractions to divide the training
%nTestParts is the analoge of nTrainParts

if(nargin < 3)
  nTrainParts = 1;
end
if(nargin < 4)
  nTestParts = 1;
end
nTest = nExmpl-nTrain;
HowManyInTrainPart = SplitInteger(nTrain,nTrainParts);
HowManyInTestPart = SplitInteger(nTest,nTestParts);
rand('state',sum(100*clock));
p = randperm(nExmpl);
PIndexTrain = [0;cumsum(HowManyInTrainPart)];
PIndexTest = [(PIndexTrain(end));cumsum(HowManyInTestPart) + nTrain];

for i = 1:nTrainParts
  TTS(i).Train = sort(p((PIndexTrain(i)+1):PIndexTrain(i+1)));
end
for i = 1:nTestParts
  TTS(i).Test = sort(p((PIndexTest(i)+1):PIndexTest(i+1)));
end

function o = SplitInteger(length,parts);
smallpart = floor(length/parts);
bigpart = ceil(length/parts);
o = repmat(smallpart,[parts,1]);
if(bigpart == smallpart)
  return
end
z = mod(length,parts);
o(1:z) = bigpart;
