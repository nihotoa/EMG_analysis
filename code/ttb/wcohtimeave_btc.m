function wcohtimeave_btc(TimeRange)


warning('off');
% --------------------------
% Set parameters

Sourcedir   = uigetdir(fullfile(datapath,'WCOH'),'WCOH file���ۑ����Ă���t�H���_��I�����Ă�������');
Expnames    = uiselect(dirdir(Sourcedir),1,'�ΏۂƂȂ�Experiment�t�H���_��I�����Ă��������B');

Tarfiles    = dirmat(fullfile(Sourcedir,Expnames{1}));
Tarfiles    = uiselect(Tarfiles,1,'Target�t�@�C�����t�@�C����I�����Ă��������B');
nTimeRange  = size(TimeRange,1);
Outputdir   = cell(nTimeRange,1);
for iTimeRange  =1:nTimeRange
Outputdir{iTimeRange}   = uigetdir(fullfile(datapath,'WCOHTIMEAVE'),['TimeRange',num2str(iTimeRange),'[',num2str(TimeRange(iTimeRange,:)),']�̂��߂̏o�͐�t�H���_��I�����Ă��������B']);
end
% --------------------------



nExp	= length(Expnames);
nTar	= length(Tarfiles);


for iExp=1:nExp
    Expname = Expnames{iExp};
    try
        disp([num2str(iExp),'/',num2str(nExp),' == ',Expname])

        for iTar =1:nTar
            Tarfile = Tarfiles{iTar};
            Tar     = load(fullfile(Sourcedir,Expname,Tarfile));

            S  = wcohtimeave(Tar,TimeRange);
            

            % save
            
            for iTimeRange  =1:nTimeRange
                OUTDIR      = fullfile(Outputdir{iTimeRange},Expname);
            if(~exist(OUTDIR,'dir'))
                mkdir(OUTDIR);
            end
                SS  = S(iTimeRange);
                Outputfile  = fullfile(OUTDIR,[SS.Name,'.mat']);
                save(Outputfile,'-struct','SS')
            end
            disp(['   ',num2str(iTar),'/',num2str(nTar),' -> ',Outputfile])
        end
    catch
        disp(['*** Error occured in ',Expname])
    end

end

warning('on')
