%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota
Last modification: 2023.04.05
【function】
check function to confirm whether RAW_EMG is correct or not

pre: you need to finish all procedure up to filterEMG.m and
SuccessTiming_func.m
post nothing

【課題点】
条件分岐が冗長すぎる(コードの書き直し)
fix_limがfilteredの方だと対応していない
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
include_task = 1; %何個分のタスクを含めるか
% task_length = 20; %(task_timingがなくてトリミングできない時)何秒分プロットするか(0の場合は，全てプロットする)
merge_EMG_figure = 0; %画像をまとめて１枚として作るか，個々の筋電別に作るか
plot_RAW = 1; %rawデータをプロットするかどうか
plot_filtered = 0; %filterデータをplotするかどうか
fix_lim = 1; %Amplitudeのscaleを固定するかどうか
line_width = 1.7;
unique_string = '-hp50Hz-rect-lp5Hz-ds100Hz'; %uniqueな文字列

%もらったcsvファイルを参照してEMGsを作ること(順番も大事)，
%pre1の時
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

%post1, post2の時
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
disp('【please select Task~.mat file(patient -> day ->)】')
[RawEMG_fileNames,RawEMG_pathName] = selectGUI(patient_name, 'EMG');
for ii = 1:length(RawEMG_fileNames) %タスクの種類???数
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
    %EMGデータをoffsetする
    EMG_data = offset(EMG_data, 'mean');
    if fix_lim
%         raw_max = abs_roundup(max(reshape(EMG_data,1,[])));
%         raw_min = abs_roundup(min(reshape(EMG_data,1,[])));
%         cri_value = min(raw_max,abs(raw_clmin));
        if length(EMGs) == 14 %post1の時
            load([pwd '/' patient_name '/' 'yMax_Data.mat'], 'yMax_list', 'electrode_matrix')
            yMax_list = yMax_list(electrode_matrix);
        else
            load([pwd '/' patient_name '/' 'yMax_Data.mat'], 'yMax_list')
        end
        flag_name = '_aligned_Amp'; %ファイル名に含める 
    else
        flag_name = '';
    end
    select_dir = [RawEMG_pathName task_name];
    if ii == 1
        disp('【Please select filtered_EMG files】')
        [filtered_EMG_fileNames, filtered_EMG_pathName] = uigetfile([ '*' unique_string '.mat'],'Select a file',select_dir,'MultiSelect','on');
        change_place = task_name;
        changed_path = filtered_EMG_pathName; 
    else
        filtered_EMG_pathName = strrep(changed_path, change_place, task_name); %タスク名のみ変更
    end

    if merge_EMG_figure
        figure('position', [100, 100, 1280, 720]);
    end
    for jj = 1:length(filtered_EMG_fileNames) %こ???ループ???の筋肉の??ータが，生??ータのどの電極に対する??
        load([filtered_EMG_pathName filtered_EMG_fileNames{jj}], 'Data','Name');
        all_filtered_data{jj,1} = Data;
        filtered_data = Data;
        Name = strrep(Name, unique_string, ''); 
        all_filtered_name{jj,1} = Name;
        % 
        selected_electrode = use_electrode_num(find(strcmp(EMGs, Name))); %filteredデータに対応する，生データの電極番号を返す
        raw_data = EMG_data(selected_electrode, :);
        try %timingデータがある時(trimできる)
            load([RawEMG_pathName task_name '_timing.mat'], 'all_timing_data', 'SamplingRate')
            raw_timing_data = all_timing_data * (1000/SamplingRate); %元の筋電のサンプリングレート/SamplingRate           
            raw_data = raw_data(1, raw_timing_data(1,1):raw_timing_data(2,include_task)); %トリミング
            filtered_data = filtered_data(1, all_timing_data(1,1):all_timing_data(2,include_task)); %トリミング
        catch %timingデータがない時 
            no_trim_flag = 1; %変数の中身は関係ない.(この変数が定義されたことが大事)
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
                    %まだできていない
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
    if ischar(RawEMG_fileNames) %ひとつしかtaskを選択してないと,タスクの数ではなく文字列長さでループするため,breakして終了
        break;
    end
end

%% set function
function return_value = abs_roundup(input_num)
% 入力した数値の絶対値を，初めて出てきた桁の下の桁で繰り上がりするための関数
if input_num < 0
    input_num = abs(input_num);
    flag = 1; %マイナス値かどうかの判断
end
decimal_places = 0; % 初めて出てきた桁が小数点以下何桁か
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