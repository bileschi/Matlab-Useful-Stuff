function [c1,s1,v1] = C1_stanedit(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,options)
%function [c1,s1,v1] = C1_stanedit(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,options)
%
%  A matlab implementation of the C1 code originally by Max Riesenhuber
%  and Thomas Serre.
%  Adapted by Stanley Bileschi
%
%  Returns the C1 and the S1 units' activation given the  
%  input image, stim.
%  filters, fSiz, c1ScaleSS, c1ScaleSS, c1OL, INCLUDEBORDERS are the
%  parameters of the C1 system
%
%  stim   - the input image must be grayscale (single channel) and 
%   type ''double''
%
%%% For S1 unit computation %%%
%
% filters -  Matrix of Gabor filters of size max_fSiz x num_filters,
% where max_fSiz is the length of the largest filter and num_filters the
% total number of filters. Column j of filters matrix contains a n_jxn_j
% filter (reshaped as a column vector and padded with zeros).
%
% fSiz - Vector of size num_filters containing the various filter
% sizes. fSiz(j) = n_j if filters j is n_j x n_j (see variable filters
% above).
%
%%% For C1 unit computation %%%
%
% c1ScaleSS  - Vector defining the scale bands, i.e. a group of filter
% sizes over which a local max is taken to get the C1 unit responses,
% e.g. c1ScaleSS = [1 k num_filters+1] means 2 scale bands, the first
% one contains filters(:,1:k-1) and the second one contains
% filters(:,k:num_filters). If N pooling bands, c1ScaleSS should be of
% length N+1.
%
% c1SpaceSS - Vector defining the spatial pooling range for each scale
% band, i.e. c1SpaceSS(i) = m_i means that each C1 unit response in band
% i is obtained by taking a max over a local neighborhood of m_ixm_i S1
% units. If N bands then c1SpaceSS should be of size N.
%
% c1OL - Scalar value defining the overlap between C1 units. In scale
% band i, the C1 unit responses are computed every c1Space(i)/c1OL.
%
% INCLUDEBORDERS - the type of treatment for the image borders.
% 
% STAN'S Additions
% (20) July05: The ability to turn on or off the normalization stage before individual filters
% (20) July05: Maximization now takes place radially, instead of up and to the left.
% (20) July05: Sampling now takes place more or less centered, rather than up and to the left.
% (9) Aug05: options are handled using a structure, rather than a list of parameters.
% (9) Aug05: added orientation estimation
% (9) Aug05: added new smoothing options (max, sum, kernelsum);
% (9) Aug05: added blockwise normalization output (only visible in v1, the vector output);
% (1) Sept05: fixed a bug in sampling locations where sample starts at 0 for some sizes.);
% (25) Oct05: Added an option to retain only the value of the orientation which fires most strongly
stim = im2double(stim);
numScaleBands=length(c1ScaleSS)-1;  % convention: last element in c1ScaleSS is max index + 1 
numScales=c1ScaleSS(end)-1; 
%   last index in scaleSS contains scale index where next band would start, i.e., 1 after highest scale!!
numSimpleFilters=floor(length(fSiz)/numScales);

d.bEstimateOrientations = 0;
d.nOriEstimates = 9;
d.INCLUDEBORDERS = 1;  % zero matts the image boundries
d.DecimationScheme = 'maxfilter'; % blurring procedure before decimation.  choices are
% 				    'maxfilter', 'sumfilter', and 'kernel_sum_filter'
d.NORMALIZEMASK = ones(numSimpleFilters,1);  % a 1 indicates that the filt response should be normed locally
                                             % by the average image grayscale brightness.  Use for derivatvive
					     % filters but not for smoothing filters.
d.bUseBlockwiseNormalization = 0;
d.bSimulatedLaplacian = 0;
d.UseLinearVersionOfSimulatedLap = 0;
d.BlockwiseNormParams_yxCellsPerBlock = [2,2];
d.BlockwiseNormParams_yxBlockSpacing =  [1,1];
d.BlockwiseNormParams_Norm =  'sqrtL1';
d.bRetainOnlyMaximumOrientation = 0;
if(nargin < 7), options = [];, end
options = ResolveMissingOptions(options,d);, clear d

for iBand = 1:numScaleBands
  ScalesInThisBand{iBand} = c1ScaleSS(iBand):(c1ScaleSS(iBand+1) -1);
end  
if(nargin < 8)
  NORMALIZEMASK = ones(numSimpleFilters,1);
end

% Rebuild all filters (of all sizes)
%%%%%%%%
nFilts = length(fSiz);
for i = 1:nFilts
  sqfilter{i} = reshape(filters(1:(fSiz(i)^2),i),fSiz(i),fSiz(i));
