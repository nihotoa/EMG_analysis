%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coded by: Naohito Ohta
% Last modification: 2022/03/29
% �ؓd�f�[�^��ECoG�f�[�^����ɂ܂Ƃ߂�&�S�Ẵf�[�^��RESAMPLE���ăT���v�����O���[�g�𑵂��邽�߂̊֐�
% �f�[�^�̘A�������ĂP���̑S�Ă̋ؓd�f�[�^����ɂ��Ă����@�\������
% �J�����g�f�B���N�g����NIBALI�ɂ��Ďg��
% �o�͌��ʂ� ���t�t�H���_ �� AllData_~.mat
% TimeRange�Ƀ^�X�N�̎n�܂�ƏI���̎��Ԃ������Ă��邪�A�����CAI_001���Q�Ƃ������̂ł��邱�Ƃɒ���
%���P�_:
%SF�́A���ꂼ��z��̃T�C�Y������ăR�[�h�������̂���ԂȂ̂ŁA�����t�@�C������ɂ܂Ƃ߂�R�[�h�������Ă��Ȃ�(�ۑ��Ώۂ��珜�O����)
%resample�����ۂ�TimeBigin,TimeEnd�̒l���C�����Ă��Ȃ��̂ŁA���̂��߂̃R�[�h�������K�v������(�S�Ẵf�[�^��TimeRange��ɕύX����)
%20220414�p�ɕύX���Ă���.���f�[�^��MAC�̃f�X�N�g�b�v�̔��ꏊ�t�H���_�̒��ɓ����Ă���
%�yprocedure�z
%pre: Copy_of_sample_data_walkthrough.m 
%post:untitled.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% Set Paremeters
exp_day = 181114;
monkey_name = 'Wa';
EMG_recording_type = 'AlphaOmega'; %'AlphaOmega'/'Ripple'
EMG_num = 16; %number of EMG
downHz = 1375;
CAI_file_num = 0; % CAI�̃f�[�^��
CRAW_file_num = 64; %CRAW�̃f�[�^��(�Ȃ����A32��80�`�����l���ɂȂ��Ă���)
CLFP_file_num = 64; %CLFP�̃f�[�^��(�Ȃ����A32��80�`�����l���ɂȂ��Ă���)
exist_EMG = 1; %EMG�f�[�^������Ƃ�1�ɂ���
no_CAI = 0; %������CAI�M�������Ă��邩�ǂ���
manual_trig = 0; %�A���t�@�I���K��manual�ő��삵�Ă���ꍇ(�ؓd�ƃ^�C�~���O����Ă��邩��ǉ��̏��������Ȃ��Ⴂ���Ȃ�)��alphaOmega�ŋؓd�v���̏ꍇ�́C0�ɂ��邱��
align_trig = 'CTTL_001'; %�ؓd�ƃA���t�@�I���K�̓����Ɏg���M��
%% code section
% �����t�@�C����A�������āA�P���̑S�ؓd�f�[�^��CEMG�ɑ������Z�N�V����
%���ړ�������'Ni'�ł���f�[�^(�ؓd�f�[�^)���J�����g�f�B���N�g������ǂݍ���
fileList1 = dir([monkey_name num2str(exp_day) '*.mat']);
for ii = 1:length(fileList1)
    load(fileList1(ii).name, 'CEMG*')
    for jj= 1:EMG_num
        eval(['CEMG_' sprintf('%03d',jj) '= cast(CEMG_' sprintf('%03d',jj) ',"double");']);
        eval(['CEMG_' sprintf('%03d',jj) '= resample(CEMG_' sprintf('%03d',jj) ',downHz,CEMG_' sprintf('%03d',jj) '_KHz*1000);']);
        eval(['sel_CEMG{jj,ii} = CEMG_' sprintf('%03d',jj) ';'])
    end
end 
All_CEMG = cell2mat(sel_CEMG);


%% search for TimeRange(TimeBegin & TimeEnd)
for ii = 1:length(fileList1) 
    %��TimeRange�ɂP���̃f�[�^��START��END�̎��Ԃ���(CEMG_001���Q��)
    load(fileList1(ii).name, 'CEMG_001_TimeBegin', 'CEMG_001_TimeEnd')
    if ii == 1 
        TimeRange(1,1) = CEMG_001_TimeBegin;
        TimeRange(1,2) = CEMG_001_TimeEnd;
    else
        TimeRange(1,2) = CEMG_001_TimeEnd;
    end
end

%% Combine multi file of CLFP
count=0;
for ii = 1:length(fileList1)
    clear CLFP_001
    load(fileList1(ii).name, 'CLFP*');
    if exist('CLFP_001') %�߂����Ꮼ�����t�@�C�����ƁACLFP�����݂��Ă��Ȃ��ꍇ������
        for jj = 1:CLFP_file_num
            if isempty(eval(['CLFP_' sprintf('%03d',jj)]))
                count=count+1;
                break
            end
            eval(['sel_CLFP{jj,ii-count} = CLFP_' sprintf('%03d',jj) ';'])
        end
    else
        count=count+1;
    end
end

for ii = 1:CLFP_file_num
    All_CLFP{ii,1} = cast(cell2mat(sel_CLFP(ii,:)),'double');
end

%% resample CRAW & combine multi file
for ii = 1:length(fileList1)
    load(fileList1(ii).name, 'CRAW*');
    for jj = 1:CRAW_file_num
        eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
        eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
        eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) ';'])
    end
end

for ii = 1:CRAW_file_num
    All_CRAW{ii,1} = cast(cell2mat(sel_CRAW(ii,:)),'double');
end

%% consolidate SaveData (�Z�[�u�f�[�^(CEMG,CAI,CTTL,CRAW,CLFP)���܂Ƃ߂�(CTTL�����́A���ƈႤ���@�ŕۑ�����))\
%CEMG�Ɋւ���
if exist_EMG == 1
    for kk = 1:EMG_num
        %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CEMG_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
        eval(['CEMG_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
        eval(['CEMG_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
        eval(['CEMG_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
    end
end

%CLFP�Ɋւ���
 if exist('All_CLFP')
     for kk = 1:CLFP_file_num
            %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
            eval(['CLFP_' sprintf('%03d',kk) ' = All_CLFP{kk,1};'])
            eval(['CLFP_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
            eval(['CLFP_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
            eval(['CLFP_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
            eval(['CLFP_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
     end
 end
 %CRAW�Ɋւ���
 for kk = 1:CRAW_file_num
        %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CRAW_' sprintf('%03d',kk) ' = All_CRAW{kk,1};'])
        eval(['CRAW_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
        eval(['CRAW_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
        eval(['CRAW_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
        eval(['CRAW_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
 end

%% save data
save_fold = fullfile(pwd, [monkey_name num2str(exp_day) '_standard']);
if not(exist(save_fold))
    mkdir(save_fold)
end
save(fullfile(save_fold, ['AllData_' monkey_name num2str(exp_day) '.mat']), 'CEMG*', 'CLFP*', 'CRAW*', 'TimeRange');





