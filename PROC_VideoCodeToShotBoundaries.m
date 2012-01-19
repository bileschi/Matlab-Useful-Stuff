function PROC_VideoCodeToShotBoundaries(txtfile,options);
%function PROC_VideoCodeToShotBoundaries(txtfile,options);
%
%input is a filename of a text file that has long list of 
%numbers in it, as output from the video program.
%The output is another file similarly format

d.GausWinSize = 10;
d.RemoveUltraShortShots = 1;
d.TooShortShot = 10;
if(nargin < 2)
options = [];
end
options = ResolveMissingOptions(options,d);

LoadData = load(txtfile);
if(isstruct(LoadData))
  fns = fieldnames(LoadData);
  D = LoadData.(fns{1});
else
  D = LoadData;
end

[p,n,e] = fileparts(txtfile);
[n2] = n(1:(end-10));
savefn = fullfile(p,[n2,'_FrameBreak',e]);

GausWinSize = options.GausWinSize;
if(length(D) < GausWinSize)
   fprintf('this would be an error\n');
end
G.mean(1:(GausWinSize)) = mean(D(1:GausWinSize));
G.std(1:(GausWinSize)) = std(D(1:GausWinSize));
clear z
z(1:GausWinSize) = 0;
for i = (GausWinSize+1):length(D)
   % z(i) = normcdf(D(i), G.mean, G.std);
   z(i) = min(100,(D(i) - G.mean(i-1)) / sqrt((G.std(i-1) + 1)));
   G.mean(i) = mean(D(i:-1:(i-GausWinSize)));
   G.std(i) = std(D(i:-1:(i-GausWinSize)));
end   
z = max(0,z);
z = find(z > 30);
if(options.RemoveUltraShortShots);
   z_diff = z(2:end) - z(1:(end-1));
   frameTooShort = z_diff < options.TooShortShot;
   f = find(frameTooShort) + 1;
   frameok = setdiff(1:length(z),f);
   z = z(frameok);
end
keyboard;
fid = fopen(savefn,'w');
fprintf(fid,'%.0d\n',length(z));
for i = 1:length(z)
   fprintf(fid,'%.0d\n',floor(z(i)));
end
fclose(fid);
