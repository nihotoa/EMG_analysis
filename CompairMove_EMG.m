%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Coded by: Naohito Ohta
%Last Modification:2022/06/02
%EMG�Ɠ����͂̌��ʂ��r���邽�߂̃R�[�h
%���֐����߂ɁA�J�����g�f�B���N�g����MATLAB�ɂ��Ď��s����
%���O����:

%���P�_(���ӓ_)
%EMG�f�[�^��ǂݍ���œ��邪,����g�p���Ă��Ȃ�(3�������W�̋O�Ղ�EMG�̋ۊ����̕ϑJ����̐}�ŕ\���������ɂ͎g���邪,�������ĂȂ�)
%�����̃f�[�^�̕��ςɎg����������Ȃ��̂�,stack�����łȂ�,���ς̕W���΍��̐}���(���ς̃f�[�^��mat�t�@�C���Ƃ��ďo�͂��遨�S�̃f�[�^��.mat�ŏo�͂���΂���)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
conducted_path = pwd; %�J�����g�f�B���N�g���̐�΃p�X����
experiment_date1 = 20220520;
experiment_date2 = 220520;
monkey_name = 'Nibali';
timing_type = 'tim3'; %�ǂ̃^�C�~���O����ɂ��邩?(����tim3�ɂ����Ή����Ă��Ȃ�)
extra_information = 1; %1�ɂȂ��Ă���ꍇ��,pre_frame�O,post_frame�O���l������(pre_trimmed,post_trimmed��p����)�v���b�g���s��
pre_frame = 300; %��L��timing_type�̎��ɁA���̃^�C�~���O����pre,post���T���v�������g���~���O���邩
post_frame = 100;
pre_trimmed= 600;%�^�X�N�Ƃ͕ʂ�,pre���T���v�����܂Ńv���b�g���邩?
post_trimmed = 200;
orig_frame_rate = 180;%�����͂Ɏg�p��������̃t���[�����[�g
EMG_SR = 1375;
judge = 1; %MonkeyExp_DLT��DLT_result��judgeON��judgeOFF�̂ǂ�����g����(judge = 1 �� judgeON)
use_point = [1 4]; %�g�p����}�[�J�[�|�C���g(�����I���\) 1:�e�w�̒� 2:�l�����w�̒� 3:�l�����w��DIP 4:�l�����w��PIP 
graph_header = {'thumb1 X' 'thumb1 Y' 'thumb1 Z'...
                'index3 X','index3 Y','index3 Z'};

%% code section

%�K�v�ȃf�[�^��ǂݍ���
load(['3D-pose-estimation/MonkeyExp_DLT/DLT_result/judgeON/' num2str(experiment_date2) '/task_3D_coodinate.mat']) %�����͂�3�������W�f�[�^
load(['3D-pose-estimation/compileTrimingMovie/referenceMovie/' num2str(experiment_date1) '/red_LED_timing.mat']) %red_LED�̃^�C�~���O�f�[�^
load(['data/' monkey_name '/' num2str(experiment_date1) '/EMG_Data/Data/task_' timing_type '_pre-' num2str(pre_frame) '_post-' num2str(post_frame) 'RAW_EMG.mat']) %�w�肵���^�C�~���O����Ő؂�o���ꂽEMG�f�[�^

%% �����̓f�[�^���������Ă���
if strcmp(timing_type,'tim3')
    max_frame = max(red_LED_timing(:,2)); %�^�C�~���O1��3�ŁA�ł����Ԃ����������^�X�N�̃t���[�����𒊏o
end

align_frame = max_frame; %����for���ō��s��̃^�C�~���O3�̈ʒu��,max_frame�Ɠ����Ȃ̂ŁA�ǐ��̌���̂��߁A���̒l��V�����ϐ��ɑ��

for ii = 1:length(All_output)
    for jj = use_point
        point_x = transpose(All_output{1,ii}(:,(3*jj)-2));  %(3*jj)-2�́A�|�C���gjj��x���W
        point_y = transpose(All_output{1,ii}(:,(3*jj)-1));
        point_z = transpose(All_output{1,ii}(:,(3*jj)));
        
        if strcmp(timing_type,'tim3')
            if jj == use_point(1,1) %1�^�X�N�ɂ��A���̑���͈��ŏ\��
                ex_frame = max_frame - red_LED_timing(ii,2);
            end
        end
        temp = [NaN(1,ex_frame) point_x];  
        eval([timing_type '_point' num2str(jj) '_x{ii,1} = evalin("base","temp");']);
        temp = [NaN(1,ex_frame) point_y];  
        eval([timing_type '_point' num2str(jj) '_y{ii,1} = evalin("base","temp");']);
        temp = [NaN(1,ex_frame) point_z];  
        eval([timing_type '_point' num2str(jj) '_z{ii,1} = evalin("base","temp");']);
    end
end

%���O��for���œ���ꂽ�f�[�^�����T���v�����O���Ă���
for ii = 1:length(All_output)
    for jj = use_point
        eval([timing_type '_point' num2str(jj) '_x{ii,1} = resample(' timing_type '_point' num2str(jj) '_x{ii,1},EMG_SR,orig_frame_rate);']);
        eval([timing_type '_point' num2str(jj) '_y{ii,1} = resample(' timing_type '_point' num2str(jj) '_y{ii,1},EMG_SR,orig_frame_rate);']);
        eval([timing_type '_point' num2str(jj) '_z{ii,1} = resample(' timing_type '_point' num2str(jj) '_z{ii,1},EMG_SR,orig_frame_rate);']);
    end
end
align_frame = round(align_frame * (EMG_SR/orig_frame_rate)); %align_frame���A���T���v�����O����

%�w�肳�ꂽ�͈͂Ńg���~���O���āA�s��ɂ܂Ƃ߂�
for ii = 1:length(All_output)
    for jj = use_point
        if extra_information == 1
            % trimed_tim3_point1_x(1,:) = tim3_point1_x{1,1}(align_frame - pre_frame+1 : align_frame + post_frame);
            eval(['trimed_' timing_type '_point' num2str(jj) '_x(ii,:) =' timing_type '_point' num2str(jj) '_x{ii,1}(align_frame - pre_trimmed+1 : align_frame + post_trimmed);' ])
            eval(['trimed_' timing_type '_point' num2str(jj) '_y(ii,:) =' timing_type '_point' num2str(jj) '_y{ii,1}(align_frame - pre_trimmed+1 : align_frame + post_trimmed);' ])
            eval(['trimed_' timing_type '_point' num2str(jj) '_z(ii,:) =' timing_type '_point' num2str(jj) '_z{ii,1}(align_frame - pre_trimmed+1 : align_frame + post_trimmed);' ])
        elseif extra_information == 0
            % trimed_tim3_point1_x(1,:) = tim3_point1_x{1,1}(align_frame - pre_frame+1 : align_frame + post_frame);
            eval(['trimed_' timing_type '_point' num2str(jj) '_x(ii,:) =' timing_type '_point' num2str(jj) '_x{ii,1}(align_frame - pre_frame+1 : align_frame + post_frame);' ])
            eval(['trimed_' timing_type '_point' num2str(jj) '_y(ii,:) =' timing_type '_point' num2str(jj) '_y{ii,1}(align_frame - pre_frame+1 : align_frame + post_frame);' ])
            eval(['trimed_' timing_type '_point' num2str(jj) '_z(ii,:) =' timing_type '_point' num2str(jj) '_z{ii,1}(align_frame - pre_frame+1 : align_frame + post_frame);' ])
        end
    end
end

%�v���b�g����
plot_axis = {'x','y','z'};
h = figure;
h.WindowState = 'maximized';
for ii = use_point
    for jj = 1:3 %x,y,z
        subplot(length(use_point),3,3*(find(use_point == ii)-1)+jj);
        for kk = 1:length(All_output)
            grid on;
            reference_data = eval(['trimed_' timing_type '_point' num2str(ii) '_' plot_axis{jj} '(kk,:);']);
            plot(reference_data)
            hold on
        end
        if extra_information == 1
            xline(pre_trimmed,'red','Color',[186 85 211]/255,'LineWidth',2.5);
            xline(pre_trimmed-pre_frame+1,'red','Color',[255 0 0]/255,'LineWidth',2.5);
            xline(pre_trimmed+post_frame,'red','Color',[0 255 0]/255,'LineWidth',2.5);
        else
            xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2.5);
        end
        title(graph_header{3*(find(use_point == ii)-1)+jj},'FontSize',20)
        hold off
    end
end
%�}��ۑ�����
mkdir(['resampled_3D_coodination/data/' num2str(experiment_date1)])
mkdir(['resampled_3D_coodination/image/' num2str(experiment_date1)])
if extra_information == 1
    saveas(gcf,['resampled_3D_coodination/image/' num2str(experiment_date1) '/extra_resampled_3D_coodinate(pre-' num2str(pre_trimmed)  '_post-' num2str(post_trimmed) ').png'])
    save(['resampled_3D_coodination/data/' num2str(experiment_date1) '/extra_resampled_3D_coodinate(pre-' num2str(pre_trimmed)  '_post-' num2str(post_trimmed) ').mat'],'trimed*','use_point')
else
    saveas(gcf,['resampled_3D_coodination/image/' num2str(experiment_date1) '/resampled_3D_coodinate(pre-' num2str(pre_frame)  '_post-' num2str(post_frame) ').png'])
    save(['resampled_3D_coodination/data/' num2str(experiment_date1) '/resampled_3D_coodinate(pre-' num2str(pre_frame)  '_post-' num2str(post_frame) ').mat'],'trimed*','use_point')
end
close all;

