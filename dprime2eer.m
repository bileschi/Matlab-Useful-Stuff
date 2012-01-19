function eer = dprime2eer(dprime);
%function eer = dprime2eer(dprime);

eer = 1 - normcdf(0,-(dprime/2),1);