function [c1] = C1NoMax_From_S1(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,INCLUDEBORDERS,ONLYS1,s1)
%function [c1] = BileschiRespC1(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,INCLUDEBORDERS,ONLYS1,s1)
%
% maximum over scales within band, but no spatial maximum.

USE_NORMXCORR_INSTEAD = 0;
if(nargin < 7)
  INCLUDEBORDERS = 0;
end
if(nargin < 8)
  ONLYS1 = 1;
end
numScaleBands=length(c1ScaleSS)-1;  % convention: last element in c1ScaleSS is max index + 1 
numScales=c1ScaleSS(end)-1; 
%   last index in scaleSS contains scale index where next band would start, i.e., 1 after highest scale!!
numSimpleFilters=floor(length(fSiz)/numScales);
for iBand = 1:numScaleBands
  ScalesInThisBand{iBand} = c1ScaleSS(iBand):(c1ScaleSS(iBand+1) -1);
end  


% calculate local pooling (c1)
%   (1) pool over scales within band
for iBand = 1:numScaleBands
  for iFilt = 1:numSimpleFilters
    c1{iBand}(:,:,iFilt) = zeros(size(s1{iBand}{1}{iFilt}));
    for iScale = 1:length(ScalesInThisBand{iBand});
      c1{iBand}(:,:,iFilt) = max(c1{iBand}(:,:,iFilt),s1{iBand}{iScale}{iFilt});
    end
  end
end


% %   (2) pool over local neighborhood
% for iBand = 1:numScaleBands
%   poolRange = (c1SpaceSS(iBand));
%   for iFilt = 1:numSimpleFilters
% %    c1{iBand}{iFilt} = maxfilter(c1{iBand}{iFilt},[0 0 poolRange-1 poolRange-1]);
%     c1{iBand}(:,:,iFilt) = maxfilter(c1{iBand}(:,:,iFilt),[0 0 poolRange-1 poolRange-1]);
%   end
% end


%   (3) subsample
for iBand = 1:numScaleBands
  sSS=ceil(c1SpaceSS(iBand)/c1OL);
  clear T;
  for iFilt = 1:numSimpleFilters
    %c1{iBand}{iFilt} = c1{iBand}{iFilt}(1:sSS:end,1:sSS:end);
    T(:,:,iFilt) = c1{iBand}(1:sSS:end,1:sSS:end,iFilt);
  end
  c1{iBand} = T;
end


function sout = removeborders(sin,siz)
sin = unpadimage(sin, [(siz+1)/2,(siz+1)/2,(siz-1)/2,(siz-1)/2]);
sin = padarray(sin, [(siz+1)/2,(siz+1)/2],0,'pre');
sout = padarray(sin, [(siz-1)/2,(siz-1)/2],0,'post');
       

