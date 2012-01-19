function [beginIdx,endIdx] = GroupIndicies(Nelem,Ngroups)
%function [beginIdx,endIdx] = GroupIndicies(Nelem,Ngroups)
%
%finds boundaries for breaking a list of elements (1:Nelem) into 
% Ngroups groups such that approximately the same number of elements are 
% in each group.  
%
% returns the list of beginning and ending indicies such that the i'th
% group can be indexed by Array(beginIdx(i):endIdx(i))
%
% beginIdx(1) is automatically 1 and endIdx(Ngroups) is automatically Nelem

nPerGroup_low = floor(Nelem / Ngroups);
nPerGroup_hi = ceil(Nelem / Ngroups);
nGroupsHi = mod(Nelem,Ngroups);
if(nGroupsHi == 0), nGroupsHi = Ngroups;, end
beginIdx = nan(Ngroups,1);
endIdx = nan(Ngroups,1);
beginIdx(1) = 1;
endIdx(1) = nPerGroup_hi;
for i = 2:nGroupsHi
    beginIdx(i) = endIdx(i-1) + 1;
    endIdx(i) = beginIdx(i) + nPerGroup_hi - 1;
end
for i = (nGroupsHi+1):Ngroups
    beginIdx(i) = endIdx(i-1) + 1;
    endIdx(i) = beginIdx(i) + nPerGroup_low - 1;
end
