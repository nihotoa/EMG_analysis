%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
応急的にシナジー解析の結果を図示するための関数
W,H,VAFの図示と保存
EMGをDownSamplingする必要がある
pre: makeEMGNMF_ohta
post: nothing
閾値を手動で切るためのコードを作成する
【注意点】
・コード中でEMG_filterというlocal関数がコメントアウトされているが，
　これは，フィルタリングした後の波が思ったより高周波だったので，後付けでローパスかけようとしたもの
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
day_names = {'pre', 'post'};
def_syn_num = 'auto';%'auto' / 'manual' %閾値から決める場合は'auto', 自分で決める場合はmanual 
r2_threshold = 0.8;
trim_task = 1; %synergy_Hをトリミングするかどうか
trim_type = 'average'; % 'average'/'stack'
use_pc = 'mac'; % 'mac'/'windows'
normalize_sampling = 1000; %時間正規化するときの分解能(1000だったら，1000点プロット)
% filter_l = 2;
%% code section
% standard.matとt_~standard.matを選択
disp('【please select t~_standard.mat and _standart.mat】')
[fileNames,use_val.pathName] = selectGUI(patient_name, 'standard');
switch use_pc
    case 'windows'
        temp = strsplit(use_val.pathName, '\');
    case 'mac'
        temp = strsplit(use_val.pathName, '/');
end
% task_type = temp{end-3};
path_elements = split(use_val.pathName,filesep);
task_names = get_task_dirs(patient_name,path_elements, day_names);
default_path = use_val.pathName;
%ループ
for task_num = 1:length(task_names)
    use_val.pathName = strrep(default_path,task_names{1}, task_names{task_num});
    % r2関連の処理
    if contains(fileNames{1},'t_')
        r2_fileName = fileNames{2};
        synergy_fileName = fileNames{1};
    else
        r2_fileName = fileNames{1};
        synergy_fileName = fileNames{2};
    end
    load([use_val.pathName r2_fileName], 'r2', 'shuffle', 'TargetName');
    figure('position', [100, 100, 800, 800]);
    plot(r2, 'LineWidth',1.5)
    hold on
    plot(shuffle.r2, 'LineWidth',1.5)
    yline(r2_threshold, 'r', 'LineWidth',1.5)
    grid on;
    h = gca; % 現在のグラフのaxesオブジェクトを取得
    xaxis = h.XAxis; % x軸のプロパティを取得
    yaxis = h.YAxis; % y軸のプロパティを取得
    xaxis.FontSize = 16; % x軸の目盛りの文字のフォントサイズを16に変更
    yaxis.FontSize = 16; % y軸の目盛りの文字のフォントサイズを16に変更
    hold off
    % フォルダの作成
    use_val.muscle_num = length(r2);
    use_val = make_syn_fold(use_val);
    syn_fold_path = use_val.syn_fold_path;
    
    % save figure
    saveas(gcf, [syn_fold_path '/' 'r2' '/' 'VAF.png'])
    saveas(gcf, [syn_fold_path '/' 'r2' '/' 'VAF.png'])
    close all
    
    % W,H関連の処理
    load([use_val.pathName synergy_fileName], 'W', 'H');

    switch def_syn_num
        case 'auto'
            ref_syn_num = min(find(r2 > r2_threshold));
        case 'manual'
            if task_num == 1
                str = input('please Enter ref_syn_num: ', 's');
                ref_syn_num = str2double(str);
            end

    end
    %↓閾値を初めて超えたシナジー数
    use_val = make_syn_fold(use_val, ref_syn_num);
    W_data = W{ref_syn_num};
    H_data = H{ref_syn_num};
    
    judge_muscle_name = 'Triceps';
    for ii = 1:length(TargetName)
        if contains(TargetName{ii}, judge_muscle_name)
            removed_str = strrep(TargetName{ii}, judge_muscle_name, '');
            break;
        end
    end
    
    for ii = 1:length(TargetName)
        TargetName{ii} = strrep(TargetName{ii}, removed_str, '');
        if contains(TargetName{ii}, '_')
            TargetName{ii} = strrep(TargetName{ii}, '_', '-');
        end
    end
    
    x = categorical(TargetName); 
    %W_syenrgyのプロット
    for ii = 1:ref_syn_num
        lim_ref = ceil(max(W_data(:,1)))+1; %全てのシナジーの中での，重みの最大値
        if ii == 1
            figure('position', [100, 100, 700, 800]);
        end
        hold on
        subplot(ref_syn_num,1,ii)
        bar(x, W_data(:,ii),'b','EdgeColor','none')
        ylim([0 lim_ref])
        ax = gca;
        ax.XAxis.FontSize = 20;
        ax.YAxis.FontSize = 20;
    end
    hold off
    % データのセーブ
    saveas(gcf, [use_val.W_fold '/' 'W_synergy.fig'])
    saveas(gcf, [use_val.W_fold '/' 'W_synergy.png'])
    close all

    %H_synergyのプロット
    index = find(strcmp(path_elements,'Human')); %path_elements上の'Human'の格納されているindex
    load([path_elements{index+1} '/' path_elements{index+2} '/' task_names{task_num} '_timing.mat'], 'SamplingRate', 'all_timing_data')
    figure('position', [100, 100, 700, 800]);
    for ii = 1:ref_syn_num
        use_data = resample(H_data(ii,:),SamplingRate, 100);
        hold on
        subplot(ref_syn_num,1,ii)
        if trim_task == 1
            switch trim_type
                case 'average'
                    Normalized_data = zeros(length(all_timing_data), normalize_sampling);
                    for jj = 1:length(all_timing_data)
                        trimmed_data = use_data(all_timing_data(1,jj):all_timing_data(2,jj));
                        Normalized_data(jj,:) = resample(trimmed_data,normalize_sampling,length(trimmed_data));
                    end
                    Normalized_data_mean = mean(Normalized_data);
                    Normalized_data_std = std(Normalized_data);
                    plot(Normalized_data_mean,'r','LineWidth',2);
                    hold on
                    ar1=area(transpose([Normalized_data_mean-Normalized_data_std;Normalized_data_std+Normalized_data_std]));
                    set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','b')
                    set(ar1(2),'FaceColor','b','FaceAlpha',0.2,'LineStyle',':','EdgeColor','b') 
                    grid on;
                    trim_state = '(trimmed_average)';
                case 'stack'
                    for jj = 1:length(all_timing_data)
                        trimmed_data = use_data(all_timing_data(1,jj):all_timing_data(2,jj));
                        x = linspace(0,1,length(trimmed_data));
    %                     Normalized_data = resample(trimmed_data,1000,length(trimmed_data));
    %                     plot(Normalized_data, 'LineWidth', 1.5)      
                        plot(x, trimmed_data, 'LineWidth', 1.5)
                    end
                     trim_state = '(trimmed_stack)';
            end
        elseif trim_task == 0
            plot(use_data, 'LineWidth', 1.5)
            trim_state = '(not-trimmed)';
        end
    end
    hold off
    title(['Synergy' num2str(ii)])
    %save
    saveas(gcf, [use_val.H_fold '/' 'H_synergy' trim_state '.fig'])
    saveas(gcf, [use_val.H_fold '/' 'H_synergy' trim_state '.png'])
    close all;
    %動作のプロット(skeltonを作成する & 回内と回外がないかを確認する)
end
%% decide local function
%{
function [processed_EMG] = EMG_filter(filter_l, SamplingRate, temp_EMG)
%high_pass
% [B,A] = butter(6, (filter_h .* 2) ./ SamplingRate, 'high');
% temp_EMG = temp_EMG;
% temp_EMG = filtfilt(B,A,temp_EMG);
%low_pass(500Hz)
% [B,A] = butter(6, (500 .* 2) ./ use_val.SamplingRate, 'low');
% temp_EMG = filtfilt(B,A,temp_EMG);

%smoothing(平滑化)→整流した後にタスクを重ね合わて、その後に平均をとって、その後にこの処理をするべき
[B,A] = butter(6, (filter_l .* 2) ./ SamplingRate, 'low');
processed_EMG = filtfilt(B,A,temp_EMG);
end
%}

function [use_val] = make_syn_fold(use_val, ref_syn_num)
input_param_num = nargin;
switch input_param_num
    case 1
        pathName = use_val.pathName; 
        mucle_num = use_val.muscle_num;
        fold_name = ['syn_result_' num2str(mucle_num)];
        use_val.syn_fold_path = [pathName fold_name];
        if not(exist( use_val.syn_fold_path))
            mkdir([use_val.syn_fold_path '/' 'W'])
            mkdir([use_val.syn_fold_path '/' 'H'])
            mkdir([use_val.syn_fold_path '/' 'r2'])
        end
    case 2
        use_val.W_fold = [use_val.syn_fold_path '/' 'W' '/' 'synergy' num2str(ref_syn_num)];
        use_val.H_fold = [use_val.syn_fold_path '/' 'H' '/' 'synergy' num2str(ref_syn_num)];
        if not(exist(use_val.W_fold))
            mkdir(use_val.W_fold)
            mkdir([use_val.H_fold])
        end
end
end
