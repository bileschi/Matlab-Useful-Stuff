function ModelLibsvm = ModelOsusvm2Libsvm(ModelOsusvm)
%function ModelLibsvm = ModelOsusvm2Libsvm(ModelOsusvm)
%
% Assumes binary classification
m2 = ModelOsusvm;
m2p = m2.Parameters;
kernelType = m2p(1);
degree = m2p(2);
gamma = m2p(3);
coefficient = m2p(4);
C = m2p(5);
Cache = m2p(6);
eps = m2p(7);
SVMType = m2p(8);
nu = m2p(9);
loss_tol = m2p(10);
shrinking = m2p(11);


ModelLibsvm.Parameters = [SVMType,kernelType,degree,gamma,coefficient]';
ModelLibsvm.nr_class = 2;
ModelLibsvm.totalSV = sum(ModelOsusvm.nSV(:));
ModelLibsvm.rho = ModelOsusvm.Bias;
ModelLibsvm.Label = ModelOsusvm.nLabel';
ModelLibsvm.ProbA = [];
ModelLibsvm.ProbB = [];
ModelLibsvm.nSV = ModelOsusvm.nSV';
ModelLibsvm.sv_coef = ModelOsusvm.AlphaY';
ModelLibsvm.SVs = sparse(ModelOsusvm.SVs)';
ModelLibsvm.paramstring = sprintf('-s 0 -c %d -t %d -g %d -r %d -d %d -b 0',C,kernelType,gamma,coefficient,degree);