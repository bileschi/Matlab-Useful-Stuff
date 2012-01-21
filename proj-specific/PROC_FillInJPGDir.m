function PROC_FillInJPGDir(Root,sprintfFormat,LastNum,FirstNum)
% PROC_FillInJPGDir(Root,sprintfFormat,LastNum,FirstNum)
%
% given a directory full of enumerated jpgs and a pattern for those jpgs
% this will go through and find any holes.  LastNum defaults to the largest num found
% and FirstNum defaults to 1
%
% sample input
% Root = '/cbcl/scratch01/bileschi/Video/Raytheon/20minSamples/Sample1/Ped'
% sprintfFormat = 'pedestrianDetect_%.6d.jpg'
% LastNum = 1202
% FirstNum = 1
%
% Bug: current version will not write files less than the first file.  Fix later.
if(nargin < 4)
   FirstNum = 1;
end
d = dir(Root);
maxNum = 0;
noFmtSprintf = RemoveFormattingNum(sprintfFormat);
n=0;
detectedNums = [];
for i = 1:length(d)
   [a,b] = sscanf(d(i).name,noFmtSprintf);
   if(b>=1)
      n = n+1;
      detectedNums(n)= a(1);
   end
end
if(length(detectedNums) < 2)
   fprintf('error: detected fewer than 2 images that match the template\n');
   fprintf('%s\n',fullfile(Root,noFmtSprintf))
   return;
end
if(nargin < 3)
   LastNum = max(detectedNums);
end
loadedMostRecent = 0;
mostRecent = 0;
for i = FirstNum:LastNum
   if(exist(fullfile(Root,sprintf(sprintfFormat,i))))
      loadedMostRecent = 0;
      mostRecent = i;
      continue;
   end
   if not(loadedMostRecent)
      im = imread(fullfile(Root,sprintf(sprintfFormat,mostRecent)));
   end
   %keyboard;
   imwrite(im,fullfile(Root,sprintf(sprintfFormat,i)),'jpg');
   fprintf('filling in %d of %d\r',i,LastNum);
end
fprintf('\n');
function s2 = RemoveFormattingNum(s1)
% removes the first instance of .? where ? is an integer between 0 and 9
%
[a,b] = strtok(s1,'.');
s2 = [a,b(4:end)];
