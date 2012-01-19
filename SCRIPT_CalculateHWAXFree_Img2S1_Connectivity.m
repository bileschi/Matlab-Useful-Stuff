%SCRIPT_CalculateHWAXFree_Img2S1_Connectivity
%
%Using the image database from streetscenes and LabelMe 13 scales, each resized to 32x32
%

%Step1 write down the matrix to use to calculate the connectivity
% (we will use negative ped images for this) (there are 2000 such images we will use just 1000)

clear all
ScalesToUse = [1,3,4,6,7,9,10,12]
SourceRoot = '/cbcl/scratch01/bileschi/HWAX_Free/Extractions/Imgs/';
SaveRoot =   '/cbcl/scratch01/bileschi/HWAX_Free/Extractions/HWAXFree';
NegObjNames = {'NonCar','NonPed','NonMon','NonPlate'};
ImgWildCard = 'negImg_%.6d_scalRat%.2d.bmp';
for iObj = 1:4;
   objName = NegObjNames{iObj};
   ImageRoot = fullfile(SourceRoot,objName);
   SaveName = fullfile(SaveRoot,sprintf('GlanceMat_Neg_%s.mat',objName));
   X = [];
   nTargets = 1000;
   for iSet = 1:nTargets
      tempFeat = [];
      for iScale = ScalesToUse
         imgName = fullfile(ImageRoot,sprintf(ImgWildCard,iSet,iScale));
         if(not(exist(imgName))),continue,end
         im = imread(imgName);
         im = im2double(im);
         im = imresize(im,[32 32],'bilinear');
         %hog = vectorizeCellArray(c1Img2C1Simple(im,c1opts));
         fov = Vectorize(im);
         tempFeat = [tempFeat;fov(:)];
      end
      X = [X,tempFeat];
      fprintf('Recording Glance Images %d of %d\r',iSet,nTargets);
   end
   save(SaveName,'X');
end
PosObjNames = {'Car','Ped','Mon','Plate'};
ImgWildCard = 'posImg_%.6d_scalRat%.2d.bmp';
for iObj = 1:4;
   objName = PosObjNames{iObj};
   ImageRoot = fullfile(SourceRoot,objName);
   SaveName = fullfile(SaveRoot,sprintf('GlanceMat_Pos_%s.mat',objName));
   X = [];
   nTargets = 1000;
   for iSet = 1:nTargets
      tempFeat = [];
      for iScale = ScalesToUse
         imgName = fullfile(ImageRoot,sprintf(ImgWildCard,iSet,iScale));
         if(not(exist(imgName))),continue,end
         im = imread(imgName);
         im = im2double(im);
         im = imresize(im,[32 32],'bilinear');
         %hog = vectorizeCellArray(c1Img2C1Simple(im,c1opts));
         fov = Vectorize(im);
         tempFeat = [tempFeat;fov(:)];
      end
      X = [X,tempFeat];
      fprintf('Recording Glance Images %d of %d\r',iSet,nTargets);
   end
   save(SaveName,'X');
end


%(2) Step 2: choose the centers
clear all
nCenters = 128;
GlanceRoot =   '/cbcl/scratch01/bileschi/HWAX_Free/Extractions/HWAXFree';
GlanceFileName = fullfile(GlanceRoot,sprintf('GlanceMat_Neg_%s.mat','NonPed'));
load(GlanceFileName)%-->X
nFeat = size(X,1);
p = randperm(nFeat);
centersFromGlance = p(1:nCenters);
SaveName = fullfile(GlanceRoot,'centersFromGlance.mat');
save(SaveName,'centersFromGlance');


%(2.5) Step 2.5: choose the centers for a second version, 
clear all
nCenters = 1024;
GlanceRoot =   '/cbcl/scratch01/bileschi/HWAX_Free/Extractions/HWAXFree';
GlanceFileName = fullfile(GlanceRoot,sprintf('GlanceMat_Neg_%s.mat','NonPed'));
load(GlanceFileName)%-->X
nFeat = size(X,1);
p = randperm(nFeat);
centersFromGlance = p(1:nCenters);
SaveName = fullfile(GlanceRoot,'centersFromGlance_1024.mat');
save(SaveName,'centersFromGlance');

%(3) Step 3: find the coorelates for a unit
clear all
GlanceRoot =   '/cbcl/scratch01/bileschi/HWAX_Free/Extractions/HWAXFree';
GlanceFileName = fullfile(GlanceRoot,sprintf('GlanceMat_Neg_%s.mat','NonPed'));
load(GlanceFileName)%-->X
CentersFileName = fullfile(GlanceRoot,'centersFromGlance.mat');
load(CentersFileName);%-->centersFromGlance
for i = 1:length(centersFromGlance)
   Img2S1Conex(:,i) = FindMaximumCorrelatedSet(X,centersFromGlance(i),64);
   imshow(FourLayerColor(RecFieldFromIdxs(Img2S1Conex(:,i)),[5]));
   drawnow;
   fprintf('%d of %d\r',i,length(centersFromGlance));
end
GlanceRoot =   '/cbcl/scratch01/bileschi/HWAX_Free/Extractions/HWAXFree';
SaveName = fullfile(GlanceRoot,'Img2S1Conex.mat');
save(SaveName,'Img2S1Conex');
   
%(3.5) Step 3.5: find the coorelates for the larger set of units
clear all
GlanceRoot =   '/cbcl/scratch01/bileschi/HWAX_Free/Extractions/HWAXFree';
GlanceFileName = fullfile(GlanceRoot,sprintf('GlanceMat_Neg_%s.mat','NonPed'));
load(GlanceFileName)%-->X
CentersFileName = fullfile(GlanceRoot,'centersFromGlance_1024.mat');
load(CentersFileName);%-->centersFromGlance
Img2S1Conex = zeros(64, 1024);
for i = 1:length(centersFromGlance)
   Img2S1Conex(:,i) = FindMaximumCorrelatedSet(X,centersFromGlance(i),64);
   %imshow(FourLayerColor(RecFieldFromIdxs(Img2S1Conex(:,i)),[5]));
   %drawnow;
   fprintf('%d of %d\r',i,length(centersFromGlance));
end
GlanceRoot =   '/cbcl/scratch01/bileschi/HWAX_Free/Extractions/HWAXFree';
SaveName = fullfile(GlanceRoot,'Img2S1Conex_1024.mat');
save(SaveName,'Img2S1Conex');
   
