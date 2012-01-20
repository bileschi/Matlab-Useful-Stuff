function cPatches = extractRandC1Patches(cItrainingOnly, numPatchSizes, numPatchesPerSize, patchSizes);
%extracts random prototypes as part of the training of the C2 classification system
%cPatches the returned prototypes
%cItrainingOnly the training images
%numPatchesPerSize is the number of sizes in which the prototypes come
%numPatchesPerSize is the number of prototypes extracted for each size
%patchSizes is the vector of the patche sizes

if nargin<2
  numPatchSizes = 4;
  numPatchesPerSize = 250;
  patchSizes = 4:4:16;
end

nImages = length(cItrainingOnly);

%----Settings for Training the random patches--------%
rot = [90 -45 0 45];
c1ScaleSS = [1 3];
RF_siz    = [11 13];
c1SpaceSS = [10];
minFS     = 11;
maxFS     = 13;
div = [4:-.05:3.2];
Div       = div(3:4);
%--- END Settings for Training the random patches--------%

fprintf(1,'Initializing gabor filters -- partial set...');
[fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, Div);
fprintf(1,'done\n');

cPatches = cell(numPatchSizes,1);
bsize = [0 0];

pind = zeros(numPatchSizes,1);
for j = 1:numPatchSizes
  cPatches{j} = zeros(patchSizes(j)^2*4,numPatchesPerSize);
end

for i = 1:nImages,
  ii = floor(rand*nImages) + 1;
  fprintf(1,'.');
  stim = cItrainingOnly{ii};
  img_siz = size(stim);
  
  [c1source,s1source] = C1(stim, filters, fSiz, c1SpaceSS, ...
      c1ScaleSS, c1OL);
  b = c1source{1}; %new C1 interface;
  bsize(1) = size(b,1);
  bsize(2) = size(b,2);
  for j = 1:numPatchSizes,
    for k = 1;
      xy = floor(rand(1,2).*(bsize-patchSizes(j)))+1;
      tmp = b(xy(1):xy(1)+patchSizes(j)-1,xy(2):xy(2)+patchSizes(j)-1,:);
      pind(j) = pind(j) + 1;
      cPatches{j}(:,pind(j)) = tmp(:); 
    end
  end
end
fprintf('\n');
