function trace2coh_btc(ntrials_limit,kknnherz,nfftPoints)
% trace2wcoh_btc(ntrials_limit,kknnherz,nfftPoints)
% ex.
% trace2wcoh_btc([100 100],[6.25 10],128)
% 
% kkherz  = 6.25;   % 128 fftpoints�Ȃ�3bin
% nnherz  = 10;     % 128 fftpoints�Ȃ�5bin
% kkherz  = 8;    % 128 fftpoints�Ȃ�4bin
% nnherz  = 12;   % 128 fftpoints�Ȃ�6bin
% kkherz  = 8;    % 128 fftpoints�Ȃ�4bin
% nnherz  = 10;   % 128 fftpoints�Ȃ�5bin
% kkherz  = 8;    % 128 fftpoints�Ȃ�4bin
% nnherz  = 8;   % 128 fftpoints�Ȃ�4bin

% ----------------------------------
% Parameter Settings

FOI     = [5 95];
% HUM     = [55 65];    % Eito, Aoba, Uma
HUM     = [45 55]; % Suu
% ----------------------------------


warning('off');
error(nargchk(3,3,nargin,'struct'))
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
SourceDir   = uigetdir(SourceDir,'STA file���ۑ����Ă���t�H���_��I�����Ă�������');
if(SourceDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'SourceDir',SourceDir);
end



Expnames    = uiselect(dirdir(SourceDir),1,'�ΏۂƂȂ�Experiment�t�H���_��I�����Ă��������B');

Tarfiles    = dirmat(fullfile(SourceDir,Expnames{1}));
Tarfiles    = strfilt(Tarfiles,'~._');
Reffile     = uiselect(Tarfiles,1,'Reference�t�@�C����I�����Ă�������(���)�B');
Reffile     = Reffile{1};
Tarfiles    = uiselect(Tarfiles,1,'Target�t�@�C�����t�@�C����I�����Ă��������i�����I���j�B');

OutputDir   = getconfig(mfilename,'OutputDir');
try
    if(~exist(OutputDir,'dir'));
        OutputDir   = pwd;
    end
catch
    OutputDir   = pwd;
end
OutputDir   = uigetdir(OutputDir,'�o�͐�t�H���_��I�����Ă��������B�K�v�Ȃ�쐬���Ă���I�����Ă��������B');
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end


kkherz  = kknnherz(1);
nnherz  = kknnherz(2);

% --------------------------

disp(['SourceDir: ',SourceDir])
disp(['OutputDir: ',OutputDir])


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
        

        nSegperTrial    = floor(length(timeVec)/nfftPoints);
        
        minSegs         = mintrials*nSegperTrial;    % �g���C�A�����Ƃ�Ƃ�Ȃ��̒P�ʂƂȂ��Ă���B
%         maxSegs         = maxtrials*nSegperTrial;
        
        
        if(ntrials<mintrials)   % minSegs
            disp([Expname,'�̃g���C�A�����i',num2str(ntrials),'�j���w�肵���ŏ��g���C�A�����i',num2str(mintrials),'=',num2str(minSegs),' FFT segments�j�ɒB���Ă��Ȃ����߉�͍͂s���܂���ł����B'])
            continue;
        end
        
        if(isempty(TrialsToUse))
            if ntrials  > maxtrials % ntrials��maxtrial�ȉ��ɂ���B
                rand('state',0) % �����_���őI�Ԃ��ǁA���������Z�b�g���o��悤�ɂ��Ă���Ƃ�������
                ind     = randperm(ntrials);
                ind     = ind(1:maxtrials);
            else
                ind = 1:ntrials;
            end
        else
            ind = TrialsToUse;
        end
        nind    = length(ind);
        
        RefData = RefData(ind,:);
        RefData = RefData(:,[1:nSegperTrial*nfftPoints])';
        RefData = reshape(RefData,nfftPoints,nind*nSegperTrial)';
        
        clear('Ref');

        
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
            
            TarData = TarData(ind,:);
            TarData = TarData(:,[1:nSegperTrial*nfftPoints])';
            TarData = reshape(TarData,nfftPoints,nind*nSegperTrial)';
        
            clear('Tar');
            
            
            S.Name          = ['COH (',RefName,', ',TarName,')'];
            S.TriggerName   = TriggerName;
            S.ReferenceName = RefName;
            S.TargetName    = TarName;
            S.Class         = 'continuous channel';
            S.AnalysisType  = 'COH';
            S.TimeRange     = TimeRange;
            S.SampleRate    = Fs;
            S.nTrials       = nind;
            S.nSegments     = nind*nSegperTrial;
            S.TrialsToUse   = ind;
            
            % coh�̎Z�o
%             [S.Cxy,txxx,fxxx,S.Pxx,S.Pyy,S.Pxy,S.Phi]   =trace2wcoh(RefData(ind,:),TarData(ind,:),freqVec,Fs,sigma);
            [S.Cxy,S.freqVec,S.Pxx,S.Pyy,S.X11,S.X22,S.X21,S.Phi]   = trace2coh(RefData,TarData,Fs);

            S.nfftPoints    = nfftPoints;
            S.c95           = cohcl(0.05,S.nSegments);
            S.Unit          = 'coh';            
            
            if(UseExpSet_flag==1)
                S.UseExpSet_flag    = UseExpSet_flag;
                S.Expset            = Expset;
                S.ExpSet_ntrials    = ExpSet_ntrials;
            end
            
            
            [S.sigind,S.clssig,S.kkherz,S.nnherz,S.FOI,S.HUM,S.isclust,S.maxclust,S.maxclustpeak,S.maxclustpeakfreq,S.maxclustpeakmean]  = sigcluster(S.freqVec,S.Cxy,S.c95,kkherz,nnherz,FOI,HUM);
            
            
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
