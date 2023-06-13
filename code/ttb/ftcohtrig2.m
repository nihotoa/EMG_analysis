function varargout  = ftcohtrig(timeRange, nfftPoints, movingStep, chan1, chan2, chantrig, trigWindows, chanref, opt_str)
% cohtrig(currExperiment, timeRange, nfftPoints, chanName1, chanName2, trigName, trigWindows, [filename])
%   currExperiment -- mda object of class 'experiment' gotten with gcme or
%   gsme.
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

maxtrial    = 1000;

if isempty(movingStep)
    movingStep  = nfftPoints(2);
end
seg_pwr(1) = floor(log2(nfftPoints(1)));
seg_pwr(2) = floor(log2(nfftPoints(2)));

% Figure decimation factors

nAnalyses   = 1;
nCombine    = 1;

if(~all([iscell(timeRange) iscell(chan1) iscell(chan2) iscell(chantrig) iscell(trigWindows) iscell(chanref)]))
    disp('ftcohtrig error: Invalid inputs. Inputs must be cell array');
    return;
elseif(~isequal(size(timeRange,1),size(chan1,1),size(chan2,1),size(chantrig,1),size(trigWindows,1),size(chanref,1)))
    disp('ftcohtrig error: Invalid inputs. Inputs must have same number of rows');
    return;
elseif(~isequal(size(chantrig,2),size(trigWindows,2)))
    disp('ftcohtrig error: Invalid inputs. trigger channels and trigger windows must have same number of colums');
    return;
else
    nAnalyses   = size(chantrig,2);
    nCombine    = size(chantrig,1);
end
%
% if(iscell(chantrig))
%     if(~iscell(trigWindows) || ~all(size(chantrig)==size(trigWindows)))
%         disp('cohanal error: Invalid inputs.');
%         return;
%     end
%     nAnalyses   = size(chantrig,2);
% else
%     nAnalyses   = 1;
% end

