function ptMatches = siftFeatureMatch(d1,d2,th)
%function ptMatches = siftFeatureMatch(d1,d2,th)
%
%
Dmat = L2_dist(d1,d2);
ptMatches = nan(3,min(size(d1,2),size(d2,2)));
n = 0;
for i = 1:size(d1,2)
   [M1,M1i] = min(Dmat(i,:));
   t = Dmat(i,M1i);
   Dmat(i,M1i) = nan;
   [M2,M2i] = min(Dmat(i,:));
   Dmat(i,M1i) = t;
   if(M1 < th)
      if(M1 < (.8 * M2))
         n=n+1;
         ptMatches(1,n) = i;
         ptMatches(2,n) = M1i;
         ptMatches(3,n) = M1;
      end
   end
end
ptMatches = ptMatches(:,1:n);
