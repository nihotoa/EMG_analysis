function [f, cl] = tcohband(dat1, dat2, samp_rate, seg_pwr, band_bins, invalid_sections, opt_str)
% function [f,cl] = coh(dat1, dat2, samp_rate, seg_pwr, band_bins, invalid_sections, opt_str)
%
% Function to estimate spectra, coherence, & phase for 2 time series
% using periodogram based estimation procedure.
% 
% Input arguments
%  dat1       Channel 1  (input) data array.
%  dat2       Channel 2 (output) data array.
%  samp_rate  Sampling rate (samples/sec).
%  seg_pwr    Segment length - specified as power of 2.
%  band_bins  Optional number of frequency bins to combine into a band (<2 if no banding desired)
%  invalid_sections  Optional list of data index ranges that should not be used in the analysis.
%                    for example [100 124; 330 395; 664 729] to eliminate data at indexes
%                    100-124, 330-395, 664-729.  Can be empty array if all data should be used.
%  opt_str    Optional options string.
%
% Output arguments
%  f    column matrix with frequency domain parameter estimates.
%  cl   single structure with scalar values related to analysis.
%
% Input Options
%  r0, r1, r2  Rectification  -  0: Input channel, 1: Output channel,
%                                2: Both channels.
%  t0, t1, t2  Linear De-trend - 0: Input channel, 1: Output channel,
%                                2: Both channels.
%  m           Mains suppresion
%  ww, wp, wh  Use Welch(ww), Parzen(wp), or Hanning(wh) window with overlapping data segments.
%              This may affect the confidence limits as data sections are no longer independant.
%  o           Window Overlapping (half way overlapping)
%  s           Smoothing Auto-spectrum and Cross-spectrum with adjecent Fs
%              bands.
%
% Options examples:
%  to set all options set opt_str = 'r2 t2 m'
%  to rectify and de-trend both channels set opt_str = 'r2 t2' 
%  to rectify channel 2 and de-trend both channels set opt_str = 'r1 t2'
%
% Output parameters
%  f column 1  frequency in Hz.
%  f column 2  Channel 1 log power spectrum.
%  f column 3  Channel 2 log power spectrum.
%  f column 4  Coherence.
%  f column 5  Phase (coherence).
%  f column 6  Phase channel 1.
%  f column 7  Phase channel 2.
%  f column 8  Z-score for Mann-whitney test of channel1 power vs channel2 power.
%
%  cl.seg_size  Segment length.
%  cl.seg_tot   Number of segments.
%  cl.samp_tot  Number of samples analysed.
%  cl.samp_rate Sampling rate of data (samps/sec).
%  cl.df        FFT frequency spacing between adjacint bins.  
%  cl.f_c95     95% confidence limit for Log spectral estimates.
%  cl.ch_c95    95% confidence limit for coherence.
%  cl.opt_str   Copy of options string.
%
% Reference.
% Halliday D.M., Rosenberg J.R., Amjad A.M., Breeze P., Conway B.A. & Farmer S.F.
% A framework for the analysis of mixed time series/point process data -
%  Theory and application to the study of physiological tremor,
%  single motor unit discharges and electromyograms.
% Progress in Biophysics and molecular Biology, 64, 237-278, 1995.
%
% This version 10/04/00, D.M. Halliday.
% Modified 7/6/00 by Larry Shupe to add windowing and overlapping data segments.
% Modified 9/22/00 Phase channel 1, Phase channel 2, MannWhitney test added
% Modified 10/00 to remove invalid data sections and compose frequency bands.
global TDEBUG

% Check numbers of arguments.
if (nargin < 5)
   error(' Not enough input arguments');
end  

if (nargout < 2)
   error(' Not enough output arguments');
end  

pts_tot = length(dat1);           % Determine size of data vector.
if (length(dat2) ~= pts_tot)      % Check that input vectors are equal length. 
   error('Unequal length data arrays');
end

% Process options.
trend_chan_1 = 0;  % Set defaults - options off.
trend_chan_2 = 0;
mains_flag = 0;
rect_chan_1 = 0;
rect_chan_2 = 0;
overlap_flag =0;
spsmooth_flag   =0;
band_bins = floor(band_bins);
if (nargin < 5) || (band_bins < 2)
   band_bins = 1;
end
if (nargin < 6)
   invalid_sections = [];
end
if (nargin < 7)  % No options supplied.
   opt_str = '';
end
windowtype = 'none';

options = deblank(opt_str);
while (any(options))              % Parse individual options from string.
   [opt,options] = strtok(options);
   optarg = opt(2:length(opt));      % Determine option argument.
   
   switch (opt(1))
   case 'r'             % Rectification option.        
      i=str2num(optarg);
      if (i < 0) || (i > 2)
         error(['error in option argument -- r',optarg]);
      end  
      if (i ~= 1)
         rect_chan_1 = 1;     % Rectify ch 1.
      end  
      if (i >= 1)
         rect_chan_2 = 1;     % Rectify ch 2.
      end  
      
   case 't'             % Linear de-trend option.
      i=str2num(optarg);
      if (i < 0) || (i > 2)
         error(['error in option argument -- t', optarg]);
      end  
      if (i ~= 1)
         trend_chan_1 = 1;    % De-trend ch 1.
      end  
      if (i >= 1)
         trend_chan_2 = 1;    % De-trend ch 2.
      end  
      
   case 'm'             % Mains suppression option.
      mains_flag = 1;
      
   case 'w'
      switch optarg(1)
      case 'p' % Parzen window 
         windowtype = 'Parzen';
      case 'w' % Welch window
         windowtype = 'Welch';
      case 'h' % Hanning window
         windowtype = 'Hanning';
      otherwise
         error(['error in option argument -- w',optarg, ' must be wp, ww, wh']);
      end
      
   case 'o'
       overlap_flag =1;
   
   case 's'
       spsmooth_flag    = 1;
           
   otherwise
      error (['Illegal option -- ',opt]);  % Illegal option.
   end
