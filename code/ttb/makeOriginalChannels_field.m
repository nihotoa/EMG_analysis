function makeOriginalChannels_field(pathname,processID)
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
if(nargin<1)
    pathname    = uigetdir(matpath,'Experimentを選択してください');
    processID   = 0;
elseif(nargin<2)
    processID   = 0;
end


%% 1
% Index Position(mm)
% Thumb Position(mm)


if(any(ismember([1,0],processID)))
    disp(1)
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
    save(fullfile(pathname,Y1.Name),'-struct','Y1');
    save(fullfile(pathname,Y2.Name),'-struct','Y2');

    % clear
    clear('ch1','ch2','Y1','Y2');
    %pack;
end
%% 2
% Index Torque(N)
% Thumb Torque(N)
% Total Torque(N)
% Total deriv Torque(Nps)

if(any(ismember([2,0],processID)))
    disp(2)
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
    save(fullfile(pathname,Y1.Name),'-struct','Y1');
    save(fullfile(pathname,Y2.Name),'-struct','Y2');
    save(fullfile(pathname,Y3.Name),'-struct','Y3');
    save(fullfile(pathname,Y4.Name),'-struct','Y4');

    % clear
    clear('ch1','ch2','Y1','Y2','Y3','Y4');
    %pack;
end
%% 3
%   Field 1 (OB) and/or Field 2 (OB)

if(any(ismember([3,0],processID)))
    disp(3)
    th  = 4;    % V

    % Field 1 (OB) Only
    if(exist(fullfile(pathname,'Field 1.mat'),'file') && ~exist(fullfile(pathname,'Field 2.mat'),'file'))
        disp('Field 1 Only')
        ch1 = load(fullfile(pathname,'Field 1.mat'));
        Y1  = makeTimestampChannel('Field 1 (OB)', 'threshold', ch1, th, (-1)*th);

        save(fullfile(pathname,Y1.Name),'-struct','Y1');
        clear('ch1','Y1');
        %pack;
    end

    % Field 2 (OB) Only
    if(~exist(fullfile(pathname,'Field 1.mat'),'file') && exist(fullfile(pathname,'Field 2.mat'),'file'))
        disp('Field 2 Only')
        ch1 = load(fullfile(pathname,'Field 2.mat'));
        Y1  = makeTimestampChannel('Field 2 (OB)', 'threshold', ch1, th, (-1)*th);

        save(fullfile(pathname,Y1.Name),'-struct','Y1');
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

        save(fullfile(pathname,Y1.Name),'-struct','Y1');
        save(fullfile(pathname,Y2.Name),'-struct','Y2');
        clear('ch1','ch2','Y1','Y2');
        %pack;
    end
end
%% 4
% % Trial Interval
% % Trial Interval (success)
% % Trial Interval (success valid)
% % Trial Interval (svwostim)

