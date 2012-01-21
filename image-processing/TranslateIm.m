function t = TranslateIm(convIm, Translation,FillValue);
%function t = TranslateIm(convIm, Translation,FillValue=0);
%
% third value can be modified to include any constant fill value
% output is the same size as the input.
if(nargin < 3), FillValue = 0;, end
Translation = round(Translation);
t = zeros(size(convIm));
for L = 1:size(convIm,3)
  t(:,:,L) = circshift(convIm(:,:,L),[Translation]);
end
sc = size(convIm);
Translation = min(Translation,sc(1:2));
Translation = max(Translation,-sc(1:2) + 1);
if(Translation(1) < 0);
  t((end+Translation(1)):(end),:,:) = FillValue;
else
  t(1:Translation(1)+1,:,:) = FillValue;
end
if(Translation(2) < 0);
  t(:,(end+Translation(2)+1):(end),:) = FillValue;
else
  t(:,1:Translation(2),:) = FillValue;
end
