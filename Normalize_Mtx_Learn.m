function N = Normalize_Mtx_Learn(Mtx,options)
%function N = Normalize_Mtx_Learn(Mtx,options)
%
if(not(exist('options'))),options = [];end
d.bZeroMean = 1;
d.b1Std     = 1;

options = ResolveMissingOptions(options,d);
N.options = options;
if(options.bZeroMean)
   N.mean = mean(Mtx,2);
end
if(options.b1Std)
   N.std = std(Mtx,0,2);
end
   