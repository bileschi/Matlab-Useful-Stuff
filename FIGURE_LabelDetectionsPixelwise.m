function out = FIGURE_LabelDetectionsPixelwise(LabelImg, SSIdx,BoundaryOn, Overlay);

if(nargin < 3)
 BoundaryOn = 1;
end
if(nargin < 4)
 Overlay = 1;
end
segmentRoot = '/cbcl/scratch01/bileschi/PrecomputedFeatures/StreetScenes/segments/700';

load CAfilelist_FilterSS;%-->CAfilelist;
originalImage = imread(CAfilelist{SSIdx}.imagename);
load(fullfile(segmentRoot,sprintf('segment_%.5d.mat',SSIdx)));%-->Boundary

if(Overlay)
  if(size(originalImage == 3))
    originalImage = rgb2gray(originalImage);
  end
  gout = zeros(size(LabelImg,1), size(LabelImg,2), 3);
  gout(:,:,1) = originalImage;
  gout(:,:,2) = originalImage;
  gout(:,:,3) = originalImage;
end

out = ones(size(LabelImg,1), size(LabelImg,2), 3);
out1 = ones(size(LabelImg,1), size(LabelImg,2));
out2 = ones(size(LabelImg,1), size(LabelImg,2));
out3 = ones(size(LabelImg,1), size(LabelImg,2));

colors = GetObjectColors;
for i = 1:9
  out1(find(LabelImg == i)) = colors{i}(1);
  out2(find(LabelImg == i)) = colors{i}(2);
  out3(find(LabelImg == i)) = colors{i}(3);
end
out(:,:,1) = out1;
out(:,:,2) = out2;
out(:,:,3) = out3;
if(Overlay)
   out = .8 * out + .2 * gout / 256;
end
if(BoundaryOn)
   if(size(Boundary,3) == 1)
      Boundary = cat(3,Boundary, Boundary, Boundary);
   end
   out(find(Boundary)) = .75 * out(find(Boundary)) + .25;
end

function c = GetObjectColors;
c{1} = [.9,.4,.1];%car
%c{1} = [.9,0,0];%car
c{2} = [0 0 0];%pedestrian
c{3} = [0 0 0];%bicycle
c{4} = [.4 .2 .05];%building
c{5} = [.3 1 .5];%tree
c{6} = [.2 .2 .2];%road
%c{6} = [.75 .75 .2];%road
c{7} = [.5 .7 1];%sky
c{8} = [0 0 0];%sidewalk
c{9} = [0 0 0];%store
