function psth_btc(TimeWindow, bw)
%   psth_btc(TimeWindow, bw) in sec

if(nargin<2)
    error('�\�����Ⴂ�܂��Bpsth_btc(TimeWindow,bw)')
end

warning('off');

ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'));
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end
ParentDir   = uigetdir(ParentDir,'�e�t�H���_��I�����Ă��������B');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'�ΏۂƂȂ�Experiment��I�����Ă��������B');

InputDir    = InputDirs{1};
Tarfiles    = sortxls(dirmat(fullfile(ParentDir,InputDir)));
Reffiles    = uiselect(Tarfiles,1,'Reference�t�@�C����I�����Ă��������i�����I���j�B');
if(isempty(Reffiles))
    disp('User pressed cancel.')
    return;
end
Tarfiles    = uiselect(Tarfiles,1,'Target�t�@�C����I�����Ă��������i�����I���j�B');
if(isempty(Tarfiles))
    disp('User pressed cancel.')
    return;
end

OutputParentDir = getconfig(mfilename,'OutputParentDir');
try
    if(~exist(OutputParentDir,'dir'))
        OutputParentDir = pwd;
    end
catch
    OutputParentDir = pwd;
end
OutputParentDir      = uigetdir(OutputParentDir,'�o�̓t�H���_��I�����Ă��������B�K�v�Ȃ�쐬���Ă��������B');
if(OutputParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputParentDir',OutputParentDir);
end

for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
        for kk =1:length(Reffiles)
            Reffile     = Reffiles{kk};
            Ref         = loaddata(fullfile(ParentDir,InputDir,Reffile));
            OutputDir   = fullfile(OutputParentDir,InputDir);
            mkdir(OutputDir)
            disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',OutputDir])
            
            for ii=1:length(Tarfiles)
                try
                    Tar     = loaddata(fullfile(ParentDir,InputDir,Tarfiles{ii}));
                    [PSTH_hdr,PSTH_dat] = psth(Tar,Ref,TimeWindow,bw);

                    Name        = PSTH_hdr.Name;
                    OutputFile_hdr  = fullfile(OutputDir,[Name,'.mat']);
                    OutputFile_dat  = fullfile(OutputDir,['._',Name,'.mat']);
                    save(OutputFile_hdr,'-struct','PSTH_hdr')
                    save(OutputFile_dat,'-struct','PSTH_dat')
                    
                    clear('Tar','PSTH_hdr','PSTH_dat')
                    mpack;
                    
                    disp([' L-- 1/1:  ',OutputFile_hdr])
                    
                    
                catch
                    disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{ii})])
                end
            end
        end
    catch
        disp(['****** Error occured in ',InputDirs{jj}])
    end
    
end

warning('on');