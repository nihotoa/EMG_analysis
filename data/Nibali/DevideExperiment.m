%{
Coded by: Naohito Ohta
Last modification : 2022/09/16
how to use�F
1.setting current directry as Nibali

�yWhat you will get�z
�EList of experimental days when the number of trials was above (or below)the threshold()
 (this data is necessary when you confirm�@Credibility of data)
�p�����[�^�̕����ŁA���낢��ȏ�����t������,���̏����𖞂��������������܂Ƃ߂ăf�[�^�Ƃ��ĕۑ�����֐�.
�����b�g�Ƃ��ẮA�p�����[�^�ŏ����ݒ肷���,���������蓮�ŏ����𖞂����Ă�������ǂ̓����T���Ȃ��ėǂ��Ȃ� &
�ۑ��������t�f�[�^�����[�v�̗v�f�Ƃ��Ďg����

�yNotes�z
�Eit is possible to validate multiple parameters
�Ethe data which is created by using this code is saved in 'devide_info' fold
�Eplease make current directry 'Nibali' when you use this code
�Eplease conduct 'untitled.m' before conducting this func (to get 'success_timing.mat')

�yprocedure�z
pre:untitled.mat (necessary)
post: you can use this func data in various function 
��but now, this data is only used in 'EMG_correlation.m' 


�y�ڕW�z
�E�^�X�N�񐔂����łȂ��A���낢��ȏ����𕡍��I�ɖ������悤�ȓ��t���}�[�W���ĕۑ��ł���悤�ȋ@�\����������(���t�����łȂ�,untitled�Ő������ꂽ�f�[�^�ւ̑�����L�q����K�v������)
(ex)100��ȏ�^�X�N����������̃f�[�^��1~50��ڂ���EMG��́A100��ȏォ�^�C�~���O1~2,2~3,3~4�ɂ����鎞�Ԃ�臒l�ȓ���EMG�𒊏o���ĉ�́��̃I�v�V������������Ƃ����炱������Ȃ��C������
�E�upre�̒��Łva�ȏ�b�ȉ�,�upost�̒��Łva�ȏ�b�ȉ��̃f�[�^�𒊏o�ł���悤�ɂ���(����́u�S�̂̒��Łv�����I�v�V�������Ȃ�)
%}
clear;
%% set param
surgery_day = 20220530;
exp_dir = dir('2022*'); %���t�t�H���_��S�ēǂݍ���
term_type = 'post'; %'all' or 'pre' or 'post'
%all_day_trial param (to save number of trial per day)
all_day_trial = 1; %if you save number of trial per day, you have to fill 1 in this param
%restrict_param
restrict_trial = 1; %if you restrict trial_num, you have to fill 1 in this param 
max_trial = 1000; %upper limit of trial
minimum_trial =0; %lower limit of trial
%% code section
for ii = 1:length(exp_dir)
    exp_dir(ii).name = str2double(exp_dir(ii).name);
end

if strcmp(term_type,'all')
    target_day = exp_dir;
else
    [target_day] = defTarget(exp_dir,term_type,surgery_day); %(remove pre/post day to reference surgery_day (if you set term_type as pre or post))
end

for ii = 1:length(target_day)
    exp_days(ii) = target_day(ii).name;
end

count=1;
for exp_day = exp_days
    timing_pass = [num2str(exp_day) '/EMG_Data/Data']; %path to the directory which contains success_timing.mat
    try
        load([timing_pass '/success_timing.mat'])
        trial_num{count,1}(1) = exp_day;
        trial_num{count,1}(2) = length(success_timing);
        count = count + 1;
    catch
        continue; %success_timing�����݂��Ȃ��ꍇ�͎��̃��[�v�֍s��
    end
end
trial_data = cell2mat(trial_num);

if all_day_trial
    %sort trial_data
    [A,I] = sort(trial_data(:,2));
    trial_data = trial_data(I,:);
    if not(exist('devide_info'))
        mkdir('devide_info')
    end
    trial_day = sort(trial_data(:,1));
    save(['devide_info/' term_type '_day_trial.mat'],'trial_data','trial_day');
end

if restrict_trial
    I = trial_data(:,2) >= minimum_trial & trial_data(:,2) <= max_trial; %extract row which achieve term
    trial_data = trial_data(I,:);
    if all_day_trial
        trial_day = sort(trial_data(:,1)); 
    end
    save(['devide_info/' term_type '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat'],'trial_data','trial_day');
end

%% define function
 %function1
 function [target_day] = defTarget(exp_dir,term_type,surgery_day)
    count = 1;
    for ii = 1:length(exp_dir)
        if strcmp(term_type,'pre')
            if exp_dir(ii).name < surgery_day
                target_day(count) = exp_dir(ii);
                count = count + 1;
            end
        elseif strcmp(term_type,'post')
            if exp_dir(ii).name > surgery_day
                target_day(count) = exp_dir(ii);
                count = count + 1;
            end
        end
            
    end
 end

