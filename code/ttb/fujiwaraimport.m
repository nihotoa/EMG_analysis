function fujiwaraimport

% List    = {'l2DIl(uV)','2DI(uV)';...
%     'l3DIl(uV)','3DI(uV)';...
%     'l4DIl(uV)','4DI(uV)';...
%     'lAbDMl(uV)','AbDM(uV)';...
%     'lAbPBl(uV)','AbPB(uV)';...
%     'lAbPLl(uV)','AbPL(uV)';...
%     'lADPl(uV)','ADP(uV)';...
%     'lBicepsl(uV)','Biceps(uV)';...
%     'lBRDl(uV)','BRD(uV)';...
%     'lECRl(uV)','ECR(uV)';...
%     'lECUl(uV)','ECU(uV)';...
%     'lED23l(uV)','ED23(uV)';...
%     'lEDCl(uV)','EDC(uV)';...
%     'lFCRl(uV)','FCR(uV)';...
%     'lFCUl(uV)','FCU(uV)';...
%     'lFDIl(uV)','FDI(uV)';...
%     'lFDPrl(uV)','FDPr(uV)';...
%     'lFDPul(uV)','FDPu(uV)';...
%     'lFDSl(uV)','FDS(uV)';...
%     'lPLl(uV)','PL(uV)';...
%     'Grip Onset (svwostim)','Grip Onset (success)';...
%     'Release Onset (svwostim)','Release Onset (success)';...
%     'Total Torque(N)','Grip Force(N)';...
%     'Spike','Spike Onset'};

List    = {'Spike','Spike Onset'};



warning('off')

Reffiles    = List(:,1);
Tarfiles    = List(:,2);

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
                Tarfile     = Tarfiles{iRef};
                fullReffile = fullfile(ParentDir,InputDir,[Reffile,'.mat']);
                               
                Y           = loaddata(fullReffile);
                Y.Name      = Tarfile;
                Y.TimeRange = [0 Y.TimeRange(2)-Y.TimeRange(1)];
                
                if(strcmp(Y.Class,'timestamp channel'))
                    ind     = [inf diff(Y.Data)]~=0;
                    ndel    = sum([inf diff(Y.Data)]==0);
                    Y.Data  = Y.Data(ind);
                    if(ndel>0)
                        disp([num2str(ndel),' data deleted.']);
                    end
                end
                
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

warning('on')

