function myIdx = PROCEDURE_IncrementMyIdx(savename)
load(savename);%-->myIdx;
myIdx = myIdx + 1;
save(savename,'myIdx');
