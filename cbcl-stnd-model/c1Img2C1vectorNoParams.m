function c1vec = c1Img2C1vectorNoParams(img);
% function c1vec = c1Img2C1vectorParams(img);
% a wrapper for c1Img2C1Simple which uses no parameters
% written for use with WindowedObjectDetectionNaive

% options.C1VerRegularC1 = 1;
options.C1Ver001 = 1;
[caC1,caS1] = c1Img2C1Simple(img,options);
c1vec = [];
for i = 1:length(caC1)
  c1vec = [c1vec(:);caC1{i}(:)];
end
    
