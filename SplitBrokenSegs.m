function s2 = SplitBrokenSegs(s1)
%function s2 = SplitBrokenSegs(s1)
%
%input: an index image
%output: an index image where non-connected components get different indexes

u = unique(s1);
n = 0;
s2 = zeros(size(s1));
for i = u'
   z = s1 == i;
   m = bwlabel(z);
   u2 = unique(m);
   u2 = setdiff(u2,[0]);
   for j = u2'
     n = n+1;
     s2 = s2 + n * (m == j);
   end
end