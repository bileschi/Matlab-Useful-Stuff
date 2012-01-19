
function [lab,mmax,FM,AllOuts] = MULTallpairsStanC(X,Model);
%function [lab,mmax,FM,AllOuts] = MULTallpairsStanC(X,Model);
%
if isempty(Model),
  lab = [];
  mmax = [];
  FM = [];
  return;
end
  
cclass = Model.cclass;
numc = Model.numc;
uniquey = Model.uniquey;

FM = zeros(size(X,2),numc);

if(nargout > 3)
  AllOuts = zeros((numc)*(numc-1)/2,size(X,2));, AllOutIdx = 1;
end
n = 0;
for i = 1:numc,
  for j = (i+1):numc,
    [i j]
    if ~isempty(cclass{i,j})
      eval(['[Cx,Fx] = ' Model.sPARAMS.CLASSIFIERNAME ...
            'C(X,cclass{i,j});']);
      if(nargout > 3)
        AllOuts(AllOutIdx,:) = Fx(:);, AllOutIdx = AllOutIdx + 1;
      end
      FM(:,i) = FM(:,i) + (Cx==1);
      FM(:,j) = FM(:,j) + (Cx~=1);
    else 
      'empty'
    end
  end
end

FM = FM./(numc*(numc-1)/2);
[mmax,lab] = max(FM,[],2);
lab = uniquey(lab);