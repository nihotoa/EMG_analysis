function applyEMGNMFW_btc(W,TimeRange,nrep,alg)
% W   size(W) = n x m の重み付け行列　EMGNMFの場合、n=EMGの数、m=シナジーの数。

if nargin<1
    error('W must be needed.')
elseif nargin<2
    TimeRange   = [0 Inf];
    nrep        = 10;
    alg         = 'mult';
elseif nargin<3
    nrep        = 10;
    alg         = 'mult';
elseif nargin<4
    alg         = 'mult';
end

if(isempty(W))
    xlsload(-1,'W');
    if(iscell(W))
       disp('W must be numeric.')
       return;
    end
end



[nEMG,nW]   = size(W);

ParentDir    = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir    = pwd;
    end
catch
    ParentDir    = pwd;
end
ParentDir   = uigetdir(ParentDir,'親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(sortxls(Tarfiles),1,['対象とするfileを選択してください (n=',num2str(nEMG),')']);

suffix      = getconfig(mfilename,'suffix');
if(isempty(suffix))
    suffix  = datestr(now,'yyyymmdd');
end
suffix      = inputdlg({'suffix:'},'Suffix for NMFH and reconstructed EMGs',1,{suffix});
suffix      = suffix{1};
setconfig(mfilename,'suffix',suffix);

nDir    = length(InputDirs);
nTar    = length(Tarfiles);


for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
        
        for iTar=1:nTar
            clear('Tar')
            Tarfile     = Tarfiles{iTar};
            Inputfile   = fullfile(ParentDir,InputDir,Tarfile);
            
            Tar     = load(Inputfile);
            
            XData   = ((1:length(Tar.Data))-1)/Tar.SampleRate;
            ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));
            TotalTime=sum(ind)/Tar.SampleRate;
            TimeRange2  = [Tar.TimeRange(1),Tar.TimeRange(1)+TotalTime];
            
            if(iTar==1)
                X   = zeros(nTar,size(Tar.Data(ind),2));
                Name = cell(nTar,1);
            end
            X(iTar,:)   = Tar.Data(ind);
            Name{iTar}  = deext(Tar.Name);
            
        end
        
        %>> preprocess 
        % negativeな値は全て０で置換する。
        % X   =max(X,0);
        
        % X  = normalize(X,'mean');
        
        if(any(X<0))
            disp('Data contains negative values. Data must be non-negative!')
            return;
        end

        % << preprocess

        
%         % 解析元となるEMGの保存
%         for iTar=1:nTar
%             clear('S')
%             S.TimeRange = TimeRange2;
%             S.Name      = [deext(Tarfiles{iTar}),'-NMF',num2str(nW,'%.2d'),'-original',suffix];
%             S.Class     = Tar.Class;
%             S.SampleRate= Tar.SampleRate;
%             S.Data      = X(iTar,:);
%             S.Unit      = 'mean';
%             
%             OutputDir   = fullfile(ParentDir,InputDir);
%             if(~exist(OutputDir,'dir'))
%                 mkdir(OutputDir);
%             end
%             Outputfile  = fullfile(OutputDir,[S.Name,'.mat']);
%             
%             save(Outputfile,'-struct','S');
%             disp(Outputfile)
%         end
        
        % WをapplyしてHを推定する（Wは更新しない）
        [W2,H]   = nnmf2(X,nW,W,[],nrep,alg,'h','none','none');
        
        % EMGの再構成
        X   = W2*H; % reconstucted EMG
        
        % 再構成されたEMGの保存
        for iTar=1:nTar
            clear('S')
            S.TimeRange = TimeRange2;
            S.Name      = [deext(Tarfiles{iTar}),'-NMF',num2str(nW,'%.2d'),'-reconst',suffix];
            S.Class     = Tar.Class;
            S.SampleRate= Tar.SampleRate;
            S.Data      = X(iTar,:);
            S.Unit      = Tar.Unit;
            
            OutputDir   = fullfile(ParentDir,InputDir);
            if(~exist(OutputDir,'dir'))
                mkdir(OutputDir);
            end
            Outputfile  = fullfile(OutputDir,[S.Name,'.mat']);
            
            save(Outputfile,'-struct','S');
            disp(Outputfile)
        end
        
        clear('X'); % Xをクリア
        
        
        % 再構成の各コンポーネントの保存
        for iTar=1:nTar
            for iW=1:nW
                clear('S')
                S.TimeRange = TimeRange2;
                S.Name      = [deext(Tarfiles{iTar}),'-NMF',num2str(nW,'%.2d'),'-component',num2str(iW,'%.2d'),suffix];
                S.Class     = Tar.Class;
                S.SampleRate= Tar.SampleRate;
                S.Data      = W2(iTar,iW)*H(iW,:);
                S.Unit      = Tar.Unit;
                
                OutputDir   = fullfile(ParentDir,InputDir);
                if(~exist(OutputDir,'dir'))
                    mkdir(OutputDir);
                end
                Outputfile  = fullfile(OutputDir,[S.Name,'.mat']);
                
                save(Outputfile,'-struct','S');
                disp(Outputfile)
            end
        end
        
        
        % NMFHの保存
        
        for iNMF=1:nW
            clear('S')
            S.TimeRange = TimeRange2;
            S.Name      = ['NMFH',num2str(nW,'%.2d'),'-',num2str(iNMF,'%.2d'),suffix];
            S.Class     = Tar.Class;
            S.SampleRate= Tar.SampleRate;
            S.Data      = H(iNMF,:);
            S.Unit      = Tar.Unit;
            
            OutputDir   = fullfile(ParentDir,InputDir);
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