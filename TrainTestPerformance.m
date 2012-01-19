function [yel,ye,ROC,Model] = TrainTestPerformance(sPos,sNeg, options,savename);
%%function [yel,ye,ROC,Model] = TrainTestPerformance(sPos,sNeg, options,savename);
%%
%%computes performance on the shape based object data.
%%will randomly pick features if there are over 8000 features!
%%
%%sPos and sNeg are structures with fields 'Root', 'Template', and 'variablename'
%%Template and Variable name may be cell arrays
%%each template entry may be a wild card, in which case multiple files will be loaded.
%% Providing a model is dangerous
%%  make sure you provide the same rand seed....

HelpTextInfo = 'TrainTestPerformance';

d.bRandsplit = 0; %0 means that we will take the first 2/3 for training
d.TrainingPart = 2/3;
d.sPARAMS.Nrounds = 200;
d.sPARAMS.R = 0;
d.sPARAMS.T = 0;
d.sPARAMS.C = 1;
d.sPARAMS.KERNEL = 0;
d.nMaxFeatures = 4500;
d.nMaxExamples = 4000;
d.ClassifierName = 'gentleBoost';
d.bNormalizeDataSamples = 1;
d.caNormalizationRegions = [];
d.NormalizationRelativeStrengths = [1];
d.bAbsVal = 0;
d.featuresubset = [];
d.bOverwrite = 1;
d.bAlternateDecimationScheme = 0;
d.bPCAReduceSize = 0;
d.sProvideModel = [];
seedrand;
d.RandSeed = floor(rand*99999);
options = ResolveMissingOptions(options,d);

if(not(options.bOverwrite))
  if(exist('savename'))
    if(exist(savename))
      fprintf('File exists, continuing\n');
      Model= [];, ye = [];, ROC = [];, yel = [];
      return;
    end
  end
end;
[PosX] = GetNewDataX(sPos.Template, sPos.variablename, sPos.Root,options);
[NegX] = GetNewDataX(sNeg.Template, sNeg.variablename, sNeg.Root,options);
NewDataX = [PosX,NegX];
clear sPosX sNegX
yfull = [ones(1,size(PosX,2)), -ones(1,size(NegX,2))];
if(size(NewDataX,1) > options.nMaxFeatures), 
  rand('state',options.RandSeed);
  p = randperm(size(NewDataX,1));
  NewDataX = NewDataX(p(1:options.nMaxFeatures),:);
  fprintf('TOO MANY FEATURES: Randomly sampling features');
end
L = length(yfull);
if(options.bRandsplit)
  nTrain = round(options.TrainingPart * L);
  nTest = L - nTrain;
  rand('state',options.RandSeed);
  p = randperm(L);
  Test = p(1:nTest);
  Train = p((nTest+1):end);
else
  Test = 1:(floor(L * (1-options.TrainingPart)));
  Train = (floor(L * (1-options.TrainingPart))+1):L;
end
DXtest = NewDataX(:,Test);
ytest = yfull(:,Test);
DXtrain = NewDataX(:,Train);
ytrain = yfull(:,Train);
[DXtrain, FeatureSubsample] = SubSampleFeatures(DXtrain, options);
[DXtrain,NormalizationParams] = InternalNormalize(DXtrain, options);
DXtest = SubSampleFeatures(DXtest, options, FeatureSubsample);
DXtest = InternalNormalize(DXtest,options,NormalizationParams);
if(options.bPCAReduceSize) 
   [U,S,V] = svd(DXtrain,0);
   DXtrain = U'*DXtrain;
   DXtest = U'*DXtest;
end
if(isempty(options.sProvideModel))
  cmd = sprintf('Model = CLS%s(DXtrain,ytrain'',options.sPARAMS);',options.ClassifierName);
  eval(cmd);
else
  Model = options.sProvideModel;
end
% [yel,ye] = CLSgentleBoostC(DXtest,Model);
if(length(DXtest) == 0)
  error('no data');
