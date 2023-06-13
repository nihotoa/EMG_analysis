function makeOriginalChannels(pathname,processIDs)
% fieldの解析をするときのデフォルト   processID   = 1:10
% unitの解析をするときのデフォルト    processID   = 101:119
% ICMSの解析をするときのデフォルト    processID   = 201
% 特殊用途                          processID   = 30x
% PT stimの解析をするときのデフォルト processID   = 401
% Synergy解析するときのデフォルト　　prpcessID    = 501:
% SCI Synergy解析するときのデフォルト　　prpcessID    = 601:

%%
% 1
% Index Position(mm)
% Thumb Position(mm)
%
% 2
% Index Torque(N)
% Thumb Torque(N)
% Total Torque(N)
% Total deriv Torque(Nps)
%
% 3
% Field 1 (OB)
%
% 4
% Trial Interval
% Trial Interval (success)
% Trial Interval (success valid)
% Trial Interval (svwostim)
%
% 5
% Grip Onset
% Grip Onset (success)
% Grip Onset (success valid)
% Grip Onset (svwostim)
%
% 6
% Release Onset
% Release Onset (success)
% Release Onset (success valid)
% Release Onset (svwostim)
%
% 7 各timestampやintervalが同じ数だけ存在するようにするプロセス（重要）
% !!!!!!again!!!!!!
% Trial Interval	!!!!!!again!!!!!!
% Trial Interval (success)	!!!!!!again!!!!!!
% Trial Interval (success valid)	!!!!!!again!!!!!!
% Trial Interval (svwostim)	!!!!!!again!!!!!!
% Grip Onset!!!!!!again!!!!!!
% Grip Onset (success)!!!!!!again!!!!!!
% Grip Onset (success valid)!!!!!!again!!!!!!
% Grip Onset (svwostim)!!!!!!again!!!!!!
% Release Onset!!!!!!again!!!!!!
% Release Onset (success)!!!!!!again!!!!!!
% Release Onset (success valid)!!!!!!again!!!!!!
% Release Onset (svwostim)!!!!!!again!!!!!!
%
% 8
% Trial Start
% Trial Start (success)
% Trial Start (success valid)
% Trial Start (svwostim)
%
% 9
% Go Onset
% Go Onset (success)
% Go Onset (success valid)
% Go Onset (svwostim)
%
% 10
% EndHold
% EndHold (success)
% EndHold (success valid)
% EndHold (svwostim)
%
% % (補欠)
% % RT
% % RT (success)
% % RT (success valid)
% % RT (svwostim)

warning('off')
%% Deal with input arguments

error(nargchk(1,2,nargin,'struct'));
% if(nargin<1)
%     pathname    = uigetdir(matpath,'Experimentを選択してください');
% end

nIDs    = length(processIDs);

for iID = 1:nIDs
    processID   = processIDs(iID);
    

%% 1
% Index Position(mm)
% Thumb Position(mm)


if(any(ismember(1,processID)))
    disp('1')
    % load
    ch1 = load(fullfile(pathname,'smoothed index(mm).mat'));
    ch2 = load(fullfile(pathname,'smoothed thumb(mm).mat'));

    % parameter
    SampleRate  = ch1.SampleRate;
    TimeRange   = ch1.TimeRange;
    nData       = length(ch1.Data);

    % Header
    Y1.TimeRange    = TimeRange;
    Y1.Name         = 'Index Position(mm)';
    Y1.Class        = 'continuous channel';
    Y1.SampleRate   = SampleRate;
    Y1.Unit         = 'mm';

    Y2.TimeRange    = TimeRange;
    Y2.Name         = 'Thumb Position(mm)';
    Y2.Class        = 'continuous channel';
    Y2.SampleRate   = SampleRate;
    Y2.Unit         = 'mm';

    % Data
    % detrend
    bpw     = SampleRate*300;       % 5分間のデータの長さ
    if(nData >= bpw)                    % detrend bpをやるにたる長さがあるときだけ
        nbp     = floor(nData/bpw);
        bpind   = repmat([-1,0],nbp,1)+repmat([1:nbp]',1,2);
        bpind(:,1)  = bpind(:,1)*bpw+1;
        bpind(:,2)  = bpind(:,2)*bpw;
        if(nData - nbp*bpw>=2)
            bpind    = [bpind;[nbp*bpw+1,nData]];
            nbp  = nbp+1;
        end
        for ibp =1:nbp
            ind  = [bpind(ibp,1):bpind(ibp,2)];
            Y1.Data(ind) = detrend(ch1.Data(ind),'linear');
            Y2.Data(ind) = detrend(ch2.Data(ind),'linear');
        end
    else
        Y1.Data = detrend(ch1.Data,'linear');
        Y2.Data = detrend(ch2.Data,'linear');
    end
    %     if(nData >= bpw)                    % detrend bpをやるにたる長さがあるときだけ
    %         Y1.Data = detrend(ch1.Data,'linear',[1:bpw:nData]);
    %         Y2.Data = detrend(ch2.Data,'linear',[1:bpw:nData]);
    %     else
    %         Y1.Data = detrend(ch1.Data);
    %         Y2.Data = detrend(ch2.Data);
    %     end
    % zero offset
    Y1.Data = Y1.Data - mean(Y1.Data(Y1.Data<prctile(Y1.Data,50)));
    Y2.Data = Y2.Data - mean(Y2.Data(Y2.Data<prctile(Y2.Data,50)));

    % save
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));

    % clear
    clear('ch1','ch2','Y1','Y2');
    %pack;
end
%% 2
% Index Torque(N)
% Thumb Torque(N)
% Total Torque(N)
% Total deriv Torque(Nps)

if(any(ismember(2,processID)))
    disp('2')
    % load
    ch1 = load(fullfile(pathname,'smoothed Index Torque(N).mat'));
    ch2 = load(fullfile(pathname,'smoothed Thumb Torque(N).mat'));

    % parameter
    SampleRate  = ch1.SampleRate;
    TimeRange   = ch1.TimeRange;
    nData       = length(ch1.Data);

    % Header
    Y1.TimeRange    = TimeRange;
    Y1.Name         = 'Index Torque(N)';
    Y1.Class        = 'continuous channel';
    Y1.SampleRate   = SampleRate;
    Y1.Unit         = 'N';

    Y2.TimeRange    = TimeRange;
    Y2.Name         = 'Thumb Torque(N)';
    Y2.Class        = 'continuous channel';
    Y2.SampleRate   = SampleRate;
    Y2.Unit         = 'N';

    Y3.TimeRange    = TimeRange;
    Y3.Name         = 'Total Torque(N)';
    Y3.Class        = 'continuous channel';
    Y3.SampleRate   = SampleRate;
    Y3.Unit         = 'N';

    Y4.TimeRange    = TimeRange;
    Y4.Name         = 'Total deriv Torque(Nps)';
    Y4.Class        = 'continuous channel';
    Y4.SampleRate   = SampleRate;
    Y4.Unit         = 'Nps';

    % Data
    % detrend
    bpw     = SampleRate*300;       % 5分間のデータの長さ
    if(nData >= bpw)                    % detrend bpをやるにたる長さがあるときだけ
        nbp     = floor(nData/bpw);
        bpind   = repmat([-1,0],nbp,1)+repmat([1:nbp]',1,2);
        bpind(:,1)  = bpind(:,1)*bpw+1;
        bpind(:,2)  = bpind(:,2)*bpw;
        if(nData - nbp*bpw>=2)
            bpind    = [bpind;[nbp*bpw+1,nData]];
            nbp  = nbp+1;
        end
        for ibp =1:nbp
            ind  = [bpind(ibp,1):bpind(ibp,2)];
            Y1.Data(ind) = detrend(ch1.Data(ind),'linear');
            Y2.Data(ind) = detrend(ch2.Data(ind),'linear');
        end
    else
        Y1.Data = detrend(ch1.Data,'linear');
        Y2.Data = detrend(ch2.Data,'linear');
    end
    %     if(nData >= bpw)                    % detrend bpをやるにたる長さがあるときだけ
    %         Y1.Data = detrend(ch1.Data,'linear',[1:bpw:nData]);
    %         Y2.Data = detrend(ch2.Data,'linear',[1:bpw:nData]);
    %     else
    %         Y1.Data = detrend(ch1.Data);
    %         Y2.Data = detrend(ch2.Data);
    %     end
    % zero offset
    Y1.Data = Y1.Data - mean(Y1.Data(Y1.Data<prctile(Y1.Data,50)));
    Y2.Data = Y2.Data - mean(Y2.Data(Y2.Data<prctile(Y2.Data,50)));

    % sum and diff
    Y3.Data	= Y1.Data + Y2.Data;
    Y4.Data = [0 diff(Y3.Data)] * SampleRate;


    % save
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));

    % clear
    clear('ch1','ch2','Y1','Y2','Y3','Y4');
    %pack;
end
%% 3
%   Field 1 (OB) and/or Field 2 (OB)

if(any(ismember(3,processID)))
    disp('3')
    th  = 4;    % V

    % Field 1 (OB) Only
    if(exist(fullfile(pathname,'Field 1.mat'),'file') && ~exist(fullfile(pathname,'Field 2.mat'),'file'))
        disp('Field 1 Only')
        ch1 = load(fullfile(pathname,'Field 1.mat'));
        Y1  = makeTimestampChannel('Field 1 (OB)', 'threshold', ch1, th, (-1)*th);

        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');
        clear('ch1','Y1');
        %pack;
    end

    % Field 2 (OB) Only
    if(~exist(fullfile(pathname,'Field 1.mat'),'file') && exist(fullfile(pathname,'Field 2.mat'),'file'))
        disp('Field 2 Only')
        ch1 = load(fullfile(pathname,'Field 2.mat'));
        Y1  = makeTimestampChannel('Field 2 (OB)', 'threshold', ch1, th, (-1)*th);

        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');
        clear('ch1','Y1');
        %pack;
    end

    % Field 1 (OB) & Field 2 (OB)
    if(exist(fullfile(pathname,'Field 1.mat'),'file') && exist(fullfile(pathname,'Field 2.mat'),'file'))
        disp('Field 1 & Field 2')
        ch1 = load(fullfile(pathname,'Field 1.mat'));
        ch2 = load(fullfile(pathname,'Field 2.mat'));
        Y1  = makeTimestampChannel('Field 1 (OB)', 'threshold', ch1, th, (-1)*th);
        Y2  = makeTimestampChannel('Field 2 (OB)', 'threshold', ch2, th, (-1)*th);

        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
        clear('ch1','ch2','Y1','Y2');
        %pack;
    end
end
%% 4
% % Trial Interval
% % Trial Interval (success)
% % Trial Interval (success valid)
% % Trial Interval (svwostim)

if(any(ismember(4,processID)))
    disp('4')
    % Field 1 (OB) Only
    if(exist(fullfile(pathname,'Field 1.mat'),'file') && ~exist(fullfile(pathname,'Field 2.mat'),'file'))

        ch1 = load(fullfile(pathname,'OutT1 On.mat'));
        ch2 = load(fullfile(pathname,'OutT2 Off.mat'));
        ch3 = load(fullfile(pathname,'Success.mat'));
        ch4 = load(fullfile(pathname,'Field 1 (OB)'));
        if(exist(fullfile(pathname,'Stim pulse.mat'),'file'))
            ch5 = load(fullfile(pathname,'Stim pulse.mat'));
        else
            ch5 = ch1;
            ch5.Data    = [];
        end

        Y1  = makeIntervalChannel('Trial Interval','timestamp pairs',ch1,ch2);
        if(size(Y1.Data,2)==1)                        %  最初と最後のトライアルを捨てる(PSTHやWCOHをする際のマージンをとっておくため)
            Y1.Data(:,1)=[];
        elseif(size(Y1.Data,2)>1)
            Y1.Data(:,end)=[];
            Y1.Data(:,1)=[];
        end

        Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y1, ch3, -1);
        Y3  = filterIntervalChannel('Trial Interval (success valid)', '~timestamp occurred', Y2, ch4);
        Y4  = filterIntervalChannel('Trial Interval (svwostim)', '~timestamp occurred', Y3, ch5);

        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
        save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
        save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
        clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
        %pack;
    end

    % Field 2 (OB) Only
    if(~exist(fullfile(pathname,'Field 1.mat'),'file') && exist(fullfile(pathname,'Field 2.mat'),'file'))

        ch1 = load(fullfile(pathname,'OutT1 On.mat'));
        ch2 = load(fullfile(pathname,'OutT2 Off.mat'));
        ch3 = load(fullfile(pathname,'Success.mat'));
        ch4 = load(fullfile(pathname,'Field 2 (OB)'));
        if(exist(fullfile(pathname,'Stim pulse.mat'),'file'))
            ch5 = load(fullfile(pathname,'Stim pulse.mat'));
        else
            ch5 = ch1;
            ch5.Data    = [];
        end

        Y1  = makeIntervalChannel('Trial Interval','timestamp pairs',ch1,ch2);
        if(size(Y1.Data,2)==1)                        %  最初と最後のトライアルを捨てる(PSTHやWCOHをする際のマージンをとっておくため)
            Y1.Data(:,1)=[];
        elseif(size(Y1.Data,2)>1)
            Y1.Data(:,end)=[];
            Y1.Data(:,1)=[];
        end

        Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y1, ch3, -1);
        Y3  = filterIntervalChannel('Trial Interval (success valid)', '~timestamp occurred', Y2, ch4);
        Y4  = filterIntervalChannel('Trial Interval (svwostim)', '~timestamp occurred', Y3, ch5);

        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
        save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
        save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
        clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
        %pack;
    end

    % Field 1 (OB) & Field 2 (OB)
    if(exist(fullfile(pathname,'Field 1.mat'),'file') && exist(fullfile(pathname,'Field 2.mat'),'file'))

        ch1 = load(fullfile(pathname,'OutT1 On.mat'));
        ch2 = load(fullfile(pathname,'OutT2 Off.mat'));
        ch3 = load(fullfile(pathname,'Success.mat'));
        ch41 = load(fullfile(pathname,'Field 1 (OB)'));
        ch42 = load(fullfile(pathname,'Field 2 (OB)'));
        if(exist(fullfile(pathname,'Stim pulse.mat'),'file'))
            ch5 = load(fullfile(pathname,'Stim pulse.mat'));
        else
            ch5 = ch1;
            ch5.Data    = [];
        end

        Y1  = makeIntervalChannel('Trial Interval','timestamp pairs',ch1,ch2);
        if(size(Y1.Data,2)==1)                        %  最初と最後のトライアルを捨てる(PSTHやWCOHをする際のマージンをとっておくため)
            Y1.Data(:,1)=[];
        elseif(size(Y1.Data,2)>1)
            Y1.Data(:,end)=[];
            Y1.Data(:,1)=[];
        end

        Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y1, ch3, -1);
        Y3  = filterIntervalChannel('Trial Interval (success valid)', '~timestamp occurred', Y2, ch41);
        Y3  = filterIntervalChannel('Trial Interval (success valid)', '~timestamp occurred', Y3, ch42);
        Y4  = filterIntervalChannel('Trial Interval (svwostim)', '~timestamp occurred', Y3, ch5);

        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
        save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
        save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
        clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
        %pack;
    end
end
%% 5
% Grip Onset
% Grip Onset detector
% Grip Onset candidate 0 1 2 3 4
% Grip Onset (success)
% Grip Onset (success valid)
% Grip Onset (svwostim)

if(any(ismember(5,processID)))
    disp('5')
    % th1 = 0.3;        % N
    th2 = 2;        % Nps

    % ch1 = load(fullfile(pathname,'Total Torque(N)'));
    ch2 = load(fullfile(pathname,'Total deriv Torque(Nps)'));
    ch3 = load(fullfile(pathname,'CentT Enter On'));
    % ch4 = load(fullfile(pathname,'OutT1 Off'));
    ch5 = load(fullfile(pathname,'Trial Interval'));
    ch6 = load(fullfile(pathname,'Trial Interval (success)'));
    ch7 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch8 = load(fullfile(pathname,'Trial Interval (svwostim)'));


    % T1  = makeTimestampChannel('Grip Onset detector', 'rising threshold', ch1, th1); % detector
    % save(fullfile(pathname,T1.Name,'.mat']),'-struct','T1');
    T2  = makeTimestampChannel('Grip Onset candidate0', 'rising threshold', ch2, th2); % candidate0
%     save(fullfile(pathname,T2.Name,'.mat']),'-struct','T2');
    % T2  = filterTimestampChannel('Grip Onset candidate1', 'timestamp occurred', T2, T1, [-0.5 0.5]);   % candidate1 detectorが近くにあるものだけ
    % save(fullfile(pathname,T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Grip Onset candidate3', 'timestamp occurred', T2, ch3, [-0.5 1.0]);  % candidate3　CentT Enter Onが近くにあるものだけ
%     save(fullfile(pathname,T2.Name,'.mat']),'-struct','T2');

    T2  = filterTimestampChannel('Grip Onset candidate2', '~timestamp occurred', T2, T2, [-1.0 -0.001]);   % candidate2  直前にほかのcandidateがないものだけ
%     save(fullfile(pathname,T2.Name,'.mat']),'-struct','T2');
    % T2  = filterTimestampChannel('Grip Onset candidate4', 'timestamp occurred', T2, ch4, [-1.25 0.5]);  % candidate3　Out1 Offが近くにあるものだけ
    % save(fullfile(pathname,T2.Name,'.mat']),'-struct','T2');

    Y1  = filterTimestampChannel('Grip Onset', 'within interval', T2, ch5);
    Y1  = filterTimestampChannel('Grip Onset', '~timestamp occurred', Y1, Y1, [-3 -0.001]);   % within interval filterをかけた後もう一度直前にほかのcandidateがないものだけ＝各トライアル中には１つのtimestampだけにする。
    Y2  = filterTimestampChannel('Grip Onset (success)', 'within interval', Y1, ch6);
    Y3  = filterTimestampChannel('Grip Onset (success valid)', 'within interval', Y1, ch7);
    Y4  = filterTimestampChannel('Grip Onset (svwostim)', 'within interval', Y1, ch8);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    % clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T1','T2','Y1','Y2','Y3','Y4');
    clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T2','Y1','Y2','Y3','Y4');
    % %pack;
