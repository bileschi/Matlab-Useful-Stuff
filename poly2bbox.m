function [bbox1, bbox2] = poly2bbox(poly);
%function [bbox1, bbox2] = poly2bbox(poly);
%T = top, L = left, W = width, H = height;
%R = right, B = bottom
%
%bbox1 is imcrop format [L,T, W, H]
%bbox2 is poly format ([L R R L L];[T T B B T])';

T = min(poly(:,2));
B = max(poly(:,2));
R = max(poly(:,1));
L = min(poly(:,1));
W = R - L + 1;
H = B - T + 1;
bbox1 = [L,T,W,H];
bbox2 = [[L R R L L];[T T B B T]]';
