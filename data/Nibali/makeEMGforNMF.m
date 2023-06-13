%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
last modification : 2022/12/22
coded by : Naohito Ohta
【fucntion】
save individual EMG_data for NMF analyse & plot those data and save as figure

【procedure】
pre : untitled.m
post : makeEMGNMF_btc_ohta.m
【改善点】
 figureの記述が冗長だから関数にして書き直す 
 NMF用のデータの保存
(save_dataとpictureも同じような処理ではあるが,あんまりかさばってないので関数にする必要ないと思われ)
mean_firstに対応できるように、関数を書き換える
【注意点】
NMF用のデータが入るフォルダの接頭語のpre/postは、フィルタリング処理において、rectより前にlpを
おこなっているか、あとにおこなっているかを示している
関数をもっと細分化したい(ref_data,図の装飾,nmf用データの保存)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
exp_day = [20220420];
monkey_name = 'Ni' ;
focus_timing = 'tim3'; %please select 'timing1'-'timing4'  'timing1','timing2','timing3','timing4'
conduct_lp = 0; %whether apply low-pass_filter
lp_Hz = 20; %(if you set conduct_lp = 1)cut off frecuency
processing_procedure = 'lp_first' ;%(if you set conduct_lp = 1) 'mean_first' or 'lp_first'ローパスと平均の処理の順序をどうするか？
line_wide = 1.2;
%% code section

% set save fold pass
data_save_dir = [num2str(exp_day) '/EMG_Data/Data'];
picture_save_dir = [num2str(exp_day) '/EMG_Data/picture'];
temp_NMF_data_dir = [num2str(exp_day) '/nmf_result/' monkey_name num2str(exp_day) '_standard'];

% load use file
file_dir = [num2str(exp_day) '/EMG_Data/Data'];
disp('【Please select use data】')
[file_name,file_path] = uigetfile(file_dir, '*.mat');
load([file_path file_name]);

%条件別に処理書いていく
if conduct_lp == 0
    %hp -> rect -> lp -> 切り出し -> 平均 の　切り出し -> 平均の部分をやっていく(plotしていく)
    pattern = digitsPattern;
    num_index = extract(file_name,pattern);
    pre_lp_Hz = str2double(cell2mat((num_index(end))));
    NMF_data_dir = [temp_NMF_data_dir '/pre_lpHz_' num2str(pre_lp_Hz)];
    if not(exist(NMF_data_dir))
        mkdir(NMF_data_dir)
    end
    % plot figure and save EMG data for NMF
    input_data = eval(['around_' focus_timing '_data']);
    %入力引数を構造体にまとめる
    var_name = {'EMGs','input_data','SR','NMF_data_dir','focus_timing','pre_frame','post_frame','line_wide'};
    for ii = 1:length(var_name)
        eval(['input_var.' var_name{ii}  ' = ' var_name{ii} ';']); 
    end
    [mean_data,std_data] = figure_package(input_var);
    %save_data
    save([data_save_dir '/' 'ave_' focus_timing '_pre-' num2str(pre_frame) '_post_' num2str(post_frame) '_lpHz_' num2str(pre_lp_Hz) '.mat'],'mean_data','std_data')
    %save_picture
    saveas(gcf,[picture_save_dir '/' 'ave_' focus_timing '_pre-' num2str(pre_frame) '_post_' num2str(post_frame) '_lpHz_' num2str(pre_lp_Hz) '.png'])
    close all;
