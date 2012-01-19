function d = RingDiff(x1,x2,rs,re)
%function d = RingDiff(x1,x2,rs,re)
%
%given a ring from rs to re (ring start ring end), computes the distance between
%x1 and x2 on that ring
sz = re - rs;
x1 = x1 - rs;
x2 = x2 - rs;
re = re - rs;

x1 = rem(x1,re);
x2 = rem(x2,re);
d1 = abs(x1-x2);
d2 = min([x1,x2])+(re-max([x1,x2]));
d = min(d1,d2);