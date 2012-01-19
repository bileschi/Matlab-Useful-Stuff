function f = percenctile(v,frac,bApprox);
%function f = percenctile(v,frac,bApprox);
%
%bApprox is default 0

v = v(:);
if(nargin < 3), bApprox = 0;, end
if(length(v)>10000)&&(bApprox)
  nnecc = min(length(v),max(bApprox,1000));
  %p = randperm(length(v));
  p = randomIntegers(nnecc, length(v));
  v = v(p);
end
[s,si] = sort(v);
u = ceil(frac*length(v));
f = s(u);
