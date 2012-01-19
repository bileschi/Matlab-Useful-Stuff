function [v,d] = min2d(A)
%function [v,d] = min2d(A)
%
% v is the minimum of the 2d array, v = A(d(1),d(2));
[v,d] = max2d(-A);
v = -v;