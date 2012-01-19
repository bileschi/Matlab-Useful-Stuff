function subDirNames = ListSubDirectories(Root);
% function subDirNames = ListSubDirectories(Root);
%
% like dir but only returns sub directories

d = dir(Root);  % will include . and ..
subDirNames = [];
n = 0;
for i = 1:length(d);
  if(d(i).isdir)
     if(strcmpi(d(i).name,'.'))
       continue;
     end
     if(strcmpi(d(i).name,'..'))
       continue;
     end     
     n = n+1;
     subDirNames(n).name = d(i).name;  
     subDirNames(n).date = d(i).date;  
     subDirNames(n).bytes = d(i).bytes;  
     subDirNames(n).isdir = d(i).isdir;
   end
end 
 