function Y = BinaryStructToMat(S)
%function Y = BinaryStructToMat(S)
names = fieldnames(S);
for i = 1:length(S)
   v = VectorizeStruct(S(i));
   Y(:,i) = v;
end