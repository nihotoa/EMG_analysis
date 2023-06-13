function sortscatter_btc(CompName,SortMethod,N,MinN)
% SortMethod  = 'interval nbin', 'ordinal nbin', 'ordinal npoint', 'copy';

if(strcmp(SortMethod,'copy'))
    copyind_flag    = true;
    SortMethod      = 'manual';
    IndexCompName   = N;
else
    copyind_flag  = false;
end

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
end
setconfig(mfilename,'ParentDir',ParentDir)

InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');
if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};
FileNames    = dirmat(fullfile(ParentDir,InputDir));
FileNames    = sortxls(strfilt(FileNames,'~._'));
FileNames    = uiselect(FileNames,1,'対象とするfileを選択してください');
if(isempty(FileNames))
    disp('User pressed cancel.')
    return;
end

if(copyind_flag)
    RefFileNames    = dirmat(fullfile(ParentDir,InputDir));
    RefFileNames    = sortxls(strfilt(RefFileNames,'~._'));
    RefFileNames    = uiselect(RefFileNames,0,'Indexをコピーする元とするfileを選択してください');
    if(isempty(RefFileNames))
        disp('User pressed cancel.')
        return;
    end
    if(length(FileNames)~=length(RefFileNames))
        disp('Number of Reference File is not matched.')
    end
end




nDir    = length(InputDirs);
nFile   = length(FileNames);


for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};

        disp([num2str(iDir),'/',num2str(length(InputDirs)),':  ',InputDir])

        for iFile=1:nFile
            try
                FileName    = FileNames{iFile};
                FullFileName    = fullfile(ParentDir,InputDir,FileName);
                S   = load(FullFileName);

                if(copyind_flag)
                    RefFileName = RefFileNames{iFile};
                    FullRefFileName = fullfile(ParentDir,InputDir,RefFileName);
                    Ref     = load(FullRefFileName);
                    
                    N       = Ref.sort.(IndexCompName).BinIndex;
                end
                
                
                S   = sortscatter(S,CompName,SortMethod,N,MinN);
                
                save(FullFileName,'-struct','S')
                clear('S')

                disp([' L-- ',num2str(iFile),'/',num2str(nFile),':  ',FullFileName])
            catch
                errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,FileNames{iFile})];
                disp(errormsg)
                errorlog(errormsg);
            end
            %                 indicator(ii,length(FileNames))
        end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end

warning('on');