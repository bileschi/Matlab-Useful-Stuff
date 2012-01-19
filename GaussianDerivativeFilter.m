function filter = GaussianDerivativeFilter(filtSize,GausRad,angle,is_odd,AspectRatio)
%function filter = GaussianDerivativeFilter(FiltSize,GausRad,angle,is_odd,AspectRatio)
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
         x = (i*cos(theta) - j*sin(theta));
         y = (i*sin(theta) + j*cos(theta));
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
