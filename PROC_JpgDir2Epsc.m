function PROC_JpgDir2Epsc(directory)
%function PROC_JpgDir2Epsc(directory)
%
%for every .jpg file in the directory, create a .epsc file

d = dir(directory);
h = figure(77)
for i = 1:length(d)
  fprintf('.');
  clf
  [pathstr,name,ext] = fileparts(d(i).name);
  if not((strcmpi(ext,'.jpg')) || (strcmpi(ext,'.jpeg')))
    continue;
  end
  im = imread(fullfile(directory,d(i).name));
  imshow(im);
  saveas(h,fullfile(directory,sprintf('%s.%s',name,'epsc')),'epsc');
end
close(h);