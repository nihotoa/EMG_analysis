function sta_btc(TimeWindow, maxtrials, Smoothing_bw, StoreTrial_flag, ISA_flag, Randomize_flag, OneToOne_flag, RescaleXData_flag)
% sta_btc(TimeWindow, maxtrials, Smoothing_bw, StoreTrial_flag, ISA_flag, Randomize_flag, OneToOne_flag, RescaleXData_flag)
% 
% TimeWindow          [-0.03 0.05] (sec)
% maxtrials           [1 inf]
% Smoothing_bw        5 (points) must be even!!
% StoreTrial_flag     0 or 1
% ISA_flag            0 or 1
% OneToOne_flag       0 or 1
% Randomize_flag      0 or 1  
% RescaleXData_flag   0 or nBins (ex 100)



error(nargchk(1,8,nargin,'struct'))

if nargin<2
    maxtrials           = [1 Inf];
    Smoothing_bw        = 0;
    StoreTrial_flag     = 0;
    ISA_flag            = 0;
    Randomize_flag      = 0;
    OneToOne_flag       = 0;
    RescaleXData_flag   = 0;
elseif nargin<3
    Smoothing_bw        = 0;
    StoreTrial_flag     = 0;
    ISA_flag            = 0;
    Randomize_flag      = 0;
    OneToOne_flag       = 0;
    RescaleXData_flag   = 0;
elseif nargin<4
    StoreTrial_flag     = 0;
    ISA_flag            = 0;
    Randomize_flag      = 0;
    OneToOne_flag       = 0;
    RescaleXData_flag   = 0;
elseif nargin<5
    ISA_flag            = 0;
    Randomize_flag      = 0;
    OneToOne_flag       = 0;
    RescaleXData_flag   = 0;
elseif nargin<6
    Randomize_flag      = 0;
    OneToOne_flag       = 0;
    RescaleXData_flag   = 0;
elseif nargin<7
    OneToOne_flag       = 0;
    RescaleXData_flag   = 0;
elseif nargin<8
    RescaleXData_flag   = 0;
end

disp(['TimeWinodw:        ',num2str(TimeWindow)]);
disp(['maxtrials:         ',num2str(maxtrials)]);
disp(['Smoothing_bw:      ',num2str(Smoothing_bw)]);
disp(['StoreTrial_flag:   ',num2str(StoreTrial_flag)]);
disp(['ISA_flag:          ',num2str(ISA_flag)]);
disp(['Randomize_flag:    ',num2str(Randomize_flag)]);
disp(['OneToOne_flag:     ',num2str(OneToOne_flag)]);
disp(['RescaleXData_flag: ',num2str(RescaleXData_flag)]);



