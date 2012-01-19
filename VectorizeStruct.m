function v = VectorizeStruct(S)
%function v = VectorizeStruct(S)
%
%
names = fieldnames(S);
for i = 1:length(names)
  thisName = names{i};
  v(i) = S.(thisName);
end
v = v(:);