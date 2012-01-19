function w = LIBSVMhyperplane(Model)
%function w = LIBSVMhyperplane(Model)
%
%for models returned by libsvm this returns a vector representing the division hyperplane.
%
w = zeros(size(Model.SVs,2),1);
w = Model.sv_coef' * Model.SVs'