if(any(ismember([4,0],processID)))
    disp(4)
    % Field 1 (OB) Only
    if(exist(fullfile(pathname,'Field 1.mat'),'file') && ~exist(fullfile(pathname,'Field 2.mat'),'file'))

        ch1 = load(fullfile(pathname,'OutT1 On.mat'));
        ch2 = load(fullfile(pathname,'OutT2 Off.mat'));
        ch3 = load(fullfile(pathname,'Success.mat'));
        ch4 = load(fullfile(pathname,'Field 1 (OB)'));
        ch5 = load(fullfile(pathname,'Stim pulse.mat'));

        Y1  = makeIntervalChannel('Trial Interval',ch1,ch2);
        if(size(Y1.Data,2)==1)                        %  最初と最後のトライアルを捨てる(PSTHやWCOHをする際のマージンをとっておくため)
            Y1.Data(:,1)=[];
        elseif(size(Y1.Data,2)>1)
            Y1.Data(:,end)=[];
            Y1.Data(:,1)=[];
        end

        Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y1, ch3, -1);
        Y3  = filterIntervalChannel('Trial Interval (success valid)', '~timestamp occurred', Y2, ch4);
        Y4  = filterIntervalChannel('Trial Interval (svwostim)', '~timestamp occurred', Y3, ch5);

        save(fullfile(pathname,Y1.Name),'-struct','Y1');
        save(fullfile(pathname,Y2.Name),'-struct','Y2');
        save(fullfile(pathname,Y3.Name),'-struct','Y3');
        save(fullfile(pathname,Y4.Name),'-struct','Y4');
        clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
        %pack;
    end

    % Field 2 (OB) Only
    if(~exist(fullfile(pathname,'Field 1.mat'),'file') && exist(fullfile(pathname,'Field 2.mat'),'file'))

        ch1 = load(fullfile(pathname,'OutT1 On.mat'));
        ch2 = load(fullfile(pathname,'OutT2 Off.mat'));
        ch3 = load(fullfile(pathname,'Success.mat'));
        ch4 = load(fullfile(pathname,'Field 2 (OB)'));
        ch5 = load(fullfile(pathname,'Stim pulse.mat'));

        Y1  = makeIntervalChannel('Trial Interval',ch1,ch2);
        if(size(Y1.Data,2)==1)                        %  最初と最後のトライアルを捨てる(PSTHやWCOHをする際のマージンをとっておくため)
            Y1.Data(:,1)=[];
        elseif(size(Y1.Data,2)>1)
            Y1.Data(:,end)=[];
            Y1.Data(:,1)=[];
        end

        Y2  = filterIntervalChannel('Trial Interval (success)', 'timestamp occurred', Y1, ch3, -1);
        Y3  = filterIntervalChannel('Trial Interval (success valid)', '~timestamp occurred', Y2, ch4);
        Y4  = filterIntervalChannel('Trial Interval (svwostim)', '~timestamp occurred', Y3, ch5);

        save(fullfile(pathname,Y1.Name),'-struct','Y1');
        save(fullfile(pathname,Y2.Name),'-struct','Y2');
        save(fullfile(pathname,Y3.Name),'-struct','Y3');
        save(fullfile(pathname,Y4.Name),'-struct','Y4');
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
        ch5 = load(fullfile(pathname,'Stim pulse.mat'));

        Y1  = makeIntervalChannel('Trial Interval',ch1,ch2);
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

        save(fullfile(pathname,Y1.Name),'-struct','Y1');
        save(fullfile(pathname,Y2.Name),'-struct','Y2');
        save(fullfile(pathname,Y3.Name),'-struct','Y3');
        save(fullfile(pathname,Y4.Name),'-struct','Y4');
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

if(any(ismember([5,0],processID)))
    disp(5)
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
    % save(fullfile(pathname,T1.Name),'-struct','T1');
    T2  = makeTimestampChannel('Grip Onset candidate0', 'rising threshold', ch2, th2); % candidate0
    save(fullfile(pathname,T2.Name),'-struct','T2');
    % T2  = filterTimestampChannel('Grip Onset candidate1', 'timestamp occurred', T2, T1, [-0.5 0.5]);   % candidate1 detectorが近くにあるものだけ
    % save(fullfile(pathname,T2.Name),'-struct','T2');
    T2  = filterTimestampChannel('Grip Onset candidate3', 'timestamp occurred', T2, ch3, [-0.5 1.0]);  % candidate3　CentT Enter Onが近くにあるものだけ
    save(fullfile(pathname,T2.Name),'-struct','T2');

    T2  = filterTimestampChannel('Grip Onset candidate2', '~timestamp occurred', T2, T2, [-1.0 -0.001]);   % candidate2  直前にほかのcandidateがないものだけ
    save(fullfile(pathname,T2.Name),'-struct','T2');
    % T2  = filterTimestampChannel('Grip Onset candidate4', 'timestamp occurred', T2, ch4, [-1.25 0.5]);  % candidate3　Out1 Offが近くにあるものだけ
    % save(fullfile(pathname,T2.Name),'-struct','T2');

    Y1  = filterTimestampChannel('Grip Onset', 'within interval', T2, ch5);
    Y1  = filterTimestampChannel('Grip Onset', '~timestamp occurred', Y1, Y1, [-2.0 -0.001]);   % within interval filterをかけた後もう一度直前にほかのcandidateがないものだけ＝各トライアル中には１つのtimestampだけにする。
    Y2  = filterTimestampChannel('Grip Onset (success)', 'within interval', T2, ch6);
    Y3  = filterTimestampChannel('Grip Onset (success valid)', 'within interval', T2, ch7);
    Y4  = filterTimestampChannel('Grip Onset (svwostim)', 'within interval', T2, ch8);

    save(fullfile(pathname,Y1.Name),'-struct','Y1');
    save(fullfile(pathname,Y2.Name),'-struct','Y2');
    save(fullfile(pathname,Y3.Name),'-struct','Y3');
    save(fullfile(pathname,Y4.Name),'-struct','Y4');
    % clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T1','T2','Y1','Y2','Y3','Y4');
    clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','th1','th2','T2','Y1','Y2','Y3','Y4');
    % %pack;
