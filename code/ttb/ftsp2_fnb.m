function [f,cl] = tsp2_fnb(d1 ,d2, samp_rate, seg_tot, seg_size, band_bins, mains_flag, spsmooth_flag);
%
% Function with core routines for periodogram based spectral estimations.
% see NOTE below.
%
%  Inputs are two matrices containng pre processed time series or point process data.
%  Matrices have L columns with T rows.
%   L = No of disjont sections.
%   T = DFT segment length.
% 
% Input arguments
%  d1         Channel 1 data matrix.
%  d2         Channel 2 data matrix.
%  seg_size   DFT segment length (T).
%  samp_rate  Sampling rate (samples/sec)
%  band_bins  Number of bins to combine into output bands (1 if no banding desired).
%
% Output arguments
%  f    column matrix with frequency domain parameter estimates.
%  cl   single structure with scalar values related to analysis.
%
% Output parameters
%  f column 1  frequency in Hz.
%  f column 2  Log input spectrum.
%  f column 3  Log output spectrum.
%  f column 4  Coherence.
%  f column 5  Phase (for coherence).
%  f column 6  Phase channel 1.
%  f column 7  Phase channel 2.
%  f column 8  Mann-whitney test of channel1 power vs channel2 power.
%
%  cl.seg_size  Segment length.
%  cl.seg_tot   Number of segments.
%  cl.samp_tot  Number of samples analysed.
%  cl.samp_rate Sampling rate of data (samps/sec).
%  cl.df        Frequency domain bin width (Hz).
%  cl.f_c95     95% confidence limit for Log spectral estimates.
%  cl.ch_c95    95% confidence limit for coherence.
%
% Reference.
% Halliday D.M., Rosenberg J.R., Amjad A.M., Breeze P., Conway B.A. & Farmer S.F.
% A framework for the analysis of mixed time series/point process data -
%  Theory and application to the study of physiological tremor,
%  single motor unit discharges and electromyograms.
% Progress in Biophysics and molecular Biology, 64, 237-278, 1995.
%
% This version 10/04/00, D.M. Halliday.
%
% function [f,t,cl] = sp2_fn(d1,d2,samp_rate,seg_tot,seg_size,mains_flag);
%
% NOTE: This routine does not support analysis of raw data.
% It is intended as a support routine for 2 channel spectral analysis functions:
% sp2m.m, sp2am.m, sp2a2m.m. Refer to these functions for further details.
%
% Note: PBMB refers to above Progress in Biophysics article.
%
% Modified 9/19/2000 by Larry Shupe to return phase information for channel 1 and channel 2
% as well as a MannWhitney z-score for the power change between channel 1 and channel 2.
global TDEBUG

fd1 = fft(d1);                 % DFT across columns/segments ch 1, PBMB (4.1) or (4.2).
fd2 = fft(d2);                 % DFT across columns/segments ch 2, PBMB (4.1) or (4.2).	

% Compensate for number of bins in each band.

band_factor = floor(seg_size / band_bins);
if mod(seg_size, band_bins) > 0
	fd1 = fd1(1:band_bins * band_factor, :);   % Remove rows at end so that we won't end
	fd2 = fd2(1:band_bins * band_factor, :);   % up with fewer that band_bins in last bin.
end

seg_tot = seg_tot * band_bins;
seg_size = seg_size / band_bins;
samp_tot = seg_size * seg_tot; % Total no of samples.
 
