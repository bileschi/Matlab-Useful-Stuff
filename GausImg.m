function gi = GausImg(sz,c,sigma)
%function gi = GausImg(sz,c,sigma,opts)
%
if(length(sigma) == 1)
  sigma = [sigma sigma];
end
normler = ((2*pi)^.5 * (norm(sigma' * sigma))^.5)^-1;
gi = zeros(sz);
x = 1:sz(2);
y = (1:sz(1))';
x = exp(-((x-c(2)).^2/(2*sigma(2))));
y = exp(-((y-c(1)).^2/(2*sigma(1))));
gi = y*x;