end
%% 6
% Release Onset
% Release Onset (success)
% Release Onset (success valid)
% Release Onset (svwostim)

if(any(ismember(6,processID)))
    disp('6')
    ch1 = load(fullfile(pathname,'Total deriv Torque(Nps)'));
    ch2 = load(fullfile(pathname,'OutT2 Enter On'));
    ch3 = load(fullfile(pathname,'CentT Off'));

    ch4 = load(fullfile(pathname,'Trial Interval'));
    ch5 = load(fullfile(pathname,'Trial Interval (success)'));
    ch6 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch7 = load(fullfile(pathname,'Trial Interval (svwostim)'));

    th1 = -2;         % Nps


    T2  = makeTimestampChannel('Release Onset candidate0', 'falling threshold', ch1, th1); % candidate0
%     save(fullfile(pathname,T2.Name,'.mat']),'-struct','T2');

    T2  = filterTimestampChannel('Release Onset candidate1', 'timestamp occurred', T2, ch2, [-0.5 1.0]);  % candidate3　OutT2 Enter Onが直後にあるものだけ
%     save(fullfile(pathname,T2.Name,'.mat']),'-struct','T2');

    T2  = filterTimestampChannel('Release Onset candidate2', '~timestamp occurred', T2, T2, [-1.0 -0.001]);   % candidate2  直前にほかのcandidateがないものだけ
%     save(fullfile(pathname,T2.Name,'.mat']),'-struct','T2');

    %     T2  = filterTimestampChannel('Release Onset candidate3', 'timestamp occurred', T2, ch3, [-1.25 0.5]);  % candidate3　Out1 Offが近くにあるものだけ
    %     save(fullfile(pathname,T2.Name,'.mat']),'-struct','T2');

    Y1  = filterTimestampChannel('Release Onset', 'within interval', T2, ch4);
    Y1  = filterTimestampChannel('Release Onset', '~timestamp occurred', Y1, Y1, [-3 -0.001]);   % within interval filterをかけた後もう一度直前にほかのcandidateがないものだけ
    Y2  = filterTimestampChannel('Release Onset (success)', 'within interval', Y1, ch5);
    Y3  = filterTimestampChannel('Release Onset (success valid)', 'within interval', Y1, ch6);
    Y4  = filterTimestampChannel('Release Onset (svwostim)', 'within interval', Y1, ch7);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','th1','T2','Y1','Y2','Y3','Y4');
    % %pack;
end
%% 7
% !!!!!!again!!!!!!
% Trial Interval	!!!!!!again!!!!!!
% Trial Interval (success)	!!!!!!again!!!!!!
% Trial Interval (success valid)	!!!!!!again!!!!!!
% Trial Interval (svwostim)	!!!!!!again!!!!!!

% Grip Onset!!!!!!again!!!!!!
% Grip Onset (success)!!!!!!again!!!!!!
% Grip Onset (success valid)!!!!!!again!!!!!!
% Grip Onset (svwostim)!!!!!!again!!!!!!

% Release Onset!!!!!!again!!!!!!
% Release Onset (success)!!!!!!again!!!!!!
% Release Onset (success valid)!!!!!!again!!!!!!
% Release Onset (svwostim)!!!!!!again!!!!!!

if(any(ismember(7,processID)))
    disp('7')
    ch1 = load(fullfile(pathname,'Grip Onset'));
    ch2 = load(fullfile(pathname,'Grip Onset (success)'));
    ch3 = load(fullfile(pathname,'Grip Onset (success valid)'));
    ch4 = load(fullfile(pathname,'Grip Onset (svwostim)'));

    ch5 = load(fullfile(pathname,'Release Onset'));
    ch6 = load(fullfile(pathname,'Release Onset (success)'));
    ch7 = load(fullfile(pathname,'Release Onset (success valid)'));
    ch8 = load(fullfile(pathname,'Release Onset (svwostim)'));

    ch9  = load(fullfile(pathname,'Trial Interval'));
    ch10 = load(fullfile(pathname,'Trial Interval (success)'));
    ch11 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch12 = load(fullfile(pathname,'Trial Interval (svwostim)'));


    Y9  = filterIntervalChannel('Trial Interval', 'timestamp occurred', ch9, ch1);
    Y9  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y9, ch5);
    Y10 = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', ch10, ch2);
    Y10 = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y10, ch6);
    Y11 = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', ch11, ch3);
    Y11 = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y11, ch7);
    Y12 = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', ch12, ch4);
    Y12 = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y12, ch8);

    Y1  = filterTimestampChannel('Grip Onset', 'within interval', ch1, Y9);
    Y2  = filterTimestampChannel('Grip Onset (success)', 'within interval', ch2, Y10);
    Y3  = filterTimestampChannel('Grip Onset (success valid)', 'within interval', ch3, Y11);
    Y4  = filterTimestampChannel('Grip Onset (svwostim)', 'within interval', ch4, Y12);

    Y5  = filterTimestampChannel('Release Onset', 'within interval', ch5, Y9);
    Y6  = filterTimestampChannel('Release Onset (success)', 'within interval', ch6, Y10);
    Y7  = filterTimestampChannel('Release Onset (success valid)', 'within interval', ch7, Y11);
    Y8  = filterTimestampChannel('Release Onset (svwostim)', 'within interval', ch8, Y12);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    save(fullfile(pathname,[Y5.Name,'.mat']),'-struct','Y5');disp(fullfile(pathname,Y5.Name));
    save(fullfile(pathname,[Y6.Name,'.mat']),'-struct','Y6');disp(fullfile(pathname,Y6.Name));
    save(fullfile(pathname,[Y7.Name,'.mat']),'-struct','Y7');disp(fullfile(pathname,Y7.Name));
    save(fullfile(pathname,[Y8.Name,'.mat']),'-struct','Y8');disp(fullfile(pathname,Y8.Name));
    save(fullfile(pathname,[Y9.Name,'.mat']),'-struct','Y9');disp(fullfile(pathname,Y9.Name));
    save(fullfile(pathname,[Y10.Name,'.mat']),'-struct','Y10');disp(fullfile(pathname,Y10.Name));
    save(fullfile(pathname,[Y11.Name,'.mat']),'-struct','Y11');disp(fullfile(pathname,Y11.Name));
    save(fullfile(pathname,[Y12.Name,'.mat']),'-struct','Y12');disp(fullfile(pathname,Y12.Name));
    
    
    nDataY1 = size(Y12.Data,2);
    nDataY2 = length(Y4.Data);
    nDataY3 = length(Y8.Data);
    
    if(nDataY1==nDataY2 && nDataY1==nDataY3)
        display('Trial Interval, Grip Onset, Release Onsetは同じデータ数になっていますOK！！')
    else
        display('******** caution！！！！！！　Trial Interval(',num2str(nDataY1),'), Grip Onset(',num2str(nDataY2),'), Release Onset(',num2str(nDataY3),')は同じデータ数になってません　caution！！！！！！')
    end

    clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','ch9','ch10','ch11','ch12''Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','Y11','Y12');
    % %pack;
end
%% 8
% Trial Start
% Trial Start (success)
% Trial Start (success valid)
% Trial Start (svwostim)

if(any(ismember(8,processID)))
    disp('8')
    ch1 = load(fullfile(pathname,'OutT1 Enter On'));
    

    ch2 = load(fullfile(pathname,'Trial Interval'));
    ch3 = load(fullfile(pathname,'Trial Interval (success)'));
    ch4 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch5 = load(fullfile(pathname,'Trial Interval (svwostim)'));
    
    ch0 = load(fullfile(pathname,'OutT1 On'));
    ch1 = filterTimestampChannel(ch1.Name,'timestamp occurred',ch1,ch0,[-1.0 0.1]);
    Y1  = filterTimestampChannel('Trial Start', 'within interval', ch1, ch2);
    Y2  = filterTimestampChannel('Trial Start (success)', 'within interval', ch1, ch3);
    Y3  = filterTimestampChannel('Trial Start (success valid)', 'within interval', ch1, ch4);
    Y4  = filterTimestampChannel('Trial Start (svwostim)', 'within interval', ch1, ch5);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    clear('ch0','ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    % %pack;
end
%% 9
% Go Onset
% Go Onset (success)
% Go Onset (success valid)
% Go Onset (svwostim)

if(any(ismember(9,processID)))
    disp('9')
    ch1 = load(fullfile(pathname,'CentT On'));

    ch2 = load(fullfile(pathname,'Trial Interval'));
    ch3 = load(fullfile(pathname,'Trial Interval (success)'));
    ch4 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch5 = load(fullfile(pathname,'Trial Interval (svwostim)'));

    Y1  = filterTimestampChannel('Go Onset', 'within interval', ch1, ch2);
    Y2  = filterTimestampChannel('Go Onset (success)', 'within interval', ch1, ch3);
    Y3  = filterTimestampChannel('Go Onset (success valid)', 'within interval', ch1, ch4);
    Y4  = filterTimestampChannel('Go Onset (svwostim)', 'within interval', ch1, ch5);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    % %pack;
end
%% 10
% EndHold
% EndHold (success)
% EndHold (success valid)
% EndHold (svwostim)

if(any(ismember(10,processID)))
    disp('10')
    ch1 = load(fullfile(pathname,'CentT Off'));

    ch2 = load(fullfile(pathname,'Trial Interval'));
    ch3 = load(fullfile(pathname,'Trial Interval (success)'));
    ch4 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch5 = load(fullfile(pathname,'Trial Interval (svwostim)'));

    Y1  = filterTimestampChannel('EndHold', 'within interval', ch1, ch2);
    Y2  = filterTimestampChannel('EndHold (success)', 'within interval', ch1, ch3);
    Y3  = filterTimestampChannel('EndHold (success valid)', 'within interval', ch1, ch4);
    Y4  = filterTimestampChannel('EndHold (svwostim)', 'within interval', ch1, ch5);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    % %pack;
end


%% 11
% !!!!!!タスクイベントの個数をそろえる重要!!!!!!
% Trial Interval	!!!!!!again!!!!!!
% Trial Interval (success)	!!!!!!again!!!!!!
% Trial Interval (success valid)	!!!!!!again!!!!!!
% Trial Interval (svwostim)	!!!!!!again!!!!!!

% Grip Onset!!!!!!again!!!!!!
% Grip Onset (success)!!!!!!again!!!!!!
% Grip Onset (success valid)!!!!!!again!!!!!!
% Grip Onset (svwostim)!!!!!!again!!!!!!

% Release Onset!!!!!!again!!!!!!
% Release Onset (success)!!!!!!again!!!!!!
% Release Onset (success valid)!!!!!!again!!!!!!
% Release Onset (svwostim)!!!!!!again!!!!!!

% Trial Interval	!!!!!!again!!!!!!
% Trial Interval (success)	!!!!!!again!!!!!!
% Trial Interval (success valid)	!!!!!!again!!!!!!
% Trial Interval (svwostim)	!!!!!!again!!!!!!

% Grip Onset!!!!!!again!!!!!!
% Grip Onset (success)!!!!!!again!!!!!!
% Grip Onset (success valid)!!!!!!again!!!!!!
% Grip Onset (svwostim)!!!!!!again!!!!!!

% Release Onset!!!!!!again!!!!!!
% Release Onset (success)!!!!!!again!!!!!!
% Release Onset (success valid)!!!!!!again!!!!!!
% Release Onset (svwostim)!!!!!!again!!!!!!

if(any(ismember(11,processID)))
    disp('11')
    a1 = load(fullfile(pathname,'Grip Onset'));
    a2 = load(fullfile(pathname,'Grip Onset (success)'));
    a3 = load(fullfile(pathname,'Grip Onset (success valid)'));
    a4 = load(fullfile(pathname,'Grip Onset (svwostim)'));

    b1 = load(fullfile(pathname,'Release Onset'));
    b2 = load(fullfile(pathname,'Release Onset (success)'));
    b3 = load(fullfile(pathname,'Release Onset (success valid)'));
    b4 = load(fullfile(pathname,'Release Onset (svwostim)'));

    c1 = load(fullfile(pathname,'Trial Start'));
    c2 = load(fullfile(pathname,'Trial Start (success)'));
    c3 = load(fullfile(pathname,'Trial Start (success valid)'));
    c4 = load(fullfile(pathname,'Trial Start (svwostim)'));
    
    d1 = load(fullfile(pathname,'Go Onset'));
    d2 = load(fullfile(pathname,'Go Onset (success)'));
    d3 = load(fullfile(pathname,'Go Onset (success valid)'));
    d4 = load(fullfile(pathname,'Go Onset (svwostim)'));
    
    e1 = load(fullfile(pathname,'EndHold'));
    e2 = load(fullfile(pathname,'EndHold (success)'));
    e3 = load(fullfile(pathname,'EndHold (success valid)'));
    e4 = load(fullfile(pathname,'EndHold (svwostim)'));
    
    Y1 = load(fullfile(pathname,'Trial Interval'));
    Y2 = load(fullfile(pathname,'Trial Interval (success)'));
    Y3 = load(fullfile(pathname,'Trial Interval (success valid)'));
    Y4 = load(fullfile(pathname,'Trial Interval (svwostim)'));


    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, a1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, b1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, c1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, d1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, e1);

    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, a2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, b2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, c2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, d2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, e2);

    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, a3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, b3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, c3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, d3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, e3);

    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, a4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, b4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, c4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, d4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, e4);
    
    
    a1  = filterTimestampChannel(a1.Name, 'within interval exclusive',a1, Y1);
    a2  = filterTimestampChannel(a2.Name, 'within interval exclusive',a2, Y2);
    a3  = filterTimestampChannel(a3.Name, 'within interval exclusive',a3, Y3);
    a4  = filterTimestampChannel(a4.Name, 'within interval exclusive',a4, Y4);
    
    b1  = filterTimestampChannel(b1.Name, 'within interval exclusive',b1, Y1);
    b2  = filterTimestampChannel(b2.Name, 'within interval exclusive',b2, Y2);
    b3  = filterTimestampChannel(b3.Name, 'within interval exclusive',b3, Y3);
    b4  = filterTimestampChannel(b4.Name, 'within interval exclusive',b4, Y4);
    
    c1  = filterTimestampChannel(c1.Name, 'within interval exclusive',c1, Y1);
    c2  = filterTimestampChannel(c2.Name, 'within interval exclusive',c2, Y2);
    c3  = filterTimestampChannel(c3.Name, 'within interval exclusive',c3, Y3);
    c4  = filterTimestampChannel(c4.Name, 'within interval exclusive',c4, Y4);
    
    d1  = filterTimestampChannel(d1.Name, 'within interval exclusive',d1, Y1);
    d2  = filterTimestampChannel(d2.Name, 'within interval exclusive',d2, Y2);
    d3  = filterTimestampChannel(d3.Name, 'within interval exclusive',d3, Y3);
    d4  = filterTimestampChannel(d4.Name, 'within interval exclusive',d4, Y4);
    
    e1  = filterTimestampChannel(e1.Name, 'within interval exclusive',e1, Y1);
    e2  = filterTimestampChannel(e2.Name, 'within interval exclusive',e2, Y2);
    e3  = filterTimestampChannel(e3.Name, 'within interval exclusive',e3, Y3);
    e4  = filterTimestampChannel(e4.Name, 'within interval exclusive',e4, Y4);
    
    
    save(fullfile(pathname,[a1.Name,'.mat']),'-struct','a1');%disp(fullfile(pathname,a1.Name));
    save(fullfile(pathname,[a2.Name,'.mat']),'-struct','a2');%disp(fullfile(pathname,a2.Name));
    save(fullfile(pathname,[a3.Name,'.mat']),'-struct','a3');%disp(fullfile(pathname,a3.Name));
    save(fullfile(pathname,[a4.Name,'.mat']),'-struct','a4');%disp(fullfile(pathname,a4.Name));
    
    save(fullfile(pathname,[b1.Name,'.mat']),'-struct','b1');%disp(fullfile(pathname,b1.Name));
    save(fullfile(pathname,[b2.Name,'.mat']),'-struct','b2');%disp(fullfile(pathname,b2.Name));
    save(fullfile(pathname,[b3.Name,'.mat']),'-struct','b3');%disp(fullfile(pathname,b3.Name));
    save(fullfile(pathname,[b4.Name,'.mat']),'-struct','b4');%disp(fullfile(pathname,b4.Name));
    
    save(fullfile(pathname,[c1.Name,'.mat']),'-struct','c1');%disp(fullfile(pathname,c1.Name));
    save(fullfile(pathname,[c2.Name,'.mat']),'-struct','c2');%disp(fullfile(pathname,c2.Name));
    save(fullfile(pathname,[c3.Name,'.mat']),'-struct','c3');%disp(fullfile(pathname,c3.Name));
    save(fullfile(pathname,[c4.Name,'.mat']),'-struct','c4');%disp(fullfile(pathname,c4.Name));
    
    save(fullfile(pathname,[d1.Name,'.mat']),'-struct','d1');%disp(fullfile(pathname,d1.Name));
    save(fullfile(pathname,[d2.Name,'.mat']),'-struct','d2');%disp(fullfile(pathname,d2.Name));
    save(fullfile(pathname,[d3.Name,'.mat']),'-struct','d3');%disp(fullfile(pathname,d3.Name));
    save(fullfile(pathname,[d4.Name,'.mat']),'-struct','d4');%disp(fullfile(pathname,d4.Name));
    
    save(fullfile(pathname,[e1.Name,'.mat']),'-struct','e1');%disp(fullfile(pathname,e1.Name));
    save(fullfile(pathname,[e2.Name,'.mat']),'-struct','e2');%disp(fullfile(pathname,e2.Name));
    save(fullfile(pathname,[e3.Name,'.mat']),'-struct','e3');%disp(fullfile(pathname,e3.Name));
    save(fullfile(pathname,[e4.Name,'.mat']),'-struct','e4');%disp(fullfile(pathname,e4.Name));
    
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));
    
    
    if(size(a1.Data,2)==size(b1.Data,2) && size(a1.Data,2)==size(c1.Data,2) && size(a1.Data,2)==size(d1.Data,2) && size(a1.Data,2)==size(e1.Data,2) && size(a1.Data,2)==size(Y1.Data,2))
        display(['                                                                               同じデータ数になっています------OK(',num2str(size(Y1.Data,2)),')'])
    else
        display('**** error                                                                               同じデータ数になっていません------Caution！！！！！')
    end
    
    

    clear('a1','a2','a3','a4','b1','b2','b3','b4','c1','c2','c3','c4','d1','d2','d3','d4','e1','e2','e3','e4','Y1','Y2','Y3','Y4');
    % %pack;
