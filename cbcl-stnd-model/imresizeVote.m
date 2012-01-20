function im2 = imresizeVote(im,yx_cellsize,newimsize,options);
%function im2 = imresizeVote(im,cellsize,newimsize);
% functions somewhat like imresize.  Each pixel votes its magnitued into one of the new pixels (ignoring 
% boundry effects).  This vote is split linearly between the 4 nearest pixels.  The implementation is simply
% to filter and decimate.
% 
% mass preserving imresize for image reduction in size.
% 
%
% INPUT: in, an input image
% 	yx_cellsize:  the size of the pooling area for which each pixel votes into
% 	alternatively, set cellsize to [] and newimsize to the desired outputsize of im2
% 	yx_cellsize will be determined automatically in this case

d.PadBoundaries = 1;
if(nargin < 4),options = [];,end
options = ResolveMissingOptions(options,d);
newimsize = [ceil(size(im,1)/yx_cellsize(1)),ceil(size(im,2)/yx_cellsize(2))];

if(options.PadBoundaries)
  im = padimage(im, 2*max(yx_cellsize),'symmetric');
end

if(isempty(yx_cellsize))
  yx_cellsize(1) = ceil(size(im,1) / newimsize);
  yx_cellsize(2) = ceil(size(im,2) / newimsize);
end
bilinfilt = MakeBilinearFilter(yx_cellsize);
filtim = imfilter(im,bilinfilt);
if(options.PadBoundaries)
  filtim = unpadimage(filtim, 2*max(yx_cellsize));
end
im2 = imresize(filtim,newimsize,'nearest');




