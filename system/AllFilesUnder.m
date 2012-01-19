function sDir = AllFilesUnder(Root, wildcard)
%function sDir = AllFilesUnder(Root,wildcard)
%
%returns a list of files like dir, but recursively includes all sub directories.
%
% BUGFIX, do not include '' as the last path.
if(nargin < 2)
  wildcard = '*';
end
searchpath = genpath(Root);
if(isempty(searchpath))
   fprintf('Root is probably not a valid directory \n %s\n',Root);
   sDir = [];
   return;
end
i = 1;
z = searchpath;
while(not(isempty(z)))
   [caPaths{i},z] = strtok(z,':');
   i = i+1;
end
nSubPaths = length(caPaths) - 1;  % don't count the last (empty) path
imageFullNames = [];
tempFullNames = [];
tempNames =[];
for i = 1:nSubPaths
   tempNames = dir(fullfile(caPaths{i},wildcard));
   tempFullNames = tempNames;
   for j = 1:length(tempNames)
      tempFullNames(j).path = caPaths{i};
      tempFullNames(j).fullname = fullfile(caPaths{i},tempFullNames(j).name);
   end 
   if(length(tempFullNames) > 0)
      imageFullNames = [imageFullNames;tempFullNames];
   end
end
sDir = imageFullNames;
