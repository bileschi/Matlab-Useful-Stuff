function [X,normparams] = normalizeByIndex(X,ci,normtype,normparams,options);
%normtype 1 = sqrt of L1
%normtype 2 = X ./ norm(X)
%normtype 3 = outnormalizeX;
if(nargin < 3)
  normtype = 1;
end

if(nargin < 4)
  normparams = [];
end
if(normtype == 1) % sqrt of L1
  X = abs(X);
  for i = 1:length(ci),
    X(ci{i},:) = MatrixNormalize(X(ci{i},:),normtype);
  end
end

if(normtype == 2) % X ./ normX
  if(isempty(normparams))
    for i = 1:length(ci),
      normparams.cExpectedPartNorm{i} = norm(X(ci{i},:));
    end
  end
  for i = 1:length(ci),
    X(ci{i},:) = length(ci{i})* ( X(ci{i},:) / normparams.cExpectedPartNorm{i});
  end
end

if(normtype == 3) % outnormalizeData X
  if(isempty(normparams))
    clear normparams
    for i = 1:length(ci),
       [X(ci{i},:),normparams{i}] = outnormalizeDataX(X(ci{i},:));
    end
  else
    for i = 1:length(ci),
       [X(ci{i},:),normparams{i}] = outnormalizeDataX(X(ci{i},:),normparams{i});
    end
  end
end

if(normtype == 4) % outnormalizeData X And Reweight Sections
  if(isempty(normparams))
    clear normparams
    for i = 1:length(ci),
       [X(ci{i},:),normparams{i}] = outnormalizeDataX(X(ci{i},:));
       X(ci{i},:) = X(ci{i},:) * options.NormalizationRelativeStrengths(i);
    end
  else
    for i = 1:length(ci),
       [X(ci{i},:),normparams{i}] = outnormalizeDataX(X(ci{i},:),normparams{i});
        X(ci{i},:) = X(ci{i},:) * options.NormalizationRelativeStrengths(i);
    end
  end
end

function X = MatrixNormalize(X, normType, normparams);
if(nargin < 3)
  normparams = [];
end

if(normType == 1)
 sX = sum(X);
 X = X * (spdiag(1./(sX+eps)));
 X = sqrt(X);
end

