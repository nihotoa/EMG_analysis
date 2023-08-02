%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
NMF�ɂ��؃V�i�W�[���o�̕��@�𑾓c�Ǌ��̃T���̉�͗p�ɍ��������
makeEMGNMF_btcOya�̃}�C�i�[�`�F���W�o�[�W����
�E�N���X�o���f�[�V�������s��Ȃ��Ă��Anmf���s����悤�ɂȂ��Ă���(kf = 1�̂Ƃ�)
�y���P�_�z:
TimeRange2�̗p�r�𒲂ׂ�(�p�r����ł́A���g��ύX����K�v�����邩��)
makeEMGNMF_btcOya.m��Uchida�Ƃ̑���_������
GUI����̎��ɂǂ̃t�H���_��I������΂����̂��킩��Ȃ��̂�,disp���g����uigetfile�̑O�ɋL�q���Ă���(1��:day -> nmf_result 2��:day -> nmf_result -> ~_standard)
���[�v�ŉ񂵂����ꍇ�ɂ�loopmakeEMGNMF_btcOhta.m���g������

��TimeRange2,Y.Info.TimeRange���R�����g�A�E�g���Ă���̂ŁA�G���[��f���ꍇ�́A���ɖ߂�
�yprocedure�z
pre: untitled.m 
post: makefold.m
�ycaution!!!�z
normalization_method��K�X�ύX���܂��傤
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ParentDir, InputDirs, OutputDir] = makeEMGNMF_btcOhta(looped_dir,referenece_type, date, task, ParentDir, InputDirs, OutputDir) %date��task��loopMake��data_type = 'each_trial'�p;

% makeEMGNMF_btc(TimeRange,kf,nrep,nshuffle,alg)
% 
% ex
% makeEMGNMF_btc([0 480],4,10,1,'mult')
TimeRange   = [0 Inf];
kf          = 1; %�����ŁA�N���X�o���f�[�V�������s�����ǂ����A�s���ꍇ�͉��������邩��ݒ�ł���
nrep        = 20;
nshuffle    = 1;
warning('off'); %�x�����b�Z�[�W���\���ɂ���
alg         = 'mult';

ParentDir    = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir    = pwd;
    end
catch
    ParentDir    = pwd;
end


disp("�yPlease select 'monkey_name' ->'date' -> 'nmf_result' �z")
if not(exist("ParentDir") == 1)
    ParentDir   = uigetdir(ParentDir,'?e?t?H???_???I???????????????B'); %�_�C�A���O�{�b�N�X���J���āA�I�������f�B���N�g���̐�΃p�X��ParentDir�ɑ��(nmf_result��I������)
end

if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

disp("�yPlease select '~_standard' fold!�z")
if not(exist("InputDirs")==1)
    InputDirs   = uiselect(dirdir(ParentDir),1,'??????????Experiments???I??????????????'); %�g�p����EMG�f�[�^�̓����Ă���f�B���N�g����I��
end
InputDir    = InputDirs{1};
% Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
% Tarfiles    = strfilt(Tarfiles,'~._');
% Tarfiles    = uiselect(sortxls(Tarfiles),1,'??????????file???I??????????????');
Tarfiles = sortxls(dirmat(fullfile(ParentDir,InputDir))); %InputDir���̑S�Ẵt�@�C���̖��O����

disp("�yPlease select muscle data(.mat) what you want to use�z")
Tarfiles    = uiselect(Tarfiles,1,'Target?');
%Tarfiles      = load('D:\MATLABCodes\Toolboxes\force\MuscleList.mat');
% try 
% Tarfiles      = Tarfiles.TargetName;
% catch
% Tarfiles      = Tarfiles.Tarfiles;
% end

%OutputDir    = getconfig(mfilename,'OutputDir');
OutputDir = [ParentDir '/' InputDir];
try
    if(~exist(OutputDir,'dir'))
        OutputDir    = pwd;
    end
catch
    OutputDir    = pwd;
end
disp("�yPlease select save_fold to save extracted data�z")
if not(exist("OutputDir")==1)
    OutputDir   = uigetdir(OutputDir,'?o???t?H???_???I???????????????B'); %���ʂ�ۑ�����f�B���N�g����I��(�I�������f�B���N�g���̐�΃p�X��OutputDir�ɑ�������)
end
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end

try %�t�H���_�ɓ��t���܂܂�Ă��鎞��try�̒��g���g��
    % ������𕪊����ăZ���z��Ɋi�[
    switch referenece_type
        case 'monkey'
            date_str = regexp(InputDirs{1}, '\d+', 'match'); % ���K�\���Ő��������𒊏o����
            tokens = strsplit(InputDirs{1}, date_str);
        
            % �������ꂽ�������ϐ��ɑ��
            monkey_name = tokens{1}; %Ni
            add_info = tokens{2}; %_standard
        
            for ii = 1:length(looped_dir)
                InputDirs{ii} = [monkey_name num2str(looped_dir(ii)) add_info];
            end
        
            nDir    = length(InputDirs);
            nTar    = length(Tarfiles);
        
            date_str = regexp(ParentDir, '\d+', 'match'); % ���K�\���Ő�������(20220420)�𒊏o����
            tokens = strsplit(ParentDir, date_str);
        
            % �������ꂽ�������ϐ��ɑ��
            ParentDir_factor1 = tokens{1}; %~/Nibali/
            ParentDir_factor2 = tokens{2}; %/nmf_result

        case 'Human'
            if not(exist('date') == 1)
                for ii = 1:length(looped_dir)
                    InputDirs{ii} = InputDir;
                end
    
                nDir    = length(InputDirs);
                nTar    = length(Tarfiles);
    
                tokens = strsplit(ParentDir,looped_dir{1});
                ParentDir_factor1 = tokens{1};
                ParentDir_factor2 = tokens{2};
            else %date�����݂��鎞(each_trial�̂Ƃ�)
                nDir    = length(InputDirs);
                nTar    = length(Tarfiles);
            end
    end
catch
    nDir    = length(InputDirs);
    nTar    = length(Tarfiles);
end

% ���t���ƂɁCNMF���s���Ă���
for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
        try
            switch referenece_type
                case 'monkey'
                    disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
                    ParentDir = [ParentDir_factor1 num2str(looped_dir(iDir)) ParentDir_factor2];
                case 'Human'
                    path_item = split(OutputDir, '/');
                    day_idx = find(contains(path_item, 'post'));
                    if isempty(day_idx)
                        day_idx = find(contains(path_item, 'pre'));
                    end
                    if not(exist('date')==1)
                        disp([num2str(iDir),'/',num2str(nDir),':  ', path_item{day_idx} '_' looped_dir{iDir}]);
                        ParentDir = [ParentDir_factor1 looped_dir{iDir} ParentDir_factor2];
                    else
                        disp([num2str(iDir),'/',num2str(nDir),':  ', path_item{day_idx} '_' task '_Trial' num2str(iDir)]);
                    end
            end
        catch
        end
        
        for iTar=1:nTar
            clear('Tar')
            Tarfile     = Tarfiles{iTar};
            if iTar == 1 %�ǂ̂悤�ȃt�B���^�����������̂��̕����������o����(�A���t�@�x�b�g���ōŏ��ɗ���̂�Biceps�����炻�̕�����������)
                filter_contents = erase(Tarfile,'Biceps(uV)_');
            end
            Inputfile   = fullfile(ParentDir,InputDir,Tarfile); %���͈�����A��������Inputfile�ɑ��
            
            Tar     = load(Inputfile);
            
            XData   = ((1:length(Tar.Data))-1)/Tar.SampleRate; %�T���v�������T���v�����O���[�g�Ŋ����āA�b�ɒP�ʕϊ�����
            ind     = (XData >= TimeRange(1) & XData <= TimeRange(2)); %XData�̊e�v�f���ATimeRange�͈̔͂ł��邩(logic�^��0,1��Ԃ�)
            TotalTime = sum(ind)/Tar.SampleRate; %�g�p����ؓd�f�[�^���g�[�^���ŉ��b�Ԃ��H
%             TimeRange2  = [TimeRange(1)+Tar.TimeRange(1),TimeRange(1)+Tar.TimeRange(1)+TotalTime]; %���Ɏg�����킩��Ȃ����A������낵���Ȃ��f�[�^�������Ă���
                        
            if(iTar==1) %iTar��for������čX�V�����(1~�g�p����ؓd�f�[�^�̐�)�@���f�[�^X�̔z���p�ӂ���
                X   = zeros(nTar,size(Tar.Data(ind),2));
                Name = cell(nTar,1);
            end
            X(iTar,:)   = Tar.Data(ind); %���f�[�^X�ɑI�������ؓd�f�[�^�������Ă���
            Name{iTar}  = deext(Tar.Name);
            
        end

        % Preprocess
        % >>>
        % ????????1?b????filter?????W?????????????????????\?????????????g???????B
        SampleRate  = Tar.SampleRate;
%         X(:,1:SampleRate)   = [];
        
        % offset?????????A??????????????????NMF???R???|?[?l???g????????????????????????????min???????????B
        X   = offset(X,'min'); %�ؓd�̐U���̊����ς���(min:�e�ؓd�̗v�f���炻�̋ؓd�̍Œ�l������ mean:�e�ؓd�̗v�f���炻�̋ؓd�̍Œ�l������)
        
        % Unit??????????????normalize?????B
        normalization_method    = 'mean';
        X     = normalize(X,normalization_method); %�U���𐳋K��(�U���̕��ϒl�Ŋ���)
        
        % negative???l???S???O???u???????B
        X(X<0)  = 0; %�񕉍s����q�����Ȃ̂ŁA�񕉒l���Ȃ���
        
%         % <<<
        
        [Y,Y_dat] = makeEMGNMFOhta(X,kf,nrep,nshuffle,alg,normalization_method); %�������~�\

        
        % Postprocess
        % >>>
        [mm,nn]   = size(X);    % mm channels x nn data length
        
        
        % NMF???????g????EMG?f?[?^??????????1?b????0???????????B
%         X   = [zeros(size(X,1),SampleRate),X];
%         
%         % NMF???????g?????inormalize???????jEMG??????
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
%         
%         clear('X'); % X???N???A
%         nNMF=2;
%         % ?w??????NMFsize????coeff???X?R?A???g????EMG?????\??
%         X   = Y_dat.W{nNMF}*Y_dat.H{nNMF};
%         
%         % NMF???????g????EMG?f?[?^??????????1?b????0???????????B
%         X   = [zeros(size(X,1),SampleRate),X];
%         
%         % ???\????????EMG??????
%         for iTar=1:nTar
%             Tar.Name    = [Name{iTar},'-NMFreconst'];
%             Tar.Data    = X(iTar,:);
%             Tar.Unit    = normalization_method;
%             
%             Outputfile  = fullfile(ParentDir,InputDir,[Tar.Name,'.mat']);
% %             
% %             save(Outputfile,'-struct','Tar');
% %             disp(Outputfile)
% %         end
%         
%         clear('X'); % X???N???A
        
%         % H??Unit??????????????normalize?????B
%         for ii=1:mm
%             A   = mean(Y_dat.test.H{ii},2);
%             Y_dat.test.W{ii} = Y_dat.test.W{ii} .* repmat(A',mm,1);
%             Y_dat.test.H{ii} = Y_dat.test.H{ii} ./ repmat(A ,1,nn);
%         end

        
        % ????????1?b????0???????????B
%         for ii=1:mm
%             Y_dat.test.H{ii} = [zeros(size(Y_dat.test.H{ii},1),SampleRate),Y_dat.test.H{ii}];
%         end
%         
                        
%         % ?w??????NMFsize????coeff???X?R?A???????????B
%         Y.nNMF = nNMF;
%         Y.coeff = Y_dat.test.W{nNMF};
%         Score   = Y_dat.test.H{nNMF};

        % <<<
        
        
        % EMGNMF?t?@?C????EMGNMF_dat?t?@?C????????
        Y.Name          = InputDir;
        Y.AnalysisType  = 'EMGNMF';
        Y.TargetName    = Name;
%         Y.TargetName    = Tarfiles;
%         Y.Unit  = normalization_method;
        Y.TimeRange     = TimeRange;
%         Y.TimeRange2    = TimeRange2;
%         Y.Info.TimeRange    = Tar.TimeRange;
        Y.Info.Class        = Tar.Class;
        Y.Info.SampleRate   = Tar.SampleRate;
        Y.Info.Unit         = Tar.Unit;
        
        %��͌��ʂ�ۑ�����Z�N�V����(�N���X�o���f�[�V�����������̂����Ă��Ȃ��̂��A�ǂ��̋ؓd�f�[�^�Ȃ̂�(tim2����Ȃ�)�𖾋L���ׂ�
        if kf == 1 %�N���X�o���f�[�V���������Ă��Ȃ��Ƃ�
            switch referenece_type
                case 'monkey'
                    try
                        if iDir == 1 %�����̎�
                            temp = regexp(OutputDir, '\d+', 'match');
                            num_part = temp{1};
                        end
                        OutputDir_EX = strrep(OutputDir, num_part, num2str(looped_dir(iDir))); %OutputDir�𓥏P�����ŏI�I��OutputDir
                        Outputfile      = fullfile(OutputDir_EX,[InputDir '_NoFold_' filter_contents]); %filter_contents�ɂ�.mat�܂ł̕����񂪊܂܂�Ă��邩��.mat������K�v�Ȃ�
                        Outputfile_dat  = fullfile(OutputDir_EX,['t_',InputDir '_NoFold_' filter_contents]);
        
                        save(Outputfile,'-struct','Y');
                        disp(Outputfile)
        
                        save(Outputfile_dat,'-struct','Y_dat');
                        disp(Outputfile_dat)
                    catch
                        Outputfile      = fullfile(OutputDir,[InputDir,'.mat']);
                        Outputfile_dat  = fullfile(OutputDir,['t_',InputDir,'.mat']);
        
                        save(Outputfile,'-struct','Y');
                        disp(Outputfile)
        
                        save(Outputfile_dat,'-struct','Y_dat');
                        disp(Outputfile_dat)
                    end
                case 'Human'
                    try 
                        if not(exist('date') == 1)
                            % task�̃��[�v�ɂ��outputDir�̕ύX
                            OutputDir_EX = strrep(OutputDir, looped_dir{1}, looped_dir{iDir}); %OutputDir�𓥏P�����ŏI�I��OutputDir
                            Outputfile = fullfile([OutputDir_EX '/' looped_dir{iDir} '_standard_Nofold.mat']); %filter_contents�ɂ�.mat�܂ł̕����񂪊܂܂�Ă��邩��.mat������K�v�Ȃ�
                            Outputfile_dat = fullfile([OutputDir_EX '/' 't_' looped_dir{iDir} '_standard_Nofold.mat']); 
                        else %each_trial�̎�
                            OutputDir_EX = strrep(OutputDir, ['trial' sprintf('%02d', 1)], ['trial' sprintf('%02d', iDir)]);
                            Outputfile = fullfile([OutputDir_EX '/' task '_standard_Nofold.mat']); 
                            Outputfile_dat = fullfile([OutputDir_EX '/' 't_' task '_standard_Nofold.mat']); 
                        end
        
                        save(Outputfile,'-struct','Y');
                        disp(Outputfile)
        
                        save(Outputfile_dat,'-struct','Y_dat');
                        disp(Outputfile_dat)
                    catch
                        error('�ǂ����ŃG���[��f���Ă��܂��D��蒼���Ă�������')
                    end
            end
        else %�N���X�o���f�[�V������������(�N���X�o���f�[�V����������Ƃ��͑S�̃f�[�^�ɑ΂��ċ؃V�i�W�[��͂�����)
            Outputfile      = fullfile(OutputDir_EX,[InputDir '_' num2str(kf) 'Fold.mat']);
            Outputfile_dat  = fullfile(OutputDir_EX,['t_',InputDir '_' num2str(kf) 'Fold.mat']);
            
            save(Outputfile,'-struct','Y');
            disp(Outputfile)
            
            save(Outputfile_dat,'-struct','Y_dat');
            disp(Outputfile_dat)
        end
        
        
        
%         % NMF????(SCORE)??????
%         Score=Y_dat.test.H;
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
%         
        

    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
        % �G���[�����擾���ĕ\��
        err = lasterror;
        disp(err.message);

        % �G���[�����������t�@�C�����ƍs�ԍ����擾���ĕ\��
        file = err.stack(1).file;
        line = err.stack(1).line;
        disp(['Error in file: ', file, ' at line ', num2str(line)]);
    end
%     indicator(0,0)
    
end

%MailClient;
%sendmail('toya@ncnp.go.jp',InputDir,'makeEMGNMF_btc Analysis Done!!!');
warning('on');
