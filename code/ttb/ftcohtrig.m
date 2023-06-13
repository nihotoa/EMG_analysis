function varargout  = ftcohtrig(timeRange, nfftPoints, movingStep, chan1, chan2, chantrig, trigWindows, chanref, opt_str)
% FTCOHTRIG Fast-tcohtrig (fast-series by TT)
% cohtrig(currExperiment, timeRange, nfftPoints, chanName1, chanName2, trigName, trigWindows, [filename])
%   
%   timeRange -- time range in seconds e.g. [1.0 200.0]
%   nfftPoints -- number of points per fft.  Must be a power of 2.
%   movingStep -- step of moving fft window. Moving window is only used for spectrogram and coherogram. Define [] for no-overlapping. 
%   chanName1 -- name of first channel
%   chanName2 -- name of second channel
%   trigName -- name of timestamp channel
%   trigWindows -- time range (in seconds) around trigger to use.  
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


if isempty(movingStep)
    movingStep  = nfftPoints;
end

% Figure decimation factors

% names{1} = chanName1;
% names{2} = chanName2;
if(iscell(chantrig))
    if(~iscell(trigWindows) || (length(chantrig)~=length(trigWindows)))
        disp('cohanal error: Invalid inputs.');
        return;
    end
%     for ii=1:length(trigNames)
%         names{2+ii} = trigNames{ii};
%     end
    nAnalyses   = length(chantrig);
else
%     names{3} = trigNames;
    nAnalyses   = 1;
end
if(~isempty(chanref))
%     addchind    = length(names)+1;
%     names{addchind}    = additionalchan;
end
% channels = experiment(currExperiment, 'findchannelobjs', names);
% if any(isnull(channels))
%     disp('cohanal error: could not find channels');
%     return;
% end

rate(1) = getfield(chan1,'SampleRate');
rate(2) = getfield(chan2,'SampleRate');
rate(3) = getfield(chanref,'SampleRate');
for ii = 1:nAnalyses
    rate(3+ii)  = getfield(chantrig{ii},'SampleRate');
end
dec     = ones(size(rate));
% 
% for ii=1:length(channels)
%     rate(ii)    = getfield(channels(ii), 'SampleRate');
%     dec(ii)     = 1;
% end

sampleRate = rate(1);
if rate(1) < rate(2)
    dec(2) = rate(2) / sampleRate;
elseif rate(2) < rate(1)
    sampleRate = rate(2);
    dec(1) = rate(1) / sampleRate;
end
if(~isempty(chanref))
    dec(3)    = rate(3) / sampleRate;
end


if (dec(1) ~= floor(dec(1))) || (dec(2) ~= floor(dec(2))) || (dec(3) ~= floor(dec(3)))
    disp('cohanal error: sample rates do not be resampled to match');
    return;
end

% Get data arrays. Decimate data if needed.
% for ii=1:length(names)
%     filt{ii}    = {};
% end

data{1} = getfield(chan1,'Data');
data{2} = getfield(chan2,'Data');
data{3} = getfield(chanref,'Data');
for ii = 1:nAnalyses
    data{3+ii} = getfield(chantrig{ii},'Data');
end

if dec(1) > 1.0
    data{1} = data{1}(1:dec(1):length(data{1}));
end
if dec(2) > 1.0
    data{2} = data{2}(1:dec(2):length(data{2}));
end
if(~isempty(chanref))
    data{3} = data{3}(1:dec(3):length(data{3}));
end

% Make sure data arrays are same length

length1 = length(data{1});
length2 = length(data{2});
if length1 ~= length2
    length1 = min([length1 length2]);
    data{1} = data{1}(1:length1);
    data{2} = data{2}(1:length1);
end


for kk=1:nAnalyses
    trigName    = getfield(chantrig{kk},'Name');
    trigWindow  = trigWindows{kk};
    
    % Align window of data with trigger times
    sampleRange = floor(trigWindow * sampleRate);
    
    if trigWindow(1) >= 0  % Align samples at start of range.
        nSamples = floor( (sampleRange(2) - sampleRange(1) - nfftPoints) / movingStep ) * movingStep + nfftPoints;
        startIndexOffset = sampleRange(1);
    elseif trigWindow(2) <=0  % Align samples at end of range.
        nSamples = floor( (sampleRange(2) - sampleRange(1) - nfftPoints) / movingStep ) * movingStep + nfftPoints;
        startIndexOffset = sampleRange(2) - nSamples;
    else  % Align samples at trigger time.
        startIndexOffset = -floor(-sampleRange(1) / movingStep) * movingStep;
        nSamples = floor( (sampleRange(2) - startIndexOffset - nfftPoints) / movingStep ) * movingStep + nfftPoints;
    end
    if nSamples < nfftPoints
        disp('cohanal error: Trigger window is smaller than number of fft points desired.');
        return;
    end

    nSteps  = floor( (nSamples - nfftPoints) / movingStep) + 1;

    % Convert time stamps to indices into data{1} and data{2} arrays.

    startIndexes = floor(sampleRate * (data{3+kk}(1,:) / rate(3+kk) - timeRange(1))) + startIndexOffset;
    stopIndexes = startIndexes + nSamples - 1;

    % Make sure all windows fall completely withing the time range

    index = find( (startIndexes > 0) & (stopIndexes <= length1) );
    startIndexes = startIndexes(index);
    siSize = size(startIndexes);
    if (siSize(1) ~= 1) % Transpose if necessary to get a row vector.
        startIndexes = startIndexes';
    end
    nTriggers = length(startIndexes);

    seg_pwr = floor(log2(nfftPoints));
    
    % Create Spike Triggered Power and Coherence Time Course plots.
    % We overlap data for consecutive times by half the fftPoint size to
    % smooth transitions a bit.

    % Trigger based analysis
    for jj = 1:nTriggers                            % loop for nTriggers
        for ii = 1:nSteps       %ii=0:movingStep:nSamples-movingStep     % loop for Window moving
            selection = (ones(nfftPoints, 1) * startIndexes(jj)) + [0:nfftPoints-1]' + (ii - 1) * movingStep;
            %         S.t(ii) = (startIndexOffset + (ii - 1) * movingStep + nfftPoints/2) / sampleRate;
            [f, cl] = ftcohband(data{1}(selection)', data{2}(selection)', sampleRate, seg_pwr, 1, [], opt_str);
            if (ii==1 && jj==1)
                % preallocate memory for result
                S.triggerbased.px  = zeros(size(f,1),nSteps,nTriggers);
                S.triggerbased.py  = S.triggerbased.px;
