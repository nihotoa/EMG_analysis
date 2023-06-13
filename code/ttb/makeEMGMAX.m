function makeEMGMAX


ParentDir   = uigetdir(fullfile(datapath,'STA'),'EMGのEvent-TAファイルが入っている親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

files       = dirmat(fullfile(ParentDir,InputDirs{1}));
files       = strfilt(files,'~._');
files       = uiselect(sortxls(files),1,'対象とするExperimentsを選択してください');

nDirs       = length(InputDirs);
nfile       = length(files);

OutputDir   = uigetdir(fullfile(datapath,'EMGMAX'),'出力フォルダを選択してください。必要に応じて作成してください。');

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