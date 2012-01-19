function [ObjParts,StartRect] = AcquirePatchTree2(sPolys,Intersections,whichSTART,StartRect)
%function [ObjParts,StartRect] = AcquirePatchTree2(sPolys,Intersections,whichSTART,StartRect)
%
%sPolys is the polygon structure from PolygonsFromDatabase or FilterPolys
%Intersections is the IntersectionMatrix from CalculatePolygonIntersections
%WhichSTART is the polygon index to start from
%StartRect is a bbox to serve as the root Patch.

USESLOWMATCHPATCH = 0;
SEARCHRANGE = [.45, .45];
%MATCHMODE = 'Grayscale';
%MATCHMODE = 'MultiTech';
MATCHMODE = 'SegmentC1';
%MATCHMODE = 'C1';

K = 5;
% MAXiterations = 1;
MAXiterations = 1000 / K;

%%%%%%%%%%%%%%%%%%%%%%%%
%% Get Starting Patch %%
%%%%%%%%%%%%%%%%%%%%%%%%

%select a square patch from START
Patches = {};
if(nargin == 3)
    switch lower(MATCHMODE)
      case 'grayscale';
        [Patches,StartRect] = GetStartPatch_Grayscale(Patches, whichSTART, sPolys);
      case 'multitech';
        [Patches,StartRect] = GetStartPatch_Grayscale(Patches, whichSTART, sPolys);
      case 'segmentc1';
        [Patches,StartRect] = GetStartPatch_segmentc1(Patches, whichSTART, sPolys);
      case 'c1';
        [Patches,StartRect] = GetStartPatch_c1(Patches, whichSTART, sPolys);
    end
else
    switch lower(MATCHMODE)
      case 'grayscale';
        [Patches,StartRect] = GetStartPatch_Grayscale(Patches, whichSTART, sPolys, StartRect);
      case 'multitech';
        [Patches,StartRect] = GetStartPatch_Grayscale(Patches, whichSTART, sPolys, StartRect);
      case 'segmentc1';
        [Patches,StartRect] = GetStartPatch_segmentc1(Patches, whichSTART, sPolys, StartRect);
      case 'c1';
        [Patches,StartRect] = GetStartPatch_c1(Patches, whichSTART, sPolys, StartRect);
    end
end

ImageSourcedFlag = zeros(length(Intersections),1);
PartUniqueness = zeros(length(Intersections),1) - 1;
ObjParts{1} = Patches{whichSTART}{1};
ObjParts{1}.referringPoly = 0;
ObjParts{1}.index_of_referringPoly = 0;

%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop Until Done    %%
%%%%%%%%%%%%%%%%%%%%%%%%

