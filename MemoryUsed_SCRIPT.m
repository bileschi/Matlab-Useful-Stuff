%function MemoryUsed_SCRIPT; %--> MemoryUsed
%
%returns the total of the bytes used in the current scope
%
%MemoryUsed is not actually a function, but a script which adds the memUsed variable
% to the workspace.  This is done since calling whos within a function only
% returns the variables within scope
%function memUsed = MemoryUsed;
MemoryUsed_s = whos;
MemoryUsed = 0;
for MemoryUsed_i = 1:length(MemoryUsed_s)
   MemoryUsed = MemoryUsed + MemoryUsed_s(MemoryUsed_i).bytes;
end
MemoryUsed;
clear MemoryUsed_s MemoryUsed_i
