function ndx = NDsub2ind(siz,subs)
%function ndx = NDsub2ind(siz,subs)
%-------------------------------
%like MATLAB standard sub2ind, but easier
% to integrate into larger scripts when the dimensionality of the mtrx is unknown
%siz should be like [10 10 4 5] if subs is like
% 9 8 3 5
% 1 1 1 1
% 10 10 4 5
% 5 8 3 3
%
% siz will be rotated for you if submit a row vec instead a col vector
% example: NDsub2ind([10 10 4 5],[[9,8,3,5];[1,1,1,1]])
%----------------------------------------------
if(size(siz,1) > 1) && (size(siz,2) > 1)
   error('the siz variable must be a vector');
end
  
if((size(subs,1) ~= 1) && (size(subs,2) == 1))
   subs = subs';
end
siz = siz(:)';
if length(siz)<2
        error('MATLAB:sub2ind:InvalidSize',...
            'Size vector must have at least 2 elements.');
end
ndim = length(siz);
if((ndim == 2) & (siz(2) ==1)) % ndim always returns at least 2
  ndim =1;
end
if(size(subs,2) > length(siz)) % too many subindicies, but are they all one?
   if(any(subs(:,((length(siz)+1):(size(subs,2)))) ~= 1))
      % some of them are not one.
      error('extra indicies specified beyond specified matrix size\n');
   else
      % remove ones subs
        %siz(((length(siz)+1):(size(subs,2)))) = 1;
        %ndim = length(siz);
      subs = subs(:,1:ndim);
   end
end
if (ndim ~= size(subs,2))
      error('NDsub2ind: ndim must = size(subs,2)');
end

nPoints = size(subs,1);


%Compute linear indices
k = [1 cumprod(siz(1:end-1))];
ndx = ones(nPoints,1);
s = size(subs); %For size comparison
for i = 1:length(siz),
    v = subs;
    if (any(v(:,i) < 1)) || (any(v(:,i) > siz(i)))
        %Verify subscripts are within range
        error('NDsub2ind:IndexOutOfRange','Out of range subscript.');
    end
    ndx = ndx + (v(:,i)-1)*k(i);
end
