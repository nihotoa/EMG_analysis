function makeEMGMAX


ParentDir   = uigetdir(fullfile(datapath,'STA'),'EMG��Event-TA�t�@�C���������Ă���e�t�H���_��I�����Ă��������B');
InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂ���Experiments��I�����Ă�������');

files       = dirmat(fullfile(ParentDir,InputDirs{1}));
files       = strfilt(files,'~._');
files       = uiselect(sortxls(files),1,'�ΏۂƂ���Experiments��I�����Ă�������');

nDirs       = length(InputDirs);
nfile       = length(files);

OutputDir   = uigetdir(fullfile(datapath,'EMGMAX'),'�o�̓t�H���_��I�����Ă��������B�K�v�ɉ����č쐬���Ă��������B');

for iDir=1:nDirs
    InputDir    = InputDirs{iDir};
    EMGMAX      = [];
    try
            for ifile=1:nfile
                file    = files{ifile};
                [Trig,EMG]= getRefTarName(file);
                Outputfile  = fullfile(OutputDir,InputDir,EMG);
                
                s   = load(fullfile(ParentDir,InputDir,file));
                EMGMAX.AnalysisType = 'EMGMAX';
                EMGMAX.MAX  = max(s.YData);
                EMGMAX.RMS  = rms(s.YData);
                EMGMAX.Unit = s.Unit;

                
                if(~exist(fileparts(Outputfile),'dir'))
                    mkdir(fileparts(Outputfile))
                end
                save(Outputfile,'-struct','EMGMAX');
                disp(Outputfile)
                
            end
            
            
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
%     indicator(0,0)
    
end