function [h,x,y] = FIG_cumulativeDistribution(z,bNormSumTo1,plotString)
%function [h,x,y] = FIG_cumulativeDistribution(z,bNormSumTo1,plotString)
%
%plots the function f(x) = count(z<=x);
%set bNormSumTo1 (default 0) to 1 to normalize sum to 1
%  f(x) = prob(z<=x);
% optional plotString alows to set the plot style

if(nargin < 2)
    bNormSumTo1 = 0;
end
if(nargin < 3)
    plotString = 'b-';
end
if(bNormSumTo1)
    y = (1:length(z))/length(z);
    x = sort(z);
    h = plot(x,y,plotString);
else
    y = 1:length(z);
    x = sort(z);
    h = plot(x,y,plotString);
end

