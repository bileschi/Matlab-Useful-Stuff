function v = VectorizeStruct(S)
%function v = VectorizeStruct(S)
%
% if S is a struct where each element is a number, then v is 
% a vector of those numbers, drawn from the fields of s alphabetically
%
% a.a = 1
% a.b = 2
% VectorizeStruct(a)

names = fieldnames(S);
for i = 1:length(names)
  thisName = names{i};
  v(i) = S.(thisName);
end
v = v(:);