end
























%% 101
% Index Position(mm)
% Thumb Position(mm)


if(any(ismember(101,processID)))
    disp('101')
    % load
    ch1 = load(fullfile(pathname,'smoothed index(mm).mat'));
    ch2 = load(fullfile(pathname,'smoothed thumb(mm).mat'));

    % parameter
    SampleRate  = ch1.SampleRate;
    TimeRange   = ch1.TimeRange;
    nData       = length(ch1.Data);

    % Header
    Y1.TimeRange    = TimeRange;
    Y1.Name         = 'Index Position(mm)';
    Y1.Class        = 'continuous channel';
    Y1.SampleRate   = SampleRate;
    Y1.Unit         = 'mm';
    Y1.Data         = ch1.Data;

    Y2.TimeRange    = TimeRange;
    Y2.Name         = 'Thumb Position(mm)';
    Y2.Class        = 'continuous channel';
    Y2.SampleRate   = SampleRate;
    Y2.Unit         = 'mm';
    Y2.Data         = ch2.Data;
    
    % Data
%     % detrend
%     bpw     = SampleRate*300;       % 5分間のデータの長さ
%     if(nData >= bpw)                    % detrend bpをやるにたる長さがあるときだけ
%         nbp     = floor(nData/bpw);
%         bpind   = repmat([-1,0],nbp,1)+repmat([1:nbp]',1,2);
%         bpind(:,1)  = bpind(:,1)*bpw+1;
%         bpind(:,2)  = bpind(:,2)*bpw;
%         if(nData - nbp*bpw>=2)
%             bpind    = [bpind;[nbp*bpw+1,nData]];
%             nbp  = nbp+1;
%         end
%         for ibp =1:nbp
%             ind  = [bpind(ibp,1):bpind(ibp,2)];
%             Y1.Data(ind) = detrend(Y1.Data(ind),'linear');
%             Y2.Data(ind) = detrend(Y2.Data(ind),'linear');
%         end
%     else
%         Y1.Data = detrend(Y1.Data,'linear');
%         Y2.Data = detrend(Y2.Data,'linear');
%     end
%         
    % zero offset
    Y1.Data = Y1.Data - mean(Y1.Data(Y1.Data<prctile(Y1.Data,50)));
    Y2.Data = Y2.Data - mean(Y2.Data(Y2.Data<prctile(Y2.Data,50)));

    % save
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));

    % clear
    clear('ch1','ch2','Y1','Y2');
    %pack;
end
%% 102
% Index Torque(N)
% Thumb Torque(N)
% Total Torque(N)
% Total deriv Torque(Nps)

if(any(ismember(102,processID)))
    disp('102')
    % load
    ch1 = load(fullfile(pathname,'smoothed Index Torque(N).mat'));
    ch2 = load(fullfile(pathname,'smoothed Thumb Torque(N).mat'));

    % parameter
    SampleRate  = ch1.SampleRate;
    TimeRange   = ch1.TimeRange;
    nData       = length(ch1.Data);

    % Header
    Y1.TimeRange    = TimeRange;
    Y1.Name         = 'Index Torque(N)';
    Y1.Class        = 'continuous channel';
    Y1.SampleRate   = SampleRate;
    Y1.Unit         = 'N';
    Y1.Data         = ch1.Data;

    Y2.TimeRange    = TimeRange;
    Y2.Name         = 'Thumb Torque(N)';
    Y2.Class        = 'continuous channel';
    Y2.SampleRate   = SampleRate;
    Y2.Unit         = 'N';
    Y2.Data         = ch2.Data;

    Y3.TimeRange    = TimeRange;
    Y3.Name         = 'Total Torque(N)';
    Y3.Class        = 'continuous channel';
    Y3.SampleRate   = SampleRate;
    Y3.Unit         = 'N';

    Y4.TimeRange    = TimeRange;
    Y4.Name         = 'Index deriv Torque(Nps)';
    Y4.Class        = 'continuous channel';
    Y4.SampleRate   = SampleRate;
    Y4.Unit         = 'Nps';
    
    Y5.TimeRange    = TimeRange;
    Y5.Name         = 'Thumb deriv Torque(Nps)';
    Y5.Class        = 'continuous channel';
    Y5.SampleRate   = SampleRate;
    Y5.Unit         = 'Nps';
    
    Y6.TimeRange    = TimeRange;
    Y6.Name         = 'Total deriv Torque(Nps)';
    Y6.Class        = 'continuous channel';
    Y6.SampleRate   = SampleRate;
    Y6.Unit         = 'Nps';
    

    % Data
%     % detrend
%     bpw     = SampleRate*300;       % 5分間のデータの長さ
%     if(nData >= bpw)                    % detrend bpをやるにたる長さがあるときだけ
%         nbp     = floor(nData/bpw);
%         bpind   = repmat([-1,0],nbp,1)+repmat([1:nbp]',1,2);
%         bpind(:,1)  = bpind(:,1)*bpw+1;
%         bpind(:,2)  = bpind(:,2)*bpw;
%         if(nData - nbp*bpw>=2)
%             bpind    = [bpind;[nbp*bpw+1,nData]];
%             nbp  = nbp+1;
%         end
%         for ibp =1:nbp
%             ind  = [bpind(ibp,1):bpind(ibp,2)];
%             Y1.Data(ind) = detrend(Y1.Data(ind),'linear');
%             Y2.Data(ind) = detrend(Y2.Data(ind),'linear');
%         end
%     else
%         Y1.Data = detrend(Y1.Data,'linear');
%         Y2.Data = detrend(Y2.Data,'linear');
%     end
    
    % zero offset
    Y1.Data = Y1.Data - mean(Y1.Data(Y1.Data<prctile(Y1.Data,50)));
    Y2.Data = Y2.Data - mean(Y2.Data(Y2.Data<prctile(Y2.Data,50)));

    % sum and diff
    Y3.Data	= Y1.Data + Y2.Data;
    Y4.Data = [0 diff(Y1.Data)] * SampleRate;
    Y5.Data = [0 diff(Y2.Data)] * SampleRate;
    Y6.Data = [0 diff(Y3.Data)] * SampleRate;


    % save
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    save(fullfile(pathname,[Y5.Name,'.mat']),'-struct','Y5');disp(fullfile(pathname,Y5.Name));
    save(fullfile(pathname,[Y6.Name,'.mat']),'-struct','Y6');disp(fullfile(pathname,Y6.Name));
    
%     % [positive],[negative],[abs]
%     Y7         = Y4;
%     Y7.Name    = [Y4.Name,'[positive]'];
%     Y7.Data    = zeromask(Y7.Data,Y7.Data>0);
%     save(fullfile(pathname,[Y7.Name,'.mat']),'-struct','Y7');disp(fullfile(pathname,Y7.Name));
%     
%     Y7         = Y4;
%     Y7.Name    = [Y4.Name,'[negative]'];
%     Y7.Data    = zeromask(Y7.Data,Y7.Data<0);
%     save(fullfile(pathname,[Y7.Name,'.mat']),'-struct','Y7');disp(fullfile(pathname,Y7.Name));
%     
    Y7         = Y6;
    Y7.Name    = [Y7.Name,'[abs]'];
    Y7.Data    = abs(Y7.Data);
    save(fullfile(pathname,[Y7.Name,'.mat']),'-struct','Y7');disp(fullfile(pathname,Y7.Name));

    % clear
    clear('ch*','Y*');
    %pack;
end
%% 103
% % Trial Interval
% % Trial Interval (success)
% % Trial Interval (success valid)
% % Trial Interval (svwostim)

if(any(ismember(103,processID)))
    disp('103')
    nsd = 2;    % Trial Interval内のスパイク数がmean+_nsdより外れているものはinvalidとして排除する。
    
    ch1 = load(fullfile(pathname,'OutT1 On.mat'));
    ch2 = load(fullfile(pathname,'OutT2 Off.mat'));
    ch3 = load(fullfile(pathname,'Success.mat'));
%     ch4 = load(fullfile(pathname,'Spike.mat'));
    if(exist(fullfile(pathname,'Spike.mat'),'file'))
        ch4 = load(fullfile(pathname,'Spike.mat'));
    else
        ch4 = ch1;
        ch4.Data    = [0:(ch4.TimeRange(2)-ch4.TimeRange(1))]*ch4.SampleRate;
    end
    if(exist(fullfile(pathname,'Stim pulse.mat'),'file'))
        ch5 = load(fullfile(pathname,'Stim pulse.mat'));
    else
        ch5 = ch1;
        ch5.Data    = [];
    end
    
    Y1  = makeIntervalChannel('Trial Interval','timestamp pairs',ch1,ch2);
    if(size(Y1.Data,2)==1)                        %  最初と最後のトライアルを捨てる(PSTHやWCOHをする際のマージンをとっておくため)
        Y1.Data(:,1)=[];
    elseif(size(Y1.Data,2)>1)
        Y1.Data(:,end)=[];
        Y1.Data(:,1)=[];
    end
    
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y1, ch3, -1);
    Y3  = filterIntervalChannel('Trial Interval (success isspike)', 'timestamp occurred', Y2, ch4);
    nTrials = size(Y3.Data,2);

    FR     = zeros(1,nTrials);
    SpikeSec    = ch4.Data ./ ch4.SampleRate;
    for iTrial=1:nTrials
        FR(iTrial) = sum(SpikeSec>=Y3.Data(1,iTrial)&SpikeSec<=Y3.Data(2,iTrial))./(Y3.Data(2,iTrial)-Y3.Data(1,iTrial));
    end
    meanFR  = mean(FR);
    sdFR    = std(FR);
    add_flag    = FR>=(meanFR-nsd*sdFR) & FR<=(meanFR+nsd*sdFR);

    Y4  = Y3;
    Y4.Name = 'Trial Interval (success valid)';
    Y4.Data = Y4.Data(:,add_flag); 
    disp(['success valid: ',num2str(sum(~add_flag)),'/',num2str(nTrials),' trials were excluced for invalid firing']);
    
    invalidfiles    = sortxls(strfilt(dirmat(pathname),'Invalid Interval'));

    if(~isempty(invalidfiles))
        ninvalid    = length(invalidfiles);
        for iinvalid=1:ninvalid
            invalidfile = invalidfiles{iinvalid};
            ch6 = load(fullfile(pathname,invalidfile));
            Y4  = filterIntervalChannel(Y4.Name, '~interval occurred', Y4, ch6);
            disp(['Invalid Interval was used:   ',invalidfile])
        end
    end
    
    
    Y5  = filterIntervalChannel('Trial Interval (svwostim)', '~timestamp occurred', Y4, ch5);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    save(fullfile(pathname,[Y5.Name,'.mat']),'-struct','Y5');disp(fullfile(pathname,Y5.Name));
    clear('ch1','ch2','ch3','ch4','ch5','ch6','Y1','Y2','Y3','Y4','Y5');
    %pack;
end
%% 104
% Grip Onset
% Grip Onset detector
% Grip Onset candidate 0 1 2 3 4
% Grip Onset (success)
% Grip Onset (success valid)
% Grip Onset (svwostim)

if(any(ismember(104,processID)))
    disp('104')
    th1 = 0.5;        % N
    th2 = 2;          % Nps

    ch1 = load(fullfile(pathname,'Total Torque(N)'));
    ch2 = load(fullfile(pathname,'Total deriv Torque(Nps)'));
    ch3 = load(fullfile(pathname,'CentT Enter On'));
    % ch4 = load(fullfile(pathname,'OutT1 Off'));
    ch5 = load(fullfile(pathname,'Trial Interval'));
    ch6 = load(fullfile(pathname,'Trial Interval (success)'));
    ch7 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch8 = load(fullfile(pathname,'Trial Interval (svwostim)'));
    
    th1 = mean(ch1.Data(ch1.Data>=prctile(ch1.Data,50)))*0.80;
    disp(['th1=',num2str(th1,'%.2g')])

    T1  = makeTimestampChannel('Grip Onset detector', 'rising threshold', ch1, th1); % detector
    save(fullfile(pathname,[T1.Name,'.mat']),'-struct','T1');
    T1  = filterTimestampChannel('Grip Onset detector1', 'signal stays high', T1, ch1, [0.001 1], th1); % detector1
    save(fullfile(pathname,[T1.Name,'.mat']),'-struct','T1');
    T1  = filterTimestampChannel('Grip Onset detector2', 'signal stays low', T1, ch1, [-1 -0.001], th1); % detector2
    save(fullfile(pathname,[T1.Name,'.mat']),'-struct','T1');
    
    T2  = makeTimestampChannel('Grip Onset candidate0', 'rising threshold', ch2, th2); % candidate0
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Grip Onset candidate1', 'timestamp occurred', T2, T1, [0 0.5]);   % candidate1 detectorの直前にあるものだけ
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Grip Onset candidate2', 'nearest', T2, T1);                           % candidate2  detectorの直近にあるもの
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Grip Onset candidate3', 'timestamp occurred', T2, ch3, [-0.5 1.0]);  % candidate3　CentT Enter Onが近くにあるものだけ
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Grip Onset candidate4', 'signal stays low', T2, ch1, [-1 -0.5], th1);% 直前（control period）にTorqueが０に近い値をとっているもの
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    
%     T2  = filterTimestampChannel('Grip Onset candidate2', '~timestamp occurred', T2, T2, [-1.0 -0.001]);   % candidate3  直前にほかのcandidateがないものだけ
    
    % T2  = filterTimestampChannel('Grip Onset candidate4', 'timestamp occurred', T2, ch4, [-1.25 0.5]);  % candidate3　Out1 Offが近くにあるものだけ
    % save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');

    Y1  = filterTimestampChannel('Grip Onset', 'within interval', T2, ch5);
    Y1  = filterTimestampChannel('Grip Onset', '~timestamp occurred', Y1, Y1, [-3 -0.001]);   % within interval filterをかけた後もう一度直前にほかのcandidateがないものだけ＝各トライアル中には１つのtimestampだけにする。
    Y2  = filterTimestampChannel('Grip Onset (success)', 'within interval', Y1, ch6);
    Y3  = filterTimestampChannel('Grip Onset (success valid)', 'within interval', Y1, ch7);
    Y4  = filterTimestampChannel('Grip Onset (svwostim)', 'within interval', Y1, ch8);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    % clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T1','T2','Y1','Y2','Y3','Y4');
    clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T2','Y1','Y2','Y3','Y4');
    % %pack;
end


%% 105
% Grip Offset
% Grip Offset detector
% Grip Offset candidate 0 1 2 3 4
% Grip Offset (success)
% Grip Offset (success valid)
% Grip Offset (svwostim)

if(any(ismember(105,processID)))
    disp('105')
    % th1 = 0.5;        % N
    th2 = 2;        % Nps

    % ch1 = load(fullfile(pathname,'Total Torque(N)'));
    ch2 = load(fullfile(pathname,'Total deriv Torque(Nps)[abs]'));
    ch3 = load(fullfile(pathname,'Grip Onset'));
    % ch4 = load(fullfile(pathname,'OutT1 Off'));
    ch5 = load(fullfile(pathname,'Trial Interval'));
    ch6 = load(fullfile(pathname,'Trial Interval (success)'));
    ch7 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch8 = load(fullfile(pathname,'Trial Interval (svwostim)'));


    T2  = makeTimestampChannel('Grip Offset candidate0', 'falling threshold', ch2, th2); % candidate0
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Grip Offset candidate1', 'timestamp occurred', T2, ch3, [-1.0 -0.001]);  % candidate1　Grip Onが近くにあるものだけ
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Grip Offset candidate2', 'nearest', T2, ch3);                          % candidate1　Grip Onの直近にあるもの
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');   
    
%     T2  = filterTimestampChannel('Grip Offset candidate2', '~timestamp occurred', T2, T2, [0.001 1.0]);   % candidate2  直後にほかのcandidateがないものだけ
%     save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    
    Y1  = filterTimestampChannel('Grip Offset', 'within interval', T2, ch5);
    Y1  = filterTimestampChannel('Grip Offset', '~timestamp occurred', Y1, Y1, [-3 -0.001]);   % within interval filterをかけた後もう一度直前にほかのcandidateがないものだけ＝各トライアル中には１つのtimestampだけにする。
    Y2  = filterTimestampChannel('Grip Offset (success)', 'within interval', Y1, ch6);
    Y3  = filterTimestampChannel('Grip Offset (success valid)', 'within interval', Y1, ch7);
    Y4  = filterTimestampChannel('Grip Offset (svwostim)', 'within interval', Y1, ch8);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));
    % clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T1','T2','Y1','Y2','Y3','Y4');
    clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T2','Y1','Y2','Y3','Y4');
    % %pack;
end



%% 106
% Release Onset
% Release Onset (success)
% Release Onset (success valid)
% Release Onset (svwostim)

if(any(ismember(106,processID)))
    disp('106')
    th1 = 0.5;      % N
    th2 = -2;       % Nps
    
    
    ch1 = load(fullfile(pathname,'Total Torque(N)'));
    ch2 = load(fullfile(pathname,'Total deriv Torque(Nps)'));
    ch3 = load(fullfile(pathname,'OutT2 Enter On'));
