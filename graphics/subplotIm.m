function subplotIm(rows,cols,idx)
%function subplotIm(rows,cols,idx)
%
%creates an axis filling the panel which would have been generated via
%subplot.

%bileschi 2009

iRow = mod(idx-1,rows)+1;
iCol = ceil(idx/rows);
l=(iCol-1)/cols;
w=1/cols;
h=1/rows;
b=(1-(iRow/rows)); 
axes('Units','Normalized','Position',[l,b,w,h]);
