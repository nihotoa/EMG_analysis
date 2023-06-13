%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
LastModification: 2023.03.30
�V�����^�X�N�ɂ�����CNMF�Ɏg�p����ؓd??�[�^����???���ĕۑ����邽��???�R�[??
pre:CombineMatfile2.m
post:makeEMGNMF -> temp_NMFdisp
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
exp_day = '20230330';
trim_pattern = 'individual'; %'none'/ 'individual', 'complex' 
task_devide_threshold = 1000; %V��H���̃^�X�N���ʂɎg�p����臒l
monkey_name = 'Ni';
filter_info.filt_h = 50;
filter_info.filt_l = 5;
filter_info.SR = 1375;

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
disp('【please select AllData~.mat (which isused to analyze)�?')
[fileName,pathName] = selectGUI(exp_day, 'none');
load([pathName fileName])

%nmf_fold�����
nmf_fold = [pathName 'nmf_result' '/' monkey_name num2str(exp_day) '_standard'];
if not(exist(nmf_fold))
    mkdir(nmf_fold);
end

if strcmp(trim_pattern, 'individual') || strcmp(trim_pattern, 'complex')
    judge_matrix = [CTTL_003_Up; CTTL_003_Down];
    [V_trim_timing, H_trim_timing] = Devide_task(judge_matrix, task_devide_threshold);
    switch trim_pattern
        case 'individual'           
            trim_timing = {V_trim_timing, H_trim_timing};
            task_name = {'V', 'H'};
            for ii = 1:2 %VorH
                %�^�X�N�ʂ̏���
                for jj = 1:length(trim_timing{ii}) %�O���[�v��
                    %�e�O���[�v�̏���
                    trim_info = trim_timing{ii}(:,jj);
                    for kk = 1:length(EMGs) %�ؓ���
%                         EMG_data = eval(['CEMG_' sprintf('%03d', kk)]);
                        EMG_package( eval(['CEMG_' sprintf('%03d', kk)]), trim_info, EMGs{kk},task_name{ii}, jj, nmf_fold, filter_info)
                    end
                end
            end
            
        case 'complex'
    end
elseif strcmp(trim_pattern, 'none')
end



%% define local function
function [V_trim_timing, H_trim_timing] = Devide_task(judge_matrix, task_devide_threshold) 
count = 1;
temp = judge_matrix(2, :);
V_start = [];
V_end = [];
H_start = [];
H_end = [];
while true
    interval = temp(count+1) - temp(count); %�X�C�b�`on�Ԃ̎��ԃT���v��
    if interval > task_devide_threshold %V�̏ꍇ
        V_start(end+1) = temp(count);
        V_end(end+1) = temp(count+1);
        count = count + 2;
    elseif interval < task_devide_threshold %H�̏ꍇ
        H_start(end+1) = temp(count);
        H_end(end+1) = temp(count+3);
        count = count + 4;
    end
    if count >= length(temp)
        break;
    end
end
V_trim_timing = [V_start; V_end];
H_trim_timing = [H_start; H_end];
end


function [] = EMG_package(EMG_data ,trim_info, EMG_name, task_name ,jj, nmf_fold, filter_info)
EMG_Data = EMG_data(trim_info(1):trim_info(2));
%�t�B���^�����O
%high_pass
[B,A] = butter(6, (filter_info.filt_h .* 2) ./ filter_info.SR, 'high');
temp_EMG = EMG_Data;
% figure('position', [100, 100, 1280, 720]);
temp_EMG = filtfilt(B,A,temp_EMG);
%rect
temp_EMG = abs(temp_EMG);
% plot(temp_EMG);
% hold on;
%smoothing
[B,A] = butter(6, (filter_info.filt_l .* 2) ./ filter_info.SR, 'low');
EMG_Data = filtfilt(B,A,temp_EMG);
EMG_Data = resample(EMG_Data,100, filter_info.SR);
% plot(EMG_Data)
% hold off
%�t�H���_�̍쐬
save_fold = [nmf_fold '/' task_name '/' 'group' num2str(jj) '/'];
if not(exist(save_fold))
    mkdir(save_fold)
end
%�ۑ����邽�߂ɕK�v�ȃt�@�C���𑵂���
Class = 'continuous channel';
Data = EMG_Data;
Name = EMG_name;
SampleRate = 100;
Unit = 'uV';
%�f�[�^�̕ۑ�
save([save_fold EMG_name '_filtered.mat'], 'Class', 'Data', 'Name', 'SampleRate', 'Unit')
% saveas(gcf, [save_fold EMG_name '.png'])
% close all;
end

