function [h,T] = dendrogram(Z,D,p)
%DENDROGRAM Generate dendragram plot for temporal sequence data.
%   The Matlab 5.3 'dendrogram' routine was modified by Uri Alon, 
%   Oct 24, 2000 to allow temporal ordering of the dendrogram.
%   The input Z is the output of the matlab routine LINKAGE.
%   D is a matrix containing the log of the data. Before
%   taking the log, every time dependent data sequence should be
%   normalized by its maximal value. Time points are assumed to 
%   be equally spaced for all measurements.
%   DENDROGRAM generates a dendrogram from the output matrix of
%   LINKAGE, Z.  Z is a (M-1) by 3 matrix. M is the number of
%   observations in the original data. 
%
%   A dendrogram consists of many upsidedown U shape lines connecting
%   nodes in a hierachichale tree. Except for the WARD linkage (see
%   LINKAGE), the height of each U is the distance between the two
%   clusters to be connected at that time.  
%
%   DENDROGRAM(Z,P) generate a dendrogram with only the top P nodes.
%   When there are more than 30 nodes in the original data, the
%   dendrogram may look crowded. The default value of P is 30. If P =
%   0, then, every node will be displayed.
%
%   H = DENDROGRAM(...) returns a vector of line handles.
%
%   [H, T] = DENDROGRAM(...) also returns T, a vector of size M that
%   contains cluster number for each observation in the original data.
%
%   When bottom leaves are cutoff, some information are lost. T
%   supplies this lost information. For example, to find out which
%   observations are contained in node k of the dendrogram, use
%   FIND(T==k). 
%
%   When there are less than P observations in the original data, T
%   is the identical map, i.e. T = (1:M)'. Each node only contains
%   itself.
%
%   See also LINKAGE, PDIST, CLUSTER, CLUSTERDATA, INCONSISTENT.

%   ZP You, 3-10-98
%   Copyright (c) 1993-98 by The MathWorks, Inc.
%   $Revision: 1.2 $

m = size(Z,1)+1;
%if nargin < 2
   p = 30;
%end

Z = transz(Z); % convert from m+k indexing to min(i,j) indexing.
T = (1:m)';

% if there are more than p node, dendrogram looks crowded, the following code
% will make the last p link nodes as the leaf node.
if (m > p) & (p ~= 0)
   
   Y = Z((m-p+1):end,:);
   
   R = Y(:,1:2);
   R = unique(R(:));
   Rlp = R(R<=p);
   Rgp = R(R>p);
   W(Rlp) = Rlp;
   W(Rgp) = setdiff(1:p, Rlp);
   W = W';
   T(R) = W(R);
   
   % computer all the leaf that each node (in the last 30 row) has 
   for i = 1:p
      c = R(i);
      T = clusternum(Z,T,W(c),c,m-p+1,0); % assign to it's leaves.
   end
   
   
   Y(:,1) = W(Y(:,1));
   Y(:,2) = W(Y(:,2));
   Z = Y;
   Z(:,3) = Z(:,3)-min(Z(:,3))*0.8; % this is to make the graph look more uniform.
   
   m = p; % reset the number of node to be 30 (row number = 29).
end

A = zeros(4,m-1);
B = A;
n = m;
X = 1:n;
Y = zeros(n,1);
r = Y;

% arrange Z into W so that there will be no crossing in the dendrogram.
W = zeros(size(Z));
W(1,:) = Z(1,:);

nsw = zeros(n,1); rsw = nsw;
nsw(Z(1,1:2)) = 1; rsw(1) = 1;
k = 2; s = 2;

while (k < n)
   i = s;
   while rsw(i) | ~any(nsw(Z(i,1:2)))
      if rsw(i) & i == s, s = s+1; end
      i = i+1;
   end
   
   W(k,:) = Z(i,:);
   nsw(Z(i,1:2)) = 1;
   rsw(i) = 1;
   if s == i, s = s+1; end
   k = k+1;
end

%%%%%%  get an X out of W
clear memb c g1 g2
l=length(Z)+1;
%Z=transz(Z1);
c(:,1)=ones(1,l)';
memb(1:l,1)=(1:l)';
a=Z(1,1);b=Z(1,2);
g1(1,1)=a;g2(1,1)=b;
memb(a,1:2)=union(memb(a,1),memb(b,1));
c(a,1)=2;
for k=2:length(Z),
   c(:,k)=c(:,k-1);
   a=Z(k,1);b=Z(k,2);
   g1(k,1:c(a,k))= memb(a,1:c(a,k));
   g2(k,1:c(b,k))=memb(b,1:c(b,k));
    c1=c(a,k)+c(b,k);
   memb(a,1:c1)=union(memb(a,1:c(a,k)),memb(b,1:c(b,k)));
   c(a,k)=c1;      
end;
Ds=sum(D');
index=1:l;
for k=length(Z):-1:2,
   a=Z(k,1);b=Z(k,2);
   gr1=g1(k,1:c(a,k-1))
   gr2=g2(k,1:c(b,k-1))
   
   t1=mean(Ds(gr1));
   t2=mean(Ds(gr2));
      if (t1>t2),
      [x,y]=sort(index([gr1 gr2]));
      index(gr1)=x(1:length(gr1));
      index(gr2)=x((length(gr1)+1):end);
   end;
   if (t1<=t2),
      [x,y]=sort(index([gr1 gr2]));
      index(gr2)=x(1:length(gr2));
      index(gr1)=x((length(gr2)+1):end);
   end;
   index
end;

%%%%%%%%%%%%%%

X=index;

[u,v]=sort(X);
T=v;
label = num2str(v');

for n=1:(m-1)
   i = Z(n,1); j = Z(n,2); w = Z(n,3);
   A(:,n) = [X(i) X(i) X(j) X(j)]';
   B(:,n) = [Y(i) w w Y(j)]';
   X(i) = (X(i)+X(j))/2; Y(i) = w;
end

figure
set(gcf,'Position', [50, 50, 800, 500]);
h = plot(A,B,'b');
axis([0 m+2 0 max(Z(:,3))*1.05])
set(gca,'XTickLabel',[],'XTick',[],'box','off','xcolor','w');

text((1:m)-0.2,zeros(m,1)-0.05*max(Z(:,3)),label);

