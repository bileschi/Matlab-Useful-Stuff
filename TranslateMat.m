function Mat = TranslateMat(Mat, Translation,FillValue,bUseCircShift);
%function t = TranslateMat(Mat, Translation,FillValue,bUseCircShift);
%
%Translation must be as long as ndim(Mat)
if(nargin < 3), FillValue = 0;, end
if(nargin < 4), bUseCircShift = 0;, end
Translation = round(Translation);
Mat = circshift(Mat,[Translation]);
sz = size(Mat);
if(bUseCircShift)
   return;
else
   if(any(abs(Translation) > sz))
      Mat = 0 * Mat;
      return;
   end
   t = zeros + FillValue;
   sc = size(Mat);
   nDims = length(size(Mat));
   for i = 1:nDims
     t = permute(Mat,[i,setdiff(1:nDims,i)]);
     sz = size(t);
     t = reshape(t,[size(t,1),prod(sz(2:end))]);
     if(Translation(i) < 0);
       t((end+Translation(i)+1):(end),:) = FillValue;
     else
       t(1:Translation(i),:) = FillValue;
     end
     t = reshape(t,sz);
     Mat = ipermute(t,[i,setdiff(1:nDims,i)]);
   end
end


