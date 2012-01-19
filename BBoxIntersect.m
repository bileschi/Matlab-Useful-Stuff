function bb3 = BBoxIntersect(bb1,bb2);
%if there is no intersect then the size of bb3 will be 0;
%

bb3(1) = max(bb1(1), bb2(1));
bb3(2) = max(bb1(2), bb2(2));
bot = min(bb1(2) + bb1(4), bb2(2) + bb2(4));
rgt = min(bb1(1) + bb1(3), bb2(1) + bb2(3));
bb3(3) = max(0,rgt - bb3(1));
bb3(4) = max(0,bot - bb3(2));
if(any(bb3([3,4]) == 0))
  bb3([3,4]) = 0;
end


