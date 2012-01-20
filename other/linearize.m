function y2 = linearize(y,x,bApprox);
%function y2 = linearize(y,x,bApprox);
%
% given input y return y2 = ax+b which minimizes L2(y,y2);
% bApprox takes a random subset of 10,000 examples and approximates regressing

if(nargin < 2)
   x= 1:length(y);
end
if(nargin < 3)
   bApprox = 0;
end   
if(bApprox)
   r = randomIntegers(min(length(y),10000),length(y),1);
   P = polyfit(Vectorize(x(r)),Vectorize(y(r)),1);
else
   P = polyfit(x(:),y(:),1);
end
y2 = polyval(P,x);