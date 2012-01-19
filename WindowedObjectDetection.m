function [yEmpl,yEmp] = WindowedObjectDetection(Model, yx_size, img,bUseBoost);
%function [yEmpl,yEmp] = WindowedObjectDetection(Model, yx_size, img);
%
%classify every window of size yx_size with SVM Model Model
%pad the sides with the minimum output value to build an image of the same size as the input

if(nargin < 4)
  bUseBoost = 0;
end

if(size(img,3) == 3)
  fprintf('only works for grayscale\n');
  error;
end
nRows = size(img,1) - yx_size + 1;
yEmp =[];
yEmpl =[];
for i = 1:nRows
   Strip = Windowing_ImageStripToMatrix(img,yx_size,i);
   if(bUseBoost)
     [yel,ye] = CLSgentleBoostC(Strip,Model);
     yel = yel';
   else
     [yel,ye] = CLSosusvmC(Strip,Model);
     ye = ye';
     yel = yel';
   end
   yEmp = [yEmp;ye];
   yEmpl = [yEmpl;yel];
   fprintf('.');
end   

s1 = size(img);
s2 = size(yEmp);
d = s1 - s2;
yEmp = padimage(yEmp, [floor(d(2)/2),floor(d(1)/2),ceil(d(2)/2),ceil(d(1)/2)],min(min(yEmp)));
yEmpl = padimage(yEmpl, [floor(d(2)/2),floor(d(1)/2),ceil(d(2)/2),ceil(d(1)/2)],min(min(yEmpl)));

