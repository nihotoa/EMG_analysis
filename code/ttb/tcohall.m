function [out_f, out_cl]=tcohall(currExperiment, timeRange, nfftPoints, chanName1, chanName2, opt_str)
% cohtrig(currExperiment, timeRange, nfftPoints, chanName1, chanName2, trigName, trigWindow, [filename])
%   currExperiment -- mda object of class 'experiment' gotten with gcme or
%   gsme.
%   timeRange -- time range in seconds e.g. [1.0 200.0]
%   nfftPoints -- number of points per fft.  Must be a power of 2.
%   chanName1 -- name of first channel
%   chanName2 -- name of second channel
%   trigName -- name of timestamp channel
%   trigWindow -- time range (in seconds) around trigger to use.  
%   filename -- an optional output file for individual power and phase values for each trial.
%
% Performs a coherence analysis for the selected experiment.
% If the two channels don't have the same sampling rate, tis function will
% try to decimate the faster channel by discarding samples.  This subsampling
% fails if one sampling rate is not an even multiple of the other.
% An output file may be specified for storing individual power and phase values for
% each trial of the first nnftPoints in each data window.
%
% Output parameters
%  f column 1  frequency in Hz.
%  f column 2  Channel 1 log power spectrum.
%  f column 3  Channel 2 log power spectrum.
%  f column 4  Coherence.
%  f column 5  Phase (coherence) ranging from -pi(-3.141592) to pi(3.141592).
%  Positive value indicates the channel 1 (input) preceds the channel 2 (output).
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
% Collect information

% currExperiment = gcme;
if isempty(currExperiment)
    disp('cohanal error: No experiment selected.');
    return;
end

% Figure decimation factors

names{1} = chanName1;
names{2} = chanName2;
channels = experiment(currExperiment, 'findchannelobjs', names);
if any(isnull(channels))
    disp('cohanal error: could not find channels');
    return;
end
rate1 = get(channels(1), 'SampleRate');
rate2 = get(channels(2), 'SampleRate');

dec1 = 1;
dec2 = 1;

sampleRate = rate1;
if rate1 < rate2
    dec2 = rate2 / sampleRate;
elseif rate2 < rate1
    sampleRate = rate2;
    dec1 = rate1 / sampleRate;
end

if (dec1 ~= floor(dec1)) || (dec2 ~= floor(dec2))
    disp('cohanal error: sample rates do not be resampled to match');
    return;
end

% Get data arrays. Decimate data if needed.

data = getdata(currExperiment, {chanName1, chanName2}, timeRange, {{},{},{}});

% % % % % for the long data segmenting the rawdata
% % % % disp(timeRange)
% % % % pack;
% % % % disp([timeRange(1) timeRange(2)/2])
% % % % dataA   = getdata(currExperiment, {chanName1, chanName2}, [timeRange(1) timeRange(2)/2], {{},{},{}});
% % % % disp([timeRange(2)/2 timeRange(2)])
% % % % dataB   = getdata(currExperiment, {chanName1, chanName2}, [timeRange(2)/2 timeRange(2)], {{},{},{}});
% % % % pack;
% % % % data{1} =[dataA{1},dataB{1}];
% % % % data{2} =[dataA{2},dataB{2}];
% % % % clear dataA dataB
% % % % pack;

if dec1 > 1.0
    data{1} = data{1}(1:dec1:length(data{1}));
end
if dec2 > 1.0
    data{2} = data{2}(1:dec2:length(data{2}));
end

% Make sure data arrays are same length

length1 = length(data{1});
length2 = length(data{2});
if length1 ~= length2
    length1 = min([length1 length2]);
    data{1} = data{1}(1:length1);
    data{2} = data{2}(1:length1);
end

% call coherence routine
seg_pwr = floor(log2(nfftPoints));
[f, cl] = tcohband(data{1}', data{2}', sampleRate, seg_pwr, 1, [], opt_str);

out_f   = f;
out_cl  = cl;

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
%  cl.df        FFT frequency spacing between adjacent bins.  
%  cl.f_c95     95% confidence limit for Log spectral estimates.
%  cl.ch_c95    95% confidence limit for coherence.
%  cl.opt_str   Copy of options string.


% Create new figure for graphs

fig = figure;

% Display power spectrum for both channels
% Limit display to frequencys < 150 Hz

figTitle = [get(currExperiment, 'Name') ' (' chanName1 ' -- ' chanName2 ') [' num2str(timeRange(1)) ', ' num2str(timeRange(2)) ']'];
subplot(4,1,1);
stairs(f(:, 1), f(:, 2));
set(gca, 'XLim', [5 150]);
title(chanName1);
ylabel('log(Px)');   
set(gca, 'XTickLabelMode', 'Manual');
set(gca, 'XTickLabel', '');

subplot(4,1,2);
stairs(f(:, 1), f(:, 3));
set(gca, 'XLim', [5 150]);
title(chanName2)
ylabel('log(Py)');   
set(gca, 'XTickLabelMode', 'Manual');
set(gca, 'XTickLabel', '');

% Display coherence and phase between channels.  Include 95% confidence level.

subplot(4,1,3);
stairs(f(:, 1), f(:, 5));
set(gca, 'XLim', [5 150]);
set(gca, 'YLim', [-pi pi]);
title([chanName1 '->' chanName2])
ylabel('Phase');   
set(gca, 'XTickLabelMode', 'Manual');
set(gca, 'XTickLabel', '');

subplot(4,1,4);
stairs(f(:, 1), f(:, 4));
h = line([0 150], [cl.ch_c95 cl.ch_c95]);
set(h, 'Color', [0.5 0.5 0.5]);
set(gca, 'XLim', [5 150]);
ylabel('Coherence');   
xlabel(['Hz (' num2str(cl.df) ' resolution, ' num2str(cl.seg_tot) ' segments, ' num2str(nfftPoints) ' points, ''' opt_str ''')']);

% Create Spike Triggered Power and Coherence Time Course plots.
% We overlap data for consecutive times by half the fftPoint size to
% smooth transitions a bit.

% set(fig, 'Position', [20,50,600,750]);
% set(fig, 'PaperPosition', [0.25 0.25 8 10.5]);
% set(fig, 'Name',figTitle);

set(fig, 'Name',figTitle,...
    'NumberTitle','off',...
    'PaperUnits', 'centimeters',...
    'PaperOrientation','landscape',...
    'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
    'PaperPositionMode','manual',...
    'Position',[307    69   660   862],...
    'Toolbar','figure');


