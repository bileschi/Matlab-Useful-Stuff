function S = OuterSum(A,B);
%function S = OuterSum(A,B);
%
%like matrix outer product, kinda.  
% Given two vectors, A, B, createa an output matrix S such that
% S(i,j) = A(i) + B(j)
%
%
% >> OuterSum([1,2,3],[10,20,30])
%
% ans =
%
%     11    21    31
%     12    22    32
%     13    23    33
 
A = A(:);
B = B(:);
A = repmat(A,[1,length(B)]);
B = repmat(B',[size(A,1),1]);
S = A + B;
