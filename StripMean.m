function [A,m] = StripMean(A,dirOfVecs);
%function A = StripMean(A,dirOfVecs);
%
%Aout is Ain with the mean vector subtracted.
%dir 1 uses a mean vector column, dir 2 uses a mean vector row
% dir1 is default
if(nargin < 2)
    dirOfVecs = 1;
end
if(dirOfVecs == 1)
    m = mean(A,2);
    A = A - repmat(m,[1,size(A,2)]);
else
    m = mean(A,1);
    A = A - repmat(m,[size(A,1),1]);
end
