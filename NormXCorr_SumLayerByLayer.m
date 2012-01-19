function Arr2d = NormXCorr_SumLayerByLayer(Patch3d,Arr3d,bReweightLayers)
%function Arr2d = NormXCorr_SumLayerByLayer(Arr3d,Patch3d,bReweightLayers)
%
%Arr3d and Patch3d must have the same depth
%computes the norm x corr of Arr3d(:,:,i) with Patch3d(:,:,i)
%and adds them all up
%If bReweightLayers == 1, then the sum will be weighted by the norm of the 
%mean-normalized layers.  Layers with more variance will be weighted more heavily.

d1 = size(Arr3d,3);
d2 = size(Patch3d,3);
if(d1 ~= d2)
  error('patches must be same depth\n');
end
if(nargin < 3)
  bReweightLayers = 0;
end;
if(no_size_compatability(size(Patch3d),size(Arr3d)))
  error('image long patch tall, cant normxcorr2 \n');
end
if(left_one_bigger(size(Patch3d),size(Arr3d)))
  fprintf('had to switch input\n');
  [Patch3d,Arr3d] = switch_names(Patch3d,Arr3d);
end
Arr3d = Arr3d + rand(size(Arr3d)) * .01 * var(Arr3d(:));
w = ones(size(Patch3d,3),1);
if(bReweightLayers)
  for i = 1:size(Patch3d,3)
    v = Patch3d(:,:,i);
    v=v(:);
    w(i) = norm(v - mean(v));
  end
end
w = w / norm(w);

Arr2d = zeros(size(Arr3d,1),size(Arr3d,2));
t = floor(size(Patch3d,1)/2);
b = ceil(size(Patch3d,1)/2);
l = floor(size(Patch3d,2)/2);
r = ceil(size(Patch3d,2)/2);

for i = 1:d1
   z1 = normxcorr2(Patch3d(:,:,i),Arr3d(:,:,i));
   z2 = z1(t:(end-b),l:(end-r));
   Arr2d = Arr2d + w(i) * z2;
end


function [a,b] = switch_names(a,b);
t = a;
a = b;
b = t;

function b= left_one_bigger(s1,s2)
  b = 0;
  if(s2(1) < s1(1))
    b = 1;
  end
   
function b = no_size_compatability(s1,s2);
  lr = s1(1) > s2(1);
  ud = s1(2) > s2(2);
  b = xor(lr,ud);
  
