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

ParentDir1   = uigetdir(fullfile(datapath,'STA'),'STA�̐e�t�H���_��I�����Ă��������B');
InputDirs   = uiselect(dirdir(ParentDir1),1,'�ΏۂƂ���Experiments��I�����Ă�������');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir1,InputDir));
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(sortxls(Tarfiles),1,'�ΏۂƂ���STA file��I�����Ă�������');
psename       = load(fullfile(ParentDir1,InputDir,Tarfiles{1}));
psename       = strfilt(fieldnames(psename),'pse');
psename       = uichoice(psename,'�ΏۂƂ���pse�̎�ނ�I�����Ă��������B');

ParentDir2   = uigetdir(matpath,'STA�̃g���K�[�ƂȂ��Ă����ATime stamp�̐e�t�H���_��I�����Ă��������B');

for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
       
            disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])
            
            Tarfile = Tarfiles{1};
            TSName  = getRefTarName(Tarfile);
            InputFile_TS   = fullfile(ParentDir2,InputDir,TSName);
            TS  = load(InputFile_TS);
            
            
            for ii=1:length(Tarfiles)
                try
                    Tarfile = Tarfiles{ii};
                    [TSName,CTName] = getRefTarName(Tarfile);
                    
                    OutName         = [TSName,' x ',CTName,'(',psename,')'];
                    
                    InputFile_STA  = fullfile(ParentDir1,InputDir,Tarfile);
                    
                    STA = load(InputFile_STA);
                    if(STA.(psename).nsigpeaksTW > 0 && STA.(psename).isXtalk==0)
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
                        noise_file  = fullfile(matpath,'summary_file',InputDir,urCTName);
                        noiseS      = load(noise_file);
                        ind         = strfind(OutName,'uV');
                        if(isempty(ind))
                            OutName = [TSName,' x ',CTName,'(',normalize_unit,')(',psename,')'];
                        else
                            OutName = [OutName(1:ind-1),normalize_unit,OutName(ind+2:end)];
                        end
                        switch normalize_unit
                            case 'sd'
                                if(noiseS.RMS~=0)
                                    cfactor     = noiseS.RMS;
                                    STA.Name    = OutName;
                                    STA.Data    = STA.Data / cfactor;
                                    STA.Unit    = normalize_unit;
                                else
                                    STA.Name    = OutName;
                                    STA.Data    = zeros(size(STA.Data));
                                    STA.Unit    = normalize_unit;
                                end

                            case 'pMAX'
                                if(noiseS.lMAXl~=0)
                                    cfactor     = noiseS.lMAXl;
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
                    
                    STA     = makeContinuousChannel(STA.Name,'butter',STA, 'low',p_lp,w_lp);
                    STA     = makeContinuousChannel([STA.Name,'lp',num2str(fs),'Hz'],'resample',STA,fs);
                    
                    OutputFile  = fullfile(ParentDir2,InputDir,[OutName,'lp',num2str(fs),'Hz']);
                    save(OutputFile,'-struct','STA'),disp(OutputFile);
                    
                    
                    
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