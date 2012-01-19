function G = SineGrating(imgSize, f, ori,phase);
%function G = SineGrating(imgSize, f, ori,phase);
%
if(nargin < 4), phase = 0;, end;
G = zeros([imgSize, imgSize]);
[X,Y] = meshgrid(1:imgSize);
dir = [sin(ori), cos(ori)];
D = X * dir(1) + Y * dir(2);
G = sin(f*D);
