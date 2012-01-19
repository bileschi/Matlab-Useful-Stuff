function bbox = bboxFromCenterAndRadius(center_xy,radius)
%function bbox = bboxFromCenterAndRadius(center_xy,radius)
%
%returns a square bounding box [left,top,width,height]
%  with center center_xy and width 2*radius + .5;

bbox(1) = center_xy(1)-radius;
bbox(2) = center_xy(2)-radius;
bbox(3) = 2*radius;
bbox(4) = 2*radius;
