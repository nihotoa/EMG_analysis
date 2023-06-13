function staconv_btc(normalize_unit)

if(nargin < 1)
    normalize_unit    = [];
end
% fs          = 100;
% gaussian_sd = 0.02;

fs      = 200;
p_lp    = 2;
w_lp    = 20;   %Hz

warning('off');

ParentDir1   = uigetdir(fullfile(datapath,'STA'),'STAの親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir1),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir1,InputDir));
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(sortxls(Tarfiles),1,'対象とするSTA fileを選択してください');
psename     = load(fullfile(ParentDir1,InputDir,Tarfiles{1}));
psename     = strfilt(fieldnames(psename),'pse');
psename     = uichoice(psename,'対象とするpseの種類を選択してください。');

ParentDir2  = uigetdir(matpath,'Convolutionの対象とするTime stampの親フォルダを選択してください。');
TSName      = uiselect(dirmat(fullfile(ParentDir2,InputDir)),1,'Convolutionの対象とするTime stampを選択してください。');
TSName      = deext(TSName{1});

for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
       
            disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])
            
            Tarfile = Tarfiles{1};
%             TSName  = getRefTarName(Tarfile);
            InputFile_TS   = fullfile(ParentDir2,InputDir,TSName);
            TS  = load(InputFile_TS);
            
            
            for ii=1:length(Tarfiles)
                try
                    Tarfile = Tarfiles{ii};
                    [tempTSName,CTName] = getRefTarName(Tarfile);
                    
                    OutName         = [TSName,' x ',CTName,'(',psename,')'];
                    
                    InputFile_STA  = fullfile(ParentDir1,InputDir,Tarfile);
                    
                    STA = load(InputFile_STA);
                    % if(STA.(psename).nsigpeaksTW > 0 && STA.(psename).isXtalk==0)
                    if(STA.(psename).nsigpeaksTW > 0)
                        STA = staconv(OutName,TS,STA,psename);
                    else
                        
                        temp.TimeRange  = TS.TimeRange;
                        temp.Name       = OutName;
                        temp.Class      = 'continuous channel';
                        temp.TargetName     = STA.Name;
                        temp.ReferenceName  = TS.Name;
                        temp.AnalysisType   = 'STACONV';
                        temp.SampleRate     = STA.SampleRate;
                        temp.pseName    = psename;
                        temp.Data       = zeros(1,(temp.TimeRange(2)-temp.TimeRange(1))*STA.SampleRate);
                        if(isfield(STA,'Unit'))
                            temp.Unit   = STA.Unit;
                        else
                            temp.Unit   = [];
                        end
                        
                        STA             = temp;
                        clear('temp')
                    end
                    
                        
                    
                    if(~isempty(normalize_unit))
                        urCTName    = [parseEMG(CTName),'(uV)'];
                        summary_file  = fullfile(matpath,'summary_file',InputDir,urCTName);
                        summaryS      = load(summary_file);
                        ind         = strfind(OutName,'uV');
                        if(isempty(ind))
                            OutName = [TSName,' x ',CTName,'(',normalize_unit,')(',psename,')'];
                        else
                            OutName = [OutName(1:ind-1),normalize_unit,OutName(ind+2:end)];
                        end
                        switch normalize_unit
                            case 'sd'
                                if(summaryS.RMS~=0)
                                    cfactor     = summaryS.RMS;
                                    STA.Name    = OutName;
                                    STA.Data    = STA.Data / cfactor;
                                    STA.Unit    = normalize_unit;
                                else
                                    STA.Name    = OutName;
                                    STA.Data    = zeros(size(STA.Data));
                                    STA.Unit    = normalize_unit;
                                end

                            case 'pMAX'
                                if(summaryS.lMAXl~=0)
                                    cfactor     = summaryS.lMAXl;
                                    STA.Name    = OutName;
                                    STA.Data    = STA.Data / cfactor;
                                    STA.Unit    = normalize_unit;
                                else
                                    STA.Name    = OutName;
                                    STA.Data    = zeros(size(STA.Data));
                                    STA.Unit    = normalize_unit;
                                end
                                
                            case 'pa'
                                if(summaryS.Area~=0)
                                    cfactor     = summaryS.lMAXl;
                                    STA.Name    = OutName;
                                    STA.Data    = STA.Data / cfactor;
                                    STA.Unit    = normalize_unit;
                                else
                                    STA.Name    = OutName;
                                    STA.Data    = zeros(size(STA.Data));
                                    STA.Unit    = normalize_unit;
                                end
                        end
                    end
                    
                    OutputFile  = fullfile(ParentDir2,InputDir,OutName);                    
                    save(OutputFile,'-struct','STA'),disp(OutputFile);

                    % Spike(Hz)ds1000Hz
                    STA  = makeContinuousChannel([OutName,'ds1000Hz'], 'resample', STA, 1000);
                    save(fullfile(ParentDir2,InputDir,STA.Name),'-struct','STA');disp(fullfile(ParentDir2,InputDir,STA.Name));

                    % Spike(Hz)ls10ds1000Hz
                    STA  = makeContinuousChannel([OutName,'ls10ds1000Hz'],'linear smoothing',STA,0.01);
                    save(fullfile(ParentDir2,InputDir,STA.Name),'-struct','STA');disp(fullfile(ParentDir2,InputDir,STA.Name));


                    % STA     = makeContinuousChannel(STA.Name,'butter',STA, 'low',p_lp,w_lp);
                    % STA     = makeContinuousChannel([STA.Name,'lp',num2str(fs),'Hz'],'resample',STA,fs);
                    %
                    % OutputFile  = fullfile(ParentDir2,InputDir,[OutName,'lp',num2str(fs),'Hz']);
                    % save(OutputFile,'-struct','STA'),disp(OutputFile);


                    clear('STA')

%                     disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',InputFile_STA])
                catch
                    errormsg    = [' L-- *** error occured in ',fullfile(ParentDir1,InputDir,Tarfiles{ii})];
                    disp(errormsg)
                    errorlog(errormsg);
                end
%                 indicator(ii,length(Tarfiles))
            end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{jj}];
        disp(errormsg)
        errorlog(errormsg);
    end
%     indicator(0,0)
    
end

warning('on');