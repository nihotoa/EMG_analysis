function trace2wcoh_btc(ntrials_limit)
% trace2wcoh_btc(Outputdir)
% ex.
% trace2wcoh_btc('071106');

warning('off');
error(nargchk(1,1,nargin,'struct'))
if(length(ntrials_limit)==2)
    mintrials   = ntrials_limit(1);
    maxtrials   = ntrials_limit(2);
elseif(length(ntrials_limit)==1)
    mintrials   = ntrials_limit(1);
    maxtrials   = ntrials_limit(1);
end

% --------------------------
% Set parameters



Sourcedir   = uigetdir(fullfile(datapath,'STA'),'STA file���ۑ����Ă���t�H���_��I�����Ă�������');
Expnames    = uiselect(dirdir(Sourcedir),1,'�ΏۂƂȂ�Experiment�t�H���_��I�����Ă��������B');

Tarfiles    = dirmat(fullfile(Sourcedir,Expnames{1}));
Reffile     = uiselect(Tarfiles,1,'Reference�t�@�C����I�����Ă��������B');
Reffile     = Reffile{1};
Tarfiles    = uiselect(Tarfiles,1,'Target�t�@�C�����t�@�C����I�����Ă��������B');

Outputdir   = uigetdir(fullfile(datapath,'WCOH'),'�o�͐�t�H���_��I�����Ă��������B�K�v�Ȃ�쐬���Ă���I�����Ă��������B');

freqVec     = [1.25:1.25:100];   % Hz
sigma       = 0.128;            % sec



% keyboard
% --------------------------

% Tarfiles    = uiselect(Original_Tarfiles);
% uiwait(msgbox(Tarfiles,'�m�F','modal'));

if(~exist(Outputdir,'dir'))
    mkdir(Outputdir);
end

nExp	= length(Expnames);
nTar	= length(Tarfiles);

for iExp=1:nExp
    Expname = Expnames{iExp};
    try
        disp([num2str(iExp),'/',num2str(nExp),' == ',Expname])

        

        % load Ref
        Ref     = load(fullfile(Sourcedir,Expname,Reffile));
        RefData	= Ref.TrialData;
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
            disp([Expname,'�̃g���C�A�����i',num2str(ntrials),'�j���w�肵���ŏ��g���C�A�����i',num2str(mintrials),'�j�ɒB���Ă��Ȃ����߉�͍͂s���܂���ł����B'])
            continue;
        end

        if ntrials  > maxtrials % ntrials��maxtrial�ȉ��ɂ���B
%             rand('state',0) % �����_���őI�Ԃ��ǁA���������Z�b�g���o��悤�ɂ��Ă���Ƃ�������
%             ind     = randperm(ntrials);
%             ind     = ind(1:maxtrials);

            ind = [101:200]
        else
            ind = 1:ntrials;
        end
        nind    = length(ind);
        clear('Ref');pack;

        
        for iTar =1:nTar
            Tarfile = Tarfiles{iTar};
            Tar     = load(fullfile(Sourcedir,Expname,Tarfile));
            TarData	= Tar.TrialData;
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
            
            % wcoh�̎Z�o
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
            OUTDIR      = fullfile(Outputdir,Expname);
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
