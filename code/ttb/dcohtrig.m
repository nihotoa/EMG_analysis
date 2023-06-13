function [DC,phi,mHf,mSf,Hf,Sf,F]  = dcohtrig(Ref, Tar, trig,  TimeWindows, ar_order,DC_method,maxtrials)
% function [f,cl]  = tcohtrig(chan1file, chan2file, trigfile,  trigWindows, reffile, nfftPoints, movingStep)

if nargin < 7
    maxtrials = [];
end

% Ref   = load(Reffile);
% Tar   = load(Tarfile);
% trig    = load(trigfile);


TimeWindowIndex     = round(TimeWindows * Tar.SampleRate);
WindowLengthIndex	= TimeWindowIndex(2) - TimeWindowIndex(1) + 1;

TimeWindow      = TimeWindowIndex / Tar.SampleRate;
timestamp       = round((trig.Data * Tar.SampleRate) / trig.SampleRate);
nstamps         = length(timestamp);
nTarData        = length(Tar.Data);


StartIndices    = timestamp + TimeWindowIndex(1);
StopIndices     = StartIndices + WindowLengthIndex -1;


jj      = 0;
data1   = zeros(seg_tot,nfftPoints);
data2   = zeros(seg_tot,nfftPoints);

for ii = 1:nstamps
%     indicator(ii,nstamps,Tar.Name)
    if(StartIndices(ii)>0 & StopIndices(ii)<=nTarData)
        jj  = jj + 1;
        data1(jj,:) = Ref.Data([StartIndices(ii):StopIndices(ii)]);
        data2(jj,:) = Tar.Data([StartIndices(ii):StopIndices(ii)]);
        if (jj== maxtrials)
            break;
        end
    end
end
if jj~=nstamps
    data1(jj+1:end,:)   = [];
    data2(jj+1:end,:)   = [];
end
% seg_tot         = jj;
nstamps     = jj;

sample_rate = Tar.SampleRate;
% keyboard

mHf = [];
mSf = [];

for ii=1:nstamps
[Hf(ii,:,:,:), Sf(ii,:,:,:), F] = dtransf([data1(ii,:)',data2(ii,:)'],ar_order,ar_order,sample_rate);

end
mHf = squeeze(mean(Hf,1));
mSf = squeeze(mean(Sf,1));

[DC,phi]    = dcoh(mHf,mSf,F,DC_method);














timecoarse_flag = 1;

ARorder1   = nfftPoints1 - 1;


if isempty(currExperiment)
    disp('cohanal error: No experiment selected.');
    return;
end
if isempty(movingStep)
    timecoarse_flag = 0;
end
% seg_pwr = floor(log2(nfftPoints));

% Figure decimation factors

names{1} = chanName1;
names{2} = chanName2;
if(iscell(chanNametrig))
    if(~iscell(trigWindows) || (length(chanNametrig)~=length(trigWindows)))
        disp('cohanal error: Invalid inputs.');
        return;
    end
    for ii=1:length(chanNametrig)
        names{2+ii} = chanNametrig{ii};
    end
    nAnalyses   = length(chanNametrig);
else
    names{3} = chanNametrig;
    nAnalyses   = 1;
end
if(~isempty(chanNameref))
    addchind    = length(names)+1;
    names{addchind}    = chanNameref;
end
channels = experiment(currExperiment, 'findchannelobjs', names);
if any(isnull(channels))
    disp('cohanal error: could not find channels');
    return;
end
for ii=1:length(channels)
    rate(ii)    = get(channels(ii), 'SampleRate');
    dec(ii)     = 1;
end

sampleRate = rate(1);
if rate(1) < rate(2)
    dec(2) = rate(2) / sampleRate;
elseif rate(2) < rate(1)
    sampleRate = rate(2);
    dec(1) = rate(1) / sampleRate;
end
if(~isempty(chanNameref))
    dec(addchind)    = rate(addchind) / sampleRate;
end


if (dec(1) ~= floor(dec(1))) || (dec(2) ~= floor(dec(2)))
    disp('cohanal error: sample rates do not be resampled to match');
    return;
end

% Get data arrays. Decimate data if needed.
for ii=1:length(names)
    filt{ii}    = {};
end
data = getdata(currExperiment, names, timeRange, filt);

if dec(1) > 1.0
    data{1} = data{1}(1:dec(1):length(data{1}));
end
if dec(2) > 1.0
    data{2} = data{2}(1:dec(2):length(data{2}));
