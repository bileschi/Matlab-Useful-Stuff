function s = foos(fn)
%foos('x') is an abbreviation of whos('-file','x')
try
 if(nargout == 1)
   s= whos('-file',fn);
 else
   whos('-file',fn);
 end
catch
 fprintf([lasterr,'\n']);
 
end
