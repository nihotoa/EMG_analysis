%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota   
Last modification: 2023.07.24
シナジー解析の日毎のstackを,taskごとに行うための関数
W,H,VAFの図示と保存
pre: makeEMGNMF_ohta
post: nothing
【注意点】
・コード中でEMG_filterというlocal関数がコメントアウトされているが，
　これは，フィルタリングした後の波が思ったより高周波だったので，後付けでローパスかけようとしたもの
【課題点】
・ループ数たびにcell配列を作るように変更する(今のようにループごとに変数の形が変わると，次のtaskのループに入った時に，その変数をclearしなければいけないから)
・シナジーのsortのアルゴリズム(k_arrの決定)として，Hをもとにk_arrを決めるアルゴリズムを追加する
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
use_val.patient_name = 'patientB';
day_names = {'pre', 'post'};
def_syn_num = 'manual';%'auto' / 'manual' %解析に用いるシナジーの数.VAFの閾値から決める場合は'auto', 自分で決める場合はmanual 
r2_threshold = 0.8;
use_pc = 'mac'; % 'mac'/'windows'
out_day = {'pre1', 'post4', 'post4_right'}; %stackに追加したくない日付がある場合にはここで指定する.
% filter_l = 2;
%% code section
% 解析に使用する，全日付のフォルダ名を取得
day_folders = dir([pwd '/' use_val.patient_name]);
day_folders = day_folders([day_folders.isdir]); % フォルダだけに絞り込み
day_folders = {day_folders.name}; % フォルダ名だけを抽出
day_folders = day_folders(contains(day_folders, day_names)); %名前の中にpreかpostを含んでいるもののみ抽出
day_folders = day_folders(~ismember(day_folders, out_day)); % '.'や'..'を除外

% 解析に使用する，全taskのフォルダ名を取得
task_folders = dir([pwd '/' use_val.patient_name '/post2']);
task_folders = task_folders([task_folders.isdir]); % フォルダだけに絞り込み
task_folders = {task_folders.name}; % フォルダ名だけを抽出
task_folders = task_folders(~ismember(task_folders, {'.', '..'})); % '.'や'..'を除外

