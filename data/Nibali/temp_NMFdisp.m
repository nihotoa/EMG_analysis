%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last Modification: 2023.03.31

【procedure】
・pre: makeEMGNMF_ohta
・post: nothing
【function】
・タスクの定義のための，シナジーがセッション間で変化がないかをを見定めるためのコード
・
【caution!!!】
・Nibaliの実験解析自体にはなんら関係ない
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

%% set param
exp_day = {'20230329', '20230330'};

%% code section
disp('【解析に使用するNMFファイルが入っているフォルダを指定してください】')
file_fold_path = uigetdir();
num_str = regexp(file_fold_path, '\d+', 'match');
day_name = num_str{1};

all_W_data = {};
all_H_data = {};
all_VAF_data = {};
all_shuffle_data = {};
for ii = 1:length(exp_day)
    use_file_fold_path = strrep(file_fold_path, day_name, exp_day{ii});
    [H_data, W_data, VAF_data, shuffle_data] = extract_data(use_file_fold_path);
    all_W_data = horzcat(all_W_data ,W_data);
    all_H_data = horzcat(all_H_data ,H_data);
    all_VAF_data = horzcat(all_VAF_data ,VAF_data);
    all_shuffle_data = horzcat(all_shuffle_data ,shuffle_data);
end
% 全てのセッションの，セッションごとのr2を調べる
figure('Position',[100 100 1000 800]);
hold on
for ii = 1:length(all_VAF_data)
    plot(all_VAF_data{ii}, 'LineWidth', 1.2)
%     plot(all_shuffle_data{ii}, 'LineWidth', 1.2, 'Color', 'K')
end
yline(0.8, 'LineWidth', 1.5, 'Color','r')
hold off
saveas(gcf, [file_fold_path 'VAF_result.fig'])
saveas(gcf, [file_fold_path 'VAF_result.png'])
close all;

% Wのプロット

%% define local function

function  [H_data, W_data, VAF_data, shuffle_data] = extract_data(use_file_fold_path)
WH_file_lists = dir([use_file_fold_path '/' 't_group*.mat']);
VAF_file_lists = dir([use_file_fold_path '/' 'group*.mat']);
H_data = {};
W_data = {};
VAF_data = {};
shuffle_data = {};
for ii = 1:length(WH_file_lists)
    load([use_file_fold_path '/' VAF_file_lists(ii).name], 'r2', 'shuffle')
    load([use_file_fold_path '/' WH_file_lists(ii).name], 'W', 'H')
    H_data{end+1} = H;
    W_data{end+1} = W;
    VAF_data{end+1} = r2;
    shuffle_data{end+1} = shuffle.r2;
end
end


% ↓W synergyの整列(まだできていない)
%{
function [] = align_W(,pcNum,)
for ii = pcNum(1,1) : pcNum(1,end)
    align_use_W = use_W; %k_arrの作成用にuse_wを複製する
    k_arr{ii,1} = zeros(ii,length(Target_date)-1);
    for kk = 1:ii %初日のシナジー数
        eval(['synergy' num2str(kk) ' = align_use_W{ii,1}{1,1}(:,kk);']) %初日のsynergy1を全体のsynergy1とする
        e_value_sel = zeros(length(Target_date),2);
        
        for ll = 2:length(Target_date)
            for mm = 1:ii
                e_value_ind = sum(eval(['abs(align_use_W{ii,1}{ll,1}(:,mm) - synergy' num2str(kk) ')'])); %indはindividualの意味
                e_value_sel(ll,mm) = e_value_ind; 
            end
            [~,I] = min(e_value_sel(ll,:));
            align_use_W{ii,1}{ll,1}(:,I) = 1000;
            k_arr{ii,1}(kk,ll-1) = I;
        end
    end   
end
end
%}