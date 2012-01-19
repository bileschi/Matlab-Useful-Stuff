%SCRIPT_vcod_hier_car_detect
%
%for all the directories, load the .mat file and then visualize
clear all
Root = '/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database';
caCatNames{1} = 'bicycle';
caCatNames{2} = 'building';
caCatNames{3} = 'car_back_side_left';
caCatNames{4} = 'car_back_side_right';
caCatNames{5} = 'car_back_view';
caCatNames{6} = 'car_frnt_side_left';
caCatNames{7} = 'car_frnt_side_right';
caCatNames{8} = 'car_front_view';
caCatNames{9} = 'car_side_left';
caCatNames{10} = 'car_side_right';
caCatNames{11} = 'dog';
caCatNames{12} = 'large_truck';
caCatNames{13} = 'small_truck_back_side_left';
caCatNames{14} = 'small_truck_back_side_right';
caCatNames{15} = 'small_truck_back_view';
caCatNames{16} = 'small_truck_front_side_left';
caCatNames{17} = 'small_truck_front_side_right';
caCatNames{18} = 'small_truck_front_view';
caCatNames{19} = 'small_truck_left';
caCatNames{20} = 'small_truck_right';
caCatNames{21} = 'tree';
nLeafs = length(caCatNames);
X = [];
Y = [];
%loop over the object categories
v = cat(3,zeros(16,16,8),ones(16,16,8));
fOriDir1 = find(v);
fOriDir2 = find(not(v));
for iCat = 1:nLeafs
   fprintf('processing cat %d of %d\r',iCat,nLeafs);
   % open the file, reshape it to one col. per example and build one big matrix
   loadfn = fullfile(Root,caCatNames{iCat},sprintf('%s_min_HoG.mat',caCatNames{iCat}));
   load(loadfn,'min_HoG_matrix','file_name_array');%->min_HoG_matrix
   s = size(min_HoG_matrix);
   xt= reshape(min_HoG_matrix,[s(1)*s(2)*s(3),s(4)]);
   x = xt;
   %x = max(xt(fOriDir1,:),xt(fOriDir2,:));  % Rectify orientation responses
   X = [X,x];
   y = repmat(iCat,[1,s(4)]);
   Y = [Y,y];
   if(0)  %illustrate average models
      figure(4)
      clf
      m = mean(min_HoG_matrix,4);
      m = permute(m,[3,2,1]);
      imshow(FourLayerColor(m,[]));
      figure(3)
      clf
      ma = max(m(:,:,1:8),m(:,:,9:16));
      imshow(FourLayerColor(ma,[]));
      pause
   end
end
fprintf('processing cat %d of %d\n',iCat,nLeafs);
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/vodXY.mat','X','Y','caCatNames');

Ycar = ones(size(Y));
Ycar = ismember(Y,[3,4,5,6,7,8,9,10]);
Ytruck = ismember(Y,13:20);
Yvehic = Ycar | Ytruck;

cvOpts.nSplits = 5;
cvOpts.TrainPart = .75;
cvOpts.Classifier = 'gentleBoost';
cvOpts.FeatureSubset = [];
cvOpts.PickFeatureSubsetForMe = 0;
cvOpts.PosExampleSubset = [];
cvOpts.NegExampleSubset = [];
cvOpts.PickExampleSubsetForMe = 0;
[caModels,caTTS,caROCs] = CrossValidate(X(:,find(Yvehic)),X(:,find(not(Yvehic))),cvOpts);
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cv_boost_vehicNotVehic.mat','caModels','caTTS','caROCs');
%save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cv_boost_rectOri_vehicNotVehic.mat','caModels','caTTS','caROCs');
[caModels,caTTS,caROCs] = CrossValidate(X(:,find(Ycar)),X(:,find(not(Ycar))),cvOpts);
%save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cv_boost_carNotCar.mat','caModels','caTTS','caROCs');
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cv_boost_rectOri_carNotCar.mat','caModels','caTTS','caROCs');
[caModels,caTTS,caROCs] = CrossValidate(X(:,find(Ytruck)),X(:,find(not(Ytruck))),cvOpts);
%save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cv_boost_truckNotTruck.mat','caModels','caTTS','caROCs');
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cv_boost_rectOri_truckNotTruck.mat','caModels','caTTS','caROCs');

cvmOpts.nSplits = 5;
cvmOpts.TrainPart = .5;
cvmOpts.Classifier = 'gentleBoost';
cvmOpts.FeatureSubset = [];
cvmOpts.PickFeatureSubsetForMe = 500;
cvmOpts.PosExampleSubset = [];
cvmOpts.NegExampleSubset = [];
cvmOpts.PickExampleSubsetForMe = 0;
cvmOpts.TTSGrouping = 1;
[caModels,caTTS,caConf,Perf,options,ccaROCs] = CrossValidateMULT(X,y,cvmOpts)
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cvm_boost.mat','caModels','caTTS','caConf','Perf','ccaROCs');

