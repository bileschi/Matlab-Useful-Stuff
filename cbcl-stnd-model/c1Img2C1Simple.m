function [caC1,caS1] = c1Img2C1Simple(InputImage,options);
%function [caC1,caS1] = c1Img2C1Simple(InputImage,options);

HelpTextInfo = 'c1Img2C1Simple';
d.C1Ver001 = 0;
d.C1Ver002 = 0;
d.C1Ver003 = 0;
d.C1Ver004 = 0;
d.C1Ver006 = 0;
d.C1Ver007 = 0;
d.C1Ver008 = 0;
d.C1Ver009 = 0;
d.C1Ver010 = 0;
d.C1Ver011 = 0;
d.C1Ver011_NoSubsample = 0;
d.C1VerStanFavorite = 0;
d.C1VerStanFavorite2 = 0;
d.C1VerRegularC1 = 0;
d.C1VerRegularC1OnlyFirstBand = 0;
d.C1VerTriggs = 0;
d.C1VerRaytheon = 0;
d.C1Ver32x32 = 0;
d.DoAreaOfSegmentedImage = 0;

if(nargin < 2),
  options = [];
  options.C1VerRegularC1 = 1;
end
options = ResolveMissingOptions(options,d);

CheckC1Ver(options);

if(size(InputImage,3) == 3)
  InputImage = rgb2gray(InputImage);
end
[caC1,cccaS1] = GrayX2C1X(InputImage,size(InputImage),options);
if(nargout == 1)
   return;
end
nb = size(cccaS1,2);
nbpb = size(cccaS1{1},2);
nl = size(cccaS1{1}{1},2);
n = 0;
for i = 1:nb
  for j = 1:nbpb
    n = n+1;
    caS1{n} = zeros(size(cccaS1{i}{j}{1},1),size(cccaS1{i}{j}{1},2),nl);
    for k = 1:nl
      caS1{n}(:,:,k) = cccaS1{i}{j}{k};
    end
  end
end      
      
function [caC1,cccaS1,c1params,options] = GrayX2C1X(stim,originalres,options);
[options,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,numSimpleFilters] = GetOptions(options);
if(options.DoAreaOfSegmentedImage)
  stim = SegmentationImToAreaIm(stim);
  stim = (stim - min(stim(:))) / (max(stim(:)) - min(stim(:)));
  stim = histeq(stim);
end
[caC1,cccaS1,v1] = C1_stanedit(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,options);

c1params = [];
% c1params.rot = rot;
% c1params.div = div;
% c1params.RF_siz = RF_siz;
c1params.c1ScaleSS = c1ScaleSS;
c1params.c1SpaceSS = c1SpaceSS;
c1params.c1OL = c1OL;
c1params.filters = filters;
c1params.fSiz = fSiz;
c1params.numSimpleFilters = numSimpleFilters;


function CheckC1Ver(options)
verArr(1) = options.C1Ver001;
verArr(2) = options.C1Ver002;
verArr(3) = options.C1Ver003;
verArr(4) = options.C1Ver004;
verArr(5) = options.C1Ver006;
verArr(6) = options.C1Ver007;
verArr(7) = options.C1Ver008;
verArr(8) = options.C1Ver009;
verArr(9) = options.C1Ver010;
verArr(10) = options.C1VerRegularC1;
verArr(11) = options.C1VerStanFavorite;
verArr(12) = options.C1VerTriggs;
verArr(13) = options.C1VerStanFavorite2;
verArr(14) = options.C1VerRegularC1OnlyFirstBand;
verArr(15) = options.C1Ver011;
verArr(16) = options.C1Ver011_NoSubsample;
verArr(17) = options.C1VerRaytheon;
verArr(18) = options.C1Ver32x32;

if(not(any(verArr)))
  error('c1Img2C1Simple: No C1 Version specified\n');
end
if( length(find(verArr)) > 1)
  error('c1Img2C1Simple: More than one Version Specified\n');
end

function [options,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,numSimpleFilters] = GetOptions(options)
if(options.C1Ver001)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,12]);
  filters(:,1) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,2) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,3) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,4) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,5) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,6) = [0;0;0;0;1;0;0;0;0];
  filters(:,7) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,8) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,9) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,10) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,11) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,12) = [0;0;0;0;1;0;0;0;0];
  numSimpleFilters = 6;
  options.NORMALIZEMASK = [1 1 1 1 1 0];
