function [c2,c1] = C2_Easy(Images,options);
%function [c2,c1] = C2_Easy(Images,options);
%
%images must be either a cell array of images, 
%or a matrix where each column is an image, wherin the original size parameter of options must be set

if(nargin < 2)
   options = [];
end
d.OriginalSize = [81 81];
if(not(iscell(Images)))
  sz = size(Images,1);
  d.OriginalSize = [sqrt(sz),sqrt(sz)];  
end
options = ResolveMissingOptions(options,d);


rot = [90 -45 0 45];
c1ScaleSS = [1:2:18];
RF_siz    = [7:2:39];
c1SpaceSS = [8:2:22];
minFS     = 7;
maxFS     = 39;
div = [4:-.05:3.2];
Div       = div;
[fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, Div);

if(iscell(Images))
  nImages = length(Images);
else
  if(size(Images,3) > 1);
    nImages = size(Images,3);
  else
    nImages = size(Images,2);
  end
end

load('PatchesFromNaturalImages250per4sizes.mat');
for iImage = 1:nImages, %for every input image
  stim = GetStim(Images,iImage,options);
  img_siz = size(stim);
  C2_imgI = [];
  fprintf('Image %d building c1... \r',iImage);
  C1_imgI = C1(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL);
  for j = 1:4, %for every unique patch size
    C2_imgI = [C2_imgI;C2(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches{j},C1_imgI)];
    fprintf(1,'Image %d of %d, Patch %d of 2000\r',iImage,nImages,(j-1)*500);
  end
  fprintf('\n');
  c2(:,iImage) = C2_imgI;
  if(nargout > 1)
    c1(:,iImage) = vectorizeCellArray(C1_imgI);
  end
end

function stim = GetStim(Images,iImg,options)
if(iscell(Images))
  stim = Images{iImg};
else
  stim = reshape(Images(:,iImg),options.OriginalSize);
end
