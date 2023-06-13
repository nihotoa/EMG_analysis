function [out_f, out_cl]=cohtrig(timeRange, nfftPoints, chanName1, chanName2, trigName, trigWindow, varargin)
% cohtrig(timeRange, nfftPoints, chanName1, chanName2, trigName, trigWindow, [filename])
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

% Collect information

currExperiment = gcme;
if isempty(currExperiment)
    disp('cohanal error: No experiment selected.');
    return;
end

% Figure decimation factors

names{1} = chanName1;
names{2} = chanName2;
names{3} = trigName;
channels = experiment(currExperiment, 'findchannelobjs', names);
if any(isnull(channels))
    disp('cohanal error: could not find channels');
    return;
end
rate1 = get(channels(1), 'SampleRate');
rate2 = get(channels(2), 'SampleRate');
rate3 = get(channels(3), 'SampleRate');

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

data = getdata(currExperiment, {chanName1, chanName2, trigName}, timeRange, {{},{},{}});
if dec1 > 1.0
    data{1} = data{1}(1:dec1:length(data{1}));
end
if dec2 > 1.0
    data{2} = data{2}(1:dec2:length(data{2}));
end

data{1} = data{1}(125:length(data{1}));
% data{2} = data{2}(125:length(data{2}));

% Make sure data arrays are same length

length1 = length(data{1});
length2 = length(data{2});
if length1 ~= length2
    length1 = min([length1 length2]);
    data{1} = data{1}(1:length1);
    data{2} = data{2}(1:length1);
end

% Align window of data with trigger times

sampleRange = floor(trigWindow * sampleRate);
nSamples = floor( (sampleRange(2) - sampleRange(1)) / nfftPoints ) * nfftPoints;
if nSamples < nfftPoints
    disp('cohanal error: Trigger window is smaller than number of fft points desired.');
    return;
end

if trigWindow(1) >= 0  % Align samples at start of range.
    startIndexOffset = sampleRange(1); 
elseif trigWindow(2) <=0  % Align samples at end of range.
    startIndexOffset = sampleRange(2) - nSamples;  
else  % Align samples at trigger time.
    startIndexOffset = -floor(-sampleRange(1) / nfftPoints) * nfftPoints;
end

% Convert time stamps to indices into data{1} and data{2} arrays.

startIndexes = floor(sampleRate * (data{3}(1,:) / rate3 - timeRange(1))) + startIndexOffset;
stopIndexes = startIndexes + nSamples - 1;

% Make sure all windows fall completely withing the time range

index = find( (startIndexes > 0) & (stopIndexes <= length1) );
startIndexes = startIndexes(index);
siSize = size(startIndexes);
if (siSize(1) ~= 1) % Transpose if necessary to get a row vector.
    startIndexes = startIndexes';
end
nTriggers = length(startIndexes);

% Create a selection index to extract sections of data around the triggers.

