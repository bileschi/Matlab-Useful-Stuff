function [m,s,NormTP] = ShowROCcaFamily(caROC, extrastring, Color, LineWidth)
%function ShowROCcaFamily(caROC)
%
%like ShowROC, but takes a cell array of ROCs
%plots the 'mean' roc and error bars using boxplot

if(nargin < 4)
  if(nargin < 3)
    if(nargin < 2)
      extrastring = 'b-';
    end
    Color = [0 0 1];
  end
  LineWidth = .25;
end

[NormTP,normfp]= NormROCca(caROC);
m = mean(NormTP);
s = std(NormTP);
tempstructure.normtp = m;
tempstructure.normfp = normfp;
ShowROC(tempstructure, extrastring, Color, LineWidth);
hold on
tempstructure.normtp = m-s;
ShowROC(tempstructure, 'b:', Color, LineWidth);
tempstructure.normtp = m+s;
ShowROC(tempstructure, 'b:', Color, LineWidth);


function [NormTP,normfp]= NormROCca(caROC);
RESOLUTION = 3000;
nCell = length(caROC);
allfp = [0:(1/(RESOLUTION-1)):1];
% allfp = [];
% for i = 1:nCell
%   allfp = [allfp;caROC{i}.normfp];
% end
% if(length(allfp) > RESOLUTION)
%   p = randperm(length(allfp));
%   allfp = allfp(p(1:RESOLUTION));
% end
% allfp = sort(allfp);
NormTP = zeros(nCell,RESOLUTION);
for i = 1:nCell
   caROC{i} = removeduplicatefps(caROC{i});
   NormTP(i,:) = (interp1(caROC{i}.normfp,caROC{i}.normtp,allfp))';
end
normfp = allfp;

function s2 = removeduplicatefps(s1);
z = [1; s1.normfp(1:(end-1)) ~= s1.normfp(2:end)];
s2 = s1;
s2.normfp = s1.normfp(find(z));
s2.normtp = s1.normtp(find(z));
