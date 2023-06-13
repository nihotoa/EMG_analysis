function applyEMGNMF_btc(NMFID)

% if nargin<1
%     NMFID       = 1;
% end

warning('off');

ParentDir    = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir    = pwd;
    end
catch
    ParentDir    = pwd;
end
ParentDir   = uigetdir(ParentDir,'EMGNMFファイルが入っているフォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

Tarfiles    = dirmat(ParentDir);
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(sortxls(Tarfiles),1,'対象とするfileを選択してください');

HParentDir    = getconfig(mfilename,'HParentDir');
try
    if(~exist(HParentDir,'dir'))
        HParentDir    = pwd;
    end
catch
    HParentDir    = pwd;
end
HParentDir   = uigetdir(HParentDir,'再構成EMGとNMF活動（H）を保存する"親"フォルダを選択してください。');
if(HParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'HParentDir',HParentDir);
end

WParentDir    = getconfig(mfilename,'WParentDir');
try
    if(~exist(WParentDir,'dir'))
        WParentDir    = pwd;
    end
catch
    WParentDir    = pwd;
end
WParentDir   = uigetdir(WParentDir,'NMF荷重（W）を保存する"親"フォルダを選択してください。');
if(WParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'WParentDir',WParentDir);
end


nTar    = length(Tarfiles);

for iTar=1:nTar
    try
        Tarfile     = Tarfiles{iTar};
        disp([num2str(iTar),'/',num2str(nTar),':  ',Tarfile])
               
        % load W and H
        NMFhdrfile  = fullfile(ParentDir,Tarfile);
        NMFdatfile  = fullfile(ParentDir,['._',Tarfile]);
        
        NMFhdr  = load(NMFhdrfile);
        NMFdat  = load(NMFdatfile);
        W       = NMFdat.W{NMFID};
        H       = NMFdat.H{NMFID};
        clear('NMFdat');
        
        % W,Hを使ってEMGを再構成
        X   = W*H;
        
        
                
        % 再構成されたEMGの保存
        nEMG    = length(NMFhdr.TargetName);
        for iEMG=1:nEMG
            clear('S')
            S.TimeRange = NMFhdr.TimeRange2;
            S.Name      = [deext(NMFhdr.TargetName{iEMG}),'-NMF',num2str(NMFID,'%.2d'),'reconst'];
            S.Class     = NMFhdr.Info.Class;
            S.SampleRate= NMFhdr.Info.SampleRate;
            S.Data      = X(iEMG,:);
            S.Unit      = NMFhdr.Info.Unit;
            
            OutputDir   = fullfile(HParentDir,deext(Tarfile));
            if(~exist(OutputDir,'dir'))
                mkdir(OutputDir);
            end
            Outputfile  = fullfile(OutputDir,[S.Name,'.mat']);
            
            save(Outputfile,'-struct','S');
            disp(Outputfile)
        end
        
        clear('X'); % Xをクリア
        
        
        % NMFHの保存
        nNMF    = NMFID;
        for iNMF=1:nNMF
            clear('S')
            S.TimeRange = NMFhdr.TimeRange2;
            S.Name      = ['NMFH',num2str(nNMF,'%.2d'),'-',num2str(iNMF,'%.2d')];
            S.Class     = NMFhdr.Info.Class;
            S.SampleRate= NMFhdr.Info.SampleRate;
            S.Data      = H(iNMF,:);
            S.Unit      = NMFhdr.Info.Unit;
            
            OutputDir   = fullfile(HParentDir,deext(Tarfile));
            if(~exist(OutputDir,'dir'))
                mkdir(OutputDir);
            end
            Outputfile  = fullfile(OutputDir,[S.Name,'.mat']);
            
            save(Outputfile,'-struct','S');
            disp(Outputfile)
        end
        
        
        % NMFWの保存 
        
        nNMF    = NMFID;
        for iNMF=1:nNMF
            clear('S')
            S.Name      = ['NMFW',num2str(nNMF,'%.2d'),'-',num2str(iNMF,'%.2d')];
            S.AnalysisType  = 'MFIELD';
            Label       = EMGprop(NMFhdr.TargetName);
            S.Label     = Label.Name;
            S.Data      = W(:,iNMF);
            S.Type      = 'NMFW';
            
            OutputDir   = fullfile(WParentDir,deext(Tarfile));
            if(~exist(OutputDir,'dir'))
                mkdir(OutputDir);
            end
            Outputfile  = fullfile(OutputDir,[S.Name,'.mat']);
            
            save(Outputfile,'-struct','S');
            disp(Outputfile)
        end
        
              
        
        

    catch
        errormsg    = ['****** Error occured in ',Tarfiles{iTar}];
        disp(errormsg)
        errorlog(errormsg);
    end
%     indicator(0,0)
    
end

warning('on');