end
if(options.C1Ver002)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 1;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,12]);
  filters(:,1) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,2) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,3) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,4) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,5) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,6) = [0;0;0;0;1;0;0;0;0];
  filters(:,7) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,8) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,9) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,10) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,11) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,12) = [0;0;0;0;1;0;0;0;0];
  numSimpleFilters = 6;
  options.NORMALIZEMASK = [1 1 1 1 1 0];
end
if(options.C1Ver003)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 1;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 1;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  options.NORMALIZEMASK = [0 0];
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,4]);
  filters(:,1) = [0;1;0;0;0;0;0;-1;0];
  filters(:,2) = [0;0;0;-1;0;1;0;0;0];
  filters(:,3) = [0;1;0;0;0;0;0;-1;0];
  filters(:,4) = [0;0;0;-1;0;1;0;0;0];
  numSimpleFilters = 2;
end
if(options.C1Ver004)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 1;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 1;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  options.NORMALIZEMASK = [0 0 0 0];
  options.DecimationScheme = 'kernel_sum_filter';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,4]);
  filters(:,1) = [0;1;0;0;0;0;0;-1;0];
  filters(:,2) = [0;0;0;-1;0;1;0;0;0];
  filters(:,3) = [0;1;0;0;0;0;0;-1;0];
  filters(:,4) = [0;0;0;-1;0;1;0;0;0];
  numSimpleFilters = 2;
end
if(options.C1VerTriggs)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 1;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 1;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  options.NORMALIZEMASK = [0 0];
  options.DecimationScheme = 'kernel_sum_filter';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [8];
  c1OL = 1; 
  fSiz = repmat(3,[1,4]);
  filters(:,1) = [0;1;0;0;0;0;0;-1;0];
  filters(:,2) = [0;0;0;-1;0;1;0;0;0];
  filters(:,3) = [0;1;0;0;0;0;0;-1;0];
  filters(:,4) = [0;0;0;-1;0;1;0;0;0];
  numSimpleFilters = 2;
end
if(options.C1Ver006)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  options.DecimationScheme = 'kernel_sum_filter';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,12]);
  filters(:,1) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,2) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,3) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,4) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,5) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,6) = [0;0;0;0;1;0;0;0;0];
  filters(:,7) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,8) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,9) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,10) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,11) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,12) = [0;0;0;0;1;0;0;0;0];
  numSimpleFilters = 6;
  options.NORMALIZEMASK = [1 1 1 1 1 0];
end
if(options.C1Ver007)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  options.DecimationScheme = 'sumfilter';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,12]);
  filters(:,1) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,2) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,3) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,4) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,5) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,6) = [0;0;0;0;1;0;0;0;0];
  filters(:,7) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,8) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,9) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,10) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,11) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,12) = [0;0;0;0;1;0;0;0;0];
  numSimpleFilters = 6;
  options.NORMALIZEMASK = [1 1 1 1 1 0];
end
if(options.C1Ver008)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 1;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  options.NORMALIZEMASK = [0 0];
  options.DecimationScheme = 'kernel_sum_filter';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,4]);
  filters(:,1) = [0;1;0;0;0;0;0;-1;0];
  filters(:,2) = [0;0;0;-1;0;1;0;0;0];
  filters(:,3) = [0;1;0;0;0;0;0;-1;0];
  filters(:,4) = [0;0;0;-1;0;1;0;0;0];
  numSimpleFilters = 2;
end
if(options.C1Ver009)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 1;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  options.NORMALIZEMASK = [0 0];
  options.DecimationScheme = 'kernel_sum_filter';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,4]);
  filters(:,1) = [0;1;0;0;0;0;0;-1;0];
  filters(:,2) = [0;0;0;-1;0;1;0;0;0];
  filters(:,3) = [0;1;0;0;0;0;0;-1;0];
  filters(:,4) = [0;0;0;-1;0;1;0;0;0];
  numSimpleFilters = 2;
end
if(options.C1Ver010)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 1;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  options.NORMALIZEMASK = [0 0];
  options.DecimationScheme = 'maxfilter';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,4]);
  filters(:,1) = [0;1;0;0;0;0;0;-1;0];
  filters(:,2) = [0;0;0;-1;0;1;0;0;0];
  filters(:,3) = [0;1;0;0;0;0;0;-1;0];
  filters(:,4) = [0;0;0;-1;0;1;0;0;0];
  numSimpleFilters = 2;
