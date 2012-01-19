function S = OuterSum(A,B);
%function S = OuterSum(A,B);
%
%like matrix product, kinda.
A = A(:);
B = B(:);
A = repmat(A,[1,length(B)]);
B = repmat(B',[size(A,1),1]);
S = A + B;
