function PROC_DependantFileScrape(RootFunction,DirToWrite)
%function PROC_DependantFileScrape(RootFunction,DirToWrite)
%
%copies all files that RootFunction depends on to DirToWrite
%
%RootFunction is a string
%DirToWrite is a valid path
%
%requires hard-coded dir name of matlab install directory
% so as to not copy system files
%
%assumes any file located under the system directory is not a user-defined
% function, but a function included with matlab (not to be copied)

if(isunix)
   SYS_DIR = {'/usr/local/matlab','/boot/matlab'};
end
if(ismac)
   SYS_DIR = '/Applications/MATLAB_R2009a.app';
end
depfuns = depfun(RootFunction);
nCopy = 0;, nSkip = 0;
%keyboard;
for i = 1:length(depfuns)
   src = depfuns{i};
   [pathstr,nm,ex] = fileparts(src);
   if any(strstrtswith(SYS_DIR,pathstr(1:length(SYS_DIR))))
      % system file, skip
      fprintf('.');
      nSkip = nSkip+ 1;
      continue;
   end 
   % user-specified file, copy
   dest = fullfile(DirToWrite,nm);
   cmd = sprintf('!cp %s %s',src,[dest,ex]);
   eval(cmd);
   fprintf(' copying file %d of %d potential\n',i,length(depfuns));
   nCopy = nCopy + 1;
end
fprintf('done, %d copied %d skipped\n',nCopy,nSkip)
