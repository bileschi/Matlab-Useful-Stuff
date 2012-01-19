function D = spdiag(d);

D = speye(length(d));
D(find(D)) = d;
