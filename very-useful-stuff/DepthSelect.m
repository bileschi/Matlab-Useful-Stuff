function Out = DepthSelect(Mat3D,Depth)
%function Out = DepthSelect(Mat3D,Depth)
%
%Out(i,j) = Mat3d(i,j,Depth(i,j));

if(size(Depth,1) ~= size(Mat3D,1))
  error('size mismatch\n');
end  
if(size(Depth,2) ~= size(Mat3D,2))
  error('size mismatch\n');
end  

Spread = length(Depth(:));
f = 1:Spread;
f = f'+(Depth(:)-1)*Spread;
Out = reshape(Mat3D(f),size(Depth));