%     ch4 = load(fullfile(pathname,'CentT Off'));

    ch4 = load(fullfile(pathname,'Trial Interval'));
    ch5 = load(fullfile(pathname,'Trial Interval (success)'));
    ch6 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch7 = load(fullfile(pathname,'Trial Interval (svwostim)'));
    
   
    th1 = mean(ch1.Data(ch1.Data>=prctile(ch1.Data,50)))*0.80;
    disp(['th1=',num2str(th1,'%.2g')])
    
    T1  = makeTimestampChannel('Release Onset detector', 'falling threshold', ch1, th1); % detector
    save(fullfile(pathname,[T1.Name,'.mat']),'-struct','T1');
    T1  = filterTimestampChannel('Release Onset detector1', 'signal stays low', T1, ch1, [0.001 1], th1); % detector1
    save(fullfile(pathname,[T1.Name,'.mat']),'-struct','T1');
    T1  = filterTimestampChannel('Release Onset detector2', 'signal stays high', T1, ch1, [-1 -0.001], th1); % detector2
    save(fullfile(pathname,[T1.Name,'.mat']),'-struct','T1');
    
    
    T2  = makeTimestampChannel('Release Onset candidate0', 'falling threshold', ch2, th2); % candidate0
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
%     T2  = filterTimestampChannel('Release Onset candidate1', 'timestamp occurred', T2, T1, [0 0.5]);   % candidate1 detectorが近くにあるものだけ
    T2  = filterTimestampChannel('Release Onset candidate1', 'timestamp occurred', T2, T1, [0 1.0]);   % candidate1 detectorが近くにあるものだけ SuuTのみ

    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Release Onset candidate2', 'nearest', T2, T1);                          % candidate2  detectorの直近にあるもの
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
%     T2  = filterTimestampChannel('Release Onset candidate3', 'timestamp occurred', T2, ch3, [-0.5 1.0]);  % candidate3　OutT2 Enter Onが近くにあるものだけ
        T2  = filterTimestampChannel('Release Onset candidate3', 'timestamp occurred', T2, ch3, [-0.5 1.5]);  % candidate3　OutT2 Enter Onが近くにあるものだけSuuTのみ

    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    
    
    
%     T2  = makeTimestampChannel('Release Onset candidate0', 'falling threshold', ch1, th1); % candidate0
% %     save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
% 
%     T2  = filterTimestampChannel('Release Onset candidate1', 'timestamp occurred', T2, ch2, [-0.5 1.0]);  % candidate3　OutT2 Enter Onが直後にあるものだけ
% %     save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
% 
%     T2  = filterTimestampChannel('Release Onset candidate2', '~timestamp occurred', T2, T2, [-1.0 -0.001]);   % candidate2  直前にほかのcandidateがないものだけ
%     save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');

    %     T2  = filterTimestampChannel('Release Onset candidate3', 'timestamp occurred', T2, ch3, [-1.25 0.5]);  % candidate3　Out1 Offが近くにあるものだけ
    %     save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');

    Y1  = filterTimestampChannel('Release Onset', 'within interval', T2, ch4);
    Y1  = filterTimestampChannel('Release Onset', '~timestamp occurred', Y1, Y1, [-3 -0.001]);   % within interval filterをかけた後もう一度直前にほかのcandidateがないものだけ
    Y2  = filterTimestampChannel('Release Onset (success)', 'within interval', Y1, ch5);
    Y3  = filterTimestampChannel('Release Onset (success valid)', 'within interval', Y1, ch6);
    Y4  = filterTimestampChannel('Release Onset (svwostim)', 'within interval', Y1, ch7);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));
    clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','th1','T2','Y1','Y2','Y3','Y4');
    % %pack;
end

%% 107
% Release Offnset
% Release Offset (success)
% Release Offset (success valid)
% Release Offset (svwostim)

if(any(ismember(107,processID)))
    disp('107')
    
        % th1 = 0.5;        % N
    th2 = 2;        % Nps

    % ch1 = load(fullfile(pathname,'Total Torque(N)'));
    ch2 = load(fullfile(pathname,'Total deriv Torque(Nps)[abs]'));
    ch3 = load(fullfile(pathname,'Release Onset'));
    % ch4 = load(fullfile(pathname,'OutT1 Off'));
    ch5 = load(fullfile(pathname,'Trial Interval'));
    ch6 = load(fullfile(pathname,'Trial Interval (success)'));
    ch7 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch8 = load(fullfile(pathname,'Trial Interval (svwostim)'));


    T2  = makeTimestampChannel('Release Offset candidate0', 'falling threshold', ch2, th2); % candidate0
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Release Offset candidate1', 'timestamp occurred', T2, ch3, [-1.0 -0.001]);  % candidate1　Release Onが近くにあるものだけ
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    T2  = filterTimestampChannel('Release Offset candidate2', 'nearest', T2, ch3);                          % candidate1　Release Onの直近にあるもの
    save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');   
%     
%     T2  = filterTimestampChannel('Release Offset candidate2', '~timestamp occurred', T2, T2, [0.001 1.0]);   % candidate2  直後にほかのcandidateがないものだけ
%     save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');
    
    Y1  = filterTimestampChannel('Release Offset', 'within interval', T2, ch5);
    Y1  = filterTimestampChannel('Release Offset', '~timestamp occurred', Y1, Y1, [-3 -0.001]);   % within interval filterをかけた後もう一度直前にほかのcandidateがないものだけ＝各トライアル中には１つのtimestampだけにする。
    Y2  = filterTimestampChannel('Release Offset (success)', 'within interval', Y1, ch6);
    Y3  = filterTimestampChannel('Release Offset (success valid)', 'within interval', Y1, ch7);
    Y4  = filterTimestampChannel('Release Offset (svwostim)', 'within interval', Y1, ch8);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));
    % clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T1','T2','Y1','Y2','Y3','Y4');
    clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T2','Y1','Y2','Y3','Y4');

    
    
    
    
%     
%     ch1 = load(fullfile(pathname,'Total deriv Torque(Nps)'));
%     ch2 = load(fullfile(pathname,'Release Onset'));
% 
%     ch4 = load(fullfile(pathname,'Trial Interval'));
%     ch5 = load(fullfile(pathname,'Trial Interval (success)'));
%     ch6 = load(fullfile(pathname,'Trial Interval (success valid)'));
%     ch7 = load(fullfile(pathname,'Trial Interval (svwostim)'));
% 
%     th1 = -2;         % Nps
% 
% 
%     T2  = makeTimestampChannel('Release Offset candidate0', 'rising threshold', ch1, th1); % candidate0
% %     save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');%disp(fullfile(pathname,Y1.Name));
%     T2  = filterTimestampChannel('Release Offset candidate1', 'timestamp occurred', T2, ch2, [-1.0 -0.001]);  % candidate3　'Release Onset'が直前にあるものだけ
% %     save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');%disp(fullfile(pathname,Y1.Name));
%     T2  = filterTimestampChannel('Release Offset candidate2', '~timestamp occurred', T2, T2, [-1.0 -0.001]);   % candidate2  直前にほかのcandidateがないものだけ
% %     save(fullfile(pathname,[T2.Name,'.mat']),'-struct','T2');%disp(fullfile(pathname,Y1.Name));
% 
%     Y1  = filterTimestampChannel('Release Offset', 'within interval', T2, ch4);
%     Y1  = filterTimestampChannel('Release Offset', '~timestamp occurred', Y1, Y1, [-3 -0.001]);   % within interval filterをかけた後もう一度直前にほかのcandidateがないものだけ
%     Y2  = filterTimestampChannel('Release Offset (success)', 'within interval', Y1, ch5);
%     Y3  = filterTimestampChannel('Release Offset (success valid)', 'within interval', Y1, ch6);
%     Y4  = filterTimestampChannel('Release Offset (svwostim)', 'within interval', Y1, ch7);
% 
%     save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
%     save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
%     save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));
%     clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','th1','T2','Y1','Y2','Y3','Y4');
%     % %pack;
end


%% 108
% !!!!!!again!!!!!!
% Trial Interval	!!!!!!again!!!!!!
% Trial Interval (success)	!!!!!!again!!!!!!
% Trial Interval (success valid)	!!!!!!again!!!!!!
% Trial Interval (svwostim)	!!!!!!again!!!!!!

% Grip Onset!!!!!!again!!!!!!
% Grip Onset (success)!!!!!!again!!!!!!
% Grip Onset (success valid)!!!!!!again!!!!!!
% Grip Onset (svwostim)!!!!!!again!!!!!!

% Release Onset!!!!!!again!!!!!!
% Release Onset (success)!!!!!!again!!!!!!
% Release Onset (success valid)!!!!!!again!!!!!!
% Release Onset (svwostim)!!!!!!again!!!!!!

if(any(ismember(108,processID)))
    disp('108')
    a1 = load(fullfile(pathname,'Grip Onset'));
    a2 = load(fullfile(pathname,'Grip Onset (success)'));
    a3 = load(fullfile(pathname,'Grip Onset (success valid)'));
    a4 = load(fullfile(pathname,'Grip Onset (svwostim)'));
    
    b1 = load(fullfile(pathname,'Grip Offset'));
    b2 = load(fullfile(pathname,'Grip Offset (success)'));
    b3 = load(fullfile(pathname,'Grip Offset (success valid)'));
    b4 = load(fullfile(pathname,'Grip Offset (svwostim)'));

    c1 = load(fullfile(pathname,'Release Onset'));
    c2 = load(fullfile(pathname,'Release Onset (success)'));
    c3 = load(fullfile(pathname,'Release Onset (success valid)'));
    c4 = load(fullfile(pathname,'Release Onset (svwostim)'));

    d1 = load(fullfile(pathname,'Release Offset'));
    d2 = load(fullfile(pathname,'Release Offset (success)'));
    d3 = load(fullfile(pathname,'Release Offset (success valid)'));
    d4 = load(fullfile(pathname,'Release Offset (svwostim)'));

    Y1   = load(fullfile(pathname,'Trial Interval'));
    Y2   = load(fullfile(pathname,'Trial Interval (success)'));
    Y3   = load(fullfile(pathname,'Trial Interval (success valid)'));
    Y4   = load(fullfile(pathname,'Trial Interval (svwostim)'));


    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, a1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, b1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, c1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, d1);
    
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, a2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, b2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, c2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, d2);
    
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, a3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, b3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, c3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, d3);
    
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, a4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, b4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, c4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, d4);

    a1  = filterTimestampChannel('Grip Onset', 'within interval', a1, Y1);
    a2  = filterTimestampChannel('Grip Onset (success)', 'within interval', a2, Y2);
    a3  = filterTimestampChannel('Grip Onset (success valid)', 'within interval', a3, Y3);
    a4  = filterTimestampChannel('Grip Onset (svwostim)', 'within interval', a4, Y4);
    
    b1  = filterTimestampChannel('Grip Offset', 'within interval', b1, Y1);
    b2  = filterTimestampChannel('Grip Offset (success)', 'within interval', b2, Y2);
    b3  = filterTimestampChannel('Grip Offset (success valid)', 'within interval', b3, Y3);
    b4  = filterTimestampChannel('Grip Offset (svwostim)', 'within interval', b4, Y4);

    c1  = filterTimestampChannel('Release Onset', 'within interval', c1, Y1);
    c2  = filterTimestampChannel('Release Onset (success)', 'within interval', c2, Y2);
    c3  = filterTimestampChannel('Release Onset (success valid)', 'within interval', c3, Y3);
    c4  = filterTimestampChannel('Release Onset (svwostim)', 'within interval', c4, Y4);

    d1  = filterTimestampChannel('Release Offset', 'within interval', d1, Y1);
    d2  = filterTimestampChannel('Release Offset (success)', 'within interval', d2, Y2);
    d3  = filterTimestampChannel('Release Offset (success valid)', 'within interval', d3, Y3);
    d4  = filterTimestampChannel('Release Offset (svwostim)', 'within interval', d4, Y4);

    
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));

    save(fullfile(pathname,[a1.Name,'.mat']),'-struct','a1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[a2.Name,'.mat']),'-struct','a2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[a3.Name,'.mat']),'-struct','a3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[a4.Name,'.mat']),'-struct','a4');%disp(fullfile(pathname,Y4.Name));

    save(fullfile(pathname,[b1.Name,'.mat']),'-struct','b1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[b2.Name,'.mat']),'-struct','b2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[b3.Name,'.mat']),'-struct','b3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[b4.Name,'.mat']),'-struct','b4');%disp(fullfile(pathname,Y4.Name));
    
    save(fullfile(pathname,[c1.Name,'.mat']),'-struct','c1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[c2.Name,'.mat']),'-struct','c2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[c3.Name,'.mat']),'-struct','c3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[c4.Name,'.mat']),'-struct','c4');%disp(fullfile(pathname,Y4.Name));

    save(fullfile(pathname,[d1.Name,'.mat']),'-struct','d1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[d2.Name,'.mat']),'-struct','d2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[d3.Name,'.mat']),'-struct','d3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[d4.Name,'.mat']),'-struct','d4');%disp(fullfile(pathname,Y4.Name));
      
    clear('a1','a2','a3','a4','b1','b2','b3','b4','c1','c2','c3','c4','d1','d2','d3','d4','Y1','Y2','Y3','Y4');
end


%% 109
% Trial Start
% Trial Start (success)
% Trial Start (success valid)
% Trial Start (svwostim)

if(any(ismember(109,processID)))
    disp('109')
    ch1 = load(fullfile(pathname,'OutT1 Enter On'));
    ch1 = filterTimestampChannel(ch1.Name, '~timestamp occurred', ch1, ch1, [-3.0 -0.001]);   % 直前にほかの自分がないものだけ


    ch2 = load(fullfile(pathname,'Trial Interval'));
    ch3 = load(fullfile(pathname,'Trial Interval (success)'));
    ch4 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch5 = load(fullfile(pathname,'Trial Interval (svwostim)'));
    
%     ch0 = load(fullfile(pathname,'OutT1 On'));
%     ch1 = filterTimestampChannel(ch1.Name,'timestamp occurred',ch1,ch0,[-2.0 0.1]);

    Y1  = filterTimestampChannel('Trial Start', 'within interval', ch1, ch2);
    Y2  = filterTimestampChannel('Trial Start (success)', 'within interval', ch1, ch3);
    Y3  = filterTimestampChannel('Trial Start (success valid)', 'within interval', ch1, ch4);
    Y4  = filterTimestampChannel('Trial Start (svwostim)', 'within interval', ch1, ch5);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    % %pack;
end
%% 110
% Go Onset
% Go Onset (success)
% Go Onset (success valid)
% Go Onset (svwostim)

if(any(ismember(110,processID)))
    disp('110')
    ch1 = load(fullfile(pathname,'CentT On'));
    ch1 = filterTimestampChannel(ch1.Name, '~timestamp occurred', ch1, ch1, [-3.0 -0.001]);   % 直前にほかの自分がないものだけ
    
    ch2 = load(fullfile(pathname,'Trial Interval'));
    ch3 = load(fullfile(pathname,'Trial Interval (success)'));
    ch4 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch5 = load(fullfile(pathname,'Trial Interval (svwostim)'));

    Y1  = filterTimestampChannel('Go Onset', 'within interval', ch1, ch2);
    Y2  = filterTimestampChannel('Go Onset (success)', 'within interval', ch1, ch3);
    Y3  = filterTimestampChannel('Go Onset (success valid)', 'within interval', ch1, ch4);
    Y4  = filterTimestampChannel('Go Onset (svwostim)', 'within interval', ch1, ch5);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    % %pack;
end
%% 111
% EndHold
% EndHold (success)
% EndHold (success valid)
% EndHold (svwostim)

if(any(ismember(111,processID)))
    disp('111')
    ch1 = load(fullfile(pathname,'CentT Off'));
    ch1 = filterTimestampChannel(ch1.Name, '~timestamp occurred', ch1, ch1, [-3.0 -0.001]);   % 直前にほかの自分がないものだけ

    ch2 = load(fullfile(pathname,'Trial Interval'));
    ch3 = load(fullfile(pathname,'Trial Interval (success)'));
    ch4 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch5 = load(fullfile(pathname,'Trial Interval (svwostim)'));

    Y1  = filterTimestampChannel('EndHold', 'within interval', ch1, ch2);
    Y2  = filterTimestampChannel('EndHold (success)', 'within interval', ch1, ch3);
    Y3  = filterTimestampChannel('EndHold (success valid)', 'within interval', ch1, ch4);
    Y4  = filterTimestampChannel('EndHold (svwostim)', 'within interval', ch1, ch5);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    % %pack;
end


%% 112
% !!!!!!タスクイベントの個数をそろえる重要!!!!!!
% Trial Interval	!!!!!!again!!!!!!
% Trial Interval (success)	!!!!!!again!!!!!!
% Trial Interval (success valid)	!!!!!!again!!!!!!
% Trial Interval (svwostim)	!!!!!!again!!!!!!

% Grip Onset!!!!!!again!!!!!!
% Grip Onset (success)!!!!!!again!!!!!!
% Grip Onset (success valid)!!!!!!again!!!!!!
% Grip Onset (svwostim)!!!!!!again!!!!!!

% Release Onset!!!!!!again!!!!!!
% Release Onset (success)!!!!!!again!!!!!!
% Release Onset (success valid)!!!!!!again!!!!!!
% Release Onset (svwostim)!!!!!!again!!!!!!

% Trial Interval	!!!!!!again!!!!!!
% Trial Interval (success)	!!!!!!again!!!!!!
% Trial Interval (success valid)	!!!!!!again!!!!!!
% Trial Interval (svwostim)	!!!!!!again!!!!!!

% Grip Onset!!!!!!again!!!!!!
% Grip Onset (success)!!!!!!again!!!!!!
% Grip Onset (success valid)!!!!!!again!!!!!!
% Grip Onset (svwostim)!!!!!!again!!!!!!

% Release Onset!!!!!!again!!!!!!
% Release Onset (success)!!!!!!again!!!!!!
% Release Onset (success valid)!!!!!!again!!!!!!
% Release Onset (svwostim)!!!!!!again!!!!!!

