function o = clamp(in,lowerbound,upperbound);
if(nargin == 2)
  if(length(lowerbound == 2))
    upperbound = lowerbound(2);
    lowerbound = lowerbound(1);
  end
end
o = min(upperbound,max(lowerbound,in));
