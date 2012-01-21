function C = RainbowColor(n,ofhowmany)
% function C = RainbowColor(n,ofhowmany)
%
% returns a unique color in RGB along the rainbow

h = n/ofhowmany;
C = hsv2rgb(h,1,1);