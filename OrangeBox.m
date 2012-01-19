function out = OrangeBox(bbox,EdgeColor,Thickness);
%function OrangeBox(bbox,Color);
%
%faster way of calling rectangle.

if( (nargin < 2) || isempty(EdgeColor))
  EdgeColor = [1, .5, 0];
end
if(nargin < 3)
  Thickness = 1;
end

out = rectangle('position',bbox,'EdgeColor',EdgeColor,'LineWidth',Thickness);