warning('off');

ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'));
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end
ParentDir   = uigetdir(ParentDir,'親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'対象となるExperimentを選択してください。');
if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
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

if(RescaleXData_flag>0)
    RSXfile    = sortxls(dirmat(fullfile(ParentDir,InputDir)));
    RSXfile    = uiselect(RSXfile,1,'RescaleXData: rescaleに用いるTimestampデータを選択して下さい。');
    if(iscell(RSXfile))
        RSXfile = RSXfile{1};
    end
    if(isempty(RSXfile))
        disp('User pressed cancel.')
        return;
    end
end
OutputParentDir = getconfig(mfilename,'OutputParentDir');
try
    if(~exist(OutputParentDir,'dir'))
        OutputParentDir = pwd;
    end
catch
    OutputParentDir = pwd;
end

OutputParentDir      = uigetdir(OutputParentDir,'出力フォルダを選択してください。必要なら作成してください。');
if(OutputParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputParentDir',OutputParentDir);
end

% if(RescaleXData_flag)
%     ParentDirRSX =  uigetdir(datapath,'RescaleXData: rescaleに用いるPSTHデータが入っている親フォルダを選択してください。');
%     RSXfile      = sortxls(dirmat(fullfile(ParentDirRSX,InputDir)));
%     RSXfile      = strfilt(RSXfile,'PSTH ~._');
%     RSXfile      = uichoice(RSXfile,'RescaleXData: rescaleに用いるPSTHデータを選択して下さい。');
% end

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
%             Ref         = load(fullfile(ParentDir,InputDir,Reffile));
            Ref         = loaddata(fullfile(ParentDir,InputDir,Reffile));
            
            OutputDir   = fullfile(OutputParentDir,InputDir);
            disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',OutputDir])
            if(length(Ref.Data)<maxtrials(1))
                disp(['スパイク数(',num2str(length(Ref.Data)),')は最小スパイク数(',num2str(maxtrials(1)),')に達していないため、解析は続行しませんでした。'])
            else
                mkdir(OutputDir)
                if(OneToOne_flag)   %% OneToOne_flag = 1;
                    try
%                         Tar     = load(fullfile(ParentDir,InputDir,Tarfiles{kk}));
                        Tar     = loaddata(fullfile(ParentDir,InputDir,Tarfiles{kk}));
                        if(RescaleXData_flag>0)
                            RSX_hdr = loaddata(fullfile(ParentDirRSX,InputDir,RSXfile));
                            RSX_dat = loaddata(fullfile(ParentDirRSX,InputDir,['._',RSXfile]));

                            
                            [STA_hdr,STA_dat]   = sta(Tar, Ref, TimeWindow*2, maxtrials, Smoothing_bw, StoreTrial_flag, ISA_flag, Randomize_flag);
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
                            [STA_hdr,STA_dat]   = sta(Tar, Ref, TimeWindow, maxtrials, Smoothing_bw, StoreTrial_flag, ISA_flag, Randomize_flag);
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
%                             Tar     = load(fullfile(ParentDir,InputDir,Tarfiles{ii}));
                            Tar     = loaddata(fullfile(ParentDir,InputDir,Tarfiles{ii}));
                            if(RescaleXData_flag>0)
                                nBin    = RescaleXData_flag;
                                
%                                 RSX_hdr = loaddata(fullfile(ParentDirRSX,InputDir,RSXfile));
%                                 RSX_dat = loaddata(fullfile(ParentDirRSX,InputDir,['._',RSXfile]));
                                RSX     = loaddata(fullfile(ParentDir,InputDir,RSXfile));
                                
                                RefTrigTime = Ref.Data./Ref.SampleRate;
                                RSXTrigTime = RSX.Data./RSX.SampleRate;
                                
                                RSXTrigTime = nearest(RSXTrigTime, RefTrigTime);
                                RSXData = RSXTrigTime - RefTrigTime;
                                
                                maxRSXData  = max(RSXData);
                                TimeWindow2 = TimeWindow*maxRSXData;
                                
                                [STA_hdr,STA_dat]   = sta(Tar, Ref, TimeWindow2, maxtrials, Smoothing_bw, StoreTrial_flag, ISA_flag, Randomize_flag);
                                                                
                                STA_hdr.TrialTriggerTime = STA_hdr.TimeStamps./STA_hdr.SampleRate;
%                                 RSX_hdr.TrialTriggerTime;
                                
%                                 STAind=ismember(STA_hdr.TrialTriggerTime,RSX_hdr.TrialTriggerTime);
%                                 RSXind=ismember(RSX_hdr.TrialTriggerTime,STA_hdr.TrialTriggerTime);
                                
%                                 STA_dat.TrialData   = STA_dat.TrialData(STAind,:);
%                                 RSXData =RSXData(RSXind);
                                
                                
                                nRSX    = length(RSXData);
                                nSTA    = size(STA_dat.TrialData,1);
                                                               
                                
                                if(nRSX~=nSTA)
                                    error('Rescale dataとSTA dataのトライアル数が一致しません。')
                                end
                                
                                TotalTime   = TimeWindow(2)-TimeWindow(1);
                                TotalnBin   = TotalTime * nBin +1;
                                newXData    = linspace(TimeWindow(1),TimeWindow(2),TotalnBin);
                                newTrialData    = nan(nRSX,TotalnBin);
                                
                                for iRSX = 1:nRSX
                                    oldXData    = STA_hdr.XData ./ RSXData(iRSX);
                                    newTrialData(iRSX,:)    = interp1(oldXData,STA_dat.TrialData(iRSX,:),newXData);
%                                     STA_dat.TrialData(iRSX,:)   = rescaleXData(STA_hdr.XData,STA_dat.TrialData(iRSX,:),cfactor);
                                end
%                                 RSXind              = (STA_hdr.XData >= TimeWindow(1) & STA_hdr.XData <= TimeWindow(end));
%                                 STA_dat.TrialData   = STA_dat.TrialData(:,RSXind);
                                
                                STA_dat.TrialData   = newTrialData;
                                STA_hdr.RescaleXData_flag   = RescaleXData_flag;
                                STA_hdr.TimeRange   = TimeWindow;
                                STA_hdr.YData       = nanmean(STA_dat.TrialData,1);
%                                 STA_hdr.XData       = STA_hdr.XData(1,RSXind);
                                STA_hdr.XData       = newXData;
                                STA_hdr.Name        = [deext(STA_hdr.Name),'[rescaled]'];
                                STA_hdr.data_file   = ['._',STA_hdr.Name,'.mat'];
                                STA_hdr.nTrials     = nSTA;
                                STA_dat.Name        = deext(STA_hdr.data_file);
                                STA_dat.hdr_file    = [STA_hdr.Name,'.mat'];
                                
                            else
                                [STA_hdr,STA_dat] = sta(Tar, Ref, TimeWindow, maxtrials, Smoothing_bw, StoreTrial_flag, ISA_flag, Randomize_flag);
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

warning('on');
end