%SCRIPT_Aerial_GatherFeatures
%
%Gather the computed image features into manageable matricies
%


setup_BAE
clear all
FeatureInputRoot = '/cbcl/scratch01/bileschi/Images/BAE/AerialDetection/Downloaded_Aerial_Images/Feat/';
FeatureOutputRoot = '/cbcl/scratch01/bileschi/Images/BAE/AerialDetection/Downloaded_Aerial_Images/Feat/';
d = dir(fullfile(FeatureInputRoot,'C1'));
caCategoryNames{1} = 'Baseball';
caCategoryNames{2} = 'Bridges';
caCategoryNames{3} = 'CrossWalks';
caCategoryNames{4} = 'Docks';
caCategoryNames{5} = 'Fields';
caCategoryNames{6} = 'Monuments';
caCategoryNames{7} = 'Overpass';
caCategoryNames{8} = 'ParkingLots';
caCategoryNames{9} = 'Random';
caCategoryNames{10} = 'Random2';
nCategories = length(caCategoryNames);

seedrand
%Loop over categories (C1)
for iCat = randperm(nCategories) 
   FeatureReadPath = fullfile(FeatureInputRoot,'C1',caCategoryNames{iCat});
   FeatureWritePath = fullfile(FeatureOutputRoot,'C1');
   %Loop over Scales within Categories
   for iScale = randperm(7)+12
      SourceFeatFns = dirfull(fullfile(FeatureReadPath,sprintf('*scal%.2d_*.mat',iScale)));
      nImgs = length(SourceFeatFns);
      %Loop over images within scales
      c1Mat = [];
      savename = sprintf('c1Mat_cat%.2d_scal%.2d.mat',iCat,iScale);
      savefullname = fullfile(FeatureWritePath,savename);
      if(exist(savefullname)),fprintf('.');,continue;,end
      clear myLat myLon myScale c1Mat
      for iImg = 1:nImgs
         loadname = sprintf('c1_cat%.2d_scal%.2d_imidx%.4d.mat',iCat,iScale,iImg);
         loadfullname = fullfile(FeatureReadPath,loadname);
         load(loadfullname,'caC1','imgLat','imgLon','imgScal');
         myLat(iImg) = imgLat;
         myLon(iImg) = imgLon;
         myScal(iImg) = imgScal;
         c1Mat(:,iImg) = vectorizeCellArray(caC1);
         fprintf('processing %d %d %d of %d\n',iCat,iScale,iImg,nImgs)
      end
     save(savefullname,'c1Mat','myLat','myLon','myScal');
   end
end

%Loop over categories (HoG)
for iCat = 1:nCategories 
   FeatureReadPath = fullfile(FeatureInputRoot,'HoG',caCategoryNames{iCat});
   FeatureWritePath = fullfile(FeatureOutputRoot,'HoG');
   %Loop over Scales within Categories
   for iScale = 13:19
      SourceFeatFns = dirfull(fullfile(FeatureReadPath,sprintf('*scal%.2d_*.mat',iScale)));
      nImgs = length(SourceFeatFns);
      %Loop over images within scales
      hogMat = [];
      savename = sprintf('hogMat_cat%.2d_scal%.2d.mat',iCat,iScale);
      savefullname = fullfile(FeatureWritePath,savename);
      if(exist(savefullname)),fprintf('.');,continue;,end
      for iImg = 1:nImgs
         loadname = sprintf('hog_cat%.2d_scal%.2d_imidx%.4d.mat',iCat,iScale,iImg);
         loadfullname = fullfile(FeatureReadPath,loadname);
         load(loadfullname,'caHoG','imgLat','imgLon','imgScal');
         myLat(iImg) = imgLat;
         myLon(iImg) = imgLon;
         myScal(iImg) = imgScal;
         hogMat(:,iImg) = vectorizeCellArray(caHoG);
         fprintf('processing %d %d %d of %d\n',iCat,iScale,iImg,nImgs)
      end
     save(savefullname,'hogMat','myLat','myLon','myScal');
   end
end


%Loop over categories (C2)
for iCat = 1:nCategories 
   FeatureReadPath = fullfile(FeatureInputRoot,'C2',caCategoryNames{iCat});
   FeatureWritePath = fullfile(FeatureOutputRoot,'C2');
   %Loop over Scales within Categories
   for iScale = 13:19
      SourceFeatFns = dirfull(fullfile(FeatureReadPath,sprintf('*scal%.2d_*.mat',iScale)));
      nImgs = length(SourceFeatFns);
      %Loop over images within scales
      hogMat = [];
      savename = sprintf('c2Mat_cat%.2d_scal%.2d.mat',iCat,iScale);
      savefullname = fullfile(FeatureWritePath,savename);
      if(exist(savefullname)),fprintf('.');,continue;,end
      for iImg = 1:nImgs
         loadname = sprintf('c2_cat%.2d_scal%.2d_imidx%.4d.mat',iCat,iScale,iImg);
         loadfullname = fullfile(FeatureReadPath,loadname);
         load(loadfullname,'c2','imgLat','imgLon','imgScal');
         myLat(iImg) = imgLat;
         myLon(iImg) = imgLon;
         myScal(iImg) = imgScal;
         hogMat(:,iImg) = vectorizeCellArray(caHoG);
         fprintf('processing %d %d %d of %d\n',iCat,iScale,iImg,nImgs)
      end
     save(savefullname,'hogMat','myLat','myLon','myScal');
   end
end

