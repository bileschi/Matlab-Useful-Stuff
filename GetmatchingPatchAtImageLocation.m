function [MatchPatch,NecessaryPad] = GetmatchingPatchAtImageLocation(Image, Location, Patch,paddingStrategy)
%function val = GetmatchingPatchAtImageLocation(Image, Location, Patch)
%
%centers the patch over the location in the image, and extracts the
%patch of image corresponding to the patch.  The Patch is not exactly centered if either
%size dimension is even.  If necessary the image will be padded to fit the patch.
%By default the image will be padded with 'padimage(~,~,'replicate')', but this behaviour can be overrided
%by setting the paddingStrategy parameter.
%
%Location is [ X , Y ]   <----------  Look *_*

MatchPatch  = zeros(size(Patch));
if(nargin < 3)
    fprintf('val = GetmatchingPatchAtImageLocation(Image, Location, Patch,~paddingStrategy)\n');,    return;
end
if(nargin < 4)
    paddingStrategy = 'replicate';
end
sizeI = size(Image);, sizeP = size(Patch);
if(sizeI(3) ~= sizeP(3))
    size(Image)
    size(Patch)
    fprintf('nlayers(Image) ne nlayers(Patch)\n');,keyboard,return;
end
%get matching image Location.
PatchCenter = (sizeP(1:2)/2);
%ImageMatchLoaction = [L T R B];
ImageMatchLocation(1) = Location(1) - floor(PatchCenter(2));
ImageMatchLocation(2) = Location(2) - floor(PatchCenter(1));
ImageMatchLocation(3) = Location(1) +  ceil(PatchCenter(2));
ImageMatchLocation(4) = Location(2) +  ceil(PatchCenter(1));

TopLeftPad = -(min(ImageMatchLocation - 1));
%BottomRightPad = max(ImageMatchLocation(3:4) - sizeI([2,1]) + [1,1]);
BottomRightPad = max(ImageMatchLocation(3:4) - sizeI([2,1]));
NecessaryPad = max(TopLeftPad, BottomRightPad);
%keyboard;
if(NecessaryPad > 0)
    Image = padimage(Image, NecessaryPad, paddingStrategy);
    ImageMatchLocation = ImageMatchLocation + NecessaryPad;
else
    NecessaryPad = 0;
end

bbox = ImageMatchLocation(1:2);
bbox(3) = ImageMatchLocation(3) - ImageMatchLocation(1) - 1;
bbox(4) = ImageMatchLocation(4) - ImageMatchLocation(2) - 1;

MatchPatch = nLayerImCrop(Image, bbox);
if(not(all(size(MatchPatch) == size(Patch))))
    fprintf('E R R O R:  Patch Sizes do not Match!!!! this should never happen\n');
    return;
end
