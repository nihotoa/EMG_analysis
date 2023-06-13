function existfile_btc(filename)

ParentDir    = uigetdir(matpath,'親フォルダを選択してください。');
% ParentDir   = 'L:\tkitom\MDAdata\mat';
InputDirs   = uiselect(dirdir(ParentDir),1,'対象となるExperimentを選択してください')

nDir    = length(InputDirs)

for iDir=1:nDir
    InputDir    = InputDirs{iDir};
    fullfilename    = fullfile(ParentDir,InputDir,filename);
    yn  = exist(fullfilename,'file');
    
    if(~yn)
        disp(fullfilename);
        
    end
end
end
