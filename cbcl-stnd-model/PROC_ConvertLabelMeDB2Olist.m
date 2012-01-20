function PROC_ConvertLabelMeDB2Olist(Root);
%function PROC_ConvertLabelMeDB2Olist(Root);
%
%passes any xml file under root to LMxml2olist
%
%may require adding LMxml2olist directory to path.
%
%/cbcl/scratch03/bileschi/Release/code

fns = fulldir(fullfile(Root,'*.xml'));
for i = 1:length(fns);
  newfn = strrep(fns(i).fullname,'.xml','_olist.mat');
  LM
end
