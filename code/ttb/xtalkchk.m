function S  = xtalkchk(Exp,ChanNames)
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


% % Exps = gsme;
% % if isempty(Exps)
% %     disp('SaveIntervals error: No experiments selected.');
% %     return;
% % end

ChanNames   = sortxls(ChanNames);

PeakWidth       = 100;  % ms
BinWidth        = 1;    % ms
SampleRate      = round(1000/BinWidth);
TimeRange       = [30 90];

% % nExp    = length(Exps); % Number of selected experiments.
nChan   = length(ChanNames); % Maximum number of channels looked at in each experiment.
nLags   = ceil(PeakWidth / BinWidth);

% % for iExp = 1:nExp
% %     Exp = Exps(iExp);

% find channel names
ExpName     = get(Exp, 'Name');
Chans       = cell(nChan,1);
SampleRates  = zeros(nChan,1);
for iChan = 1:nChan
    Chan    = experiment(Exp, 'findchannelobjs', ChanNames{iChan});
    Chans{iChan}    = Chan(1);
    SampleRates(iChan)   = get(Chan(1), 'SampleRate');

end

% Get data array, calculate XCorr for each pair of channels.
lRlmaxs = zeros(nChan,nChan);
Lags    = zeros(nChan,nChan);


% load data of all channels
for iChan =1:nChan
    tempdata    = getdata(Exp, ChanNames{iChan}, TimeRange);
    tempdata    = tempdata{1};
    SamplePerBin    = round(SampleRates(iChan)/SampleRate);
    data(iChan,:)   = downsample(tempdata,SamplePerBin);
end

for iChan = 1:nChan-1 % Substitute 1:nChan-1 to do all pairs (here and below)
    data1 = data(iChan,:);
    data1 = diff(data1,3);   %d3x
    data1 = data1 - mean(data1);
    for jChan = iChan+1:nChan
        data2 = data(jChan,:);
        data2 = diff(data2,3);   %d3x
        data2 = data2 - mean(data2);

        ndata1 = length(data1);
        ndata2 = length(data2);
        if ndata1 ~= ndata2
            disp(['ACorr: Warning, unequal data lengths for: ', Name{iChan}, '(n=', num2str(ndata1), '), ', Name{jChan}, '(n=', num2str(ndata2), '), in experimenent ', ExpName]);
            newSize = min(ndata1, ndata2);
            data1 = data1(1:newSize);
            data2 = data2(1:newSize);
        end
        [xcorrs, lags]  = xcorr(data1, data2, nLags, 'coeff');
        [lRlmax,ind]    = max(abs(xcorrs));
        lag             = lags(ind)* BinWidth;


        lRlmaxs(iChan,jChan)    = lRlmax;
        lRlmaxs(jChan,iChan)    = lRlmax;
        if(~isnan(lRlmax))
            Lags(iChan,jChan)       = lag;
            Lags(jChan,iChan)       = -1*lag;
        else
            Lags(iChan,jChan)   = NaN;
            Lags(jChan,iChan)   = NaN;
        end
            
    end
end
S.ChanNames = ChanNames;
S.lRlmaxs   = lRlmaxs;
S.Lags      = Lags;
% % end