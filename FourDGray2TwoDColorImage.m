function TwoDIm = FourDGray2TwoDColorImage(FourDIm,options);
%function TwoDIm = FourDGray2TwoDColorImage(FourDIm,options);
%
if(nargin < 2), options = [];, end
d.MaxOutputSize = 3000;
d.DecimateStrat = 'max'; %{'max','mean'}
options = ResolveMissingOptions(options,d);


sz1 = size(FourDIm,1);
sz2 = size(FourDIm,2);
sz3 = size(FourDIm,3);
sz4 = size(FourDIm,4);

maxnewsize = max(sz1 * sz3, sz2 * sz4);
minreducefactor = maxnewsize / options.MaxOutputSize;
reducefactor = 1;
while(reducefactor < minreducefactor)
  reducefactor = reducefactor * 2;
end;
if(reducefactor > 1)
  NewFourDIm = zeros(sz1,sz2,floor(sz3/reducefactor), floor(sz4/reducefactor));
  switch(lower(options.DecimateStrat));
    case('max')
       N = MatrixDecimate_Max(FourDIm,3,reducefactor);
       N = MatrixDecimate_Max(N,4,reducefactor);
    case('mean')
       N = MatrixDecimate_Max(FourDIm,3,reducefactor,'mean');
       N = MatrixDecimate_Max(N,4,reducefactor,'mean');
  end
else
  N = FourDIm;
end
sz = size(N);
% TwoDIm = zeros(sz(1)*sz(3), sz(2)*sz(4));
TwoDIm_V = permute(N,[3,1,4,2]);
TwoDIm_V = reshape(TwoDIm_V,[sz(1)*sz(3),sz(2)*sz(4)]);
RStemplate = zeros(sz(3),sz(4));
rsc = (1/2)*([sz(3),sz(4)]+1);
for i = 1:sz(3)
  for j = 1:sz(4)
    dy = i - rsc(1);
    dx = j - rsc(2);
    r = sqrt(dy*dy+dx*dx);
    th = atan2(dy,dx);
    RStemplate(i,j,1) = th;
    RStemplate(i,j,2) = r;
  end
end
RStemplate(:,:,1) = min(1,max(0,(RStemplate(:,:,1) + pi) / (2*pi)));
RStemplate(:,:,2) = min(1,max(0,RStemplate(:,:,2) / (sqrt(2) * max(rsc))));
TwoDIm_RS = repmat(RStemplate, [sz(1) sz(2)]);
TwoDIm = hsv2rgb(cat(3, TwoDIm_RS,TwoDIm_V));
