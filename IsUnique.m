function b = IsUnique(x)
%function b = IsUnique(x)
%
%returns a bit matrix which is 1 for every location i that x(i) is unique
%in x
[s,si] = sort(x(:));
leftSame = [0;(s(1:(end-1)) == s(2:end))];
rightSame = [(s(1:(end-1)) == s(2:end));0];
b = not(leftSame | rightSame);
b = b(invertpermutation(si));
b = reshape(b,size(x));