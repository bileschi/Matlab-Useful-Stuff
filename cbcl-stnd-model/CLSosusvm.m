function Model = CLSosusvm(Xtrain,Ytrain,sPARAMS);
%function Model = CLSosusvm(Xtrain,Ytrain,sPARAMS);
%
%Builds an SVM classifier
%This is only a wrapper function for osu svm
%It requires that osu svm (http://www.ece.osu.edu/~maj/osu_svm/) is installed and included in the path
%X contains the data-points as COLUMNS, i.e., X is nfeatures \times nexamples
%y is a column vector of all the labels. y is nexamples \times 1
%sPARAMS is a structure of parameters:
%sPARAMS.KERNEL specifies the kernel type
%sPARAMS.C specifies the regularization constant
%sPARAMS.GAMMA, sPARAMS.DEGREE are parameters of the kernel function
%Model contains the parameters of the SVM model as returned by osu svm

Ytrain = Ytrain';
if nargin<3
  SETPARAMS = 1;
elseif isempty(sPARAMS)
  SETPARAMS = 1;
else
  SETPARAMS = 0;
end

if SETPARAMS
  sPARAMS.KERNEL = 0;
  sPARAMS.C = 1;
end

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
end

Model.AlphaY = AlphaY;
Model.SVs = SVs;
Model.Bias = Bias;
Model.Parameters = Parameters;
Model.nSV = nSV;
Model.nLabel = nLabel;
Model.sPARAMS = sPARAMS;

