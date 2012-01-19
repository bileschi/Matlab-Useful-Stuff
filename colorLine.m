function colorLine(X,Y,rgb);
%function colorLine(X,Y,rgb);
%
% wraps 'line' and sets color to rgb
if(nargin < 3)
    line(X,Y);
else
    h = line(X,Y);
    set(h,'Color',rgb);
end