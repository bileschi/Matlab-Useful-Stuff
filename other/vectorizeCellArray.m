function v = vectorizeCellArray(c);
%function v = vectorizeCellArray(c);
%
%works for cell arrays where each cell contains a matrix or a cell array of matricies 
%returns one vector containing the concatination of the vectorization of all the matricies
%
% WARNING: Recursive function calls for cell arrays containing cell arrays
v = [];
for i = 1:length(c)
   if(iscell(c{i}))
      v = [v;vectorizeCellArray(c{i})];
   else
      v = [v;c{i}(:)];
   end
end

%  
%  v = [];
%  for i = 1:length(c)
%     v = [v;c{i}(:)];
%  end