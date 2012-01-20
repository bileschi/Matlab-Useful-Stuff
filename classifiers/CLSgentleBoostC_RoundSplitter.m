function [labels,weights] = CLSgentleBoostC_RoundSplitter(X,Model);

if ~Model.Nbagging 
  [Cx,Fx] = strongGentleClassifier_RoundSplitter(X,Model.classifier); 
  weights = Fx;
  Cx = (Cx+3)/2;
else
  Cx = [];
  Fx = [];
  for i = 1:Model.Nbagging,
    [tCx,tFx] = strongGentleClassifier_RoundSplitter(X,Model.classifier{i});
    tCx = tCx';
    tFx = tFx';
    Cx = [Cx, tCx];
    Fx = [Fx, tFx];
  end
 
  if 0 
    weights = mean(Fx')';
  else
    weights = mean(Cx')';
  end
  Cx = sign(sum(Cx')');
  Cx = (Cx+3)/2;
end
labels = Model.uniquey(floor(Cx));


function [Cx, Fx] = strongGentleClassifier_RoundSplitter(x, classifier)
% [Cx, Fx] = strongLogitClassifier(x, classifier)
%
% Cx is the predicted class 
% Fx is the output of the additive model
% Cx = sign(Fx)
%
% In general, Fx is more useful than Cx.
%
% The weak classifiers are stumps

% Friedman, J. H., Hastie, T. and Tibshirani, R. 
% "Additive Logistic Regression: a Statistical View of Boosting." (Aug. 1998) 

% atb, 2003
% torralba@ai.mit.edu

Nstages = length(classifier);
[Nfeatures, Nsamples] = size(x); % Nsamples = Number of thresholds that we will consider

Fx = zeros(Nstages, Nsamples);
for m = 1:Nstages
    featureNdx = classifier(m).featureNdx;
    th = classifier(m).th;
    a = classifier(m).a;
    b = classifier(m).b;
    if(m == 1)
      Fx(m,:) = Fx(m,:) + (a * (x(featureNdx,:)>th) + b); %add regression stump
    else
      Fx(m,:) = Fx(m-1,:) + (a * (x(featureNdx,:)>th) + b); %add regression stump
    end
end

Cx = sign(Fx);
