function makeEMGNMF_btc(TimeRange,kf,nrep,nshuffle,alg)

% makeEMGNMF_btc(TimeRange,kf,nrep,nshuffle,alg)
% 
% ex
% makeEMGNMF_btc([0 480],4,10,1,'mult')

if nargin<1
    TimeRange   = [0 Inf];
    kf          = 2;
    nrep        = 5;
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<2
    kf          = 4;
    nrep        = 20;
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<3
    nrep        = 20;
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<4
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<4
    alg         = 'mult';
end

warning('off');


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
Tarfiles    = uiselect(sortxls(Tarfiles),1,'対象とするfileを選択してください');



OutputDir    = getconfig(mfilename,'OutputDir');
try
    if(~exist(OutputDir,'dir'))
        OutputDir    = pwd;
    end
catch
    OutputDir    = pwd;
end
OutputDir   = uigetdir(OutputDir,'出力フォルダを選択してください。');
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end


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
            TimeRange2  = [TimeRange(1)+Tar.TimeRange(1),TimeRange(1)+Tar.TimeRange(1)+TotalTime];
                        
            if(iTar==1)
                X   = zeros(nTar,size(Tar.Data(ind),2));
                Name = cell(nTar,1);
            end
            X(iTar,:)   = Tar.Data(ind);
            Name{iTar}  = deext(Tar.Name);
            
        end

%         % Preprocess
%         % >>>
%         % はじめの1秒間はfilterの関係などでゆがんでいる可能性があるので使わない。
%         SampleRate  = Tar.SampleRate;
%         X(:,1:SampleRate)   = [];
%         
%         % offsetがあると、それに引っ張られてNMFのコンポーネントができてしまうのでそれぞれのminを差っ引く。
%         X   = offset(X,'min');
%         
%         % Unitを揃えるためにnormalizeする。
%         normalization_method    = 'mean';
%         X     = normalize(X,normalization_method);
%         
        % negativeな値は全て０で置換する。
        X(X<0)  = 0;
        
%         % <<<
        
        [Y,Y_dat] = makeEMGNMF(X,kf,nrep,nshuffle,alg);

        
        % Postprocess
        % >>>
        [mm,nn]   = size(X);    % mm channels x nn data length
        mm=10;
        
%         % NMF解析に使ったEMGデータのはじめの1秒間に0を補間する。
%         X   = [zeros(size(X,1),SampleRate),X];
        
%         % NMF解析に使った（normalizeされた）EMGの保存
%         for iTar=1:nTar
%             Tar.Name    = [Name{iTar},'_NMFraw'];
%             Tar.Data    = X(iTar,:);
%             Tar.Unit    = normalization_method;
%             
%             Outputfile  = fullfile(ParentDir,InputDir,[Tar.Name,'.mat']);
%             
%             save(Outputfile,'-struct','Tar');
%             disp(Outputfile)
%         end
        
%         clear('X'); % Xをクリア
        
%         % 指定したNMFsizeでのcoeffとスコアを使ってEMGを再構成
%         X   = Y_dat.W{nNMF}*Y_dat.H{nNMF};
        
%         % NMF解析に使ったEMGデータのはじめの1秒間に0を補間する。
%         X   = [zeros(size(X,1),SampleRate),X];
        
%         % 再構成されたEMGの保存
%         for iTar=1:nTar
%             Tar.Name    = [Name{iTar},'-NMFreconst'];
%             Tar.Data    = X(iTar,:);
%             Tar.Unit    = normalization_method;
%             
%             Outputfile  = fullfile(ParentDir,InputDir,[Tar.Name,'.mat']);
%             
%             save(Outputfile,'-struct','Tar');
%             disp(Outputfile)
%         end
%         
%         clear('X'); % Xをクリア
        
%         % HのUnitを揃えるためにnormalizeする。
%         for ii=1:mm
%             A   = mean(Y_dat.H{ii},2);
%             Y_dat.W{ii} = Y_dat.W{ii} .* repmat(A',mm,1);
%             Y_dat.H{ii} = Y_dat.H{ii} ./ repmat(A ,1,nn);
%         end
        
%         % はじめの1秒間に0を補間する。
%         for ii=1:mm
%             Y_dat.H{ii} = [zeros(size(Y_dat.H{ii},1),SampleRate),Y_dat.H{ii}];
%         end
        
                        
%         % 指定したNMFsizeでのcoeffとスコアを保存する。
%         Y.nNMF = nNMF;
%         Y.coeff = Y_dat.W{nNMF};
%         Score   = Y_dat.H{nNMF};

        % <<<
        
        
        % EMGNMFファイルとEMGNMF_datファイルの保存
        Y.Name          = InputDir;
        Y.AnalysisType  = 'EMGNMF';
        Y.TargetName    = Name;
%         Y.TargetName    = Tarfiles;
%         Y.Unit  = normalization_method;
        Y.TimeRange     = TimeRange;
        Y.TimeRange2    = TimeRange2;
        Y.Info.TimeRange    = Tar.TimeRange;
        Y.Info.Class        = Tar.Class;
        Y.Info.SampleRate   = Tar.SampleRate;
        Y.Info.Unit         = Tar.Unit;
        
        
        Outputfile      = fullfile(OutputDir,[InputDir,'.mat']);
        Outputfile_dat  = fullfile(OutputDir,['._',InputDir,'.mat']);
        
        save(Outputfile,'-struct','Y');
        disp(Outputfile)
        
        save(Outputfile_dat,'-struct','Y_dat');
        disp(Outputfile_dat)
        
        
        
%         % NMF活動(SCORE)の保存
%         nNMF    = size(Score,1);
%         for iNMF=1:nNMF
%             Tar.Name    = ['EMGNMF',num2str(iNMF,'%02d')];
%             Tar.Data    = Score(iNMF,:);
%             Tar.Unit    = normalization_method;
%             
%             Outputfile  = fullfile(ParentDir,InputDir,[Tar.Name,'.mat']);
%             
%             save(Outputfile,'-struct','Tar');
%             disp(Outputfile)
%         end
        
        

    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
%     indicator(0,0)
    
end

warning('on');