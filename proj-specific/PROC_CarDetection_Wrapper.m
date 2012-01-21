function PROC_CarDetection_Wrapper(SourceRoot,frameFNs,DestRoot)
%function PROC_CarDetection_Wrapper(SourceRoot,frameFNs,DestRoot)
%
%
addpath('~bileschi/MATLAB/Rayth');
load('/cbcl/scratch01/bileschi/PrecomputedFeatures/StreetScenes/AppearanceDetector/SCRIPT_TrainCarDetector','Model_Boost');
Model = Model_Boost{4};

%ImRoot = '/cbcl/scratch01/bileschi/Video/Neo2/Frames/20070521_14-45-17';
NFRAMES = length(frameFNs);
%iFrame = 1500;
%im = imread(fullfile(ImRoot,sprintf('raw_%.6d.jpg',iFrame)));
%im = im(1:460,:,:);
DetectOptions.ClassifierName = 'gentleBoost';
SuppressOptions.max_n_return = 25;        % the maximum number of detections that will be returned.
SuppressOptions.fSuppressionRadius = 64;  % the tightness of the spacial suppression in the xy direction.
SuppressOptions.SuppressScaleStructure = [1, .85, .5, .15]; % the first value refers to the strenth 
                  % of the suppression in this scale.  The second value the relative
        % suppression strength in the adjacent scales. etc.             
SuppressOptions.OriginalImageSize = [460 640];
SuppressOptions.ScaleStructure = ((2).^(1/8)) .^ [-14:8];
%SuppressOptions.ScaleStructure = ((2).^(1/8)) .^ [6:8];
SuppressOptions.WindowSize = [128 128];
SuppressOptions.bSuppressTruncatedBoxes = 0; % suppresses the detection of bounding boxes which would exit the
% DL = LocalNeighborhoodSuppression(cads,SuppressOptions);
seedrand
alpha = .5;
maxExpectedStrength = 5;
for iFrame = randperm(NFRAMES)
   fprintf('%d\r',iFrame);
   savename = fullfile(DestRoot,sprintf('pedestraindets_%.6d.mat',iFrame));
   %savename = fullfile(DestRoot,sprintf('cardets_%.6d.mat',iFrame));
   Imgsavename = fullfile(DestRoot,sprintf('carDetect_%.6d.jpg',iFrame));
   if(exist(Imgsavename))   
      continue;
   end
   inim = imread(fullfile(SourceRoot, frameFNs(iFrame).name));
   inImgSize = size(inim);
   if(exist(savename))
      load(savename);
   else
      SuppressOptions.OriginalImageSize = inImgSize;
      im = inim(1:460,:,:);
      cads =  WindowedObjectDetection_C1Simple(im,Model,DetectOptions);
      DL = LocalNeighborhoodSuppression(cads,SuppressOptions);
      save(savename,'cads','DL');
   end
   mask = DetectionList2Mask(DL,inImgSize,alpha,maxExpectedStrength);
   outIm = BlueMask(mask,inim,1.5,[0 0 1]);
   imwrite(outIm,Imgsavename,'jpg');
end

