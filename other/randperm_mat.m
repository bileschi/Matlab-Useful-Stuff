function [v2,p] = randperm_mat(v)
%function [v2,p] = randperm_mat(v)
%
%returns a matrix the same size as v with the elements permuted such that v2 = v(p);
p = randperm(length(v(:)));
v2 = v(p);
v2 = reshape(v2,size(v));