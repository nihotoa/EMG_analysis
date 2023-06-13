function trace2wcoh_btc(ntrials_limit)
% trace2wcoh_btc([mintrials maxtrials])
% ex.
% trace2wcoh_btc([100 100]);


% ----------------------------------
% Parameter Settings

freqVec     = [1.25:1.25:100];   % Hz
sigma       = 0.128;            % sec

% ----------------------------------



warning('off');
error(nargchk(1,1,nargin,'struct'))
if(length(ntrials_limit)==1)
    mintrials   = ntrials_limit(1);
    maxtrials   = ntrials_limit(1);
    TrialsToUse = [];
elseif(length(ntrials_limit)==2)
    mintrials   = ntrials_limit(1);
    maxtrials   = ntrials_limit(2);
    TrialsToUse = [];
else
    mintrials   = length(ntrials_limit);
    maxtrials   = length(ntrials_limit);
    TrialsToUse = ntrials_limit;
end

% --------------------------
% Set parameters


SourceDir   = getconfig(mfilename,'SourceDir');
try
    if(~exist(SourceDir,'dir'));
        SourceDir   = pwd;
    end
catch
    SourceDir   = pwd;
end
SourceDir   = uigetdir(SourceDir,'STA fileが保存してあるフォルダを選択してください');
if(SourceDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'SourceDir',SourceDir);
end



Expnames    = uiselect(dirdir(SourceDir),1,'対象となるExperimentフォルダを選択してください。');

Tarfiles    = dirmat(fullfile(SourceDir,Expnames{1}));
Tarfiles    = strfilt(Tarfiles,'~._');
Reffile     = uiselect(Tarfiles,1,'Referenceファイルを選択してください(一つ)。');
Reffile     = Reffile{1};
Tarfiles    = uiselect(Tarfiles,1,'Targetファイルをファイルを選択してください（複数選択可）。');

OutputDir   = getconfig(mfilename,'OutputDir');
try
    if(~exist(OutputDir,'dir'));
        OutputDir   = pwd;
    end
catch
    OutputDir   = pwd;
end
OutputDir   = uigetdir(OutputDir,'出力先フォルダを選択してください。必要なら作成してから選択してください。');
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end





% keyboard
% --------------------------
disp(['SourceDir: ',SourceDir])
disp(['OutputDir: ',OutputDir])
% Tarfiles    = uiselect(Original_Tarfiles);
% uiwait(msgbox(Tarfiles,'確認','modal'));

if(~exist(OutputDir,'dir'))
    mkdir(OutputDir);
end

nExp	= length(Expnames);
nTar	= length(Tarfiles);

for iExp=1:nExp
    Expname = Expnames{iExp};
    try
        disp([num2str(iExp),'/',num2str(nExp),' == ',Expname])

        

        % load Ref
        Ref     = load(fullfile(SourceDir,Expname,Reffile));
        
        if(exist(fullfile(SourceDir,Expname,['._',Reffile]),'file'))
            RefData = load(fullfile(SourceDir,Expname,['._',Reffile]),'TrialData');
            RefData = RefData.TrialData;
        else %old sta format
            RefData	= Ref.TrialData;
        end
        
        RefName = Ref.TargetName;
        timeVec = Ref.XData;
        Fs      = Ref.SampleRate;
        ntrials = size(RefData,1);

        TriggerName   = Ref.ReferenceName;
        TimeRange     = Ref.TimeRange;
        if(isfield(Ref,'UseExpSet_flag'))
            UseExpSet_flag  = 1;
            Expset          = Ref.Expset;
            ExpSet_ntrials  = Ref.ExpSet_ntrials;
        else
            UseExpSet_flag  = 0;
        end
        
        if(ntrials<mintrials)   % mintrials
            disp([Expname,'のトライアル数（',num2str(ntrials),'）が指定した最小トライアル数（',num2str(mintrials),'）に達していないため解析は行われませんでした。'])
            continue;
        end
        
        if(isempty(TrialsToUse))
            if ntrials  > maxtrials % ntrialsをmaxtrial以下にする。
                rand('state',0) % ランダムで選ぶけど、いつも同じセットが出るようにしているということ
                ind     = randperm(ntrials);
                ind     = ind(1:maxtrials);
            else
                ind = 1:ntrials;
            end
        else
            ind = TrialsToUse;
        end
        nind    = length(ind);
        clear('Ref');pack;

        
        for iTar =1:nTar
            Tarfile = Tarfiles{iTar};
            Tar     = load(fullfile(SourceDir,Expname,Tarfile));
            
            if(exist(fullfile(SourceDir,Expname,['._',Tarfile]),'file'))
                TarData = load(fullfile(SourceDir,Expname,['._',Tarfile]),'TrialData');
                TarData = TarData.TrialData;
            else %old sta format
                TarData	= Tar.TrialData;
            end
            
            TarName = Tar.TargetName;
            clear('Tar');pack;
            
            
            S.Name          = ['WCOH (',RefName,', ',TarName,')'];
            S.TriggerName   = TriggerName;
            S.ReferenceName = RefName;
            S.TargetName    = TarName;
            S.Class         = 'continuous channel';
            S.AnalysisType  = 'WCOH';
            S.TimeRange     = TimeRange;
            S.SampleRate    = Fs;
            S.nTrials       = nind;
            S.TrialsToUse   = ind;
            
            % wcohの算出
            [S.Cxy,txxx,fxxx,S.Pxx,S.Pyy,S.Pxy,S.Phi]   =trace2wcoh(RefData(ind,:),TarData(ind,:),freqVec,Fs,sigma);

            S.freqVec       = freqVec;
            S.timeVec       = timeVec;
            S.sigma         = sigma;
            S.c95           = cohcl(0.05,nind);
            S.Unit          = 'coh';            
            
            if(UseExpSet_flag==1)
                S.UseExpSet_flag    = UseExpSet_flag;
                S.Expset            = Expset;
                S.ExpSet_ntrials    = ExpSet_ntrials;
            end
            
            % save
            OUTDIR      = fullfile(OutputDir,Expname);
            if(~exist(OUTDIR,'dir'))
                mkdir(OUTDIR);
            end
            Outputfile  = fullfile(OUTDIR,[S.Name,'.mat']);
            save(Outputfile,'-struct','S')
            disp(['   ',num2str(iTar),'/',num2str(nTar),' -> ',Outputfile])
        end
    catch
        disp(['*** Error occured in ',Expname])
    end

end

warning('on')
