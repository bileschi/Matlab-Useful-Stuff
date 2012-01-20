function [c2,s2,c1,s1,c2R,s2R,c1R,s1R] = procedure_testbileschirespc2(TestImage);
%function [c2,s2,c1,s1,c2R,s2R,c1R,s1R] = PROCEDURE_TestBileschiRespC2(TestImage);
%
rot = [90 -45 0 45];
div = [4:-.05:3.2];
clear c1OL
global fSiz filters c1SpaceSS c1ScaleSS c1OL minFS maxFS numSimpleFilters
if 0 
%case 'Gabband2'
%----Settings for Training --------%
c1ScaleSS = [1 3];
RF_siz    = [11 13];
c1SpaceSS = [10];
minFS     = 11;
maxFS     = 13;
Div       = div(3:4);
%--- END Settings for Training --------%
else
%----Settings for Testing --------%
c1ScaleSS = [1:2:18];
RF_siz    = [7:2:39];
c1SpaceSS = [8:2:22];
minFS     = 7;
maxFS     = 39;
Div       = div;
%--- END Settings for Testing --------%
end

disp('Initializing S1 features ...');
init_gabor(rot, RF_siz, Div);
fprintf(1,'done! \n\n');
disp('Processing C1 layer and extracting random patches...');
featureParams.s2Target = [];
stim = rgb2gray_cautious(double(TestImage));
%stim = imresize2(stim, [96,128]);
stim = imresize(stim,[96,128]);% [384,512]);
img_siz = size(stim);
tic 
[c1source,s1source] = BileschiRespC1(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL);
e = toc;
fprintf('c1 costs %f\n',e);
for i = 1:4 
  b(:,:,i) = c1source{1}{i}; 
end
sample1 = b(2:7,3:8,:);  
sample2 = b(12:17,10:15,:);
sample3 = b(7:12,13:18,:);
figure(1), imshow(TestImage)
hold on
scaleUp = size(TestImage,1) / size(b,1);
plot(11/2 * scaleUp,9/2 * scaleUp,'ro');
plot(25/2 * scaleUp,29/2 * scaleUp,'bo');
plot(31/2 * scaleUp,19/2 * scaleUp,'go');
s2Target(:,1) = sample1(:);
s2Target(:,2) = sample2(:);
s2Target(:,3) = sample3(:);
s2TargetRand = s2Target;    
l = size(s2TargetRand,1);
pfull = randperm(l);
l = ceil(l/2);
which2switch = pfull(1:l);
pwhich2switch = randperm(length(which2switch));
p = 1:size(s2TargetRand,1);
p(which2switch) = p(which2switch(pwhich2switch));
s2TargetRand(:,:) = s2TargetRand(p,:);
tic
[c2,s2,c1,s1] = BileschiRespC2(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,1,s2Target);
e = toc;
fprintf('c2 total costs %f\n',e);
figure(2)
subplot(3,1,1)
imshow(s2{1}{1},[]);
[i,j] = find(s2{1}{1} == min(min(s2{1}{1})));
hold on;
plot(j,i,'ro');
subplot(3,1,2)
imshow(s2{2}{1},[]);
[i,j] = find(s2{2}{1} == min(min(s2{2}{1})));
hold on;
plot(j,i,'bo');
subplot(3,1,3)
imshow(s2{3}{1},[]);
[i,j] = find(s2{3}{1} == min(min(s2{3}{1})));
hold on;
plot(j,i,'go');
tic
   [c2R,s2R,c1R,s1R] = BileschiRespC2(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,1,s2TargetRand);
e = toc;
fprintf('c2 total costs %f\n',e);
tic
   ThomasC2 = myRespC2(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,1,s2TargetRand);
e = toc;
fprintf('Thomas c2 total costs %f\n',e);
figure(3)
subplot(3,1,1)
imshow(s2R{1}{1},[]);
[i,j] = find(s2{1}{1} == min(min(s2{1}{1})));
hold on;
plot(j,i,'ro');
subplot(3,1,2)
imshow(s2R{2}{1},[]);
[i,j] = find(s2{2}{1} == min(min(s2{2}{1})));
hold on;
plot(j,i,'bo');
subplot(3,1,3)
imshow(s2R{3}{1},[]);
[i,j] = find(s2{3}{1} == min(min(s2{3}{1})));
hold on;
plot(j,i,'go');
fprintf('Bileschi c2 Results\n');
c2R.^2
fprintf('Serre c2 Results\n');
-ThomasC2