done = 0;
todolist = [whichSTART];
%done if MAXIterations or at end of todo list.
iteration = 0;
while(~done)
    iteration = iteration + 1;    
    fprintf('Beginning work on Obj %d\n',todolist(iteration));
    currentObj = todolist(iteration);
    ImageSourcedFlag(currentObj) = 1;
    todolist = todolist(2:end);
    workingPatch = Patches{currentObj}{1};
    if(iteration~=1)
       ObjParts{end} = workintPatch;
    end;
    [MatchTheseObjsNow] = GetUnusedNeighbors(currentObj, ImageSourcedFlag,K,Intersections,workingPatch,sPolys);
    todolist = [todolist, MatchTheseObjsNow];
    %build the set of allowable transformations of this patch
    [TPatches,transformations] = ShowTransformationsOfWorkingPatch(workingPatch,0);
    %find the closest match in each of the kNN
    NTD = length(MatchTheseObjsNow);
    figure(3)
    clf
    for k = 1:NTD
        image_toObj = imread(sPolys(MatchTheseObjsNow(k)).im_name);
        figure(3)
	subplot(NTD,6,(k-1)*6 + 1,'align');
        [ObjBoxK,ObjImage] = prettyshowObj(sPolys,MatchTheseObjsNow(k),0);
        hold on;
        if(USESLOWMATCHPATCH)
	    if(strcmpi(MATCHMODE,'SegmentC1'))
	       error('SegmentC1 incompatable with SLOWPATCHMATCH');
	    end;
            CroppedObjImage = imcrop(ObjImage, ObjBoxK);
            CroppedObjImage = rgb2gray(CroppedObjImage);
            [MatchPatch,t] = GetMatchingPatch(workingPatch, transformations,TPatches, ...
	       CroppedObjImage,ObjBoxK,MatchTheseObjsNow(k));
            CroppedObjImage = imread(sPolys(MatchTheseObjsNow(k)).im_name);
        else
	    if(strcmpi(MATCHMODE,'grayscale'));
               [MatchPatch,t] = GetMatchingPatchFaster_Grayscale(workingPatch, image_toObj, ObjBoxK, ...
   	          transformations, TPatches, MatchTheseObjsNow(k),SEARCHRANGE);
            end
	    imnum = sPolys(MatchTheseObjsNow(k)).imidx;
	    load(sprintf('/cbcl/scratch01/bileschi/PrecomputedFeatures/StreetScenes/c1/TestingParams/c1AtSomeScales_%.5d.mat',imnum));
	    %-->Exp
	    c1 = c1Vector2LayerStructure(Exp.c1structure{1},8:2:22,2,960,1280);
	    im3d = c1{1};
	    load(sprintf('/cbcl/scratch01/bileschi/PrecomputedFeatures/StreetScenes/segments/700/segment_%.5d.mat',imnum));
	    %-->Boundary
	    Boundary = im2double(imresize(maxfilter(Boundary,3),[240 320],'bilinear'));
	    for i = 1:4
  	        image_toObj_C1(:,:,i) = im3d(:,:,i).*(Boundary/256);
	    end
	    if(strcmpi(MATCHMODE,'segmentc1'));
	       ObjBoxK_s = CoordinateRespace(ObjBoxK, [960 1280], [240 320],'bbox');
               [MatchPatch,t] = GetMatchingPatchFaster_SegmentC1(workingPatch, image_toObj_C1, ObjBoxK_s, ...
   	          transformations, TPatches, MatchTheseObjsNow(k),SEARCHRANGE);
            end
	    if(strcmpi(MATCHMODE,'c1'));
	       ObjBoxK_s = CoordinateRespace(ObjBoxK, [960 1280], [240 320],'bbox');
               [MatchPatch,t] = GetMatchingPatchFaster_SegmentC1(workingPatch, im3d, ObjBoxK_s, ...
   	          transformations, TPatches, MatchTheseObjsNow(k),SEARCHRANGE);
            end
        end
        
        MatchPatch.imcropRGB = imcrop(ObjImage, MatchPatch.CoordsOriginal(1:4));
        MatchPatch.fromObjIndex = MatchTheseObjsNow(k);
        MatchPatch.imfrom = sPolys(MatchTheseObjsNow(k)).im_name;
	MatchPatch.SSDBIdx = sPolys(MatchTheseObjsNow(k)).imidx;        
	MatchPatch.Uniqueness = getMaxStd(MatchPatch.resultimage);
	MatchPatch.referringObj = currentObj;
        MatchPatch.index_of_referringObj = iteration;
	
        subplot(NTD,6,(k-1)*6 + 2,'align'),
        imshow(MatchPatch.resultimage,[]);
        subplot(NTD,6,(k-1)*6 + 3,'align'),
        imshow(TPatches{t}(:,:,1:3)* (1/(max(max(max(TPatches{t}(:,:,1:3)))))));
        subplot(NTD,6,(k-1)*6 + 4,'align'),
        imshow(MatchPatch.imcropRGB);
        subplot(NTD,6,(k-1)*6 + 5,'align'),
        imshow(workingPatch.imcropRGB);
        subplot(NTD,6,(k-1)*6 + 6,'align'),
        st = sprintf('correleation %1.2f poly %d uniqueness %f',MatchPatch.correlationStrength,MatchTheseObjsNow(k),MatchPatch.Uniqueness);
        title(st);
        axis off;
        drawnow; 
        subplot(NTD,6,(k-1)*6 + 1,'align');
        hold on;
        DrawLinesOnExpectedPosition(workingPatch,ObjBoxK,image_toObj);
        hold on;
        DrawBoxAroundCenterSearchRange(workingPatch, ObjBoxK, image_toObj, SEARCHRANGE);
        drawnow;
	        
	if(MatchPatch.Uniqueness > PartUniqueness)
	     Patches{MatchTheseObjsNow(k)}{1} = MatchPatch;
        	PartUniqueness(MatchTheseObjsNow(k)) = MatchPatch.Uniqueness;
        end
    end
    [todolist] = reorderTodolist(todolist, PartUniqueness, ImageSourcedFlag);
	%display.
    if (iteration >= MAXiterations)
        done = 1;
    end
    if isempty(todolist)
        done = 1;
    end   
