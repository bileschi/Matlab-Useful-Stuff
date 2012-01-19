function sDir = dirfull(varargin)
%function sDir = dirfull(varargin)
%
%like dir but includes a field fullname
Wildcard = fullfile(varargin{:});
imageFullNames = [];
tempFullNames = [];
tempNames = dir(Wildcard);
tempFullNames = tempNames;
[p,n,e] = fileparts(Wildcard);
if(isempty(p))
   p = pwd;
end
if(strcmpi(p,'.'));
   p = pwd;
end

for j = 1:length(tempNames)
   tempFullNames(j).path = p;
   tempFullNames(j).fullname = fullfile(p,tempFullNames(j).name);
end 
if(length(tempFullNames) > 0)
      imageFullNames = [imageFullNames;tempFullNames];
end
sDir = imageFullNames;

% 
% 
% function sDir = dirfull(Wildcard)
% %function sDir = dirfull(Wildcard)
% %
% %like dir but includes a field fullname
% imageFullNames = [];
% tempFullNames = [];
% tempNames = dir(Wildcard);
% tempFullNames = tempNames;
% [p,n,e] = fileparts(Wildcard);
% if(isempty(p))
%    p = pwd;
% end
% if(strcmpi(p,'.'));
%    p = pwd;
% end
% 
% for j = 1:length(tempNames)
%    tempFullNames(j).path = p;
%    tempFullNames(j).fullname = fullfile(p,tempFullNames(j).name);
% end 
% if(length(tempFullNames) > 0)
%       imageFullNames = [imageFullNames;tempFullNames];
% end
% sDir = imageFullNames;
