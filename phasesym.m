% PHASESYM - Function for computing phase symmetry on an image.
%
% Usage: [phaseSym orientation] = phasesym(image)
%
% This function calculates the phase symmetry of points in an image.  
% For maximum speed the input image should be square and have a 
% size that is a power of 2, but the code will operate on images
% of arbitrary size.  
%
%
% Return values:
%                 phaseSym          - phase symmetry image
%                                     (values between 0 and 1) 
%                 orientation       - orientation image.
%                                     (orientation in which local
%                                     symmetry energy is a maximum,
%                                     in degrees (0-180), angles positive 
%                                     anti-clockwise.
%
% Parameters:  
%
% The convolutions are done via the FFT.  Many of the parameters relate 
% to the specification of the filters in the frequency plane.  
% The parameters are set within the file rather than being specified as 
% arguments because they rarely need to be changed - nor are they very 
% critical.  You may want to experiment with editing the values of `nscales'
% and `noiseCompFactor'.  
%
% It is suggested that you work with small images (128x128 or 256x256) as
% the phasecongruency code is very computationally expensive and uses
% *lots* of memory.
%
%
% Example MATLAB session:
%
% >> [im, map] = imread('picci.tif');      % read the image and its colour map
% >> image(im);                            % display the image
% >> [phaseSym orientation] = phasesym(im);
% >> imagesc(phaseSym);                    % display the phase symmetry image
%
%
% Peter Kovesi   
% School of Computer Science & Software Engineering
% The University of Western Australia
% pk at csse uwa edu au    http://www.csse.uwa.edu.au/~pk   
%
% Original Version written April 1996     
% Noise compensation corrected. August 1998
% Noise compensation corrected. October 1998  - Again!!!
% Modified to operate on non-square images of arbitrary size. September 1999
% Specialised from phasecong.m to calculate phase symmetry February 2001
%
% References:
%     Peter Kovesi, "Symmetry and Asymmetry From Local Phase" AI'97, Tenth
%     Australian Joint Conference on Artificial Intelligence. 2 - 4 December
%     1997. http://www.cs.uwa.edu.au/pub/robvis/papers/pk/ai97.ps.gz.
%
%     Peter Kovesi, "Image Features From Phase Congruency". Videre: A
%     Journal of Computer Vision Research. MIT Press. Volume 1, Number 3,
%     Summer 1999 http://mitpress.mit.edu/e-journals/Videre/001/v13.html
     

function[phaseSym, orientation, totalEnergy] = ...
	phasesym(im, nscale, norient, minWaveLength, mult, sigmaOnf, dThetaOnSigma, k)

    polarity = -1;
sze = size(im);

% Set up default values

if nargin < 2
    nscale          = 5;     % Number of wavelet scales.
end
if nargin < 3
    norient         = 6;     % Number of filter orientations.
end
if nargin < 4
    minWaveLength   = 3;     % Wavelength of smallest scale filter.
end
if nargin < 5
    mult            = 2.5;   % Scaling factor between successive filters.
end
if nargin < 6
    sigmaOnf        = 0.55;  % Ratio of the standard deviation of the
                             % Gaussian describing the log Gabor filter's transfer function 
			     % in the frequency domain to the filter center frequency.
end
if nargin < 7
    dThetaOnSigma   = 1.7;   % Ratio of angular interval between filter orientations
			     % and the standard deviation of the angular Gaussian
			     % function used to construct filters in the
                             % freq. plane.
end
if nargin < 8
    k               = 2.0;   % No of standard deviations of the noise energy beyond the
			     % mean at which we set the noise threshold point.
			     % standard deviation to its maximum effect
                             % on Energy.
end

epsilon         = .0001;     % Used to prevent division by zero.


thetaSigma = pi/norient/dThetaOnSigma;  % Calculate the standard deviation of the
                                        % angular Gaussian function used to
                                        % construct filters in the freq. plane.

imagefft = fft2(im);                    % Fourier transform of image
sze = size(imagefft);
rows = sze(1);
cols = sze(2);
zero = zeros(sze);

totalEnergy = zero;                     % Matrix for accumulating weighted phase 
                                        % congruency values (energy).
totalSumAn  = zero;                     % Matrix for accumulating filter response
                                        % amplitude values.
orientation = zero;                     % Matrix storing orientation with greatest
                                        % energy for each pixel.
estMeanE2n = [];

% Pre-compute some stuff to speed up filter construction

x = ones(rows,1) * (-cols/2 : (cols/2 - 1))/(cols/2);  
y = (-rows/2 : (rows/2 - 1))' * ones(1,cols)/(rows/2);
radius = sqrt(x.^2 + y.^2);       % Matrix values contain *normalised* radius from centre.
radius(round(rows/2+1),round(cols/2+1)) = 1; % Get rid of the 0 radius value in the middle 
                                             % so that taking the log of the radius will 
                                             % not cause trouble.
theta = atan2(-y,x);              % Matrix values contain polar angle.
                                  % (note -ve y is used to give +ve anti-clockwise angles)
clear x; clear y;                 % save a little memory

% The main loop...

for o = 1:norient,                   % For each orientation.
  fprintf('Processing orientation %d \r', o);

  angl = (o-1)*pi/norient;           % Calculate filter angle.
  wavelength = minWaveLength;        % Initialize filter wavelength.
  sumAn_ThisOrient  = zero;      
  Energy_ThisOrient = zero;      
  EOArray = [];          % Array of complex convolution images - one for each scale.
  ifftFilterArray = [];  % Array of inverse FFTs of filters

  % Pre-compute filter data specific to this orientation
  % For each point in the filter matrix calculate the angular distance from the
  % specified filter orientation.  To overcome the angular wrap-around problem
  % sine difference and cosine difference values are first computed and then
  % the atan2 function is used to determine angular distance.

  ds = sin(theta) * cos(angl) - cos(theta) * sin(angl); % Difference in sine.
  dc = cos(theta) * cos(angl) + sin(theta) * sin(angl); % Difference in cosine.
  dtheta = abs(atan2(ds,dc));                           % Absolute angular distance.
  spread = exp((-dtheta.^2) / (2 * thetaSigma^2));      % Calculate the angular filter component.

  for s = 1:nscale,                  % For each scale.

    % Construct the filter - first calculate the radial filter component.
    fo = 1.0/wavelength;                  % Centre frequency of filter.
    rfo = fo/0.5;                         % Normalised radius from centre of frequency plane 
                                          % corresponding to fo.
    logGabor = exp((-(log(radius/rfo)).^2) / (2 * log(sigmaOnf)^2));  
    logGabor(round(rows/2+1),round(cols/2+1)) = 0; % Set the value at the center of the filter
                                                   % back to zero (undo the radius fudge).

    filter = logGabor .* spread;          % Multiply by the angular spread to get the filter.
    filter = fftshift(filter);            % Swap quadrants to move zero frequency 
                                          % to the corners.

    ifftFilt = real(ifft2(filter))*sqrt(rows*cols);  % Note rescaling to match power
    ifftFilterArray = [ifftFilterArray ifftFilt];    % record ifft2 of filter

    % Convolve image with even and odd filters returning the result in EO
    EOfft = imagefft .* filter;           % Do the convolution.
    EO = ifft2(EOfft);                    % Back transform.

    EOArray = [EOArray, EO];              % Record convolution result
    An = abs(EO);                         % Amplitude of even & odd filter response.

    sumAn_ThisOrient = sumAn_ThisOrient + An;     % Sum of amplitude responses.

    if s==1
      EM_n = sum(sum(filter.^2));           % Record mean squared filter value at smallest
    end                                     % scale. This is used for noise estimation.

    wavelength = wavelength * mult;         % Finally calculate Wavelength of next filter
  end                                       % ... and process the next scale


  
  % Now calculate the phase symmetry measure.  

  if polarity == 0     % look for 'white' and 'black' spots
      for s = 1:nscale,                  
	  Energy_ThisOrient = Energy_ThisOrient ...
	      + abs(real(submat(EOArray,s,cols))) - abs(imag(submat(EOArray,s,cols)));
      end
      
  elseif polarity == 1  % Just look for 'white' spots
      for s = 1:nscale,                  
	  Energy_ThisOrient = Energy_ThisOrient ...
	      + real(submat(EOArray,s,cols)) - abs(imag(submat(EOArray,s,cols)));
      end
  
  elseif polarity == -1  % Just look for 'black' spots
      for s = 1:nscale,                  
	  Energy_ThisOrient = Energy_ThisOrient ...
	      - real(submat(EOArray,s,cols)) - abs(imag(submat(EOArray,s,cols)));
      end      
      
  end
  
      % Compensate for noise
      % We estimate the noise power from the energy squared response at the
      % smallest scale.  If the noise is Gaussian the energy squared will
      % have a Chi-squared 2DOF pdf.  We calculate the median energy squared
      % response as this is a robust statistic.  From this we estimate the
      % mean.  The estimate of noise power is obtained by dividing the mean
      % squared energy value by the mean squared filter value

  medianE2n = median(reshape(abs(submat(EOArray,1,cols)).^2,1,rows*cols));
  meanE2n = -medianE2n/log(0.5);
  estMeanE2n = [estMeanE2n meanE2n];

  noisePower = meanE2n/EM_n;                       % Estimate of noise power.

  % Now estimate the total energy^2 due to noise
  % Estimate for sum(An^2) + sum(Ai.*Aj.*(cphi.*cphj + sphi.*sphj))

  EstSumAn2 = zero;
  for s = 1:nscale
    EstSumAn2 = EstSumAn2+submat(ifftFilterArray,s,cols).^2;
  end

  EstSumAiAj = zero;
  for si = 1:(nscale-1)
    for sj = (si+1):nscale
      EstSumAiAj = EstSumAiAj + submat(ifftFilterArray,si,cols).*submat(ifftFilterArray,sj,cols);
    end
  end

  EstNoiseEnergy2 = 2*noisePower*sum(sum(EstSumAn2)) + 4*noisePower*sum(sum(EstSumAiAj));

  tau = sqrt(EstNoiseEnergy2/2);                     % Rayleigh parameter
  EstNoiseEnergy = tau*sqrt(pi/2);                   % Expected value of noise energy
  EstNoiseEnergySigma = sqrt( (2-pi/2)*tau^2 );

  T =  EstNoiseEnergy + k*EstNoiseEnergySigma;       % Noise threshold

  % The estimated noise effect calculated above is only valid for the PC_1 measure. 
  % The PC_2 measure does not lend itself readily to the same analysis.  However
  % empirically it seems that the noise effect is overestimated roughly by a factor 
  % of 1.7 for the filter parameters used here.

  T = T/1.7;        % Empirical rescaling of the estimated noise effect to 
                    % suit the PC_2 phase congruency measure

  Energy_ThisOrient = max(Energy_ThisOrient - T, zero);  % Apply noise threshold

  % Update accumulator matrix for sumAn and totalEnergy

  totalSumAn  = totalSumAn + sumAn_ThisOrient;
  totalEnergy = totalEnergy + Energy_ThisOrient;

  % Update orientation matrix by finding image points where the energy in this
  % orientation is greater than in any previous orientation (the change matrix)
  % and then replacing these elements in the orientation matrix with the
  % current orientation number.

  if(o == 1),
    maxEnergy = Energy_ThisOrient;
  else
    change = Energy_ThisOrient > maxEnergy;
    orientation = (o - 1).*change + orientation.*(~change);
    maxEnergy = max(maxEnergy, Energy_ThisOrient);
  end

end  % For each orientation
  fprintf('\n');
  

disp('Mean Energy squared values recorded with smallest scale filter at each orientation');
disp(estMeanE2n);

% Display results

imagesc(totalEnergy), axis image, title('total symmetry energy');
disp('Hit any key to continue '); pause

% Normalize totalEnergy by the totalSumAn to obtain phase symmetry

phaseSym = totalEnergy ./ (totalSumAn + epsilon);

imagesc(phaseSym), axis image, title('normalised phase symmetry');

% Convert orientation matrix values to degrees

orientation = orientation * (180 / norient);



%
% SUBMAT
%
% Function to extract the i'th sub-matrix 'cols' wide from a large
% matrix composed of several matricies.  The large matrix is used in
% lieu of an array of matricies 

function a = submat(big,i,cols)

a = big(:,((i-1)*cols+1):(i*cols));