end
if(options.C1Ver011)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [8];
  c1OL = 2; 
  fSiz = repmat(3,[1,12]);
  filters(:,1) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,2) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,3) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,4) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,5) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,6) = [0;0;0;0;1;0;0;0;0];
  filters(:,7) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,8) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,9) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,10) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,11) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,12) = [0;0;0;0;1;0;0;0;0];
  numSimpleFilters = 6;
  options.NORMALIZEMASK = [1 1 1 1 1 0];
end
if(options.C1Ver011_NoSubsample)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [8];
  c1OL = 8; 
  fSiz = repmat(3,[1,12]);
  filters(:,1) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,2) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,3) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,4) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,5) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,6) = [0;0;0;0;1;0;0;0;0];
  filters(:,7) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,8) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,9) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,10) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,11) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,12) = [0;0;0;0;1;0;0;0;0];
  numSimpleFilters = 6;
  options.NORMALIZEMASK = [1 1 1 1 1 0];
end

if(options.C1VerStanFavorite)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 'not estimating orientations';
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = 'no blockwise';
  options.BlockwiseNormParams_yxBlockSpacing =  'no blockwise';
  options.BlockwiseNormParams_Norm =  'no blockwise';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,8]);
  filters(:,1) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,2) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,3) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,4) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,5) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,6) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,7) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,8) = [1;1;0;1;0;-1;0;-1;-1];
  numSimpleFilters = 4;
  options.NORMALIZEMASK = [1 1 1 1];
end
if(options.C1VerStanFavorite2)
  options.includelaplacianfilter = 0;
  options.includegrayscalefilter = 0;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 'not estimating orientations';
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = 'no blockwise';
  options.BlockwiseNormParams_yxBlockSpacing =  'no blockwise';
  options.BlockwiseNormParams_Norm =  'no blockwise';
  options.bRetainOnlyMaximumOrientation =  1;
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [24];
  c1OL = 3; 
  fSiz = repmat(3,[1,8]);
  filters(:,1) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,2) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,3) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,4) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,5) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,6) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,7) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,8) = [1;1;0;1;0;-1;0;-1;-1];
  numSimpleFilters = 4;
  options.NORMALIZEMASK = [0 0 0 0];
end
if(options.C1VerRegularC1)
  rot = [90 -45 0 45];
  c1ScaleSS = [1:2:18];
  RF_siz    = [7:2:39];
  c1SpaceSS = [8:2:22];
  div = [4:-.05:3.2];
  [fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, div);
end
if(options.C1VerRegularC1OnlyFirstBand)
  rot = [90 -45 0 45];
  c1ScaleSS = [1:2:3];
  RF_siz    = [7:2:9];
  c1SpaceSS = [8:2:10];
  div = [4:-.05:3.95];
  [fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, div);
end
if(options.C1VerRaytheon)
  options.includelaplacianfilter = 1;
  options.includegrayscalefilter = 1;
  options.bEstimateOrientations = 0;
  options.nOriEstimates = 9;
  options.INCLUDEBORDERS = 1;  
  options.bUseBlockwiseNormalization = 0;
  options.BlockwiseNormParams_yxCellsPerBlock = [2,2];
  options.BlockwiseNormParams_yxBlockSpacing =  [1,1];
  options.BlockwiseNormParams_Norm =  'sqrtL1';
  c1ScaleSS = [1:2:3];
  c1SpaceSS = [8];
  c1OL = 2; 
  fSiz = repmat(3,[1,12]);
  filters(:,1) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,2) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,3) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,4) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,5) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,6) = [0;0;0;0;1;0;0;0;0];
  filters(:,7) = [1;1;1;0;0;0;-1;-1;-1];
  filters(:,8) = [-1;0;1;-1;0;1;-1;0;1];
  filters(:,9) = [0;1;1;-1;0;1;-1;-1;0];
  filters(:,10) = [1;1;0;1;0;-1;0;-1;-1];
  filters(:,11) = [-1;-1;-1;-1;8;-1;-1;-1;-1];
  filters(:,12) = [0;0;0;0;1;0;0;0;0];
  numSimpleFilters = 6;
  options.NORMALIZEMASK = [1 1 1 1 1 0];
end
if(options.C1Ver32x32)
  rot = [90 -45 0 45];
  c1ScaleSS = [1:2:18];
  c1ScaleSS = c1ScaleSS(1:4); 
  RF_siz    = [7:2:39];
  RF_siz    = RF_siz(1:6);
  c1SpaceSS = [8:2:22];
  c1SpaceSS = c1SpaceSS(1:3); 
  div = [4:-.05:3.2];
  div = div(1:6);
  [fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, div);
end

