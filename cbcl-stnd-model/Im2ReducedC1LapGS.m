function [c1,s1] = Im2ReducedC1LapGS(stim);
%function out = Im2ReducedC1LapGS(stim);
%
% stim should be grayscale image and between 0 and 1

% set up filters
if(isinteger(stim))
   stim = im2double(stim);
end
sqfilter{1} = [1,1,1;0,0,0;-1,-1,-1];
sqfilter{2} = [-1,0,1;-1,0,1;-1,0,1];
sqfilter{3} = [0,1,1;-1,0,1;-1,-1,0];
sqfilter{4} = [1,1,0;1,0,-1;0,-1,-1];
sqfilter{5} = [-1,-1,-1;-1,8,-1;-1,-1,-1];
sqfilter{6} = [0,0,0;0,1,0;0,0,0];

sz = size(stim);
sqim = stim.^2;
iUFilterIndex = 0;
% precalculate the normalizations
uFiltSizes = 3;
s1Norm = sumfilter(sqim,1).^0.5;
%avoid divide by zero (regularize)  %%%STAN EDIT, there was a possible error here when working with double imgs
s1Norm = s1Norm + .05 * mean(s1Norm(:)) * ~s1Norm;
s1 = zeros(sz(1),sz(2),6);

% Calculate all filter responses (s1)
%%%%%%%%
for iFilt = 1:5
  s1(:,:,iFilt) = imfilter(stim, sqfilter{iFilt},'symmetric','same','corr');
  s1(:,:,iFilt) = abs(s1(:,:,iFilt) ./ s1Norm);
end
s1(:,:,6) = stim;
c1_proto = zeros(size(s1));
% Calculate local pooling (c1)
%%%%%%%%
pRange1 = 8;
pRange2 = 8;
for iFilt = 1:5
   c1_proto(:,:,iFilt) = maxfilter(s1(:,:,iFilt),[pRange1 pRange1 pRange2 pRange2]);
end
beforesize = size(c1_proto(:,:,6));
c1OneFilt = imresizeVote(s1(:,:,6),[pRange1 pRange1]);
c1_proto(:,:,6) = imresize(c1OneFilt,beforesize,'nearest')/64;
%   subsample
sSS = 8;
r1 = ceil((mod(size(c1_proto,1)-1,sSS)+1)/2);
r2 = ceil((mod(size(c1_proto,2)-1,sSS)+1)/2);
c1 = zeros(length(r1:sSS:sz(1)),length(r2:sSS:sz(2)),6);
for iFilt = 1:6
   c1(:,:,iFilt) = c1_proto(r1:sSS:end,r2:sSS:end,iFilt);
end
