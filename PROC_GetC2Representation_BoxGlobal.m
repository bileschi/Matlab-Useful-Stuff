function C2_X = PROC_GetC2Representation_BoxGlobal(savename,S2Root,objname);
%fuction C2_X = PROC_GetC2Representation_BoxGlobal(savename,S2Root,objname);
%
%S2Root = '/cbcl/scratch01/bileschi/PrecomputedFeatures/StreetScenes/c2/NaturalS2Centroids_70x5';

HelpTextInfo = GetHelpTextInfo;
stillMore = 1;
partNum = 1;
while(stillMore)
  [BBoxs,SSIdxs,stillMore] = GetBBoxAndSSIdxs(objname,partNum);
  if(not(stillMore))
     break;
  end
  fprintf('BEGINNING PART NUMBER %d\n',partNum);
  [C2_X] = C2_GlobalMaxInBox(SSIdxs, BBoxs, S2Root);
  fullsavename = sprintf('%s_%s_f%.3d.mat',savename, objname,partNum);
  save(fullsavename,'C2_X','HelpTextInfo','S2Root');
  partNum = partNum + 1;
end

function [BBox, Idx,ThisExists] = GetBBoxAndSSIdxs(objname,partNum)
Root = '/cbcl/scratch01/bileschi/PrecomputedFeatures/StreetScenes/AppearanceDetector';
l = dir(fullfile(Root, sprintf('AppearanceData_128x128_%s_f%.3d.mat',objname,partNum)));
BBox = [];
Idx =[];
if(length(l) == 0)
  ThisExists = 0;
  return;
end
ThisExists = 1;
load(fullfile(Root,l(1).name));%--> myIdx, myBBox, y
BBox = myBBox;
Idx = myIdx;
