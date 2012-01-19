function bbox2 = bboxEnforceAspectRatio(bbox1,aspect_ratio_yx, centering)
%function bbox2 = bboxEnforceAspectRatio(bbox1,aspect_ratio_yx, centering)
%
%increases the size of the bbox to force (approximate) aspect ratio.  bbox may be extended
%outside the image.  use pad-image before cropping to save heart-ache
%
%aspect_ratio_yx is [ysize,xsize]
%
%extends the bbox to match the aspect ratio
%
%centering elm {'center','bottom'}, only matters if bbox is too wide and 
%  fluff needs to be added to the top / bottom

bbox2 = bbox1;
if(nargin < 3)
  centering = 'center';
end
if(not(strcmpi(centering,'center')) && not(strcmpi(centering,'bottom')))
  fprintf('centering can not be %s\n',centering);
  fprintf('it must be <center> or <bottom>');
  return;
end

asout = aspect_ratio_yx(1) / aspect_ratio_yx(2);
asin = bbox1(4) / bbox1(3);

%two cases, if bbox is too wide, or too tall
%case one, too wide
if(asin < asout)
  %centering can be bottom or center
  true_height = round(asout * bbox1(3));
  d = true_height - bbox1(4);% > 0
  moretop = floor(d / 2);
  morebottom = ceil(d / 2);
  d = round(d);
  switch(lower(centering))
    case 'center'
      %move the top up half and adjust the hight
      bbox2(2) = bbox2(2) - moretop;
      bbox2(4) = true_height;
    case 'bottom'
      %move the top up all the way
      bbox2(2) = bbox2(2) - d;
      bbox2(4) = true_height;
    otherwise
      fprintf('This should never happen\n');
  end
end

%case two, too tall
if(asin > asout)
  %widen left and right
  %move the left back half and adjust the width
  true_width = (asout ^ -1) * bbox1(4);
  d = true_width - bbox1(3);
  d = round(d);
  moreleft = floor(d/2);
  bbox2(1) = bbox2(1) - moreleft;
  bbox2(3) = bbox2(3) + d;
end
