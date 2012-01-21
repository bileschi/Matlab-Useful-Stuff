function spim = spimage(fi,fj,sz,v);
%function spim = spImage(fi,fj,sz.v);
%
%creates an image of minimum size whos elements are zero except for all elements (fi(i),fj(i))
%whose values are v.  size(fi) must == size(fj)
% if values v are not supplied, v = ones
%
% >> spimage([1,2,5],[1,2,4])
%
% ans =
%
%      1     0     0     0
%      0     1     0     0
%      0     0     0     0
%      0     0     0     0
%      0     0     0     1

if(any(size(fi) ~= size(fj)))
   error('size fi must equal size fj');
end
if(isempty(fi))
  spim = [];
  return
end
if(nargin < 3)
   sz = [];
end
if(isempty(sz))
   sz(1) = max(fi);
   sz(2) = max(fj);
end
spim = zeros(sz(1),sz(2));
if(nargin < 4)
   v = ones(length(fi),1);
end
for iElm = 1:length(fi)
   spim(fi(iElm),fj(iElm)) = v(iElm);
end
