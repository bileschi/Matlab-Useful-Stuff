function [labels,weights] = CLSlogicBoostC(X,Model);
%function [labels,weights] = CLSlogicBoostC(X,Model);
%
X = outnormalizeDataX(X,Model.normXweights);
MyX = BuildFeaturesFromRecipie(Model.saFeatureRecipie,X);
X = [X;MyX];
[labels,weights] = CLSgentleBoostC(X,Model);


function  MyX = BuildFeaturesFromRecipie(saNextFR,X);
bFeatFilled = zeros(length(saNextFR),1);
MyX = NaN(length(saNextFR), size(X,2));
while(not(all(bFeatFilled)))
  for i = 1:length(saNextFR)
    if(bFeatFilled(i)), continue, end
    if(saNextFR(i).bIsAtomic)
      MyX(i,:) = X(saNextFR(i).AtomRef,:);
      bFeatFilled(i) = 1;
      continue;
    end
    ia = saNextFR(i).LogicRef(1);
    ib = saNextFR(i).LogicRef(2);
    if(all(bFeatFilled([ia,ib])))
      if(saNextFR(i).bUseAnd)
        MyX(i,:) = min(MyX(ia,:),MyX(ib,:));
      else
        MyX(i,:) = max(MyX(ia,:),MyX(ib,:));
      end
      bFeatFilled(i) = 1;
    else
      continue;
    end
  end
end
   
