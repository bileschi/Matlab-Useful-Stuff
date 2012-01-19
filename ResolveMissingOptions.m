function options = ResolveMissingOptions(options,d)
%function options = ResolveMissingOptions(options,d)
%finds fields in d that are missing in options, and fills those missing fields in options
% if for all fields in d, all those fields exist in options, then
% options is returned unchanged.

names = fieldnames(d);
for n = 1:length(names)
    if~(isfield(options,names{n}))
        options.(names{n}) = d.(names{n});
    end
end
