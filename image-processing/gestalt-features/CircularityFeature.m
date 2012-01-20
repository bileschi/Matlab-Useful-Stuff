function [cCircularity,cHoughCirclesPreCombo] = CircularityFeature(img, options)
% function [cCircularity] = CircularityFeature(img, options)
%

d.RadMin = 2;
d.RadMax = 32;
d.RadGrain = sqrt(2);
d.CentGradPerRad = 1;
d.StopForDebugging = 0;
d.LinearVersion = 0;
d.Verbose = 1;
d.bSpeedUpForLargeRadius = 0;
d.bDecimateResult = 0;
d.bOtherDecimateResult = 0;
d.bFilimentOn = 0;
d.bRoughnessNormalization = 0;

if(size(img,3) > 1), error('image must be single channel\n');, end

if(nargin < 2),options = [];,end
options = ResolveMissingOptions(options,d);
options.OrigSize = size(img);
% saMat.SegFeature = zeros(size(X));
if(options.Verbose), fprintf('F');, end
stim = FourWayFilter(img);
if(options.Verbose), fprintf('X');, end
stim = OnlyRetainMaximumOrientationStim(stim);
if(options.Verbose), fprintf('D');, end
cHoughCirclesPreCombo = DetectCircles(stim,options);
if(options.StopForDebugging)
   keyboard
end
if(options.LinearVersion)
   for j = 1:length(cHoughCirclesPreCombo)
     cHoughCircles{j} = sum(cHoughCirclesPreCombo{j},3);
     if((nargout > 1) && (i==1))
      imgstruct{j} = cHoughCircles{j};
     end
     if(options.bDecmiateResult)
       cHoughCircles{j} = imresize(cHoughCircles{j},1/8,'bilinear');
     end
   end
else
  for j = 1:length(cHoughCirclesPreCombo)
    z = sort(cHoughCirclesPreCombo{j},3);
    if(options.bFilimentOn)
      cHoughCircles{j} = sum(z(:,:,1:3),3);
    else
      cHoughCircles{j} = sum(z(:,:,1:3),3);
    end
    if((nargout > 1) && (i==1))
      imgstruct{j} = cHoughCircles{j};
    end
    if(options.bDecimateResult)
       cHoughCircles{j} = imresize(cHoughCircles{j},1/8,'bilinear');
     end
   end
end
 cCircularity = cHoughCircles;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function MLI = UniqueWindowed(IdxImg,yx_wind);
%function MLI = UniqueWindowed(IdxImg,yx_wind);

IdxImg = padimage(IdxImg,[floor(yx_wind),ceil(yx_wind)],'symmetric');
u = unique(IdxImg);
MLI = zeros(size(IdxImg,1), size(IdxImg,2), length(u));

nWindsY = size(IdxImg,1) - yx_wind(1) + 1;
nWindsX = size(IdxImg,2) - yx_wind(2) + 1;
T = zeros(size(IdxImg,1), size(IdxImg,2), length(u));
for i = u'
  T(:,:,i) = (IdxImg == u(i));
  MLI(:,:,i) = maxfilter(T(:,:,i),[floor(yx_wind/2),ceil(yx_wind/2)]);
  %  MLI(:,:,i) = imdilate(T(:,:,i),ones(floor(yx_wind(1)),ceil(yx_wind(2))));
end
MLI = unpadimage(MLI,[floor(yx_wind),ceil(yx_wind)]);

function outim = FourWayFilter(inim)
filters{1} = [ 1  1  1; 0  0  0;-1 -1 -1];
filters{2} = [-1  0  1;-1  0  1;-1  0  1];
filters{3} = [ 0  1  1;-1  0  1;-1 -1  0];
filters{4} = [ 1  1  0; 1  0 -1; 0 -1 -1];
outim = abs(ApplyFilterBank(inim,filters));

function cHoughCircles = DetectCircles(stim,options);
% function cHoughCircles = DetectCircles(stim,options);
% each oriented element contributes to potential circles at different scales.
rads = options.RadMin;
orientations = [90,0,45,135]; 
translations{1} = [1, 0];
translations{2} = [0, 1];
translations{3} = [.7, -.7];
translations{4} = [.7, .7];
while(rads(end) < options.RadMax);
  rads(end+1) = rads(end) * options.RadGrain;
