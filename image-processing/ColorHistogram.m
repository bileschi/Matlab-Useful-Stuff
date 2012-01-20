function H = ColorHistogram(c,options)
%function H = ColorHistogram(c,options)
%
%outputs a color vector for each crop
%
%input must be [m,n,3]

d.ColorSpace = 'rgb';
if(nargin < 2)
   options = [];
end
if(size(c,3) ~=3)
   error('must be a 3 layer image\n');
end
if(any(clamp(c,0,1) ~= c))
   c = im2double(c);
   if(any(clamp(c,0,1) ~= c))
      error('must be between 0 and 1')
   else
      warning('ColorHistogram: Input Image Converted To Double');
   end
end

Model.nFeatures = 1000;
for i = 1:3
   Model.caBinCenters{i} = .5:1:10;
   Model.caBinBoundaries{i} = .1:.1:.9;
end
c = (reshape(c,[size(c,1)*size(c,2),size(c,3)]))';
H = AdaptiveHistogramApply(c,Model);
