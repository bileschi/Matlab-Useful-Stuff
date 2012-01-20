%%function sout = removeborders(sin,siz)
%sin = unpadimage(sin, [(siz+1)/2,(siz+1)/2,(siz-1)/2,(siz-1)/2]);
%sin = padarray(sin, [(siz+1)/2,(siz+1)/2],0,'pre');
%sout = padarray(sin, [(siz-1)/2,(siz-1)/2],0,'post');
        

function sout = removeborders(sin,siz)
%sout = [zeros((siz+1)/2, size(sin,2)); sin(
sout = sin;
sout(1:(siz+1)/2,:) = 0;
sout(end-(siz-1)/2+1:end,:) = 0;

sout(:,1:(siz+1)/2) = 0;
sout(:,end-(siz-1)/2+1:end) = 0;
