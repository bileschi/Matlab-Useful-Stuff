function cfilters = BuildDirectionalDerivatives(options)
% funciton cfilters = BuildDirectionalDerivatives(options)
%
%like directional gabor filters.
%  D.NOrientations = 18;
%  D.FilterResolution = 5;
%  D.FilterType = 'gabor'; % or 'gabor2','bar','gap'
%  D.sigma = 1;
%  D.aspect = 5;
%  D.Normalize = 1;

D.NOrientations = 18;
D.FilterResolution = 5;
D.FilterType = 'gabor';
D.sigma = 1;
D.aspect = 5;
D.Normalize = 1;

if(nargin < 1), options = [];, end
options = ResolveMissingOptions(options,D);
for i = 1:options.NOrientations
  orientation(i) = pi * (i-1) / options.NOrientations;
  if(strcmpi(options.FilterType , 'gabor'))
    cfilters{i} = MakeGabor(options.FilterResolution,orientation(i),options.sigma,options.aspect);
  end
  if(strcmpi(options.FilterType , 'gabor2'))
    cfilters{i} = MakeGabor2(options.FilterResolution,orientation(i),options.sigma,options.aspect);
  end
end
if(strcmpi(options.FilterType , 'bar'))
  cfilters = MakeBar(options);
end
if(strcmpi(options.FilterType , 'gap'))
  cfilters = MakeGap(options);
end

if(options.Normalize)
   for i = 1:options.NOrientations
      cfilters{i} = cfilters{i} - mean(mean(cfilters{i}));
      cfilters{i} = cfilters{i} / sqrt(sum(cfilters{i}(:).^2));
   end
end

function g = MakeGabor(r,o,s,a)
frequency = 4;
s = s*r;
g = zeros(r);
c = [r/2,r/2];
for i = 1:r
  y = i - c(2) - .5;
  for j = 1:r
    x = j-c(1) - .5;
    x2 = x*cos(o) - y*sin(o);
    y2 = x*sin(o) + y*cos(o);
    g(i,j) = exp(-(x2^2+a*y2^2)/(2*s)) *  sin(frequency*pi*y2/r);
  end
end

function g = MakeGabor2(r,o,s,a)
s = s*r;
g = zeros(r);
c = [r/2,r/2];
for i = 1:r
  y = i - c(2) - .5;
  for j = 1:r
    x = j-c(1) - .5;
    x2 = x*cos(o) - y*sin(o);
    y2 = x*sin(o) + y*cos(o);
    g(i,j) = exp(-(x2^2+a*y2^2)/(2*s)) * sign(y2);
  end
end

function g = MakeBar(options)
if(options.sigma <= 2);
   for i = 1:options.NOrientations
      cMinSupport{i} = zeros(options.FilterResolution);
      o(i) = (pi * (i-1)) / options.NOrientations - 1 * pi/2;
      u = [sin(-o(i)),cos(-o(i))];
      u = u / norm(u);
      o(i) = mod(o(i),pi);
      if not((o(i) < (pi/4)) || (o(i) > (3*pi/4)))  % for all x find one best y
      for x = 1:options.FilterResolution 
         x2 = x - options.FilterResolution / 2 - .5;  
         for y = 1:options.FilterResolution 
            y2 = y - options.FilterResolution / 2 - .5;  
            r = [y2, x2];
            d(y) = abs(r * u');
         end
         [m_dy,mi_dy] = min(d);
         cMinSupport{i}(mi_dy,x) = 1;
      end   
      else % for all y, find one best x
      for y = 1:options.FilterResolution 
         y2 = y - options.FilterResolution / 2 - .5;  
         for x = 1:options.FilterResolution 
            x2 = x - options.FilterResolution / 2 - .5;  
            r = [y2, x2];
            d(x) = abs(r * u');
         end
         [m_dx,mi_dx] = min(d);
         cMinSupport{i}(y,mi_dx) = 1;
      end   
      end
   end
else
   for i = 1:options.NOrientations
      cMinSupport{i} = zeros(options.FilterResolution);
      o(i) = (pi * (i-1)) / options.NOrientations - 1 * pi/2;
      u = [sin(-o(i)),cos(-o(i))];
      u = u / norm(u);
      for x = 1:options.FilterResolution 
         for y = 1:options.FilterResolution
            x2 = x - options.FilterResolution / 2 - .5;  
            y2 = y - options.FilterResolution / 2 - .5;  
            r = [y2, x2];
            d = abs(r * u');
            if(d < (options.sigma/2))
               cMinSupport{i}(y,x) = 1;
            end
         end
      end
   end 
end     
g = cMinSupport;


function g = MakeGap(options)
if(options.sigma <= 2);
   for i = 1:options.NOrientations
      cMinSupport{i} = zeros(options.FilterResolution);
      o(i) = (pi * (i-1)) / options.NOrientations - 1 * pi/2;
      u = [sin(-o(i)),cos(-o(i))];
      u = u / norm(u);
      o(i) = mod(o(i),pi);
      if not((o(i) < (pi/4)) || (o(i) > (3*pi/4)))  % for all x find one best y
      for x = 1:options.FilterResolution 
         x2 = x - options.FilterResolution / 2 - .5;  
         for y = 1:options.FilterResolution 
            y2 = y - options.FilterResolution / 2 - .5;  
            r = [y2, x2];
            ad(y) = abs(r * u');
            if(r * u')>0
               cMinSupport{i}(y,x) = -1;
            else
               cMinSupport{i}(y,x) = 1;
            end
         end
         [m_dy,mi_dy] = min(ad);
         cMinSupport{i}(mi_dy,x) = 0;
      end   
      else % for all y, find one best x
      for y = 1:options.FilterResolution 
         y2 = y - options.FilterResolution / 2 - .5;  
         for x = 1:options.FilterResolution 
            x2 = x - options.FilterResolution / 2 - .5;  
            r = [y2, x2];
            ad(y) = abs(r * u');
            if(r * u')>0
               cMinSupport{i}(y,x) = -1;
            else
               cMinSupport{i}(y,x) = 1;
            end
         end
         [m_dx,mi_dx] = min(ad);
         cMinSupport{i}(y,mi_dx) = 0;
      end   
      end
   end
else
   for i = 1:options.NOrientations
      cMinSupport{i} = zeros(options.FilterResolution);
      o(i) = (pi * (i-1)) / options.NOrientations - 1 * pi/2;
      u = [sin(-o(i)),cos(-o(i))];
      u = u / norm(u);
      for x = 1:options.FilterResolution 
         for y = 1:options.FilterResolution
            x2 = x - options.FilterResolution / 2 - .5;  
            y2 = y - options.FilterResolution / 2 - .5;  
            r = [y2, x2];
            if(r * u')>0
               cMinSupport{i}(y,x) = -1;
            else
               cMinSupport{i}(y,x) = 1;
            end
            ad = abs(r * u');
            if(ad < (options.sigma/2))
               cMinSupport{i}(y,x) = 0;
            end
         end
      end
   end 
end     
g = cMinSupport;
