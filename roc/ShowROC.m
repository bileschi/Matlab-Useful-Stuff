function ShowROC(RocStructure, extrastring, Color, LineWidth)
%function ShowROC(RocStructure, extrastring, Color, LineWidth)
%
if(nargin == 1)
  plot(RocStructure.normfp, RocStructure.normtp);
end

if(nargin == 2)
  plot(RocStructure.normfp, RocStructure.normtp, extrastring);
end

if(nargin  == 3)
  plot(RocStructure.normfp, RocStructure.normtp, extrastring, 'Color', Color);
end

if(nargin  == 4)
  plot(RocStructure.normfp, RocStructure.normtp, extrastring, 'Color', Color, 'LineWidth',LineWidth);
end

