function CRTGeneralName
%function CRTGeneralName
 caStr{1} = '$hostname';
 x = dbstack;
 if(length(x) < 2)
   HelpTextInfo = 'Calling From a Script will not work\n';
   functionname = 'SomeScriptOrPrompt';
 else
  functionname = x(2).name;
 end
 caStr{2} = functionname;
 ChangeCRTTitle(caStr)