% standard.matとt_~standard.matを選択
disp('【please select t~_standard.mat and _standart.mat】')
[fileNames,use_val.pathName] = selectGUI(use_val.patient_name, 'standard');
switch use_pc
    case 'windows'
        temp = strsplit(use_val.pathName, '\');
    case 'mac'
        temp = strsplit(use_val.pathName, '/');
end
% task_type = temp{end-3};
path_elements = split(use_val.pathName,filesep);
default_path = use_val.pathName;

%defaultのfile nameを取得
if contains(fileNames{1},'t_')
    default_r2_fileName = fileNames{2};
    default_synergy_filename = fileNames{1};
else 
    default_r2_fileName = fileNames{1};
    default_synergy_filename = fileNames{2};
end

%VAF, W, Hの順番でtask1~5までstackする
for task_num = 1:length(task_folders)
    clear('use_W*')
    clear('use_H*')
    clear('day_folders_*')
    clear('k_arr')
    %loadするfile名の変更
    r2_fileName = strrep(default_r2_fileName, task_folders{1}, task_folders{task_num});
    synergy_fileName = strrep(default_synergy_filename, task_folders{1}, task_folders{task_num});
    task_fixed_path_name = strrep(default_path, task_folders{1}, task_folders{task_num});
    %VAFについて
    for day_num = 1:length(day_folders)
        %一番最初のループ時
        if day_num == 1
            default_task_fixed_path_name = task_fixed_path_name;
            for kk = 1:length(day_folders)
                if contains(default_task_fixed_path_name, day_folders{kk})
                    default_index = kk;
                    break;
                end
            end
        end
        % change default_file_path_name
        % default_task_fixed_path_name内のdayが，day_folders内のどのインデックスの要素に対応するか調べる
        task_fixed_path_name = strrep(default_task_fixed_path_name, day_folders{default_index}, day_folders{day_num});
        try
            load([task_fixed_path_name r2_fileName], 'r2', 'shuffle', 'TargetName');
        catch %そのタスクが存在しない時
            continue;
        end
        if day_num == 1
            figure('position', [100, 100, 800, 800]);
            legend_name_cell = repmat({' '}, 1, length(day_folders)+2); 
        end
        hold on;
        plot(r2, 'LineWidth',1.5)
        ylim([0.5 1])
        %最適シナジー数を見つける
        switch def_syn_num
            case 'auto'
                ref_syn_num_list(day_num) = min(find(r2 > r2_threshold));
            case 'manual'
                if day_num == 1
                    str = input('please Enter ref_syn_num: ', 's');
                end
                ref_syn_num_list(day_num) = str2double(str);
        end
        legend_name_cell{day_num} = day_folders{day_num};
        if day_num == length(day_folders)
            yline(r2_threshold, 'r', 'LineWidth',1.5)
            grid on;
            %shuffleのplot(最終日だけ)
%             plot(shuffle.r2, 'LineWidth',1.5)
            legend(legend_name_cell, 'Location', 'southeast');
            h = gca; % 現在のグラフのaxesオブジェクトを取得
            xaxis = h.XAxis; % x軸のプロパティを取得
            yaxis = h.YAxis; % y軸のプロパティを取得
            xaxis.FontSize = 16; % x軸の目盛りの文字のフォントサイズを16に変更
            yaxis.FontSize = 16; % y軸の目盛りの文字のフォントサイズを16に変更
            hold off
        end
    end
    % フォルダの作成
    use_val.muscle_num = length(r2);
    use_val.task_name = task_folders{task_num};
    use_val = make_syn_fold(use_val);
    syn_fold_path = use_val.syn_fold_path;
    
    % save figure
    saveas(gcf, [syn_fold_path '/' 'r2' '/' 'VAF.png'])
    saveas(gcf, [syn_fold_path '/' 'r2' '/' 'VAF.fig'])
    close all;
    
    % W,Hについて

    % 処理内容の名前部分の抽出
    judge_muscle_name = 'Triceps';
    for ii = 1:length(TargetName)
        if contains(TargetName{ii}, judge_muscle_name)
            removed_str = strrep(TargetName{ii}, judge_muscle_name, '');
            break;
        end
    end
    
    %string中の_を-に直す(ファイルの読み込みのため)
    for ii = 1:length(TargetName)
        TargetName{ii} = strrep(TargetName{ii}, removed_str, '');
        if contains(TargetName{ii}, '_')
            TargetName{ii} = strrep(TargetName{ii}, '_', '-');
        end
    end
    x = categorical(TargetName); 

    for day_num = 1:length(day_folders) %日付の数
        task_fixed_path_name = strrep(default_task_fixed_path_name, day_folders{default_index}, day_folders{day_num});
        try
            load([task_fixed_path_name synergy_fileName], 'H', 'W');
        catch %そのタスクが存在しない時
            continue
        end
        
        x = categorical(TargetName); 

        %alignのためのデータセットの作成
        if day_num == 1 %初めてのループの時
            eval(['use_W_' num2str(ref_syn_num_list(1)) '{1,1} = W{' num2str(ref_syn_num_list(1)) '};']);
            eval(['use_H_' num2str(ref_syn_num_list(1)) '{1,1} = H{' num2str(ref_syn_num_list(1)) '};']);
            eval(['day_folders_syn' num2str(ref_syn_num_list(1)) '{1} = day_folders{1};'])
            % day_folders_syn3(1) = day_folders{1};
            % use_W_3{1,1} = W{3}
        elseif not(exist(['use_W_' num2str(ref_syn_num_list(day_num))])) %そのシナジー数でのuse_Wが存在しない
            eval(['use_W_' num2str(ref_syn_num_list(day_num)) '{1,1} = W{' num2str(ref_syn_num_list(day_num)) '};']);
            eval(['use_H_' num2str(ref_syn_num_list(day_num)) '{1,1} = H{' num2str(ref_syn_num_list(day_num)) '};']);
            eval(['day_folders_syn' num2str(ref_syn_num_list(day_num)) '{1} = day_folders{' num2str(day_num) '};'])
        else %既に代入する変数が存在する時
            eval(['use_W_' num2str(ref_syn_num_list(day_num)) '{end+1,1} = W{' num2str(ref_syn_num_list(day_num)) '};']);
            eval(['use_H_' num2str(ref_syn_num_list(day_num)) '{end+1,1} = H{' num2str(ref_syn_num_list(day_num)) '};']);
            eval(['day_folders_syn' num2str(ref_syn_num_list(day_num)) '{end+1} = day_folders{' num2str(day_num) '};'])
            % use_W_3{end+1,1} = W{3}
            % day_folders_syn3(end+1) = day_folders{1};
        end
    end

    %並び替えのアルゴリズム
    searchString = 'use_W';
    clear use_W_list %variableListに含まれてしまうので，一旦消す.
    % ワークスペース変数の変数名リストを取得
    variableList = who;
    % 指定した文字列を含む変数名を抽出
    use_W_list = variableList(contains(variableList, searchString));
    for ii = 1:length(use_W_list)
        % 数字のパターンを示す正規表現を定義
        pattern = '\d+';        
        % 正規表現を使って数字の部分を抽出
        ref_syn_num = regexp(use_W_list{ii}, pattern, 'match');
        ref_syn_num = str2double(ref_syn_num{1});
        if length(eval(['use_W_' num2str(ref_syn_num)])) == 1
            %並び替えの必要なし
            k_arr{ref_syn_num} = 1;
        else
            k_arr{ref_syn_num} = align_W_synergy(eval(['use_W_' num2str(ref_syn_num)]), ref_syn_num, eval(['day_folders_syn' num2str(ref_syn_num)]));
        end
    end
    
    %W_syenrgyのプロット
    for ii = 1:length(k_arr)
        if isempty(k_arr{ii})
            continue
        else
            % ↓synergy解析用のフォルダの作成
            ref_syn_num = ii;
            use_val = make_syn_fold(use_val, ref_syn_num);
            for jj = 1:ref_syn_num
                if jj == 1
                    figure('position', [100, 100, 700, 800]);
                end
                hold on
                subplot(ref_syn_num,1,jj)
                clear W_data
                for kk = 1:length(eval(['use_W_' num2str(ref_syn_num)]))
                    if kk == 1
                        W_data(:, 1) = eval(['use_W_' num2str(ref_syn_num) '{1}(:, jj);']); %初日のシナジーjjのデータ
                    else
                        W_data(:, kk) = eval(['use_W_' num2str(ref_syn_num) '{kk}(:, k_arr{ref_syn_num}(jj));']);%初日のjjに対応するシナジー
                    end
                end
                bar(x, W_data,'EdgeColor','none')
                if jj == 1
                    legend(eval(['day_folders_syn' num2str(ref_syn_num)]));
                end
                lim_ref = ceil(max(reshape(W_data,[],1)))+1; %全てのシナジーの中での，重みの最大値
                ylim([0 lim_ref])
                ax = gca;
                ax.XAxis.FontSize = 20;
                ax.YAxis.FontSize = 20;
            end
            hold off
            % データのセーブ
            saveas(gcf, [use_val.W_fold{ref_syn_num} '/' 'W_synergy.fig'])
            saveas(gcf, [use_val.W_fold{ref_syn_num} '/' 'W_synergy.png'])
            close all
            end
    end
    %H_synergyについて
    for ii = 1:length(k_arr)
        if isempty(k_arr{ii})
            continue
        else
            ref_syn_num = ii;
            for jj = 1:ref_syn_num
                if jj == 1
                    figure('position', [100, 100, 700, 800]);
                end
                hold on
                subplot(ref_syn_num,1,jj)
                for kk = 1:length(eval(['use_W_' num2str(ref_syn_num)])) %その最適シナジー数の日付の数
                    clear H_data_task
                    if kk == 1
                        H_data = eval(['use_H_' num2str(ref_syn_num) '{1}(jj, :);']); %初日のシナジーjjのデータ
                        %H_dataをトリミングして，タスク平均を出す
                        timing_path = [pwd '/' use_val.patient_name '/' eval(['day_folders_syn' num2str(ref_syn_num) '{kk}'])];
                        load([timing_path '/' task_folders{task_num} '_timing.mat'], 'all_timing_data');
                        for ll = 1:length(all_timing_data) %task中の活動パターンの平均をとる
                            H_data_task{ll, 1} = H_data(1, all_timing_data(1, ll)+1:all_timing_data(2,ll));
                        end
                        a = 0;
                        for ll = 1:length(all_timing_data) %平均サンプル数を求める
                            a = a + length(H_data_task{ll});
                        end
                        average_sample_num = round(a/length(all_timing_data));

                        for ll = 1:length(all_timing_data) %平均サンプル数を求める
                            H_data_task{ll} = resample(H_data_task{ll}, average_sample_num, length(H_data_task{ll}));
                        end       
                        H_data_ave = mean(cell2mat(H_data_task));
                        y = linspace(0, 1, average_sample_num);
                        plot(y, H_data_ave, 'LineWidth', 1.5);
                        hold on;
                    else
                        timing_path = [pwd '/' use_val.patient_name '/' eval(['day_folders_syn' num2str(ref_syn_num) '{kk}'])];
                        load([timing_path '/' task_folders{task_num} '_timing.mat'], 'all_timing_data');
                        H_data = eval(['use_H_' num2str(ref_syn_num) '{kk}(k_arr{ref_syn_num}(jj), :);']);%初日のjjに対応するシナジー
                        for ll = 1:length(all_timing_data) %task中の活動パターンの平均をとる
                            H_data_task{ll, 1} = H_data(1, all_timing_data(1, ll)+1:all_timing_data(2,ll));
                        end
                        a = 0;
                        for ll = 1:length(all_timing_data) %平均サンプル数を求める
                            a = a + length(H_data_task{ll});
                        end
                        average_sample_num = round(a/length(all_timing_data));

                        for ll = 1:length(all_timing_data) %平均サンプル数を求める
                            H_data_task{ll, 1} = resample(H_data_task{ll}, average_sample_num, length(H_data_task{ll}));
                        end
                        H_data_ave = mean(cell2mat(H_data_task));
                        y = linspace(0, 1, average_sample_num);
                        plot(y, H_data_ave, 'LineWidth',1.5);
                    end
                end
                if jj == 1
                    legend(eval(['day_folders_syn' num2str(ref_syn_num)]));
                end
                lim_ref = ceil(max(reshape(W_data,[],1)))+1; %全てのシナジーの中での，重みの最大値
                % decoration
                grid on;
                ax = gca;
                ax.XAxis.FontSize = 15;
                ax.YAxis.FontSize = 15;
            end
            hold off
            % データのセーブ
            saveas(gcf, [use_val.H_fold{ref_syn_num} '/' 'H_synergy.fig'])
            saveas(gcf, [use_val.H_fold{ref_syn_num} '/' 'H_synergy.png'])
            close all
        end
    end
end

%% set local function
function [use_val] = make_syn_fold(use_val, ref_syn_num)
input_param_num = nargin;
switch input_param_num
    case 1
        pathName = [pwd '/' use_val.patient_name '/' 'stack_synergy_analysis_result' '/' use_val.task_name]; 
        mucle_num = use_val.muscle_num;
        fold_name = ['syn_result_' num2str(mucle_num)];
        use_val.syn_fold_path = [pathName '/' fold_name];
        if not(exist(use_val.syn_fold_path))
            mkdir([use_val.syn_fold_path '/' 'W'])
            mkdir([use_val.syn_fold_path '/' 'H'])
            mkdir([use_val.syn_fold_path '/' 'r2'])
        end
    case 2
        use_val.W_fold{ref_syn_num} = [use_val.syn_fold_path '/' 'W' '/' 'synergy' num2str(ref_syn_num)];
        use_val.H_fold{ref_syn_num} = [use_val.syn_fold_path '/' 'H' '/' 'synergy' num2str(ref_syn_num)];
        if not(exist(use_val.W_fold{ref_syn_num}))
            mkdir(use_val.W_fold{ref_syn_num})
            mkdir(use_val.H_fold{ref_syn_num})
        end
end
end

function [k_arr] = align_W_synergy(use_W, ref_syn_num, day_folders)
% align W_synergy to plot & create list of each synergy correspondence
align_use_W = use_W; %k_arrの作成用にuse_wを複製する
k_arr = zeros(ref_syn_num,length(day_folders)-1);
for kk = 1:ref_syn_num %初日のシナジー数
    eval(['synergy' num2str(kk) ' = align_use_W{1,1}(:,kk);']) %初日のsynergy1を全体のsynergy1とする
    e_value_sel = zeros(length(day_folders)-1,ref_syn_num);
    
    for ll = 2:length(day_folders) %日付分だけループ(post1, post2 ...)
        for mm = 1:ref_syn_num
            e_value_ind = sum(eval(['abs(align_use_W{ll,1}(:,mm) - synergy' num2str(kk) ')'])); %indはindividualの意味
            e_value_sel(ll-1,mm) = e_value_ind; 
        end
        [~,I] = min(e_value_sel(ll-1,:));
        align_use_W{ll,1}(:,I) = 1000;
        k_arr(kk,ll-1) = I;
    end
end   
end