cvOpts.Classifier = 'libsvm';
cvmOpts.Classifier = 'libsvm';
[caModels,caTTS,caROCs] = CrossValidate(X(:,find(Ycar)),X(:,find(not(Ycar))),cvOpts);
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cv_svm_carNotCar.mat','caModels','caTTS','caROCs');
[caModels,caTTS,caROCs] = CrossValidate(X(:,find(Ytruck)),X(:,find(not(Ytruck))),cvOpts);
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cv_svm_truckNotTruck.mat','caModels','caTTS','caROCs');
[caModels,caTTS,caConf,Perf,options,ccaROCs] = CrossValidateMULT(X,y,cvmOpts)
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/cvm_boost.mat','caModels','caTTS','caConf','Perf','ccaROCs');


%%%%%%%%%%%%%%%%%%%%%
%%  Data illustrations
%%%%%%%%%%%%%%%%%%%%%
clear all
Root = '/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database';
caCatNames{1} = 'bicycle';
caCatNames{2} = 'building';
caCatNames{3} = 'car_back_side_left';
caCatNames{4} = 'car_back_side_right';
caCatNames{5} = 'car_back_view';
caCatNames{6} = 'car_frnt_side_left';
caCatNames{7} = 'car_frnt_side_right';
caCatNames{8} = 'car_front_view';
caCatNames{9} = 'car_side_left';
caCatNames{10} = 'car_side_right';
caCatNames{11} = 'dog';
caCatNames{12} = 'large_truck';
caCatNames{13} = 'small_truck_back_side_left';
caCatNames{14} = 'small_truck_back_side_right';
caCatNames{15} = 'small_truck_back_view';
caCatNames{16} = 'small_truck_front_side_left';
caCatNames{17} = 'small_truck_front_side_right';
caCatNames{18} = 'small_truck_front_view';
caCatNames{19} = 'small_truck_left';
caCatNames{20} = 'small_truck_right';
caCatNames{21} = 'tree';
nLeafs = length(caCatNames);
X = [];
Y = [];
%loop over the object categories
v = cat(3,zeros(16,16,8),ones(16,16,8));
fOriDir1 = find(v);
fOriDir2 = find(not(v));
RootFigs = '/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/Figs/';
for iCat = 1:nLeafs
   fprintf('processing cat %d of %d\r',iCat,nLeafs);
   % open the file, reshape it to one col. per example and build one big matrix
   loadfn = fullfile(Root,caCatNames{iCat},sprintf('%s_min_HoG.mat',caCatNames{iCat}));
   load(loadfn,'min_HoG_matrix','file_name_array');%->min_HoG_matrix
   s = size(min_HoG_matrix);
   xt= reshape(min_HoG_matrix,[s(1)*s(2)*s(3),s(4)]);
   %x = xt;
   x = max(xt(fOriDir1,:),xt(fOriDir2,:));  % Rectify orientation responses
   X = [X,x];
   y = repmat(iCat,[1,s(4)]);
   Y = [Y,y];
   if(1)  %illustrate average models
      figure(4)
      clf
      m = mean(min_HoG_matrix,4);
      m = permute(m,[3,2,1]);
      imshow(FourLayerColor(m,[]));
      figure(3)
      clf
      ma = max(m(:,:,1:8),m(:,:,9:16));
      imshow(FourLayerColor(ma,[]));
      %pause
      imwrite(FourLayerColor(ma,[]),fullfile(RootFigs,'HoG_FourLayerColor',sprintf('class_%.3d_%s.jpg',iCat,caCatNames{iCat})));
   end