end

% Calculate all filter responses (s1)
%%%%%%%%
sqim = stim.^2;
iUFilterIndex = 0;
% precalculate the normalizations for the usable filter sizes
uFiltSizes = unique(fSiz);
for i = 1:length(uFiltSizes)
  s1Norm{uFiltSizes(i)} = (sumfilter(sqim,(uFiltSizes(i)-1)/2)).^0.5;
  %avoid divide by zero (regularize)  %%%STAN EDIT, there was a possible error here when working with double imgs
  s1Norm{uFiltSizes(i)} = s1Norm{uFiltSizes(i)} + .05 * mean(s1Norm{uFiltSizes(i)}(:)) * ~s1Norm{uFiltSizes(i)};
end

for iBand = 1:numScaleBands
   for iScale = 1:length(ScalesInThisBand{iBand})
     for iFilt = 1:numSimpleFilters
       iUFilterIndex = iUFilterIndex+1;
       s1{iBand}{iScale}{iFilt} = imfilter(stim, sqfilter{iUFilterIndex},'symmetric','same','corr');
       if(options.bEstimateOrientations == 0)
         s1{iBand}{iScale}{iFilt} = abs(s1{iBand}{iScale}{iFilt});
       end
       if(~options.INCLUDEBORDERS)
         s1{iBand}{iScale}{iFilt} = removeborders(s1{iBand}{iScale}{iFilt},fSiz(iUFilterIndex));
       end
       if(options.NORMALIZEMASK(iFilt))
         s1{iBand}{iScale}{iFilt} = im2double(s1{iBand}{iScale}{iFilt}) ./ s1Norm{fSiz(iUFilterIndex)};
       else
         s1{iBand}{iScale}{iFilt} = im2double(s1{iBand}{iScale}{iFilt}) / mean(mean(s1Norm{fSiz(iUFilterIndex)}));
       end
     end
   end
end

% if necessary, estimate the additional orientation layers
% assume the first 2 filters are an x and y derivitive, respectively.
if(options.bEstimateOrientations)
  olds1 = s1;
  clear s1
  numSimpleFilters = options.nOriEstimates;
  for iBand = 1:numScaleBands
     for iScale = 1:length(ScalesInThisBand{iBand})
       ori = mod(atan2(olds1{iBand}{iScale}{1},olds1{iBand}{iScale}{2}),pi);
       Mag = sqrt(olds1{iBand}{iScale}{1}.^2 + olds1{iBand}{iScale}{2}.^2);
       Mag = repmat(Mag,[1 1 numSimpleFilters]);
       ori_f = SoftIndexLoop(ori,0,pi,numSimpleFilters);
       for iOri = 1:numSimpleFilters
	 s1{iBand}{iScale}{iOri} = Mag(:,:,iOri) .* ori_f(:,:,iOri);
       end
     end
  end
end
if(options.bSimulatedLaplacian)
% Replace each filter output at x with the minimum of the other filter outputs at x
  if(not(options.UseLinearVersionOfSimulatedLap))
      for iBand = 1:numScaleBands
     for iScale = 1:length(ScalesInThisBand{iBand})
       z = zeros(size(s1{iBand}{iScale}{1},1),size(s1{iBand}{iScale}{1},2),numSimpleFilters);
       for iOri = 1:numSimpleFilters
         z(:,:,iOri) = s1{iBand}{iScale}{iOri};
       end
       for iOri = 1:numSimpleFilters
	 if(iOri == 1)
	% s1{iBand}{iScale}{iOri} = min(z(:,:,setdiff(1:numSimpleFilters,iOri)),[],3);
  	   s1{iBand}{iScale}{iOri} = min(z,[],3);
	 else
  	   s1{iBand}{iScale}{iOri} = s1{iBand}{iScale}{1};
	 end
       end
     end
    end
  else
   % Replace each filter with the sum.
    for iBand = 1:numScaleBands
     for iScale = 1:length(ScalesInThisBand{iBand})
       z = zeros(size(s1{iBand}{iScale}{1},1),size(s1{iBand}{iScale}{1},1),numSimpleFilters);
       for iOri = 1:numSimpleFilters
         z(:,:,iOri) = s1{iBand}{iScale}{iOri};
       end
       for iOri = 1:numSimpleFilters
	 if(iOri == 1)
  	   s1{iBand}{iScale}{iOri} = (sum(z(:,:,:),3) / numSimpleFilters);
	 else
  	   s1{iBand}{iScale}{iOri} = s1{iBand}{iScale}{1};
	 end
       end
     end
    end
  end
  numSimpleFilters = 1;