if (band_bins >= 2) 
	fd1 = reshape(fd1', seg_tot, band_factor)';
	fd2 = reshape(fd2', seg_tot, band_factor)';
end
t_fac = 2 * pi * seg_size;     % Normalization for periodogram spectral estimates.
deltaf = samp_rate / seg_size; % Resolution - spacing of Fourier frequencies in Hz.

% f21 = mean((fd2 .* conj(fd1) / t_fac), 2);  % Cross spectrum (complex valued),PBMB (5.2).
f21 = mean((fd2 .* conj(fd1)), 2);  % Cross spectrum (complex valued),PBMB (5.2).

% NB 1/L included in mean() function.

% f11 = mean((fd1 .* conj(fd1) / t_fac), 2); % Power Spectrum 1, PBMB (5.2).
% f22 = mean((fd2 .* conj(fd2) / t_fac), 2); % Power Spectrum 2, PBMB (5.2).
f11 = mean((fd1 .* conj(fd1)), 2); % Power Spectrum 1, PBMB (5.2).
f22 = mean((fd2 .* conj(fd2)), 2); % Power Spectrum 2, PBMB (5.2).

fa1 = abs(fd1 .* fd1) / t_fac;
% f11 = mean(fa1, 2);   
%     
fa2 = abs(fd2 .* fd2) / t_fac;
% f22 = mean(fa2, 2);   % Spectrum 2, PBMB (5.2), NB Mag squared for auto spectra.

if(spsmooth_flag==1)                % f21, f11, f22 are smoothed using a Hanning window inwhich eahc potints was replaced with the weighted sum of its value and that of the two surrounding potints, with weitghts 1/4 1/2 1/4 (Farmer et al., 1993)
    temp = conv(f21,[0.25 0.5 0.25]);   % add by TT 061203
    f21 = temp(2:length(temp)-1);   % add by TT 061203
    temp = conv(f11,[0.25 0.5 0.25]);   % add by TT 061203
    f11 = temp(2:length(temp)-1);   % add by TT 061203
    temp = conv(f22,[0.25 0.5 0.25]);   % add by TT 061203
    f22 = temp(2:length(temp)-1);   % add by TT 061203
end
if(TDEBUG)
    disp(['spsmooth_flag: ' num2str(spsmooth_flag)])
end

if mains_flag        % Suppression of mains - smooth out using adjacent values.
   mains_ind = round(60.0 / deltaf) + 1;        % NB Index 1 is DC.
   f11(mains_ind) = 0.5 * (f11(mains_ind - 2) + f11(mains_ind + 2));    % Spectrum ch 1.
   f11(mains_ind - 1) = 0.5 * (f11(mains_ind - 2) + f11(mains_ind - 3));
   f11(mains_ind + 1) = 0.5 * (f11(mains_ind + 2) + f11(mains_ind + 3));
   f22(mains_ind) = 0.5 * (f22(mains_ind - 2) + f22(mains_ind + 2));    % Spectrum ch 2.
   f22(mains_ind - 1) = 0.5 * (f22(mains_ind - 2) + f22(mains_ind - 3));
   f22(mains_ind + 1) = 0.5 * (f22(mains_ind + 2) + f22(mains_ind + 3));
   f21(mains_ind) = 0.5 * (f21(mains_ind - 2) + f21(mains_ind + 2));    % Cross spectrum.
   f21(mains_ind - 1) = 0.5 * (f21(mains_ind - 2) + f21(mains_ind - 3));
   f21(mains_ind + 1) = 0.5 * (f21(mains_ind + 2) + f21(mains_ind + 3));
   % Smooth elements in upper hermetian section of cross spectral estimate.
   % This data used in ifft() to generate cumulant. NB Data is complex conjugate.
   f21(seg_size - mains_ind + 2) = conj(f21(mains_ind));
   f21(seg_size - mains_ind + 3) = conj(f21(mains_ind - 1));
   f21(seg_size - mains_ind + 1) = conj(f21(mains_ind + 1));
end  

% Calculate the power spectra and coherence
coh21       = zeros(size(f21));
coh21(1)    = 0; % Avoid divide by zero warning, coherence at 0 HZ is undefined. [LS]
coh21(2:end)   = (f21(2:end) .* conj(f21(2:end))) ./ (f11(2:end) .* f22(2:end));           % (f21(2:end) .* conj(f21(2:end))) = |f21(2:end)|.^2 in PBMB (5.5)
phi21          = angle(f21);      % Coherence phase, PBMB (5.7).
% disp('ftsp2_fnd')

% Construct output spectral matrix f.
seg_size_2 = (1:seg_size/2-1)';    % Indexing for output.
f(:,1) = (seg_size_2 - 1) * deltaf;  % Column 1 - frequencies in Hz.
if f11(1) <= 0
    f(1,2) = -inf; % prevent log of 0 warning.
%     f(2:end,2) = log10(band_bins * f11(seg_size_2(2:end)));     % Column 2 - Log spectrum ch 1.
    f(2:end,2) = f11(seg_size_2(2:end)) * 2 / (seg_size ^ 2);     % Column 2 - Log spectrum ch 1.
else
%     f(:,2) = log10(band_bins * f11(seg_size_2));     % Column 2 - Log spectrum ch 1.
        f(:,2) = f11(seg_size_2) * 2 / (seg_size ^ 2);     % Column 2 - Log spectrum ch 1.
end
if f22(1) <= 0
    f(1,3) = -inf; % prevent log of 0 warning.
%     f(2:end,3) = log10(band_bins * f22(seg_size_2(2:end)));     % Column 3 - Log spectrum ch 2.
    f(2:end,3) = f22(seg_size_2(2:end)) * 2 / (seg_size ^ 2);     % Column 2 - Log spectrum ch 1.
else
%     f(:,3) = log10(band_bins * f22(seg_size_2));     % Column 3 - Log spectrum ch 2.
        f(:,3) = f22(seg_size_2) * 2 / (seg_size ^ 2);     % Column 2 - Log spectrum ch 1.keyboard
end


% Column 4 - Coherence, PBMB (5.5).
f(:,4)  = coh21(seg_size_2);
f(:,5)  = phi21(seg_size_2);
% f(1,4) = 0; % Avoid divide by zero warning, coherence at 0 HZ is undefined. [LS]
% f(2:end,4) = abs(f21(seg_size_2(2:end))) .* abs(f21(seg_size_2(2:end))) ./ (f11(seg_size_2(2:end)) .* f22(seg_size_2(2:end)));


for i=1:seg_size_2
    f(i,8) = MannWhitney(fa1(i,:), fa2(i,:));
end
f(:,6) = mean(angle(fd1(seg_size_2, :)), 2);   % Column 6 - phases for ch 1.
f(:,7) = mean(angle(fd2(seg_size_2, :)), 2);   % Column 7 - phases for ch 2.
% Construct cl structure, confidence limits for parameter estimates.

cl.seg_size = seg_size;         % T in PBMB Set values in cl structure. 
cl.seg_tot = seg_tot;           % L in PBMB
cl.samp_tot = samp_tot;         % R in PBMB
cl.samp_rate = samp_rate;
cl.df = deltaf;
cl.f_c95 = 0.8512 * sqrt(1 / seg_tot);    % Confidence limit for spectral estimates, PBMB (6.2).
% N.B. Confidence interval for log plot of spectra is TWICE this value.
if (seg_tot > 1)
    cl.ch_c95 = 1 - 0.05^(1 / (seg_tot - 1));   % Confidence limit for coherence, PBMB (6.6).
else
    cl.ch_c95 = 0;
end

%------------------------------------------------------------------------------------------------

function z_score = MannWhitney(data1, data2)
% zscore = MannWhitney(data1, data2);
% Performs non-parametric Mann-Whitney rank test.
% Returns z_score = NaN if there is not enough data to perform test.

z_score = NaN;
n1 = length(data1);
n2 = length(data2);
if (n1 >= 1) && (n2 > 1) 
   table = sortrows(reshape([data1(:); data2(:); ones(n1, 1); zeros(n2, 1)], n1 + n2, 2));
   rank = table(:, 2);
   ranksum1 = sum(find(rank == 1));
   ranksum2 = sum(find(rank ~= 1));
   uvalue = (n1 * n2) + 0.5 * (n1 * (n1 + 1.0)) - ranksum1;
   sd = sqrt(((n1 * n2) * (n1 + n2 + 1.0)) / 12.0);
   z_score = (uvalue - 0.5 * n1 * n2) / sd;
end;

