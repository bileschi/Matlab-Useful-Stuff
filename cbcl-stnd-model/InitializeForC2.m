function [filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cas2Target] = InitializeForC2
%function [filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,s2Target] = InitializeForC2

rot = [90 -45 0 45];
c1ScaleSS = [1:2:18];
RF_siz    = [7:2:39];
c1SpaceSS = [8:2:22];
minFS     = 7;
maxFS     = 39;
div = [4:-.05:3.2];
Div       = div;
%--- END Settings for Testing --------%

%creates the gabor filters use to extract the S1 layer
[fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, Div);

if(nargout > 5)
  cPatches = load('PatchesFromNaturalImages250per4sizes','cPatches');
  cPatches = cPatches.cPatches;
  cas2Target = cPatches;
end
