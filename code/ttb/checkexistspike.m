function existfile_btc(filename)

ParentDir    = uigetdir(matpath,'�e�t�H���_��I�����Ă��������B');
% ParentDir   = 'L:\tkitom\MDAdata\mat';
InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂȂ�Experiment��I�����Ă�������')

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
