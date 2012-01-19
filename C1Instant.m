function [c1,vc1] = C1Instant(im);
%function [c1,vc1] = C1Instant(im);
%
%optionless version of c1 using the most common parameter values
% returns both the cell array and vector versions of c1
%
% for refererence the regions of the vector corresponding to the 
% different bands are:
%
%
%      1 :  4096
%      4097 : 6800
%      6801 : 8736
%      8737 :10180
%     10181 :11204
%     11205 :12104
%     12105 :12780
%     12781 :13356



if(size(im, 3) > 1)
  im = rgb2gray(im);
end
im = imresize(im,[128 128],'bilinear');
stim = double(im) / 255.0;

rot = [90 -45 0 45];
c1ScaleSS = [1:2:18];
RF_siz    = [7:2:39];
c1SpaceSS = [8:2:22];
minFS     = 7;
maxFS     = 39;
div = [4:-.05:3.2];
Div       = div;
[fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, Div);

c1 = C1(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL);
if(nargout > 1)
  vc1 = vectorizeCellArray(c1);
end
