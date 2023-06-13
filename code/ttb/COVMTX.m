function COVMTX(maxlag,TimeRange)
% maxlag in sec
if nargin < 1
    maxlag          = 0;
    TimeRange       = [-inf inf];
elseif nargin < 2
    TimeRange       = [-inf inf];
end
alpha   = 0.05;
contents    = uiselect({'corr','xcorr','stepwise_corr'},1,'解析内容の選択');
keyboard
[Ref,Reffile]   = topen('Reference file(TrialData付きSTA)を選択してください。');
keyboard
[Tar,Tarfile]   = topen('Target file(TrialData付きSTA)を選択してください。');

if(~(Ref.nTrials==Tar.nTrials))
    disp('データ数が違います！！')
    return;
else
    nTrials = Ref.nTrials;
end

[OutputFile,prefix,suffix]  = autolabel({Reffile,Tarfile});
OutputFile  = getfileparts([prefix,suffix],'file');

[OutputFile,OutputDir]  = uiputfile(fullfile(datapath,'COVMTX',['COVMTX',OutputFile(4:end),'.mat']),'出力ファイルを選択してください。');


clear('S');

S.Name          = deext(OutputFile);
S.Unit          = Tar.Unit;
S.diff3_flag    = false;
S.OneToOne_flag = false;
S.TimeRange     = Tar.TimeRange;
S.maxlag        = maxlag;
S.AnalysisType  = 'COVMTX';
S.TargetName    = getfileparts(Tarfile,'file');
S.ReferenceName = getfileparts(Reffile,'file');

ind     = (Tar.XData >= TimeRange(1) & Tar.XData <= TimeRange(2));

RefYData    = Ref.YData(ind)';
TarYData    = Tar.YData(ind)';  


if(any(ismember(contents,'corr')))
    % 共分散および相関係数行列(corr)
    X           = [RefYData,TarYData];
    S.cov       = cov(zscore(X));
        
    [S.corrcoef,S.corrcoefP,S.corrcoefLO,S.corrcoefUP]  = corrcoef(X,'alpha',alpha,'rows','complete');
    
    S.corrcoefH     = S.corrcoefP < alpha;
    S.corrcoefN     = sum(all(~isnan(X),2));
    S.corrcoefUPLim = t2r(tinv(1-alpha/2,S.corrcoefN-2),S.corrcoefN);
    S.corrcoefLOLim = - S.corrcoefUPLim;
    
    disp('corr')
end

if(any(ismember(contents,'xcorr')))
%     
%     % 相互相関係数行列
    % 両端をNaNで補完する
    maxlagind   = round(maxlag * Tar.SampleRate);
    lagind      = (-maxlagind):maxlagind;
    lag         =  lagind / Tar.SampleRate;
    nlag        = length(lag);
    datalength  = size(RefYData,1);
    
    S.xcorr      = zeros(1,nlag);
    S.xcorrP     = zeros(1,nlag);
    S.xcorrH     = false(1,nlag);
    S.xcorrLO    = zeros(1,nlag);
    S.xcorrUP    = zeros(1,nlag);
    S.xcorrN     = zeros(1,nlag);
    S.xcorrLOLim = zeros(1,nlag);
    S.xcorrUPLim = zeros(1,nlag);
    
    X20 = [nan(maxlagind,1);TarYData;nan(maxlagind,1)];
    for ilag = 1:nlag
        X1  = RefYData;
        X2  = X20(ilag:(ilag+datalength-1));
        [temp,tempP,tempLO,tempUP]  = corrcoef(X2,X1,'alpha',alpha,'rows','complete');
        S.xcorr(ilag)   = temp(1,2);
        S.xcorrP(ilag)  = tempP(1,2);
        S.xcorrH(ilag)  = S.xcorrP(ilag) < alpha;
        S.xcorrLO(ilag) = tempLO(1,2);
        S.xcorrUP(ilag) = tempUP(1,2);
        S.xcorrN(ilag)  = sum(~isnan(X2) & ~isnan(X1));
        S.xcorrUPLim(ilag) = t2r(tinv(1-alpha/2,S.xcorrN(ilag)-2),S.xcorrN(ilag));
        S.xcorrLOLim(ilag) = - S.xcorrUPLim(ilag);
        
    end

    S.xcorrlag      = lag;  % ch1がlag(i)分遅く起こったときのch2との相関係数がS.xcorr(:,i)に入っている。
