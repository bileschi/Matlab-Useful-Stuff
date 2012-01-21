function f = percenctile(v,frac,bApprox);
%function f = percenctile(v,frac,bApprox);
%
% given:  matrix of real values v
%         percentile target frac in range 0 to 1
%         bApprox flag whether approximate answers are ok
%
% returns the value f such that fraction frac of v are less than f
%
% bApprox is default 0 (no approximation)

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
