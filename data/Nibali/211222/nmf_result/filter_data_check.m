%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code written by: Naohito Ohta
% Last modification:2021/12/23
% �t�B���^�����O��̊e�ؓd�f�[�^����̃O���t�Ƀv���b�g���A�ۑ����Ă����B
% �ۑ�����}�̖��O�A�g���q�͓K�X�ύX���邱�ƁB
% �J�����g�f�B���N�g����Nibali->nmf_result�ɂ��Ďg�p���邱��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% define variable
real_name='Nibali';
fold_name='nmf_result';
monkey_name='Ni';
exp_day='211222';
task_name='standard';
plot_filt = 1;
plot_raw = 1;
%% code part

%�ؓ��̒�`
switch real_name
     case 'SesekiR'
        selEMGs=[1:12];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,3) ;
        EMGs{1,1}= 'EDC';
        EMGs{2,1}= 'ED23';
        EMGs{3,1}= 'ED45';
        EMGs{4,1}= 'ECU';
        EMGs{5,1}= 'ECR';
        EMGs{6,1}= 'Deltoid';
        EMGs{7,1}= 'FDS';
        EMGs{8,1}= 'FDP';
        EMGs{9,1}= 'FCR';
        EMGs{10,1}= 'FCU';
        EMGs{11,1}= 'PL';
        EMGs{12,1}= 'BRD';
        EMG_num = 12;
        make_ECoG = 0;
    case 'Nibali'
        selEMGs=[1:16];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
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
end

%�v���b�g�͈͂̒�`
[Max,Min] = DefLim(EMGs,EMG_num,1);
[RawMax,RawMin] = RawDefLim(EMGs,EMG_num,1);

%�v���b�g�{�ۑ�
cd([ monkey_name exp_day '_' task_name]);
if plot_filt == 1
    figure('Position',[0,0,1000,1000]);
    for ii=1:EMG_num
        subplot(4,4,ii);
        %load([EMGs{ii,1} '-hp50Hz-rect-lp20Hz-ds100Hz.mat']);
        load([EMGs{ii,1} '-hp50Hz-rect-lp20Hz.mat']);
        plot(Data);
        ylim([Min Max])
        title(EMGs{ii,1})
    end

    saveas(gcf,'filtered-data-check.png')
    close all;
end

if plot_raw == 1
    figure('Position',[0,0,1000,1000]);
    for ii=1:EMG_num
        subplot(4,4,ii);
        load([EMGs{ii,1} '(uv).mat']);
        plot(Data);
        ylim([RawMin RawMax])
        title(EMGs{ii,1})
    end

    saveas(gcf,'raw-data-check.png')
    close all;
end
cd ../

%% define ylim(filtered)
function [Max,Min]=DefLim(EMGs,EMG_num,get_first)
    for ii=1:EMG_num
        if get_first == 1
            load([EMGs{1,1} '-hp50Hz-rect-lp20Hz-ds100Hz.mat']);
            Max = max(Data);
            Min = min(Data);
            get_first = 0;
        else
            load([EMGs{ii,1} '-hp50Hz-rect-lp20Hz-ds100Hz.mat']);
            if max(Data) > Max
                Max = max(Data);
            end

            if min(Data) < Min
                Min = min(Data);
            end
        end
    end
end

%% define ylim(raw)
function [RawMax,RawMin]=RawDefLim(EMGs,EMG_num,get_first)
    for ii=1:EMG_num
        if get_first == 1
            load([EMGs{1,1} '(uv).mat']);
            RawMax = max(Data);
            RawMin = min(Data);
            get_first = 0;
        else
            load([EMGs{ii,1} '(uv).mat']);
            if max(Data) > RawMax
                RawMax = max(Data);
            end

            if min(Data) < RawMin
                RawMin = min(Data);
            end
        end
    end
end