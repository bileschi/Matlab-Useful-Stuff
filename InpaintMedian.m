function imgOut = InpaintMedian(img,toFill,maxNRounds)
%function imgOut = InpaintMedian(img,toFill,,maxNRounds)
%
%ASSERT:
%size(img,1:2) == size(toFill,1:2)
%size(toFill,3) == 1
%
%output imgOut(not(find(toFill))) == img(not(find(toFill)))
%       imgOut(otherwise) == median of nearby points
%
%iterates via finding points on the boundary of filled and not filled and filling those
%no interpolation takes place here, instead we index to the higher value
% i.e. the "median" of [3,2] is 2;
%
% maxNRounds sets a limit to how far the filling process will continue.
%            it defaults to inf.
%
% example:
%   img = magic(60) / 3600;
%   toFill = zeros(60);
%   toFill(20:40,20:40) = 1;
%   imgOut = InpaintMedian(img,toFill);
options.Verbose = 0;
if(size(img,1) ~= size(toFill,1)) | (size(img,2) ~= size(toFill,2))
   error('size of toFill must be equal to one layer of img')
end
imgOut = img;
if(nargin < 3)
    maxNRounds = inf;
end
n=0;
while(any(toFill(:)))
   erd = imerode(toFill,ones(3));
   toFillThisRound = toFill & ~erd;
   [fThisRoundI,fThisRoundJ] = find(toFillThisRound);
   fNeighborsI = cat(2,fThisRoundI-1,fThisRoundI-1,fThisRoundI-1,fThisRoundI,fThisRoundI,fThisRoundI+1,fThisRoundI+1,fThisRoundI+1);
   fNeighborsJ = cat(2,fThisRoundJ-1,fThisRoundJ,fThisRoundJ+1,fThisRoundJ-1,fThisRoundJ+1,fThisRoundJ-1,fThisRoundJ,fThisRoundJ+1);
   okNeighbor = (fNeighborsI > 0) & (fNeighborsI <= size(img,1)) & (fNeighborsJ > 0) & (fNeighborsJ <= size(img,2));
   f = find(not(okNeighbor));
   fNeighborsI(f) = 1;
   fNeighborsJ(f) = 1;
   okNeighbor = okNeighbor & spindex(~toFill,fNeighborsI,fNeighborsJ);
   fNeighborsI(not(okNeighbor)) = nan;
   fNeighborsJ(not(okNeighbor)) = nan;
   medIdx = ceil(sum(okNeighbor,2)/2); %8->4,7->4,6->3,5->3,4->2,3->2,2->1,1->1;
   %median filter in each dimension separately
   for iD = 1:size(img,3)
      %NDsub2Ind and spindex will output nan for any corresponding input nan
      origIdx = NDsub2ind(size(img),[fThisRoundI,fThisRoundJ,repmat(iD,[length(fThisRoundI),1])]);
      if(size(img,3)>1)
         vals = spindex(imgOut,fNeighborsI,fNeighborsJ,iD*ones(size(fNeighborsI)));
      else
         vals = spindex(imgOut,fNeighborsI,fNeighborsJ);
      end
      vals = sort(vals,2);
      medVals = spindex(vals,[1:size(vals,1)]',medIdx);
      imgOut(origIdx) = medVals;
   end
   if(options.Verbose)
      fprintf('.');
   end
   toFill = erd;
   n=n+1;
   if n == maxNRounds
       return;
   end
end
