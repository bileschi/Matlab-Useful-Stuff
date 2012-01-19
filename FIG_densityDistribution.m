function [h,x,y,y_by_countInRange, y_by_distToN] = FIG_densityDistribution(z,plotString,spatialGrain,minPtsForEstimate,bDist)
%function [h,x,y,y_by_countInRange, y_by_distToN] = FIG_densityDistribution(z,plotString,spatialGrain,minPtsForEstimate,bDist)
%
%plots the function f(x) = diff(count(z<=x));
%set bNormSumTo1 (default 0) to 1 to normalize sum to 1
%  f(x) = diff(prob(z<=x));
% optional plotString alows to set the plot style
%
% normalize to a distribution by setting the 5th input to 1
if(nargin < 2)
    plotString = 'b-';
end

if(length(unique(z)) < 50)
    fprintf('too few unique values to create a density: try hist\n');
end

%-------- default options
if(nargin < 3)
   spatialGrain = [];
end
if(nargin < 4)
   minPtsForEstimate = [];
end
if(nargin < 5)
   bDist = 0;
end
if(isempty(spatialGrain))
   spatialGrain = 100;
end
if(isempty(minPtsForEstimate))
   minPtsForEstimate = 4;
end
options.spatialGrain = spatialGrain;
options.minPointsForEstimate = minPtsForEstimate;
%--------

sz = sort(z);
minspan = (sz(end) - sz(1))/options.spatialGrain;
minpts = options.minPointsForEstimate ;

[range,density_of_nearest_N] = getRangeOfNearestN(sz,minpts);
[count,density_of_range_r] = getCountOfRange(sz,minspan);
valid_count = count >= minpts;
y_by_countInRange = density_of_range_r;
y_by_distToN = density_of_nearest_N;
f = find(valid_count);
y(f) = y_by_countInRange(f);
f = find(not(valid_count));
y(f) = y_by_distToN(f);
if(bDist)
   myArea = sum(y(2:end) .* (sz(2:end) - sz(1:(end-1))));
   y = y./myArea;
end
x = sz;
h = plot(x,y,plotString);


function [range,density] = getRangeOfNearestN(sz,N)
sz = [repmat(-inf,[N-1,1]);sz(:);repmat(inf,[N-1,1])];
distList = abs(sz(N:end) - sz(1:(end-N+1)));
distList = distList(1:(end -N+1));
range = -maxfilter(-distList,[(N-1),0,0,0]);
range(range==0) = 1; % wont get used anyway since count will trump it
density = (N-1) ./ range;

function [c_max,d] = getCountOfRange(sz,r)
c_to_right = ones(size(sz));
c_max = ones(size(sz));
right_i = 1;
b_is_more_right = 1;
L = length(sz);
for left_i = 1:L
   % for every element(left) advance the right until it is just within the
   % range.  Take care to not move the point beyond the final boundary
   if(right_i < left_i)
      right_i = left_i;
   end
   if(right_i == L)
      b_is_more_right = 0;
   end
   % if there is more right to search, then the right_i may need to be
   % moved.
   if(b_is_more_right)
      b_found_target = 0;
      while(not(b_found_target))
         pos_left = sz(left_i);
         pos_right = sz(right_i);
         pos_right_next = sz(right_i + 1);
         if((pos_right_next - pos_left) < r)
            % advance the right boundary
            right_i = right_i + 1;
            if(right_i == L)
               % target found by "end of list"
               b_is_more_right = 0;
               b_found_target = 1;
            end
            pos_right = sz(right_i);
         else
            % target found by "next out of range:
            b_found_target = 1;
         end
      end
   end
   % the count is the difference between the indicies of two endpoints
   c_to_right(left_i) = right_i - left_i + 1;
   % the maximum number of points within range is the maximum of "count within range to the right"
   % of points within range to the left (including this point)
   for j = left_i:right_i
      if(c_to_right(j) > c_max(j))
         c_max(j) = c_to_right(j);
      end
   end
end
d = (c_max-1) ./ r;

