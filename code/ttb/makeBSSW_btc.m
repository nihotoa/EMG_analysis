function makeBSSW_btc(TimeRange)

if nargin<1
    TimeRange   = [0 Inf];
end

p   = 2;        % filter order = p+1;
exl = 0.01;     % (s)  maximam lag, where to test the output independency(s)
% th  = 0.001;    % if xcorr in the above time range below this threshold, output is to be judge as independent. 
% th  = 0.00001;    % if xcorr in the above time range below this threshold, output is to be judge as independent. 
th  = 1e-3; % (%)
% th  = 1e-4; % (%)
% th  = 1e-5; % (%)
% th  = 1; % (%)

warning('off');

ParentDir    = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir    = pwd;
    end
catch
    ParentDir    = pwd;
end
ParentDir   = uigetdir(ParentDir,'EMG�̐e�t�H���_��I�����Ă��������B');
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
Reffile     = uichoice(sortxls(Tarfiles),'��͑Ώۋ�Ԃ��w�肷��Interval��������Timestamp channel��I�����Ă��������B�iBSSW�͈�ڂ̋�Ԃ̃f�[�^����v�Z���܂��j');
Tarfiles    = uiselect(sortxls(Tarfiles),1,'�ΏۂƂ���EMGfile��I�����Ă�������');


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
        clear('W','X','Ref')
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
        
        if(~isempty(Reffile))
            Ref = load(fullfile(ParentDir,InputDir,Reffile));
            
            switch Ref.Class
                case 'timestamp channel'
                    TimeRange2   = TimeRange + Ref.Data(1)./Ref.SampleRate;
                case 'interval channel'
                    TimeRange2   = TimeRange + Ref.Data(1,1);
            end
        else
            TimeRange2   = TimeRange;
        end

        
        for iTar=1:nTar
            clear('Tar')
            Tarfile     = Tarfiles{iTar};
            Inputfile   = fullfile(ParentDir,InputDir,Tarfile);
            
            Tar         = load(Inputfile);
            
            XData   = ((1:length(Tar.Data))-1)/Tar.SampleRate;
            ind     = (XData >= TimeRange2(1) & XData <= TimeRange2(2));
            exlpnt  = exl * Tar.SampleRate;
            
            
            if(iTar==1)
                X   = zeros(size(Tar.Data(ind),2),nTar);
                EMGName = cell(1,nTar);
            end
            
            temp    = Tar.Data(ind);
            % %
            % spike2�̏ꍇ�A���Ȃ����ԂŎ���Ă��Ă��f�[�^�̒������Ⴄ�ꍇ������B
            % ���̏ꍇ�́A�X�^�[�g�͈ꏏ���Ɖ��肵�ăf�[�^�̒������̂�؂��Ă��܂��B
            
            if(isfield(Tar,'PlatForm'))
                if(strcmp(Tar.PlatForm,'spike2'))
                    len1    = size(X,1);
                    len2    = length(temp);
                    
                    if(len1 ~= len2)
                        disp(['Data length mismatch!! len1=',num2str(len1),' len2=',num2str(len2)])
                    end
                    
                    if(len1 < len2)
                        temp    = temp(1:len1);
                        disp(['Data length was changed to ',num2str(len1)])
                    elseif(len1 > len2)
                        X       = X(1:len2,:);
                        disp(['Data length was changed to ',num2str(len2)])
                    end
                end
            end
            % %

            X(:,iTar)   = filter([1 -3 3 -1], 1, temp)'; % Apply 3rd order difference
            EMGName{iTar}   = deext(Tar.Name);
            disp([Tarfile,' loaded.'])

        end
        ValidEMGInd     = (mean(X,1)~=0);

        W.W   = makeBSSW(X(:,ValidEMGInd),p,exlpnt,th);
        W.AnalysisType  = 'BSSW';
        W.TimeRange     = TimeRange;
        W.TimeRange2    = TimeRange2;
        W.EMGName       = EMGName;
        W.ValidEMGInd   = ValidEMGInd;
        W.p             = p;
        W.exl           = exl;
        W.th            = th;
        W.preprocess    = 'diff3';
         disp(' W calculated.')


        Outputfile  = fullfile(OutputDir,InputDir);
        if(~exist(fileparts(Outputfile),'dir'))
            mkdir(fileparts(Outputfile));
        end
        save(Outputfile,'-struct','W');
        disp(Outputfile)
        
        
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
%     indicator(0,0)
    
end

warning('on');