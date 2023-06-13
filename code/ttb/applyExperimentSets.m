function applyExperimentSets

ExpsetDir   = uigetdir(fullfile(datapath,'ExperimentSets'),'ExperimentSetsフォルダを選択してください。');
Expsetfiles = dirmat(ExpsetDir);
Expsetfiles = uiselect(deext(Expsetfiles),1,'用いるExperimentSetを選択してください。');
Expsetfile  = Expsetfiles{1};
Expset      = load(fullfile(ExpsetDir,Expsetfile));
ExpName     = Expset.Data{1};

ParentDir   = uigetdir(datapath,'ExperimentSetを適用するExperimentの親フォルダを選択してください。');
Tarfiles    = strfilt(sortxls(deext(dirmat(fullfile(ParentDir,ExpName)))),'~._');
Tarfiles    = uiselect(Tarfiles,1,'適用するファイルを選択してください（複数選択可）。');

OutParentDir    = uigetdir(ParentDir,'出力フォルダを選択してください。必要なら作成してください。');

nExpset = length(Expsetfiles);
nTar    = length(Tarfiles);

for iExpset = 1:nExpset
    Expsetfile  = Expsetfiles{iExpset};
    Expset      = load(fullfile(ExpsetDir,Expsetfile));
    
    ExpNames    = Expset.Data;
    nExp        = length(ExpNames);
    
    OutputDir   = fullfile(OutParentDir,Expsetfile);
    if(~exist(OutputDir,'dir'))
        mkdir(OutputDir);
    end
    
    for iTar    = 1:nTar
        Tarfile  = Tarfiles{iTar};
        try
        ExpName  = ExpNames{1};
        
        Y   = load(fullfile(ParentDir,ExpName,[Tarfile,'.mat']));
        Y.UseExpSet  = 1;
        Y.Expset     = ExpNames;
        
        switch(Y.AnalysisType)
            case 'STA'
                Y.Name      = Tarfile;
                Y.data_file = ['._',Y.Name];
                if(Y.StoreTrial_flag~=1)
                    Y.YData = Y.YData * Y.nTrials;
                end
                
                Y_dat           = load(fullfile(ParentDir,ExpName,['._',Tarfile,'.mat']));
                Y_dat.Name      = Y.data_file;
                Y_dat.hdr_file  = Y.Name;
                
                if(nExp > 1)
                    for iExp    = 2:nExp
                        ExpName  = ExpNames{iExp};
                        
                        S    = load(fullfile(ParentDir,ExpName,[Tarfile,'.mat']));
                        S_dat= load(fullfile(ParentDir,ExpName,['._',Tarfile,'.mat']));
                        
                        if(Y.StoreTrial_flag~=S.StoreTrial_flag)
                            error('StoreTrial_flag must be same.')
                        end
                        if(Y.ISA_flag~=S.ISA_flag)
                            error('ISA_flag must be same.')
                        end
                        
                        if(Y.maxtrials(1)~=S.maxtrials(1))
                            Y.maxtrials(1)  = NaN;
                        end
                        if(Y.maxtrials(2)~=S.maxtrials(2))
                            Y.maxtrials(2)  = NaN;
                        end
                        
                        if(Y.Smoothing_flag~=S.Smoothing_flag)
                            Y.Smoothing_flag  = 'mixed';
                        end
                        
                        % Y.Name
                        if(~strcmp(Y.TargetName,S.TargetName))
                            Y.TargetNames   = 'mixed';
                        end
                        if(~strcmp(Y.ReferenceName,S.ReferenceName))
                            Y.ReferenceNames   = 'mixed';
                        end
                        if(~strcmp(Y.Class,S.Class))
                            error('Class must be same.');
                        end
                        if(~strcmp(Y.AnalysisType,S.AnalysisType))
                            error('AnalysisType must be same.');
                        end
                        if(any(Y.TimeRange~=S.TimeRange))
                            error('TimeRange must be same.');
                        end
                        if(Y.SampleRate~=S.SampleRate)
                            error('SampleRate must be same.')
                        end
                        Y.TimeStamps  = [Y.TimeStamps,S.TimeStamps];
                        
                        Y.nTrials   = Y.nTrials + S.nTrials;
                        %Y.YData
                        
                        if(any(Y.XData~=S.XData))
                            error('XData must be same.');
                        end
                        
                        if(~strcmp(Y.Unit,S.Unit))
                            error('Unit must be same.');
                        end
                        %Y.data_file
                        
                        if(Y.StoreTrial_flag==1)
                            if(Y.TrialData~=S.TrialData)
                                error('TrialData must be same.')
                            end
                            Y_dat.TrialData = [Y_dat.TrialData;S_dat.TrialData];
                        else
                            Y.YData = nansum([Y.YData;S.YData*S.nTrials]);
                        end
                        
                        if(Y.ISA_flag==1)
                            if(Y.ISATrialData~=S.ISATrialData)
                                error('ISATrialData must be same.')
                            end
                            % Y.ISAData
                            Y.nISA  = Y.nISA + S.nISA;
                            Y_dat.ISATrialData = [Y_dat.ISATrialData;S_dat.ISATrialData];
                        end
                    end
                    
                    if(Y.StoreTrial_flag == 1)
                        Y.YData = mean(Y_dat.TrialData,1);
                    else
                        Y.YData = Y.YData / Y.nTrials;
                    end
                    if(Y.ISA_flag==1)
                        Y.ISAData = mean(Y_dat.ISATrialData,1);
                    end
                end
                
            case 'PSTH'
                Y.Name      = Tarfile;
                Y.data_file = ['._',Y.Name];
                                
                Y_dat           = load(fullfile(ParentDir,ExpName,['._',Tarfile,'.mat']));
                Y_dat.Name      = Y.data_file;
                Y_dat.hdr_file  = Y.Name;
                
                if(nExp > 1)
                    for iExp    = 2:nExp
                        ExpName  = ExpNames{iExp};
                        
                        S    = load(fullfile(ParentDir,ExpName,[Tarfile,'.mat']));
                        S_dat= load(fullfile(ParentDir,ExpName,['._',Tarfile,'.mat']));
                        
                        % Y.Name
                        if(~strcmp(Y.TargetName,S.TargetName))
                            Y.TargetNames   = 'mixed';
                        end
                        if(~strcmp(Y.ReferenceName,S.ReferenceName))
                            Y.ReferenceNames   = 'mixed';
                        end
                        if(~strcmp(Y.Class,S.Class))
                            error('Class must be same.');
                        end
                        if(~strcmp(Y.AnalysisType,S.AnalysisType))
                            error('AnalysisType must be same.');
                        end
                        if(any(Y.TimeRange~=S.TimeRange))
                            error('TimeRange must be same.');
                        end
                        if(Y.SampleRate~=S.SampleRate)
                            error('SampleRate must be same.')
                        end
                        
                        Y.nTrials   = Y.nTrials + S.nTrials;
                        %Y.YData
                        
                        if(any(Y.XData~=S.XData))
                            error('XData must be same.');
                        end
                        
                        if(any(Y.BinData~=S.BinData))
                            error('BinData must be same.');
                        end
                        
                        if(any(Y.BinWidth~=S.BinWidth))
                            error('BinWidth must be same.');
                        end
                        %Y.data_file
                        
                        
                        Y_dat.TrialData = [Y_dat.TrialData;S_dat.TrialData];
                        Y_dat.psth_TrialData     = [Y_dat.psth_TrialData;S_dat.psth_TrialData];
                        Y_dat.psth_TrialData_sps = [Y_dat.psth_TrialData_sps;S_dat.psth_TrialData_sps];
                        
                        
                    end
                    
                    
                    Y.YData     = sum(Y_dat.psth_TrialData,1);
                    Y.YData_sps = Y.YData ./ Y.nTrials ./ Y.BinWidth;
                    
                    
                end
        end
        
         save(fullfile(OutputDir,[Tarfile,'.mat']),'-struct','Y')
         save(fullfile(OutputDir,['._',Tarfile,'.mat']),'-struct','Y_dat')
         
         disp([fullfile(OutputDir,[Tarfile,'.mat']),' was created.'])
        catch
            disp(['***** error occurred in ',fullfile(OutputDir,Tarfile)])
        end
    end
end

