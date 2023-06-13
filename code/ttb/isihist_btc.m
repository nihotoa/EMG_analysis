function isihist_btc(bw, nonzero_flag)


%isihist_btc(bw[, nonzero_flag])
% 
% ex
% isihist_btc(0.001, 1)
% 
% bw: in sec
% nonzero_flag = 1 ->　ISI=0のデータは排除する。

if nargin < 2
    nonzero_flag    = 0;
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
Reffiles    = dirmat(fullfile(ParentDir,InputDir));
Reffiles    = sortxls(strfilt(Reffiles,'~._'));
Reffiles    = uiselect(Reffiles,1,'対象とするfileを選択してください');
if(isempty(Reffiles))
    disp('User pressed cancel.')
    return;
end

OutputParentDir = getconfig(mfilename,'OutputParentDir');
try
    if(~exist(OutputParentDir,'dir'))
        OutputParentDir   = pwd;
    end
catch
    OutputParentDir   = pwd;
end
OutputParentDir   = uigetdir(OutputParentDir,'親フォルダを選択してください。');
if(OutputParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputParentDir',OutputParentDir);
end



nDir    = length(InputDirs);
nRef    = length(Reffiles);


for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
                
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
                
        for iRef=1:nRef
            try
                Reffile     = Reffiles{iRef};
                fullReffile = fullfile(ParentDir,InputDir,Reffile);
                               
                Ref = loaddata(fullReffile);
                
                
                % applyTrialsToUseをしてpseを行い、psename fieldを作る
                Y   = isihist(Ref,bw,nonzero_flag);
                
                OutputDir       = fullfile(OutputParentDir,InputDir);
                mkdir(OutputDir);
                fullOutputfile  = fullfile(OutputDir,[Y.Name,'.mat']);
                save(fullOutputfile,'-struct','Y')
                
                disp([' L-- ',num2str(iRef),'/',num2str(nRef),':  ',fullOutputfile])
            catch
                errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,Reffiles{iRef})];
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
