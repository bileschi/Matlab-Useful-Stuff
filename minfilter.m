function [I,LRi,UDi] = minfilter(I,radius);
%I is the input image
%radius is the additional radius of the window, i.e., 5 means 11 x 11
%if a four value vector is specified for radius, then any rectangular support may be used for max.
%in the order left top right bottom.
I = -I;
GET_COORDS = nargout > 1;

if(length(radius) == 1)
 I = padimage(I,radius);
 [n,m,thirdd] = size(I);
 B = I;
 LRi = I;
 UDi = I;
 for i = radius+1:m-radius,
  [B(:,i,:),LRi(:,i,:)] = max(I(:,[i-radius:i+radius],:),[],2);
 end
 for i = radius+1:n-radius,
  [I(i,:,:),UDi(i,:,:)] = max(B([i-radius:i+radius],:,:),[],1);
 end
end
if(length(radius) == 4)
 I = padarray(I,[radius(2),radius(1)],-inf,'pre');
 I = padarray(I,[radius(4),radius(3)],-inf,'post');
 [n,m,thirdd] = size(I);
 B = I;
 LRi = I;
 UDi = I;
 for i = radius(1)+1:m-radius(3),
  [B(:,i,:),LRi(:,i,:)] = max(I(:,[i-radius(1):i+radius(3)],:),[],2);
 end
 for i = radius(2)+1:n-radius(4),
  [I(i,:,:),UDi(i,:,:)] = max(B([i-radius(2):i+radius(4)],:,:),[],1);
 end
end
I = unpadimage(I,radius);
if(GET_COORDS)
  LRi = unpadimage(LRi,radius);
  UDi = unpadimage(UDi,radius);
end
I = -I;
%function [I,LRi,UDi] = maxfilter(I,radius);
%%I is the input image
%%radius is the additional radius of the window, i.e., 5 means 11 x 11
%%if a four value vector is specified for radius, then any rectangular support may be used for max.
%%in the order left top right bottom.
%if(length(radius) == 1)
% I = padimage(I,radius);
% [n,m,thirdd] = size(I);
% B = I;
% for i = radius+1:m-radius,
%  [B(:,i,:),LRi(:,i)] = max(I(:,[i-radius:i+radius],:),[],2);
% end
% for i = radius+1:n-radius,
%  I(i,:,:) = max(B([i-radius:i+radius],:,:),[],1);
% end
% I = unpadimage(I,radius);
%end
%if(length(radius) == 4)
% I = padarray(I,[radius(2),radius(1)],-inf,'pre');
% I = padarray(I,[radius(4),radius(3)],-inf,'post');
% [n,m,thirdd] = size(I);
% B = I;
% for i = radius(1)+1:m-radius(3),
%  B(:,i,:) = max(I(:,[i-radius(1):i+radius(3)],:),[],2);
% end
% for i = radius(2)+1:n-radius(4),
%  I(i,:,:) = max(B([i-radius(2):i+radius(4)],:,:),[],1);
% end
% I = unpadimage(I,radius);
%end
