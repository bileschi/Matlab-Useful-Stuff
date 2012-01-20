function [TotalIm,TotalSupport] = ImshowUnstructuredImage(xysRelativePoints,vData,options)
% function  [TotalIm,TotalSupport] = ImshowUnstructuredImage(xysRelativePoints,vData,options)
%
vData = vData(:);

d.Mode = 'mean';
d.OrigSize = [240 320];
d.SupportSizeModulation = 1;
d.BorderMethod = 'ignore';
if(nargin < 3)
  options = [];
end
options = ResolveMissingOptions(options,d);

nP = size(xysRelativePoints,1);
nLay = length(vData) / nP;
if(mod(length(vData) , nP) ~= 0), error('vData must be a multiple length of xysRelativePoints\n');, end

switch(lower(options.BorderMethod))
  case('symmetric')
    xysRelativePoints(:,[1,2]) = abs(mod(xysRelativePoints(:,[1,2])+1,2)-1);
  case('replicate');
    xysRelativePoints(:,[1,2]) = min(1,max(0,xysRelativePoints(:,[1,2])));
  case('circular');
    xysRelativePoints(:,[1,2]) = mod(xysRelativePoints(:,[1,2]),1);
  case('ignore');
    fs = find(xysRelativePoints(:,1) > 0);
    fs = intersect(fs, find(xysRelativePoints(:,1) < 1));
    fs = intersect(fs, find(xysRelativePoints(:,2) > 0));
    fs = intersect(fs, find(xysRelativePoints(:,2) < 1));
    xysRelativePoints = xysRelativePoints(fs,:);
    vData = reshape(vData,[nP,nLay]);
    vData = vData(fs,:);
    vData = vData(:);
    nP = size(xysRelativePoints,1);
  otherwise
    error('SampleField: Unrecognized options.BorderMethod should be symmetric or replicate or circular\n');    
end



switch(lower(options.Mode))
  case('mean')
    TotalIm = zeros(options.OrigSize(1),options.OrigSize(2),nLay);
    TotalSupport = zeros(options.OrigSize(1),options.OrigSize(2));
    for i = 1:nP
      fprintf('%d of %d points\r',i,nP);
      SupportIm = buildSupport(xysRelativePoints(i,:),options);
      [TotalIm,TotalSupport] = IncorporateNewData(TotalIm,TotalSupport,SupportIm, vData(i:nP:end),options);
    end
    fprintf('\n');
  case('max')
    TotalIm = zeros(options.OrigSize(1),options.OrigSize(2),nLay) + min(vData);
    TotalSupport = zeros(options.OrigSize(1),options.OrigSize(2));
    for i = 1:nP
      fprintf('%d of %d points\r',i,nP);
      bbox = buildSupportBBox(xysRelativePoints(i,:),options);
      yidx = [bbox(2):(bbox(2)+bbox(4))];
      xidx = [bbox(1):(bbox(1)+bbox(3))];
      TotalSupport(yidx,xidx) = TotalSupport(yidx,xidx) + 1;
      for j = 1:nLay
         TotalIm(yidx,xidx,j) = max(TotalIm(yidx,xidx,j),vData(nP*(j-1)+i));
      end
    end
    fprintf('\n');
end
    
function SupportIm = buildSupport(xysRelPt,options);
SupportIm = zeros(options.OrigSize(1),options.OrigSize(2));
bbox = buildSupportBBox(xysRelPt,options);
SupportIm([bbox(2):(bbox(2)+bbox(4))],[bbox(1):(bbox(1)+bbox(3))]) = ((bbox(3)+1) + (bbox(4)+1))^-1;

function bbox = buildSupportBBox(xysRelPt,options);
sz = xysRelPt(3) * options.SupportSizeModulation;
bbox = [xysRelPt(1)-sz/2, xysRelPt(2)-sz/2,sz,sz];
bbox = bboxRelative2Real(bbox, options.OrigSize);
bbox([1,2]) = floor(bbox([1,2]));
bbox([3,4]) = ceil(bbox([3,4]));
bbox = BBoxIntersect(bbox,[1,1,options.OrigSize(2)-1,options.OrigSize(1)-1]); 

function [TotalIm,TotalSupport] = IncorporateNewData(TotalIm,TotalSupport,SupportIm, vData,options);
  lambda = (TotalSupport + eps)./(TotalSupport + SupportIm + eps);  
  TotalSupport = TotalSupport + SupportIm;
  SupportIm = SupportIm > 0;
  for i = 1:length(vData)
    TotalIm(:,:,i) = lambda .* (TotalIm(:,:,i)) + (1-lambda) .* (vData(i) * SupportIm);
  end  
