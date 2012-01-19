function [v,d] = max2d(X);
%function [v,d] = max2d(X);
%
%for finding maximum of an array X
% v = max(max(X)).  X(d(1),d(2)) = v;

[v,i] = max(X);
[v,j] = max(v);
d = [i(j),j];