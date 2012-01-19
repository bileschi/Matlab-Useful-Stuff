function [dendroGram] = randomDendriticCluster(X);
% function [dendroGram] = randomDendriticCluster(X);
% 
% X is features x points
% dendrogram is 2 x nEdges. for any edge d(1,x) is the first pt, d(2,x) is the second point and 

nPts = size(X,2);
nFeats = size(X,1);

currentClust = 1:nPts;

seedrand;
done = 0;
dendroGram = zeros(2,nPts);
nEdges = 0;

while(not(length(unique(currentClust)) == 1))  % everything in the same cluster
   pointA = GetRandomPoint(nPts);
   [pointB,distAB] = findMinDistPointNotInCluster(pointA,currentClust,X);
   [pointC,distBC] = findMinDistPointNotInCluster(pointB,currentClust,X);
   while(distBC < distAB)
     distAB = distBC;
     pointA = pointB;
     pointB = pointC;
     [pointC,distBC] = findMinDistPointNotInCluster(pointB,currentClust,X);
   end
   clustA = currentClust(pointA);
   clustB = currentClust(pointB);
   if(clustA == clustB)
      keyboard;
   end
   iClustA = find(currentClust == clustA);
   iClustB = find(currentClust == clustB);
   currentClust([iClustA(:);iClustB(:)]) = min(clustA,clustB);
   nEdges = nEdges + 1;
   dendroGram(:,nEdges) = [pointA;pointB];
   fprintf('at %.6d of %.6d %.6d of %.6d links %.6d of %.6d\r', nEdges, nPts, clustA, length(iClustA), clustB, length(iClustB));
end
   
function [pointB,distAB] = findMinDistPointNotInCluster(pointA,currentClust,X)
   pointBList = setdiff(1:size(X,2),find(currentClust == currentClust(pointA))); %points not in this cluster
   p = randperm(length(pointBList));
   p = p(1:(min(100,length(p))));
   pointBList = pointBList(p);
   distances = X(:,pointBList) - repmat(X(:,pointA),[1,length(pointBList)]);
   distances = sum(distances .^ 2);
   [distAB,iMinDist] = min(distances);
   pointB = pointBList(iMinDist);

function pt = GetRandomPoint(nPts)
p = randperm(nPts);
pt = p(1);
