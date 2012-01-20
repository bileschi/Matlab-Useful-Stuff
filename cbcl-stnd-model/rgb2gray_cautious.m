function im = rgb2gray_cautious(im)
im = sum(double(im),3);
im = im - min(im(:));
im = im / max(im(:));
