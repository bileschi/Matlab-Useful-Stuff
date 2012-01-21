function TTS = TTSplit_Make(AvailIndexList,TrainPart, TestPart,options)
%
%grouping means that chunks of n consecutive examples will always be together
% in either train or test.
%
%grouping does not work in conjunction with AvailIndexList
%d.Grouping = 1;  grouping = 10 makes each set of ten successive examples part of the same split

d.Grouping = 1;
if(nargin < 4)
   options = [];
end
options = ResolveMissingOptions(options,d);
nfiles = length(AvailIndexList);
if((TrainPart + TestPart) > 1)
  error('TrainPart + TestPart > 1\n');
  TTS = [];
  return;
end
if(options.Grouping == 1)
   p = randperm(nfiles);
   nTrain = floor(TrainPart * nfiles);
   nTest = floor(TestPart * nfiles);
   TTS.Train = p(1:nTrain);
   TTS.Train = AvailIndexList(TTS.Train);
   TTS.Test = p((nTrain+1):(nTrain+nTest));
   TTS.Test = AvailIndexList(TTS.Test);
else
   if(0 ~= mod(nfiles,options.Grouping))
      error('when grouping, the number of examples must be a multiple of the groupsize\n');
   end
   nfiles = nfiles / options.Grouping;
   p = randperm(nfiles);
   nTrain = floor(TrainPart * nfiles);
   nTest = floor(TestPart * nfiles);
   TTS.Train = p(1:nTrain);
   TTS.Test = p((nTrain+1):(nTrain+nTest));
   TTS.Train = Vectorize(OuterSum(TTS.Train*options.Grouping,1:options.Grouping));
   TTS.Test = Vectorize(OuterSum(TTS.Test*options.Grouping,1:options.Grouping));
end