end

if(options.bRetainOnlyMaximumOrientation)
  for iBand = 1:numScaleBands
    for iScale = 1:length(ScalesInThisBand{iBand})
      M = zeros(size(s1{iBand}{iScale}{1},1),size(s1{iBand}{iScale}{1},2),numSimpleFilters);
      for iOri = 1:numSimpleFilters
        M(:,:,iOri) = s1{iBand}{iScale}{iOri};
      end
      M = RetainOnlyMaximumInDepth(M);
      for iOri = 1:numSimpleFilters
        s1{iBand}{iScale}{iOri} = M(:,:,iOri);
      end
    end
  end
end

clear olds1
% Calculate local pooling (c1)
%%%%%%%%
%   (1) pool over scales within band
for iBand = 1:numScaleBands
  for iFilt = 1:numSimpleFilters
    c1{iBand}(:,:,iFilt) = zeros(size(s1{iBand}{1}{iFilt}));
    for iScale = 1:length(ScalesInThisBand{iBand});
      c1{iBand}(:,:,iFilt) = max(c1{iBand}(:,:,iFilt),s1{iBand}{iScale}{iFilt});
    end
  end
end

%   (2) pool over local neighborhood
for iBand = 1:numScaleBands
  pRange1 = ceil((c1SpaceSS(iBand)-1)/2);
  pRange2 = floor((c1SpaceSS(iBand)-1)/2);
  for iFilt = 1:numSimpleFilters
    switch options.DecimationScheme
      case 'maxfilter'
        c1{iBand}(:,:,iFilt) = maxfilter(c1{iBand}(:,:,iFilt),[pRange1 pRange1 pRange2 pRange2]);
      case 'sumfilter'
        c1{iBand}(:,:,iFilt) = sumfilter(c1{iBand}(:,:,iFilt),[pRange1 pRange1 pRange2 pRange2]);
      case 'kernel_sum_filter'
	beforesize = size(c1{iBand}(:,:,iFilt));
	c1OneFilt = imresizeVote(c1{iBand}(:,:,iFilt),[pRange1 pRange1]);
        c1{iBand}(:,:,iFilt) = imresize(c1OneFilt,beforesize,'nearest');
    end
  end
end


%   (3) subsample
for iBand = 1:numScaleBands
  sSS=ceil(c1SpaceSS(iBand)/c1OL);
  clear T;
  for iFilt = 1:numSimpleFilters
    r1 = ceil((mod(size(c1{iBand},1)-1,sSS)+1)/2);
    r2 = ceil((mod(size(c1{iBand},2)-1,sSS)+1)/2);
    T(:,:,iFilt) = c1{iBand}(r1:sSS:end,r2:sSS:end,iFilt);
  end
  c1{iBand} = T;
end

% (OPTIONAL Blockwise Normalization Stage)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(options.bUseBlockwiseNormalization)
  yxCPB = options.BlockwiseNormParams_yxCellsPerBlock;
  yxBSpan = options.BlockwiseNormParams_yxBlockSpacing;
  NormString = options.BlockwiseNormParams_Norm;
  v1 = [];
  for iBand = 1:numScaleBands
    for iBlock_x = 1:yxBSpan(2):(size(c1{iBand},2)-yxCPB(2)+1)
      for iBlock_y = 1:yxBSpan(1):(size(c1{iBand},1)-yxCPB(1)+1)
        fBlocky = (1:yxCPB(1))+iBlock_y-1;
	     fBlockx = (1:yxCPB(2))+iBlock_x-1;
	     v1 = [v1;NormalizeByString(c1{iBand}(fBlocky,fBlockx,:),NormString)];
      end
    end
  end
nori = size(c1{1},3);
nx = size(c1{1},2);
ny = size(c1{1},1);
nxblox = length(1:yxBSpan(2):(size(c1{iBand},2)-yxCPB(2)+1));
nyblox = length(1:yxBSpan(1):(size(c1{iBand},1)-yxCPB(1)+1));
c1 = {v1};
else
  v1 = vectorizeCellArray(c1);
end

function sout = removeborders(sin,siz)
sin = unpadimage(sin, [(siz+1)/2,(siz+1)/2,(siz-1)/2,(siz-1)/2]);
sin = padarray(sin, [(siz+1)/2,(siz+1)/2],0,'pre');
sout = padarray(sin, [(siz-1)/2,(siz-1)/2],0,'post');
       
function x = NormalizeByString(x,NormString)
x = x(:);
switch NormString
 case 'sqrtL1'
   x = sqrt(x/(sum(x)+eps));
end

