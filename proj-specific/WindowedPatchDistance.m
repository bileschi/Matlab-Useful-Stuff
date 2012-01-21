function D = WindowedPatchDistance(Im,Patch,pleasestop)
%function D = WindowedPatchDistance(Im,Patch)
%
% sum_over_p(W(p)-I(p))^2 is factored as
% sum_over_p(W(p)^2) + sum_over_p(I(p)^2) - 2*(W(p)*I(p));
%
if(nargin < 3)
pleasestop = 0;
end
dIm = size(Im,3);
dPatch = size(Im,3);
if(dIm ~= dPatch)
  fprintf('The patch and image must be of the same number of layers');
end
s = size(Patch);
s(3) = dIm;
Psqr = sum(sum(sum(Patch.^2)));
Imsq = Im.^2;
Imsq = sum(Imsq,3);
%sum_support = [floor(s(2)/2),floor(s(1)/2),ceil(s(2)/2)-1,ceil(s(1)/2)-1];
sum_support = [ceil(s(2)/2)-1,ceil(s(1)/2)-1,floor(s(2)/2),floor(s(1)/2)];
Imsq = sumfilter(Imsq,sum_support);
PI = zeros(size(Imsq));
for i = 1:dIm
   PI = PI + imfilter(Im(:,:,i), Patch(:,:,i),'same','corr');
end
D = Imsq - 2 * PI + Psqr + 10^-10;
if(any(D(:)<0))
keyboard;
end
D = D.^(.5);



