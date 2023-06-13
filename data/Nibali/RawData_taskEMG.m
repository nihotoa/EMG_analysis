%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�y���ݎg�p���Ă��Ȃ��֐��z
% coded by:Naohito Ohta
% Last Modification:2022/2/16
% how to use:
% Nibali���J�����g�f�B���N�g���ɂ��Ďg���B���̓��̃^�X�N���̐��̋ؓd�f�[�^���擾���ăv���b�g����(�d�ˍ��킹�ƁA���ς�2���v���b�g)�{���̃f�[�^��Mat�t�@�C���ɂ��ĕۑ�����
% ����̓��h���Ȃ������߂ɁA�Ⴂ�J�b�g�I�t���g���̃n�C�p�X��������I�v�V����������
% �^�X�N���̋ؓd�f�[�^���K�v�Ȃ̂ŁASYNERGYPLOT���񂵂����ʓ�����success_timing.mat���K�v(EMG_Data��Data�̒��ɂ���.mat�t�@�C��)
% AllData_EMG�́Auntitled.m���Œ�`���ꂽ�ϐ��B�����Ă���f�[�^�͐��f�[�^.�]�u���ꂽ��Ԃŕۑ�����Ă��邽�߁A��͂����X�߂�ǂ�����
% ���O�̃p�����[�^�̐ݒ��Y�ꂸ�ɍs��(monkey_name,exp_day�Ȃ�)
% �ۑ��ꏊ�͓��t��EMG_Data�̒�
% ���P�_�F
% ds100Hz�ɑΉ����Ă��Ȃ�(SYNERGYPLOT���ŁAds100Hz��success_timing��MAT�t�@�C��������āA�����ǂݍ��݁A���f�[�^��1375Hz����100Hz�Ƀ_�E���T���v�����O���Ĕ�r����)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% �ϐ��̒�`
clear;
monkey_name = 'Ni';
xpdate = 20220301;
data_fold = 'Data';
picture_fold = 'picture';
%�����f�[�^�ɑ΂���U����񂩁A�^�X�N�f�[�^�ɑ΂���U����񂩂�I������
plot_task = 1;
high_pass = 1; %�n�C�p�X�������邩�ǂ���
%���n�C�p�X��������ꍇ
filt_h = 20; %(�n�C�p�X��������ꍇ��)�J�b�g�I�t���g��[HZ]
SR = 1375;%(�f�[�^�̃T���v�����O���[�g)
define_timing = 1; %0:CAI001�݂̂ł̏��� 1:define_task=1�̎��̃^�C�~���O�f�[�^���g�p���� 2:define_task=2�̎��̃^�C�~���O�f�[�^���g�p����


selEMGs= 1:16 ;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
EMGs=cell(16,1) ;
EMGs{1,1}= 'EDC-A';
EMGs{2,1}= 'EDC-B';
EMGs{3,1}= 'ED23';
EMGs{4,1}= 'ED45';
EMGs{5,1}= 'ECR';
EMGs{6,1}= 'ECU';
EMGs{7,1}= 'BRD';
EMGs{8,1}= 'EPL-B';
EMGs{9,1}= 'FDS-A';
EMGs{10,1}= 'FDS-B';
EMGs{11,1}= 'FDP';
EMGs{12,1}= 'FCR';
EMGs{13,1}= 'FCU';
EMGs{14,1}= 'FPL';
EMGs{15,1}= 'Biceps';
EMGs{16,1}= 'Triceps';
EMG_num = 16;
%% �ؓd�f�[�^�̎擾
cd([num2str(xpdate) '/EMG_Data/Data']);

load('AllData_EMG.mat');
%�g�p����^�C�~���O�f�[�^�̑I��
if define_timing == 0
    load('success_timing.mat')
elseif define_timing == 1
    load('define1_success_timing.mat')
    load('define1_tim_hist.mat')
elseif define_timing == 2
    load('define2_success_timing.mat')
    load('define2_tim_hist.mat')
end


if high_pass == 1
    AllData_EMG = transpose(AllData_EMG);
    for ii = 1 : EMG_num
        [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
        AllData_EMG(ii,:) = filtfilt(B,A,AllData_EMG(ii,:));
    end
else
    AllData_EMG = transpose(AllData_EMG);
end

figure('Position',[0,0,1700,1700]);
for ii=1:EMG_num
    RAW_task_EMG_sel = {};
    for jj = 1:length(success_timing)
        raw_task_trim = AllData_EMG(ii,success_timing(1,jj):success_timing(4,jj));
        %���Ԑ��K��
        raw_task_trim = resample(raw_task_trim,1000,length(raw_task_trim));
        RAW_task_EMG_sel{jj,1} = raw_task_trim;
    end
    RAW_task_EMG = cell2mat(RAW_task_EMG_sel);
    RAW_ave_task_EMG = mean(RAW_task_EMG);
    subplot(4,4,ii)
    count = 1;
    for kk = 1:length(RAW_task_EMG_sel)
        for ll = 1:length(RAW_task_EMG)
            if ll == 1
                abs_maxEMG = abs(RAW_task_EMG(kk,ll));
            elseif abs(RAW_task_EMG(kk,ll)) > abs_maxEMG
                abs_maxEMG = abs(RAW_task_EMG(kk,ll));
            end
        end
        if abs_maxEMG < 1000
            plot(RAW_task_EMG(kk,:));
            hold on;
            eval(['number' num2str(ii) '_RAW_task_EMG_sel{' num2str(count) ',1} = RAW_task_EMG(' num2str(kk) ',:);'])
            count = count+1; 
        else
            
        end
    end
    RAW_task_EMG = eval(['number' num2str(ii) '_RAW_task_EMG_sel']);
    RAW_task_EMG = cell2mat(RAW_task_EMG);
    title([EMGs{ii} '(uV)'])
    yyaxis right;
    ylim([0 40])
    histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
    histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
    tim2_median = median(tim_hist(1,:));
    tim3_median = median(tim_hist(2,:));
    xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
    xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
    hold off
    All_RAW_task_EMG{ii,1} = RAW_task_EMG;
    All_RAW_ave_task_EMG{ii,1} = RAW_ave_task_EMG;
end
cd ../../
cd EMG_Data/picture
if define_timing == 0
    if high_pass == 1
        saveas(gcf,['RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'RAW_taskEMG.png');
    end
elseif define_timing == 1
    if high_pass == 1
        saveas(gcf,['define1_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'define1_RAW_taskEMG.png');
    end
elseif define_timing == 2
    if high_pass == 1
        saveas(gcf,['define2_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'define2_RAW_taskEMG.png');
    end
end
close all;
All_RAW_ave_task_EMG = cell2mat(All_RAW_ave_task_EMG);


% �^�X�N����EMG�̕��ς��v���b�g
figure('Position',[0,0,1700,1700]);

for ll = 1:EMG_num
    subplot(4,4,ll)
    plot(All_RAW_ave_task_EMG(ll,:))
    hold on
    title([EMGs{ll} '(uV)'])
    yyaxis right;
    ylim([0 40])
    histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
    histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
    tim2_median = median(tim_hist(1,:));
    tim3_median = median(tim_hist(2,:));
    xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
    xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
    hold off
end

if define_timing == 0
    if high_pass == 1
        saveas(gcf,['ave_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'ave_RAW_taskEMG.png');
    end
elseif define_timing == 1 
    if high_pass == 1
        saveas(gcf,['define1_ave_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'define1_ave_RAW_taskEMG.png');
    end
elseif define_timing == 2
    if high_pass == 1
        saveas(gcf,['define2_ave_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'define2_ave_RAW_taskEMG.png');
    end
end
close all;

%�f�[�^�̕ۑ�
cd ../
cd Data
if define_timing == 0
    if high_pass == 1
        save(['RAW_task_EMG_Data(highpass_' num2str(filt_h) 'Hz).mat'],'All_RAW_task_EMG','All_RAW_ave_task_EMG');
    else
        save('RAW_task_EMG_Data.mat','All_RAW_task_EMG','All_RAW_ave_task_EMG');
    end
elseif define_timing == 1
    if high_pass == 1
        save(['define1_RAW_task_EMG_Data(highpass_' num2str(filt_h) 'Hz).mat'],'All_RAW_task_EMG','All_RAW_ave_task_EMG');
    else
        save('define1_RAW_task_EMG_Data.mat','All_RAW_task_EMG','All_RAW_ave_task_EMG');
    end
elseif define_timing == 2
    if high_pass == 1
        save(['define2_RAW_task_EMG_Data(highpass_' num2str(filt_h) 'Hz).mat'],'All_RAW_task_EMG','All_RAW_ave_task_EMG');
    else
        save('define2_RAW_task_EMG_Data.mat','All_RAW_task_EMG','All_RAW_ave_task_EMG');
    end
end
cd ../../../