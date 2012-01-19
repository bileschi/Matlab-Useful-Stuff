function b =isBlackImage(img);
%function b =isBlackImage(img);
% if(any(img(:)>0))
%     b = 0;
% else
%     b = 1;
% end
if(any(img(:)>0))
    b = 0;
else
    b = 1;
end
