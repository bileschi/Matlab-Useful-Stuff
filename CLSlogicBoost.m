function Model = CLSlogicBoost(X,y,sPARAMS);
%function Model = CLSlogicBoost(X,y,sPARAMS);

MAX_ATOMIC_FEATURES = 50;  
[X,normXweights] = outnormalizeDataX(X);
sPARAMS1 = sPARAMS;
NDEPTH = 5;
sPARAMS1.Nrounds = MAX_ATOMIC_FEATURES / NDEPTH;
% sPARAMS1.Nrounds = 5;
bIMdone = 0;
AtomicFeats = 1:size(X,1);
if(length(AtomicFeats) > MAX_ATOMIC_FEATURES)
  AtomicFeats = GetFirstAtomicFeats(MAX_ATOMIC_FEATURES,X,y,sPARAMS);
end
for i = 1:length(AtomicFeats)
  saPrevFR(i).bIsAtomic = 1; % atomic
  saPrevFR(i).AtomRef = i;
  saPrevFR(i).LogicRef(1) = NaN;
  saPrevFR(i).LogicRef(2) = NaN;
  saPrevFR(i).bUseAnd = NaN;    
end
% while(not(bIMdone))
for iter = 1:NDEPTH
   fprintf('Make Logic\n');
   saNextFR = BuildNextFR(saPrevFR);
   fprintf('Build Matrix\n');
   MyX = BuildFeaturesFromRecipie(saNextFR,X);
   fprintf('Train\n');
   InterModel = CLSgentleBoost(MyX,y(:),sPARAMS1);
   fprintf('Remove\n');
   [saPrevFR] = RemoveUnusedFeatures(InterModel,saNextFR);
   fprintf('AddRand\n');
   [saPrevFR] = AddRandomAtoms(saPrevFR,size(X,1),MAX_ATOMIC_FEATURES);
end
% saPrevFR = saPrevFR(find(not(sFieldToArr(saPrevFR,'bIsAtomic'))));
% saPrevFR = saPrevFR(find(not(saPrevFR.bIsAtomic)));
MyX = BuildFeaturesFromRecipie(saNextFR,X);
X = [X;MyX];
Model = CLSgentleBoost(X,y(:),sPARAMS);
Model.normXweights = normXweights;
Model.saFeatureRecipie = saNextFR;

function  [saPrevFR] = AddRandomAtoms(saPrevFR,nAtoms,MAX_ATOMIC_FEATURES);
% pick some randome unique atoms to add to the feature list
nToAdd = MAX_ATOMIC_FEATURES - length(saPrevFR);
atomswehave = [];
for i = 1:length(saPrevFR)
  if(saPrevFR(i).bIsAtomic)
    atomswehave(end+1) = saPrevFR(i).AtomRef;
  end
end
atomswehave = unique(atomswehave);
nToAdd = min(nAtoms - length(atomswehave),nToAdd);
takefrom = setdiff(1:nAtoms,atomswehave);
p = randperm(length(takefrom));
p = p(1:nToAdd);
N = length(saPrevFR);
for i = 1:nToAdd
  n = N + i;
  saPrevFR(n).bIsAtomic = 1;
  saPrevFR(n).AtomRef = takefrom(p(i));
  saPrevFR(n).LogicRef(1) = NaN;
  saPrevFR(n).LogicRef(2) = NaN;
  saPrevFR(n).bUseAnd = NaN;    
end


function [saPrevFR,bIMdone] = RemoveUnusedFeatures(Model,saFR);
% we keep all the features that were selected by the model, and all those features
% that those features depended on.  All else are removed.
fKeep = unique(Model.featuresused);
bAddedSome = 1;
while(bAddedSome)
  bAddedSome = 0;
  for i = fKeep(:)'
    if(saFR(i).bIsAtomic), continue, end;
    ia = saFR(i).LogicRef(1);
    ib = saFR(i).LogicRef(2);
    if(not(ismember(ia,fKeep)))
      fKeep(end+1) = ia;
      bAddedSome = 1;
    end
    if(not(ismember(ib,fKeep)))
      fKeep(end+1) = ib;
      bAddedSome = 1;
    end
  end    
end
fKeep = sort(fKeep);
NewToOld = zeros(length(saFR),1);
NewToOld(fKeep) = 1;
NewToOld = cumsum(NewToOld);
saPrevFR = saFR(fKeep);
for i = 1:length(saPrevFR)
  if(not(saPrevFR(i).bIsAtomic))
    saPrevFR(i).LogicRef(1) = NewToOld(saPrevFR(i).LogicRef(1));
    saPrevFR(i).LogicRef(2) = NewToOld(saPrevFR(i).LogicRef(2));
  end
end  

function saNextFR = BuildNextFR(saPrevFR)
%NextFR includes PrevFR and all pair combinations of PrevFR
nA = length(saPrevFR);
saNextFR(1:nA) = saPrevFR;
nCombinations = nA*(nA-1)/2;
saNextFR((nA+1):(nA+1+nCombinations)) = saNextFR(1); % Force Mem Alloc.
n = nA;
for i = 1:nA
  for j = (i+1):nA
    NextItem.bIsAtomic = 0; % Logical
    NextItem.AtomRef = NaN;
    NextItem.LogicRef(1) = i;
    NextItem.LogicRef(2) = j;
    NextItem.bUseAnd = 1; % AND
    n = n+1;
    saNextFR(n) = NextItem;
    Nextitim.bUseAnd = 0; % OR
    n = n+1;
    saNextFR(n) = NextItem;
  end
end

function  MyX = BuildFeaturesFromRecipie(saNextFR,X);
bFeatFilled = zeros(length(saNextFR),1);
MyX = NaN(length(saNextFR), size(X,2));
while(not(all(bFeatFilled)))
  for i = 1:length(saNextFR)
    if(bFeatFilled(i)), continue, end
    if(saNextFR(i).bIsAtomic)
      MyX(i,:) = X(saNextFR(i).AtomRef,:);
      bFeatFilled(i) = 1;
      continue;
    end
    ia = saNextFR(i).LogicRef(1);
    ib = saNextFR(i).LogicRef(2);
    if(all(bFeatFilled([ia,ib])))
      if(saNextFR(i).bUseAnd)
        MyX(i,:) = min(MyX(ia,:),MyX(ib,:));
      else
        MyX(i,:) = max(MyX(ia,:),MyX(ib,:));
      end
      bFeatFilled(i) = 1;
    else
      continue;
    end
  end
end
   



function AtomicFeats = GetFirstAtomicFeats(MAX_LOGICAL_FEATURES,X,y,sPARAMS);
Model1 = CLSgentleBoost(X,y,sPARAMS);
AtomicFeats = unique(Model1.featuresused);