%     S.xcorrlaghelp  = 'Reference(ex Spike)がlag(ii)分遅く起こったときのTarget(ex EMG)との相関係数がS.xcorr(1,ii)に入っている。';
    S.xcorrlaghelp  = 'Target(ex EMG)がlag(ii)分早く起こったときのReference(ex Spike)との相関係数がS.xcorr(1,ii)に入っている。';

    S.xcorrRmax     = 0;
    S.xcorrRmaxlag  = 0;
    S.xcorrRmaxP    = 0;
    S.xcorrRmaxH    = false;

    [temp,xcorrRmaxind] = max(abs(S.xcorr));
    S.xcorrRmax     = S.xcorr(xcorrRmaxind);
    S.xcorrRmaxlag  = S.xcorrlag(xcorrRmaxind);
    S.xcorrRmaxP    = S.xcorrP(xcorrRmaxind);
    S.xcorrRmaxH    = S.xcorrH(xcorrRmaxind);
    disp('xcorr')    
    
end

if(any(ismember(contents,'stepwise_corr')))

    nperms  = 1000;
    rand('state',0);% ランダムで選ぶけど、いつも同じセットが出るようにしているということ

    Refdatfile      = fullfile(getfileparts(Reffile,'path'),['._',getfileparts(Reffile,'file'),'.mat']);
    RefTrialData    = load(Refdatfile,'TrialData');
    RefTrialData    = RefTrialData.TrialData;
    if(isfield(Ref,'Weights'))
        RefTrialData= (RefTrialData.*repmat(shiftdim(Ref.Weights),1,size(RefTrialData,2)))';
    else
        RefTrialData= RefTrialData';
    end
    Tardatfile      = fullfile(getfileparts(Tarfile,'path'),['._',getfileparts(Tarfile,'file'),'.mat']);
    TarTrialData    = load(Tardatfile,'TrialData');
    TarTrialData    = TarTrialData.TrialData;
    if(isfield(Tar,'Weights'))
        TarTrialData= (TarTrialData.*repmat(shiftdim(Tar.Weights),1,size(TarTrialData,2)))';
    else
        TarTrialData= TarTrialData';
    end
    S.sw_nperms     = nperms;
    S.sw_nTrials    = nTrials;
    S.sw_corrcoef   = zeros(nperms,nTrials);

    for iperm   =1:nperms
        indicator(iperm,nperms,'stepwise_corr')
        order   = randperm(nTrials);
        for istep   =1:nTrials
            X   = [mean(RefTrialData(:,order(1:istep)),2),mean(TarTrialData(:,order(1:istep)),2)];
            temp    = corrcoef(X);
            S.sw_corrcoef(iperm,istep) = temp(1,2);
        end
    end
      indicator(0,0)
      
      disp('stepwise_corr')
end

save(fullfile(OutputDir,OutputFile),'-struct','S');
disp(fullfile(OutputDir,OutputFile))

warning('on');
end

