function ShowDET(RocStructure, extrastring, Color, LineWidth)
%function ShowROC(RocStructure, extrastring, Color, LineWidth)
%

MissRate = (1 - RocStructure.recall);
FPPW = RocStructure.normfp;

if(nargin == 1)
  loglog(FPPW, MissRate);
end

if(nargin == 2)
  loglog(FPPW, MissRate, extrastring);
end

if(nargin  == 3)
  loglog(FPPW, MissRate, extrastring, 'Color', Color);
end

if(nargin  == 4)
  loglog(FPPW, MissRate, extrastring, 'Color', Color, 'LineWidth',LineWidth);
end

