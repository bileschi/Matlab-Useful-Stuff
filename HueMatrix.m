function HueMtx = HueMatrix(n);
HueMtx = zeros(n,3);
for i = 1:n
   HueMtx(i,:) = permute(hsv2rgb((i-1)/n,1,1),[1,3,2]);
end
HueMtx = HueMtx ./ repmat(sum(HueMtx),[n,1]);