selection = reshape((ones(nSamples, 1) * startIndexes) + ([0:nSamples-1]' * ones(1,nTriggers)), 1, nSamples * nTriggers);

% call coherence routine

seg_pwr = floor(log2(nfftPoints));
[f, cl] = cohband(data{1}(selection)', data{2}(selection)', sampleRate, seg_pwr, 1, [], 't2');

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

figTitle = [get(currExperiment, 'Name') ' (' trigName ' -> ' chanName1 ', ' chanName2 ') [' num2str(timeRange(1)) ', ' num2str(timeRange(2)) ']'];
subplot(4,2,1);
stairs(f(:, 1), f(:, 2));
set(gca, 'XLim', [5 150]);
title(figTitle);
ylabel('log(Px)');   
set(gca, 'XTickLabelMode', 'Manual');
set(gca, 'XTickLabel', '');

subplot(4,2,3);
stairs(f(:, 1), f(:, 3));
set(gca, 'XLim', [5 150]);
ylabel('log(Py)');   
set(gca, 'XTickLabelMode', 'Manual');
set(gca, 'XTickLabel', '');

% Display coherence and phase between channels.  Include 95% confidence level.

subplot(4,2, 5);
stairs(f(:, 1), f(:, 5));
set(gca, 'XLim', [5 150]);
set(gca, 'YLim', [-pi pi]);
ylabel('Phase');   
set(gca, 'XTickLabelMode', 'Manual');
set(gca, 'XTickLabel', '');

subplot(4,2, 7);
stairs(f(:, 1), f(:, 4));
h = line([0 150], [cl.ch_c95 cl.ch_c95]);
set(h, 'Color', [0.5 0.5 0.5]);
set(gca, 'XLim', [5 150]);
ylabel('Coherence');   
xlabel(['Hz (' num2str(cl.df) ' resolution, ' num2str(cl.seg_tot) ' segments, ' num2str(nfftPoints) ' points)']);

% Create Spike Triggered Power and Coherence Time Course plots.
% We overlap data for consecutive times by half the fftPoint size to
% smooth transitions a bit.

nfftPoints2 = nfftPoints / 2;
for i=0:nfftPoints2:nSamples-nfftPoints2
    selection = reshape((ones(nfftPoints, 1) * startIndexes) + ([0:nfftPoints-1]' * ones(1, nTriggers)), 1, nfftPoints * nTriggers) + i;
    [f, cl] = cohband(data{1}(selection)', data{2}(selection)', sampleRate, seg_pwr, 1, [], 't2');
   
    if i==0
        px = f(:, 2);
        py = f(:, 3);
        cxy = f(:, 4);
        phi = f(:, 5);
        x = startIndexOffset / sampleRate;
    else
        px = [px, f(:, 2)];
        py = [py, f(:, 3)];
        cxy = [cxy, f(:, 4)];
        phi = [phi, f(:, 5)];
        x = [x, (startIndexOffset + i) / sampleRate];
    end
    
end

% Power time courses

subplot(4,2, 2);
px(1,:) = mean(mean(px)); % Clear 0 Hz row to keep it from from affecting the color stairs
pcolor(x, f(:, 1), px);
shading('flat');
set(gca, 'YLim', [5 150]);
ylabel('Hz');   
title([chanName1 ' Log Power']);
set(gca, 'XTickLabelMode', 'Manual');
set(gca, 'XTickLabel', '');
colorbar;

subplot(4,2, 4);
py(1,:) = mean(mean(py)); % Clear 0 Hz row to keep it from from affecting the color stairs
pcolor(x, f(:, 1), py);
shading('flat');
set(gca, 'YLim', [5 150]);
ylabel('Hz');   
title([chanName2 ' Log Power']);
set(gca, 'XTickLabelMode', 'Manual');
set(gca, 'XTickLabel', '');
colorbar;

% Coherence and Phase time course

subplot(4,2, 6)
pcolor(x, f(:, 1), phi);
shading('flat');
set(gca, 'YLim', [5 150]);
ylabel('Hz');   
title([chanName1 ', ' chanName2 ' Phase']);
set(gca, 'XTickLabelMode', 'Manual');
set(gca, 'XTickLabel', '');
colorbar;

subplot(4,2, 8);
pcolor(x, f(:, 1), cxy);
shading('flat');
set(gca, 'YLim', [5 150]);
ylabel('Hz');   
xlabel(['Time (N=' num2str(nTriggers) ')']);
title([chanName1 ', ' chanName2 ' Coherence']);
colorbar;

% Set window size to match letter size paper

set(fig, 'Position', [20,50,600,750]);
set(fig, 'PaperPosition', [0.25 0.25 8 10.5]);
% Create Spike Triggered Power and Coherence Time Course plots.
% We overlap data for consecutive times by half the fftPoint size to
% smooth transitions a bit.

if length(varargin) < 1
    return;
end

fid = fopen(varargin{1}, 'w');
if (fid == -1)
    return;
end

% Save fft information for the first window to a file

selection = (ones(nfftPoints, 1) * startIndexes) + ([0:nfftPoints-1]' * ones(1, nTriggers));
n = length(f(:, 1)); % number of columns.
for i=1:nTriggers
    [f, cl] = cohband(data{1}(selection(:,i))', data{2}(selection(:,i))', sampleRate, seg_pwr, 1, [], 't2');
   
    % On first pass print out header information at top of each column of data.
    
    if i==1
        j = 1;
        while f(j, 1) <= 100
            hz = round(f(j, 1) * 10) / 10;
            if (j == 1)
                fprintf(fid, 'Trial');
            end
            fprintf(fid, '\tPx(%g)\tPy(%g)\trxy(%g)\trx(%g)\try(%g)', hz, hz, hz, hz, hz);
            j = j + 1;
            if j > n
                break;
            end
        end
        fprintf(fid, '\n');  
    end
    
    % Report power and phase values for each frequency
    j = 1;
    while f(j, 1) <= 100
        hz = round(f(j, 1));
        if (j == 1)
            fprintf(fid, '%d', i);
        end
        fprintf(fid, '\t%g\t%g\t%g\t%g\t%g', f(j, 2), f(j,3), f(j,5), f(j,6), f(j,7));
        j = j + 1;
        if j > n
            break;
        end
    end
    fprintf(fid, '\n');        
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

function x = normalize(y)
yy = y;
yy(1,:) = mean(mean(y));
minval = min(min(yy));
maxval = max(max(yy));
x = (yy - minval) ./ (maxval - minval);