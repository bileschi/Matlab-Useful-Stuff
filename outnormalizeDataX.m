function [X,normXweights,original_order] = outnormalizeDataX(X,normXweights,options);
%function [X,normXweights,original_order] = outnormalizeDataX(X,normXweights,options);

if nargin>1
     default_options.useExternalWeights = ~isempty(normXweights);
else
     default_options.useExternalWeights = 0;
end

default_options.removeZeroRows = 0;
default_options.normalizeColumns = 0;

if nargin < 3
    options = default_options;
end
nf = size(X,1);
ns = size(X,2);

if options.normalizeColumns
    for i = 1:ns,
        if(norm(X(:,i)) ~= 0)
            X(:,i) = X(:,i)./norm(X(:,i));
        end
    end
end

if (not(options.useExternalWeights ))
    normXweights = zeros(nf,2);
    normXweights(:,2) = 1;
    outstd = sqrt(2);
    normXweights(:,1) = (sum(X')')./ns;
    X = X - normXweights(:,1)*ones(1,ns);
    normXweights(:,2) = sqrt(sum(X'.^2))'/outstd;
    normXweights(find(normXweights == 0)) = -1;    
    normXweights(:,2) = 1./normXweights(:,2);
    tmp = speye(size(normXweights,1));
    tmp(find(tmp)) = normXweights(:,2);
    X = tmp*X;
else%use external weights
    if(size(X,1) > 3000);%stan 11.17  this keeps memchoking me
        for k = 1:(size(X,1))
            X(k,:) = X(k,:) - normXweights(k,1)*ones(1,ns);
            X(k,:) = X(k,:) * normXweights(k,2);    
        end
    else
        X = X - normXweights(:,1)*ones(1,ns);
        normXweights(find(normXweights == 0)) = -1;
        tmp = speye(size(normXweights,1));
        tmp(find(tmp)) = normXweights(:,2);
        X = tmp*X;
    end    
end

normXweights(find(normXweights == -1)) = 0;

original_order = 1:size(X,1);
if(options.removeZeroRows)
    original_order = find(normXweights(:,2));
    X = X(original_order,:);
end
