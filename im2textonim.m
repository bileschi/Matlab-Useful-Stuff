function TextonMap = im2textonim(im,options)
%function texton = im2textonim(im,options)
%
%uses the universal textons recorded in TextonCentersMalik

d.TextonPrototypeFN = '/cbcl/scratch01/bileschi/PrecomputedFeatures/StreetScenes/Textons/TextonCentersMalik';
d.Verbose = 1;

if(not(exist('options'))),options = [];, end
options = ResolveMissingOptions(options,d);

load(options.TextonPrototypeFN);%-->C;
imgb = GaborBattery_Malik(im,options);
% fullX = nLayerImage2MatrixOfPixels(imgb);
TextonMap = FindNearestTexton(imgb,C,options);

function [TextonMap,DistMap] = FindNearestTexton(FilterResponseImage,TextonCenters,options)
%function [TextonMap,DistMap] = FindNearestTexton(FilterResponseImage,TextonCenters,options)
%
%
d.Verbose = 0;
if(not(exist('options'))),options = [];, end
options = ResolveMissingOptions(options,d);

X = im2double(nLayerImage2MatrixOfPixels(FilterResponseImage));
if(size(X,1) ~= size(TextonCenters,1))
  fprintf('Dimensionality missmatch\n');
  TextonMap = [];
  return;
end
nTexC = size(TextonCenters,2);
nP = size(X,2);
D = zeros(size(X));
for i = 1:nTexC
  if(options.Verbose),fprintf('Centroid %d of %d...\r',i,nTexC);,end
  D(i,:) = sum((X - repmat(TextonCenters(:,i),[1,nP])).^2).^.5;
end
if(options.Verbose),fprintf('Centroid %d of %d...\n',i,nTexC);,end
[DistMap,TextonMap] = min(D,[],1);
s = size(FilterResponseImage);
DistMap = reshape(DistMap,s(1:2));
TextonMap = reshape(TextonMap,s(1:2));

function [PyrOut,filts] = GaborBattery_Malik(Im, options);
%function PyrOut = GaborBattery(Im, options);
%
d.Verbose = 0;
if(not(exist('options'))),options = [];, end
options = ResolveMissingOptions(options,d);

img = im2double(Im);
if(size(img,3) == 3), img = rgb2gray(img);, end

PyrOut = [];
n = 0;
for angle = 0:-30:-179
  for radius = [7,10,14]
    for is_odd = [1,0]
      n = n+1;
      if(options.Verbose)
        fprintf('Filter %d of 36...\r',n);
      end
      otherfilt = Gabor(32,radius,angle,is_odd,.33);
      Im2 = conv2(img,otherfilt,'same');
      PyrOut = cat(3,PyrOut,Im2);
      filts{n} = otherfilt;
    end
  end
end
if(options.Verbose)
  fprintf('Filter 36 of 36... done\n');
end

function filter = Gabor(filtSize,GausRad,angle,is_odd,AspectRatio)
%function filter = Gabor(FiltSize,GausRad,angle,is_odd,AspectRatio)
%
%returns a zero-mean unit norm matrix of size FiltSize
% which is like Genvelope .* directionalDeriv(GCircular)

theta     = angle*pi/180;
center    = ceil(filtSize/2);
filtSizeL = center-1;
filtSizeR = filtSize-filtSizeL-1;
sigmaq    = GausRad^2;
for i = -filtSizeL:filtSizeR
   for j = -filtSizeL:filtSizeR
      if(0)
      %if ( sqrt(i^2+j^2)>filtSize/2 )
         E = 0;
      else
         x = i*cos(theta) - j*sin(theta);
         y = i*sin(theta) + j*cos(theta);
	 if(is_odd)
	   G1 = exp(-((x+.005)^2+AspectRatio^2*y^2)/(.05*sigmaq));
	   G2 = exp(-((x-.005)^2+AspectRatio^2*y^2)/(.05*sigmaq));
           E = (G2 - G1);
	 else
	   G1 = exp(-((x+.005)^2+AspectRatio^2*y^2)/(.05*sigmaq));
	   G2 = exp(-((x)^2+AspectRatio^2*y^2)/(.05*sigmaq));
	   G3 = exp(-((x-.005)^2+AspectRatio^2*y^2)/(.05*sigmaq));
           E = (-2*G2 + G1 + G3);
         end	 
      end
   f(j+center,i+center) = E;
   end
end
f = f - mean(mean(f));
f = f ./ sqrt(sum(sum(f.^2)));
filter = f;
