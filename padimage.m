function o = padimage(i,amnt,method)
%function o = padimage(i,amnt,method)
%
%padarray which operates on only the first 2 dimensions of a 3 dimensional
%image. (of arbitrary number of layers);
%
%String values for METHOD
%        'circular'    Pads with circular repetion of elements.
%        'replicate'   Repeats border elements of A.
%        'symmetric'   Pads array with mirror reflections of itself. 
%
%if(amnt) is length 1, then pad all sides same amount
%
%if(amnt) is length 2, then pad y direction amnt(1), and x direction amnt(2)
%
%if(amnt) is length 4, then pad sides unequally with order LTRB, left top right bottom
if(nargin < 3)
   method = 'replicate';
end
if(length(amnt) == 1)
  o = zeros(size(i,1) + 2 * amnt, size(i,2) + 2* amnt, size(i,3));
  for n = 1:size(i,3)
    o(:,:,n) = padarray(i(:,:,n),[amnt,amnt],method,'both');
  end
end
if(length(amnt) == 2)
  o = zeros(size(i,1) + 2 * amnt(1), size(i,2) + 2* amnt(2), size(i,3));
  for n = 1:size(i,3)
    o(:,:,n) = padarray(i(:,:,n),amnt,method,'both');
  end
end
if(length(amnt) == 4)
  o = zeros(size(i,1) + amnt(2) + amnt(4), size(i,2) + amnt(1) + amnt(3), size(i,3));
  for n = 1:size(i,3)
    o(:,:,n) = padarray(padarray(i(:,:,n),[amnt(2), amnt(1)],method,'pre'),[amnt(4), amnt(3)],method,'post');
  end
end