end
%% 6
% Release Onset
% Release Onset (success)
% Release Onset (success valid)
% Release Onset (svwostim)

if(any(ismember([6,0],processID)))
    disp(6)
    ch1 = load(fullfile(pathname,'Total deriv Torque(Nps)'));
    ch2 = load(fullfile(pathname,'OutT2 Enter On'));
    ch3 = load(fullfile(pathname,'CentT Off'));

    ch4 = load(fullfile(pathname,'Trial Interval'));
    ch5 = load(fullfile(pathname,'Trial Interval (success)'));
    ch6 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch7 = load(fullfile(pathname,'Trial Interval (svwostim)'));

    th1 = -2;         % Nps


    T2  = makeTimestampChannel('Release Onset candidate0', 'falling threshold', ch1, th1); % candidate0
    save(fullfile(pathname,T2.Name),'-struct','T2');

    T2  = filterTimestampChannel('Release Onset candidate1', 'timestamp occurred', T2, ch2, [-0.5 1.0]);  % candidate3　OutT2 Enter Onが直後にあるものだけ
    save(fullfile(pathname,T2.Name),'-struct','T2');

    T2  = filterTimestampChannel('Release Onset candidate2', '~timestamp occurred', T2, T2, [-1.0 -0.001]);   % candidate2  直前にほかのcandidateがないものだけ
    save(fullfile(pathname,T2.Name),'-struct','T2');

    %     T2  = filterTimestampChannel('Release Onset candidate3', 'timestamp occurred', T2, ch3, [-1.25 0.5]);  % candidate3　Out1 Offが近くにあるものだけ
    %     save(fullfile(pathname,T2.Name),'-struct','T2');

    Y1  = filterTimestampChannel('Release Onset', 'within interval', T2, ch4);
    Y1  = filterTimestampChannel('Release Onset', '~timestamp occurred', Y1, Y1, [-3 -0.001]);   % within interval filterをかけた後もう一度直前にほかのcandidateがないものだけ
    Y2  = filterTimestampChannel('Release Onset (success)', 'within interval', T2, ch5);
    Y3  = filterTimestampChannel('Release Onset (success valid)', 'within interval', T2, ch6);
    Y4  = filterTimestampChannel('Release Onset (svwostim)', 'within interval', T2, ch7);

    save(fullfile(pathname,Y1.Name),'-struct','Y1');
    save(fullfile(pathname,Y2.Name),'-struct','Y2');
    save(fullfile(pathname,Y3.Name),'-struct','Y3');
    save(fullfile(pathname,Y4.Name),'-struct','Y4');
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

if(any(ismember([7,0],processID)))
    disp(7)
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

    save(fullfile(pathname,Y1.Name),'-struct','Y1');
    save(fullfile(pathname,Y2.Name),'-struct','Y2');
    save(fullfile(pathname,Y3.Name),'-struct','Y3');
    save(fullfile(pathname,Y4.Name),'-struct','Y4');
    save(fullfile(pathname,Y5.Name),'-struct','Y5');
    save(fullfile(pathname,Y6.Name),'-struct','Y6');
    save(fullfile(pathname,Y7.Name),'-struct','Y7');
    save(fullfile(pathname,Y8.Name),'-struct','Y8');
    save(fullfile(pathname,Y9.Name),'-struct','Y9');
    save(fullfile(pathname,Y10.Name),'-struct','Y10');
    save(fullfile(pathname,Y11.Name),'-struct','Y11');
    save(fullfile(pathname,Y12.Name),'-struct','Y12');

    clear('ch1','ch2','ch3','ch4','ch5','ch6','ch7','ch8','ch9','ch10','ch11','ch12''Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','Y11','Y12');
    % %pack;
