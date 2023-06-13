function sta_btc(TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag,OneToOne_flag,UseExpSets_flag)
%   sta_btc(TimeWindow,StoreTrial_flag,ISA_flag[,nTrials][,OneToOne_flag][,UseExpSets_flag])

error(nargchk(3,7,nargin,'struct'))

if nargin<4
    UseExpSets_flag = 0;
    OneToOne_flag   = 0;
    Smoothing_flag  = 0;
    maxtrials       = [1 Inf];
elseif nargin<5
    UseExpSets_flag = 0;
    OneToOne_flag   = 0;
    Smoothing_flag  = 0;
elseif nargin<6
    UseExpSets_flag = 0;
    Smoothing_flag  = 0;
elseif nargin<7
    UseExpSets_flag = 0;
end
if(StoreTrial_flag);disp('StoreTrial_flag');end
if(ISA_flag);disp('ISA_flag');end
if(Smoothing_flag);disp('Smoothing_flag');end
if(OneToOne_flag);disp('OneToOne_flag');end
if(UseExpSets_flag);disp('UseExpSets_flag');end
disp(['maxtrials= ',num2str(maxtrials)]);


warning('off');

if(~UseExpSets_flag)            % 普通のsta
    ParentDir   = 'M:\tkitom\MDAdata\mat\Eito\Spinal Unit';
    outdir      = 'M:\tkitom\data\STA\Spike(EMG_filtered)(-0.03_0.05,lEMGl,Inf)\EitoTxx';
    
  
    InputDirs   = {'EitoT00202',...1
'EitoT00223',...
'EitoT00225',...
'EitoT00226',...
'EitoT00227',...
'EitoT00407',...
'EitoT00414',...
'EitoT00501',...
'EitoT00510',...
'EitoT00713',...
'EitoT00815',...
'EitoT00816',...
'EitoT00902',...
'EitoT01005',...
'EitoT01308',...
'EitoT01504',...
'EitoT01512',...
'EitoT01516',...
'EitoT01711',...
'EitoT01802',...
'EitoT02306',...
'EitoT02413',...
'EitoT02505'};
    Reffiles    = {'Spike(2DI(uV)_filtered).mat'};
    Tarfiles    = {'l2DIl(uV).mat'};
  
 

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
                    if(OneToOne_flag)
                        try
                            Tar     = load(fullfile(ParentDir,InputDir,Tarfiles{kk}));
                            [STA_hdr,STA_dat]   = sta(Tar,Ref,TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
                            Name        = STA_hdr.Name;
                            OutputFile_hdr  = fullfile(OutputDir,Name);
                            OutputFile_dat  = fullfile(OutputDir,['._',Name,'.mat']);
                            save(OutputFile_hdr,'-struct','STA_hdr')
                            save(OutputFile_dat,'-struct','STA_dat')
                            
                            clear('Tar','STA_hdr','STA_dat')
                            mpack;
                            
                            disp([' L-- 1/1:  ',OutputFile_hdr])
                        catch
                            disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{kk})])
                        end

                    else
                        for ii=1:length(Tarfiles)
                            try
                                Tar     = load(fullfile(ParentDir,InputDir,Tarfiles{ii}));
                                [STA_hdr,STA_dat] = sta(Tar,Ref,TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
                                Name        = STA_hdr.Name;
                                OutputFile_hdr  = fullfile(OutputDir,Name);
                                OutputFile_dat  = fullfile(OutputDir,['._',Name,'.mat']);
                                save(OutputFile_hdr,'-struct','STA_hdr')
                                save(OutputFile_dat,'-struct','STA_dat')
                                
                                clear('Tar','STA_hdr','STA_dat')
                                mpack;
                                
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

else            % ExpSetsを使ったsta
% 
%     [ExpSetsName,ExpSets,ExpSetsfile]   = loadExpSets;
%     [ExpSetsName,ind]          = uiselect(ExpSetsName,1,'対象となるExperiment Setを選択してください。');
%     ExpSets   = ExpSets(ind);
% 
%     ParentDir   = uigetdir(matpath,[ExpSetsfile,':  Sourceの親フォルダを選択してください。']);
%     ExpSet     = ExpSets{1};
%     Exp          = ExpSet{1};
%     Tarfiles    = sortxls(dirmat(fullfile(ParentDir,Exp)));
%     Reffiles    = uiselect(Tarfiles,1,'Select Reference files');
%     Tarfiles    = uiselect(Tarfiles,1,'Select Target files');
%     outdir      = uigetdir(fullfile(datapath,'STA'),'出力フォルダを選択してください。必要なら作成してください。');
%     if(OneToOne_flag)
%         message = cell(size(Reffiles));
%         for ii=1:length(Reffiles)
%             message{ii} = [Reffiles{ii},'---',Tarfiles{ii}];
%         end
%         YN  = questdlg(message, ...
%             'Check One-to-One', ...
%             'OK','Cancel');
%         if(strcmp(YN,'Cancel'))
%             disp('Cancelled')
%             return;
%         end
%     end
% 
%     nRef    = length(Reffiles);
%     nTar    = length(Tarfiles);
%     nExpSet    = length(ExpSets);
%     for iExpSet    =1:nExpSet       % ExpSetごと
%         ExpSet          = ExpSets{iExpSet};
%         ExpSetName  = ExpSetsName{iExpSet};
%         try
%             OutputDir   = fullfile(outdir,ExpSetName);
%             if(~exist(OutputDir,'dir'))
%                 mkdir(OutputDir)
%             end
%             disp([num2str(iExpSet),'/',num2str(nExpSet),':  ',OutputDir])
%             nExp    = length(ExpSet);
% 
% 
%             for iRef =1:nRef
%                 Reffile     = Reffiles{iRef};
%                 if(OneToOne_flag)
%                     Tarfile = Tarfiles{iRef};
%                     for iExp = 1:nExp       % ExpSet内のExpごと
%                         Exp = ExpSet{iExp};
%                         InputDir    = fullfile(ParentDir,Exp);
% 
%                         Ref = load(fullfile(InputDir,Reffile));
%                         Tar = load(fullfile(InputDir,Tarfile));
% 
%                         STADATA = sta(Tar,Ref,TimeWindow,StoreTrial_flag,ISA_flag,maxtrials,Smoothing_flag);
%                         if(iExp==1)
%                             ALLSTADATA  = STADATA;
% 
%                             ALLSTADATA.YData    = zeros(size(ALLSTADATA.YData));
%                             ALLSTADATA.smYData  = zeros(size(ALLSTADATA.smYData));
%                             ALLSTADATA.nTrials  = 0;
% 
%                             ExpSet_ntrials   = zeros(1,nExp);
% 
%                             if(StoreTrial_flag)
%                                 ALLSTADATA.TrialData    = [];
%                             end
%                             if(ISA_flag)
%                                 ALLSTADATA.ISAData      = zeros(size(ALLSTADATA.ISAData));
%                                 ALLSTADATA.smISAData    = zeros(size(ALLSTADATA.smISAData));
%                                 ALLSTADATA.nISA         = 0;
%                                 ExpSet_nISA  = zeros(1,nExp);
%                             end
%                         end
%                         if(STADATA.nTrials~=0)
%                             ALLSTADATA.YData    = ALLSTADATA.YData + STADATA.YData*STADATA.nTrials;
%                             ALLSTADATA.smYData  = ALLSTADATA.smYData + STADATA.smYData*STADATA.nTrials;
%                             ALLSTADATA.nTrials  = ALLSTADATA.nTrials + STADATA.nTrials;
%                             ExpSet_ntrials(iExp) = STADATA.nTrials;
% 
%                             if(StoreTrial_flag)
%                                 ALLSTADATA.TrialData    = [ALLSTADATA.TrialData;STADATA.TrialData];
%                             end
%                             if(ISA_flag)
%                                 ALLSTADATA.ISAData    = ALLSTADATA.ISAData + STADATA.ISAData*STADATA.nISA;
%                                 ALLSTADATA.smISAData  = ALLSTADATA.smISAData + STADATA.smISAData*STADATA.nISA;
%                                 ALLSTADATA.nISA       = ALLSTADATA.nISA + STADATA.nISA;
%                                 ExpSet_nISA(iExp)    = STADATA.nISA;
%                             end
%                         end
%                         clear STADATA
%                     end
% 
%                     ALLSTADATA.YData    = ALLSTADATA.YData/ALLSTADATA.nTrials;
%                     ALLSTADATA.smYData  = ALLSTADATA.smYData/ALLSTADATA.nTrials;
% 
%                     if(ISA_flag)
%                         ALLSTADATA.ISAData    = ALLSTADATA.ISAData/ALLSTADATA.nISA;
%                         ALLSTADATA.smISAData  = ALLSTADATA.smISAData/ALLSTADATA.nISA;
%                     end
% 
%                     ALLSTADATA.UseExpSet_flag   = 1;
%                     ALLSTADATA.Expset           = ExpSet;
%                     ALLSTADATA.ExpSet_ntrials   = ExpSet_ntrials;
%                     if(ISA_flag)
%                         ALLSTADATA.ExpSet_nISA      = ExpSet_nISA;
%                     end
% 
%                     Name    = ALLSTADATA.Name;
%                     OutputFile  = fullfile(OutputDir,Name);     % ExpSetNameのフォルダに作る
%                     save(OutputFile,'-struct','ALLSTADATA')
% 
%                     disp([' L-- 1/1:  ',OutputFile])
% 
%                 else % OneToOne_flag=0
% 
%                     for iTar=1:nTar
%                         Tarfile = Tarfiles{iTar};
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
%                         disp([' L-- ',num2str(iTar),'/',num2str(nTar),':  ',OutputFile])
%                     end
%                 end
%             end
%         catch
%             disp(['****** Error occured in ',ExpSetName])
%         end
%     end
end

warning('on');