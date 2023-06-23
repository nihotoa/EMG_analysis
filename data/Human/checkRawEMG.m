%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota
Last modification: 2023.04.05
�yfunction�z
check function to confirm whether RAW_EMG is correct or not

pre: you need to finish all procedure up to filterEMG.m and
SuccessTiming_func.m
post nothing

�y�ۑ�_�z
�������򂪏璷������(�R�[�h�̏�������)
fix_lim��filtered�̕����ƑΉ����Ă��Ȃ�
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
include_task = 1; %�����̃^�X�N���܂߂邩
% task_length = 20; %(task_timing���Ȃ��ăg���~���O�ł��Ȃ���)���b���v���b�g���邩(0�̏ꍇ�́C�S�ăv���b�g����)
merge_EMG_figure = 0; %�摜���܂Ƃ߂ĂP���Ƃ��č�邩�C�X�̋ؓd�ʂɍ�邩
plot_RAW = 1; %raw�f�[�^���v���b�g���邩�ǂ���
plot_filtered = 0; %filter�f�[�^��plot���邩�ǂ���
fix_lim = 1; %Amplitude��scale���Œ肷�邩�ǂ���
line_width = 1.7;
unique_string = '-hp50Hz-rect-lp5Hz-ds100Hz'; %unique�ȕ�����

%�������csv�t�@�C�����Q�Ƃ���EMGs����邱��(���Ԃ��厖)�C
%pre1�̎�
% EMGs=cell(14,1) ;
% EMGs{1,1}= 'IOD-1';
% EMGs{2,1}= 'APB';
% EMGs{3,1}= 'APQ';
% EMGs{4,1}= 'EDC';
% EMGs{5,1}= '2L';
% EMGs{6,1}= 'ECR';
% EMGs{7,1}= 'BRD';
% EMGs{8,1}= 'FCU';
% EMGs{9,1}= '3L';
% EMGs{10,1}= 'FCR';
% EMGs{11,1}= 'FDS';
% EMGs{12,1}= 'Biceps';
% EMGs{13,1}= '4L';
% EMGs{14,1}= 'Triceps';

%post1, post2�̎�
EMGs=cell(16,1) ;
EMGs{1,1}= 'IOD-1';
EMGs{2,1}= '2L';
EMGs{3,1}= '3L';
EMGs{4,1}= '4L';
EMGs{5,1}= 'APB';
EMGs{6,1}= 'ADQ';
EMGs{7,1}= 'EDC';
EMGs{8,1}= 'ECR';
EMGs{9,1}= 'BRD';
EMGs{10,1}= 'FCU';
EMGs{11,1}= 'FCR';
EMGs{12,1}= 'FDS';
EMGs{13,1}= 'Biceps';
EMGs{14,1}= 'Triceps';
EMGs{15,1}= 'DLA';
EMGs{16,1}= 'DLM';

%% code section
use_electrode_num = [1:length(EMGs)];
disp('�yplease select Task~.mat file(patient -> day ->)�z')
[RawEMG_fileNames,RawEMG_pathName] = selectGUI(patient_name, 'EMG');
for ii = 1:length(RawEMG_fileNames) %�^�X�N�̎��???��
    if ischar(RawEMG_fileNames)
        task_name = strrep(RawEMG_fileNames, '.mat', '');
        % load RAW EMG files
        temp = load([RawEMG_pathName RawEMG_fileNames], 'data');
    else
        task_name = strrep(RawEMG_fileNames{ii}, '.mat', '');
        % load RAW EMG files
        temp = load([RawEMG_pathName RawEMG_fileNames{ii}], 'data');
    end
    EMG_data = temp.data';
    %EMG�f�[�^��offset����
    EMG_data = offset(EMG_data, 'mean');
    if fix_lim
%         raw_max = abs_roundup(max(reshape(EMG_data,1,[])));
%         raw_min = abs_roundup(min(reshape(EMG_data,1,[])));
%         cri_value = min(raw_max,abs(raw_clmin));
        if length(EMGs) == 14 %post1�̎�
            load([pwd '/' patient_name '/' 'yMax_Data.mat'], 'yMax_list', 'electrode_matrix')
            yMax_list = yMax_list(electrode_matrix);
        else
            load([pwd '/' patient_name '/' 'yMax_Data.mat'], 'yMax_list')
        end
        flag_name = '_aligned_Amp'; %�t�@�C�����Ɋ܂߂� 
    else
        flag_name = '';
    end
    select_dir = [RawEMG_pathName task_name];
    if ii == 1
        disp('�yPlease select filtered_EMG files�z')
        [filtered_EMG_fileNames, filtered_EMG_pathName] = uigetfile([ '*' unique_string '.mat'],'Select a file',select_dir,'MultiSelect','on');
        change_place = task_name;
        changed_path = filtered_EMG_pathName; 
    else
        filtered_EMG_pathName = strrep(changed_path, change_place, task_name); %�^�X�N���̂ݕύX
    end

    if merge_EMG_figure
        figure('position', [100, 100, 1280, 720]);
    end
    for jj = 1:length(filtered_EMG_fileNames) %��???���[�v???�̋ؓ���??�[�^���C��??�[�^�̂ǂ̓d�ɂɑ΂���??
        load([filtered_EMG_pathName filtered_EMG_fileNames{jj}], 'Data','Name');
        all_filtered_data{jj,1} = Data;
        filtered_data = Data;
        Name = strrep(Name, unique_string, ''); 
        all_filtered_name{jj,1} = Name;
        % 
        selected_electrode = use_electrode_num(find(strcmp(EMGs, Name))); %filtered�f�[�^�ɑΉ�����C���f�[�^�̓d�ɔԍ���Ԃ�
        raw_data = EMG_data(selected_electrode, :);
        try %timing�f�[�^�����鎞(trim�ł���)
            load([RawEMG_pathName task_name '_timing.mat'], 'all_timing_data', 'SamplingRate')
            raw_timing_data = all_timing_data * (1000/SamplingRate); %���̋ؓd�̃T���v�����O���[�g/SamplingRate           
            raw_data = raw_data(1, raw_timing_data(1,1):raw_timing_data(2,include_task)); %�g���~���O
            filtered_data = filtered_data(1, all_timing_data(1,1):all_timing_data(2,include_task)); %�g���~���O
        catch %timing�f�[�^���Ȃ��� 
            no_trim_flag = 1; %�ϐ��̒��g�͊֌W�Ȃ�.(���̕ϐ�����`���ꂽ���Ƃ��厖)
        end
        Name = strrep(Name,'_', '-');
        if jj == 1
            x = linspace(0,1,length(raw_data));
            y = linspace(0,1,length(filtered_data));
        end
        if merge_EMG_figure
            %subplot & decorate
            subplot(ceil(length(EMGs)/4),4,jj);
            hold on;
            if plot_RAW
                plot(x, raw_data, 'LineWidth',1.2);
            end
            if plot_filtered
                plot(y, filtered_data, 'LineWidth',line_width);
            end
            %decorate
            title(Name)
            xlabel('Time[%]')
            ylabel('Amplitude[V]')
        else
            figure('position', [100, 100, 600, 800]);
            %subplot & decorate
            hold on
            if plot_RAW
                plot(x, raw_data,'LineWidth',line_width);
            end

            if plot_filtered
                plot(y, filtered_data,'LineWidth', line_width);
            end
            %decorate
            if fix_lim
                if plot_RAW
                    ylim([-1*yMax_list(selected_electrode) yMax_list(selected_electrode)])
                else
                    %�܂��ł��Ă��Ȃ�
                end
            end
            ax = gca;
            ax.XAxis.FontSize = 15;
            ax.YAxis.FontSize = 15;
            title(Name, 'FontSize', 20)
            xlabel('Time[%]','FontSize', 20)
            ylabel('Amplitude[V]','FontSize', 20)
            hold off
            %save
            save_dir = [select_dir '/' 'EachEMG'];
            if not(exist(save_dir))
                mkdir(save_dir)
            end
            
            if exist('no_trim_flag')
                saveas(gcf, [save_dir '/' Name '_all_EMG' flag_name '.png'])
                saveas(gcf, [save_dir '/' Name '_all_EMG' flag_name '.fig'])
            elseif and(plot_filtered, plot_RAW)
                saveas(gcf, [save_dir '/' Name '_EMG(' num2str(include_task) 'task_span)' flag_name '.png'])
                saveas(gcf, [save_dir '/' Name '_EMG(' num2str(include_task) 'task_span)' flag_name '.fig'])
            elseif plot_RAW
                saveas(gcf, [save_dir '/' Name 'raw_EMG(' num2str(include_task) 'task_span)' flag_name '.png'])
                saveas(gcf, [save_dir '/' Name 'raw_EMG(' num2str(include_task) 'task_span)' flag_name '.fig'])
            elseif plot_filtered
                saveas(gcf, [save_dir '/' Name 'filterd_EMG(' num2str(include_task) 'task_span)' flag_name '.png'])
                saveas(gcf, [save_dir '/' Name 'filtered_EMG(' num2str(include_task) 'task_span)' flag_name '.fig'])
            end
            close all;
        end
    end
    % save
    if merge_EMG_figure
        if exist('no_trim_flag')
            saveas(gcf, [select_dir '/' Name '_all_EMG' flag_name '.png'])
            saveas(gcf, [select_dir '/' Name '_all_EMG' flag_name '.fig'])
        elseif and(plot_filtered, plot_RAW)
            saveas(gcf, [select_dir '/' task_name '_EMG(' num2str(include_task) 'task_span)' flag_name '.png'])
            saveas(gcf, [select_dir '/' task_name '_EMG(' num2str(include_task)  'task_span)' flag_name '.fig'])
        elseif plot_RAW
            saveas(gcf, [select_dir '/' task_name 'raw_EMG(' num2str(include_task) 'task_span)' flag_name '.png'])
            saveas(gcf, [select_dir '/' task_name 'raw_EMG(' num2str(include_task)  'task_span)' flag_name '.fig'])
        elseif plot_filtered
            saveas(gcf, [select_dir '/' 'EachEMG' '/' 'filtered_EMG(' num2str(include_task) 'task_span)' flag_name '.png'])
            saveas(gcf, [select_dir '/' 'EachEMG' '/' 'filtered_EMG(' num2str(include_task) 'task_span)' flag_name '.fig'])
        end
        close all;
    end
    if ischar(RawEMG_fileNames) %�ЂƂ���task��I�����ĂȂ���,�^�X�N�̐��ł͂Ȃ������񒷂��Ń��[�v���邽��,break���ďI��
        break;
    end
end

%% set function
function return_value = abs_roundup(input_num)
% ���͂������l�̐�Βl���C���߂ďo�Ă������̉��̌��ŌJ��オ�肷�邽�߂̊֐�
if input_num < 0
    input_num = abs(input_num);
    flag = 1; %�}�C�i�X�l���ǂ����̔��f
end
decimal_places = 0; % ���߂ďo�Ă������������_�ȉ�������
while true
     if input_num >= 1
         break
     else
         input_num = input_num * 10;
         decimal_places = decimal_places + 1;
     end
end
if exist('flag') == 1
    return_value = -1*(ceil(input_num) * 10^-(decimal_places));
else
    return_value = ceil(input_num) * 10^-(decimal_places);
end
end