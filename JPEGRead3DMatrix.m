function A = JPEGRead3DMatrix(WrappingDir, FileName);
%function JPEGWrite3DMatrix(WrappingDir, FileName);
%Version 2.0;
%
%Given the file name of a jpg matrix written with 
%JPEGWrite3DMatrix, return the full matrix off the disk.
%Bileschi May 2005
%
%November 2005 ERROR: if the directory is moved, the locations are corrupted.
%   Hack fix:  Look in the wrapping Dir instead of the the written filename


if(not(isdir(WrappingDir)));
  fprintf('ERROR %s is not a valid directory\n', WrappingDir);
end
HeadderFN = sprintf('%s__JW3DM_Headder.mat',FileName);
load(fullfile(WrappingDir,HeadderFN));%-->JPEGHead;
if(length(JPEGHead.OriginalSize) < 3), d = 1;, else, d = JPEGHead.OriginalSize(3);, end
ndigrep = ceil(log(d+1) / log(10));
FNTemplate = ['%s_JW3DM_%.',sprintf('%d',ndigrep),'d.jpg'];
A = zeros(JPEGHead.OriginalSize);
for iLay = 1:size(A,3);
   FNs{iLay} = fullfile(WrappingDir, sprintf(FNTemplate,FileName,iLay));
   % BugFix Nov2005
   % A(:,:,iLay) = im2double(imread(JPEGHead.FNs{iLay}));
   A(:,:,iLay) = im2double(imread(FNs{iLay}));
   if(not(JPEGHead.bWasUINT8))
      A(:,:,iLay) = A(:,:,iLay) * JPEGHead.Spans(iLay);
      A(:,:,iLay) = A(:,:,iLay) + JPEGHead.mins(iLay);
   end
end
if(JPEGHead.bWasUINT8)
   A = im2uint8(A);
end
