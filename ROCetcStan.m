function [stSoStat] = ROCetcStan(o,labels,bSpeedup)
%randomize the examples order.
%If there are many with the same o value, then simply sorting will keep the input order
%which can have strong effects on the ROC appearance.

o = o(:);
labels = labels(:);

u = unique(o);
if(length(u) <= 2)
  fprintf('The first input has only 1 or 2 values, are you sure the inputs are not switched?\n');
end
u = unique(labels);
if(length(u) == 1)
  fprintf('there is only one possible label, no information is available\n');
end
if(length(intersect(u,[0,1])) == 2)
  fprintf('labels is [0,1] instead of (traditional) [-1,1]\n');
  fprintf('may not be compatable with older version of CLS\n');
  labels = 2*labels - 1;
end
if(nargin < 3)
  bSpeedup = 0;
end


u = unique(labels);
if(bSpeedup)
  z1 = find(labels == u(1));
  z2 = find(labels == u(2));
  if(length(z1) > 5000)
    p = randperm(length(z1));
    z1 = z1(p(1:5000));
  end
  if(length(z2) > 5000)
    p = randperm(length(z2));
    z2 = z2(p(1:5000));
  end
  o = o([z1(:);z2(:)]);
  labels = labels([z1(:);z2(:)]);
end

l = length(o);
p = randperm(l);
o = o(p);
labels = labels(p);

[sotedo,sind] = sort(o);
slab = labels(sind);
n = length(o);
np = sum(labels>0);
nn = sum(labels<0);

stSoStat.np = np;
stSoStat.nn = nn;
stSoStat.n = n;

stSoStat.tp = zeros(n,1);
stSoStat.tn = zeros(n,1);
stSoStat.fp = zeros(n,1);
stSoStat.fn = zeros(n,1);
stSoStat.nr = zeros(n,1);

%for i = n:-1:0,
%       stSoStat.tp(i+1) = sum(slab(i+1:end)>0);
%       stSoStat.fp(i+1) = sum(slab(i+1:end)<=0);
%       stSoStat.tn(i+1) = sum(slab(1:i)<0);
%       stSoStat.fn(i+1) = sum(slab(1:i)>=0);
%       stSoStat.nr(i+1) = n-i;
%end
stSoStat.tp(n+1) = sum(slab(n+1:end)>0);
stSoStat.fp(n+1) = sum(slab(n+1:end)<=0);
stSoStat.tn(n+1) = sum(slab(1:n)<0);
stSoStat.fn(n+1) = sum(slab(1:n)>=0);
stSoStat.nr(n+1) = 0;
for i = ((n-1):(-1):(1)),
        stSoStat.tp(i+1) = stSoStat.tp(i+2) + (slab(i+1)>0);
        stSoStat.fp(i+1) = stSoStat.fp(i+2) + (slab(i+1)<=0);
        stSoStat.tn(i+1) = stSoStat.tn(i+2) - (slab(i)<0);
        stSoStat.fn(i+1) = stSoStat.fn(i+2) - (slab(i)>=0);
        stSoStat.nr(i+1) = n-i;
end
stSoStat.tp(1) = stSoStat.tp(2) + (slab(1)>0);
stSoStat.fp(1) = stSoStat.fp(2) + (slab(1)<=0);
stSoStat.tn(1) = stSoStat.tn(2);
stSoStat.fn(1) = stSoStat.fn(2);
stSoStat.nr(1) = n;



if np
  stSoStat.recall = stSoStat.tp ./ np;
else
  stSoStat.recall = ones(n+1,1);
end

stSoStat.precision = [stSoStat.tp(1:n) ./ stSoStat.nr(1:n);1];

stSoStat.normfp = stSoStat.fp./nn;
stSoStat.normtp = stSoStat.tp./np;
stSoStat.auc = auc2(stSoStat.normfp,stSoStat.normtp);

stSoStat2 = stSoStat;
%less than chance means we could operate in reverse and improve performance.
if(stSoStat.auc < .4)
  fprintf('flipROC');
%if(stSoStat.lowfpauc < .005)
  stSoStat2.tp = stSoStat.fp;
  stSoStat2.fp = stSoStat.tp;
  stSoStat2.tn = stSoStat.fn;
  stSoStat2.fn = stSoStat.tn;

%  stSoStat2.tp = stSoStat.fp;
%  stSoStat2.fp = stSoStat.tp;
%  stSoStat2.tn = stSoStat.fn;
%  stSoStat2.fn = stSoStat.tn;
end
stSoStat = stSoStat2;

if np
  stSoStat.recall = stSoStat.tp ./ np;
else
  stSoStat.recall = ones(n+1,1);
end

stSoStat.precision = [stSoStat.tp(1:n) ./ stSoStat.nr(1:n);1];

stSoStat.normfp = stSoStat.fp./nn;
stSoStat.normtp = stSoStat.tp./np;

stSoStat.auc = auc2(stSoStat.normfp,stSoStat.normtp);
lfp = find(stSoStat.normfp <= .1);
stSoStat.auc10 = 10 * auc2(stSoStat.normfp(lfp),stSoStat.normtp(lfp));
lfp = find(stSoStat.normfp <= .01);
stSoStat.auc100 = 100 * auc2(stSoStat.normfp(lfp),stSoStat.normtp(lfp));
lfp = find(stSoStat.normfp <= .001);
stSoStat.auc1000 = 1000 * auc2(stSoStat.normfp(lfp),stSoStat.normtp(lfp));
lfp = find(stSoStat.normfp <= .0001);
stSoStat.auc10000 = 10000 * auc2(stSoStat.normfp(lfp),stSoStat.normtp(lfp));

stSoStat.EqualErrorRate = ApproximateEqualErrorRate(stSoStat.normfp, stSoStat.normtp);

% stSoStat.dPrime = CalculateDPrime(o(find(labels > 0)),o(find(labels < 0)));

function E = ApproximateEqualErrorRate(fp,tp);
%this is an approximation to the equal error rate, which must be calculated as an interpolated value
%between the points where the fp < tp, and where fp > tp, intersects the line tp = (1-fp);
toolow = find(fp < (1-tp));
toohigh = find(fp >= (1-tp));
if(max(toolow) < min(toohigh))
  iLow = max(toolow);
  iHi = min(toohigh);
else
  iHi = min(toolow);
  iLow = max(toohigh);
end
dLow = abs(fp(iLow) - (1-tp(iLow)));
dHi = abs(fp(iHi) - (1-tp(iHi)));
dSum = dLow + dHi;
E = (fp(iLow) * dHi + fp(iHi) * dLow) / (dSum);
