function c1Vector = c1LayerStructure2Vector(c1Layers)
%function c1Vector = c1LayerStructure2Vector(c1Layers)
%
%undoes c1Vector2LayerStructure

nBands = length(c1Layers);
nSpacesPerBand = size(c1Layers{1},1) * size(c1Layers{1},2);
if(iscell(c1Layers{1}))
   nSpacesPerBand = size(c1Layers{1}{1},1) * size(c1Layers{1}{1},2);
else
   nSpacesPerBand = size(c1Layers{1},1) * size(c1Layers{1},2);
end
c1Vector = zeros(nBands * 4 * nSpacesPerBand,1);
for b = 1:nBands
   if(iscell(c1Layers{b}))
      n_px = size(c1Layers{b}{1},1) * size(c1Layers{b}{1},2);
   else
      n_px = size(c1Layers{b},1) * size(c1Layers{b},2);
   end
   for f = 1:4
      location = (1:n_px) + (nSpacesPerBand * (4 * (b - 1) + f - 1));
      if(iscell(c1Layers{b}))
        t = (c1Layers{b}{f});
      else
        t = (c1Layers{b}(:,:,f));
      end
      c1Vector(location(1:length(t(:)))) = t(:);
   end
end
