function JPEGWrite3DMatrix(A, WrappingDir, FileName);
%function JPEGWrite3DMatrix(A, WrappingDir, FileName);
%Version 1.0;
%
%writes a compressed matrix to disk.
%
%Given Matrix A, record a JPG compressed copy of the matrix in a folder named WrappingDir.
%Each layer of the matrix A(:,:,i) will be stored in a separate
%jpg image.  A top level file will contain the necessary information for reconstruction.
%JPEGWrite3DMatrix is a lossy compression.
%
%Each unique pair of WrappingDir and FileName must correspond to only one matrix A.
%Bileschi May 2005
if(not(isdir(WrappingDir)));
  fprintf('ERROR %s is not a valid directory\n', WrappingDir);
end
JPEGHead.Version = 1.0;
JPEGHead.OriginalSize = size(A);
JPEGHead.bWasUINT8 = isa(A,'uint8');

%CreateTheHeadderFile
HeadderFN = sprintf('%s__JW3DM_Headder.mat',FileName);
ndigrep = ceil(log(size(A,3)+1) / log(10));
FNTemplate = ['%s_JW3DM_%.',sprintf('%d',ndigrep),'d.jpg'];

if(JPEGHead.bWasUINT8)
   for iLay = 1:size(A,3);
      FNs{iLay} = fullfile(WrappingDir, sprintf(FNTemplate,FileName,iLay));
      imwrite(A(:,:,iLay),FNs{iLay},'jpg','Quality',100);
   end

else
   for iLay = 1:size(A,3);
      mins(iLay) = min(min(A(:,:,iLay)));
      A(:,:,iLay) = A(:,:,iLay) - mins(iLay);
      Spans(iLay) = max(max(A(:,:,iLay)));
      A(:,:,iLay) = A(:,:,iLay) / Spans(iLay);
      FNs{iLay} = fullfile(WrappingDir, sprintf(FNTemplate,FileName,iLay));
      imwrite(A(:,:,iLay),FNs{iLay},'jpg','Quality',100);
   end
   JPEGHead.mins = mins;
   JPEGHead.Spans = Spans;
end

JPEGHead.FNs = FNs;
save(fullfile(WrappingDir,HeadderFN),'JPEGHead');
   
