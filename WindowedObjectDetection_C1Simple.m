function [caDetectionStrength] = WindowedObjectDetection_C1Simple(img,Model,options)
%function [caDetectionStrength] = WindowedObjectDetection_C1Simple(img,Model,Options)
%
%
d.modelXYResolution = [16 16];
d.scaleFactor = 2^(1/8);  % scale factor between neighboring scales
d.scaleLimitBigger = 2.01; % size by which the maximum sized image will be increased
d.scaleLimitSmaller = 0; % size by which the minimum sized image will be decreased 
                         %(0 means the smallest will be limited by options.ModelXYResolution
d.ClassifierName = 'gentleBoost';
if(nargin < 3)
   options = [];
end
options = ResolveMissingOptions(options,d);

img = MyPreprocess(img);
fprintf('computing pyramid.');
caPyr = ImageToPyramid(img,options);
fprintf('done\n');
nLevls = length(caPyr);
for iScal = 1:nLevls
   c1 = Im2ReducedC1LapGS(caPyr{iScal});
   [threshdVer,caDetectionStrength{iScal}] = WindowedObjectDetection2(Model,options.modelXYResolution,c1,options);
   fprintf('detecting at scale %d of %d\r',iScal,nLevls);
end
fprintf('\n');

function caPyr = ImageToPyramid(img,options);
sf = options.scaleFactor;
mxyr = options.modelXYResolution;
% the c1 img is 8 times smaller than the input image in x,y
minScaleFactor = max(options.scaleLimitSmaller,max(8*mxyr./ size(img)));
maxScaleFactor = options.scaleLimitBigger;
maxScaleRepeats = floor(log(maxScaleFactor)/log(sf));
minScaleRepeats = ceil(log(minScaleFactor)/log(sf));
myScales = sf.^(minScaleRepeats:maxScaleRepeats);
%keyboard;
nScales = length(myScales);
for i = 1:nScales
   caPyr{i} = imresize(img,myScales(i),'bilinear');
   fprintf('.');
end


function out = MyPreprocess(in);
if(size(in,3) > 1)
   in = rgb2gray(in);
end
in = im2double(in);
if(max(max(in)) > 2)
   in = in / 255;
end
out = in;