if(any(ismember(112,processID)))
    disp('112')
    a1 = load(fullfile(pathname,'Grip Onset'));
    a2 = load(fullfile(pathname,'Grip Onset (success)'));
    a3 = load(fullfile(pathname,'Grip Onset (success valid)'));
    a4 = load(fullfile(pathname,'Grip Onset (svwostim)'));
    
    b1 = load(fullfile(pathname,'Grip Offset'));
    b2 = load(fullfile(pathname,'Grip Offset (success)'));
    b3 = load(fullfile(pathname,'Grip Offset (success valid)'));
    b4 = load(fullfile(pathname,'Grip Offset (svwostim)'));

    c1 = load(fullfile(pathname,'Release Onset'));
    c2 = load(fullfile(pathname,'Release Onset (success)'));
    c3 = load(fullfile(pathname,'Release Onset (success valid)'));
    c4 = load(fullfile(pathname,'Release Onset (svwostim)'));

    d1 = load(fullfile(pathname,'Release Offset'));
    d2 = load(fullfile(pathname,'Release Offset (success)'));
    d3 = load(fullfile(pathname,'Release Offset (success valid)'));
    d4 = load(fullfile(pathname,'Release Offset (svwostim)'));

    e1 = load(fullfile(pathname,'Trial Start'));
    e2 = load(fullfile(pathname,'Trial Start (success)'));
    e3 = load(fullfile(pathname,'Trial Start (success valid)'));
    e4 = load(fullfile(pathname,'Trial Start (svwostim)'));
    
    f1 = load(fullfile(pathname,'Go Onset'));
    f2 = load(fullfile(pathname,'Go Onset (success)'));
    f3 = load(fullfile(pathname,'Go Onset (success valid)'));
    f4 = load(fullfile(pathname,'Go Onset (svwostim)'));
    
    g1 = load(fullfile(pathname,'EndHold'));
    g2 = load(fullfile(pathname,'EndHold (success)'));
    g3 = load(fullfile(pathname,'EndHold (success valid)'));
    g4 = load(fullfile(pathname,'EndHold (svwostim)'));
    
    Y1 = load(fullfile(pathname,'Trial Interval'));
    Y2 = load(fullfile(pathname,'Trial Interval (success)'));
    Y3 = load(fullfile(pathname,'Trial Interval (success valid)'));
    Y4 = load(fullfile(pathname,'Trial Interval (svwostim)'));


    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, a1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, b1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, c1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, d1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, e1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, f1);
    Y1  = filterIntervalChannel('Trial Interval', 'timestamp occurred', Y1, g1);

    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, a2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, b2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, c2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, d2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, e2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, f2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y2, g2);


    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, a3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, b3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, c3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, d3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, e3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, f3);
    Y3  = filterIntervalChannel('Trial Interval (success valid)', 'timestamp occurred', Y3, g3);

    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, a4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, b4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, c4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, d4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, e4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, f4);
    Y4  = filterIntervalChannel('Trial Interval (svwostim)', 'timestamp occurred', Y4, g4);
    
    
    a1  = filterTimestampChannel(a1.Name, 'within interval exclusive',a1, Y1);
    a2  = filterTimestampChannel(a2.Name, 'within interval exclusive',a2, Y2);
    a3  = filterTimestampChannel(a3.Name, 'within interval exclusive',a3, Y3);
    a4  = filterTimestampChannel(a4.Name, 'within interval exclusive',a4, Y4);
    
    b1  = filterTimestampChannel(b1.Name, 'within interval exclusive',b1, Y1);
    b2  = filterTimestampChannel(b2.Name, 'within interval exclusive',b2, Y2);
    b3  = filterTimestampChannel(b3.Name, 'within interval exclusive',b3, Y3);
    b4  = filterTimestampChannel(b4.Name, 'within interval exclusive',b4, Y4);
    
    c1  = filterTimestampChannel(c1.Name, 'within interval exclusive',c1, Y1);
    c2  = filterTimestampChannel(c2.Name, 'within interval exclusive',c2, Y2);
    c3  = filterTimestampChannel(c3.Name, 'within interval exclusive',c3, Y3);
    c4  = filterTimestampChannel(c4.Name, 'within interval exclusive',c4, Y4);
    
    d1  = filterTimestampChannel(d1.Name, 'within interval exclusive',d1, Y1);
    d2  = filterTimestampChannel(d2.Name, 'within interval exclusive',d2, Y2);
    d3  = filterTimestampChannel(d3.Name, 'within interval exclusive',d3, Y3);
    d4  = filterTimestampChannel(d4.Name, 'within interval exclusive',d4, Y4);
    
    e1  = filterTimestampChannel(e1.Name, 'within interval exclusive',e1, Y1);
    e2  = filterTimestampChannel(e2.Name, 'within interval exclusive',e2, Y2);
    e3  = filterTimestampChannel(e3.Name, 'within interval exclusive',e3, Y3);
    e4  = filterTimestampChannel(e4.Name, 'within interval exclusive',e4, Y4);
    
    f1  = filterTimestampChannel(f1.Name, 'within interval exclusive',f1, Y1);
    f2  = filterTimestampChannel(f2.Name, 'within interval exclusive',f2, Y2);
    f3  = filterTimestampChannel(f3.Name, 'within interval exclusive',f3, Y3);
    f4  = filterTimestampChannel(f4.Name, 'within interval exclusive',f4, Y4);
    
    g1  = filterTimestampChannel(g1.Name, 'within interval exclusive',g1, Y1);
    g2  = filterTimestampChannel(g2.Name, 'within interval exclusive',g2, Y2);
    g3  = filterTimestampChannel(g3.Name, 'within interval exclusive',g3, Y3);
    g4  = filterTimestampChannel(g4.Name, 'within interval exclusive',g4, Y4);

    
    save(fullfile(pathname,[a1.Name,'.mat']),'-struct','a1');%disp(fullfile(pathname,a1.Name));
    save(fullfile(pathname,[a2.Name,'.mat']),'-struct','a2');%disp(fullfile(pathname,a2.Name));
    save(fullfile(pathname,[a3.Name,'.mat']),'-struct','a3');%disp(fullfile(pathname,a3.Name));
    save(fullfile(pathname,[a4.Name,'.mat']),'-struct','a4');%disp(fullfile(pathname,a4.Name));
    
    save(fullfile(pathname,[b1.Name,'.mat']),'-struct','b1');%disp(fullfile(pathname,b1.Name));
    save(fullfile(pathname,[b2.Name,'.mat']),'-struct','b2');%disp(fullfile(pathname,b2.Name));
    save(fullfile(pathname,[b3.Name,'.mat']),'-struct','b3');%disp(fullfile(pathname,b3.Name));
    save(fullfile(pathname,[b4.Name,'.mat']),'-struct','b4');%disp(fullfile(pathname,b4.Name));
    
    save(fullfile(pathname,[c1.Name,'.mat']),'-struct','c1');%disp(fullfile(pathname,c1.Name));
    save(fullfile(pathname,[c2.Name,'.mat']),'-struct','c2');%disp(fullfile(pathname,c2.Name));
    save(fullfile(pathname,[c3.Name,'.mat']),'-struct','c3');%disp(fullfile(pathname,c3.Name));
    save(fullfile(pathname,[c4.Name,'.mat']),'-struct','c4');%disp(fullfile(pathname,c4.Name));
    
    save(fullfile(pathname,[d1.Name,'.mat']),'-struct','d1');%disp(fullfile(pathname,d1.Name));
    save(fullfile(pathname,[d2.Name,'.mat']),'-struct','d2');%disp(fullfile(pathname,d2.Name));
    save(fullfile(pathname,[d3.Name,'.mat']),'-struct','d3');%disp(fullfile(pathname,d3.Name));
    save(fullfile(pathname,[d4.Name,'.mat']),'-struct','d4');%disp(fullfile(pathname,d4.Name));
    
    save(fullfile(pathname,[e1.Name,'.mat']),'-struct','e1');%disp(fullfile(pathname,e1.Name));
    save(fullfile(pathname,[e2.Name,'.mat']),'-struct','e2');%disp(fullfile(pathname,e2.Name));
    save(fullfile(pathname,[e3.Name,'.mat']),'-struct','e3');%disp(fullfile(pathname,e3.Name));
    save(fullfile(pathname,[e4.Name,'.mat']),'-struct','e4');%disp(fullfile(pathname,e4.Name));

    save(fullfile(pathname,[f1.Name,'.mat']),'-struct','f1');%disp(fullfile(pathname,d1.Name));
    save(fullfile(pathname,[f2.Name,'.mat']),'-struct','f2');%disp(fullfile(pathname,d2.Name));
    save(fullfile(pathname,[f3.Name,'.mat']),'-struct','f3');%disp(fullfile(pathname,d3.Name));
    save(fullfile(pathname,[f4.Name,'.mat']),'-struct','f4');%disp(fullfile(pathname,d4.Name));
    
    save(fullfile(pathname,[g1.Name,'.mat']),'-struct','g1');%disp(fullfile(pathname,e1.Name));
    save(fullfile(pathname,[g2.Name,'.mat']),'-struct','g2');%disp(fullfile(pathname,e2.Name));
    save(fullfile(pathname,[g3.Name,'.mat']),'-struct','g3');%disp(fullfile(pathname,e3.Name));
    save(fullfile(pathname,[g4.Name,'.mat']),'-struct','g4');%disp(fullfile(pathname,e4.Name));
    
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y4.Name));
    
    
%     if(size(a1.Data,2)==size(b1.Data,2) && size(a1.Data,2)==size(c1.Data,2) && size(a1.Data,2)==size(d1.Data,2) && size(a1.Data,2)==size(e1.Data,2) && size(a1.Data,2)==size(Y1.Data,2))
%         display(['                                                                               同じデータ数になっています------OK(',num2str(size(Y1.Data,2)),')'])
%     else
%         display('**** error                                                                               同じデータ数になっていません------Caution！！！！！')
%     end
disp(['Grip Onset:      ',num2str(size(a4.Data,2))])
disp(['Grip Offset:     ',num2str(size(b4.Data,2))])
disp(['Release Onset:   ',num2str(size(c4.Data,2))])    
disp(['Release Offset:  ',num2str(size(d4.Data,2))])
disp(['Trial Start:     ',num2str(size(e4.Data,2))])    
disp(['Go Onset:        ',num2str(size(f4.Data,2))])    
disp(['EndHold:         ',num2str(size(g4.Data,2))])
disp(['Trial Interval:  ',num2str(size(b4.Data,2))])    


    clear('a1','a2','a3','a4','b1','b2','b3','b4','c1','c2','c3','c4',...
        'd1','d2','d3','d4','e1','e2','e3','e4','f1','f2','f3','f4',...
        'g1','g2','g3','g4','Y1','Y2','Y3','Y4');
    % %pack;
end

%% 113
% % Grip Interval
% % Grip Interval (success)
% % Grip Interval (success valid)
% % Grip Interval (svwostim)

if(any(ismember(113,processID)))
    disp('113')

    ch1 = load(fullfile(pathname,'Grip Onset.mat'));
    ch2 = load(fullfile(pathname,'Grip Offset.mat'));
    ch3 = load(fullfile(pathname,'Release Onset.mat'));
    ch4 = load(fullfile(pathname,'Release Offset.mat'));
    ch5 = load(fullfile(pathname,'Trial Start.mat'));
    
    Y1  = makeIntervalChannel('Grip Interval','timestamp pairs',ch1,ch2);
    Y2  = makeIntervalChannel('Hold Interval','timestamp pairs',ch2,ch3);
    Y3  = makeIntervalChannel('Release Interval','timestamp pairs',ch3,ch4); 
    Y4  = makeIntervalChannel('Rest Interval','window',ch5,[0 0.5]);
    
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y3.Name));
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    

    
    ch1 = load(fullfile(pathname,'Grip Onset (success).mat'));
    ch2 = load(fullfile(pathname,'Grip Offset (success).mat'));
    ch3 = load(fullfile(pathname,'Release Onset (success).mat'));
    ch4 = load(fullfile(pathname,'Release Offset (success).mat'));
    ch5 = load(fullfile(pathname,'Trial Start (success).mat'));
    
    Y1  = makeIntervalChannel('Grip Interval (success)','timestamp pairs',ch1,ch2);
    Y2  = makeIntervalChannel('Hold Interval (success)','timestamp pairs',ch2,ch3);
    Y3  = makeIntervalChannel('Release Interval (success)','timestamp pairs',ch3,ch4); 
    Y4  = makeIntervalChannel('Rest Interval (success)','window',ch5,[0 0.5]);
    
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y3.Name));
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    
    
    
    
    ch1 = load(fullfile(pathname,'Grip Onset (success valid).mat'));
    ch2 = load(fullfile(pathname,'Grip Offset (success valid).mat'));
    ch3 = load(fullfile(pathname,'Release Onset (success valid).mat'));
    ch4 = load(fullfile(pathname,'Release Offset (success valid).mat'));
    ch5 = load(fullfile(pathname,'Trial Start (success valid).mat'));
    
    Y1  = makeIntervalChannel('Grip Interval (success valid)','timestamp pairs',ch1,ch2);
    Y2  = makeIntervalChannel('Hold Interval (success valid)','timestamp pairs',ch2,ch3);
    Y3  = makeIntervalChannel('Release Interval (success valid)','timestamp pairs',ch3,ch4); 
    Y4  = makeIntervalChannel('Rest Interval (success valid)','window',ch5,[0 0.5]);
        
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y3.Name));
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');


    
    
    ch1 = load(fullfile(pathname,'Grip Onset (svwostim).mat'));
    ch2 = load(fullfile(pathname,'Grip Offset (svwostim).mat'));
    ch3 = load(fullfile(pathname,'Release Onset (svwostim).mat'));
    ch4 = load(fullfile(pathname,'Release Offset (svwostim).mat'));
    ch5 = load(fullfile(pathname,'Trial Start (svwostim).mat'));
    
    Y1  = makeIntervalChannel('Grip Interval (svwostim)','timestamp pairs',ch1,ch2);
    Y2  = makeIntervalChannel('Hold Interval (svwostim)','timestamp pairs',ch2,ch3);
    Y3  = makeIntervalChannel('Release Interval (svwostim)','timestamp pairs',ch3,ch4); 
    Y4  = makeIntervalChannel('Rest Interval (svwostim)','window',ch5,[0 0.5]);
        
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');%disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');%disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');%disp(fullfile(pathname,Y3.Name));
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');

end


%% 114
% Trigger(EMG)

if(any(ismember(114,processID)))
    disp('114')
    [temp,Expname]  = fileparts(pathname);
    Expname(end-1:end) = [];
    noisepath       = fullfile(matpath,'noise_file',Expname);

    % FDI(uV).matなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'(uV).mat']);
        
        if(exist(filename,'file'))
            noisefile   = fullfile(noisepath,[EMG,'(uV).mat']);
            noise   = load(noisefile);

            ch1 = load(filename);
            th  = 1 * noise.MAX;
            %         th  = median(ch1.Data(ch1.Data>noise.MAX));
            %         th  = mean([max(ch1.Data), noise.MAX]);

            Y1  = makeTimestampChannel(['Trigger(',EMG,'(uV))'], 'rising threshold', ch1, th/1000/1000);
            Y1.Threshold    = th;

            %         ch1 = makeTimestampChannel([EMG,'(uV)_OB'], 'rising threshold', ch1, 0.5 * max(ch1.Data) /1000/1000);
            %         save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp([fullfile(pathname,ch1.Name),' n=',num2str(length(ch1.Data))]);
            %         Y1  = filterTimestampChannel(Y1.Name, '~timestamp occurred', Y1, ch1, [-0.1 0.1]);

            save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp([fullfile(pathname,Y1.Name),' n=',num2str(length(Y1.Data))]);
            clear('ch1','Y1');
        end
    end
end

%% 115
% Spike(EMG_filtered)

if(any(ismember(115,processID)))
    disp('115')
    nth  = 1.25;
    
%     b1  = load(fullfile(pathname,'Grip Interval (svwostim).mat'));
%     b2  = load(fullfile(pathname,'Hold Interval (svwostim).mat'));
%     b3  = load(fullfile(pathname,'Release Interval (svwostim).mat'));
    
    [temp,Expname]  = fileparts(pathname);
    Expname(end-1:end) = [];
    noisepath       = fullfile(matpath,'noise_file',Expname);

    % FDI(uV).matなどunrectified EMGの名前を探す。
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG =1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'(uV).mat']);
        if(exist(filename,'file'))
            noisefile   = fullfile(noisepath,[EMG,'(uV).mat']);
            noise   = load(noisefile);

            ch1 = load(filename);
            ch2 = load(fullfile(pathname,'Spike'));

            Y1  = filterTimestampChannel(['Spike(',EMG,'(uV)_filtered)'], 'signal RMS stays high',ch2, ch1, [-0.03 0.05], nth*noise.RMS/1000/1000);
            Y1.RMS          = noise.RMS;
            Y1.nThreshold   = nth;
            Y1.Threshold    = nth*noise.RMS;
            save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));

%             Y2  = filterTimestampChannel(['Spike(',EMG,'(uV)_filtered)(Grip Interval (svwostim))'], 'within interval',      Y1, b1);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%%disp(fullfile(pathname,b1.Name));
%             Y2  = filterTimestampChannel(['Spike(',EMG,'(uV)_filtered)(Hold Interval (svwostim))'], 'within interval',      Y1, b2);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%%disp(fullfile(pathname,b1.Name));
%             Y2  = filterTimestampChannel(['Spike(',EMG,'(uV)_filtered)(Release Interval (svwostim))'], 'within interval',   Y1, b3);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%%disp(fullfile(pathname,b1.Name));


            clear('ch*','Y*');
        end

    end
end


%% 116
% Spike(Grip Interval)
% Spike(Hold Interval)
% Spike(Release Interval)

if(any(ismember(116,processID)))
    disp('116')
    a1  = load(fullfile(pathname,'Spike'));

    b1  = load(fullfile(pathname,'Grip Interval (svwostim).mat'));
    b2  = load(fullfile(pathname,'Hold Interval (svwostim).mat'));
    b3  = load(fullfile(pathname,'Release Interval (svwostim).mat'));
        
    b1  = filterTimestampChannel('Spike(Grip Interval (svwostim))', 'within interval', a1, b1);
    b2  = filterTimestampChannel('Spike(Hold Interval (svwostim))', 'within interval', a1, b2);
    b3  = filterTimestampChannel('Spike(Release Interval (svwostim))', 'within interval', a1, b3);

    save(fullfile(pathname,[b1.Name,'.mat']),'-struct','b1');%%disp(fullfile(pathname,b1.Name));
    save(fullfile(pathname,[b2.Name,'.mat']),'-struct','b2');%%disp(fullfile(pathname,b1.Name));
    save(fullfile(pathname,[b3.Name,'.mat']),'-struct','b3');%%disp(fullfile(pathname,b1.Name));
    
    clear('a1','b1','b2','b3');

end


%% 117