end
cmd = sprintf('[yel, ye] = CLS%sC(DXtest,Model);',options.ClassifierName);
eval(cmd)
ROC = ROCetcStan(ye' ,ytest);
if(exist('savename'))
  save(savename,'HelpTextInfo','yel','ye','ROC','sPos','sNeg','Model','options','ytest','FeatureSubsample','NormalizationParams');
end



function [NewDataX] = GetNewDataX(Template, variablename,Root,options)
NewDataX = [];
yfull = [];
if(not(iscell(Template)))
  subp = fileparts(Template);
  d = dir(fullfile(Root,Template));
  nExSoFar = 0;
  for iFl = 1:length(d);
    if(nExSoFar >=options.nMaxExamples)
      break;
    end
    D = load(fullfile(Root,subp,d(iFl).name));%-->eval(variablename);
    Part = getfield(D,variablename);
    nExThisPart = size(Part,2);
    nExToTake = min(size(Part,2), options.nMaxExamples - nExSoFar);
    if(isfield(options,'featuresubset'))
         if(not(isempty(options.featuresubset)))
  	   Part = Part(options.featuresubset,:);
	 end
    end
    nExSoFar = nExSoFar + nExToTake;
    NewDataX = [NewDataX,Part(:,1:nExToTake)];
  end
else
  % In order to save memory here, we are going to have to estimate the full
  % size of the matrix to load, and decimate as we build.
  sn = 1;
  for iGroup = 1:length(Template)
    d = dir(fullfile(Root,Template{iGroup}));
    sq = 1;
    SizeCheckStruct = whos('-file',fullfile(Root,d(1).name),variablename{iGroup});
    PartSizes(iGroup) = SizeCheckStruct.size(1);
    if(not(isempty(options.featuresubset{iGroup})))
      PartSizes(iGroup) = min(PartSizes(iGroup), length(options.featuresubset{iGroup}));
    end
  end
  nParts = length(Template);
  [newPartSizes,p,cap] = ComputeNewPartSizes(PartSizes,options.nMaxFeatures,options);
   %%%%%%%%%%%%%%%%%%%%%%%%%%BEFORE EDIT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  sn = 1;
  for iGroup = 1:length(Template)
    subp = fileparts(Template{iGroup});
    d = dir(fullfile(Root,Template{iGroup}));
    sq = 1;
    nExSoFar = 0;
    for iFl = 1:length(d);
      if(nExSoFar >=options.nMaxExamples)
        break;
      end
      D = load(fullfile(Root,subp,d(iFl).name));%-->eval(variablename);  
      Part = getfield(D,variablename{iGroup});
      nExThisPart = size(Part,2);
      nExToTake = min(size(Part,2), options.nMaxExamples - nExSoFar);
      if(isfield(options,'featuresubset'))
         if(not(isempty(options.featuresubset{iGroup})))
  	   Part = Part(options.featuresubset{iGroup},:);
	 end
      end
      Part = Part(cap{iGroup},:);
      [n,q] = size(Part);
      nExSoFar = nExSoFar + nExToTake;
      NewDataX(sn:(n+sn-1),sq:(sq+q-1)) = Part(:,1:nExToTake);
      sq = sq + q;
      if(iGroup == 1)
        load(fullfile(Root,subp,d(iFl).name),'y');%-->grayX,gradX,toyotaX,y; % this is wrong
        yfull = [yfull,y];
      end 
    end %loop over breaks in data on disk
    sn = size(NewDataX,1) + 1;
    PartSizes(iGroup) = size(Part,1);
  end %loop over data types
  %% (OLD VERSION, feature selection takes place after all are loaded.  bad for memory)
  % if(options.bAlternateDecimationScheme)
  %   NewDataX = NewDataX(p,:);
  % end
end


function [X,NormalizationParams] = InternalNormalize(X,options,NormalizationParams)
if(nargin < 3)
  NormalizationParams = [];
end
if(options.bNormalizeDataSamples > 0)
  if(isempty(options.caNormalizationRegions))
    caNR{1} = 1:size(X,1);
  else
    caNR = options.caNormalizationRegions;
  end
  [X,NormalizationParams] = normalizeByIndex(X, caNR, options.bNormalizeDataSamples,NormalizationParams,options);
end
     

function [XTrainFull, SelectedFeatures] = SubSampleFeatures(XTrainFull, options, SelectedFeatures);
if(nargin < 3)
  SelectedFeatures = 1:size(XTrainFull,1);
  if(size(XTrainFull,1) > options.nMaxFeatures), 
    seedrand(options.RandSeed);
    p = randperm(size(XTrainFull,1));
    XTrainFull = XTrainFull(p(1:options.nMaxFeatures),:);
    SelectedFeatures = p(1:options.nMaxFeatures);
    fprintf('TOO MANY FEATURES: Randomly sampling %d features\n', options.nMaxFeatures);
  end
else
  XTrainFull = XTrainFull(SelectedFeatures,:);
end  

function [newPartSizes,p,cap] = ComputeNewPartSizes(PartSizes,nMaxFeatures,options);
%if each part is larger than nMaxFeatures / length(PartSizes)
%make each part equally big. Otherwise take all parts wich are less than this limit,
%add the extra to the bin and recurse.
nParts = length(PartSizes);
newPartSizes = zeros(nParts,1);
bPartRepresented = zeros(nParts,1);
done = 0;
while(not(done))
  maxTake = floor(nMaxFeatures / sum(not(bPartRepresented)));
  v = intersect(find(PartSizes < maxTake), find(not(bPartRepresented)));
  newPartSizes(v) = PartSizes(v);
  nMaxFeatures = nMaxFeatures - sum(PartSizes(v));
  bPartRepresented(v) = 1;
  if(not(any(v)))
    v = find(not(bPartRepresented));
    newPartSizes(v) = maxTake;
    bPartRepresented(v) = 1;
  end
  if(all(bPartRepresented))
    done = 1;
  end
end  
s = [0,cumsum(PartSizes)];
p = [];
seedrand(options.RandSeed);
for i = 1:nParts
  p_i = randperm(PartSizes(i));
  p_i = p_i(1:newPartSizes(i));
  cap{i} = p_i;
  p = [p,s(i)+p_i];
end    


