function com = CenterOfMass(v)
%function com = CenterOfMass(v)
%
%returns the approximate center of mass of vector v
%assumes v represents a set of point masses at the locations 1,2,...,length(v)
com = sum(v(:)' .* (1:length(v))) / sum(v);