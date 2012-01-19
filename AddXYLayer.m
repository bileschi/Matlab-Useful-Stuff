function BTRSIm = AddXYLayer(BTRSIm)
%function BTRSIm = AddXYLayer(BTRSIm)
%
%adds two additional layers to an image indicating the relative 
%location of the pixel
s = size(BTRSIm);
[X,Y] = meshgrid(1:s(2), 1:s(1));
BTRSIm(:,:,s(3)+1) = double(X) / s(2);
BTRSIm(:,:,s(3)+2) = double(Y) / s(1);
