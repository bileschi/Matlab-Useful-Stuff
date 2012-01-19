function PROC_DBToNewFeature_CleanUpFileFractions(DBname,NewLabel);
% function PROC_DBToNewFeature_CleanUpFileFractions(DBname);
% 
if(nargin > 1)
  [pathname,filename,extension] = fileparts(DBname);
  DBname = fullfile(pathname,[filename,'_',NewLabel,extension]);
end
nparts = length(dir([DBname,'part_*of*.mat']))
 for i = 1:20
   PartSavename = [DBname,sprintf('part_%.2dof.%2d.mat',i,nparts)];
   if(exist(PartSavename))
     delete(PartSavename);
     fprintf('%s deleted \n',PartSavename);
   end
 end
