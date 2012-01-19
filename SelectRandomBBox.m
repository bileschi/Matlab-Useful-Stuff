function bbox = SelectRandomBBox(imagesize, hw_bboxsize)
%function bbox = SelectRandomBBox(imagesize, hw_bboxsize)
%
%returns a bbox with height and width = to hw_bboxsize that lies completely within an image of size
% imagesize.
%
%hw_bboxsize is in [height width] format

h = hw_bboxsize(1);
w = hw_bboxsize(2);
if(h > imagesize(1))
  error('image too small');
end
if(w > imagesize(2))
  error('image too small');
end

MaxLeft = imagesize(2) - w + 1;
Left = ceil(MaxLeft * rand);
MaxTop = imagesize(1) - h + 1;
Top = ceil(MaxTop * rand);
bbox = [Left, Top, w-1, h-1];

