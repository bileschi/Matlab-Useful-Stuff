function filter = Gabor(filtSize,GausRad,angle,phase,AspectRatio,CyclesPerWindow)
%function filter = Gabor(FiltSize,GausRad,angle,phase,AspectRatio,CyclesPerWindow)
%
%returns a zero-mean unit norm matrix of size FiltSize
% which is like Genvelope .* directionalDeriv(GCircular)

theta     = angle*pi/180;
center    = ceil(filtSize/2);
filtSizeL = center-1;
filtSizeR = filtSize-filtSizeL-1;
sigmaq    = GausRad^2;
if(nargin < 6)
  CyclesPerWindow = 1;
end
for i = -filtSizeL:filtSizeR
   for j = -filtSizeL:filtSizeR
      if(0)
      %if ( sqrt(i^2+j^2)>filtSize/2 )
         E = 0;
      else
         x = i*cos(theta) - j*sin(theta);
         y = i*sin(theta) + j*cos(theta);
	 SinFilter = sin((x)*CyclesPerWindow/filtSizeR+phase);
	 EnvelopeFilter = exp(-((x)^2+AspectRatio^2*y^2)/(.05*sigmaq));
         E = SinFilter * EnvelopeFilter;
      end
   f(j+center,i+center) = E;
   end
end
f = f - mean(mean(f));
f = f ./ sqrt(sum(sum(f.^2)));
filter = f;
