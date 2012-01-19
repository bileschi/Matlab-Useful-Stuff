function NMtx = Normalize_Mtx_Apply(Mtx,N);
%function NMtx = Normalize_Mtx_Apply(Mtx,N);
d.bZeroMean = 1;
d.b1Std     = 1;
options = ResolveMissingOptions(N.options,d);
N.options = options;
s = size(Mtx);
NMtx= Mtx;
if(options.bZeroMean)
   NMtx = NMtx - repmat(N.mean,[1,s(2)]);
end
if(options.b1Std)
   N.std(find(N.std == 0)) = 1;
   NMtx = NMtx ./ max(eps,repmat(N.std,[1,s(2)]));   
end