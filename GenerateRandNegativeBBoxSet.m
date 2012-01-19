function [selected_nonobjs_bboxs,idxout] = GenerateRandNegativeBBoxSet(selected_bboxs, idxin,objectname,negperpos,options);
%function [selected_nonobjs_bboxs,idxout] = GenerateRandNegativeBBoxSet(selected_bboxs, idxin,objectname,negperpos,options);
%
%intent: for street scene use.  Selects negative examples from the same size and shape distribution
%        of the positive examples, but doesn't overlap the object mask too much.  Also does not
%        exit the boundary.


nbox = size(selected_bboxs,1);
nidx = length(idxin);
if(exist('CAFileList_FilterSS'))
  load CAFileList_FilterSS;%-->CAfilelist;
  d.CAfilelist = CAfilelist;
else
  d.CAfilelist = {};
end
d.InSize = [960 1280];
if(nargin < 5);
  options = [];
end
options = ResolveMissingOptions(options,d);

n=1;
for i = 1:nbox
   if(mod(i,10)==0)
     fprintf('%d\n',i);
   end
   for j = 1:negperpos
      rand_idx = ceil(rand*nidx);
      idx = idxin(rand_idx);
      rand_box = ceil(rand*nbox);
      box = selected_bboxs(rand_box,:);
      [selected_nonobjs_bboxs(n,:)] = Get10PercentBox(box,idx,options.CAfilelist,objectname,options);
      idxout(n) = idx;
      n = n+1;
   end
end     

function outbox = Get10PercentBox(inbox,idx,CAfilelist,objectname,options)
img = imread(CAfilelist{idx}.imagename);
olist = QReadOList2(CAfilelist{idx}.olistname);
if(isfield(olist,objectname))
  mask = QGetObjectMask(olist.(objectname),options.InSize);
else
  mask = zeros(options.InSize);
end
done = 0;
retrycount = 0;
while(not(done))
   while(any(options.InSize <= inbox([4,3])));
     inbox(3:4) = floor(inbox(3:4) * .9);
   end
   outbox =  SelectRandomBBox(options.InSize, inbox([4,3])+1);
   overlap = CalculateOverlap(outbox, mask);
   if(overlap < .1)
      done = 1;
   else
      retrycount = retrycount + 1;
   end
   if (retrycount == 25)
      retrycount = 0;
      inbox(3:4) = floor(inbox(3:4) * .9);
   end
end

function overlap = CalculateOverlap(box,mask)
support = sum(sum(mask(box(2):(box(2)+box(4)),box(1):(box(1)+box(3)))));
maxsupport = (box(4)+1)*(box(3)+1);
overlap = support / maxsupport;





