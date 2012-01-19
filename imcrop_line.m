function im2 = imcrop_line(im,lineX,lineY,width)
%function im2 = imcrop_line(im,lineX,lineY,width)
%
%like imcrop, but extracts a box along the line at width w
%
%usually faster than rotating the whole image and cropping.

th = atan2(lineY(1)-lineY(2),lineX(1)-lineX(2));
sth = sin(th);
cth = cos(th);
w2 = width/2;
b1_x = lineX(1) - w2*sth;
b1_y = lineY(1) + w2*cth;
b2_x = lineX(1) + w2*sth;
b2_y = lineY(1) - w2*cth;
b3_x = lineX(2) - w2*sth;
b3_y = lineY(2) + w2*cth;
b4_x = lineX(2) + w2*sth;
b4_y = lineY(2) - w2*cth;

mx = min([b1_x,b2_x,b3_x,b4_x]);
Mx = max([b1_x,b2_x,b3_x,b4_x]);
my = min([b1_y,b2_y,b3_y,b4_y]);
My = max([b1_y,b2_y,b3_y,b4_y]);

minBox = [mx,my,Mx-mx,My-my];
for iLay = 1:size(im,3)
   imc(:,:,iLay) = imcrop(im(:,:,iLay),round(minBox));
end
th_d = (th * 360 / (2*pi));
if(th_d > 90)
   th_d = th_d - 180;
end
imisgood= imrotate(ones([size(imc,1),size(imc,2),1]),th_d);
for iLay = 1:size(im,3)
   imcr(:,:,iLay) = imrotate(imc(:,:,iLay),th_d);
end
bbox = getcroplimitbbox(imisgood,width);
for iLay = 1:size(im,3)
  im2(:,:,iLay) = imcrop(imcr(:,:,iLay),round(bbox));
end

function bbox = getcroplimitbbox(imcr,width);
%find the left and right limits for the bounding box.
%
h = size(imcr,1)/2;
u = round(h-width/2);
d = u + width-1;
usepart = imcr(u:d,:);
s = sum(usepart,1);
f = find(s == width);
m = min(f);
M = max(f);
bbox = [m,u,M-m,d-u];
