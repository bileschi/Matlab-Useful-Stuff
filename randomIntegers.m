function i = randomIntegers(n,M,bUnique)
%function i = randomIntegers(n,M,bUnique)
% returns a vector of n integers from 1 to M
%
%
if(nargin < 3)
   bUnique = 0;
end
if(bUnique)
   if n > M
      error(' can not generate n unique integers < M\n');
   end
   if n > floor(M/2)
      p = randperm(M);
      i = p(1:n);
   else
      p = ceil(M*rand(n,1));
      u = unique(p);
      while (length(u) < n);
         p = [p,ceil(rand(n,1)*M)];
         u = unique(p);
      end
      p= randperm(length(u));
      i = u(p(1:n));
   end
else
   p = rand(n,1);
   i = ceil(M*p);
end
i = i(:);