end
fprintf('processing cat %d of %d\n',iCat,nLeafs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% One vs One Experiments %  Abs ori
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
Root = '/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database';
caCatNames{1} = 'bicycle';
caCatNames{2} = 'building';
caCatNames{3} = 'car_back_side_left';
caCatNames{4} = 'car_back_side_right';
caCatNames{5} = 'car_back_view';
caCatNames{6} = 'car_frnt_side_left';
caCatNames{7} = 'car_frnt_side_right';
caCatNames{8} = 'car_front_view';
caCatNames{9} = 'car_side_left';
caCatNames{10} = 'car_side_right';
caCatNames{11} = 'dog';
caCatNames{12} = 'large_truck';
caCatNames{13} = 'small_truck_back_side_left';
caCatNames{14} = 'small_truck_back_side_right';
caCatNames{15} = 'small_truck_back_view';
caCatNames{16} = 'small_truck_front_side_left';
caCatNames{17} = 'small_truck_front_side_right';
caCatNames{18} = 'small_truck_front_view';
caCatNames{19} = 'small_truck_left';
caCatNames{20} = 'small_truck_right';
caCatNames{21} = 'tree';
nLeafs = length(caCatNames);
X = [];
Y = [];
%loop over the object categories
v = cat(3,zeros(16,16,8),ones(16,16,8));
fOriDir1 = find(v);
fOriDir2 = find(not(v));
RootFigs = '/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/Figs/';
for iCat = 1:nLeafs
   fprintf('processing cat %d of %d\r',iCat,nLeafs);
   % open the file, reshape it to one col. per example and build one big matrix
   loadfn = fullfile(Root,caCatNames{iCat},sprintf('%s_min_HoG.mat',caCatNames{iCat}));
   load(loadfn,'min_HoG_matrix','file_name_array');%->min_HoG_matrix
   s = size(min_HoG_matrix);
   xt= reshape(min_HoG_matrix,[s(1)*s(2)*s(3),s(4)]);
   %x = xt;
   x = max(xt(fOriDir1,:),xt(fOriDir2,:));  % Rectify orientation responses
   X = [X,x];
   y = repmat(iCat,[1,s(4)]);
   Y = [Y,y];
end
fprintf('processing cat %d of %d\n',iCat,nLeafs);
%train all pairwise models
optionsCrossVal.nSplits = 1;
optionsCrossVal.TrainPart = .75;
optionsCrossVal.Classifier = 'gentleBoost';
optionsCrossVal.FeatureSubset = [];
optionsCrossVal.PickFeatureSubsetForMe = 100;
optionsCrossVal.PosExampleSubset = [];
optionsCrossVal.NegExampleSubset = [];
optionsCrossVal.PickExampleSubsetForMe = 0;
meanEER = nan(21);
nTrials = 5;
for iCat = 1:21
   X1 = X(:,find(Y== iCat));
   for jCat = iCat:21
      fprintf('%d %s vs %d %s\n',iCat, caCatNames{iCat},jCat,caCatNames{jCat});
      X2 = X(:,find(Y== jCat));
      for iTrial = 1:nTrials
         [caModels,caTTS,caROCs,options] = CrossValidate(X1,X2,optionsCrossVal);
         eerOfTrial(iTrial) = caROCs{1}.EqualErrorRate;
      end
      meanEER(iCat,jCat) = mean(eerOfTrial);
      meanEER(jCat,iCat) = mean(eerOfTrial);
   end
end
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/Results/OvO_F100_boost_100r.mat','meanEER','optionsCrossVal');
%train all pairwise models
optionsCrossVal.nSplits = 1;
optionsCrossVal.TrainPart = .75;
optionsCrossVal.Classifier = 'libsvm';
optionsCrossVal.FeatureSubset = [];
optionsCrossVal.PickFeatureSubsetForMe = 100;
optionsCrossVal.PosExampleSubset = [];
optionsCrossVal.NegExampleSubset = [];
optionsCrossVal.PickExampleSubsetForMe = 0;
meanEER = nan(21);
nTrials = 5;
for iCat = 1:21
   X1 = X(:,find(Y== iCat));
   for jCat = iCat:21
      if(iCat == jCat)
         meanEER(iCat,jCat) = .5;
         continue;
      end
      fprintf('%d %s vs %d %s\n',iCat, caCatNames{iCat},jCat,caCatNames{jCat});
      X2 = X(:,find(Y== jCat));
      [X1,f1,X2] = RemoveDuplicateDatapoints(X1,X2);
      for iTrial = 1:nTrials
         [caModels,caTTS,caROCs,options] = CrossValidate(X1,X2,optionsCrossVal);
         eerOfTrial(iTrial) = caROCs{1}.EqualErrorRate;
      end
      meanEER(iCat,jCat) = mean(eerOfTrial);
      meanEER(jCat,iCat) = mean(eerOfTrial);
   end
end
save('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/Results/OvO_F100_svm_100r.mat','meanEER','optionsCrossVal');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Illustrate One vs One Experiments %  Abs ori
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
svm = load('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/Results/OvO_F100_svm_100r.mat','meanEER','optionsCrossVal');
boost = load('/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/Results/OvO_F100_boost_100r.mat','meanEER','optionsCrossVal');
h = figure(1)
clf
imshow(svm.meanEER,[]);
colormap('jet');
saveas(h,'/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/Figs/OvO_F100_svm_100r_meanEER.jpg','jpg');
clf

h = figure(1)
imshow(boost.meanEER,[]);
colormap('jet');
saveas(h,'/cbcl/scratch01/bileschi/Images/RichardWashington/vistacon_object_database/Figs/OvO_F100_boost_100r_meanEER.jpg','jpg');


