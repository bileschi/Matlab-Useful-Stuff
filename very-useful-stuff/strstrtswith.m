function b = strstrtswith(model,test)
%function b = strstrtswith(model,test)
%
%returns a binary vector indecating whether model is the beginning of any
%of the strings in cell array of strings test (or just test, if test is a string)
if(iscell(model) && not(iscell(test)))
   tmp = test;
   test = model;
   model = tmp;
end
if(not(iscell(test)))
   test = {test};
end
for i = 1:length(test)
   N = min(length(model),length(test{i}));
   b(i) = strncmp(model,test{i},N);
end
