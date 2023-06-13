function sta_btc(TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag,OneToOne_flag,UseExpSets_flag,UseExcel_flag,RescaleXData_flag)
%   sta_btc(TimeWindow,StoreTrial_flag,ISA_flag[,nTrials][,OneToOne_flag][,UseExpSets_flag])

error(nargchk(3,9,nargin,'struct'))

if nargin<4
    RescaleXData_flag   = 0;
    UseExcel_flag   = 0;
    UseExpSets_flag = 0;
    OneToOne_flag   = 0;
    Smoothing_flag  = 0;
    maxtrials       = [1 Inf];
elseif nargin<5
    RescaleXData_flag   = 0;
    UseExcel_flag   = 0;
    UseExpSets_flag = 0;
    OneToOne_flag   = 0;
    Smoothing_flag  = 0;
elseif nargin<6
    RescaleXData_flag   = 0;
    UseExcel_flag   = 0;
    UseExpSets_flag = 0;
    OneToOne_flag   = 0;
elseif nargin<7
    RescaleXData_flag   = 0;
    UseExcel_flag   = 0;
    UseExpSets_flag = 0;
elseif nargin<8
    RescaleXData_flag   = 0;
    UseExcel_flag   = 0;
elseif nargin<9
    RescaleXData_flag   = 0;
end
if(StoreTrial_flag);disp('StoreTrial_flag');end
if(ISA_flag);disp('ISA_flag');end
if(Smoothing_flag);disp('Smoothing_flag');end
if(OneToOne_flag);disp('OneToOne_flag');end
if(UseExpSets_flag);disp('UseExpSets_flag');end
if(UseExcel_flag);disp('UseExel_flag');end
if(RescaleXData_flag);disp('RescaleXData_flag');end
disp(['maxtrials= ',num2str(maxtrials)]);


warning('off');


