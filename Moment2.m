function M = Moment2(v,c)
%function M = Moment2(v,c)
%
%assums that v is a set of point masses located at 1,2,...,length(v)
%returns average value of distance of mass from center of masses, or, alternatively, from some other point c
%

if(nargin < 2)
  c = CenterOfMass(v);
end
Mass = sum(v);
DistancesFromC = abs((1:length(v)) - c);
M = (1/Mass) * sum(DistancesFromC(:) .* v(:));