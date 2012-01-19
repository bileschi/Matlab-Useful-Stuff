function [HY,BETA] = ModelToHyperplane(M,svmname)
%function [HY,BETA] = ModelToHyperplane(M,svmname)
%
%converts a linear SVM classifier into an actual hyperplane.

if(nargin < 2)
  svmname = 'libsvm';
end
if(not(isfield(M,'sv_coef')))
   svmname = 'osusvm';
   HY = (M.AlphaY*M.SVs')';
   BETA = M.Bias;
   return
else
  HY = M.SVs'*M.sv_coef;
  BETA = M.rho;
end
X = rand(size(HY,1),1);
cmd = sprintf('[lab,score] = CLS%sC(X,M);',svmname);
eval(cmd);
myscore = (HY'*X-BETA);
if sign(myscore)~=lab
	HY = -HY;
	BETA = -BETA;
	myscore = (HY'*X-BETA);
end

z1 = abs(myscore - score);
z2 = abs(myscore + score);
if min(z1,z2) > 1e-8
   error('something is fucked up');
end	

