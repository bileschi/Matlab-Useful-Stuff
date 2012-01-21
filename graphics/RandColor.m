function C = RandColor(index)
%function C = RandColor(index)
% outputs a random color uniformly in RGB
if(nargin > 0)
   z = Colors;
   C = z(1+mod(index,size(z,1)),:);
else
   C = [rand rand rand];
end

function C = Colors
C = [0,1,2,3,5,6,8,9] * .1;
C = repmat(C(:),[2,1]);
C(1:10,2) = 1;
C(1:10,3) = 1;
C(11:20,2) = .5;
C(11:20,3) = .5;
C = hsv2rgb(C);
