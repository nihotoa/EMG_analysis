%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�m�C�Y�����o�����邽�߂̃v���O����
%���܂ꂽ�̂ŏ�����
%Nibari���J�����g�f�B���N�g���ɂ��Ďg�p����
%���P�_:
%xlim��ylim��݂���
%�ۑ����@
%�n�C�p�X������I�v�V����
%�ւ���ɃT���v���摜��������OK���炦������A���P�_�͉��P����Ă��Ȃ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
exp_day = 20220414;
monkey_name = 'Ni';
pre = 2000; %1�^�X�N�ڂ̑O�A���T���v�����O�܂Ńg���~���O���邩
post = 2000; %3�^�X�N�ڂ̌�A���T���v�����O�܂Ńg���~���O���邩
high_pass = 1; %����̓��h���Ȃ������߂Ƀn�C�p�X�������邩�ǂ���
SR = 1375; %�ؓd�f�[�^�̃T���v�����O���[�g
filt_h = 50;%�J�b�g�I�t���g���̒l

selEMGs= 1:16;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
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
%% code section
cd(num2str(exp_day))
load(['AllData_' monkey_name num2str(exp_day) '.mat'])
cd('EMG_Data/Data')
load('success_timing.mat')
%%define high-pass flter
if high_pass == 1
    for ii = 1 : EMG_num
        [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
        temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]);
        temp_EMG = filtfilt(B,A,temp_EMG);
        eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
    end
else
    
end

%% 3�^�X�N�����g���~���O
h = figure();
h.WindowState = 'maximized';
for ii = 1:EMG_num
    subplot(4,4,ii)
    for jj = 1 %�d�ˍ��킹�̉�
        %task_trim = CEMG_001(1,success_timing(3*jj-2,1)+1 : success_timing(3*jj,4));
        eval(['task_trim = CEMG_' sprintf('%03d',ii) '(1,(success_timing(3*jj-2,1)+1) - pre : success_timing(4,3*jj)+post);'])
        task_criterion = success_timing(1,1) - pre;
        task_tim{1,1} = [pre,success_timing(2,1)-task_criterion,success_timing(3,1)-task_criterion,success_timing(4,1)-task_criterion];
        task_tim{2,1} = [success_timing(1,2)-task_criterion,success_timing(2,2)-task_criterion,success_timing(3,2)-task_criterion,success_timing(4,2)-task_criterion];
        task_tim{3,1} = [success_timing(1,3)-task_criterion,success_timing(2,3)-task_criterion,success_timing(3,3)-task_criterion,success_timing(4,3)-task_criterion];
        plot(task_trim);
        hold on;
        xlim([0 length(task_trim)])
        %ylim([]) ���ƂŒǉ�����
        for kk = 1:3%�\������^�X�N��
            for ll = 1:4 %�^�X�N�^�C�~���O
                if ll == 1
                    xline(task_tim{kk,1}(1,ll),'red','Color',[255 0 0]/255,'LineWidth',1);
                elseif ll == 2
                    xline(task_tim{kk,1}(1,ll),'red','Color',[186 85 211]/255,'LineWidth',1);
                elseif ll == 3
                    xline(task_tim{kk,1}(1,ll),'red','Color',[0 255 0]/255,'LineWidth',1);
                elseif ll == 4
                    xline(task_tim{kk,1}(1,ll),'red','Color',[0 0 255]/255,'LineWidth',1);
                end
            end
        end
    end
    title([EMGs{ii,1} '(uV)'])
end
cd ../
cd picture

if high_pass == 1
    saveas(gcf,['CheckNoize_HighPass(' num2str(filt_h) 'Hz)_pre-' num2str(pre) '_post' num2str(post) '.png'])
else 
    saveas(gcf,['CheckNoize_RAW_pre-' num2str(pre) '_post' num2str(post) '.png'])
end
close all
cd ../../../;
