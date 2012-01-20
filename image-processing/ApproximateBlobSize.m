function myBlobSize = ApproximateBlobSize(im,p_xy);
%function myBlobSize = ApproximateBlobSize(im,p_xy);
%
%thresholds the input image at the 95th ptile and computes the connected component at p_xy
%the size is the square root of the area of the blob
p_xy = round(p_xy);
bwim = im > percentile(Vectorize(im),.95);
bwim((p_xy(2)-1):(p_xy(2)+1),(p_xy(1)-1):(p_xy(1)+1)) = 1;
myBlobSize = sqrt(sum(Vectorize(bwselect(bwim,p_xy(1),p_xy(2),4)))); 
