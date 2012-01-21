function I = modefilter(I,radius,padstrategy);
%function I = modefilter(I,radius,padstrategy);
%I is the input image
%radius is the additional radius of the window, i.e., 5 means 11 x 11
%if a four value vector is specified for radius, then any rectangular support may be used for max.
%in the order left top right bottom.
%pad strategy can be {|R, 'symmetric','circular','replicate'}

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
 I = stripMode(I,[radius(1)+radius(3), radius(2)+radius(4)]);
 % I = unpadimage(I,radius);
end


function M = stripMode(img, yx_size);
nRows = size(img,1) - yx_size + 1;
M = [];
v = floor(mean(prod(yx_size)) / 2);
for i = 1:nRows
   Strip = Windowing_ImageStripToMatrix(img,yx_size,i);
   Strip = sort(Strip);
   ye = Strip(v,:);
   M = [M;ye];
end   
