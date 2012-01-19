function zi = griddata_extend(x,y,z,xi,yi)
%function zi = griddata_extend(x,y,z,xi,yi)
%
% a wrapper to griddata which appends the point list to add points in the
% corners.  This is done so that the borders of the output are not nan.

newxy(:,1) = [min(xi(:));min(yi(:))];
newxy(:,2) = [max(xi(:));min(yi(:))];
newxy(:,3) = [max(xi(:));max(yi(:))];
newxy(:,4) = [min(xi(:));max(yi(:))];

D = L2_dist([x(:)';y(:)'],newxy);
[md,mdi] = min(D);
z2 = [z;z(mdi)];
x2 = [x;newxy(1,:)'];
y2 = [y;newxy(2,:)'];
zi = griddata(x2,y2,z2,xi,yi);

