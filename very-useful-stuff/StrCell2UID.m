function uid = StrCell2UID(strCell,str)
%function uid = StrCell2UID(strCell,str)
%
%given a cell array of strings, returns the uid of the cell containing
%exactly that string.  0 if that string is not in the cell array
uid = 0;
for i = 1:length(strCell)
    if(strcmp(strCell{i},str))
       uid = i;
       return;
    else
        continue;
    end
end