function [Y,Y_data]  = sta(Tar, Ref, TimeWindow, maxtrials, Smoothing_bw, StoreTrial_flag, ISA_flag, Randomize_flag)
% Y  = sta(Tar(continuous), Ref(timestamp), TimeWindow, StoreTrial_flag[,maxtrials])
%
% INPUT
%  Tar         must be continuous channel struct
%  Ref         must be timestamp channel struct
%  TimeWindow          [-0.03 0.05] (sec)
%  maxtrials           [1 inf]
%  Smoothing_bw        5 (points) must be even!!
%  StoreTrial_flag     0 or 1
%  ISA_flag            0 or 1
%  Randomize_flag      0 or 1
%
% OUTPUT
%  Y.Name          = ['STA (',Ref.Name,', ',Tar.Name,')'];
%  Y.TargetName    = Tar.Name;
%  Y.ReferenceName = Ref.Name;
%  Y.Class         = Tar.Class;
%  Y.AnalysisType  = 'STA';
%  Y.TimeRange     = TimeWindow; in sec
%  Y.SampleRate    = Tar.SampleRate;
%  Y.TrialData     = TrialData;
%  Y.YData         = YData;
%  Y.XData         = XData;

error(nargchk(3,8,nargin,'struct'))

if nargin < 4
    maxtrials       = [1 Inf];
    Smoothing_bw    = 0;    % points
    StoreTrial_flag = 0;
    ISA_flag        = 0;
    Randomize_flag  = 0;
elseif nargin < 5
    Smoothing_bw    = 0;    % points
    StoreTrial_flag = 0;
    ISA_flag        = 0;
    Randomize_flag  = 0;
elseif nargin < 6
    StoreTrial_flag = 0;
    ISA_flag        = 0;
    Randomize_flag  = 0;
elseif nargin < 7
    ISA_flag        = 0;
    Randomize_flag  = 0;
elseif nargin < 8
    Randomize_flag  = 0;
end

if(Smoothing_bw > 1)
    Smoothing_flag  = 1;
else
    Smoothing_flag  = 0;
end

ISATimeWindow       = (-(TimeWindow(2)-TimeWindow(1))/2):0.001:((TimeWindow(2)-TimeWindow(1))/2);   % (sec)

if(length(Ref.Data)<maxtrials(1))
    disp(['Reference:',Ref.Name,', Target:',Tar.Name,', スパイク数(',num2str(length(Ref.Data)),')は最小スパイク数(',num2str(maxtrials(1)),')に達していないため、解析は続行しませんでした。'])
    Y=[];
    return;
end

Y.StoreTrial_flag   = StoreTrial_flag;
Y.ISA_flag          = ISA_flag;
if(ISA_flag)
    Y.ISATimeWindow     = ISATimeWindow;
end
Y.maxtrials         = maxtrials;
Y.Smoothing_flag    = Smoothing_flag;
if(Smoothing_flag)
    Y.Smoothing_bw      = Smoothing_bw;
end

if(ISA_flag == 1)
    
    TimeWindowIndex = round(TimeWindow * Tar.SampleRate);
    TimeWindowIndex(1)  = TimeWindowIndex(1) - Smoothing_bw;        % 最後のスムージングを考慮して余分にSmoothing_bw分だけデータを処理する
    TimeWindowIndex(2)  = TimeWindowIndex(2) + Smoothing_bw;
    
    ISATimeWindowIndex = round(ISATimeWindow * Tar.SampleRate);
    ISAWindowLengthIndex = length(ISATimeWindowIndex);
    WindowLengthIndex   = TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
    TimeWindow      = TimeWindowIndex / Tar.SampleRate;
    ISATimeWindow   = ISATimeWindowIndex / Tar.SampleRate;
    XData           = [TimeWindowIndex(1):TimeWindowIndex(2)]/ Tar.SampleRate;
    timestamp       = Ref.Data + (Ref.TimeRange(1) - Tar.TimeRange(1)) * Ref.SampleRate; % Targetの時間軸にあわせる(単位はRefのサンプリングポイント)
    timestamp       = round((timestamp * Tar.SampleRate) / Ref.SampleRate);    % Targetのサンプリングレートにあわせる