if(~UseExpSets_flag)            % 普通のsta
    if(~UseExcel_flag)
        ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
        if(ParentDir==0)
            disp('User pressed cancel.')
            return;
        end
        InputDirs   = dirdir(ParentDir);
        InputDirs   = uiselect(InputDirs,1,'対象となるExperimentを選択してください。');

        InputDir    = InputDirs{1};
        Tarfiles    = sortxls(dirmat(fullfile(ParentDir,InputDir)));
        Reffiles    = uiselect(Tarfiles,1,'Referenceファイルを選択してください（複数選択可）。');
        if(isempty(Reffiles))
            disp('User pressed cancel.')
            return;
        end
        Tarfiles    = uiselect(Tarfiles,1,'Targetファイルを選択してください（複数選択可）。');
        if(isempty(Tarfiles))
            disp('User pressed cancel.')
            return;
        end
        
        outdir      = uigetdir(fullfile(datapath,'STA'),'出力フォルダを選択してください。必要なら作成してください。');
        if(outdir==0)
            disp('User pressed cancel.')
            return;
        end
        if(RescaleXData_flag)
            ParentDirRSX =  uigetdir(datapath,'RescaleXData: rescaleに用いるPSTHデータが入っている親フォルダを選択してください。');
            RSXfile      = sortxls(dirmat(fullfile(ParentDirRSX,InputDir)));
            RSXfile      = strfilt(RSXfile,'PSTH ~._');
            RSXfile      = uichoice(RSXfile,'RescaleXData: rescaleに用いるPSTHデータを選択して下さい。');
        end

        if(OneToOne_flag)
            message = cell(size(Reffiles));
            for ii=1:length(Reffiles)
                message{ii} = [Reffiles{ii},'---',Tarfiles{ii}];
            end
            YN  = questdlg(message, ...
                'Check One-to-One', ...
                'OK','Cancel');
            if(strcmp(YN,'Cancel'))
                disp('Cancelled')
                return;
            end
        end


        for jj=1:length(InputDirs)
            try
                InputDir    = InputDirs{jj};
                for kk =1:length(Reffiles)
                    Reffile     = Reffiles{kk};
                    Ref         = load(fullfile(ParentDir,InputDir,Reffile));

                    OutputDir   = fullfile(outdir,InputDir);
                    disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',OutputDir])
                    if(length(Ref.Data)<maxtrials(1))
                        disp(['スパイク数(',num2str(length(Ref.Data)),')は最小スパイク数(',num2str(maxtrials(1)),')に達していないため、解析は続行しませんでした。'])
                    else
                        mkdir(OutputDir)
                        if(OneToOne_flag)   %% OneToOne_flag = 1;
                            try
                                Tar     = load(fullfile(ParentDir,InputDir,Tarfiles{kk}));
                                if(RescaleXData_flag)
                                    RSX_hdr = load(fullfile(ParentDirRSX,InputDir,RSXfile));
                                    RSX_dat = load(fullfile(ParentDirRSX,InputDir,['._',RSXfile]));
                                    [STA_hdr,STA_dat]   = sta(Tar,Ref,TimeWindow*2,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
                                    nRSX    = RSX_hdr.nTrials;
                                    nSTA    = STA_hdr.nTrials;
                                    if(nRSX~=nSTA)
                                        error('Rescale dataとSTA dataのトライアル数が一致しません。')
                                    end
                                    for iRSX=1:nRSX
                                        cfactor                     = 1.5 / RSX_hdr.XData(RSX_dat.TrialData(iRSX,:));
                                        STA_dat.TrialData(iRSX,:)   = rescaleXData(STA_hdr.XData,STA_dat.TrialData(iRSX,:),cfactor); 
                                    end
                                    RSXind              = (STA_hdr.XData >= TimeWindow(1) & STA_hdr.XData <= TimeWindow(end));
                                    STA_dat.TrialData   = STA_dat.TrialData(:,RSXind);
                                    STA_hdr.RescaleXData_flag   = RescaleXData_flag;
                                    STA_hdr.TimeRange   = TimeWindow;
                                    STA_hdr.YData       = nanmean(STA_dat.TrialData,1);
                                    STA_hdr.XData       = STA_hdr.XData(1,RSXind);
                                    
                                    STA_hdr.Name        = [deext(STA_hdr.Name),'[rescaled]'];
                                    STA_hdr.data_file   = ['._',STA_hdr.Name,'.mat'];
                                    
                                    STA_dat.Name        = deext(STA_hdr.data_file);
                                    STA_dat.hdr_file    = [STA_hdr.Name,'.mat'];
                                    
                                else
                                    [STA_hdr,STA_dat]   = sta(Tar,Ref,TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
                                end
                                Name        = STA_hdr.Name;
                                OutputFile_hdr  = fullfile(OutputDir,[Name,'.mat']);
                                OutputFile_dat  = fullfile(OutputDir,['._',Name,'.mat']);
                                save(OutputFile_hdr,'-struct','STA_hdr')
                                save(OutputFile_dat,'-struct','STA_dat')

                                clear('Tar','STA_hdr','STA_dat')
                                % mpack;

                                disp([' L-- 1/1:  ',OutputFile_hdr])
                            catch
                                disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{kk})])
                            end

                        else        %% OneToOne_flag = 0;
                            for ii=1:length(Tarfiles)
                                try
                                    Tar     = load(fullfile(ParentDir,InputDir,Tarfiles{ii}));
                                    if(RescaleXData_flag)
                                        RSX_hdr = load(fullfile(ParentDirRSX,InputDir,RSXfile));
                                        RSX_dat = load(fullfile(ParentDirRSX,InputDir,['._',RSXfile]));
                                        [STA_hdr,STA_dat]   = sta(Tar,Ref,TimeWindow*2,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
                                        nRSX    = RSX_hdr.nTrials;
                                        nSTA    = STA_hdr.nTrials;
                                        if(nRSX~=nSTA)
                                            error('Rescale dataとSTA dataのトライアル数が一致しません。')
                                        end
                                        for iRSX = 1:nRSX
                                            cfactor                     = 1.5 ./ RSX_hdr.XData(RSX_dat.TrialData(iRSX,:));
                                            STA_dat.TrialData(iRSX,:)   = rescaleXData(STA_hdr.XData,STA_dat.TrialData(iRSX,:),cfactor);
                                        end
                                        RSXind              = (STA_hdr.XData >= TimeWindow(1) & STA_hdr.XData <= TimeWindow(end));
                                        STA_dat.TrialData   = STA_dat.TrialData(:,RSXind);
                                        STA_hdr.RescaleXData_flag   = RescaleXData_flag;
                                        STA_hdr.TimeRange   = TimeWindow;
                                        STA_hdr.YData       = nanmean(STA_dat.TrialData,1);
                                        STA_hdr.XData       = STA_hdr.XData(1,RSXind);

                                        STA_hdr.Name        = [deext(STA_hdr.Name),'[rescaled]'];
                                        STA_hdr.data_file   = ['._',STA_hdr.Name,'.mat'];

                                        STA_dat.Name        = deext(STA_hdr.data_file);
                                        STA_dat.hdr_file    = [STA_hdr.Name,'.mat'];

                                    else
                                        [STA_hdr,STA_dat] = sta(Tar,Ref,TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
                                    end
                                    Name        = STA_hdr.Name;
                                    OutputFile_hdr  = fullfile(OutputDir,[Name,'.mat']);
                                    OutputFile_dat  = fullfile(OutputDir,['._',Name,'.mat']);
                                    save(OutputFile_hdr,'-struct','STA_hdr')
                                    save(OutputFile_dat,'-struct','STA_dat')

                                    clear('Tar','STA_hdr','STA_dat')
%                                     % mpack;

                                    disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',OutputFile_hdr])
                                catch
                                    disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{ii})])
                                end
                            end
                        end
                    end
                end
            catch
                disp(['****** Error occured in ',InputDirs{jj}])
            end

        end
    else% if(UseExcel_flag) % TarもRefもExcel内のEMGNameに該当するものを使う。ようは自動的にOneToOne
        ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
        InputDirs   = dirdir(ParentDir);
        InputDir    = InputDirs{1};
        Tarfiles    = sortxls(dirmat(fullfile(ParentDir,InputDir)));
        Reffiles    = uiselect(Tarfiles,1,'Referenceファイルを選択してください（複数選択可）。');
        Tarfiles    = uiselect(Tarfiles,1,'Targetファイルを選択してください（複数選択可）。');

        outdir      = uigetdir(fullfile(datapath,'STA'),'出力フォルダを選択してください。必要なら作成してください。');
        
        if(RescaleXData_flag)
            ParentDirRSX =  uigetdir(datapath,'RescaleXData: rescaleに用いるPSTHデータが入っている親フォルダを選択してください。');
            InputDir     = InputDir{1};
            RSXfile      = sortxls(dirmat(fullfile(ParentDirRSX,InputDir)));
            RSXfile      = uichoice(RSXfile,'RescaleXData: rescaleに用いるPSTHデータを選択して下さい。');
        end
        Listfilename    = uigetfullfile('*.xls','STAを行うUnitとEMGのリストを含むExcelファイルを選択してください。さらにその後3行[]のデータを選択してください。');
        [temp1,temp2,List] = xlsread(Listfilename,-1);
        if(size(List,2)~=3)
            msgbox({'invalid selection';'select [ExpName, suffix,depth, TotalTime(1),TotalTime(2),(MSD Name)]'})
            return;
        end
        nList   = size(List,1);

        for iList=1:nList

            ExpName = [List{iList,1},List{iList,2}];
            EMGName = List{iList,3};
            InputDir    = strfilt(InputDirs,ExpName);
            if(length(InputDir)>1)
                error([ExpName,': Experiment名でマッチするものが複数見つかってしまいました。'])
            else
            InputDir    = InputDir{1};
            end

            Tarfile     = strfilt(Tarfiles,EMGName);
            if(length(Tarfile)>1)% もし複数ヒットした場合は、一番短いstringを選ぶ
                temp    = zeros(length(Tarfile));
                for iTar=1:length(Tarfile)
                    temp(iTar)    =length(Tarfile{iTar});
                end
