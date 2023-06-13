function acorr(ChanNames, PeakWidth, BinWidth, GaussianSDBins, TimeRange, Option, plot_flag, print_flag, alpha)
% acorr(ChanNames, PeakWidth, BinWidth, GaussianSDBins <,TimeRange>)
%   ChanNames -- a cell array of the names of Continuous and Timestamp channels to cross correlate
%   PeakWidth -- Width (in milliseconds) of cross correlation graphs.
%   BinWidth -- Width (in milliseconds) of bins in the cross correation function.
%   GaussianSDBins -- Number of bins for standard deviation of the gaussian
%       used for smoothing timestamp channels. Must be an integer.
%       0 Gives a direct spike conversion (each spike = a count of 1).
%       Negative values use an interspike interval method for timestamp conversion.
%   TimeRange -- [StartTimeSec, EndTimeSec] optional time range in seconds over
%                   which to do the analysis. If omitted, all time is used.
%   Option -- Options. To use pre-3rd-differentiated data, enter 'd3x'.
% Performs an analog cross correlation between all the given channels.
% Continuous channels are downsampled to the given BinWidth.
% Timestamp channels are converted to analog channels by convolving the Timestamp's
% impulse function with a Gaussian function of SD = GaussianSDWidth.
%
% Modified by TT 070203 add pre-d3x function

% rcl  =  0.1;

selectedExperiments = gsme;

if isempty(selectedExperiments)
    disp('SaveIntervals error: No experiments selected.');
    return;
end
if nargin < 5
    timewindow = [0 Inf];
    Option     = 'none';
    plot_flag   =1;
    print_flag  =0;
    alpha      = 0.05;
elseif nargin < 6
    timewindow = TimeRange;
    Option     = 'none';
    plot_flag   =1;
    print_flag  =0;
    alpha      = 0.05;
elseif nargin < 7
    timewindow  = TimeRange;
    plot_flag   =1;
    print_flag  =0;
    alpha      = 0.05;
elseif nargin < 8
    timewindow  = TimeRange;
    print_flag  =0;
    alpha      = 0.05;
elseif nargin < 9
    timewindow  = TimeRange;
    alpha      = 0.05;
else
    timewindow  = TimeRange;
end

d3x_flag    =0;
matrix_flag =0;
% plot_flag   =1;
% print_flag  =1;

options = deblank(Option);
while (any(options))              % Parse individual options from string.
    [opt,options] = strtok(options);
    switch opt
        case 'd3x'             %
            d3x_flag    =1;
        case 'matrix'             %
            matrix_flag    =1;
            %         case 'plot'             %
            %             plot_flag    =1;
            %         case 'print'             %
            %             print_flag    =1;
    end
end
Option(Option==' ') =[];
GaussianSDBins = ceil(GaussianSDBins);

% Maker sure destination directory L:\tkitom\data\acorr\ exists