% Spike(Hz)ds5000Hz
% Spike(Hz)ds1000Hz
% Spike(Hz)lp20ds200Hz

if(any(ismember(117,processID)))
    disp('117')
     
%     fs_base     = 5000;
%     fs_lp1      = 1000;
%     fs_lp2      = 200;
%     p_lp        = 2;
%     w_lp        = 20;   %Hz
    
    
    Y1 = load(fullfile(pathname,'Spike'));
    Y2 = makeContinuousChannel('Spike(Hz)ds5000Hz','interspike interval',Y1,5000);
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    
    
%     % Spike(Hz)ds1000Hz
%     Y3 = makeContinuousChannel('Spike(Hz)ds1000Hz','interspike interval',Y1,1000);
%     save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));

%     % Spike(Hz)ls10ds1000Hz
%     Y2  = makeContinuousChannel('Spike(Hz)ls10ds1000Hz','linear smoothing',Y1,0.01);
%     Y2  = makeContinuousChannel('Spike(Hz)ls10ds1000Hz', 'resample', Y2, 1000);
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));

    % Spike(Hz)lp20ds1000Hz
    Y3  = makeContinuousChannel('Spike(Hz)lp20', 'butter', Y2, 'low',2,20,'both');
    havenans    = sum(isnan(Y3.Data));
    if(havenans>0)
        disp('DataにNaNがふくまれています')
    end
    Y3  = makeContinuousChannel('Spike(Hz)lp20ds1000Hz', 'resample', Y3, 1000);
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    



    clear('Y1','Y2')
end




%% 1172

% Spike(Hz)ds20000Hz
% Spike(Hz)ds1000Hz
% Spike(Hz)lp20ds200Hz

if(any(ismember(1172,processID)))
    disp('1172')
     
    
    % >> for specimen !!caution!! its heavy
    Y1 = load(fullfile(pathname,'Spike'));
    Y1 = makeContinuousChannel('Spike(Hz)ds20000Hz','interspike interval',Y1,20000);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    % <<

    clear('Y*')
end


%% 118
% lEMGl(uV)
% lEMGl(uV)lp20ds1000Hz

if(any(ismember(118,processID)))
    disp('118')
    
    
%     p_lp        = 2;
%     w_lp        = 20;   % Hz

    % FDIなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG=1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,['l',EMG,'l(uV).mat']);
        if(exist(filename,'file'))
            Y1     = load(filename);    % rectified
            Name    = ['l',EMG,'l(uV)'];
% % % 
% % %             
% % %             % lEMGl(uV)ds1000Hz
% % %             Y2  = makeContinuousChannel([Name,'ds1000Hz'],'resample',Y1,1000,1);
% % %             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
% % % 
% % % %             % lEMGl(uV)ls10ds1000Hz
% % % %             Y2  = makeContinuousChannel([Name,'ls10'],'linear smoothing',Y1,0.01);
% % % %             Y2  = makeContinuousChannel([Name,'ls10ds1000Hz'], 'resample', Y2, 1000);
% % % %             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
% % % 
            % lEMGl(uV)lp20ds1000Hz
            Y2  = makeContinuousChannel([Name,'lp20'], 'butter', Y1, 'low',2,20,'both');
            havenans    = sum(isnan(Y2.Data));
            if(havenans>0)
                disp('DataにNaNがふくまれています')
            end
            Y2  = makeContinuousChannel([Name,'lp20ds1000Hz'], 'resample', Y2, 1000,1);
            save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            
%             Y2     = load(fullfile(pathname,['l',EMG,'l(uV)lp20ds1000Hz.mat']));    % rectified
%             Name    = ['l',EMG,'l(uV)'];
%             
%             % lEMGl(uV)lp20ds1000Hz-deriv1
%             Y2  = makeContinuousChannel([Name,'lp20ds1000Hz-deriv'], 'derivative', Y2, 1);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            

            
            
            
%             % lEMGl(Hz)lp50ls25ds200Hz for NMF
%             Y2  = Y1;
%             Y2  = makeContinuousChannel([Name,'lp50'],'butter',Y2,'low', 2, 50);
%             Y2  = makeContinuousChannel([Name,'lp50ls25'],'linear smoothing',Y2,0.025);
%             Y2  = makeContinuousChannel([Name,'lp50ls25ds200Hz'], 'resample', Y2, 200);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));


%           

            clear('Y*','ch*');
        end
    end

end

% %% 119
% 
% % Total deriv Torque(Nps)[positive]
% % Total deriv Torque(Nps)[negative]
% % Total deriv Torque(Nps)[abs]
% 
% if(any(ismember(119,processID)))
%     disp('119')
% 
%     
%     ch1 = load(fullfile(pathname,'Total deriv Torque(Nps)'));
%     
%     ch2         = ch1;
%     ch2.Name    = [ch1.Name,'[positive]'];
%     ch2.Data    = zeromask(ch2.Data,ch2.Data>0);
%     save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
%     
%     ch2         = ch1;
%     ch2.Name    = [ch1.Name,'[negative]'];
%     ch2.Data    = zeromask(ch2.Data,ch2.Data<0);
%     save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
%     
%     ch2         = ch1;
%     ch2.Name    = [ch1.Name,'[abs]'];
%     ch2.Data    = abs(ch2.Data);
%     save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
% 
%     
%     
%     clear('ch1','ch2');
%     
%     
%     
% end


%% 120
% EMG''' cross-talk MTX を作るときなどに必要

if(any(ismember(120,processID)))
    disp('120')
    % FDI(uV).matなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'(uV).mat']);
        if(exist(filename,'file'))
            ch1 = load(filename);

            ch1.Data    = deriv(ch1.Data,3);
            ch1.Name    = [EMG,'''''''(uV)'];

            save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));
%                     disp(fullfile(pathname,ch1.Name));
            clear('ch1');
        end
    end
    
    
end



%% 121
% Trigger(EMG''''''(uV))
% EMG''' cross-talk MTX を作るときなどに必要


ID  = 121;
if(any(ismember(ID,processID)))
    disp(num2str(ID))

    % FDI(uV).matなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};
        
        
        filename    = fullfile(pathname,[EMG,'''''''(uV).mat']);
        if(exist(filename,'file'))
            ch1 = load(filename);
            th  = 1.96*std(ch1.Data);
            
            Y1  = makeTimestampChannel(['Trigger(',EMG,'''''''(uV))'], 'rising threshold', ch1, th/1000/1000);
            Y1.Threshold    = th;

            save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp([fullfile(pathname,Y1.Name),' n=',num2str(length(Y1.Data))]);
%             disp(fullfile(pathname,Y1.Name));
            
            clear('ch1','Y1');
        end
    end
end


%% 122 CentT Enter Interval
if(any(ismember(122,processID)))
    disp('122')
    
    ch1 = load(fullfile(pathname,'CentT Enter On.mat'));
    ch2 = load(fullfile(pathname,'CentT Enter Off.mat'));
    
    
    Y1  = makeIntervalChannel('CentT Enter Interval','timestamp pairs',ch1,ch2);
    Y1  = filterIntervalChannel(Y1.Name,'duration',Y1,[0.5 inf]);
    
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    
    clear('ch*','Y*');
    %pack;
end

%% 181 for Dr Koike
% % Trial Interval
% % Trial Interval (success)
% % Trial Interval (success valid)
% % Trial Interval (svwostim)

if(any(ismember(181,processID)))
    disp('181')
       
    ch1 = load(fullfile(pathname,'OutT1 On.mat'));
    ch2 = load(fullfile(pathname,'OutT2 Off.mat'));
    ch3 = load(fullfile(pathname,'Success.mat'));
    ch4 = load(fullfile(pathname,'CentT Enter On'));
    ch5 = load(fullfile(pathname,'CentT Enter Off'));

    
    Y1  = makeIntervalChannel('Trial Interval','timestamp pairs',ch1,ch2);
    Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y1, ch3, -1);
    Y3  = makeIntervalChannel('Hold Interval','timestamp pairs',ch4,ch5);
    Y4  = filterIntervalChannel('Hold Interval (success)', 'interval occurred', Y3, Y2);

    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
    save(fullfile(pathname,[Y4.Name,'.mat']),'-struct','Y4');disp(fullfile(pathname,Y4.Name));
    clear('ch*','Y*');
    %pack;
end







%% 214
% Trigger(EMG)

if(any(ismember(214,processID)))
    disp('214')
    [temp,Expname]  = fileparts(pathname);
    Expname(end-1:end) = [];
    noisepath       = fullfile(matpath,'noise_file',Expname);

    % FDI(uV).matなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};

        noisefile   = fullfile(noisepath,[EMG,'(uV).mat']);
        noise   = load(noisefile);

        ch1 = load(fullfile(pathname,[EMG,'''(uV).mat']));
        th  = median(ch1.Data(ch1.Data>noise.MAX));
%         th  = mean([max(ch1.Data), noise.MAX]);

        Y1  = makeTimestampChannel(['Trigger(',EMG,'''(uV))'], 'rising threshold', ch1, th/1000/1000);
        Y1.Threshold    = th;

        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        clear('ch1','Y1');

    end
end

%% 215
% Spike(EMG_filtered)

if(any(ismember(215,processID)))
    disp('215')
    nth  = 1.25;
    
    b1  = load(fullfile(pathname,'Grip Interval (svwostim).mat'));
    b2  = load(fullfile(pathname,'Hold Interval (svwostim).mat'));
    b3  = load(fullfile(pathname,'Release Interval (svwostim).mat'));
    
    [temp,Expname]  = fileparts(pathname);
    Expname(end-1:end) = [];
    noisepath       = fullfile(matpath,'noise_file',Expname);

    % FDI(uV).matなどunrectified EMGの名前を探す。

    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG =1:nEMG
        EMG = EMGs{iEMG};

        noisefile   = fullfile(noisepath,[EMG,'(uV).mat']);
        noise   = load(noisefile);

        ch1 = load(fullfile(pathname,[EMG,'''(uV).mat']));
        ch2 = load(fullfile(pathname,'Spike'));

        Y1  = filterTimestampChannel(['Spike(',EMG,'''(uV)_filtered)'], 'signal RMS stays high',ch2, ch1, [-0.03 0.05], nth*noise.RMS/1000/1000);
        Y1.RMS          = noise.RMS;
        Y1.nThreshold   = nth;
        Y1.Threshold    = nth*noise.RMS;
        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        
        Y2  = filterTimestampChannel(['Spike(',EMG,'''(uV)_filtered)(Grip Interval (svwostim))'], 'within interval',      Y1, b1);
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%%disp(fullfile(pathname,b1.Name));
        Y2  = filterTimestampChannel(['Spike(',EMG,'''(uV)_filtered)(Hold Interval (svwostim))'], 'within interval',      Y1, b2);
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%%disp(fullfile(pathname,b1.Name));
        Y2  = filterTimestampChannel(['Spike(',EMG,'''(uV)_filtered)(Release Interval (svwostim))'], 'within interval',   Y1, b3);
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');%%disp(fullfile(pathname,b1.Name));
        
        
        clear('ch1','ch2','Y1','Y2');

    end
end


%% 301
% EMG(uV)_original.mat
% EMG(uV).mat
% lEMGl(uV).mat

% Aobaで見られるDetectionPulseのノイズを除去するため、
% EMG(uV)をEMG(uV)_originalとリネームして、
% remove artifactをしたものをEMG(uV)、
% さらにrectifyしたものをlEMGl(uV)とする。

if(any(ismember(301,processID)))
    disp('301')
    window  = [-0.002 0.002];

    % FDI(uV).matなどunrectified EMGの名前を探す。

    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG =1:nEMG
        EMG = EMGs{iEMG};

        filename    = fullfile(pathname,'MSD.mat');
        if(exist(filename,'file'))
            ch2 = load(filename);
        end
        
        filename    = fullfile(pathname,[EMG,'(uV).mat']);
        if(exist(filename,'file'))
            ch1 = load(filename);
            
            ch1.Name    = [EMG,'(uV)_original'];
            save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));

            ch1   = makeContinuousChannel([EMG,'(uV)'],'remove artifact',ch1,ch2,window);
            save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));
        end

        filename    = fullfile(pathname,['l',EMG,'l(uV).mat']);
        if(exist(filename,'file'))
            ch1 = load(filename);
            
%             ch1.Name    = ['l',EMG,'l(uV)_original'];
%             save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));

            ch1   = makeContinuousChannel(['l',EMG,'l(uV)'],'remove artifact',ch1,ch2,window);
            save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));
        end


        clear('ch1','ch2');

    end
end


%% 302
% % EMG'''(uV).mat

if(any(ismember(302,processID)))
    disp('302')

    % FDI(uV).matなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'(uV).mat']);
        if(exist(filename,'file'))
            ch1 = load(filename);

            ch1.Data    = diff3(ch1.Data);
            ch1.Name    = [EMG,'''''''(uV)'];

            save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));
            %         disp(fullfile(pathname,ch1.Name));
            clear('ch1');
        end
    end
end

%% 303
% Trigger(EMG''''''(uV))
ID  = 303;
if(any(ismember(ID,processID)))
    disp(num2str(ID))

    % FDI(uV).matなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};
        
        
        filename    = fullfile(pathname,[EMG,'''''''(uV).mat']);
        if(exist(filename,'file'))
            ch1 = load(filename);
            th  = 1.96*std(ch1.Data);
            %         th  = 1 * noise.MAX;
            %         th  = median(ch1.Data(ch1.Data>noise.MAX));
            %         th  = mean([max(ch1.Data), noise.MAX]);

            Y1  = makeTimestampChannel(['Trigger(',EMG,'''''''(uV))'], 'rising threshold', ch1, th/1000/1000);
            Y1.Threshold    = th;

            %         ch1 = makeTimestampChannel([EMG,'(uV)_OB'], 'rising threshold', ch1, 0.8 * max(ch1.Data) /1000/1000);
            %         save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp([fullfile(pathname,ch1.Name),' n=',num2str(length(ch1.Data))]);
            %         Y1  = filterTimestampChannel(Y1.Name, '~timestamp occurred', Y1, ch1, [-0.1 0.1]);

            save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp([fullfile(pathname,Y1.Name),' n=',num2str(length(Y1.Data))]);
            clear('ch1','Y1');
        end
    end
end


%% 999
% % 何かの手違いでlEMGl(uV).matファイルを書き換えてしまったときに、EMG(uV).matファイルから復元する

if(any(ismember(999,processID)))
    disp('999')

    % FDI(uV).matなどunrectified EMGの名前を探す。
%     files    = dirmat(pathname);
%     ind     = strfind(files,'l(uV).mat');
%     nEMG    = 0;
%     for ifile=1:length(files)
%         if(~isempty(ind{ifile}))
%             nEMG    = nEMG+1;
%             indl    = strfind(files{ifile},'l');
%             EMGs{nEMG}  = [files{ifile}(indl(1)+1:indl(end)-1),'(uV).mat'];
%             Name{nEMG}  = deext(files{ifile});
%         end
%     end
    
%     EMGs    = dirmat(pathname);
%     EMGs    = parseEMG(EMGs);
%     for iEMG=length(EMGs):-1:1
%         if(isempty(EMGs{iEMG}))
%             EMGs(iEMG)=[];
%         end
%     end
%     EMGs    = unique(EMGs);
%     nEMG    = length(EMGs);
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'(uV).mat']);
        if(exist(filename,'file'))
        ch1 = load(filename);

        ch1.Data    = abs(ch1.Data);
        ch1.Name    = ['l',EMG,'l(uV)'];

        save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));
%         disp(fullfile(pathname,ch1.Name));
        clear('ch1');
        end
    end
end





%% 998
% % 何かの手違いでlEMG'l(uV).matファイルを書き換えてしまったときに、EMG'(uV).matファイルから復元する

if(any(ismember(998,processID)))
    disp('998')

    % FDI(uV).matなどunrectified EMGの名前を探す。
%     files    = dirmat(pathname);
%     ind     = strfind(files,'l(uV).mat');
%     nEMG    = 0;
%     for ifile=1:length(files)
%         if(~isempty(ind{ifile}))
%             nEMG    = nEMG+1;
%             indl    = strfind(files{ifile},'l');
%             EMGs{nEMG}  = [files{ifile}(indl(1)+1:indl(end)-1),'(uV).mat'];
%             Name{nEMG}  = deext(files{ifile});
%         end
%     end
    
%     EMGs    = dirmat(pathname);
%     EMGs    = parseEMG(EMGs);
%     for iEMG=length(EMGs):-1:1
%         if(isempty(EMGs{iEMG}))
%             EMGs(iEMG)=[];
%         end
%     end
%     EMGs    = unique(EMGs);
%     nEMG    = length(EMGs);
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};

        filename    = fullfile(pathname,[EMG,'''(uV).mat']);
        if(exist(filename,'file'))
            ch1 = load(filename);

            ch1.Data    = abs(ch1.Data);
            ch1.Name    = ['l',EMG,'''l(uV)'];

            save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));
            %         disp(fullfile(pathname,ch1.Name));
            clear('ch1');
        end
    end
end
















%% 201
% ICMS(XuAxY)