for kk  = 1:nAnalyses
    DataMatrix   ={[],[],[]};
    if(nCombine > 1)
        % make sure all combined data have same sample rate
        for hh=1:nCombine
            ratio1(hh)   = getfield(chan1{hh,1},'SampleRate');
            ratio2(hh)   = getfield(chan2{hh,1},'SampleRate');
            ratio3(hh)   = getfield(chanref{hh,1},'SampleRate');
            ratio4(hh)   = getfield(chantrig{hh,kk},'SampleRate');
        end
        if(~all([length(unique(ratio1))==1,length(unique(ratio2))==1,length(unique(ratio3))==1,length(unique(ratio4))==1]))
            disp('ftcohtrig error: Invalid inputs. combined data must have same sampling rate');
            return;
        end
    end

    for hh  = 1:nCombine
        trigName    = getfield(chantrig{hh,kk},'Name');
        trigWindow  = trigWindows{hh,kk};

        rate(1) = getfield(chan1{hh,1},'SampleRate');
        rate(2) = getfield(chan2{hh,1},'SampleRate');
        rate(3) = getfield(chanref{hh,1},'SampleRate');
        rate(4) = getfield(chantrig{hh,kk},'SampleRate');

        dec     = ones(size(rate));

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


        data{1} = getfield(chan1{hh,1},'Data');
        data{2} = getfield(chan2{hh,1},'Data');
        data{3} = getfield(chanref{hh,1},'Data');
        data{4} = getfield(chantrig{hh,kk},'Data');

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
        length3 = length(data{3});
        if (isequal(length1,length2,length3))
            length1 = min([length1 length2 length3]);
            data{1} = data{1}(1:length1);
            data{2} = data{2}(1:length1);
            data{3} = data{3}(1:length1);
        end

        % Align window of data with trigger times
        sampleRange = floor(trigWindow * sampleRate);

        %         if trigWindow(1) >= 0  % Align samples at start of range.
        %             nSamples = floor( (sampleRange(2) - sampleRange(1) - nfftPoints) / movingStep ) * movingStep + nfftPoints;
        %             startIndexOffset = sampleRange(1);
        %         elseif trigWindow(2) <=0  % Align samples at end of range.
        %             nSamples = floor( (sampleRange(2) - sampleRange(1) - nfftPoints) / movingStep ) * movingStep + nfftPoints;
        %             startIndexOffset = sampleRange(2) - nSamples;
        %         else  % Align samples at trigger time.
        %             startIndexOffset = -floor(-sampleRange(1) / movingStep) * movingStep;
        %             nSamples = floor( (sampleRange(2) - startIndexOffset - nfftPoints) / movingStep ) * movingStep + nfftPoints;
        %         end
        %         if nSamples < nfftPoints
        %             disp('cohanal error: Trigger window is smaller than number of fft points desired.');
        %             return;
        %         end
        %
        %         nSteps  = floor( (nSamples - nfftPoints) / movingStep) + 1;
        %
        %         % Convert time stamps to indices into data{1} and data{2} arrays.
        %
        %         startIndexes = floor(sampleRate * (data{4}(1,:) / rate(4) - timeRange{hh,1}(1))) + startIndexOffset;
        %         stopIndexes = startIndexes + nSamples - 1;
        %
        %         % Make sure all windows fall completely withing the time range
        %
        %         index = find( (startIndexes > 0) & (stopIndexes <= length1) );
        %         startIndexes = startIndexes(index);
        %         siSize = size(startIndexes);
        %         if (siSize(1) ~= 1) % Transpose if necessary to get a row vector.
        %             startIndexes = startIndexes';
        %         end
        %         nTriggers = length(startIndexes);
        %
        %         seg_pwr = floor(log2(nfftPoints));

        % Create Spike Triggered Power and Coherence Time Course plots.
        % We overlap data for consecutive times by half the fftPoint size to
        % smooth transitions a bit.

        %     % Trigger based analysis
        %     for jj = 1:nTriggers                            % loop for nTriggers
        %         for ii = 1:nSteps       %ii=0:movingStep:nSamples-movingStep     % loop for Window moving
        %             selection = (ones(nfftPoints, 1) * startIndexes(jj)) + [0:nfftPoints-1]' + (ii - 1) * movingStep;
        %             %         S.t(ii) = (startIndexOffset + (ii - 1) * movingStep + nfftPoints/2) / sampleRate;
        %             [f, cl] = ftcohband(data{1}(selection)', data{2}(selection)', sampleRate, seg_pwr, 1, [], opt_str);
        %             if (ii==1 && jj==1)
        %                 % preallocate memory for result
        %                 S.triggerbased.px  = zeros(size(f,1),nSteps,nTriggers);
        %                 S.triggerbased.py  = S.triggerbased.px;
        % %                 S.cxy  = S.px;
        % %                 S.phixy  = S.px;
        % %                 S.phix  = S.px;
        % %                 S.phiy  = S.px;
        %                 S.triggerbased.ref   = zeros(nSteps,nTriggers);
        %                 S.triggerbased.t     = ones(1,nSteps);
        %                 S.triggerbased.freq  = f(:,1)';
        %                 S.triggerbased.opt_str   = opt_str;
        %                 S.triggerbased.nTriggers = nTriggers;
        %                 S.triggerbased.nSteps    = nSteps;
        %                 S.triggerbased.nfftPoints    = nfftPoints;
        %                 S.triggerbased.movingStep    = movingStep;
        %                 S.triggerbased.sampleRate    = sampleRate;
        %             end
        %             S.triggerbased.px(:,ii,jj) = f(:, 2);
        %             S.triggerbased.py(:,ii,jj) = f(:, 3);
        % %             S.cxy(:,ii,jj) = f(:, 4);
        % %             S.phixy(:,ii,jj) = f(:, 5);
        % %             S.phix(:,ii,jj) = f(:, 6);
        % %             S.phiy(:,ii,jj) = f(:, 7);
        %             if(~isempty(chanref))
        %                 S.triggerbased.ref(ii,jj)    = mean(data{3}(selection));
        %             end
        %             S.triggerbased.t(ii) = (startIndexOffset + (ii - 1) * movingStep + nfftPoints/2) / sampleRate;
        %         end
        %     end

        %     % timecoarse analysis
        %     for ii=1:nSteps%:nfftPoints2:nSamples-nfftPoints2
        %         selection = reshape((ones(nfftPoints, 1) * startIndexes) + ([0:nfftPoints-1]' * ones(1, nTriggers)), 1, nfftPoints * nTriggers) + (ii - 1) * movingStep;
        %         [f, cl] = ftcohband(data{1}(selection)', data{2}(selection)', sampleRate, seg_pwr, 1, [], opt_str);
        %
        %         if ii==1
        %             S.timecoarse.px = f(:, 2);
        %             S.timecoarse.py = f(:, 3);
        %             S.timecoarse.cxy = f(:, 4);
        %             S.timecoarse.phi = f(:, 5);
        %             S.timecoarse.cl   = cl;
        %             S.timecoarse.t  = S.triggerbased.t;
        %             S.timecoarse.freq  = S.triggerbased.freq;
        % %             S.compiled.x = startIndexOffset / sampleRate;
        %         else
        %             S.timecoarse.px = [S.timecoarse.px, f(:, 2)];
        %             S.timecoarse.py = [S.timecoarse.py, f(:, 3)];
        %             S.timecoarse.cxy = [S.timecoarse.cxy, f(:, 4)];
        %             S.timecoarse.phi = [S.timecoarse.phi, f(:, 5)];
        % %             x = [x, (startIndexOffset + i) / sampleRate];
        %         end
        %
        %     end

        % compiled analysis without movingstep


%         if trigWindow(1) >= 0  % Align samples at start of range.
%             nSamples = floor( (sampleRange(2) - sampleRange(1)) / nfftPoints(1) ) * nfftPoints(1);
%             startIndexOffset = sampleRange(1);
%         elseif trigWindow(2) <=0  % Align samples at end of range.
%             nSamples = floor( (sampleRange(2) - sampleRange(1)) / nfftPoints(1) ) * nfftPoints(1);
%             startIndexOffset = sampleRange(2) - nSamples;
%         else  % Align samples at trigger time.
%             startIndexOffset = -floor(-sampleRange(1) / nfftPoints(1)) * nfftPoints(1);
%             nSamples = floor( (sampleRange(2) - startIndexOffset) / nfftPoints(1) ) * nfftPoints(1);
%         end

        % Align samples at start of range.
        nSamples = floor( (sampleRange(2) - sampleRange(1)) / nfftPoints(1) ) * nfftPoints(1);
        startIndexOffset = sampleRange(1);
        
        if nSamples < nfftPoints(1)
            disp('cohanal error: Trigger window is smaller than number of fft points desired.');
            return;
        end

        startIndexes = floor(sampleRate * (data{4}(1,:) / rate(4) - timeRange{hh,1}(1))) + startIndexOffset;
        startIndexes = startIndexes(1:min(maxtrial,length(startIndexes)));
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

        DataMatrix{1}   = [DataMatrix{1}, reshape(data{1}(selection),nSamples,nTriggers)];  % [nSamples nTriggers]
        DataMatrix{2}   = [DataMatrix{2}, reshape(data{2}(selection),nSamples,nTriggers)];
        DataMatrix{3}   = [DataMatrix{3}, reshape(data{3}(selection),nSamples,nTriggers)];

    end % for hh=1:nCombine
    compiledData{1}     = reshape(DataMatrix{1},prod(size(DataMatrix{1})),1);
    compiledData{2}     = reshape(DataMatrix{2},prod(size(DataMatrix{2})),1);
    [S.compiled.f, S.compiled.cl] = ftcohband(compiledData{1}, compiledData{2}, sampleRate, seg_pwr(1), 1, [], opt_str);
    clear('compiledData');

    % timecoarse analysis

    nSteps  = floor( (nSamples - nfftPoints(2)) / movingStep) + 1;
    for ii=1:nSteps         %:nfftPoints2:nSamples-nfftPoints2
        selection   = [1:nfftPoints(2)] + (ii - 1) * movingStep;
        selectedDataMatrix{1} = DataMatrix{1}(selection,:);
        selectedDataMatrix{2} = DataMatrix{2}(selection,:);
        selectedDataMatrix{3} = DataMatrix{3}(selection,:);

        selectedData{1} = reshape(selectedDataMatrix{1},prod(size(selectedDataMatrix{1})),1);
        selectedData{2} = reshape(selectedDataMatrix{2},prod(size(selectedDataMatrix{2})),1);
        selectedData{3} = reshape(selectedDataMatrix{3},prod(size(selectedDataMatrix{3})),1);

        [f, cl] = ftcohband(selectedData{1}, selectedData{2}, sampleRate, seg_pwr(2), 1, [], opt_str);

        if ii==1
            S.timecoarse.px     = f(:, 2);
            S.timecoarse.py     = f(:, 3);
            S.timecoarse.cxy    = f(:, 4);
            S.timecoarse.phi    = f(:, 5);
            S.timecoarse.cl     = cl;
            S.timecoarse.freq   = f(:,1)';
        else
            S.timecoarse.px = [S.timecoarse.px, f(:, 2)];
            S.timecoarse.py = [S.timecoarse.py, f(:, 3)];
            S.timecoarse.cxy = [S.timecoarse.cxy, f(:, 4)];
            S.timecoarse.phi = [S.timecoarse.phi, f(:, 5)];

        end
        S.timecoarse.t(ii)  = (startIndexOffset + (ii - 1) * movingStep + nfftPoints(2)/2) / sampleRate;
        S.timecoarse.ref(ii)= mean(selectedData{3});
        clear('selectedData','selectedDataMatrix');
    end

    S.data  = DataMatrix;
    S.Name1 = getfield(chan1{hh,1},'Name');
    S.Name2 = getfield(chan2{hh,1},'Name');
    S.Nameref = getfield(chanref{hh,1},'Name');
    S.Nametrig  = getfield(chantrig{hh,kk},'Name');
    S.SampleRate =sampleRate;
    S.t     = [startIndexOffset:startIndexOffset+nSamples-1]/sampleRate;
    S.nfftpoints    = nfftPoints;
    S.movingstep    = movingStep;
    S.opt_str       = opt_str;
    S.ncombined     = nCombine;

    varargout{kk}   = S;
    clear('S');
end % for kk=1:nAnalyses