function [bOK,err] = exist_JPEGMatrix(WrappingDir, FileName);
%function [bOK,err] = exist_JPEGMatrix(WrappingDir, FileName);
%Version 1.0;
%
%Given the file name of a jpg matrix written with 
%JPEGWrite3DMatrix check that the files exist.  There is no way to tell if the files
%are not corrupt with out (expensively) loading them all.  To be safe, one might run
%JPEGRead3DMatrix within a try-catch loop.
%Bileschi May 2005

bOK = 0;
if(not(isdir(WrappingDir)));
  fprintf('ERROR %s is not a valid directory\n', WrappingDir);
  return;
end
HeadderFN = sprintf('%s__JW3DM_Headder.mat',FileName);
if(not(exist(fullfile(WrappingDir,HeadderFN))))
  bOK = 0;
  return;
end
%try
  load(fullfile(WrappingDir,HeadderFN));%-->JPEGHead;
  ndigrep = ceil(log(JPEGHead.OriginalSize(3)) / log(10));
  %FNTemplate = ['%s_JW3DM_%.',sprintf('%d',ndigrep),'d.jpg'];
  FNTemplate = fullfile(WrappingDir, sprintf('%s_JW3DM_*.jpg',FileName));
  D = dir(FNTemplate);
  if(length(D) ~= JPEGHead.OriginalSize(3));
     bOK = 0;
     return;
  end
  %for iLay = 1:JPEGHead.OriginalSize(3);
  %   FNs{iLay} = fullfile(WrappingDir, sprintf(FNTemplate,FileName,iLay));
  %   if(not(exist(FNs{iLay}) == 2))
  %      fprintf('%s\n no existo\n',FNs{iLay});
  %	return;
  %   end
  %end
%catch
%   err = lasterr;
%   return;
%end
err = [];
bOK = 1; 