%     timestamp       = round((Ref.Data * Tar.SampleRate) / Ref.SampleRate);  % Targetのサンプリングレートにあわせる
    nstamps         = length(timestamp);
    nTarData        = length(Tar.Data);
    
    if(Randomize_flag == 1)
        % /*randomize
        rand('state',0) % ランダムで選ぶけど、いつも同じセットが出るようにしているということ
        randind         = randperm(nstamps);
        timestamp       = timestamp(randind);
        % randomize*/
    end
    
    StartIndices    = timestamp + TimeWindowIndex(1) + 1;
    StopIndices     = StartIndices + WindowLengthIndex -1;
    
    firstISAindex   = ISATimeWindowIndex(1) + TimeWindowIndex(1);
    lastISAindex    = ISATimeWindowIndex(end) + TimeWindowIndex(2);
    
    
    if(StoreTrial_flag==1)
        nSTAstamps  = 0;
        nISAstamps  = 0;
        TrialData   = zeros(nstamps,WindowLengthIndex);
        ISATrialData    = zeros(nstamps,WindowLengthIndex);
        YData       = zeros(1,WindowLengthIndex);
        ISAData     = zeros(1,WindowLengthIndex);
        
        for ii = 1:nstamps
            %             indicator(ii,nstamps,Tar.Name)
            if(timestamp(ii) + firstISAindex >= 1 && timestamp(ii) + lastISAindex<=nTarData && nSTAstamps < maxtrials(2))
                nSTAstamps      = nSTAstamps + 1;
                nISAstamps      = nISAstamps + ISAWindowLengthIndex;
                ISAindices      = timestamp(ii) + repmat(ISATimeWindowIndex',1,WindowLengthIndex) + repmat([TimeWindowIndex(1):TimeWindowIndex(2)],ISAWindowLengthIndex,1);
                TrialData(nSTAstamps,:) = Tar.Data([StartIndices(ii):StopIndices(ii)]);
                YData           = YData   + double(Tar.Data([StartIndices(ii):StopIndices(ii)]));
                ISAData         = ISAData + sum(double(Tar.Data(ISAindices)),1);
                ISATrialData(nSTAstamps,:)  = mean(double(Tar.Data(ISAindices)),1);
            else
                timestamp(ii)   = nan;
                if(Randomize_flag == 1)
                    randind(ii) = nan;
                end
            end
        end
        if nSTAstamps~=nstamps
            TrialData(nSTAstamps+1:end,:)   = [];
            ISATrialData(nSTAstamps+1:end,:)= [];
            timestamp(isnan(timestamp))     = [];
            if(Randomize_flag == 1)
                randind(isnan(randind))     = [];
            end
        end
        
        if(Randomize_flag == 1)
            % /* inverse randomize
            [randind,irandind] = sort(randind);    % inverse randomize****
            timestamp       = timestamp(irandind);
            TrialData       = TrialData(irandind,:);
            ISATrialData    = ISATrialData(irandind,:);
            %  inverse randomize */
        end
        
        YData                   = YData / nSTAstamps;
        ISAData                 = ISAData / nISAstamps;
    else
        nSTAstamps  = 0;
        nISAstamps  = 0;
        TrialData   = [];
        ISATrialData    = [];
        YData       = zeros(1,WindowLengthIndex);
        ISAData     = zeros(1,WindowLengthIndex);
        for ii = 1:nstamps
            indicator(ii,nstamps,Tar.Name)
            if(timestamp(ii) + firstISAindex >= 1 && timestamp(ii) + lastISAindex<=nTarData && nSTAstamps < maxtrials(2))
                nSTAstamps      = nSTAstamps + 1;
                nISAstamps      = nISAstamps + ISAWindowLengthIndex;
                ISAindices      = timestamp(ii) + repmat(ISATimeWindowIndex',1,WindowLengthIndex) + repmat([TimeWindowIndex(1):TimeWindowIndex(2)],ISAWindowLengthIndex,1);
                YData           = YData   + double(Tar.Data([StartIndices(ii):StopIndices(ii)]));
                ISAData         = ISAData + sum(double(Tar.Data(ISAindices)),1);
            else
                timestamp(ii)   = nan;
                if(Randomize_flag == 1)
                    randind(ii) = nan;
                end
            end
        end
        if nSTAstamps~=nstamps
            timestamp(isnan(timestamp))     = [];
            if(Randomize_flag == 1)
                randind(isnan(randind))     = [];
            end
        end
        
        if(Randomize_flag == 1)
            % /* inverse randomize
            [randind,irandind] = sort(randind);    % inverse randomize****
            timestamp       = timestamp(irandind);
            %  inverse randomize */
        end
        
        YData                   = YData / nSTAstamps;
        ISAData                 = ISAData / nISAstamps;
    end
    if(Smoothing_flag)
        YData         = smoothing(YData,Smoothing_bw,'boxcar');
        ISAData       = smoothing(ISAData,Smoothing_bw,'boxcar');
        if(~isempty(TrialData))
            TrialData = smoothing(TrialData,Smoothing_bw,'boxcar',2);
        end
        if(~isempty(ISATrialData))
            ISATrialData  = smoothing(ISATrialData,Smoothing_bw,'boxcar',2);
        end
    end
    TimeWindowIndex(1)  = TimeWindowIndex(1) + Smoothing_bw;
    TimeWindowIndex(2)  = TimeWindowIndex(2) - Smoothing_bw;
    TimeWindow      = TimeWindowIndex / Tar.SampleRate;
    XDataIndex      = (XData>=TimeWindow(1)&XData<=TimeWindow(2));
    
    Y.Name          = ['STA (',Ref.Name,', ',Tar.Name,')'];
    Y.TargetName    = Tar.Name;
    Y.ReferenceName = Ref.Name;
    Y.Class         = Tar.Class;
    Y.AnalysisType  = 'STA';
    Y.TimeRange     = TimeWindow;
    Y.SampleRate    = Tar.SampleRate;
    Y.TimeStamps    = timestamp;
    if(isempty(TrialData))
        Y.TrialData     = TrialData;
    else
        Y.TrialData     = TrialData(:,XDataIndex);
    end
    Y.nTrials       = nSTAstamps;
    Y.YData         = YData(XDataIndex);
    Y.XData         = XData(XDataIndex);
    if(isempty(ISATrialData))
        Y.ISATrialData  = ISATrialData;
    else
        Y.ISATrialData  = ISATrialData(:,XDataIndex);
        
    end
    Y.ISAData       = ISAData(XDataIndex);
    Y.nISA          = nISAstamps;
    if(isfield(Tar,'Unit'))
        Y.Unit      = Tar.Unit;
    end
    if(isfield(Ref,'TrialsToUse'))
        Y.TrialsToUse   = Ref.TrialsToUse;
    end
    
    %     indicator(0,0)
else    % if(ISA_flag == 1)
    
    TimeWindowIndex = round(TimeWindow * Tar.SampleRate);
    TimeWindowIndex(1)  = TimeWindowIndex(1) - Smoothing_bw;        % 最後のスムージングを考慮して余分にSmoothing_bw分だけデータを処理する
    TimeWindowIndex(2)  = TimeWindowIndex(2) + Smoothing_bw;
    
    WindowLengthIndex   = TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
    TimeWindow      = TimeWindowIndex / Tar.SampleRate;
    timestamp       = Ref.Data + (Ref.TimeRange(1) - Tar.TimeRange(1)) * Ref.SampleRate; % Targetの時間軸にあわせる(単位はRefのサンプリングポイント)
    timestamp       = round((timestamp * Tar.SampleRate) / Ref.SampleRate);    % Targetのサンプリングレートにあわせる
%     timestamp       = round((Ref.Data * Tar.SampleRate) / Ref.SampleRate);  % Targetのサンプリングレートにあわせる
    nstamps         = length(timestamp);
    nTarData        = length(Tar.Data);
    
    if(Randomize_flag == 1)
        % /*randomize
        rand('state',0) % ランダムで選ぶけど、いつも同じセットが出るようにしているということ
        randind         = randperm(nstamps);
        timestamp       = timestamp(randind);
        % randomize*/
    end
    
    StartIndices    = timestamp + TimeWindowIndex(1);
    StopIndices     = StartIndices + WindowLengthIndex -1;
    
    XData           = [TimeWindowIndex(1):TimeWindowIndex(2)]/ Tar.SampleRate;
    if(StoreTrial_flag==1)
        nSTAstamps      = 0;
        TrialData   = zeros(nstamps,WindowLengthIndex);
        for ii = 1:nstamps
            %             indicator(ii,nstamps,Tar.Name)
            if(StartIndices(ii)>0 && StopIndices(ii)<=nTarData && nSTAstamps < maxtrials(2))
                nSTAstamps  = nSTAstamps + 1;
                TrialData(nSTAstamps,:) = double(Tar.Data([StartIndices(ii):StopIndices(ii)]));
            else
                timestamp(ii)   = nan;
                if(Randomize_flag == 1)
                    randind(ii) = nan;
                end
            end
        end
        if nSTAstamps~=nstamps
            TrialData(nSTAstamps+1:end,:)   = [];
            timestamp(isnan(timestamp))     = [];
            if(Randomize_flag == 1)
                randind(isnan(randind))     = [];
            end
        end
        
        if(Randomize_flag == 1)
            % /* inverse randomize
            [randind,irandind] = sort(randind);    % inverse randomize****
            timestamp       = timestamp(irandind);
            TrialData       = TrialData(irandind,:);
            %  inverse randomize */
        end
        
        YData           = mean(TrialData,1);
    else %(StoreTrial_flag==1)
        nSTAstamps  = 0;
        TrialData   = [];
        YData       = zeros(1,WindowLengthIndex);
        for ii = 1:nstamps
            %             indicator(ii,nstamps,Tar.Name)
            if(StartIndices(ii)>0 && StopIndices(ii)<=nTarData && nSTAstamps < maxtrials(2))
                nSTAstamps  = nSTAstamps + 1;
                YData           = YData(1,:) + double(Tar.Data([StartIndices(ii):StopIndices(ii)]));
            else
                timestamp(ii)   = nan;
                if(Randomize_flag == 1)
                    randind(ii) = nan;
                end
            end
        end
        
        if nSTAstamps~=nstamps
            timestamp(isnan(timestamp))     = [];
            if(Randomize_flag == 1)
                randind(isnan(randind))     = [];
            end
        end
        
        if(Randomize_flag == 1)
            % /* inverse randomize
            [randind,irandind] = sort(randind);    % inverse randomize****
            timestamp       = timestamp(irandind);
            %  inverse randomize */
        end
        
        
        YData           = YData ./ nSTAstamps;
    end
    if(Smoothing_flag)
        YData         = smoothing(YData,Smoothing_bw,'boxcar');
        if(~isempty(TrialData))
            TrialData = smoothing(TrialData,Smoothing_bw,'boxcar',2);
        end
    end
    
    TimeWindowIndex(1)  = TimeWindowIndex(1) + Smoothing_bw;
    TimeWindowIndex(2)  = TimeWindowIndex(2) - Smoothing_bw;
    TimeWindow      = TimeWindowIndex / Tar.SampleRate;
    XDataIndex      = (XData>=TimeWindow(1)&XData<=TimeWindow(2));
    
    Y.Name          = ['STA (',Ref.Name,', ',Tar.Name,')'];
    Y.TargetName    = Tar.Name;
    Y.ReferenceName = Ref.Name;
    
    Y.Class         = Tar.Class;
    Y.AnalysisType  = 'STA';
    Y.TimeRange     = TimeWindow;
    Y.SampleRate    = Tar.SampleRate;
    Y.TimeStamps    = timestamp;
    if(isempty(TrialData))
        Y.TrialData     = TrialData;
    else
        Y.TrialData     = TrialData(:,XDataIndex);
    end
    Y.nTrials       = nSTAstamps;
    Y.YData         = YData(XDataIndex);
    Y.XData         = XData(XDataIndex);
    if(isfield(Tar,'Unit'))
        Y.Unit      = Tar.Unit;
    end
    if(isfield(Ref,'TrialsToUse'))
        Y.TrialsToUse   = Ref.TrialsToUse;
    end
    
    % indicator(0,0)
    
end

[Y,Y_data]  = makeSTADatafile(Y,[],0);

