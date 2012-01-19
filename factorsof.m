function factors = factorsof(N,primeFactors)
%function factors = factorsof(N,primeFactors)
%
% returns a sorted vector of integers for which N/factor(i) is an integer
% uses a pretty crappy recursive implementation.
if(N) == 1
   factors =  1;
   return;
end
if(isprime(N))
   factors = [1,N];
   return;
end
if(nargin < 2)
   primeFactors = factor(N);
end
thisprime = primeFactors(1);
% subFactors := factors without the first prime
subFactors = factorsof(N/thisprime,primeFactors(2:end));
% factors := subFactors and thisprime * subFactors
factors = unique(union(subFactors,thisprime*subFactors)); % 
