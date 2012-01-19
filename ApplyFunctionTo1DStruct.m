function [outStruct,nNonEmpty] = ApplyFunctionTo1DStruct(instruct,functionName,bIgnoreEmpties)
%function [outStruct,nNonEmpty] = ApplyFunctionTo1DStruct(instruct,functionName,bIgnoreEmpties)
%
%the function is applied to every field independantly in the structure.
%optionally, the empty fields are ignored.

if(nargin < 3)
  bIgnoreEmpties = 1;
end

fns = fieldnames(instruct);
for iFieldname = 1:length(fns)
  fn = fns{iFieldname};
  A = [];
  for j = 1:length(instruct);
    if(not(isempty(instruct(j).(fn))))
      A(end+1) = instruct(j).(fn);
    end
  end
  evalc(sprintf('outStruct.(fn) = %s(A);',functionName));
  nNonEmpty.(fn) = length(A);
end

function b = meannotisnan(a)
a = a(find(not(isnan(a))));
b = mean(a);

function b = stdnotisnan(a)
a = a(find(not(isnan(a))));
b = std(a);
