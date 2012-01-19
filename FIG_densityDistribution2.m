function [h,x,y] = FIG_densityDistribution2(z,bNormSumTo1,plotString)
%function [h,x,y] = FIG_densityDistribution2(z,bNormSumTo1,plotString)
%
%plots the function f(x) = diff(count(z<=x));
%set bNormSumTo1 (default 0) to 1 to normalize sum to 1
%  f(x) = diff(prob(z<=x));
% optional plotString alows to set the plot style
if(nargin < 2)
    bNormSumTo1 = 0;
end
if(nargin < 3)
    plotString = 'b-';
end
grain = 40;
if(bNormSumTo1)
    cx = sort(z);
    x = .5*(cx(1:(end-grain)) + cx((grain+1):end));
    yinv = (cx((grain+1):end)-cx(1:(end-grain))) ./ (grain/length(z)) ;
    y = 1./(yinv+eps);
    h = plot(x,y,plotString);
else
    cx = sort(z);
    x = .5*(cx(1:(end-grain)) + cx((grain+1):end));
    yinv = (cx((grain+1):end)-cx(1:(end-grain))) ./ grain;
    y = 1./(yinv+eps);
    h = plot(x,y,plotString);
end

