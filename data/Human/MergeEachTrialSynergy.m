%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota

function:
merge all trials data and plot mean +- std data of r2, W, H
すべてのtrialデータをマージして,r2, W, Hをプロットする関数

procedure:
pre: loopmakeEMGNMF_btcOhta.m
before-pre: devide_filteredEMG.m
post: nothing

※この関数はLoopMerge Each TrialSynergy.m　からの呼び出しで使用される
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MergeEachTrialSynergy(patient_name, day_name, task_name, common_string, ref_syn_num, most_dark_value, plot_type)
%% set param
% patient_name = 'patientB';  %後で消す(この関数を呼び出すfunctionないで定義する)
% day_name = 'post1'; %後で消す
% task_name = 'Task01'; %後で消す
% common_string = '-hp50Hz-rect-lp3Hz-ds100Hz'; %後で消す
% ref_syn_num = 3; %後で消す?(この中で決める?) %自動じゃない方がいい気がするから消していいと思う
% most_dark_value = 80; %後で消す
% plot_type = 'mean'; %'stack' / 'mean' %後で消す
%% code section
trial_data_path = [pwd '/' patient_name '/' day_name '/' task_name '/' 'nmf_result' '/patientB_standard/each_trials'];
trial_names = getDirectoryInfo(trial_data_path, 'trial', 'name');
trial_num = length(trial_names);
synergy_file_name = ['t_' task_name '_standard_Nofold.mat'];
r2_file_name = [task_name '_standard_Nofold.mat'];

% trialデータをまとめる
for ii = 1:trial_num
    %r2fileのロード
    load([trial_data_path '/' trial_names{ii} '/' r2_file_name], 'r2', 'shuffle', 'TargetName')
    % muscle_nameの取得
    %まとめる
    if ii == 1
        muscle_name = generate_muscle_name(TargetName, common_string);
        r2_fold = zeros(length(TargetName), trial_num);
        shuffle_representative = shuffle;
    end
    r2_fold(:, ii) = r2;

    %W,Hのロード
    load([trial_data_path '/' trial_names{ii} '/' synergy_file_name], 'W', 'H')
    if ii == 1
        W_fold = cell(trial_num, 1);
        H_fold = cell(trial_num, 1);
    end
    %まとめる
    W_fold{ii} = W{ref_syn_num};
    H_fold{ii} = H{ref_syn_num};
end

% Hの長さを揃える処理
H_length_mean = mean_length(H_fold);
H_fold = resample_H(H_fold, H_length_mean);

 % シナジーの並び替えに関するリスト(k_arr)の作成
[k_arr] = align_W_synergy(W_fold, ref_syn_num);

%保存するフォルダの作成
if not(exist([trial_data_path '/' 'nmf_result_figure']) == 7)
    make_result_dir(trial_data_path)
end

%% r2　について
result_path = [trial_data_path '/' 'nmf_result_figure' '/' 'r2'];
figure('position', [100, 100, 1200, 800])
hold on;
for ii = 1:trial_num
    color_value = (most_dark_value + ((255 - most_dark_value) / (trial_num - 1)) * (ii - 1)) / 255;
    plot(r2_fold(:, ii), 'Color', [color_value, 0, 0], 'LineWidth', 1.5)
end
plot(shuffle_representative.r2, 'Color', 'b', 'LineWidth', 1.5)
%decoration
yline(0.8, 'g', LineWidth=1.5)
grid on;
ylim([0 1])
set(gca, 'FontSize', 20);
title(['VAF(' day_name '-' task_name '-' num2str(trial_num) 'trials)'], 'FontSize', 25)
% save figure
saveas(gcf, [result_path '/' 'VAF_result.png'])
saveas(gcf, [result_path '/' 'VAF_result.fig'])
close all;

%% Wについて
result_path = [trial_data_path '/' 'nmf_result_figure' '/' 'W'];
x = categorical(muscle_name); 
W_forplot = sort_W(W_fold, k_arr);
figure('position', [100, 100, 1200, 800])
for ii = 1:ref_syn_num
    subplot(ref_syn_num, 1, ii);
    switch plot_type
        case 'stack'
            bar(x, W_forplot{ii},'EdgeColor','none');
        case 'mean'
            W_mean = mean(W_forplot{ii}, 2);
            W_std = std(W_forplot{ii}, [], 2);
            bar(x, W_mean, 'EdgeColor', 'none');
            hold on
            er = errorbar(x, W_mean, -1 * W_std, W_std, 'Color','k', 'LineStyle','none', LineWidth=1.5);
            hold off
    end
    ylim([0 Inf])
    title(['Synergy' num2str(ii) ' pcNum = 3'], FontSize=15)
    set(gca, 'FontSize', 15);
end

% save figure
switch plot_type
    case 'stack'
        saveas(gcf, [result_path '/' 'W_syenrgy(pcNum=' num2str(ref_syn_num) ')_stack.png'])
        saveas(gcf, [result_path '/' 'W_syenrgy(pcNum=' num2str(ref_syn_num) ')_stack.fig'])
    case 'mean'
        saveas(gcf, [result_path '/' 'W_syenrgy(pcNum=' num2str(ref_syn_num) ')_mean.png'])
        saveas(gcf, [result_path '/' 'W_syenrgy(pcNum=' num2str(ref_syn_num) ')_mean.fig'])
