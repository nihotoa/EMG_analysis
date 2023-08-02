%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last Modification: 2023.03.13
makeEMGNMF_bctOhtaを日付でループするための関数
(nibaliのファイル構造を他のサルと異なる形で作ってしまったので，既存の関数だと複数日の解析を一括でできないので作った)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
reference_type = 'Human'; %which type of data you want to analyze ('monkey'/'Human') 
data_type = 'each_trial'; % (reference_type == 'Human' の時)データセットとして，すべてのレコーディング区間を使用するか，taskごとに区切られたものを使用するか 'all'/'each_trial'
monkey_name = 'Nibali';
setting_Target_date = 0; %(if you will calculate in 'monkey')0:手動でTarget_dateを設定したとき 1:devide_infoから日付を設定したとき(生成したグラフやディレクトリの名前を決定するときに、devide_infoを使用したことをわかるようにしたい)
Target_date = [20230420]; %(if you will calculate in 'monkey')相関を求めたい対象の実験日を配列にまとめる

%% code section
% set first displayed directory
current_dir = pwd;
each_elements = split(current_dir, '/');
use_elements = each_elements(1:end-1);
use_elements{end+1} = 'data';
dir_path = join(use_elements, '/');
switch reference_type
    case 'monkey'
        disp("【please select 'MATLAB' -> 'data' -> monkey_name(what you want to use】")
        [monkey_dir] = uigetdir([dir_path{1} '/' monkey_name]);
        if setting_Target_date == 1
            load([monkey_dir '/' 'devide_info' '/' 'all_day_trial.mat'], 'trial_day'); %全ての実験日の日付リストをロードする
            Target_date = GenerateTargetDate(trial_day ,'all',0,1000,monkey_dir); %解析する日付をcell配列に格納するための変数．あんまり気にしない
        end
        makeEMGNMF_btcOhta(Target_date, reference_type)
    case 'Human'
        disp("【please select 'MATLAB' -> 'data' -> 'Human' -> patientB -> day】")
        reference_dir = uigetdir([dir_path{1} '/' 'Human']);
        file_info = dir(reference_dir);
        Task_dirs = {file_info([file_info.isdir]).name}; 
        Task_dirs = Task_dirs(~ismember(Task_dirs, {'.', '..'}));
        switch data_type
            case 'all'
                makeEMGNMF_btcOhta(Task_dirs, reference_type)
            case 'each_trial'
                path_elements = split(reference_dir, '/');
                date = path_elements{end};
                for ii = 1:length(Task_dirs)
                    if ii == 1
                        [ParentDir_def, InputDirs_def, OutputDir_def] = makeEMGNMF_btcOhta('nothing',reference_type, date, Task_dirs{ii});
                    else
                        ParentDir = ParentDir_def; %をうまく書き換える
                        OutputDir = OutputDir_def; %をうまく書き換える
                        %trial_num = all_timingの長さ
                        InputDirs = MakeTaskFoldersCell(trial_num, 'trial');
                        makeEMGNMF_btcOhta('nothing',reference_type ,date, Task_dirs{ii}, ParentDir, InputDirs, OutputDir)
                    end
                end
        end
end