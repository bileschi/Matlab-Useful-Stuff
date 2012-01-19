function i = BinarySearchLT(l,q);
%function i = BinarySearchLT(l,q);
%
%returns the largest index of an element LESS THAN q
%
%list l sorted >>>>>>> smallest to greatest <<<<<<<<
%query q  
%index i is the largest index of l such that l(i) < q
i = 0;
if l(1) > q, return, end
if l(end) < q, i = length(l), return, end
iSmallerThanQ = 1;
iLargerThanQ = length(l);
while (iLargerThanQ - iSmallerThanQ) > 1
   iQuery = floor(mean([iLargerThanQ,iSmallerThanQ])); % the center point of the remaining values
   valueAtIQ = l(iQuery);
   if valueAtIQ < q
      iSmallerThanQ = iQuery;
   else
      iLargerThanQ = iQuery;
   end
end
i = iSmallerThanQ;
return


%% SCRIPT TESTING THIS FUNCTION
l = 10000* rand(10^7,1);
l = sort(l);
q = .5;
tic
max(find(l>q))
toc
tic
myi = BinarySearchLT(l,q)
toc
[l(myi),l(myi+1)]
