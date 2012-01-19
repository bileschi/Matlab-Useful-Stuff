%SCRIPT_Aerial_Images2C1
%
%convert the images downloaded from MapGrabber into C1 Format



setup_BAE
clear all
ImageSourceRoot = '/cbcl/scratch01/bileschi/Images/BAE/AerialDetection/Downloaded_Aerial_Images/Imgs/';
FeatureOutputRoot = '/cbcl/scratch01/bileschi/Images/BAE/AerialDetection/Downloaded_Aerial_Images/Feat/';
d = dir(ImageSourceRoot);
for i = 3:length(d)
  caCategoryNames{i-2} = d(i).name;
end
nCategories = length(caCategoryNames);

seedrand
%Loop over categories
for iCat = 1:nCategories 
   C1WritePath = fullfile(FeatureOutputRoot,'C1',caCategoryNames{iCat});
   if(not(exist(C1WritePath)))
      mkdir(fullfile(FeatureOutputRoot,'C1'),caCategoryNames{iCat});
   end
   %Loop over Scales within Categories
   for iScale = 13:19
      SourceImageFns = dirfull(fullfile(ImageSourceRoot,caCategoryNames{iCat},sprintf('*%.2d.jpg',iScale)));
      nImgs = length(SourceImageFns);
      %Loop over images within scales
      for iImg = randperm(nImgs)
         savename = sprintf('c1_cat%.2d_scal%.2d_imidx%.4d.mat',iCat,iScale,iImg);
         savefullname = fullfile(C1WritePath,savename)
         if(exist(savefullname)),fprintf('.');,continue;,end
         [imgLat,imgLon,imgScal] = LatLonScaleFromAerialFn(SourceImageFns(iImg).name);
         fprintf('processing %d %d %d of %d\n',iCat,iScale,iImg,nImgs)
         im = imread(SourceImageFns(iImg).fullname);
         im = im(95:222,92:222,:);
         %take the "middle" 128 x 128
         caC1 = c1Img2C1Simple(im);
         save(savefullname,'caC1','imgLat','imgLon','imgScal');
      end
   end
end
