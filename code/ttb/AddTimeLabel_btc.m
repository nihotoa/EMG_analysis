function AddTimeLabel_btc(Name,method,TimeWindow)

if(nargin<1)
    Name        = 'Label1';
    method      = 'localmax';
    TimeWindow  = [-inf inf];
elseif(nargin<2)
    method      = 'localmax';
    TimeWindow  = [-inf inf];
elseif(nargin<3)
    TimeWindow  = [-inf inf];
end

ParentDir   = uigetdir(datapath,'親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
end
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');
if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = sortxls(strfilt(Tarfiles,'~._'));
Tarfiles    = uiselect(Tarfiles,1,'Targetとするfileを選択してください');
if(isempty(Tarfiles))
    disp('User pressed cancel.')
    return;
end

nDirs   = length(InputDirs); 
nTars   = length(Tarfiles);



if(strcmpi(method,'copy'))
    InputDir    = InputDirs{1};
    Reffiles    = dirmat(fullfile(ParentDir,InputDir));
    Reffiles    = sortxls(strfilt(Reffiles,'~._'));
    Reffiles    = uiselect(Reffiles,1,'コピー元となるfileを選択してください');
    if(isempty(Reffiles))
        disp('User pressed cancel.')
        return;
    end
    nRefs   = length(Reffiles);
    if(nTars~=nRefs)
        disp('Number of Target files and Reference files must be same.');
        return;
    end
end



for iDir=1:nDirs
    try
        InputDir    = InputDirs{iDir};

        disp([num2str(iDir),'/',num2str(length(InputDirs)),':  ',InputDir])

        for iTar=1:nTars
            try
                clear('Tar')
                if(strcmpi(method,'copy'))
                    
                    Tarfile         = Tarfiles{iTar};
                    fullTarfile     = fullfile(ParentDir,InputDir,Tarfile);
                    Tar             = load(fullTarfile);
                    
                    Reffile         = Reffiles{iTar};
                    fullReffile     = fullfile(ParentDir,InputDir,Reffile);
                    Ref             = load(fullReffile);
                    
                    Tar             = AddTimeLabel(Tar,Name,method,TimeWindow,Ref);
                else
                    Tarfile         = Tarfiles{iTar};
                    fullTarfile     = fullfile(ParentDir,InputDir,Tarfile);
                    Tar             = load(fullTarfile);
                    
                    Tar             = AddTimeLabel(Tar,Name,method,TimeWindow);
                end
                
                save(fullTarfile,'-struct','Tar')

                disp([' L-- ',num2str(iTar),'/',num2str(nTars),':  ',fullTarfile])
            catch
                errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{iTar})];
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

warning('on');