warning('off', 'MATLAB:MKDIR:DirectoryExists');
mkdir('L:\tkitom\', 'data');
mkdir('L:\tkitom\data\', 'acorr');
warning('on', 'MATLAB:MKDIR:DirectoryExists');

% Loop through all selected experiments

nExperiments = length(selectedExperiments); % Number of selected experiments.
nChannels = length(ChanNames); % Maximum number of channels looked at in each experiment.
maxPlots = nChannels * (nChannels - 1) / 2; % Total number of xcorrs per experiment.
nLags = ceil(PeakWidth / BinWidth);

for expIndex = 1:nExperiments

    currExperiment = selectedExperiments(expIndex);

    % find channel names

    expName = get(currExperiment, 'Name');
    channel = {};
    name = {};
    rate = [];
    for i = 1:nChannels
        chan = experiment(currExperiment, 'findchannelobjs', ChanNames{i});
        if length(chan) < 1
            disp(['ACorr: ' ChanNames{i} ' not found in experiment: ' expName]);
            continue;
        end
        chantype = get(chan, 'Class');
        if (strcmp(chantype, 'continuous channel') | strcmp(chantype, 'timestamp channel'))
            name{end+1} = ChanNames{i};
            channel{end+1} = chan(1);
            rate(end+1) = get(chan(1), 'SampleRate');
        else
            disp(['ACorr: ' ChanNames{i} ' is not a Continuous or Timestamp channel in: ' expName]);
            continue;
        end
    end

    nchans = length(rate); % number of channels for this particular experiment.
    if nchans < 2
        disp(['ACorr: no channel pairs matched in experiment: ' expName]);
        continue;
    end

    % Get data array, calculate XCorr for each pair of channels.

    xcorrs = [];
    index = 0;
    nPlots = 0;
    switch matrix_flag
        case 1
            nloops  = nchans-1;
        case 0
            nloops  = 1;
    end
    
    % load data of all channels
    for ii =1:nchans
        data(ii,:)  = downsample(currExperiment, name{ii}, channel{ii}, BinWidth, GaussianSDBins, timewindow);
    end
    pack
    
    for i = 1:nloops % Substitute 1:nchans-1 to do all pairs (here and below)
        %     for i = 1:nchans-1 % Substitute 1:nchans-1 to do all pairs (here and below)
%         data1 = downsample(currExperiment, name{i}, channel{i}, BinWidth, GaussianSDBins, timewindow);
        data1 = data(i,:);
        if(d3x_flag  == 1)
            data1 = diff(data1,3);   %d3x
        end
        data1 = data1 - mean(data1);
        for j = i+1:nchans
%             data2 = downsample(currExperiment, name{j}, channel{j}, BinWidth, GaussianSDBins, timewindow);
            data2 = data(j,:);
            if(d3x_flag  == 1)
                data2 = diff(data2,3);   %d3x
            end
            data2 = data2 - mean(data2);

            index = index + 1;
            n1 = length(data1);
            n2 = length(data2);
            if n1 ~= n2
                disp(['ACorr: Warning, unequal data lengths for: ', name{i}, '(n=', num2str(n1), '), ', name{j}, '(n=', num2str(n2), '), in experimenent ', expName]);
                newSize = min(n1, n2);
                data1 = data1(1:newSize);
                data2 = data2(1:newSize);
            end
            [xcorrs(index,:), lags] = xcorr(data1, data2, nLags, 'coeff');
            N(index)   = length(data1);
            nPlots = nPlots + 1;
        end
    end


    % Make sure summary file is created

    fid = fopen('L:\tkitom\data\acorr\DataSummary.xls', 'r');
    if fid == -1
        fid = fopen('L:\tkitom\data\acorr\DataSummary.xls', 'w');
        fprintf(fid, 'Date\tFile\tChans\tExpName\tChan1\tChan2\tOption\tR\trMax\tAbs(rMax)\tLatency(ms)\tN(points)\tcl(%g)',alpha);
    end
    fclose(fid);
    outfilename = ['L:\tkitom\data\acorr\' expName '(' num2str(timewindow(1)) ',' num2str(timewindow(2)) ')' num2str(GaussianSDBins) Option '.xls'];


    if(plot_flag   == 1)
        % Caculate number of rows and columns to use in figure by trying to
        % make twice as many rows as columns.

        cols = ceil(sqrt(nPlots / 2));
        rows = ceil(nPlots / cols);

        % Create Figure

        H = figure('Numbertitle','off',...
            'Name',[expName '(' num2str(timewindow(1)) ',' num2str(timewindow(2)) ')' num2str(GaussianSDBins) Option],...
            'Position', [300,50,600,700]);
        figure(H);
    end


    lags = lags * BinWidth;  % Convert lags from samples to milliseconds.
    index = 0;
    for i = 1:nloops % Substitute with 1:nchans-1 to do all pairs (here and above)
        %     for i = 1:nchans-1 % Substitute with 1:nchans-1 to do all pairs (here and above)
        for j = i+1:nchans
            index = index + 1;
            
            % Confidence limit for correlation
            rcl   = t2r(tinv(1 - alpha/2,N(index)-2),N(index));
            
            % The maximum correlation and lag.
            [maxv,imax] = max(xcorrs(index, :));
            [minv,imin] = min(xcorrs(index, :));
            if abs(minv) > abs(maxv)
                maxv = minv;
                imax = imin;
            end
            
            % The correlation at zero lag.
            [temp1, ind_zerolag]  = nearest(lags,0);
            R_zerolag   = xcorrs(index, ind_zerolag);
            
            if(plot_flag   == 1)
                subplot(rows, cols, index);
                plot(lags, xcorrs(index,:));
                line([lags(1),lags(1);lags(end),lags(end)],[-rcl,rcl;-rcl,rcl],'Color',[0.5 0.5 0.5]);
                set(gca, 'XLim', [lags(1) lags(end)]); % Force X axis same for every subplot.
                %             limit = max(abs(get(gca, 'YLim')));
                %             if (limit > 0.5)
                %                 limit = 1;
                %             end
                limit = 1;        % normalized y-axis -1~1
                set(gca, 'YLim', [-limit limit]); % Set symetrical Y limits with a max range of [-1 1].

                % Stick an overall figure title as centered as possible in one of the subplot titles.

                if ((index == 1) && nPlots <= 4) || ((index == cols+1) && (nPlots > 4));
                    textline = ['XCorr: ' expName ',  Time: (' num2str(timewindow(1)) ', ' num2str(timewindow(2)) '), GSD: ' num2str(GaussianSDBins * BinWidth) 'ms, Opt: ' Option];
                    ylabel(textline);
                end

                % Print the maximum correlation and lag as the y label.

                textline = ['r = ' num2str(maxv) '[r^2 = ' num2str(maxv^2) '] at ' num2str(lags(imax)) 'ms cl(' num2str(alpha) ') = ' num2str(rcl)];
                title(textline);

                % Only place x axis on bottom most subplots.

                if (nPlots - index >= cols)
                    xlabel([name{i} ' -> ' name{j}]);
                    set(gca, 'XTickLabel', '');
                else
                    xlabel([name{i} ' -> ' name{j} ' (ms)']);
                end
            end
            
            % make an entry in the summary file
            %           keyboard
            fid = fopen('L:\tkitom\data\acorr\DataSummary.xls', 'a');
            if fid ~= -1
                fprintf(fid, '\r\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%g\t%g\t%g\t%g\t%d\t%g', date, outfilename, [name{i} '->' name{j}], expName, name{i}, name{j}, Option,R_zerolag, maxv, abs(maxv), lags(imax), N(index), rcl);
                fclose(fid);
            end

        end
    end

    % Save data to a file

    textline = ['L:\tkitom\data\acorr\' expName '(' num2str(timewindow(1)) ',' num2str(timewindow(2)) ')' num2str(GaussianSDBins) Option '.xls'];
    fid = fopen(textline, 'w');
    if fid ~= -1
        % Write header
        fprintf(fid, 'Analog xcorr: %s\r\n', textline);
        fprintf(fid, 'Time(ms)');
        for i = 1:nloops
            for j = i+1:nchans
                fprintf(fid, '\t%s->%s', name{i}, name{j});
            end
        end

        % Write out xcorrs 1 per column.
        n = length(lags);
        for i = 1:n
            fprintf(fid, '\r\n%g', lags(i));
            for j=1:nPlots
                fprintf(fid, '\t%g', xcorrs(j, i));
            end
        end

        fclose(fid);
        disp([textline,' was made.  (',datestr(now),')'])
    else
        disp(['     ***** Error: Failed to make file... ', textline])
    end
    if(plot_flag ==1 & print_flag == 1)
        print(H)
    end
%     close(H)
end

%%%%%%%%%%%%%%%%%%%%%%%%

function samples = downsample(Experiment, ChanName, ChanObj, BinWidth, SDBins, Time)
% Get data from a continous or timestamp channel and down sample it to
% BinWidth milliseconds for the given time range

data = getdata(Experiment, ChanName, Time);
data = data{1};
data = data(1,:);
chantype = get(ChanObj, 'Class');
samplerate = get(ChanObj, 'SampleRate');

if (strcmp(chantype, 'timestamp channel') & (SDBins < 0))
    % Convert timestamps to a continuous signal using an interspike
    % interval method.  All samples between two timestamps are set
    % to a firing rate = samplerate/(sample(i+1) - sample(i-1));
    % Then we let the next code section down sample the channel.
    tstamps = data;
    data = zeros(1, (Time(2) - Time(1)) * samplerate);
    zerobin = floor(Time(1) * samplerate) - 1;
    ntstamps = length(tstamps);
    if ntstamps > 1
        leftbin = tstamps(1) - zerobin;
        for i=2:ntstamps
            rightbin = tstamps(i) - zerobin;
            data(leftbin:rightbin) = samplerate / (rightbin - leftbin);
            leftbin = rightbin;
        end
    end
    chantype = 'continuous channel';
end

if strcmp(chantype, 'continuous channel')
    % average consecutive points together to acheive the desired sample
    % rate.  If BinWidth is not evenly divisible by the sample width,
    % then edge effects will cause some bins to be used more than once.
    % This could create some extra covariation between bins, but should
    % not be much of a problem.  Normally the user should pick a final
    % binwidth that is an exact multiple of the original sampling interval.
    npoints = length(data);
    sampleWidth = 1000.0 / samplerate; % Width of a sample in milliseconds
    samplesPerBin = max([1, floor(BinWidth * samplerate / 1000)]);
    sampleIndexes = floor(0:BinWidth / sampleWidth:npoints-samplesPerBin);
    nindexes = length(sampleIndexes);
    samples = zeros(1, nindexes);
    for i=1:nindexes
        index = sampleIndexes(i);
        samples(i) = mean(data(index+1:index+samplesPerBin));
    end
elseif strcmp(chantype, 'timestamp channel')
    % use SDBins * 4 + 1 central bins from a gaussian function with standard
    % deviation of SDBins. Pad samples with an extra SDBins * 4 elements to
    % account for the offset caused by the Filter function.
    samples = zeros(1, SDBins * 4 + (Time(2) - Time(1)) * 1000 / BinWidth);
    timestampBins = floor((data(1,:) * 1000.0) / (samplerate * BinWidth)) + SDBins * 2;
    n = length(timestampBins);
    nsamples = length(samples);
    for i=1:n
        bin = timestampBins(i);
        if bin > nsamples
            break;
        end
        samples(bin) = samples(bin) + 1;
    end
    samples = filter(discretegaussian(SDBins, SDBins * 4 + 1), 1, samples);
    samples = samples(SDBins * 4 + 1 : end);
else
    samples = zeros(1, (Time(2) - Time(1)) * 1000 / BinWidth);
end

