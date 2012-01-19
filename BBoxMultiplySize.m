function bboxOut = BBoxMultiplySize(bboxIn,multiplicand);
%function bboxOut = BBoxMultiplySize(bboxIn,multiplicand);
%
%returns a new bbox with the same center but of a new size
%

cx = bboxIn(1) + bboxIn(3)/2;
cy = bboxIn(2) + bboxIn(4)/2;
bboxOut(3) = floor((bboxIn(3) + 1) * multiplicand - 1);
bboxOut(4) = floor((bboxIn(4) + 1) * multiplicand - 1);
bboxOut(1) = floor(cx - bboxOut(3) /2);
bboxOut(2) = floor(cy - bboxOut(4) /2);

