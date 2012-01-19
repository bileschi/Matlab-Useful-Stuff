function [g,d] = GaussianValue(M,Cov,mu);
% M is n*q
n = size(M,1);
q = size(M,2);
if(nargin < 3), mu = zeros([n,1]);, end
mu = mu(:);
M = M - repmat(mu,[1,q]);
d = length(Cov);
if(n~=d), error('Missmatched Dimensions\n');, end
norm = 1/((2*pi)^(d/2)*det(inv(Cov))^(.5));
d = sum(M.* (Cov*M));
g = exp(-(.5)*d);
g = norm*g;
  
