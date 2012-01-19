function [bOK,err,A] = check_JPEGMatrix(WrappingDir, FileName,opts);
%function [bOK,err,A] = check_JPEGMatrix(WrappingDir, FileName,opts);
%Version 1.0;
%
%Given the file name of a jpg matrix written with 
%JPEGWrite3DMatrix check that the files exist.  If they do, check that all the files match
%the conditions set in the options, i.e. no zero layers, no NaN, no imaginary values... 
%Bileschi May 2005

d.b_isok_NaN = 0;
d.b_isok_Imaginary = 0;
d.b_isok_ZeroLayer = 0;
if(not(exist('opts')))
  opts = [];
end
opts = ResolveMissingOptions(opts,d);


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
try
  load(fullfile(WrappingDir,HeadderFN));%-->JPEGHead;
  ndigrep = ceil(log(JPEGHead.OriginalSize(3)) / log(10));
  FNTemplate = fullfile(WrappingDir, sprintf('%s_JW3DM_*.jpg',FileName));
  D = dir(FNTemplate);
  if(length(D) ~= JPEGHead.OriginalSize(3));
     bOK = 0;
     err = 'Not all files present\n';
     return;
  end
  FNTemplate = ['%s_JW3DM_%.',sprintf('%d',ndigrep),'d.jpg'];
  A = JPEGRead3DMatrix(WrappingDir, FileName);
  if(not(opts.b_isok_NaN))
     if(any(isnan(A)))
        err = 'Array has NaNs\n';
        return;
     end
  end
  if(not(opts.b_isok_Imaginary))
     if(any(not(isreal(A))))
        err = 'Array has Imaginary Values\n';
	return;
     end
  end
  if(not(opts.b_isok_ZeroLayer))
     if(any(ZeroLayer(A)))
        err = 'Array has ZeroLayers\n';
	return;
     end
  end
catch
   err = lasterr;
   return;
end
err = [];
bOK = 1; 

function b = ZeroLayer(A);
A = reshape(A,[prod([size(A,1),size(A,2)]),size(A,3)]);
b = not(any(A));