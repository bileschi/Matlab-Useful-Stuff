function I = maxfilter_arbitrarySupport(I,Msupport,padval);
%function I = maxfilter_arbitrarySupport(I,Msupport,padval);
%
%support must be a binary matrix.  The centroid of the support will be at
%[floor(size(support,1)/2), floor(size(support,2)/2)]
%
if(nargin < 3)
  padval = -inf;
end

sz = size(Msupport);
centroid = floor(sz);
fsupport = find(Msupport);
ndxsupport = NDind2sub(sz,fsupport);
nPoints = size(fsupport,1);
ndxsupport = ndxsupport - repmat(centroid, [nPoints,1]);
padamnt = max(ceil(sz/2));
ndxsupport = ndxsupport + padamnt;
ndxsupport = ndxsupport + padamnt;
padI = padimage(I,padamnt,padval);
BigMat = zeros(nPoints, prod(size(I)));
sI = size(I);
for i = 1:nPoints
  crop = padI( ndxsupport(i,1) +  (1:sI(1))-1,ndxsupport(i,2) + (1:sI(2)) - 1 );
  BigMat(i,:) = crop(:);
end
I = reshape(max(BigMat,[],1),sI);

%  function I = maxfilter_arbitrarySupport(I,Msupport);
%  %function I = maxfilter_arbitrarySupport(I,Msupport);
%  %
%  %support must be a binary matrix.  The centroid of the support will be at
%  %[floor(size(support,1)/2), floor(size(support,2)/2)]
%  
%  sz = size(Msupport);
%  centroid = floor(sz);
%  fsupport = find(Msupport);
%  ndxsupport = NDind2sub(sz,fsupport);
%  nPoints = size(fsupport,1);
%  ndxsupport = ndxsupport - repmat(centroid, [nPoints,1]);
%  padamnt = max(ceil(sz/2));
%  ndxsupport = ndxsupport + padamnt;
%  ndxsupport = ndxsupport + padamnt;
%  padI = padimage(I,padamnt,-inf);
%  BigMat = zeros(nPoints, prod(size(I)));
%  sI = size(I);
%  for i = 1:nPoints
%    crop = padI( ndxsupport(i,1) +  (1:sI(1))-1,ndxsupport(i,2) + (1:sI(2)) - 1 );
%    BigMat(i,:) = crop(:);
%  end
%  I = reshape(max(BigMat,[],1),sI);
