function ShowPR(RocStructure, extrastring, Color, LineWidth)
%function ShowPR(RocStructure, extrastring, Color, LineWidth)
%
if(nargin == 1)
  plot(RocStructure.recall, RocStructure.precision);
end

if(nargin == 2)
  plot(RocStructure.recall, RocStructure.precision, extrastring);
end

if(nargin  == 3)
  plot(RocStructure.recall, RocStructure.precision, extrastring, 'Color', Color);
end

if(nargin  == 4)
  plot(RocStructure.recall, RocStructure.precision, extrastring, 'Color', Color, 'LineWidth',LineWidth);
end
