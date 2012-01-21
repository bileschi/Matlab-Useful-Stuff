function seedrand(startState)
%function seedrand
%
%intent:  simpler to remember than the actual function to give a random seed.
%RAND('state',sum(100*clock))
if(nargin <1)
  rand('state',sum(100*clock));
else
  rand('state',startState);
end