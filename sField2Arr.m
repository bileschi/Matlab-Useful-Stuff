function o = sField2Arr(s,field,n_elms_of_mat);
%function o = sField2Arr(s,field);
%
%intent: given a struct array s with numerical field field (defined for all entries of s)
%        sField2Arr will make a corresponding vector o
%  
%        if n_elms_of_mat is defined, the first n elements of each of the matricies
%           s(:).(field) will be added to each column of o.
% 
%        bSkipEmpties will remove all columns that have at least one empty array

if(isempty(s))
   o = [];
   return;
end
if(nargin < 3), n_elms_of_mat = 1;, end;
bReshape = 0;
if((length(s(:)) > length(s))&&(n_elms_of_mat == 1))
  sz = size(s);
  bReshape = 1;
  s = s(:);
end

if(nargin < 4)
  bSkipEmpties = 0;
end

if(nargin < 3)
  for i = 1:length(s);
     x = s(i).(field); 
     if(isempty(x));
       o(i) = NaN;
     else
       o(i) = x(1);
     end
  end
else
  ls = length(s);
  o = zeros(n_elms_of_mat,ls);
  for i = 1:ls
      sx = s(i).(field);
      sx = sx(:);
      if(prod(size(sx)) > 0)
        o(:,i) = sx(1:n_elms_of_mat);
      else
        o(:,i) = repmat(NaN,[n_elms_of_mat,1]);
      end
  end
end
if(bReshape)
  o = reshape(o,sz);
end


% if(bSkipEmpties)
%   sm = sum(o,1);
%   f = find(not(isnan(sm)));
%   o = o(f);
% end

% function b = NaN4Empty(a)
% b = a;
% if(isempty(a))
%   b = NaN;
% end
