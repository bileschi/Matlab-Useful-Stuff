function Res=wc(FileName,Option);
%--------------------------------------------------------------------------
% wc function     Call Unix wc (word count) command.
% Input  : - Character array containing file name.
%          - Options:
%            'c' - Return number of bytes only (fast).
%            'm' - Return number of chars only.
%            'l' - Return number of lines only (fast) - default.
%            'L' - Return max line length only.
%            'w' - Return number of words only.
% Output : - Requested number.
% Tested : Matlab 5.3 (on Linux).
%     By : Eran O. Ofek           July 2004
%    URL : http://wise-obs.tau.ac.il/~eran/matlab.html
%--------------------------------------------------------------------------
if (nargin==1),
   Option = 'l';
elseif (nargin==2),
   % do nothing
else
   error('Illegal number of input argument');
end

TMP_FILE = 'TMP_WC';
RunStr = sprintf('!wc -%c %s > %s',Option,FileName,TMP_FILE);
eval(RunStr);
FID = fopen(TMP_FILE,'r');
Res=fscanf(FID,'%f',1);
fclose(FID);
delete(TMP_FILE);