end
%% 8
% Trial Start
% Trial Start (success)
% Trial Start (success valid)
% Trial Start (svwostim)

if(any(ismember([8,0],processID)))
    disp(8)
    ch1 = load(fullfile(pathname,'OutT1 Enter On'));

    ch2 = load(fullfile(pathname,'Trial Interval'));
    ch3 = load(fullfile(pathname,'Trial Interval (success)'));
    ch4 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch5 = load(fullfile(pathname,'Trial Interval (svwostim)'));

    Y1  = filterTimestampChannel('Trial Start', 'within interval', ch1, ch2);
    Y2  = filterTimestampChannel('Trial Start (success)', 'within interval', ch1, ch3);
    Y3  = filterTimestampChannel('Trial Start (success valid)', 'within interval', ch1, ch4);
    Y4  = filterTimestampChannel('Trial Start (svwostim)', 'within interval', ch1, ch5);

    save(fullfile(pathname,Y1.Name),'-struct','Y1');
    save(fullfile(pathname,Y2.Name),'-struct','Y2');
    save(fullfile(pathname,Y3.Name),'-struct','Y3');
    save(fullfile(pathname,Y4.Name),'-struct','Y4');
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    % %pack;
end
%% 9
% Go Onset
% Go Onset (success)
% Go Onset (success valid)
% Go Onset (svwostim)

if(any(ismember([9,0],processID)))
    disp(9)
    ch1 = load(fullfile(pathname,'CentT On'));

    ch2 = load(fullfile(pathname,'Trial Interval'));
    ch3 = load(fullfile(pathname,'Trial Interval (success)'));
    ch4 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch5 = load(fullfile(pathname,'Trial Interval (svwostim)'));

    Y1  = filterTimestampChannel('Go Onset', 'within interval', ch1, ch2);
    Y2  = filterTimestampChannel('Go Onset (success)', 'within interval', ch1, ch3);
    Y3  = filterTimestampChannel('Go Onset (success valid)', 'within interval', ch1, ch4);
    Y4  = filterTimestampChannel('Go Onset (svwostim)', 'within interval', ch1, ch5);

    save(fullfile(pathname,Y1.Name),'-struct','Y1');
    save(fullfile(pathname,Y2.Name),'-struct','Y2');
    save(fullfile(pathname,Y3.Name),'-struct','Y3');
    save(fullfile(pathname,Y4.Name),'-struct','Y4');
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    % %pack;
end
%% 10
% EndHold
% EndHold (success)
% EndHold (success valid)
% EndHold (svwostim)

if(any(ismember([10,0],processID)))
    disp(10)
    ch1 = load(fullfile(pathname,'CentT Off'));

    ch2 = load(fullfile(pathname,'Trial Interval'));
    ch3 = load(fullfile(pathname,'Trial Interval (success)'));
    ch4 = load(fullfile(pathname,'Trial Interval (success valid)'));
    ch5 = load(fullfile(pathname,'Trial Interval (svwostim)'));

    Y1  = filterTimestampChannel('EndHold', 'within interval', ch1, ch2);
    Y2  = filterTimestampChannel('EndHold (success)', 'within interval', ch1, ch3);
    Y3  = filterTimestampChannel('EndHold (success valid)', 'within interval', ch1, ch4);
    Y4  = filterTimestampChannel('EndHold (svwostim)', 'within interval', ch1, ch5);

    save(fullfile(pathname,Y1.Name),'-struct','Y1');
    save(fullfile(pathname,Y2.Name),'-struct','Y2');
    save(fullfile(pathname,Y3.Name),'-struct','Y3');
    save(fullfile(pathname,Y4.Name),'-struct','Y4');
    clear('ch1','ch2','ch3','ch4','ch5','Y1','Y2','Y3','Y4');
    % %pack;
end

warning('on')