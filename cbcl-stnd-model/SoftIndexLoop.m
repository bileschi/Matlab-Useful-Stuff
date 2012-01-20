function ori_f = SoftIndexLoop(ori,minAng,maxAng,nBins)
%function ori_f = SoftIndexLoop(ori)
%linearly interpolate each element of ori into the ori bins, record the weights in ori_f
%
ori_f = zeros(size(ori,1), size(ori,2), nBins);
ori_i = nBins * ((ori - minAng) / maxAng);
for i = 1:nBins
   upper_hit_here = find(ceil(ori_i) == i);
   fpart = ori_i - fix(ori_i);
   onelayer = zeros(size(ori_f(:,:,1)));
   onelayer(upper_hit_here) = fpart(upper_hit_here);
   ori_f(:,:,i) = ori_f(:,:,i) + onelayer;
end
for i = 1:nBins
   lower_hit_here = find((mod(floor(ori_i-1),nBins)+1) == i);
   fpart = 1 - ori_i + fix(ori_i);
   onelayer = zeros(size(ori_f(:,:,1)));
   onelayer(lower_hit_here) = fpart(lower_hit_here);
   ori_f(:,:,i) = ori_f(:,:,i) + onelayer;
end
