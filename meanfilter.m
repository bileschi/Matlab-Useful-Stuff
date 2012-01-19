function B = meanfilter(A,rad);
nlayers = size(A,3);
A = padimage(A,rad,'symmetric');
for i = 1:nlayers
  B(:,:,i) = colfilt(A(:,:,i),[rad rad],'sliding',@mean);
end
B = unpadimage(B,rad);
