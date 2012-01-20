function b = BoxIsAroundPoly(bbox,poly,options)
% function b = BoxIsAroundPoly(bbox,poly,options)
%
% returns 1 iff the smallest box which contains poly and has the same aspect ratio as bbox
% overlaps bbox by at least options.slack and the same is true for reversing the two boxes.



d.slack = .5;
d.bPolyMayExitBox = 0;
if(nargin < 3)
 options = [];
end
options = ResolveMissingOptions(options,d);
bbox2 = poly2bbox(poly);
if(not(options.bPolyMayExitBox))
  if(any(BBoxIntersect(bbox,bbox2) ~= bbox2))
    b = 0;
    return;
  end
end
% bbox3 = bboxEnforceAspectRatio(bbox,[bbox2(4),bbox2(3)],'center');
bbox2 = bboxEnforceAspectRatio(bbox2,[bbox(4),bbox(3)],'center');

ibb2 = BBoxIntersect(bbox,bbox2);
% ibb3 = BBoxIntersect(bbox,bbox3);
A1 = bbox(3) * bbox(4);
A2 = bbox2(3) * bbox2(4);
% A3 = bbox3(3) * bbox3(4);
AI = ibb2(3) * ibb2(4);
ival2 = min([AI / A1, AI / A2]);
% ival3 = min([AI / A1, AI / A2]);

b = ival2 > options.slack;
