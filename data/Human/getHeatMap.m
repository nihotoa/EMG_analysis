%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota
Last modification: 2023.04.05
【function】
function to confirm EMG activity strength by HeatMap

pre: you need to finish all procedure up to filterEMG.m and
SuccessTiming_func.m and getMaxY.m
post nothing

【課題点】
使用しているデータが,全体データから1タスク目をトリミングしたものなので，
each_trialsの各データから,図を作成する様な仕様に変更する
(個々のtrialではなくて，全てのtrialの活動パターンを加味したヒートマップはどうやって作る?)
 → 平均をとるか,全タスク分を加算してから新服正規化するか(平均と同じ?)

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
include_task = 1; %何個分のタスクを含めるか
unique_string = '-hp50Hz-rect-lp3Hz-ds100Hz'; %uniqueな文字列

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

%post1, post2,post3,post4,post4_rightの時
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
path_elements = split(RawEMG_pathName, '/');
day_name = path_elements{end-1};
for ii = 1:length(RawEMG_fileNames) %タスクごとに処理をループ(その日の全てのデータに対して処理を適用するため)
    if ischar(RawEMG_fileNames)
        task_name = strrep(RawEMG_fileNames, '.mat', '');
    else
        task_name = strrep(RawEMG_fileNames{ii}, '.mat', '');
    end
    select_dir = [RawEMG_pathName task_name]; %taskフォルダまでの絶対パス
    if ii == 1
        disp('【Please select filtered_EMG files】')
        [filtered_EMG_fileNames, filtered_EMG_pathName] = uigetfile([ '*' unique_string '.mat'],'Select a file',select_dir,'MultiSelect','on');
        change_place = task_name; %task2以降で,変更すべきstring
        changed_path = filtered_EMG_pathName; %元となるpath(task1の絶対パス)
    else
        filtered_EMG_pathName = strrep(changed_path, change_place, task_name); %タスク名のみ変更
    end

    filtered_EMG = cell(length(filtered_EMG_fileNames) ,1); 
    muscle_name = cell(length(filtered_EMG_fileNames) ,1); 
    for jj = 1:length(filtered_EMG_fileNames) %筋肉ごとにループする
        load([filtered_EMG_pathName filtered_EMG_fileNames{jj}], 'Data','Name');
        filtered_data = Data;
        Name = strrep(Name, unique_string, ''); 
        selected_electrode = use_electrode_num(find(strcmp(EMGs, Name))); %filteredデータに対応する，生データの電極番号を返す
        %timingデータがある時(trimできる)ここで切り取られる範囲が決まる
        load([RawEMG_pathName task_name '_timing.mat'], 'all_timing_data', 'SamplingRate')         
        filtered_data = filtered_data(1, all_timing_data(1,1):all_timing_data(2,include_task)); %トリミング
        Name = strrep(Name,'_', '-');
        filtered_EMG{jj} = filtered_data;
        muscle_name{jj} = Name;
    end
    filtered_EMG = cell2mat(filtered_EMG);
    filtered_EMG = normalize(filtered_EMG, 'mean');
    figure('position', [100, 100, 1000, 1000])
    y_axis = muscle_name;
    x_axis = linspace(0,1, size(filtered_EMG, 2));
    imagesc(filtered_EMG) %ヒートマップみたいなやつ
    yticks(1:length(muscle_name)) %y軸上の，labelをつける場所を選択
    yticklabels(muscle_name)
    xticks([1, (1+size(filtered_EMG, 2))/2, size(filtered_EMG, 2)]) %y軸上の，labelをつける場所を選択(初め真ん中,終わりの三か所)
    xticklabels([0, 0.5, 1])
    set(gca, 'FontSize', 20)
    title(['all-muscle-activity(' day_name '-' task_name ')'], 'FontSize', 25)
    colorbar
    % save
    saveas(gcf, [select_dir '/' 'EachEMG' '/' 'filtered_EMG(' num2str(include_task) 'task_span).png'])
    saveas(gcf, [select_dir '/' 'EachEMG' '/' 'filtered_EMG(' num2str(include_task) 'task_span).fig'])
    close all;
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