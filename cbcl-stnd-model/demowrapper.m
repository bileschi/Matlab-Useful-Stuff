
allclasses = dir('/scratch2/serre/databases/perona/101_ObjectCategories/');
allclasses = allclasses(4:end);

cry = cell(10,10);
crw = cell(10,10);
csuccessrate = cell(10,10);
cstSoStat = cell(10,10);

dname2 = '/scratch2/serre/databases/perona/101_ObjectCategories/BACKGROUND_Google/';

for dmi = 1:10,
  dname1 = ...
      ['/scratch2/serre/databases/perona/101_ObjectCategories/' allclasses(dmi).name '/']
  for dmj = 1:10,
    demo;
    cry{dmi,dmj} = ry;
    crw{dmi,dmj} = rw;
    csuccessrate{dmi,dmj} = successrate;
    cstSoStat{dmi,dmj} = stSoStat;
  end
end

    
    
