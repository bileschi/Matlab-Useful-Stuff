function vsts(v)
%%function vsts(v)
%
%prints a number of useful statistics about vector v
%
%if a multiple dimensional array is input then it is vectorized first
v=v(:);
fprintf('\t%d elements\n',length(v));
if(any(isnan(v)))
    fprintf('\t%d nans\n',length(find(isnan(v))));
else
    fprintf('\tNO nans\n');
end
if(any(mod(v,1)))
    fprintf('\tSome non-integers\n');
    fprintf('\t%%is zero = %f\n',sum(v==0)/length(v));
    fprintf('\tmin = %f\n',min(v));
    fprintf('\tmean = %f\n',mean(v));
    fprintf('\tstd = %f\n',std(v));
    fprintf('\tmax = %f\n',max(v));
else
    fprintf('\tInteger valued\n');
    fprintf('\t%d are zero\n',sum(v==0));
    fprintf('\tmin = %d\n',min(v));
    fprintf('\tmedian = %d\n',median(v));
    fprintf('\tstd = %f\n',std(v));
    fprintf('\tmax = %d\n',max(v));
    if(length(unique(v)) == length(v))
        fprintf('\tall unique: YES\n');
    else
        fprintf('\tall unique: NO\n');
    end
end

