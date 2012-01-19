function PROC_DBToNewFeature(DBname, FunctionName, NewLabel, options);
%function PROC_DBToNewFeature(DBname,FunctionName, NewLabel, options);
%
%the new file is written next to the old one. 
%only the X values are written, the y, if it exists, must be copied manually.

d.HelpTextInfo = GetHelpTextInfo;
d.ResetParallel = 0;
d.bOverwrite = 1;
d.Sourcevariablename = 'X';
d.bSplitTo50s = 0;
d.bCopyYValue = 0;
if(nargin < 3), options = [];, end;
options = ResolveMissingOptions(options,d);

[pathname,filename,extension] = fileparts(DBname);
savename = fullfile(pathname,[filename,'_',NewLabel,extension]);
fprintf('FunctionName %s...\n', FunctionName);
if(not(options.bOverwrite))
  if(exist(savename))
    fprintf('%s already exists.  No overwrite.\n',savename);
    return;
  end
end
if(options.bCopyYValue)
  [NewDataX,y] = GetNewDataX(DBname, options);
else
  [NewDataX] = GetNewDataX(DBname, options);
end
if(options.bSplitTo50s)
  bAllAreComplete = 1;
  maxnparts = ceil(size(NewDataX,2)/50);
  seedrand
  for i = randperm(maxnparts)
    PartSavename = [savename,sprintf('part_%.2dof.%2d.mat',i,maxnparts)];
    if(exist(savename))
      %% This is in case the program has been finished by another cpu already.
      fprintf('%s has been completed by another cpu.  No overwrite.\n',savename);
      return;
    end
    fprintf('Building Random Fraction %d of %d...\n',i,maxnparts);
    if(exist(PartSavename))
      fprintf('ALREADY EXISTS\n');
      continue;
    else
    Which50 = intersect(1:size(NewDataX,2),(1:50) + (i-1)*50);
    NewDataXPart = NewDataX(:,Which50);
    cmd = sprintf('saNewMats = %s(NewDataXPart,options);',FunctionName);
    eval(cmd);
    fns = fieldnames(saNewMats);
    nfns = length(fns);
    savecmd = 'save(PartSavename';
    for j = 1:nfns
      cmd = sprintf('%s = saNewMats.%s;',fns{j},fns{j});
      eval(cmd);
      savecmd = [savecmd,sprintf(',''%s''',fns{j})];
    end
    savecmd = [savecmd,');'];
    fprintf('saving %s... ',PartSavename);
    ntriesleft = 5;
    while(ntriesleft > 0)
      ntriesleft = ntriesleft -1;
        try
          eval(savecmd);
          fprintf('success\n');
          break;
        catch
          pause(ceil(rand*30))
          fprintf('ERROR, trying again\n');
          continue;
        end
        fprintf('Out of save attempts.  Perhaps Disk is full?\n');
      end
    end
  end
  % rebuild the data and save the whole
  for i = 1:maxnparts
    PartSavename = [savename,sprintf('part_%.2dof.%2d.mat',i,maxnparts)];
    try
      N = load(PartSavename);
    catch
      fprintf('THere has been an error loading the part file\n');
      fprintf('%s\n',PartSavename);
      fprintf('for consolidation\n');
      fprintf('it is possible that there was a disk error\n')
      fprintf('alternatively, two consolidation processes were working in parallel and this one\n')
      fprintf('was left behind\n\n');
      if(exist(savename))
        fprintf('Returning without error, the full savefile seems to exist\n');
        return;
      else
        fprintf('Pausing 180 seconds...');
        pause(180);        
        fprintf('After 180 seconds, the file still does not exist, there has likly been an error\n');
        continue;
      end
    end  %% try
    fns = fieldnames(N);
    nfns = length(fns);
    for j = 1:nfns
      if(strcmpi(fns{j},'options'))
        continue;
      end
      if i==1
        cmd = sprintf('%s = [];',fns{j});;
        eval(cmd);
      end
      cmd = sprintf('%s = [%s,N.%s];',fns{j},fns{j},fns{j});
      eval(cmd);
    end
  end
  savecmd = 'save(savename,''options''';
  for j = 1:nfns
    savecmd = [savecmd,sprintf(',''%s''',fns{j})];
  end  
  savecmd = [savecmd,');'];
  fprintf('saving %s\n',savename);
  ntriesleft = 5;
  while(ntriesleft > 0)
    ntriesleft = ntriesleft -1;
    try
      eval(savecmd);
      fprintf('success\n');
      break;
    catch
      pause(ceil(rand*30))
      fprintf('ERROR, trying again\n');
      continue;
    end
    fprintf('Out of save attempts.  Perhaps Disk is full?\n');
  end
else  
  % THIS CODE IS WAHT THIS FUNCTION WAS BEFORE ADDING THE bSplitTo50s part.
  cmd = sprintf('saNewMats = %s(NewDataX,options);',FunctionName);
  eval(cmd);
  fns = fieldnames(saNewMats);
  nfns = length(fns);
  savecmd = 'save(savename,''options''';
  for i = 1:nfns
    cmd = sprintf('%s = saNewMats.%s;',fns{i},fns{i});
    eval(cmd);
    savecmd = [savecmd,sprintf(',''%s''',fns{i})];
  end  
  savecmd = [savecmd,');'];
  eval(savecmd);
  fprintf('saving %s\n',savename);
end
if(options.bCopyYValue)
  savecmd = sprintf('save(-append,%s,''y'')',savename);
  eval(savecmd);
end


 
function [NewDataX,y] = GetNewDataX(DBname, options);
 y = [];
 D = load(DBname,options.Sourcevariablename);
 NewDataX = getfield(D,options.Sourcevariablename);
 if(nargout == 2);
   if(not(isfield(D,'y')))
     error('%s has no ''y''',DBname);
   end
   D = load(DBname,'y');
   y = D.y;
 end
 
