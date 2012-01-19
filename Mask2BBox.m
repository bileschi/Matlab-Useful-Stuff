function bbox = Mask2BBox(mask)
%function bbox = Mask2BBox(mask)
%
%
row = sum(mask,1);
col = sum(mask,2);
row = row > 0;
col = col > 0;
bbox(1) = min(find(row));
bbox(3) = max(find(row)) - bbox(1) + 1;
bbox(2) = min(find(col));
bbox(4) = max(find(col)) - bbox(2) + 1;
