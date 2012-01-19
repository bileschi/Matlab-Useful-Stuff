function [whichHost] = isHost(hostnames)
%function [whichHost] = isHost(hostnames)
%
% hostnames is a string or a cell array of strings
% returns true iff the hostname is in the cellarray (or is equal to the
% string)

if(not(iscell(hostnames)))
   hostnames = {hostnames};
end
if(ismac || isunix)
   [ok,h] = system('hostname');
else
   warning('this might not work on windows');
   [ok,h] = system('hostname');
end

b = (strcmpi(strtrim(h),hostnames));
whichHost = find(b,1);
if(isempty(whichHost))
   whichHost = 0;
end
