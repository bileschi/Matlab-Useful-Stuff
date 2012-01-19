function D = L2_dist(dub1,dub2);
%function D = L2_dist(dub1,dub2);
%
% computes euclidean distance l2 between vectors or sets of vectors
%
%if inputs have just one non singular dimension
% then both are remade into column vectors
%
%if either input is a matrix, then the inputs are treated as sets of col vecs

if(isvector(dub1))
  dub1 = dub1(:);
end

if(isvector(dub2))
  dub2 = dub2(:);
end

D = dist2(dub1',dub2');
D = D.^.5;




function n2 = dist2(x, c)
%DIST2  Calculates squared distance between two sets of points.
%
%       Description
%       D = DIST2(X, C) takes two matrices of vectors and calculates the
%       squared Euclidean distance between them.  Both matrices must be of
%       the same column dimension.  If X has M rows and N columns, and C has
%       L rows and N columns, then the result has M rows and L columns.  The
%       I, Jth entry is the  squared distance from the Ith row of X to the
%       Jth row of C.
%
%       See also
%       GMMACTIV, KMEANS, RBFFWD
%

%       Copyright (c) Ian T Nabney (1996-2001)

[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
        error('Data dimension does not match dimension of centres')
end

n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
  ones(ndata, 1) * sum((c.^2)',1) - ...
  2.*(x*(c'));

% Rounding errors occasionally cause negative entries in n2
if any(any(n2<0))
  n2(find(n2<0)) = 0;;
end