end

% Get first artifact interval or [0 0] if there are no artifacts.

artindex = 1;
artlast = size(invalid_sections, 1);
artStart = 0;
artStop = 0;
if (artlast >= 1)
   artStart = invalid_sections(artindex, 1);
   artStop = invalid_sections(artindex, 2);
end

% Get all intervals that are not in an artifact section.

seg_tot = 0;
samp_tot = 0;
seg_size = 2^seg_pwr;        % DFT segment length (T).
if (overlap_flag==0)
	overlap = seg_size;       % No overlap between sections.
else
   overlap = seg_size / 2;   % With windowing we overlap adjacent sections halfway.
end
if(TDEBUG)
    disp(['overlap_flag: ' num2str(overlap_flag)])
end

% Count number of valid sections.  This is done so we can initialize the size
% of our rd1 and rd2 matrices and avoid time consuming memory reallocations.

for k = seg_size:overlap:pts_tot  % k is the last index of the segment.
   j = k - seg_size + 1; % j is the first index of the segment.
   
   % Find artifact section nearest the current index.
   
   while (artindex < artlast) && (artStop < j)
      artindex = artindex + 1;
   	artStart = invalid_sections(artindex, 1);
   	artStop = invalid_sections(artindex, 2);
   end
   
   % Count this sement only if it does not overlap with nearest artifact
   
   if (j > artStop) || (k < artStart)   
      seg_tot = seg_tot + 1;
   end
end

samp_tot = seg_tot * seg_size;      % Number of samples to analyse R=LT.   
rd1 = zeros(seg_size, seg_tot); 		% Preallocate space for data arrays.
rd2 = zeros(seg_size, seg_tot);

% Reset artifact checking parameters for our second pass

artindex = 1;
artlast = size(invalid_sections, 1);
artStart = 0;
artStop = 0;
if (artlast >= 1)
   artStart = invalid_sections(artindex, 1);
   artStop = invalid_sections(artindex, 2);
end

i = 0;
for k = seg_size:overlap:pts_tot  % k is the last index of the segment.
   j = k - seg_size + 1; % j is the first index of the segment.
   
   % Find artifact section nearest the current index.
   
   while (artindex < artlast) && (artStop < j)
      artindex = artindex + 1;
   	artStart = invalid_sections(artindex, 1);
   	artStop = invalid_sections(artindex, 2);
   end
   
   % Use this segment only if it does not overlap with nearest artifact
   
   if (j > artStop) || (k < artStart)   
      i = i + 1; % index of this segment.
      rd1(:,i) = dat1(j:k);
      rd2(:,i) = dat2(j:k);
   end
end

% Apply detrend and rectification options

if (trend_chan_1 || trend_chan_2)       % Index for fitting data with polynomial.
   trend_x = (1:seg_size)';
end

md1 = mean(rd1);    % Determine mean of each column/segment.  
md2 = mean(rd2);

for ind=1:seg_tot   % Loop across columns/segments.
   rd1(:,ind) = rd1(:,ind) - md1(ind);           % Subtract mean from ch 1.
   rd2(:,ind) = rd2(:,ind) - md2(ind);           % Subtract mean from ch 2.
   if rect_chan_1
      rd1(:,ind) = abs(rd1(:,ind));              % Rectification of ch 1 (Full wave).
   end
   if rect_chan_2
      rd2(:,ind) = abs(rd2(:,ind));              % Rectification of ch 2 (Full wave).  
   end
   if trend_chan_1                               % Linear trend removal.
      p = polyfit(trend_x, rd1(:,ind), 1);       % Fit 1st order polynomial.
      rd1(:,ind) = rd1(:,ind) - p(1) * trend_x(:) - p(2); % Subtract from ch 1.
   end  
   if trend_chan_2                               % Linear trend removal.
      p = polyfit(trend_x, rd2(:,ind), 1);       % Fit 1st order polynomial.
      rd2(:,ind) = rd2(:,ind) - p(1) * trend_x(:) - p(2); % Subtract from ch 2.
   end  
end

% Apply windowing function to each column of rd1 and rd2.

if (windowtype(1) ~= 'n')
   switch windowtype(1)
   case 'P' % Parzen window 
      window = (1 - abs((0:seg_size-1) - 0.5 * (seg_size-1)) / (0.5 * (seg_size+1)))' * ones(1, seg_tot);
   case 'W' % Welch window
      window = (1 - (((0:seg_size-1) - 0.5 * (seg_size-1)) / (0.5 * (seg_size+1))).^2)' * ones(1, seg_tot);
   case 'H' % Hanning window
      window = hanning(seg_size, 'periodic') * ones(1, seg_tot);
   end
   
   rd1 = rd1 .* window;
   rd2 = rd2 .* window;
end
if(TDEBUG)
    disp(['windowtype: ' windowtype])
end

clear dat1 dat2 md1 md2 trendx  % to save memory
pack                            % to save memory

% Call sp2_fn() Periodogram based spectral estimation routine.
[f,cl] = ftsp2_fnb(rd1, rd2, samp_rate, seg_tot, seg_size, band_bins, mains_flag, spsmooth_flag);

% Set additional elements in cl structure.
cl.opt_str = opt_str;          % Copy of options string.

% Display No of segments & resolution  if number of segments changes.
global coband_segments;
if coband_segments ~= seg_tot
   coband_segments = seg_tot;
   disp(['Segments: ',num2str(seg_tot),', Segment length: ',num2str(seg_size/samp_rate),' sec,  Resolution: ',num2str(cl.df),' Hz.']);
end
return;