end
    
figure(6);
nr = floor(sqrt(length(ObjParts)));
nc = ceil(length(ObjParts) / nr);
for i = 1:length(ObjParts);
    subplot(nc,nr,i);
    if(strcmpi(MATCHMODE,'segmentc1'));
       imshow(ObjParts{i}.imcropRGB);
    end
    if(strcmpi(MATCHMODE,'grayscale'));
       imshow(ObjParts{i}.imcrop);
    end
end

function DrawBoxAroundCenterSearchRange(workingPatch, ObjBox, image_toObj, SEARCHRANGE)
ex = workingPatch.CoordsWRTObjBox(5:6) .* ObjBox(3:4) + ObjBox(1:2);
hs = SEARCHRANGE .* ObjBox(3:4) / 2;
l = ex(1) - hs(1);
r = ex(1) + hs(1);
t = ex(2) - hs(2);
b = ex(2) + hs(2);
h = line([l l r r l], [t b b t t]);
set(h,'Color',[1 0 0]);

function DrawLinesOnExpectedPosition(workingPatch,ObjBox,img)
ex = workingPatch.CoordsWRTObjBox(5:6) .* ObjBox(3:4) + ObjBox(1:2);
line([ex(1) ex(1)],[ 1 size(img,1)]);
line([1 size(img,2)],[ ex(2) ex(2)]);

function [todolist] = reorderTodolist(todolist, PartUniqueness, ImageSourcedFlag);
u = PartUniqueness(todolist);
[Y,I] = sort(-u);
lenv = length(u);
lentdl = length(todolist);
todolist = todolist(I);

function inPatch = UndoTransformation(inPatch);
transopts.Rotations = [-inPatch.transform.rotation];
transopts.Scales = [1 / (inPatch.transform.xscale)];
srcim = imread(inPatch.imfrom);
T = GetTransformationsOfPatch(inPatch, srcim,transopts);
inPatch.preDeTransform = inPatch.imcrop;
inPatch.imcrop = T{1};


function [NewPatch,resim] = FindBestFit(Obj, ObjPart,CanonPos,searchrange,ObjBoxInOrigImage)
%CanonPos is [x y]
resim = normxcorr2(ObjPart,Obj);
if(nargin < 3)
    CanonPos = [.5 .5];
end
if(nargin < 4)
    searchrange = -1;
end
partcenter = size(ObjPart) / 2;
if(searchrange ~= -1)
    mask = zeros(size(resim));
    Mx = size(mask,2);
    My = size(mask,1);
    xrange_in_pix = floor(searchrange * size(Obj,2));
    yrange_in_pix = floor(searchrange * size(Obj,1));
    xc = floor(partcenter(2) + CanonPos(1)*size(Obj,2));
    yc = floor(partcenter(1) + CanonPos(2)*size(Obj,1));
    mask( max((yc - yrange_in_pix),1):min((yc + yrange_in_pix),My),max((xc - xrange_in_pix),1):min((xc + xrange_in_pix),Mx)) = 1;
    resim = (resim +1) .* mask;
