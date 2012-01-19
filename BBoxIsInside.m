function b = BBoxIsInside(bbox1,bbox2);
%function b = BBoxIsInside(bbox1,bbox2);
%
%returns one iff bbox1 is inside (or on top of) bbox2

b = bbox1(1) >= bbox2(1);
b = b && ( bbox1(2) >= bbox2(2) );
b = b && ( ( bbox1(2) + bbox1(4) )  <= (bbox2(2) + bbox2(4)) );
b = b && ( ( bbox1(1) + bbox1(3) )  <= (bbox2(1) + bbox2(3)) );