%                 keyboard
                [temp,iTar] = min(temp);
                Tarfile     = Tarfile{iTar};
            else
            Tarfile     = Tarfile{1};
            end

            Reffile     = strfilt(Reffiles,EMGName);
            if(length(Reffile)>1)% もし複数ヒットした場合は、一番短いstringを選ぶ
                temp    = zeros(length(Reffile));
                for iRef=1:length(Reffile)
                    temp(iRef)    =length(Reffile{iRef});
                end
                [temp,iRef] = min(temp);
                Reffile     = Reffile{iRef};
            else
                Reffile     = Reffile{1};
            end

            OutputDir   = fullfile(outdir,InputDir);
            Ref     = load(fullfile(ParentDir,InputDir,Reffile));
            try
                if(length(Ref.Data)<maxtrials(1))
                    disp(['スパイク数(',num2str(length(Ref.Data)),')は最小スパイク数(',num2str(maxtrials(1)),')に達していないため、解析は続行しませんでした。'])
                else
                    mkdir(OutputDir)

                    Tar     = load(fullfile(ParentDir,InputDir,Tarfile));
                    if(RescaleXData_flag)
                        RSX_hdr = load(fullfile(ParentDirRSX,InputDir,RSXfile));
                        RSX_dat = load(fullfile(ParentDirRSX,InputDir,['._',RSXfile]));
                        [STA_hdr,STA_dat]   = sta(Tar,Ref,TimeWindow*2,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
                        nRSX    = RSX_hdr.nTrials;
                        nSTA    = STA_hdr.nTrials;
                        if(nRSX~=nSTA)
                            error('Rescale dataとSTA dataのトライアル数が一致しません。')
                        end
                        for iRSX=1:nRSX
                            cfactor                     = 1.5 / RSX_hdr.XData(RSX_dat.TrialData(iRSX,:));
                            STA_dat.TrialData(iRSX,:)   = rescaleXData(STA_hdr.XData,STA_dat.TrialData(iRSX,:),cfactor);
                        end
                        RSXind              = (STA_hdr.XData >= TimeWindow(1) & STA_hdr.XData <= TimeWindow(end));
                        STA_dat.TrialData   = STA_dat.TrialData(:,RSXind);
                        STA_hdr.RescaleXData_flag   = RescaleXData_flag;
                        STA_hdr.TimeRange   = TimeWindow;
                        STA_hdr.YData       = nanmean(STA_dat.TrialData,1);
                        STA_hdr.XData       = STA_hdr.XData(1,RSXind);


                        STA_hdr.Name        = [deext(STA_hdr.Name),'[rescaled]'];
                        STA_hdr.data_file   = ['._',STA_hdr.Name,'.mat'];

                        STA_dat.Name        = deext(STA_hdr.data_file);
                        STA_dat.hdr_file    = [STA_hdr.Name,'.mat'];

                    else
                        [STA_hdr,STA_dat]   = sta(Tar,Ref,TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
                    end
                    Name        = STA_hdr.Name;
                    OutputFile_hdr  = fullfile(OutputDir,[Name,'.mat']);
                    OutputFile_dat  = fullfile(OutputDir,['._',Name,'.mat']);
                    save(OutputFile_hdr,'-struct','STA_hdr')
                    save(OutputFile_dat,'-struct','STA_dat')

                    clear('Tar','STA_hdr','STA_dat')
                    % % mpack;

                    disp([' L-- ',num2str(iList),'/',num2str(nList),':  ',OutputFile_hdr])
                end
            catch
                disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfile)])
            end
        end



    end

