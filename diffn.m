function X2 =diffn(X,n)
%function X2 =diffn(X,n)
%
% computes diff of X along dimension n

s = size(X);
X = permute(X,[n,setdiff(1:length(s),n)]);
X2 = diff(X);
X2 = ipermute(X2,[n,setdiff(1:length(s),n)]);
