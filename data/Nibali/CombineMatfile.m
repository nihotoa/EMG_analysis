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
function [] = CombineMatfile(exp_day,real_name_day)
%% Set Paremeters
% exp_day = 20220722;
% real_name_day = 220722;
monkey_name = 'Ni';
real_name = 'F';%�A���t�@�I���K�����.mat�t�@�C���̐ړ���
EMG_num = 16;
downHz = 1375;
CAI_file_num = 1; % CAI�̃f�[�^��
% CTTL_file_num = 3; %CTTL�̃f�[�^��(����ł�001�����R�[�h���(�g�p���Ȃ�)002���t�H�g�Z��,003������)3���f�t�H
CRAW_file_num = 80; %CRAW�̃f�[�^��(�Ȃ����A32��80�`�����l���ɂȂ��Ă���)
CLFP_file_num = 80; %CLFP�̃f�[�^��(�Ȃ����A32��80�`�����l���ɂȂ��Ă���)
exist_EMG = 1; %EMG�f�[�^������Ƃ�1�ɂ���
manual_trig = 1; %�A���t�@�I���K��manual�ő��삵�Ă���ꍇ(�ؓd�ƃ^�C�~���O����Ă��邩��ǉ��̏��������Ȃ��Ⴂ���Ȃ�)
align_trig = 'CTTL_001'; %�ؓd�ƃA���t�@�I���K�̓����Ɏg���M��
%% code section

% �����t�@�C����A�������āA�P���̑S�ؓd�f�[�^��CEMG�ɑ������Z�N�V����
cd(num2str(exp_day));
%���ړ�������'Ni'�ł���f�[�^(�ؓd�f�[�^)���J�����g�f�B���N�g������ǂݍ���
if exist_EMG == 1
    fileList1 = dir([monkey_name num2str(exp_day) '*.mat']);
end
%���ړ�������'F'�ł���f�[�^(�]�g�ƃ^�C�~���O�̃f�[�^)���J�����g�f�B���N�g������ǂݍ���
fileList2 = dir([real_name num2str(real_name_day) '*.mat']);
if exist_EMG == 1
    for ii = 1:length(fileList1)
        load(fileList1(ii).name)
        for jj= 1:EMG_num
            eval(['sel_CEMG{jj,ii} = CEMG_' sprintf('%03d',jj) ';'])
        end
    end 
    All_CEMG = cell2mat(sel_CEMG);
end


%% resample CAI & combine multi file
if manual_trig==1
    [TimeRange,sel_CAI] = AlignStart(fileList2,downHz,align_trig,All_CEMG,'CAI');
elseif manual_trig==0 %���܂ł̃f�t�H
    for ii = 1:length(fileList2) 
        load(fileList2(ii).name)
        %��TimeRange�ɂP���̃f�[�^��START��END�̎��Ԃ���(CAI_001���Q�Ƃ��Ă���)
        if ii == 1 
            TimeRange(1,1) = CAI_001_TimeBegin;
            TimeRange(1,2) = CAI_001_TimeEnd;
        else
            TimeRange(1,2) = CAI_001_TimeEnd;
        end

        for jj=1:CAI_file_num
            eval(['CAI_' sprintf('%03d',jj) '= cast(CAI_' sprintf('%03d',jj) ',"double");']);
            eval(['CAI_' sprintf('%03d',jj) '= resample(CAI_' sprintf('%03d',jj) ',downHz,CAI_001_KHz*1000);']);
            eval(['CAI_' sprintf('%03d',jj) '_KHz = downHz/1000;']);
            eval(['CAI_' sprintf('%03d',jj) '_KHz_Orig = downHz/1000;']);
            eval(['sel_CAI{jj,ii} = CAI_' sprintf('%03d',jj) ';'])
        end
    end
end
%�ؓd��CAI�̃^�C�~���O�𑵂���
%��alphaomega�����mat�t�@�C���������������Ƃ��ɘA�����邽�߂Ɉ�x���̕ϐ��𒇉��
All_CAI = cell2mat(sel_CAI);

%��ALL_CAI��p���ĘA������
%{
for kk = 1:CAI_file_num
    eval(['CAI_' sprintf('%03d',kk) ' = All_CAI(kk,:);'])
end
%}

%% resample CTTL & combine multi file(���ƈ���āA�����t�@�C���ɑΉ����Ă��Ȃ�(���))
for ii = 1:length(fileList2)
    clear CTTL_002*
    clear CTTL_003*
    load(fileList2(ii).name);
    %���̕ϐ��ƈ���āAUP��DOWN��2��ނ̕ϐ�������+�_�E���T���v�����O����Ȃ��āA�ϐ��̒��g�̒l��1.375/44����
    if exist('CTTL_002_Down') %�ꍇ�ɂ���ẮA���g���قƂ�ǂȂ�mat�t�@�C��������̂ŁA���̑΍��p
        %��CTTL_file_num�����肷��
        if ii == 1
            if length(CTTL_003_Up) <= 1 %CTTL_003�̒��g���Ȃ��Ƃ�
                CTTL_file_num = 2;
            elseif length(CTTL_003_Up) > 1%CTTL_003�̒��g������Ƃ�
                CTTL_file_num = 3;
            end
        end
        
        for jj= 2:CTTL_file_num %CTTL_001�͕s�v�Ȃ̂ŁA2����X�^�[�g
            %��success_signal(CTTL_003)�̓r�؂�Ă���f�[�^������������
            if jj == 3
                if ii>1
                    clear success_signal
                    clear judge frame
                    clear correct_signal %���Ԃ񂱂ꂪ�X�V����Ă��Ȃ������̂�����
                end
                if exist('CTTL_003_Up') %CTTL_003_UP�Ƃ����ϐ������݂��Ȃ��ꍇ�́A�������s��Ȃ�(���̃t�@�C���ɂ̓^�X�N�̃f�[�^���܂܂�Ă��Ȃ����Ă���)
                    count = 1;
                    if length(CTTL_003_Up) == length(CTTL_003_Down) %UP��DOWN�̉񐔂������Ƃ�
                        success_signal = [CTTL_003_Up;CTTL_003_Down];
                    elseif length(CTTL_003_Up) > length(CTTL_003_Down) %UP��DOWN�̉񐔂��Ⴄ��(UP���Ƀt�@�C�����؂�ւ���Ă��܂�����)
                        success_signal = [CTTL_003_Up(1,1:end-1);CTTL_003_Down];
                        final_signal_time = CTTL_003_TimeEnd; %���̃t�@�C���̑���(����elseif��)�Ŏg��
                    elseif length(CTTL_003_Up) < length(CTTL_003_Down) %UP��DOWN�̉񐔂��Ⴄ��(UP���Ƀt�@�C�����؂�ւ���Ă��܂������̌��̃t�@�C���̂����)
                        first_Up_frame = round((final_signal_time - CTTL_003_TimeBegin)*44000);
                        CTTL_003_Up = [first_Up_frame CTTL_003_Up];
                        success_signal = [CTTL_003_Up;CTTL_003_Down];
                    end
                    %sel_final_frame(1,ii) = max(success_signal(:)); %���̃t�@�C���Ƃ̌݊��̂��߂ɒ�`(�����{�^��(CTTL_003))
                    for kk = 1:length(success_signal)
                        judge_frame = success_signal(2,kk) - success_signal(1,kk);
                        if judge_frame > 100
                            correct_signal(:,count) = [success_signal(1,kk);success_signal(2,kk)];
                            count = count + 1;
                        end
                    end
                    CTTL_003_Up = correct_signal(1,:);
                    CTTL_003_Down = correct_signal(2,:);
                end
            end
            if CTTL_file_num == 2
                eval(['CTTL_' sprintf('%03d',jj) '_Up = cast(CTTL_' sprintf('%03d',jj) '_Up' ',"double");']);
                eval(['CTTL_' sprintf('%03d',jj) '_Down = cast(CTTL_' sprintf('%03d',jj) '_Down' ',"double");']);
                eval(['CTTL_' sprintf('%03d',jj) '_Up = round(CTTL_' sprintf('%03d',jj) '_Up * (downHz/(CTTL_' sprintf('%03d',jj) '_KHz*1000)));']);
                eval(['CTTL_' sprintf('%03d',jj) '_Down = round(CTTL_' sprintf('%03d',jj) '_Down * (downHz/(CTTL_' sprintf('%03d',jj) '_KHz*1000)));']);
                eval(['CTTL_' sprintf('%03d',jj) '_KHz = downHz/1000;']);
                eval(['CTTL_' sprintf('%03d',jj) '_KHz_Orig = downHz/1000;']);
                %���A���̂��߂ɕK�v�ȍ��
                eval(['sel_CTTL_' sprintf('%03d',jj) '_Up{1,ii} = CTTL_' sprintf('%03d',jj) '_Up;'])
                eval(['sel_CTTL_' sprintf('%03d',jj) '_Down{1,ii} = CTTL_' sprintf('%03d',jj) '_Down;'])
                eval(['sel_CTTL_' sprintf('%03d',jj) '_TimeBegin(1,ii) = CTTL_' sprintf('%03d',jj) '_TimeBegin;'])
                eval(['sel_CTTL_' sprintf('%03d',jj) '_TimeEnd(1,ii) = CTTL_' sprintf('%03d',jj) '_TimeEnd;'])
            elseif CTTL_file_num == 3
                if exist('CTTL_003_Up') 
                    eval(['CTTL_' sprintf('%03d',jj) '_Up = cast(CTTL_' sprintf('%03d',jj) '_Up' ',"double");']);
                    eval(['CTTL_' sprintf('%03d',jj) '_Down = cast(CTTL_' sprintf('%03d',jj) '_Down' ',"double");']);
                    eval(['CTTL_' sprintf('%03d',jj) '_Up = round(CTTL_' sprintf('%03d',jj) '_Up * (downHz/(CTTL_' sprintf('%03d',jj) '_KHz*1000)));']);
                    eval(['CTTL_' sprintf('%03d',jj) '_Down = round(CTTL_' sprintf('%03d',jj) '_Down * (downHz/(CTTL_' sprintf('%03d',jj) '_KHz*1000)));']);
                    eval(['CTTL_' sprintf('%03d',jj) '_KHz = downHz/1000;']);
                    eval(['CTTL_' sprintf('%03d',jj) '_KHz_Orig = downHz/1000;']);
                    %���A���̂��߂ɕK�v�ȍ��
                    eval(['sel_CTTL_' sprintf('%03d',jj) '_Up{1,ii} = CTTL_' sprintf('%03d',jj) '_Up;'])
                    eval(['sel_CTTL_' sprintf('%03d',jj) '_Down{1,ii} = CTTL_' sprintf('%03d',jj) '_Down;'])
                    eval(['sel_CTTL_' sprintf('%03d',jj) '_TimeBegin(1,ii) = CTTL_' sprintf('%03d',jj) '_TimeBegin;'])
                    eval(['sel_CTTL_' sprintf('%03d',jj) '_TimeEnd(1,ii) = CTTL_' sprintf('%03d',jj) '_TimeEnd;'])
                end
            end
        end
    end
end
%�����Ƀ^�C�~���O�f�[�^�̏������L�q����
%sel_final_frame = round(sel_final_frame*(1375/44000));%finalframe���_�E���T���v�����O
for kk = 2:CTTL_file_num %kk:CTTL�̐�(002��003)
    if CTTL_file_num == 3
        for ll = 1:length(sel_CTTL_003_Up) %length(fileList2)���ƃ^�X�N�f�[�^�̓����Ă��Ȃ��t�@�C�����������Ƃ��ɑΏ��ł��Ȃ�(sel_CTTL�Ƃ̔z�񐔂̈Ⴂ�ŃG���[�f��) 
            %error_sampling = (sel_CTTL_00kk_TimeBegin(1,ll)-TimeRange(1,1)) * downHz;
            %sel_CTTL_00kk{ll,1} = error_sampling + sel_CTTL_00kk{ll,1} ;
            error_sampling = round(eval(['(sel_CTTL_' sprintf('%03d',kk) '_TimeBegin(1,ll) - TimeRange(1,1)) * downHz']));
            eval(['sel_CTTL_' sprintf('%03d',kk) '_Down{1,ll} = error_sampling + sel_CTTL_' sprintf('%03d',kk) '_Down{1,ll}'])
            eval(['sel_CTTL_' sprintf('%03d',kk) '_Up{1,ll} = error_sampling + sel_CTTL_' sprintf('%03d',kk) '_Up{1,ll}'])
        end
    elseif CTTL_file_num == 2 %success�V�O�i�����Ȃ��Ƃ�
        for ll = 1:length(sel_CTTL_002_Up) 
            %error_sampling = (sel_CTTL_00kk_TimeBegin(1,ll)-TimeRange(1,1)) * downHz;
            %sel_CTTL_00kk{ll,1} = error_sampling + sel_CTTL_00kk{ll,1} ;
            error_sampling = round(eval(['(sel_CTTL_' sprintf('%03d',kk) '_TimeBegin(1,ll) - TimeRange(1,1)) * downHz']));
            eval(['sel_CTTL_' sprintf('%03d',kk) '_Down{1,ll} = error_sampling + sel_CTTL_' sprintf('%03d',kk) '_Down{1,ll}'])
            eval(['sel_CTTL_' sprintf('%03d',kk) '_Up{1,ll} = error_sampling + sel_CTTL_' sprintf('%03d',kk) '_Up{1,ll}'])
        end
    end
end

if CTTL_file_num == 2
    sel_CTTL_002_Up = cell2mat(sel_CTTL_002_Up);
    sel_CTTL_002_Down = cell2mat(sel_CTTL_002_Down);
    sel_CTTL_002_TimeBegin = TimeRange(1,1);
    sel_CTTL_002_TimeEnd = sel_CTTL_002_TimeEnd(1,ll);
elseif CTTL_file_num == 3
    sel_CTTL_002_Up = cell2mat(sel_CTTL_002_Up);
    sel_CTTL_002_Down = cell2mat(sel_CTTL_002_Down);
    sel_CTTL_002_TimeBegin = TimeRange(1,1);
    sel_CTTL_002_TimeEnd = sel_CTTL_002_TimeEnd(1,ll);
    sel_CTTL_003_Up = cell2mat(sel_CTTL_003_Up);
    sel_CTTL_003_Down = cell2mat(sel_CTTL_003_Down);
    sel_CTTL_003_TimeBegin = TimeRange(1,1);
    sel_CTTL_003_TimeEnd = sel_CTTL_003_TimeEnd(1,ll);
end
%{
for kk = 2:CTTL_file_num %kk:�M���̐� ll:�t�@�C���̐�
    e1 = round((eval(['sel_CTTL_' sprintf('%03d',kk) '_TimeBegin(1,1)'])-TimeRange(1,1)) * downHz); %�e�^�C�~���O�M���̊J�n�ƁA���R�[�h�̊J�n�Ƃ̃t���[���덷
    eval(['sel_CTTL_' sprintf('%03d',kk) '_Up{1,1} = e1 + sel_CTTL_' sprintf('%03d',kk) '_Up{1,1};'])
    eval(['sel_CTTL_' sprintf('%03d',kk) '_Down{1,1} = e1 + sel_CTTL_' sprintf('%03d',kk) '_Down{1,1};'])
    %��1�t�@�C���ڂɕ΍���K�p
    for ll= 1:length(fileList2)
        if ll == 1 %�t�@�C������1�̂Ƃ��͉��̏��������Ȃ�

        else
            if kk == 2 %CTTL_002�̂Ƃ�
                e_pre = round((sel_CTTL_002_TimeBegin(ll) - sel_CTTL_002_TimeEnd(ll-1)) * downHz);
                %��Up��Down�̋L�^�񐔂��قȂ�ꍇ������̂ŁA��������őΉ�(�t�H�g�Z�����������Ă��鎞�Ɏ��̃t�@�C���ɍs���ƁA�L�^�񐔂��قȂ�)
                %pre_file�́A��O�̃t�@�C���̍Ō�̃t���[����(pre_final_frame)�̒��o�ɕK�v
                if length(sel_CTTL_002_Down{1,ll-1}) == length(sel_CTTL_002_Up{1,ll-1})
                    pre_file = [sel_CTTL_002_Down{1,ll-1};sel_CTTL_002_Up{1,ll-1}];
                elseif length(sel_CTTL_002_Down{1,ll-1}) < length(sel_CTTL_002_Up{1,ll-1})
                    e_length = length(sel_CTTL_002_Up{1,ll-1}) - length(sel_CTTL_002_Down{1,ll-1});
                    tent_sel_CTTL_002_Down = [sel_CTTL_002_Down{1,ll-1},NaN(1,e_length)];
                    pre_file = [tent_sel_CTTL_002_Down;sel_CTTL_002_Up{1,ll-1}];
                elseif length(sel_CTTL_002_Down{1,ll-1}) > length(sel_CTTL_002_Up{1,ll-1})
                    e_length = length(sel_CTTL_002_Down{1,ll-1}) - length(sel_CTTL_002_Up{1,ll-1});
                    tent_sel_CTTL_002_Up = [sel_CTTL_002_Up{1,ll-1},NaN(1,e_length)];
                    pre_file = [sel_CTTL_002_Down{1,ll-1};tent_sel_CTTL_002_Up];
                end
                pre_final_frame = max(pre_file(:));
                sel_CTTL_002_Up{1,ll} = (pre_final_frame + e_pre) + sel_CTTL_002_Up{1,ll};
                sel_CTTL_002_Down{1,ll} = (pre_final_frame + e_pre) + sel_CTTL_002_Down{1,ll};
                if ll == length(fileList2)
                    sel_CTTL_002_Up = cell2mat(sel_CTTL_002_Up);
                    sel_CTTL_002_Down = cell2mat(sel_CTTL_002_Down);
                    sel_CTTL_002_TimeBegin = TimeRange(1,1);
                    sel_CTTL_002_TimeEnd = sel_CTTL_002_TimeEnd(1,ll);
                end
                
            elseif kk == 3 %CTTL_003�̂Ƃ�
                sel_final_frame = e1 + sel_final_frame; %sel_final_frame���ACAI�̊�ɕϊ�
                e_pre = round((sel_CTTL_003_TimeBegin(ll) - sel_CTTL_003_TimeEnd(ll-1)) * downHz);
                sel_CTTL_003_Up{1,ll} = (sel_final_frame(1,ll-1) + e_pre) + sel_CTTL_003_Up{1,ll};
                sel_CTTL_003_Down{1,ll} = (sel_final_frame(1,ll-1) + e_pre) + sel_CTTL_003_Down{1,ll};
                if ll == length(fileList2)
                    sel_CTTL_003_Up = cell2mat(sel_CTTL_003_Up);
                    sel_CTTL_003_Down = cell2mat(sel_CTTL_003_Down);
                    sel_CTTL_003_TimeBegin = TimeRange(1,1);
                    sel_CTTL_003_TimeEnd = sel_CTTL_003_TimeEnd(1,ll);
                end
            end
        end
    end
end
%}
%% Combine multi file of CLFP
if manual_trig==1
    count=0;
  for ii = 1:length(fileList2)
      clear CLFP_001
      load(fileList2(ii).name)
      if exist('CLFP_001')
          if ii == 1 %��ԍŏ��̃t�@�C��(����Ȃ������������K�v����)
              trash_sec = TimeRange(1) - CAI_001_TimeBegin; %����Ȃ��b��
              trash_sample = round(trash_sec*downHz);
              for jj = 1:CLFP_file_num
                   eval(['sel_CLFP{jj,ii-count} = CLFP_' sprintf('%03d',jj) '(1,trash_sample+1:end);'])
              end
          elseif TimeRange(1)<CAI_001_TimeBegin && TimeRange(2)>CAI_001_TimeEnd
              for jj = 1:CLFP_file_num
                   eval(['sel_CLFP{jj,ii-count} = CLFP_' sprintf('%03d',jj) ';'])
              end
          else %��ԍŌ�̃t�@�C��
              e_LastSec = CAI_001_TimeEnd - TimeRange(2);
              e_LastFrame = round(e_LastSec * downHz);
              for jj = 1:CLFP_file_num
                   eval(['sel_CLFP{jj,ii-count} = CLFP_' sprintf('%03d',jj) '(1,1:end - e_LastFrame+1);'])
              end
          end
      else
          count=count+1;
      end
  end
elseif manual_trig==0
    count=0;
    for ii = 1:length(fileList2)
        clear CLFP_001
        load(fileList2(ii).name);
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
end


for ii = 1:CLFP_file_num
    All_CLFP{ii,1} = cast(cell2mat(sel_CLFP(ii,:)),'double');
end
%
%All_CLFP = cast(cell2mat(sel_CLFP),'double'); %�Ȃ��������t�@�C���ɂ����āACLFP�̔z��̐����قȂ�`�����l�������邩��Acell2mat�ł��Ȃ�(4/26,27�̗���)(�f�[�^���̖̂���1375/1���炢�Ȃ̂łقƂ�ǖ��Ȃ���,cell2mat���ł��Ȃ�)
%{
for kk = 1:CLFP_file_num
    eval(['CLFP_' sprintf('%03d',kk) ' = All_CLFP(kk,:);'])
end
%}
%% resample CRAW & combine multi file
if manual_trig == 1
    for ii=1:length(fileList2)
        load(fileList2(ii).name);
        if ii == 1 %��ԍŏ��̃t�@�C��(����Ȃ������������K�v����)
            for jj = 1:CRAW_file_num
                 eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
                 eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
                 eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) '(1,trash_sample+1:end);'])
            end
        elseif TimeRange(1)<CAI_001_TimeBegin && TimeRange(2)>CAI_001_TimeEnd
            for jj = 1:CRAW_file_num
                 eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
                 eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
                 eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) '(1,:);'])
            end
        else %��ԍŌ�̃t�@�C��
            for jj = 1:CRAW_file_num
                 eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
                 eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
                 eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) '(1,1:end - e_LastFrame+1);'])
            end
        end
    end
elseif manual_trig == 0
    for ii = 1:length(fileList2)
        load(fileList2(ii).name);
        for jj = 1:CRAW_file_num
            eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
            eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
            eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) ';'])
        end
    end
end

for ii = 1:CRAW_file_num
    All_CRAW{ii,1} = cast(cell2mat(sel_CRAW(ii,:)),'double');
end
%% consolidate SaveData (�Z�[�u�f�[�^(CEMG,CAI,CTTL,CRAW,CLFP)���܂Ƃ߂�(CTTL�����́A���ƈႤ���@�ŕۑ�����))\
%���Ȃ�璷�ȃR�[�h�A�֐��ɂ܂Ƃ߂�ׂ�

%CAI�Ɋւ���
for kk = 1:CAI_file_num
        %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CAI_' sprintf('%03d',kk) ' = All_CAI(kk,:);'])
        eval(['CAI_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
        eval(['CAI_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
        eval(['CAI_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
        eval(['CAI_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
end
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
 for kk = 1:CLFP_file_num
        %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CLFP_' sprintf('%03d',kk) ' = All_CLFP{kk,1};'])
        eval(['CLFP_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
        eval(['CLFP_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
        eval(['CLFP_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
        eval(['CLFP_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
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
%CTTL�M���Ɋւ���
for kk = 2:CTTL_file_num
    eval(['CTTL_' sprintf('%03d',kk) '_Up = sel_CTTL_' sprintf('%03d',kk) '_Up;'])
    eval(['CTTL_' sprintf('%03d',kk) '_Down = sel_CTTL_' sprintf('%03d',kk) '_Down;'])
    eval(['CTTL_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);']) %TimeEnd�̓��X�g�t�@�C����TimeEnd�����A���łɑ���ς݂Ȃ̂ŁA�����Œ�`���Ȃ��Ă���
    eval(['CTTL_' sprintf('%03d',kk) '_KHz = (downHz/1000);'])
    eval(['CTTL_' sprintf('%03d',kk) '_KHz_Orig = (downHz/1000);'])
end

%% save data
if exist_EMG == 1
    if CTTL_file_num == 2
        save(['AllData_' monkey_name num2str(exp_day) '.mat'],'CAI*','CEMG*','CLFP*','CRAW*','Channel_ID_Name_Map','Ports_ID_Name_Map','TimeRange','CTTL_002*')
    elseif CTTL_file_num == 3
        save(['AllData_' monkey_name num2str(exp_day) '.mat'],'CAI*','CEMG*','CLFP*','CRAW*','Channel_ID_Name_Map','Ports_ID_Name_Map','TimeRange','CTTL_002*','CTTL_003*')
    end
else
    if CTTL_file_num == 2
        save(['AllData_' monkey_name num2str(exp_day) '.mat'],'CAI*','CLFP*','CRAW*','Channel_ID_Name_Map','Ports_ID_Name_Map','TimeRange','CTTL_002*')
    elseif CTTL_file_num == 3
        save(['AllData_' monkey_name num2str(exp_day) '.mat'],'CAI*','CLFP*','CRAW*','Channel_ID_Name_Map','Ports_ID_Name_Map','TimeRange','CTTL_002*','CTTL_003*')
    end
end
cd ../
end