if(any(ismember(201,processID)))
    disp('201')
    ch1 = load(fullfile(pathname,'Stim pulse'));

    ind     = strcmp({ch1.accessory_data.Name},'Offset3');
    Offset  = ch1.accessory_data(ind).Data(1);
    
    ch1     = makeTimestampChannel(ch1.Name, 'shift', ch1, Offset/1000);
    
    ind     = strcmp({ch1.accessory_data.Name},'Actual Amp3');
    Amps    = sort(unique(ch1.accessory_data(ind).Data));

    nAmp    = length(Amps);
    for iAmp=1:nAmp
        Amp     = Amps(iAmp);
        Name    = ['ICMS(',num2str(Amp),'uAx1)'];
        Y1  = filterTimestampChannel(Name, 'accessory data equal', ch1, 'Relay3', 1, 'Actual Amp3', Amp, 'Cycles3', 1);
        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    end
    
    Y1  = filterTimestampChannel('ICMS(vl5uAx1)', 'accessory data range', ch1, 'Relay3',    1, 'Actual Amp3', [0.1 5], 'Cycles3', 1);
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    Y1  = filterTimestampChannel('ICMS(5vvl10uAx1)', 'accessory data range', ch1, 'Relay3', 1, 'Actual Amp3', [5.1 10], 'Cycles3', 1);
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    Y1  = filterTimestampChannel('ICMS(10vvl20uAx1)', 'accessory data range', ch1, 'Relay3',1, 'Actual Amp3', [10.1 20], 'Cycles3', 1);
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    Y1  = filterTimestampChannel('ICMS(20vvl30uAx1)', 'accessory data range', ch1, 'Relay3',1, 'Actual Amp3', [20.1 30], 'Cycles3', 1);
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    Y1  = filterTimestampChannel('ICMS(30vvl40uAx1)', 'accessory data range', ch1, 'Relay3',1, 'Actual Amp3', [30.1 40], 'Cycles3', 1);
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    Y1  = filterTimestampChannel('ICMS(40vvl50uAx1)', 'accessory data range', ch1, 'Relay3',1, 'Actual Amp3', [40.1 50], 'Cycles3', 1);
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    Y1  = filterTimestampChannel('ICMS(vl50uAx1)', 'accessory data range', ch1, 'Relay3',   1, 'Actual Amp3', [0.1 50], 'Cycles3', 1);
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    Y1  = filterTimestampChannel('ICMS(vl30uAx1)', 'accessory data range', ch1, 'Relay3',   1, 'Actual Amp3', [0.1 30], 'Cycles3', 1);
    save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));

%     Y1  = filterTimestampChannel('ICMS(30vuAx1)', 'accessory data range', ch1, 'Relay3', 1, 'Actual Amp3', [30.1 Inf], 'Cycles3', 1);
%     save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
%     Y1  = filterTimestampChannel('ICMS(50vuAx1)', 'accessory data range', ch1, 'Relay3', 1, 'Actual Amp3', [50.1 Inf], 'Cycles3', 1);
%     save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    
    clear('ch1','Y1');
    
    
end


%% 401

if(any(ismember(401,processID)))
    disp('401')
    
    % EMG(uV)の直流成分を除去し、EMG(uV)とlEMGl(uV)を作成する。
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};

        filename    = fullfile(pathname,[EMG,'(uV).mat']);
        if(exist(filename,'file'))
            ch1 = load(filename);

            ch2 = makeContinuousChannel(ch1.Name,'detrend',ch1,'constant');
            save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
            
            
            ch2  =  makeContinuousChannel(['l',EMG,'l(uV)'], 'rectify', ch2);
            save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));

            
%             ch1 = makeContinuousChannel([EMG,'-HP(uV)'],'butter',ch1,'high',2,10,'normal');
%             save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));
% 
%             ch2  =  makeContinuousChannel(['l',EMG,'-HPl(uV)'], 'rectify', ch1);
%             save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
%             
%             ch1 = makeContinuousChannel([EMG,'-HP-BS(uV)'],'butter',ch1,'stop',2,[49,51],'normal');
%             save(fullfile(pathname,[ch1.Name,'.mat']),'-struct','ch1');disp(fullfile(pathname,ch1.Name));
% 
%             ch2  =  makeContinuousChannel(['l',EMG,'-HP-BSl(uV)'], 'rectify', ch1);
%             save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
            
            clear('ch1','ch2');
        end
    end
    
end

%% 402

if(any(ismember(402,processID)))
    disp('402')
    
    
    window  = [0 0.025]; %sec
    th      = 300 / 1000 / 1000;
    
    
    % PT stim evoked EMGを取り除くためにStim pulseとStim pulse2のwindow[0
    % 0.02]secをremove artifact
    
    ch1 = load(fullfile(pathname,'Stim pulse'));
%     % Offset をつけていた場合、それを補正する。
%     ind     = strcmp({ch1.accessory_data.Name},'Offset3');
%     Offset  = ch1.accessory_data(ind).Data(1);
%     ch1     = makeTimestampChannel(ch1.Name, 'shift', ch1, Offset/1000);
    
    ch2  = makeTimestampChannel([ch1.Name,' 2'],'shift cycles', ch1, 3, 1);
    save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
    ch2  = makeTimestampChannel([ch1.Name,' 3'],'shift cycles', ch1, 3, 2);
    save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
    
    
    
    ch2 = load(fullfile(pathname,'Stim pulse 2'));
    ch1 = makeTimestampChannel(ch1.Name,'merge',{ch1,ch2});
    
    
                            
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};

        filename    = fullfile(pathname,[EMG,'(uV).mat']);
        if(exist(filename,'file'))
            ch2 = load(filename);
            
            ch2 = makeContinuousChannel([EMG,'-rmMEP(uV)'],'remove artifact',ch2,ch1,window);
            save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
            
            ch2 = makeContinuousChannel(['l',EMG,'l-rmMEP(uV)'], 'rectify', ch2);
            save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
            
            
            clear('ch2');
        end
    end
    
    
    
end



%% 403

if(any(ismember(403,processID)))
    disp('403')
    
    window1 = [0.005 0.02];
    window2 = [-0.1  0.5];
    BGEMGth = 65 /1000 /1000;
    
        
    ch1 = load(fullfile(pathname,'Stim pulse'));
        
%     % Offset をつけていた場合、それを補正する。
%     ind     = strcmp({ch1.accessory_data.Name},'Offset3');
%     Offset  = ch1.accessory_data(ind).Data(1);
%     ch1     = makeTimestampChannel(ch1.Name, 'shift', ch1, Offset/1000);
    
    ch2  = makeTimestampChannel([ch1.Name,' 2'],'shift cycles', ch1, 3, 1);
    save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
    ch2  = makeTimestampChannel([ch1.Name,' 3'],'shift cycles', ch1, 3, 2);
    save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
    
    if(exist(fullfile(pathname,'MEP timestamps.mat'),'file'))
        ch2 = load(fullfile(pathname,'MEP timestamps'));
        MEP_flag    = true;
        disp('MEP_flag = 1')
    else
        MEP_flag    = false;
        disp('MEP_flag = 0')
    end
    
    BGEMGfilename   = 'lFDIl-rmMEP(uV).mat';
%     BGEMGfilename   = 'BGEMG.mat';
    if(exist(fullfile(pathname,BGEMGfilename),'file'))
        ch3 = load(fullfile(pathname,BGEMGfilename));
        BGEMG_flag    = true;
        disp('BGEMG_flag = 1')
    else
        BGEMG_flag    = false;
        disp('BGEMG_flag = 0')
    end
    
    
    if(MEP_flag)
        % (1発目の)刺激後(5-20ms)にMEP timestampsが起こっているもののみに絞る。
        Y1  = filterTimestampChannel([ch1.Name,' (withMEP)'], 'timestamp occurred', ch1, ch2, window1);
        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
    end
    
    if(BGEMG_flag)
%         % (1発目の)刺激前(500-0ms)にMEP timestampsが起こっているもののみに絞る。
%         Y1  = filterTimestampChannel([ch1.Name,' (withBGEMG)'], 'timestamp occurred', ch1, ch3, window2);
%         save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        % (1発目の)刺激前後(-100-500ms)のRMSがthより高いものに絞る。
        Y1  = filterTimestampChannel([ch1.Name,' (withBGEMG)'], 'signal RMS stays high', ch1, ch3, window2, BGEMGth);
        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        
        Y2  = makeTimestampChannel([Y1.Name,' 2'],'shift cycles', Y1, 3, 1);
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
        Y2  = makeTimestampChannel([Y1.Name,' 3'],'shift cycles', Y1, 3, 2);
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
        
%         Y1  = filterTimestampChannel([ch1.Name,' (~withBGEMG)'], '~timestamp occurred', ch1, ch3, window2);
%         save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        % (1発目の)刺激前後(-100-500ms)のRMSがthより低いものに絞る。
        Y1  = filterTimestampChannel([ch1.Name,' (~withBGEMG)'], 'signal RMS stays low', ch1, ch3, window2, BGEMGth);
        save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
        
        Y2  = makeTimestampChannel([Y1.Name,' 2'],'shift cycles', Y1, 3, 1);
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
        Y2  = makeTimestampChannel([Y1.Name,' 3'],'shift cycles', Y1, 3, 2);
        save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    end
    
    % Actual Amp3
    AmpRanges   = [1,25;...
        26,50;...
        51,75;...
        76,100;...
        1,100;...
        101,200;...
        201,300;...
        301,400;...
        401,500;...
        501,600;...
        601,700;...
        701,800;...
        801,900;...
        901,1000;];
    nAmp    = size(AmpRanges,1);
    
    for iAmp=1:nAmp
        AmpRange = AmpRanges(iAmp,:);
        Y1  = filterTimestampChannel(['Stim pulse (Amp',num2str(AmpRange(1),'%0.3d'),'-',num2str(AmpRange(2),'%0.3d'),'uA)'],...
            'accessory data range', ch1,...
            'Relay3',    1,...
            'Actual Amp3', AmpRange);
        
%         if(~isempty(Y1.Data))
            save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
            
            if(MEP_flag)
                % (1発目の)刺激後(5-20ms)にMEP timestampsが起こっているもののみに絞る。
                Y1  = filterTimestampChannel([Y1.Name,' (withMEP)'], 'timestamp occurred', Y1, ch2, window1);
                save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
            end
            
            if(BGEMG_flag)
%                 % (1発目の)刺激前(500-0ms)にBGEMGが起こっているもののみに絞る。
%                 Y2  = filterTimestampChannel([Y1.Name,' (withBGEMG)'], 'timestamp occurred', Y1, ch3, window2);
%                 save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
%                 Y2  = filterTimestampChannel([Y1.Name,' (~withBGEMG)'], '~timestamp occurred', Y1, ch3, window2);
%                 save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));

                % (1発目の)刺激前後(-100-500ms)のRMSがthより高いものに絞る。
                Y2  = filterTimestampChannel([Y1.Name,' (withBGEMG)'], 'signal RMS stays high', Y1, ch3, window2, BGEMGth);
                save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
                
                % (1発目の)刺激前後(-100-500ms)のRMSがthより低いものに絞る。
                Y2  = filterTimestampChannel([Y1.Name,' (~withBGEMG)'], 'signal RMS stays low', Y1, ch3, window2, BGEMGth);
                save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
        
                
            end
            
%         end
    end
    
    
    Freqs   = [2.5, 5, 7.5, 10, 12.5, 15, 17.5, 20, 25, 30, 35, 40, 45, 50, 62.5, 83.333 125, 250];
    nFreq   = length(Freqs);
    
    for iFreq=1:nFreq
        
        Freq = Freqs(iFreq);
        
        leftnum     = floor(Freq);
        rightnum    = Freq - leftnum;
        leftchar    = num2str(leftnum,'%0.3d');
        rightchar   = num2str(rightnum,'%0.1g');
        rightchar(1)    = [];
        Freqchar    = [leftchar,rightchar];
        
        Y1  = filterTimestampChannel(['Stim pulse (Freq',Freqchar,'Hz)'],...
            'accessory data equal', ch1,...
            'Relay3',1,...
            'Frequency3', Freq);
        
        if(~isempty(Y1.Data))
            save(fullfile(pathname,[Y1.Name,'.mat']),'-struct','Y1');disp(fullfile(pathname,Y1.Name));
            
            
            if(MEP_flag)
                % 1発目の刺激後(5-20ms)にMEP timestampsが起こっているもののみに絞る。
                X1  = filterTimestampChannel([Y1.Name,' (withMEP)'], 'timestamp occurred', Y1, ch2, window1);
                save(fullfile(pathname,[X1.Name,'.mat']),'-struct','X1');disp(fullfile(pathname,X1.Name));
            end
            
            if(BGEMG_flag)
%                 % (1発目の)刺激前(500-0ms)にBGEMGが起こっているもののみに絞る。
%                 X2  = filterTimestampChannel([Y1.Name,' (withBGEMG)'], 'timestamp occurred', Y1, ch3, window2);
%                 save(fullfile(pathname,[X2.Name,'.mat']),'-struct','X2');disp(fullfile(pathname,X2.Name));
%                 
%                 X3  = filterTimestampChannel([Y1.Name,' (~withBGEMG)'], '~timestamp occurred', Y1, ch3, window2);
%                 save(fullfile(pathname,[X3.Name,'.mat']),'-struct','X3');disp(fullfile(pathname,X3.Name));

                % (1発目の)刺激前後(-100-500ms)のRMSがthより高いものに絞る。
                X2  = filterTimestampChannel([Y1.Name,' (withBGEMG)'], 'signal RMS stays high', Y1, ch3, window2, BGEMGth);
                save(fullfile(pathname,[X2.Name,'.mat']),'-struct','X2');disp(fullfile(pathname,X2.Name));

                % (1発目の)刺激前後(-100-500ms)のRMSがthより低いものに絞る。
                X3  = filterTimestampChannel([Y1.Name,' (~withBGEMG)'], 'signal RMS stays low', Y1, ch3, window2, BGEMGth);
                save(fullfile(pathname,[X3.Name,'.mat']),'-struct','X3');disp(fullfile(pathname,X3.Name));
            end
            
            % n発目のStimonsetにtimestampを作るために、(1/Freq * (n-1))秒シフトさせる。
            nn   = strmatch('Cycles3',{Y1.accessory_data.Name});
            nn   = unique(Y1.accessory_data(nn).Data);
            
            if(nn(1)>1 && length(nn)<2)
                for ii =2:(nn+1)
                    Y2  = makeTimestampChannel([Y1.Name,' ', num2str(ii)],...
                        'shift', Y1, (1*(ii-1))/Freq);
                    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));

                    if(MEP_flag)
                        % 1発目の刺激後(5-20ms)にMEP timestampsが起こっているもののみに絞る。
                        X1  = makeTimestampChannel([X1.Name,' ', num2str(ii)],...
                            'shift', X1, (1*(ii-1))/Freq);
                        save(fullfile(pathname,[X1.Name,'.mat']),'-struct','X1');disp(fullfile(pathname,X1.Name));
                    end
                    
                    if(BGEMG_flag)
                        % (1発目の)刺激前(500-0ms)にBGEMGが起こっているもののみに絞る。
                        X22  = makeTimestampChannel([X2.Name,' ', num2str(ii)],...
                            'shift', X2, (1*(ii-1))/Freq);
                        save(fullfile(pathname,[X22.Name,'.mat']),'-struct','X22');disp(fullfile(pathname,X22.Name));
                        
                        X33  = makeTimestampChannel([X3.Name,' ', num2str(ii)],...
                            'shift', X3, (1*(ii-1))/Freq);
                        save(fullfile(pathname,[X33.Name,'.mat']),'-struct','X33');disp(fullfile(pathname,X33.Name));
                    end
                end
            end

            
        end
    end
    
    clear('ch*','Y*','X*');
    
end
%% 404

if(any(ismember(404,processID)))
    disp('404')
    
    th      = [200,300,400,500,600,800];
    nth     = length(th);
    
    % EMG(uV)の直流成分を除去し、EMG(uV)とlEMGl(uV)を作成する。
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);
    
    for iEMG =1:nEMG
        EMG = EMGs{iEMG};

        filename    = fullfile(pathname,['l',EMG,'l(uV).mat']);
        if(exist(filename,'file'))
            ch1 = load(filename);
            
            for ith=1:nth
            ch2 = makeTimestampChannel(['MEP timestamps',num2str(th(ith))], 'rising threshold', ch1, th(ith)/1000/1000);
            save(fullfile(pathname,[ch2.Name,'.mat']),'-struct','ch2');disp(fullfile(pathname,ch2.Name));
            end
            
            clear('ch1','ch2');
        end
    end
    
end


%% 501
% lEMGl(uV)
% lEMGl(uV)lp20ds1000Hz

if(any(ismember(501,processID)))
    disp('501')
    
    
%     p_lp        = 2;
%     w_lp        = 20;   % Hz

    % FDIなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG=1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,['l',EMG,'l(uV).mat']);
        if(exist(filename,'file'))

            
            Y2     = load(fullfile(pathname,[EMG,'(uV).mat']));    % unrectified
            Name   = [EMG,'(uV)'];
            
            
            
            % EMG(uV)1000Hz
            Y2  = makeContinuousChannel([Name,'-ds1000Hz'], 'resample', Y2, 1000);
            save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            

            
            
            
%             % lEMGl(Hz)lp50ls25ds200Hz for NMF
%             Y2  = Y1;
%             Y2  = makeContinuousChannel([Name,'lp50'],'butter',Y2,'low', 2, 50);
%             Y2  = makeContinuousChannel([Name,'lp50ls25'],'linear smoothing',Y2,0.025);
%             Y2  = makeContinuousChannel([Name,'lp50ls25ds200Hz'], 'resample', Y2, 200);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));


%           

            clear('Y*','ch*');
        end
    end

end

%% 502
% lEMGl(uV)
% lEMGl(uV)lp20ds1000Hz

if(any(ismember(502,processID)))
    disp('502')
    
    
%     p_lp        = 2;
%     w_lp        = 20;   % Hz

    % FDIなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG=1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'(uV)1000Hz-bss.mat']);
        if(exist(filename,'file'))

            
            Y2     = load(filename);   
            
            % highpass filtering
            Y2  = makeContinuousChannel([EMG,'(uV)-ds1000Hz-bss-hp30Hz'], 'butter', Y2, 'high', 2, 30);
            
            
            % rectification
            Y2   = makeContinuousChannel([EMG,'(uV)-ds1000Hz-bss-hp30Hz-rect'], 'rectify', Y2);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            
            % lowpass filtering
            % lEMGl(uV)lp20ds1000Hz
            Y2  = makeContinuousChannel([EMG,'(uV)-ds1000Hz-bss-hp30Hz-rect-lp20Hz'], 'butter', Y2, 'low',2,20,'both');
            havenans    = sum(isnan(Y2.Data));
            if(havenans>0)
                disp('DataにNaNがふくまれています')
            end
            
            
%             % 100Hz version
%             % downsampling (bin-average)
%             Y3  = makeContinuousChannel(['l',EMG,'l(uV)lp20ds100Hz-bss'], 'resample', Y2, 100,1);
% %             save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
%             
%             % non-negative
%             Y3.Name = ['l',EMG,'l(uV)lp20ds100Hz-bss-nn'];
%             Y3.Data = max(0,Y3.Data);
% %             save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
%             
%             % normalize (mean)
%             Y3.Name = ['l',EMG,'l(mean)lp20ds100Hz-bss-nn'];
%             Y3.Data = normalize(Y3.Data,'mean');
%             Y3.Unit = 'mean';
%             save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
            
            
            
