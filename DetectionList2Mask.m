function mask = DetectionList2Mask(DL,inImgSize,alpha,maxExpectedStrength)
%function mask = DetectionList2Mask(DL,inImgSize,alpha,maxExpectedStrength)
%
mask = ones(inImgSize(1), inImgSize(2));
for i = 1:length(DL)
  if(DL(i).str <= 0)
     continue;
  end
  myalpha = alpha * (DL(i).str/maxExpectedStrength)^4;
  bbox = DL(i).bboxOrig;
  minx = max(1,floor(bbox(1)));
  maxx = min(inImgSize(2),ceil(bbox(1) + bbox(3)));
  miny = max(1,floor(bbox(2)));
  maxy = min(inImgSize(1), ceil(bbox(2) + bbox(4)));
  rangex = minx:maxx;
  rangey = miny:maxy;
  mask(rangey,rangex) = mask(rangey,rangex) * (1-myalpha);
end
mask = 1 - mask;
mask = min(mask,alpha);
