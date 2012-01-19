function ChangeCRTTitle(caStr)
% caStr is a cell array of strings to make the new title
% $hostname is replaced by the actual host-name
% $functionname is replaced by the calling function
hostname = evalc('!hostname');
hostname = hostname(end-7:end-1);
hostname = hostname([1,6:end]);
x = dbstack;
if(length(x) < 2)
   HelpTextInfo = 'Calling From a Script will not work\n';
   functionname = 'SomeScriptOrPrompt';
else
  functionname = x(2).name;
end
newname = [];
for i = 1:length(caStr)
  if(strcmpi(caStr{i},'$hostname'))
    newname = [newname,' ',hostname];
    continue;
  end
  if(strcmpi(caStr{i},'$functionname'))
    newname = [newname,' ',functionname];
    continue;
  end
  newname = [newname,' ',caStr{i}];
end  
eval(['!~liorwolf/title "',newname,'"']);
