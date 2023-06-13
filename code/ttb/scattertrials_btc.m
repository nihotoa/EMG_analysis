function scattertrials_btc(method,TimeWindow)

if(nargin<1)
    method      = 'mean';
    TimeWindow  = [-inf inf];
    test_limits = [];
elseif(nargin<2)
    TimeWindow  = [-inf inf];
    test_limits = [];
elseif(nargin<3)
    test_limits = [];
end
if(isempty(test_limits))
    test_flag   = 0;
else
    test_flag   = 1;
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
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');
if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = sortxls(strfilt(Tarfiles,'~._'));
Reffiles    = uiselect(Tarfiles,1,'対象とするfile(XData)を選択してください');
if(isempty(Reffiles))
    disp('User pressed cancel.')
    return;
end
Tarfiles    = uiselect(Tarfiles,1,'対象とするfile(YData)を選択してください');

OutputDir   = getconfig(mfilename,'OutputDir');
try
    if(~exist(OutputDir,'dir'))
        OutputDir   = pwd;
    end
catch
    OutputDir   = pwd;
end

OutputDir      = uigetdir(OutputDir,'出力フォルダを選択してください。必要なら作成してください。');
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end



nDirs   = length(InputDirs); 
nRefs   = length(Reffiles);
nTars   = length(Tarfiles);

for iDir=1:nDirs
    try
        InputDir    = InputDirs{iDir};

        disp([num2str(iDir),'/',num2str(length(InputDirs)),':  ',InputDir])
        
        
        
        
        for iRef=1:nRefs
            Reffile     = Reffiles{iRef};
            fullReffile = fullfile(ParentDir,InputDir,Reffile);
            fullRefdatfile  = fullfile(ParentDir,InputDir,['._',Reffile]);
            Ref_hdr     = load(fullReffile);
            Ref_dat     = load(fullRefdatfile);
            
            
            
            for iTar=1:nTars
                try
                    Tarfile         = Tarfiles{iTar};
                    fullTarfile     = fullfile(ParentDir,InputDir,Tarfile);
                    fullTardatfile  = fullfile(ParentDir,InputDir,['._',Tarfile]);
                    Tar_hdr         = load(fullTarfile);
                    Tar_dat         = load(fullTardatfile);
                    
                    
                    S   = scattertrials(Ref_hdr,Ref_dat,Tar_hdr,Tar_dat,method,TimeWindow);
                    
                    Outputfile      = [S.Name,'.mat'];
                    if(~exist(fullfile(OutputDir,InputDir),'dir'))
                        mkdir(fullfile(OutputDir,InputDir));
                    end
                    Outputfullfile  = fullfile(OutputDir,InputDir,Outputfile);
                    save(Outputfullfile,'-struct','S')
                    
                    disp([' L-- ',num2str(iTar),'/',num2str(nTars),':  ',Outputfullfile])
                catch
                    errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{iTar})];
                    disp(errormsg)
                    errorlog(errormsg);
                end
            end
        end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    
end

warning('on');