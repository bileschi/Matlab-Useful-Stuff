function HelpTextInfo = GetHelpTextInfo;
%function HelpTextInfo = GetHelpTextInfo;
%
%Returns the help text info of the calling function
x = dbstack;
if(length(x) < 2)
   HelpTextInfo = 'Calling From a Script will not work\n';
   return;
end
HelpTextInfo = help(x(2).name);