%             % 40Hz version
%             % downsampling (bin-average)
%             Y3  = makeContinuousChannel(['l',EMG,'l(uV)lp20ds40Hz-bss'], 'resample', Y2, 40,1);
% %             save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
%             
%             % non-negative
%             Y3.Name = ['l',EMG,'l(uV)lp20ds40Hz-bss-nn'];
%             Y3.Data = max(0,Y3.Data);
% %             save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
%             
%             % normalize (mean)
%             Y3.Name = ['l',EMG,'l(mean)lp20ds40Hz-bss-nn'];
%             Y3.Data = normalize(Y3.Data,'mean');
%             Y3.Unit = 'mean';
%             save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
            
            
            % linear smoothing 100ms 100Hz version
            Y3  = makeContinuousChannel([EMG,'(uV)-ds1000Hz-bss-hp30Hz-rect-lp20Hz-ls100ms'],'linear smoothing',Y2,0.1);
            % downsampling
            Y3  = makeContinuousChannel([EMG,'(uV)-ds1000Hz-bss-hp30Hz-rect-lp20Hz-ls100ms-ds100Hz'], 'resample', Y3, 100,0);
%             save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
            
            % non-negative
            Y3.Name = [EMG,'(uV)-ds1000Hz-bss-hp30Hz-rect-lp20Hz-ls100ms-ds100Hz-nn'];
            Y3.Data = max(0,Y3.Data);
%             save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
            
            % normalize (mean)
            Y3.Name = [EMG,'(mean)-ds1000Hz-bss-hp30Hz-rect-lp20Hz-ls100ms-ds100Hz-nn'];
            Y3.Data = normalize(Y3.Data,'mean');
            Y3.Unit = 'mean';
            save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
            
            
            
%             % lEMGl(Hz)lp50ls25ds200Hz for NMF
%             Y2  = Y1;
%             Y2  = makeContinuousChannel([Name,'lp50'],'butter',Y2,'low', 2, 50);
%             Y2  = makeContinuousChannel([Name,'lp50ls25'],'linear smoothing',Y2,0.025);
%             Y2  = makeContinuousChannel([Name,'lp50ls25ds200Hz'], 'resample', Y2, 200);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));


%           

            clear('Y*','ch*');
        end
    end

end





%% 503
% EMG(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-trim(0-480s)-norm(mean)

CurrID  = 503;
if(any(ismember(CurrID,processID)))
    disp(CurrID)
    
    

    % FDIなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG=1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'(uV)-ds1000Hz-bss.mat']);
%         suffix      = '-ds1000Hz-bss';
        if(exist(filename,'file'))

            
            Y2     = load(filename);   
            
            % highpass filtering
            Y2  = makeContinuousChannel([Y2.Name,'-hp50Hz'], 'butter', Y2, 'high',  4, 50,'both');
                        
            % rectification
            Y2   = makeContinuousChannel([Y2.Name,'-rect'], 'rectify', Y2);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            % lowpass filtering
            % lEMGl(uV)lp20ds1000Hz
            Y2  = makeContinuousChannel([Y2.Name,'-lp20Hz'], 'butter', Y2, 'low',4,20,'both');
            havenans    = sum(isnan(Y2.Data));
            if(havenans>0)
                disp('DataにNaNがふくまれています')
            end
                        
            
            % linear smoothing 100ms 100Hz version
            Y2  = makeContinuousChannel([Y2.Name,'-ls100ms'],'linear smoothing',Y2,0.1);
            % downsampling
            Y2  = makeContinuousChannel([Y2.Name,'-ds100Hz'], 'resample', Y2, 100,0);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
             havenans    = sum(isnan(Y2.Data));
            if(havenans>0)
                disp('DataにNaNがふくまれています')
                keyboard
            end
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            
%             % subtraction noise offset (10% percentile)
%             Y2.Data = Y2.Data-prctile(Y2.Data,5);
%             Y2.Name = [Y2.Name,'-offset5prc'];
%             %             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
% 
            % non-negative
            Y2.Name = [Y2.Name,'-nn'];
            Y2.Data = max(0,Y2.Data);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));

            % trim data length [0 480] sec
            Y2.Name = [Y2.Name,'-trim(0-480s)'];
            
            TimeRange   = [0 480]; %sec
            XData   = ((1:length(Y2.Data))-1)/Y2.SampleRate;
            ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));
            TotalTime   = sum(ind)/Y2.SampleRate;
            Y2.TimeRange    = [TimeRange(1)+Y2.TimeRange(1),TimeRange(1)+Y2.TimeRange(1)+TotalTime];
            Y2.Data = Y2.Data(ind);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));            
            
% 
            % normalize (mean)
            Y2.Name = [Y2.Name,'-norm(mean)'];
            Y2.Data = normalize(Y2.Data,'mean');
            Y2.Unit = 'mean';

            save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,[Y2.Name,'.mat']));
            

            clear('Y*','ch*');
        end
    end
    
    
    
    % Total Torque(N).matも[0 480]secにtrim
    
    filename    = fullfile(pathname,'Total Torque(N).mat');
    Y2     = load(filename);
    
    Y2.Name = [Y2.Name,'-trim(0-480s)'];
    TimeRange   = [0 480]; %sec
    XData   = ((1:length(Y2.Data))-1)/Y2.SampleRate;
    ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));
    TotalTime   = sum(ind)/Y2.SampleRate;
    Y2.TimeRange    = [TimeRange(1)+Y2.TimeRange(1),TimeRange(1)+Y2.TimeRange(1)+TotalTime];
    Y2.Data = Y2.Data(ind);
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,[Y2.Name,'.mat']));

end



%% 504
% EMG(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-norm(mean)

CurrID  = 504;
if(any(ismember(CurrID,processID)))
    disp(CurrID)
    
    

    % FDIなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG=1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'(uV)-ds1000Hz-bss.mat']);
%         suffix      = '-ds1000Hz-bss';
        if(exist(filename,'file'))

            
            Y2     = load(filename);   
            
            % highpass filtering
            Y2  = makeContinuousChannel([Y2.Name,'-hp50Hz'], 'butter', Y2, 'high',  4, 50,'both');
                        
            % rectification
            Y2   = makeContinuousChannel([Y2.Name,'-rect'], 'rectify', Y2);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            % lowpass filtering
            % lEMGl(uV)lp20ds1000Hz
            Y2  = makeContinuousChannel([Y2.Name,'-lp20Hz'], 'butter', Y2, 'low',4,20,'both');
            havenans    = sum(isnan(Y2.Data));
            if(havenans>0)
                disp('DataにNaNがふくまれています')
            end
                        
            
            % linear smoothing 100ms 100Hz version
            Y2  = makeContinuousChannel([Y2.Name,'-ls100ms'],'linear smoothing',Y2,0.1);
            % downsampling
            Y2  = makeContinuousChannel([Y2.Name,'-ds100Hz'], 'resample', Y2, 100,0);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
             havenans    = sum(isnan(Y2.Data));
            if(havenans>0)
                disp('DataにNaNがふくまれています')
                keyboard
            end
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            
%             % subtraction noise offset (10% percentile)
%             Y2.Data = Y2.Data-prctile(Y2.Data,5);
%             Y2.Name = [Y2.Name,'-offset5prc'];
%             %             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
% 
            % non-negative
            Y2.Name = [Y2.Name,'-nn'];
            Y2.Data = max(0,Y2.Data);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));

% % %             % trim data length [0 480] sec
% % %             Y2.Name = [Y2.Name,'-trim(0-480s)'];
% % %             
% % %             TimeRange   = [0 480]; %sec
% % %             XData   = ((1:length(Y2.Data))-1)/Y2.SampleRate;
% % %             ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));
% % %             TotalTime   = sum(ind)/Y2.SampleRate;
% % %             Y2.TimeRange    = [TimeRange(1)+Y2.TimeRange(1),TimeRange(1)+Y2.TimeRange(1)+TotalTime];
% % %             Y2.Data = Y2.Data(ind);
% % % %             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));            
% % %             
% 
            % normalize (mean)
            Y2.Name = [Y2.Name,'-norm(mean)'];
            Y2.Data = normalize(Y2.Data,'mean');
            Y2.Unit = 'mean';

            save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,[Y2.Name,'.mat']));
            

            clear('Y*','ch*');
        end
    end

end


%% 505
% Spike(Hz)

CurrID  = 505;
if(any(ismember(CurrID,processID)))
    disp(CurrID)
    
    
    Y1 = load(fullfile(pathname,'Spike'));
%     Y2 = makeContinuousChannel('Spike(Hz)-hist100Hz','histogram',Y1,100);
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
%     
%     % linear smoothing 100ms 100Hz version
%     Y2  = makeContinuousChannel('Spike(Hz)-hist100Hz-ls100ms','linear smoothing',Y2,0.1);
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
%     
%     
%     Y2  = makeContinuousChannel('Spike(Hz)-hist100Hz-ks100ms', 'spike kernel smoothing', Y1, 100, 0.1);
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
%     
%     
%     Y2  = makeContinuousChannel('Spike(Hz)-hist100Hz-ks50ms', 'spike kernel smoothing', Y1, 100, 0.05);
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    
%     Y2  = makeContinuousChannel('Spike(Hz)-hist100Hz-ks20ms', 'spike kernel smoothing', Y1, 100, 0.02);
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
    
%     Y2  = makeContinuousChannel('Spike(Hz)-hist100Hz-ks10ms', 'spike kernel smoothing', Y1, 100, 0.01);
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
%     
%     
    Y2  = makeContinuousChannel('Spike(Hz)-hist100Hz','histogram',Y1,100);
    Y2  = makeContinuousChannel('Spike(Hz)-hist100Hz-lp20Hz', 'butter', Y2, 'low',4,20,'both');
    havenans    = sum(isnan(Y2.Data));
    if(havenans>0)
        disp('DataにNaNがふくまれています')
    end
%     save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
%     
    Y2  = makeContinuousChannel('Spike(Hz)-hist100Hz-lp20Hz-ls100ms','linear smoothing',Y2,0.1);
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
%     
%     
%     
%
% Y2  = makeContinuousChannel([Y2.Name,'-lp20Hz'], 'butter', Y2, 'low',4,20,'both');
% havenans    = sum(isnan(Y2.Data));
% if(havenans>0)
%     disp('DataにNaNがふくまれています')
% end



% linear smoothing 10ms 100Hz version
% Y3  = makeContinuousChannel([Y2.Name,'-ls100ms'],'linear smoothing',Y2,0.1);
% save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));

    
    clear('Y*')

end



%% 506

% EMG(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-norm(mean)-NMF03-residual-meanW.mat
% EMG(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-norm(mean)-NMF04-residual-meanW.mat


CurrID  = 506;
if(any(ismember(CurrID,processID)))
    disp(CurrID)
    
     % FDIなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG=1:nEMG
        EMG = EMGs{iEMG};
        
        
% % %         filename1   = fullfile(pathname,[EMG,'(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-norm(mean).mat']);
        filename1   = fullfile(pathname,[EMG,'(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-trim(0-480s)-norm(mean).mat']);
        
        
        if(exist(filename1,'file'))
    
            Y1     = load(filename1);   

            
% % %             filename2   = fullfile(pathname,[EMG,'(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-norm(mean)-NMF03-reconst-meanW.mat']);
            filename2   = fullfile(pathname,[EMG,'(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-trim(0-480s)-norm(mean)-NMF03-reconst-meanW.mat']);

            if(exist(filename2,'file'))
                Y2     = load(filename2);   
                
% % %                 Y2.Name = [EMG,'(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-norm(mean)-NMF03-residual-meanW'];
                Y2.Name = [EMG,'(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-trim(0-480s)-norm(mean)-NMF03-residual-meanW'];

                Y2.Data = Y1.Data - Y2.Data;
                save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,[Y2.Name,'.mat']));
            end
            
            filename2   = fullfile(pathname,[EMG,'(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-norm(mean)-NMF04-reconst-meanW.mat']);
            if(exist(filename2,'file'))
                Y2     = load(filename2);   
                
                Y2.Name = [EMG,'(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-nn-norm(mean)-NMF04-residual-meanW'];
                Y2.Data = Y1.Data - Y2.Data;
                save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,[Y2.Name,'.mat']));
            end
            

            clear('Y*','ch*');
        end
    end


end



%% 601
% EMG-ds1000Hz

CurrID  = 601;
if(any(ismember(CurrID,processID)))
    disp(CurrID)
    
    
%     p_lp        = 2;
%     w_lp        = 20;   % Hz

    % FDIなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG=1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'.mat']);
        if(exist(filename,'file'))

            
            Y2     = load(fullfile(pathname,[EMG,'.mat']));    % rectified
            Name   = EMG;
            
            
            % EMG(uV)1000Hz
            Y2  = makeContinuousChannel([Name,'-ds1000Hz'], 'resample', Y2, 1000);
            save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,[Y2.Name,'.mat']));
            

            
            
            
%             % lEMGl(Hz)lp50ls25ds200Hz for NMF
%             Y2  = Y1;
%             Y2  = makeContinuousChannel([Name,'lp50'],'butter',Y2,'low', 2, 50);
%             Y2  = makeContinuousChannel([Name,'lp50ls25'],'linear smoothing',Y2,0.025);
%             Y2  = makeContinuousChannel([Name,'lp50ls25ds200Hz'], 'resample', Y2, 200);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));


%           

            clear('Y*','ch*');
        end
    end

end




%% 602
% EMG-ds1000Hz

CurrID  = 602;
if(any(ismember(CurrID,processID)))
    disp(CurrID)
    
%     TimeRange   = [0 360] %sec
    TimeRange   = [200 560] %sec
%     TimeRange   = [0 480] %sec

disp(TimeRange)
    

    % FDIなどunrectified EMGの名前を探す。
    
    EMGs    = findEMG(dirmat(pathname));
    nEMG    = length(EMGs);

    for iEMG=1:nEMG
        EMG = EMGs{iEMG};
        
        filename    = fullfile(pathname,[EMG,'-ds1000Hz-bss.mat']);
%         suffix      = '-ds1000Hz-bss';
        if(exist(filename,'file'))

            
            Y2     = load(filename);   
            
            % highpass filtering
            Y2  = makeContinuousChannel([Y2.Name,'-hp50Hz'], 'butter', Y2, 'high',  4, 50,'both');
                        
            % rectification
            Y2   = makeContinuousChannel([Y2.Name,'-rect'], 'rectify', Y2);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            % lowpass filtering
            % lEMGl(uV)lp20ds1000Hz
            Y2  = makeContinuousChannel([Y2.Name,'-lp20Hz'], 'butter', Y2, 'low',4,20,'both');
            havenans    = sum(isnan(Y2.Data));
            if(havenans>0)
                disp('DataにNaNがふくまれています')
            end
                        
            
            % linear smoothing 100ms 100Hz version
            Y2  = makeContinuousChannel([Y2.Name,'-ls100ms'],'linear smoothing',Y2,0.1);
            % downsampling
            Y2  = makeContinuousChannel([Y2.Name,'-ds100Hz'], 'resample', Y2, 100,0);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
             havenans    = sum(isnan(Y2.Data));
            if(havenans>0)
                disp('DataにNaNがふくまれています')
                keyboard
            end
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
            
%             % subtraction noise offset (10% percentile)
%             Y2.Data = Y2.Data-prctile(Y2.Data,5);
%             Y2.Name = [Y2.Name,'-offset5prc'];
%             %             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));
% 
            % non-negative
            Y2.Name = [Y2.Name,'-nn'];
            Y2.Data = max(0,Y2.Data);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));

            % trim data length [0 480] sec
            Y2.Name = [Y2.Name,'-trim(',num2str(0),'-',num2str(TimeRange(2)-TimeRange(1)),'s)'];
            
%             TimeRange   = [0 360]; %sec
            XData   = ((1:length(Y2.Data))-1)/Y2.SampleRate;
            ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));
            TotalTime   = sum(ind)/Y2.SampleRate;
            Y2.TimeRange    = [TimeRange(1)+Y2.TimeRange(1),TimeRange(1)+Y2.TimeRange(1)+TotalTime];
            Y2.Data = Y2.Data(ind);
%             save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,Y2.Name));            
            
% 
            % normalize (mean)
            Y2.Name = [Y2.Name,'-norm(mean)'];
            Y2.Data = normalize(Y2.Data,'mean');
            Y2.Unit = 'mean';

            save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,[Y2.Name,'.mat']));
            

            clear('Y*','ch*');
        end
    end
    
    
    
    % Total Torque(N).matも[0 480]secにtrim
    
    filename    = fullfile(pathname,'index.mat');
    Y2     = load(filename);
    
    Y2.Name = [Y2.Name,'-trim(',num2str(0),'-',num2str(TimeRange(2)-TimeRange(1)),'s)'];
%     TimeRange   = [0 480]; %sec
    XData   = ((1:length(Y2.Data))-1)/Y2.SampleRate;
    ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));
    TotalTime   = sum(ind)/Y2.SampleRate;
    Y2.TimeRange    = [TimeRange(1)+Y2.TimeRange(1),TimeRange(1)+Y2.TimeRange(1)+TotalTime];
    Y2.Data = Y2.Data(ind);
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,[Y2.Name,'.mat']));
    

    filename    = fullfile(pathname,'thumb.mat');
    Y2     = load(filename);
    
    Y2.Name = [Y2.Name,'-trim(',num2str(0),'-',num2str(TimeRange(2)-TimeRange(1)),'s)'];
%     TimeRange   = [0 480]; %sec
    XData   = ((1:length(Y2.Data))-1)/Y2.SampleRate;
    ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));
    TotalTime   = sum(ind)/Y2.SampleRate;
    Y2.TimeRange    = [TimeRange(1)+Y2.TimeRange(1),TimeRange(1)+Y2.TimeRange(1)+TotalTime];
    Y2.Data = Y2.Data(ind);
    save(fullfile(pathname,[Y2.Name,'.mat']),'-struct','Y2');disp(fullfile(pathname,[Y2.Name,'.mat']));

end





end

warning('on')
