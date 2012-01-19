function ShowROCDifferential(RocStructure1, RocStructure2, extrastring, Color, LineWidth)
%function ShowROC(RocStructure, extrastring, Color, LineWidth)
%
%plots tp1 - tp2 for every value of fp1

DifferentialTP = RocStructure1.normtp;
j = 1;
seedrand;
[RocStructure1,RocStructure2] = reverse(RocStructure1,RocStructure2);
if(length(RocStructure1.normfp) > 10000)
   p = randperm(length(   RocStructure1.normfp));
   p = sort(p(1:10000));
   RocStructure1.normfp = RocStructure1.normfp(p);
   RocStructure1.normtp = RocStructure1.normtp(p);
end

DifferentialTP = zeros(size(RocStructure1.normfp));
WarpIdx = zeros(size(RocStructure1.normfp));
InterpBelowPart = zeros(size(RocStructure1.normfp));

for i = 1:(length(RocStructure1.normfp)-1);
  if(mod(i,1000) == 0)
    fprintf('.');
  end
  while(RocStructure2.normfp(j)< RocStructure1.normfp(i))
     j = j+1;
   end
   WarpIdx(i) = j;
   if((RocStructure1.normfp(i+1) - RocStructure1.normfp(i)) == 0)
     InterpBelowPart(i) = 0;
     DifferentialTP(i) = RocStructure2.normtp(WarpIdx(i));
   else
     InterpBelowPart(i) = (RocStructure2.normfp(j) - RocStructure1.normfp(i)) ...
          / (RocStructure1.normfp(i+1) - RocStructure1.normfp(i));
     DifferentialTP(i) = InterpBelowPart(i) * RocStructure2.normtp(WarpIdx(i)) ...
          +  (1 - InterpBelowPart(i)) * RocStructure2.normtp(WarpIdx(i)+1);
   end
end
fprintf('\n');
DifferentialTP(end) = 1;
DifferentialTP = - DifferentialTP + RocStructure1.normtp;

if(nargin == 2)
  plot(RocStructure1.normfp, DifferentialTP);
end

if(nargin == 3)
  plot(RocStructure1.normfp, DifferentialTP, extrastring);
end

if(nargin  == 4)
  plot(RocStructure1.normfp, DifferentialTP, extrastring, 'Color', Color);
end

if(nargin  == 5)
  plot(RocStructure1.normfp, DifferentialTP, extrastring, 'Color', Color, 'LineWidth',LineWidth);
end

function [RocStructure1,RocStructure2] = reverse(RocStructure1,RocStructure2)
if(RocStructure1.normfp(end) < RocStructure1.normfp(1))
  RocStructure1.normfp = RocStructure1.normfp(end:-1:1);
end
if(RocStructure1.normtp(end) < RocStructure1.normtp(1))
  RocStructure1.normtp = RocStructure1.normtp(end:-1:1);
end
if(RocStructure2.normfp(end) < RocStructure2.normfp(1))
  RocStructure2.normfp = RocStructure2.normfp(end:-1:1);
end
if(RocStructure2.normtp(end) < RocStructure2.normtp(1))
  RocStructure2.normtp = RocStructure2.normtp(end:-1:1);
end

