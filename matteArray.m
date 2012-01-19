function B = matteArray(A,s,v);
%function B = matteArray(A,s,v);
%
if(length(s) == 1)
 s(2:4) = s(1);
end
if(length(s) == 2);
 s(1:4) = [s(2),s(1),s(2),s(1)];
end
B = A;
B(:,1:s(1)) = v;
B(:,(end-s(3)+1):end) = v;
B(1:s(2),:) = v;
B((end-s(4)+1):end,:) = v;