end
if(~isempty(chanNameref))
    data{addchind} = data{addchind}(1:dec(addchind):length(data{addchind}));
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
    DataMatrix   ={[],[],[]};
    trigName    = chanNametrig{kk};
    trigWindow  =trigWindows{kk};
    sampleRange = floor(trigWindow * sampleRate);

    % Align samples at start of range.
    nSamples = floor( (sampleRange(2) - sampleRange(1)) / WindowSize1 ) * WindowSize1;
    startIndexOffset = sampleRange(1);


    if nSamples < WindowSize1
        disp('cohanal error: Trigger window is smaller than number of fft points desired.');
        return;
    end

    startIndexes = floor(sampleRate * (data{2+kk}(1,:) / rate(2+kk) - timeRange(1))) + startIndexOffset;
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
    %     DataMatrix{3}   = [DataMatrix{3}, reshape(data{3}(selection),nSamples,nTriggers)];

    % compiled analysis
    
    %     compiledData{1}     = reshape(DataMatrix{1},prod(size(DataMatrix{1})),1);
    %     compiledData{2}     = reshape(DataMatrix{2},prod(size(DataMatrix{2})),1);
    %     [S.compiled.coh, S.compiled.phase, S.compiled.freq] = dcohband([compiledData{1}, compiledData{2}], ARorder, nfftPoints, sampleRate, opt_str, 'b');
    %     clear('compiledData');

    for ii=1:nTriggers         %:nfftPoints2:nSamples-nfftPoints2

        selectedData{1} = DataMatrix{1}(:,ii);
        selectedData{2} = DataMatrix{2}(:,ii);
        [Hf(:,:,:,ii), Sf(:,:,:,ii), freq]    = dtransf([selectedData{1}, selectedData{2}], ARorder1, nfftPoints1, sampleRate, opt_str);

    end

    % average all individual Hf and Sf
    Hf  = mean(Hf,4);
    Sf  = mean(Sf,4);

    [S.compiled.coh, S.compiled.phase]  = dcoh(Hf,Sf,freq,'b');
    S.compiled.freq   = freq;
    S.compiled.coh(:,:,1) = zeros(size(S.compiled.coh(:,:,1)));
    clear('selectedData', 'Hf', 'Sf');


    if timecoarse_flag == 1
        % timecoarse analysis
        
        ARorder2   = nfftPoints2 - 1;

        nSteps  = floor( (nSamples - WindowSize2) / movingStep) + 1;
        for ii=1:nSteps         %:nfftPoints2:nSamples-nfftPoints2
            selection   = [1:WindowSize2] + (ii - 1) * movingStep;

            for jj=1:nTriggers
                selectedData{1} = DataMatrix{1}(selection,jj);
                selectedData{2} = DataMatrix{2}(selection,jj);
                %
                %         selectedDataMatrix{1} = DataMatrix{1}(selection,:);
                %         selectedDataMatrix{2} = DataMatrix{2}(selection,:);
                % %         selectedDataMatrix{3} = DataMatrix{3}(selection,:);
                %
                %         selectedData{1} = reshape(selectedDataMatrix{1},prod(size(selectedDataMatrix{1})),1);
                %         selectedData{2} = reshape(selectedDataMatrix{2},prod(size(selectedDataMatrix{2})),1);
                %         selectedData{3} = reshape(selectedDataMatrix{3},prod(size(selectedDataMatrix{3})),1);

                [Hf(:,:,:,jj), Sf(:,:,:,jj), freq]    = dtransf([selectedData{1}, selectedData{2}], ARorder2, nfftPoints2, sampleRate, opt_str);
            end

            % average all individual Hf and Sf
            Hf  = mean(Hf,4);
            Sf  = mean(Sf,4);

            [coh, phase]  = dcoh(Hf,Sf,freq,'b');

            if ii==1
                S.timecoarse.coh    = coh;
                S.timecoarse.phase  = phase;
                S.timecoarse.freq   = freq;
            else
                S.timecoarse.coh    = cat(4,S.timecoarse.coh,coh);
                S.timecoarse.phase  = cat(4,S.timecoarse.phase,phase);
            end
            S.timecoarse.t(ii)  = (startIndexOffset + (ii - 1) * movingStep + WindowSize2/2) / sampleRate;
            %         S.timecoarse.ref(ii)= mean(selectedData{3});
            S.timecoarse.coh(:,:,1) = zeros(size(S.timecoarse.coh(:,:,1)));
            clear('selectedData', 'Hf', 'Sf');
        end
    end

    % output analysis

    %     S.data  = DataMatrix;
    %     S.Name1 = getfield(chan1{hh,1},'Name');
    %     S.Name2 = getfield(chan2{hh,1},'Name');
    %     S.Nameref = getfield(chanref{hh,1},'Name');
    %     S.Nametrig  = getfield(chantrig{hh,kk},'Name');
    %     S.SampleRate =sampleRate;
    %     S.t     = [startIndexOffset:startIndexOffset+nSamples-1]/sampleRate;
    %     S.nfftpoints    = nfftPoints;
    %     S.movingstep    = movingStep;
    %     S.opt_str       = opt_str;
    %     S.ncombined     = nCombine;
    %
    varargout{kk}   = S;
    clear('S');
end
