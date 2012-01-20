function BinaryLayerIm = IdxImage2BinaryLayerImg(BTRSim,n_Layers)
%the unique identifiers in the case wehre n_Layers is supplied must be
%1:n_Layers
s = size(BTRSim);
if(nargin < 2)
    u = unique(BTRSim);
    nu = length(u);
else
    u = 1:n_Layers;
    nu = n_Layers;
end
BinaryLayerIm = zeros([s(1), s(2), nu]);
layer = zeros([s(1), s(2), 1]);
for i = 1:nu
    vu = u(i);
    LayerIm = zeros([s(1), s(2)]);
    LayerIm(find(BTRSim == vu)) = 1;
    BinaryLayerIm(:,:,i) = LayerIm;
end