else            % ExpSetsを使ったsta
%     
%         [ExpSetsName,ExpSets,ExpSetsfile]   = loadExpSets;
%         [ExpSetsName,ind]          = uiselect(ExpSetsName,1,'対象となるExperiment Setを選択してください。');
%         ExpSets   = ExpSets(ind);
%     
%         ParentDir   = uigetdir(matpath,[ExpSetsfile,':  Sourceの親フォルダを選択してください。']);
%         ExpSet     = ExpSets{1};
%         Exp          = ExpSet{1};
%         Tarfiles    = sortxls(dirmat(fullfile(ParentDir,Exp)));
%         Reffiles    = uiselect(Tarfiles,1,'Select Reference files');
%         Tarfiles    = uiselect(Tarfiles,1,'Select Target files');
%         outdir      = uigetdir(fullfile(datapath,'STA'),'出力フォルダを選択してください。必要なら作成してください。');
%         if(OneToOne_flag)
%             message = cell(size(Reffiles));
%             for ii=1:length(Reffiles)
%                 message{ii} = [Reffiles{ii},'---',Tarfiles{ii}];
%             end
%             YN  = questdlg(message, ...
%                 'Check One-to-One', ...
%                 'OK','Cancel');
%             if(strcmp(YN,'Cancel'))
%                 disp('Cancelled')
%                 return;
%             end
%         end
%     
%         nRef    = length(Reffiles);
%         nTar    = length(Tarfiles);
%         nExpSet    = length(ExpSets);
%         for iExpSet    =1:nExpSet       % ExpSetごと
%             ExpSet          = ExpSets{iExpSet};
%             ExpSetName  = ExpSetsName{iExpSet};
%             try
%                 OutputDir   = fullfile(outdir,ExpSetName);
%                 if(~exist(OutputDir,'dir'))
%                     mkdir(OutputDir)
%                 end
%                 disp([num2str(iExpSet),'/',num2str(nExpSet),':  ',OutputDir])
%                 nExp    = length(ExpSet);
%     
%     
%                 for iRef =1:nRef
%                     Reffile     = Reffiles{iRef};
%                     if(OneToOne_flag)
%                         Tarfile = Tarfiles{iRef};
%                         for iExp = 1:nExp       % ExpSet内のExpごと
%                             Exp = ExpSet{iExp};
%                             InputDir    = fullfile(ParentDir,Exp);
%     
%                             Ref = load(fullfile(InputDir,Reffile));
%                             Tar = load(fullfile(InputDir,Tarfile));
%     
%                             STADATA = sta(Tar,Ref,TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
%                             if(iExp==1)
%                                 ALLSTADATA  = STADATA;
%     
%                                 ALLSTADATA.YData    = zeros(size(ALLSTADATA.YData));
%                                 ALLSTADATA.smYData  = zeros(size(ALLSTADATA.smYData));
%                                 ALLSTADATA.nTrials  = 0;
%     
%                                 ExpSet_ntrials   = zeros(1,nExp);
%     
%                                 if(StoreTrial_flag)
%                                     ALLSTADATA.TrialData    = [];
%                                 end
%                                 if(ISA_flag)
%                                     ALLSTADATA.ISAData      = zeros(size(ALLSTADATA.ISAData));
%                                     ALLSTADATA.smISAData    = zeros(size(ALLSTADATA.smISAData));
%                                     ALLSTADATA.nISA         = 0;
%                                     ExpSet_nISA  = zeros(1,nExp);
%                                 end
%                             end
%                             if(STADATA.nTrials~=0)
%                                 ALLSTADATA.YData    = ALLSTADATA.YData + STADATA.YData*STADATA.nTrials;
%                                 ALLSTADATA.smYData  = ALLSTADATA.smYData + STADATA.smYData*STADATA.nTrials;
%                                 ALLSTADATA.nTrials  = ALLSTADATA.nTrials + STADATA.nTrials;
%                                 ExpSet_ntrials(iExp) = STADATA.nTrials;
%     
%                                 if(StoreTrial_flag)
%                                     ALLSTADATA.TrialData    = [ALLSTADATA.TrialData;STADATA.TrialData];
%                                 end
%                                 if(ISA_flag)
%                                     ALLSTADATA.ISAData    = ALLSTADATA.ISAData + STADATA.ISAData*STADATA.nISA;
%                                     ALLSTADATA.smISAData  = ALLSTADATA.smISAData + STADATA.smISAData*STADATA.nISA;
%                                     ALLSTADATA.nISA       = ALLSTADATA.nISA + STADATA.nISA;
%                                     ExpSet_nISA(iExp)    = STADATA.nISA;
%                                 end
%                             end
%                             clear STADATA
%                         end
%     
%                         ALLSTADATA.YData    = ALLSTADATA.YData/ALLSTADATA.nTrials;
%                         ALLSTADATA.smYData  = ALLSTADATA.smYData/ALLSTADATA.nTrials;
%     
%                         if(ISA_flag)
%                             ALLSTADATA.ISAData    = ALLSTADATA.ISAData/ALLSTADATA.nISA;
%                             ALLSTADATA.smISAData  = ALLSTADATA.smISAData/ALLSTADATA.nISA;
%                         end
%     
%                         ALLSTADATA.UseExpSet_flag   = 1;
%                         ALLSTADATA.Expset           = ExpSet;
%                         ALLSTADATA.ExpSet_ntrials   = ExpSet_ntrials;
%                         if(ISA_flag)
%                             ALLSTADATA.ExpSet_nISA      = ExpSet_nISA;
%                         end
%     
%                         Name    = ALLSTADATA.Name;
%                         OutputFile  = fullfile(OutputDir,Name);     % ExpSetNameのフォルダに作る
%                         save(OutputFile,'-struct','ALLSTADATA')
%     
%                         disp([' L-- 1/1:  ',OutputFile])
%     
%                     else % OneToOne_flag=0
%     
%                         for iTar=1:nTar
%                             Tarfile = Tarfiles{iTar};
%                             for iExp = 1:nExp       % ExpSet内のExpごと
%                                 Exp = ExpSet{iExp};
%                                 InputDir    = fullfile(ParentDir,Exp);
%     
%                                 Ref = load(fullfile(InputDir,Reffile));
%                                 Tar = load(fullfile(InputDir,Tarfile));
%     
%                                 STADATA = sta(Tar,Ref,TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
%                                 if(iExp==1)
%                                     ALLSTADATA  = STADATA;
%     
%                                     ALLSTADATA.YData    = zeros(size(ALLSTADATA.YData));
%                                     ALLSTADATA.smYData  = zeros(size(ALLSTADATA.smYData));
%                                     ALLSTADATA.nTrials  = 0;
%     
%                                     ExpSet_ntrials   = zeros(1,nExp);
%     
%                                     if(StoreTrial_flag)
%                                         ALLSTADATA.TrialData    = [];
%                                     end
%                                     if(ISA_flag)
%                                         ALLSTADATA.ISAData      = zeros(size(ALLSTADATA.ISAData));
%                                         ALLSTADATA.smISAData    = zeros(size(ALLSTADATA.smISAData));
%                                         ALLSTADATA.nISA         = 0;
%                                         ExpSet_nISA  = zeros(1,nExp);
%                                     end
%                                 end
%                                 if(STADATA.nTrials~=0)
%                                     ALLSTADATA.YData    = ALLSTADATA.YData + STADATA.YData*STADATA.nTrials;
%                                     ALLSTADATA.smYData  = ALLSTADATA.smYData + STADATA.smYData*STADATA.nTrials;
%                                     ALLSTADATA.nTrials  = ALLSTADATA.nTrials + STADATA.nTrials;
%                                     ExpSet_ntrials(iExp) = STADATA.nTrials;
%     
%                                     if(StoreTrial_flag)
%                                         ALLSTADATA.TrialData    = [ALLSTADATA.TrialData;STADATA.TrialData];
%                                     end
%                                     if(ISA_flag)
%                                         ALLSTADATA.ISAData    = ALLSTADATA.ISAData + STADATA.ISAData*STADATA.nISA;
%                                         ALLSTADATA.smISAData  = ALLSTADATA.smISAData + STADATA.smISAData*STADATA.nISA;
%                                         ALLSTADATA.nISA       = ALLSTADATA.nISA + STADATA.nISA;
%                                         ExpSet_nISA(iExp)    = STADATA.nISA;
%                                     end
%                                 end
%                                 clear STADATA
%                             end
%     
%                             ALLSTADATA.YData    = ALLSTADATA.YData/ALLSTADATA.nTrials;
%                             ALLSTADATA.smYData  = ALLSTADATA.smYData/ALLSTADATA.nTrials;
%     
%                             if(ISA_flag)
%                                 ALLSTADATA.ISAData    = ALLSTADATA.ISAData/ALLSTADATA.nISA;
%                                 ALLSTADATA.smISAData  = ALLSTADATA.smISAData/ALLSTADATA.nISA;
%                             end
%     
%                             ALLSTADATA.UseExpSet_flag   = 1;
%                             ALLSTADATA.Expset           = ExpSet;
%                             ALLSTADATA.ExpSet_ntrials   = ExpSet_ntrials;
%                             if(ISA_flag)
%                                 ALLSTADATA.ExpSet_nISA      = ExpSet_nISA;
%                             end
%     
%                             Name    = ALLSTADATA.Name;
%                             OutputFile  = fullfile(OutputDir,Name);     % ExpSetNameのフォルダに作る
%                             save(OutputFile,'-struct','ALLSTADATA')
%     
%                             disp([' L-- ',num2str(iTar),'/',num2str(nTar),':  ',OutputFile])
%                         end
%                     end
%                 end
%             catch
%                 disp(['****** Error occured in ',ExpSetName])
%             end
%         end
end

warning('on');