function D = WindowedPatchDistance(Im,Patch)
%function D = WindowedPatchDistance(Im,Patch)
%
%computes the euclidean distance between Patch and all crops of Im of
%similar size.
%
% sum_over_p(W(p)-I(p))^2 is factored as
% sum_over_p(W(p)^2) + sum_over_p(I(p)^2) - 2*(W(p)*I(p));
%
% Im and Patch must have the same number of channels
%
% 3/20/2008 changed conv2 to filter2 and re-aligned the filter range
% so that the patch was truely being matched, not a rotation of the patch.

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
sum_support = [ceil(s(2)/2)-1,ceil(s(1)/2)-1,floor(s(2)/2),floor(s(1)/2)];
%sum_support = [floor(s(2)/2),floor(s(1)/2),ceil(s(2)/2)-1,ceil(s(1)/2)-1];
Imsq = sumfilter(Imsq,sum_support);
PI = zeros(size(Imsq));

for i = 1:dIm
	% PI = PI + conv2(Im(:,:,i),Patch(:,:,i), 'same');
   PI = PI + filter2(Patch(:,:,i),Im(:,:,i), 'same');
end

D = Imsq - 2 * PI + Psqr + 10^-10;
if(any(D(:) < 0))
   keyboard;
end
D = D.^(.5);


