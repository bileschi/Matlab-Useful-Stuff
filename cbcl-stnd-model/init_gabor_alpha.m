function [fSiz,filters,c1OL,numSimpleFilters] = init_gabor_alpha(rot, RF_siz, Div, options)
%additional functionality by bileschi
%
% function init_gabor(rot, RF_siz, Div)
% Thomas R. Serre
% Feb. 2003

D.includelaplacianfilter = 0;
D.includegrayscalefilter = 0;
D.useRealGabors = 0;

if(nargin < 4)
  options = [];
end
options = ResolveMissingOptions(options,D);

c1OL             = 2;
numFilterSizes   = length(RF_siz);
numSimpleFilters = length(rot);
numAdditionalFilters = 0 + options.includelaplacianfilter + options.includegrayscalefilter;
numFilters       = numFilterSizes*(numSimpleFilters+numAdditionalFilters);
fSiz             = zeros(numFilters,1);	% vector with filter sizes
filters          = zeros(max(RF_siz)^2,numFilters);

lambda = RF_siz*2./Div;
sigma  = lambda.*0.8;
G      = 0.3;   % spatial aspect ratio: 0.23 < gamma < 0.92

for k = 1:numFilterSizes  
    filtSize  = RF_siz(k);
    center    = ceil(filtSize/2);
    filtSizeL = center-1;
    filtSizeR = filtSize-filtSizeL-1;
    for r = 1:numSimpleFilters
        theta     = rot(r)*pi/180;
        filtSize  = RF_siz(k);
        center    = ceil(filtSize/2);
        filtSizeL = center-1;
        filtSizeR = filtSize-filtSizeL-1;
        sigmaq    = sigma(k)^2;
        if(not(options.useRealGabors));
          for i = -filtSizeL:filtSizeR
              for j = -filtSizeL:filtSizeR
                  if ( sqrt(i^2+j^2)>filtSize/2 )
                      E = 0;
                  else
                      x = i*cos(theta) - j*sin(theta);
                      y = i*sin(theta) + j*cos(theta);
                      E = exp(-(x^2+G^2*y^2)/(2*sigmaq))*cos(2*pi*x/lambda(k));
                  end
                  f(j+center,i+center) = E;
              end
          end
        else % use real gabors
	  f = Gabor(filtSize, filtSize,theta*180/pi,0,1/1.5,8);
	end
        f = f - mean(mean(f));
        f = f ./ sqrt(sum(sum(f.^2)));
        p = (numSimpleFilters+numAdditionalFilters)*(k-1) + r;
        filters(1:filtSize^2,p)=reshape(f,filtSize^2,1);
        fSiz(p)=filtSize;
    end
    if(options.includelaplacianfilter)
        gaussrad = .1 * filtSize;
	ratio = 1.1;
        p = (numSimpleFilters+numAdditionalFilters)*(k-1) + r + 1;      
        f = fspecial('gaussian',filtSize,gaussrad*ratio) - fspecial('gaussian',filtSize,gaussrad);
        f = f - mean(mean(f));
        f = f ./ sqrt(sum(sum(f.^2)));
        filters(1:filtSize^2,p)=reshape(f,filtSize^2,1);
        fSiz(p)=filtSize;
    end
    if(options.includegrayscalefilter)
        gaussrad = .2 * filtSize;
        f = fspecial('gaussian',filtSize,gaussrad);
	f = f - min(f(:));
	f = f ./ sqrt(sum(f(:).^2));
        p = (numSimpleFilters+numAdditionalFilters)*(k-1) + r + 2;
        filters(1:filtSize^2,p)=reshape(f,filtSize^2,1);
        fSiz(p)=filtSize;
    end
end
