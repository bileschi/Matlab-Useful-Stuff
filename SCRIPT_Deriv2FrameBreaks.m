% SCRIPT_Deriv2FrameBreaks
%%%
clear all
cd /cbcl/scratch03/bileschi/Videos/BroadwayVideoTestFiles_DO_NOT_DISTRIBUTE
d = dir('extra/*_ChangeMag.txt');
nfs = length(d);
mypath = '/cbcl/scratch03/bileschi/Videos/BroadwayVideoTestFiles_DO_NOT_DISTRIBUTE/extra';
for i = 1:nfs
  PROC_VideoCodeToShotBoundaries(fullfile(mypath,d(i).name),[]);
end
