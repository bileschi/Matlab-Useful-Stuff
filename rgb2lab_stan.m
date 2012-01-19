function imout = rgb2lab_stan(imin)
if(ndims(imin) < 3)
    fprintf('warning: image is grayscale\n');
    imin = repmat(imin,[1,1,3]);
end
s = size(imin);
imin_reshape = reshape(imin,[prod(s(1:2)),s(3)]);
size(imin_reshape);
XYZn = [ 0.9505 1.0000 1.0888 ]';  %% = rgb2xyz matrix * [1;1;1]

XYZ2 = [.412453 .357580 .180423;.212671 .715160 .072169;.019334 .119193 .950227];
XYZ = XYZ2*(im2double(imin_reshape))';

Lstar = 116*labF(XYZ(2,:))-16;

astar = 500*(labF(XYZ(1,:)./XYZn(1))-labF(XYZ(2,:)));
bstar = 200*(labF(XYZ(2,:))-labF(XYZ(3,:)./XYZn(3)));

newmap = [Lstar ; astar ; bstar]';
imout(:,:,1) = reshape(Lstar,s(1:2));
imout(:,:,2) = reshape(astar,s(1:2));
imout(:,:,3) = reshape(bstar,s(1:2));


return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function out=labF(in)

out = (in.^(1/3)).*(in>.008856) + (7.787.*in+16/116).*(in<=.008856);

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 1997-1999. The Regents of the University
% of California (Regents). All Rights Reserved.
% 
% Permission to use, copy, modify, and distribute this software and its
% documentation for educational, research, and not-for-profit purposes,
% without fee and without a signed licensing agreement, is hereby
% granted, provided that the above copyright notice, this paragraph and
% the following two paragraphs appear in all copies, modifications, and
% distributions. Contact The Office of Technology Licensing, UC Berkeley,
% 2150 Shattuck Avenue, Suite 510, Berkeley, CA 94720-1620, (510)
% 643-7201, for commercial licensing opportunities. Created by
% Chad Carson, Serge Belongie, and Jitendra Malik, Department of Electrical
% Engineering and Computer Sciences, University of California, Berkeley.
% For technical information, contact carson@eecs.berkeley.edu.
% 
% IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
% SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
% ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
% REGENTS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF
% ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION
% TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
% MODIFICATIONS.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

