function [labels,weights,firstindeces] = CLSnnC(X,Model);
%function [labels,weights,firstindeces] = CLSnnC(X,Model);
%
%X contains the data-points to be classified as COLUMNS, i.e., it is nfeatures \times nexamples
%Model is the model returned by CLSnn
%labels are the predicted labels
%
%
%Inputs:
%Model.k
%Model.trainX 
%Model.trainy 
%
%See also CLSnn
if isfield(Model,'deg')
  deg = Model.deg;
else 
  deg = 2;
end

len1 = size(X,2);
len2 = size(Model.trainX,2);
if deg==2
  X2 = sum((X).^2,1);
  Z2 = sum((Model.trainX).^2,1);
  distance = (repmat(Z2,len1,1)+repmat(X2',1,len2)-2*X'*Model.trainX)';
else
  distance = zeros(len2,len1);
  for i = 1:len1,
    for j = 1:len2,
      distance(j,i) = sum(abs(X(:,i)-Model.trainX(:,j)).^deg);
    end
  end
end

[sorted,index] = sort(distance);
yy = Model.trainy(index);
if Model.k>1
  weights = mean(yy(1:Model.k,:),1)';
  disp('kNN weights::just sign no voting');
  labels = sign(weights);
else
  labels = yy(1,:)';
  weights = 1./(sorted(1,:)'+eps);
end

if nargout>2
  numindeces = min(size(sorted,1),Model.numindeces);
  firstindeces = yy(1:numindeces,:)';
end

