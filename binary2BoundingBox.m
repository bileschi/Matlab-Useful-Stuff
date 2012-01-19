function [bbox,boxIsEmpty] = binary2BoundingBox(bw1)
%function [bbox,boxIsEmpty] = binary2BoundingBox(bw1)
%
%returns a the minimum box containing the selected region in bw1
%
boxIsEmpty = 0;
if(not(any(bw1(:))))
  boxIsEmpty = 1;
  bbox = [0 0 0 0];
  return;
end
rows = any(bw1,1);
cols = any(bw1,2);
bbox(1) = min(find(rows));
bbox(2) = min(find(cols));
bbox(3) = max(find(rows)) - bbox(1);
bbox(4) = max(find(cols)) - bbox(2);
bbox = bbox(:)';
