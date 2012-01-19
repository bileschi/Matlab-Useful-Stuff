function [A,B,caLabels] = ShowStats(ca,Verbose)
if(nargin < 2)
  Verbose = 1;
end
nstats = length(ca);
A = zeros(7,nstats);
for i = 1:nstats
  A(1,i) = ca{i}.m.AUC;
  A(2,i) = ca{i}.m.EER;
  A(3,i) = ca{i}.m.TPatFP(1);
  A(4,i) = ca{i}.m.TPatFP(2);
  A(5,i) = ca{i}.m.TPatFP(3);
  A(6,i) = ca{i}.m.TPatFP(4);
  A(7,i) = ca{i}.m.TPatFP(5);
  
  B(1,i) = ca{i}.v.AUC;
  B(2,i) = ca{i}.v.EER;
  B(3,i) = ca{i}.v.TPatFP(1);
  B(4,i) = ca{i}.v.TPatFP(2);
  B(5,i) = ca{i}.v.TPatFP(3);
  B(6,i) = ca{i}.v.TPatFP(4);
  B(7,i) = ca{i}.v.TPatFP(5);
end  
caLabels = {'meanAUC','meanEER','tp at fp = .1','tp at fp = .01','tp at fp = .001','tp at fp = .0001'};

if(Verbose)
 fprintf('\n\n');
 for i = [2,4]% 1:6
    fprintf('%18s    ', caLabels{i});
    for j = 1:nstats
      fprintf('%.4f+-%.3f',A(i,j),sqrt(B(i,j)));
      fprintf('  ');
    end
    fprintf('\n');
 end
end