end
n = 0;
iRad = 0;
OrigSize = options.OrigSize;
for r = rads
   n = n+1;
   if(options.Verbose), fprintf('computing radius %d of %d\n',n,length(rads));, end
   iRad = iRad + 1;
   if(options.bFilimentOn), nLay = 8; else, nLay = 4;, end
   if(not(options.bSpeedUpForLargeRadius))
     cHoughCircles{iRad} = zeros(OrigSize(1),OrigSize(2),nLay);
     iori = 0;
     for ori = orientations
        iori = iori + 1;
        Translation = r * translations{iori};
        ConvK = BuildConvolutionKernel(r,ori);
        convIm = conv2(stim(:,:,iori),ConvK,'same');
        if(options.bFilimentOn)
          cHoughCircles{iRad}(:,:,iori) = cHoughCircles{iRad}(:,:,iori) + TranslateIm(convIm, Translation);
          cHoughCircles{iRad}(:,:,iori+4) = cHoughCircles{iRad}(:,:,iori+4) + TranslateIm(convIm, -Translation);
        else
	  cHoughCircles{iRad}(:,:,iori) = cHoughCircles{iRad}(:,:,iori) + TranslateIm(convIm, Translation);
          cHoughCircles{iRad}(:,:,iori) = cHoughCircles{iRad}(:,:,iori) + TranslateIm(convIm, -Translation);
        end
     end
   else
     iori = 0;
     resize = 1;
     effectiver = r;
     while(effectiver > 16)
        effectiver = effectiver / 2;
        resize = resize / 2;
      end
     if(options.bFilimentOn), nLay = 8; else, nLay = 4;, end
     cHoughCirclesF{iRad} = zeros(OrigSize(1)*resize,OrigSize(2)*resize,nLay);
     if(resize < 1)
       eStim = imresize(stim, resize,'bilinear');
     else
       eStim = stim;
     end
     for ori = orientations
        iori = iori + 1;       
	Translation = effectiver * translations{iori};        
	ConvK = BuildConvolutionKernel(effectiver,ori);
	convIm = conv2(eStim(:,:,iori),ConvK,'same');
%        cHoughCirclesF{iRad}(:,:,iori) = cHoughCirclesF{iRad}(:,:,iori) + TranslateIm(convIm, Translation);
%        cHoughCirclesF{iRad}(:,:,iori) = cHoughCirclesF{iRad}(:,:,iori) + TranslateIm(convIm, -Translation);
        if(options.bFilimentOn)
          cHoughCirclesF{iRad}(:,:,iori) = cHoughCirclesF{iRad}(:,:,iori) + TranslateIm(convIm, Translation);
          cHoughCirclesF{iRad}(:,:,iori+4) = cHoughCirclesF{iRad}(:,:,iori+4) + TranslateIm(convIm, -Translation);
        else
	  cHoughCirclesF{iRad}(:,:,iori) = cHoughCirclesF{iRad}(:,:,iori) + TranslateIm(convIm, Translation);
          cHoughCirclesF{iRad}(:,:,iori) = cHoughCirclesF{iRad}(:,:,iori) + TranslateIm(convIm, -Translation);
        end
     end
     if(options.bOtherDecimateResult)
       cHoughCircles{iRad} = imresize(cHoughCirclesF{iRad},(1/resize)*(1/min(1,r/2)),'bilinear');
     else
       cHoughCircles{iRad} = imresize(cHoughCirclesF{iRad},1/resize,'bilinear');
     end
     cHoughCirclesF{iRad} = [];
   end
   if(options.bRoughnessNormalization);
     rr = 20;
     M = imfilter(cHoughCircles{iRad},ones(ceil(rr*2)),'symmetric') / (ceil(rr*2)*ceil(rr*2));
     cHoughCircles{iRad} = -max(0,cHoughCircles{iRad}-maxfilter(M,ceil(rr/2)));
   end
end

function ConvK = BuildConvolutionKernel(r,ori)
%function ConvK = BuildConvolutionKernel(r,ori)
r = round(r);
ConvK = GausImg([2*r 2*r],[r,r],[4*r,r*1.75]);
% ConvK = GausImg([2*r 2*r],[r,r],[8*r,r*.15]);
% ConvK = ConvK > .5;
ConvK = 2 * min(ConvK, .5);
ConvK = im2double(imrotate(ConvK, ori,'bilinear','crop'));
ConvK = ConvK / (ConvK(:)' * ConvK(:) );


function t = TranslateIm(convIm, Translation);
%function t = TranslateIm(convIm, Translation);
Translation = round(Translation);
t = zeros(size(convIm));
t = circshift(convIm,[Translation]);
Translation = min(Translation,size(convIm));
Translation = max(Translation,-size(convIm) + 1);
if(Translation(1) < 0);
  t((end+Translation(1)):(end),:) = 0;
else
  t(1:Translation(1),:) = 0;
end
if(Translation(2) < 0);
  t(:,(end+Translation(2)):(end)) = 0;
else
  t(:,1:Translation(2)) = 0;
end

function stim = OnlyRetainMaximumOrientationStim(stim);
% function stim = OnlyRetainMaximumOrientationStim(stim);
M = max(stim(:));
stim = stim + rand(size(stim))*.01*M;
[s, si] = sort(stim,3);
v = repmat(s(:,:,end),[1,1,size(stim,3)]);
f = stim == v;
stim = 0 * stim;
stim(f) = v(f);


   
   
   
   
   
