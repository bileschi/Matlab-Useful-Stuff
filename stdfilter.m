function I = stdfilter(I,radius,padstrategy);
%function I = stdfilter(I,radius,padstrategy);

if(nargin <3)
 padstrategy = 'symmetric';
end

if(length(radius) == 1)
 I = padimage(I,radius,padstrategy);
 I = stripMode(I,[2*radius+1, 2*radius+1]);
% I = unpadimage(I,radius);
end
if(length(radius) == 4)
 I = padarray(I,[radius(2),radius(1)],padstrategy,'pre');
 I = padarray(I,[radius(4),radius(3)],padstrategy,'post');
 I = stripStd(I,[radius(1)+radius(3), radius(2)+radius(4)]);
 % I = unpadimage(I,radius);
end


function M = stripMode(img, yx_size);
nRows = size(img,1) - yx_size + 1;
M = [];
v = floor(mean(prod(yx_size)) / 2);
for i = 1:nRows
   Strip = Windowing_ImageStripToMatrix(img,yx_size,i);
   M = [M;std(Strip)];
end   
