function NewX = imResizeGrayscaleMatrix(X,Sold,Snew,method)
%function NewX = imResizeGrayscaleMatrix(X,Sold,Snew,method)
%
%given: X is a matrix of (1 channel) images stored as columns. and these images are originally size Sold
%NewX is a similar matrix of images of size Snew resized by bilinear interpolation
%sizes must be given in [height, width, *] format


if(not(exist('method')))
  method = 'bilinear';
end
n = size(X,2);
if(prod(size(X)) ~= (n * prod(Sold(1:2))))
   error('Old size %d * %d * %d does not match array size %d * d\n', Sold(1), Sold(2), n, size(X,1),n);
   NewX = [];
   return;
end
X = reshape(X,[Sold(1),Sold(2),n]);
NewX = imresize(X,[Snew(1),Snew(2)],method);
NewX = reshape(NewX, [prod(Snew(1:2)), n]);