%     % 相互相関係数行列
%     maxlagind   = round(maxlag * Tar.SampleRate);
%     lagind      = (-maxlagind):maxlagind;
%     lag         =  lagind / Tar.SampleRate;
%     nlag        = length(lag);
%     datalength  = size(RefYData,1) - maxlagind * 2;
% 
%     S.xcorr1     = zeros(1,nlag);
%     for ilag = 1:nlag
%         X1  = RefYData((maxlagind+1):(maxlagind+datalength));
%         X2  = TarYData(ilag:(ilag+datalength-1));
%         temp    = corrcoef(X2,X1,'rows','complete');
%         S.xcorr1(ilag) = temp(1,2);
%     end
% 
%     S.xcorrlag1      = lag;  % ch1がlag(i)分遅く起こったときのch2との相関係数がS.xcorr(:,i)に入っている。
% %     S.xcorrlaghelp  = 'Reference(ex Spike)がlag(ii)分遅く起こったときのTarget(ex EMG)との相関係数がS.xcorr(1,ii)に入っている。';
%     S.xcorrlaghelp1  = 'Target(ex EMG)がlag(ii)分早く起こったときのReference(ex Spike)との相関係数がS.xcorr(1,ii)に入っている。';
% 
%     S.xcorrPmax1     = 0;
%     S.xcorrPmaxlag1  = 0;
%     [temp,xcorrPmaxind] = max(abs(S.xcorr1));
%     S.xcorrPmax1     = S.xcorr1(xcorrPmaxind);
%     S.xcorrPmaxlag1  = S.xcorrlag1(xcorrPmaxind);
%     disp('xcorr1')
%     
%     % 両端をzeroで補完する
%     maxlagind   = round(maxlag * Tar.SampleRate);
%     lagind      = (-maxlagind):maxlagind;
%     lag         =  lagind / Tar.SampleRate;
%     nlag        = length(lag);
%     datalength  = size(RefYData,1);
%     
%     S.xcorr2     = zeros(1,nlag);
%     X20 = [zeros(maxlagind,1);TarYData;zeros(maxlagind,1)];
%     for ilag = 1:nlag
%         X1  = RefYData;
%         X2  = X20(ilag:(ilag+datalength-1));
%         temp    = corrcoef(X2,X1,'rows','complete');
%         S.xcorr2(ilag) = temp(1,2);
%     end
% 
%     S.xcorrlag2      = lag;  % ch1がlag(i)分遅く起こったときのch2との相関係数がS.xcorr(:,i)に入っている。
% %     S.xcorrlaghelp  = 'Reference(ex Spike)がlag(ii)分遅く起こったときのTarget(ex EMG)との相関係数がS.xcorr(1,ii)に入っている。';
%     S.xcorrlaghelp2  = 'Target(ex EMG)がlag(ii)分早く起こったときのReference(ex Spike)との相関係数がS.xcorr(1,ii)に入っている。';
% 
%     S.xcorrPmax2     = 0;
%     S.xcorrPmaxlag2  = 0;
%     [temp,xcorrPmaxind] = max(abs(S.xcorr2));
%     S.xcorrPmax2     = S.xcorr2(xcorrPmaxind);
%     S.xcorrPmaxlag2  = S.xcorrlag2(xcorrPmaxind);
%     disp('xcorr2')
%     
%     

%     % STAは短いのでバイアスのかかったxcorrで我慢する。
% 
%     maxlagind   = round(maxlag * Tar.SampleRate);
% 
%     [S.xcorr,lagind]   = xcorr(X(:,2)',X(:,1)',maxlagind,'coeff');
% %     if(size(S.xcorr,1)~=1)
% %         S.xcorr = S.xcorr';
% %     end
%     lag     =  lagind / Tar.SampleRate;
% 
%     S.xcorrlag      = lag;  % ch1がlag(i)分遅く起こったときのch2との相関係数がS.xcorr(:,i)に入っている。
%     S.xcorrlaghelp  = 'Reference(ex Spike)がlag(ii)分遅く起こったときのTarget(ex EMG)との相関係数がS.xcorr(1,ii)に入っている。';
% 
%     S.xcorrPmax     = 0;
%     S.xcorrPmaxlag  = 0;
%     [temp,xcorrPmaxind] = max(abs(S.xcorr));
%     S.xcorrPmax     = S.xcorr(xcorrPmaxind);
%     S.xcorrPmaxlag  = S.xcorrlag(xcorrPmaxind);
%     disp('xcorr')
