function o = linInterpSample(s,i);
%function o = linInterpSample(s,i);
%
% calculate the values of s at the (floating point locations) i, using
% linear interpolation.  Assume s is a function on 1:length(s), and i are
% floating point values inside [1,length(s)];
below = s(floor(i));
above = s(ceil(i));
weightOfAbove = rem(i,1);
% o = below .* (1-weightOfAbove) + above.*(weightOfAbove);
% o = below .* 1 - below .* weightOfAbove + above.*(weightOfAbove);
o = below + (above - below) .* weightOfAbove;