elseif conduct_lp == 1
    %hp -> rect -> 切り出し -> (平均 -> lp) or (lp -> 平均) の()部分をやっていく
    NMF_data_dir = [temp_NMF_data_dir '/post_lpHz_' num2str(lp_Hz) '(' processing_procedure ')'];
    if not(exist(NMF_data_dir))
        mkdir(NMF_data_dir)
    end
    %追加の処理(lpと平均)
    switch processing_procedure
        case 'mean_first'
            %平均を求めていく
            mean_data = zeros(length(EMGs),pre_frame + post_frame);
            for ii = 1:length(EMGs)
                ref_data = eval(['around_' focus_timing '_data{' num2str(ii) '}']);
                EMG_mean = mean(ref_data);
                mean_data(ii,:) = EMG_mean;
            end
            %平滑化のためのデータ作成
            [B,A] = butter(6, (lp_Hz .* 2) ./ SR, 'low');
            
            input_data = mean_data;
            %merge use_data as struct type
            var_name = {'EMGs','SR','input_data','NMF_data_dir','focus_timing','pre_frame','post_frame','line_wide'};
            for ii = 1:length(var_name)
                eval(['input_var.' var_name{ii}  ' = ' var_name{ii} ';']); 
            end
            
            %analyze & save data
            [~,~] = figure_package(input_var);

            %図の保存
            saveas(gcf,[picture_save_dir '/' focus_timing '_pre-' num2str(pre_frame) '_post_' num2str(post_frame) '_lpHz_' num2str(lp_Hz) '(post_lp(' processing_procedure ')).png'])
            close all;
        case 'lp_first'
            %lpをかけて平滑化
            [B,A] = butter(6, (lp_Hz .* 2) ./ SR, 'low');
            for ii = 1:length(EMGs) 
                ref_data = eval(['around_' focus_timing '_data{' num2str(ii) '}']);
                if ii == 1
                    [trial_num, ~] = size(ref_data);
                    %stackデータを格納する変数の構造を作成
                    stack_EMG = cell(length(EMGs),1);
                    for jj = 1:length(EMGs)
                        stack_EMG{jj} = zeros(trial_num,pre_frame + post_frame);
                    end
                end
                for jj = 1:trial_num
                    temp_EMG = ref_data(jj,:);
                    temp_EMG = filtfilt(B,A,temp_EMG);
                    stack_EMG{ii}(jj,:) = temp_EMG;
                end
            end
            input_data = stack_EMG;
            %merge use_data as struct type
            var_name = {'EMGs','SR','input_data','NMF_data_dir','focus_timing','pre_frame','post_frame','line_wide'};
            for ii = 1:length(var_name)
                eval(['input_var.' var_name{ii}  ' = ' var_name{ii} ';']); 
            end
            % stack図の作成とファイルの保存
            input_var.target_figure = figure('Position', [100 100 1280 720]);
            for ii = 1:length(EMGs)
                subplot(4,4,ii)
                hold on
                for jj = 1:trial_num
                    plot(stack_EMG{ii}(jj,:));
                end
                input_var.target_figure =  figure_decoration(ii,input_var);
                hold off
            end
            %save figure & data
            saveas(gcf,[picture_save_dir '/' focus_timing '_pre-' num2str(pre_frame) '_post_' num2str(post_frame) '_lpHz_' num2str(lp_Hz) '(lp_first)_stack.png'])
            save([data_save_dir '/' focus_timing '_pre-' num2str(pre_frame) '_post_' num2str(post_frame) '_lpHz_' num2str(lp_Hz) '(lp_first)_stackData.mat'],'stack_EMG')
            close all;
            
            
            %plot averarge figure & save EMG data for NMF
            [~,~] =  figure_package(input_var);
            %図の保存(データは、NMF用の個別出力のところで既に保存済みなので、保存しなくていい)
            saveas(gcf,[picture_save_dir '/' 'ave_' focus_timing '_pre-' num2str(pre_frame) '_post_' num2str(post_frame) '_lpHz_' num2str(lp_Hz) '(lp_first).png'])
            close all;
    end
end

%% define function
%図の作成と、NMF用データの作成 & 保存
function [mean_data,std_data] = figure_package(varargin)
input_var = varargin{1};
%処理の記述
mean_data = zeros(length(input_var.EMGs),input_var.pre_frame + input_var.post_frame);
std_data = zeros(length(input_var.EMGs),input_var.pre_frame + input_var.post_frame);
input_var.target_figure = figure('Position', [100 100 1280 720]);
for ii = 1:length(input_var.EMGs)   
    try
        ref_data = input_var.input_data{ii};
        input_var.EMG_mean = mean(ref_data);
        input_var.max_value = max(input_var.EMG_mean);
        input_var.EMG_std = std(ref_data);
    catch
        ref_data = input_var.input_data(ii,:);
        input_var.max_value = max(ref_data);
    end
    subplot(4,4,ii)
    hold on;
    try
        plot(input_var.EMG_mean,'r','LineWidth',2);
    catch
        plot(ref_data,'r','LineWidth',2);
    end
    input_var.target_figure =  figure_decoration(ii,input_var);
    hold off
    %データを収納する
    try
        mean_data(ii,:) = input_var.EMG_mean;
        std_data(ii,:) = input_var.EMG_std;
    catch
    end
    %NMF用に、個々の筋電データをファイルに保存していく
    Name = cell2mat(input_var.EMGs(ii,1));
    Class = 'continuous channel';
    SampleRate = input_var.SR;
    try
        Data = input_var.EMG_mean;
    catch
        Data = ref_data;
    end
    Unit = 'uV';
    save([input_var.NMF_data_dir '/' cell2mat(input_var.EMGs(ii,1)) '(uV)_' input_var.focus_timing '_pre-' num2str(input_var.pre_frame) '_post-' num2str(input_var.post_frame) '.mat'], 'Name', 'Class', 'SampleRate', 'Data', 'Unit');
end
end

%↓図の装飾のための関数
function [temp] = figure_decoration(ii,input_var)
figure(input_var.target_figure)
grid on;
title(input_var.EMGs{ii,1},'FontSize',22);

try
    ar1=area(transpose([input_var.EMG_mean-input_var.EMG_std;input_var.EMG_std+input_var.EMG_std]));
    set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r')
    set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') 
catch
end

try
    ylim([0 round(input_var.max_value + 10)]);
catch
end

xline(input_var.pre_frame,'red','Color',[186 85 211]/255,'LineWidth',input_var.line_wide);
temp = input_var.target_figure;
end