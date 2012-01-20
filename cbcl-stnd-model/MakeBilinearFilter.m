function bilinfilt = MakeBilinearFilter(yx_cellsize);
%function bilinfilt = MakeBilinearFilter(yx_cellsize);
filtsize(1) = 2*yx_cellsize(1) - 1;
filtsize(2) = 2*yx_cellsize(2) - 1;
x_k = (yx_cellsize(2):-1:1)/yx_cellsize(2);
x_k = [x_k((end):-1:2) , x_k(1:end)];
y_k = (yx_cellsize(1):-1:1)/yx_cellsize(1);
y_k = [y_k((end):-1:2) , y_k(1:end)];
bilinfilt = y_k' * x_k;

