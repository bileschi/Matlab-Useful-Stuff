%demoRelease.m
%demonstrates how to use C2 standard model features in a pattern classification framework

warning off
addpath ~/scratch2/osusvm/ %put your own path to osusvm here
warning on

useSVM = 1; %if you do not have osusvm installed you can turn this
            %to 0, so that the classifier would be a NN classifier
	    %note: NN is not a great classifier for these features
	    
READPATCHESFROMFILE = 1; %use patches that were already computed
                         %(e.g., from natural images)

patchSizes = [4 8 12 16]; %other sizes might be better, maybe not
                          %all sizes are required
			  
numPatchSizes = length(patchSizes);

%specify directories for training and testing images
Root = '/cbcl/scratch03/serre/sigala/perona';
train_set.pos   = fullfile(Root, 'Image_Datasets/airTr');
train_set.neg   = fullfile(Root, 'Image_Datasets/bckgTr');
test_set.pos    = fullfile(Root, 'Image_Datasets/airTe');
test_set.neg    = fullfile(Root, 'Image_Datasets/bckgTe');

cI = readAllImages(train_set,test_set); %cI is a cell containing
                                        %all training and testing images
cI
disp('hi');
pause;
%below the c1 prototypes are extracted from the images/ read from file
if ~READPATCHESFROMFILE
  tic
  numPatchesPerSize = 250; %more will give better results, but will
                           %take more time to compute
  cPatches = extractRandC1Patches([cI{1};cI{2}], numPatchSizes, numPatchesPerSize, patchSizes);
  totaltimespectextractingPatches = toc;
else
  fprintf('reading patches');
  cPatches = load('PatchesFromNaturalImages250per4sizes','cPatches');
  cPatches = cPatches.cPatches;
end

%----Settings for Testing --------%
rot = [90 -45 0 45];
c1ScaleSS = [1:2:18];
RF_siz    = [7:2:39];
c1SpaceSS = [8:2:22];
div = [4:-.05:3.2];
Div       = div;
%--- END Settings for Testing --------%

fprintf(1,'Initializing gabor filters -- full set...');
%creates the gabor filters use to extract the S1 layer
[fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, Div);
fprintf(1,'done\n');

%The actual C2 features are computed below for each one of the training/testing directories
tic
for i = 1:4,
  C2res{i} = extractC2forcell(filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches,cI{i},numPatchSizes);
  toc
end
totaltimespectextractingC2 = toc;

%Simple classification code
XTrain = [C2res{1} C2res{2}]; %training examples as columns 
XTest =  [C2res{3},C2res{4}]; %the labels of the training set
ytrain = [ones(size(C2res{1},2),1);-ones(size(C2res{2},2),1)];%testing examples as columns
ytest = [ones(size(C2res{3},2),1);-ones(size(C2res{4},2),1)]; %the true labels of the test set
if useSVM
  Model = CLSosusvm(XTrain,ytrain);  %training
  [ry,rw] = CLSosusvmC(XTest,Model); %predicting new labels
else %use a Nearest Neighbor classifier
  Model = CLSnn(XTrain, ytrain); %training
  [ry,rw] = CLSnnC(XTest,Model); %predicting new labels
end  
successrate = mean(ytest==ry) %a simple classification score