end
close all;

%% Hについて
result_path = [trial_data_path '/' 'nmf_result_figure' '/' 'H'];
x = linspace(0,1,H_length_mean);
figure('position', [100, 100, 1000, 1000])
for ii = 1:ref_syn_num %シナジーiiについて
    subplot(ref_syn_num, 1, ii)
    hold on
    switch plot_type
        case 'stack'
            plot(x,H_fold{1}(ii, :),'Color',[most_dark_value/255, 0, 0], 'LineWidth',1.5)
            for jj = 2:trial_num
                color_value = (most_dark_value + ((255 - most_dark_value) / (trial_num - 1)) * (jj - 1)) / 255;
                plot(x,H_fold{jj}(k_arr(ii, jj-1), :), 'Color',[color_value, 0, 0], 'LineWidth',1.5)
            end
        case 'mean'
            ref_synergy_data = ExtractSynergydata(ii, H_fold, k_arr);
            mean_data = mean(ref_synergy_data);
            std_data = std(ref_synergy_data);
            hold on;
            %背景のプロット
            curve1 = mean_data + std_data;
            curve2 = mean_data - std_data;
            x2 = [x, fliplr(x)];
            inBetween = [curve1, fliplr(curve2)];
            fill(x2, inBetween, 'r', 'FaceAlpha',0.1, 'LineStyle',':', 'EdgeColor','r', 'DisplayName', '');
            %実線のプロット
            plot(x, mean_data, 'Color','r', 'LineWidth',1.5)
            hold off;
    end
    hold off
    %decoration
    grid on;
    title(['Synergy' num2str(ii) ' pcNum = 3'], FontSize=20)
    set(gca, 'FontSize', 15);
end
% save figure
switch plot_type
    case 'stack'
        saveas(gcf, [result_path '/' 'H_syenrgy(pcNum=' num2str(ref_syn_num) ')_stack.png'])
        saveas(gcf, [result_path '/' 'H_syenrgy(pcNum=' num2str(ref_syn_num) ')_stack.fig'])
    case 'mean'
        saveas(gcf, [result_path '/' 'H_syenrgy(pcNum=' num2str(ref_syn_num) ')_mean.png'])
        saveas(gcf, [result_path '/' 'H_syenrgy(pcNum=' num2str(ref_syn_num) ')_mean.fig'])
end
close all;
end
%% define local function

%% ファイル名から処理の名前部分を削除して筋肉名のcell配列を作成
function  muscle_name = generate_muscle_name(TargetName, common_string)
muscle_name = cell(length(TargetName), 1);
for ii = 1:length(TargetName)
    muscle_name{ii} = strrep(TargetName{ii}, common_string, '');
end
end

%% H_syergyの長さの平均を求める
function H_length_mean = mean_length(H_fold)
length_sum = 0;
trial_num = length(H_fold);
for ii = 1:trial_num
     length_sum = length_sum + length(H_fold{ii});
end
H_length_mean = round(length_sum / trial_num);
end

%% データ長を統一する(H_length_meanを基準として，すべてのH_foldの中身をresampleする)
function resampled_H_fold = resample_H(H_fold, H_length_mean)
trial_num = length(H_fold);
[ref_syn_num, ~] = size(H_fold{1});
for ii = 1:trial_num
    for jj = 1:ref_syn_num
        resampled_H_fold{ii, 1}(jj, :) = resample(H_fold{ii}(jj, :), H_length_mean, length(H_fold{ii}(jj, :)));
    end
end
end

%% 結果を保存するフォルダを作成する
function make_result_dir(trial_data_path)
    mkdir([trial_data_path '/' 'nmf_result_figure'])
    mkdir([trial_data_path '/' 'nmf_result_figure' '/' 'r2'])
    mkdir([trial_data_path '/' 'nmf_result_figure' '/' 'W'])
    mkdir([trial_data_path '/' 'nmf_result_figure' '/' 'H'])
end

%% Wを並び替えて，plot用の行列を作る
function W_forplot = sort_W(W_fold, k_arr)
trial_num = length(W_fold);
[muscle_num, ref_syn_num] = size(W_fold{1});

% 出力する行列の作成
W_forplot = cell(ref_syn_num, 1);
for ii = 1:ref_syn_num
    W_forplot{ii} = zeros(muscle_num, trial_num);
end

%収納していく
for ii = 1:ref_syn_num %初日のシナジーiiについて
    W_forplot{ii}(:,1) = W_fold{1}(:, ii);
    for jj = 2:trial_num %日付の数(初日を除く)
        W_forplot{ii}(:,jj) = W_fold{jj}(:, k_arr(ii, jj-1));
    end
end
end

%% Hを対象のシナジーについてまとめる
function ref_synergy_data = ExtractSynergydata(ii, H_fold, k_arr)
trial_num = length(H_fold);
ref_synergy_data = zeros(trial_num, length(H_fold{1}));
ref_synergy_data(1, :) = H_fold{1}(ii, :);
for jj = 2:trial_num
    ref_synergy_data(jj, :) = H_fold{jj}(k_arr(ii, jj-1), :);
end
end