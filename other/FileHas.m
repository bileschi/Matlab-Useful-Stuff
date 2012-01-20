function b = FileHas(filename, variablename)
%function b = FileHas(filename, variablename)
%
%returns true if mat file exists, is not corrupt, and contains variablename
b=0;
try
   L = whos('-file',filename);
   nvars = length(L);
   for i = 1:nvars
      if(strcmp(L(i).name,variablename))
         b = 1;
         break;
      end
   end
catch
   b = 0;
   lasterr
end