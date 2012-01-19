function Model = CLSosusvm(Xtrain,Ytrain,sPARAMS);

D.KERNEL = 0;
D.C = 1;
D.DEGREE = 1;
D.COEF = 1;
D.GAMMA = 1;

Ytrain = Ytrain';

sPARAMS = ResolveMissingOptions(sPARAMS,D);

switch sPARAMS.KERNEL,
  case 0,
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = ...
	LinearSVC(Xtrain, Ytrain, sPARAMS.C);
  case 1,
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = ...
	PolySVC(Xtrain, Ytrain, sPARAMS.DEGREE, sPARAMS.C, 1,0);
  case 2,
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = ...
	PolySVC(Xtrain, Ytrain, sPARAMS.DEGREE, sPARAMS.C, 1,sPARAMS.COEF);
  case 3,
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = ...
	RbfSVC(Xtrain, Ytrain, sPARAMS.GAMMA, sPARAMS.C);
  case 0.1,
    'EARLY TERMINATION'
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = ...
	LinearSVCearlyTermination(Xtrain, Ytrain, sPARAMS.C,sPARAMS.TERMINATIONEPSILON);
    
end

Model.AlphaY = AlphaY;
Model.SVs = SVs;
Model.Bias = Bias;
Model.Parameters = Parameters;
Model.nSV = nSV;
Model.nLabel = nLabel;
Model.sPARAMS = sPARAMS;

