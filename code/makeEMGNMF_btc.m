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
ParentDir   = uigetdir(ParentDir,'�e�t�H���_��I�����Ă��������B');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂ���Experiments��I�����Ă�������');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(sortxls(Tarfiles),1,'�ΏۂƂ���file��I�����Ă�������');



OutputDir    = getconfig(mfilename,'OutputDir');
try
    if(~exist(OutputDir,'dir'))
        OutputDir    = pwd;
    end
catch
    OutputDir    = pwd;
end
OutputDir   = uigetdir(OutputDir,'�o�̓t�H���_��I�����Ă��������B');
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
%         % �͂��߂�1�b�Ԃ�filter�̊֌W�Ȃǂł䂪��ł���\��������̂Ŏg��Ȃ��B
%         SampleRate  = Tar.SampleRate;
%         X(:,1:SampleRate)   = [];
%         
%         % offset������ƁA����Ɉ���������NMF�̃R���|�[�l���g���ł��Ă��܂��̂ł��ꂼ���min�����������B
%         X   = offset(X,'min');
%         
%         % Unit�𑵂��邽�߂�normalize����B
%         normalization_method    = 'mean';
%         X     = normalize(X,normalization_method);
%         
        % negative�Ȓl�͑S�ĂO�Œu������B
        X(X<0)  = 0;
        
%         % <<<
        
        [Y,Y_dat] = makeEMGNMF(X,kf,nrep,nshuffle,alg);

        
        % Postprocess
        % >>>
        [mm,nn]   = size(X);    % mm channels x nn data length
        mm=10;
        
%         % NMF��͂Ɏg����EMG�f�[�^�̂͂��߂�1�b�Ԃ�0���Ԃ���B
%         X   = [zeros(size(X,1),SampleRate),X];
        
%         % NMF��͂Ɏg�����inormalize���ꂽ�jEMG�̕ۑ�
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
        
%         clear('X'); % X���N���A
        
%         % �w�肵��NMFsize�ł�coeff�ƃX�R�A���g����EMG���č\��
%         X   = Y_dat.W{nNMF}*Y_dat.H{nNMF};
        
%         % NMF��͂Ɏg����EMG�f�[�^�̂͂��߂�1�b�Ԃ�0���Ԃ���B
%         X   = [zeros(size(X,1),SampleRate),X];
        
%         % �č\�����ꂽEMG�̕ۑ�
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
%         clear('X'); % X���N���A
        
%         % H��Unit�𑵂��邽�߂�normalize����B
%         for ii=1:mm
%             A   = mean(Y_dat.H{ii},2);
%             Y_dat.W{ii} = Y_dat.W{ii} .* repmat(A',mm,1);
%             Y_dat.H{ii} = Y_dat.H{ii} ./ repmat(A ,1,nn);
%         end
        
%         % �͂��߂�1�b�Ԃ�0���Ԃ���B
%         for ii=1:mm
%             Y_dat.H{ii} = [zeros(size(Y_dat.H{ii},1),SampleRate),Y_dat.H{ii}];
%         end
        
                        
%         % �w�肵��NMFsize�ł�coeff�ƃX�R�A��ۑ�����B
%         Y.nNMF = nNMF;
%         Y.coeff = Y_dat.W{nNMF};
%         Score   = Y_dat.H{nNMF};

        % <<<
        
        
        % EMGNMF�t�@�C����EMGNMF_dat�t�@�C���̕ۑ�
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
        
        
        
%         % NMF����(SCORE)�̕ۑ�
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