function Cubes = Reshape2Cubes(X,cubesize);
%function Cubes = Reshape2Cubes(X,cubesize);
%
%input a 3d matrix and the cubesize
%the output is a 6d matrix where the original dimensions are intact,
%but the data is sliced into non-overlapping cubes, indexed along the 4th,5th,and 6th dimensions
%
%if size(X) is not a multiple of cubesize then the extra elements are lost.
%
%This only works on 3D data.  It is probably possible to make an arbitrary chunking tool.


sz = size(X);
ncubes4 = floor(sz(1)/cubesize(1));
ncubes5 = floor(sz(2)/cubesize(2));
ncubes6 = floor(sz(3)/cubesize(3));
max1 = ncubes4*cubesize(1);
max2 = ncubes5*cubesize(2);
max3 = ncubes6*cubesize(3);
X = X(1:max1,1:max2,1:max3);
sz = size(X);
X = reshape(X,[sz(1),sz(2),cubesize(3),ncubes6]);
X = permute(X,[3,4,1,2]);
X = reshape(X,[cubesize(3),ncubes6,sz(1),cubesize(2),ncubes5]);
X = permute(X,[4,5,1,2,3]);
X = reshape(X,[cubesize(2),ncubes5,cubesize(3),ncubes6,cubesize(1),ncubes4]);
Cubes = permute(X,[5,1,3,6,2,4]);
return
%  
%  % below is only testing stuff;
%  
%  
%  %neworder = ComputeNewOrder(sz,cubesize,ncubes4,ncubes5,ncubes6);
%  %Cubes(1:length(Vectorize(Cubes))) = X(neworder);
%  
%  %  function neworder = ComputeNewOrder(sz,cubesize,ncubes4,ncubes5,ncubes6);
%  sz = [12,12,12];
%  cubesize(1) = 2;
%  cubesize(2) = 3;
%  cubesize(3) = 4;
%  ncubes4 = 6;
%  ncubes5 = 4;
%  ncubes6 = 3;
%  
%  [MG1,MG2,MG3] = ndgrid(1:sz(1),1:sz(2),1:sz(3));
%  MG1 = ceil(MG1/cubesize(1))-1;
%  MG2 = ceil(MG2/cubesize(2))-1;
%  MG3 = ceil(MG3/cubesize(3))-1;
%  MG = MG1 + ncubes4 * MG2 + ncubes4*ncubes5*MG3;
%  %%% This is how testing works.