function D = L2Dist(M);
%function D = L2Dist(M);
%
%D(i,j) = L2 || M(:,i), M(:,j) ||
%
% ||i|| + ||j|| - 2|| i . j||

n = size(M,2);
Msq = repmat(sum(M.^2),[n,1]);
Minner = M'*M;
D = sqrt(Msq + Msq' - 2 * Minner);
