function parsesta_btc

ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
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

InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');
if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};
InputFiles  = dirmat(fullfile(ParentDir,InputDir));
InputFiles  = sortxls(strfilt(InputFiles,'~._'));
InputFiles  = uiselect(InputFiles,1,'対象とするfile(YData)を選択してください');


nDirs   = length(InputDirs);
nFiles  = length(InputFiles);

for iDir=1:nDirs
    try
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDirs),':  ',InputDir])
        
        for iFile=1:nFiles
            try
                InputFile   = InputFiles{iFile};
                fullInputFile   = fullfile(ParentDir,InputDir,InputFile);
                
                
                S   = load(fullInputFile);
                [S,ischanged] = parsesta(S);
                
                if(ischanged)
                    save(fullInputFile,'-struct','S')
                    disp([' L-- ',num2str(iFile),'/',num2str(nFiles),':  ',fullInputFile])
                else
                    disp([' L-- ',num2str(iFile),'/',num2str(nFiles),':  ',fullInputFile,'*'])
                end
            catch
                
                InputFile   = InputFiles{iFile};
                fullInputFile   = fullfile(ParentDir,InputDir,InputFile);
                
                errormsg    = ['****** Error occured in ',fullInputFile];
                disp(errormsg)
                errorlog(errormsg);
                
            end
            
        end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
        
    end
    
end
end




function [S,ischanged]    = parsesta(S)

ischanged = false;
if(~isfield(S,'AnalysisType'))
    return;
else
    if(~strcmp(S.AnalysisType,'STA'))
        return;
    end
end


if(isfield(S,'diff'))
    S.Process.diff  = S.diff;
    S   = rmfield(S,'diff');
    ischanged = true;
    
end

if(isfield(S,'filt'))
    S.Process.filt  = S.filt;
    S   = rmfield(S,'filt');
    ischanged = true;
    
end

end