%                 S.cxy  = S.px;
%                 S.phixy  = S.px;
%                 S.phix  = S.px;
%                 S.phiy  = S.px;
                S.triggerbased.ref   = zeros(nSteps,nTriggers);
                S.triggerbased.t     = ones(1,nSteps);
                S.triggerbased.freq  = f(:,1)';
                S.triggerbased.opt_str   = opt_str;
                S.triggerbased.nTriggers = nTriggers;
                S.triggerbased.nSteps    = nSteps;
                S.triggerbased.nfftPoints    = nfftPoints;
                S.triggerbased.movingStep    = movingStep;
                S.triggerbased.sampleRate    = sampleRate;
            end
            S.triggerbased.px(:,ii,jj) = f(:, 2);
            S.triggerbased.py(:,ii,jj) = f(:, 3);
%             S.cxy(:,ii,jj) = f(:, 4);
%             S.phixy(:,ii,jj) = f(:, 5);
%             S.phix(:,ii,jj) = f(:, 6);
%             S.phiy(:,ii,jj) = f(:, 7);
            if(~isempty(chanref))
                S.triggerbased.ref(ii,jj)    = mean(data{3}(selection));
            end
            S.triggerbased.t(ii) = (startIndexOffset + (ii - 1) * movingStep + nfftPoints/2) / sampleRate;
        end
    end
    
    % timecoarse analysis
    for ii=1:nSteps%:nfftPoints2:nSamples-nfftPoints2
        selection = reshape((ones(nfftPoints, 1) * startIndexes) + ([0:nfftPoints-1]' * ones(1, nTriggers)), 1, nfftPoints * nTriggers) + (ii - 1) * movingStep;
        [f, cl] = ftcohband(data{1}(selection)', data{2}(selection)', sampleRate, seg_pwr, 1, [], opt_str);

        if ii==1
            S.timecoarse.px = f(:, 2);
            S.timecoarse.py = f(:, 3);
            S.timecoarse.cxy = f(:, 4);
            S.timecoarse.phi = f(:, 5);
            S.timecoarse.cl   = cl;
            S.timecoarse.t  = S.triggerbased.t;
            S.timecoarse.freq  = S.triggerbased.freq;
%             S.compiled.x = startIndexOffset / sampleRate;
        else
            S.timecoarse.px = [S.timecoarse.px, f(:, 2)];
            S.timecoarse.py = [S.timecoarse.py, f(:, 3)];
            S.timecoarse.cxy = [S.timecoarse.cxy, f(:, 4)];
            S.timecoarse.phi = [S.timecoarse.phi, f(:, 5)];
%             x = [x, (startIndexOffset + i) / sampleRate];
        end

    end
    
    % compiled analysis without movingstep
    

    if trigWindow(1) >= 0  % Align samples at start of range.
        nSamples = floor( (sampleRange(2) - sampleRange(1)) / nfftPoints ) * nfftPoints;
        startIndexOffset = sampleRange(1);
    elseif trigWindow(2) <=0  % Align samples at end of range.
        nSamples = floor( (sampleRange(2) - sampleRange(1)) / nfftPoints ) * nfftPoints;
        startIndexOffset = sampleRange(2) - nSamples;
    else  % Align samples at trigger time.
        startIndexOffset = -floor(-sampleRange(1) / nfftPoints) * nfftPoints;
        nSamples = floor( (sampleRange(2) - startIndexOffset) / nfftPoints ) * nfftPoints;
    end
    if nSamples < nfftPoints
        disp('cohanal error: Trigger window is smaller than number of fft points desired.');
        return;
    end
    
    startIndexes = floor(sampleRate * (data{3+kk}(1,:) / rate(3+kk) - timeRange(1))) + startIndexOffset;
    stopIndexes = startIndexes + nSamples - 1;

    % Make sure all windows fall completely withing the time range

    index = find( (startIndexes > 0) & (stopIndexes <= length1) );
    startIndexes = startIndexes(index);
    siSize = size(startIndexes);
    if (siSize(1) ~= 1) % Transpose if necessary to get a row vector.
        startIndexes = startIndexes';
    end
    nTriggers = length(startIndexes);
    
    selection = reshape((ones(nSamples, 1) * startIndexes) + ([0:nSamples-1]' * ones(1,nTriggers)), 1, nSamples * nTriggers);
    keyboard
    [S.compiled.f, S.compiled.cl] = ftcohband(data{1}(selection)', data{2}(selection)', sampleRate, seg_pwr, 1, [], opt_str);
    
    varargout{kk}   = S;
    clear('S');
end