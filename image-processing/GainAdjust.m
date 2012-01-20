function [outim,multiplier] = GainAdjust(inim,maxmult)
% function [outim,multiplier] = GainAdjust(inim,maxmult)
%
% assumes inim is a grayscale image between 0 and 1.  If the max of inim is 
% less than 1, it will multiply inim by x where x is 1 / max(inim).
%
% x is limited by maxmult, which defaults to 2, to prevent over normalizing
% images which are menat to be all black.

if(nargin < 2)
  maxmult = 2;
end
outim = clamp(inim,0,1);
M = percentile(inim(:),1,10000);
% this returns the maximum of 10,000 random samples from inim
if( M == 0)
   multiplier = maxmult;
   return;
end
multiplier = min(maxmult, 1/M);
outim = multiplier * outim;
