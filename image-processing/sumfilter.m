function I = sumfilter(I,radius,padstrategy);
%function I = sumfilter(I,radius,padstrategy);
%I is the input image
%radius is the additional radius of the window, i.e., 5 means 11 x 11
%if a a two value vector is specified, the format is [y-radius, x-radius].
%if a four value vector is specified for radius, then any rectangular support may be used for max.
%in the order left top right bottom.
%pad strategy can be {|R, 'symmetric','circular','replicate'}

if(nargin <3)
 padstrategy = 0;
end

if(length(radius) == 2)
  radius = [radius(2),radius(1),radius(2),radius(1)];
end

if(length(radius) == 1)
 I = padimage(I,radius,padstrategy);
 [n,m,thirdd] = size(I);
 B = I;
 for i = radius+1:m-radius,
  B(:,i,:) = sum(I(:,[i-radius:i+radius],:),2);
 end
 for i = radius+1:n-radius,
  I(i,:,:) = sum(B([i-radius:i+radius],:,:),1);
 end
 I = unpadimage(I,radius);
end
if(length(radius) == 4)
 I = padarray(I,[radius(2),radius(1)],padstrategy,'pre');
 I = padarray(I,[radius(4),radius(3)],padstrategy,'post');
 [n,m,thirdd] = size(I);
 B = I;
 for i = radius(1)+1:m-radius(3),
  B(:,i,:) = sum(I(:,[i-radius(1):i+radius(3)],:),2);
 end
 for i = radius(2)+1:n-radius(4),
  I(i,:,:) = sum(B([i-radius(2):i+radius(4)],:,:),1);
 end
 I = unpadimage(I,radius);
end