end
%black out the border
resim(:,(1):(size(ObjPart,2))) = 0;
resim(:,(end - size(ObjPart,2)):end) = 0;
resim((1):(size(ObjPart,1)),:) = 0;
resim((end - size(ObjPart,1)):end,:) = 0;
[maxOfCols,yk] = max(resim);
[vk,xk] = max(maxOfCols);
yk = yk(xk);
xk = floor(xk - 2 * partcenter(2));
yk = floor(yk - 2 * partcenter(1));
newpart = imcrop(Obj,[xk yk size(ObjPart,2), size(ObjPart,1)]);
NewPatch.imcrop = newpart;
NewPatch.correlationStrength = vk;
NewPatch.ObjBox = ObjBoxInOrigImage;
x = xk + ObjBoxInOrigImage(1);
y = yk + ObjBoxInOrigImage(2);
xS = size(ObjPart,2);
yS = size(ObjPart,1);
xc = x + (xS - 1) / 2;
yc = y + (yS - 1) / 2;
NewPatch.CoordsOriginal = [x, y, xS, yS, xc, yc];

function [MatchPatch,maxt] = GetMatchingPatch(workingPatch, transformations,TPatches,CroppedObjImage,ObjBoxK,index)
DISPLAY = 0;
maxncorr = -777;
maxt = -1;
ntransformations = length(TPatches);
xr = workingPatch.CoordsWRTObjBox(5);
yr = workingPatch.CoordsWRTObjBox(6);
bestresultim = [];
if(DISPLAY)
    fprintf('Matching Obj %d to Obj %d\n',workingPatch.fromObjIndex, index);
end
for t = 1:ntransformations
    if(DISPLAY)
        fprintf('  t = %d',t);
    end
    %TransPart = rgb2gray(TPatches{t});
    TransPart = TPatches{t};
    %f = New Obj width Over Old Obj Width
    f = (ObjBoxK(3)) / workingPatch.ObjBox(3);
    NewPatchWidth = f * workingPatch.CoordsOriginal(3);
    NewPatchHeight = f * workingPatch.CoordsOriginal(4);
    TransPart = imresize(TransPart, [NewPatchHeight,NewPatchWidth]);
    %find the best correlation
    %fprintf('findbestfitcosts:');
    [TempPatch,resultim] = FindBestFit(CroppedObjImage, TransPart,[xr yr], .35, ObjBoxK);
    vk = TempPatch.correlationStrength;
    if(vk > maxncorr)
        maxncorr = vk;
        maxt = t;
        bestResultIm = resultim; 
        MatchPatch = TempPatch;
        if(DISPLAY)
            fprintf('*');    
        end
    end
    if(DISPLAY)
        fprintf('\n');
    end
end
MatchPatch.ObjBox = ObjBoxK;
mx = MatchPatch.CoordsOriginal(1);
my = MatchPatch.CoordsOriginal(2);
Mx = MatchPatch.CoordsOriginal(3) + MatchPatch.CoordsOriginal(1);
My = MatchPatch.CoordsOriginal(4) + MatchPatch.CoordsOriginal(2);
xS = MatchPatch.CoordsOriginal(3);
yS = MatchPatch.CoordsOriginal(4);
MatchPatch.CoordsWRTObjBox(1) = (mx - ObjBoxK(1)) / ObjBoxK(3);
MatchPatch.CoordsWRTObjBox(2) = (my - ObjBoxK(2)) / ObjBoxK(4);
MatchPatch.CoordsWRTObjBox(5) = ((mx + Mx) / 2 - ObjBoxK(1)) / ObjBoxK(3);
MatchPatch.CoordsWRTObjBox(6) = ((my + My) / 2 - ObjBoxK(2)) / ObjBoxK(4);
MatchPatch.CoordsWRTObjBox(3) = xS / ObjBoxK(3);
MatchPatch.CoordsWRTObjBox(4) = yS / ObjBoxK(4);

MatchPatch.transform = transformations(maxt);
MatchPatch.resultimage = bestResultIm;


function ObjBox = GetObjBox(Poly);
mx = min(Poly(:,1));
my = min(Poly(:,2));
Mx = max(Poly(:,1));
My = max(Poly(:,2));
sx = Mx - mx + 1;
sy = My - my + 1;
ObjBox = [mx, my, sx, sy];

function u = getMaxStd(resim)
z = resim(:);
z = z(find(z ~= min(z)));
M = max(z);
m = mean(z);
s = std(z);
u = (M-m)/s;