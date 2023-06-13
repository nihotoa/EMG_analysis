%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by : Naohito Ota
Last modification : 2023.05.17
【function】
・筋シナジーに使用する筋電が適切かどうかを判断するためのコード
・y軸の閾値は変数でマニュアル設定にしているので注意
【改善点】
・ループできない(日付改装の名前だけ変更してループさせるようにする)
・直流成分を除去する(基線の位置が0になるようにオフセットする)
【procedure】
・untitled.m
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
exp_days = [20230512];
trial_num = 3;
% y_max = 15;
start_num = 39;
EMGs{1,1} = 'EDC-A';
EMGs{2,1} = 'EDC-B';
EMGs{3,1} = 'ED23';
EMGs{4,1} = 'ED45';
EMGs{5,1} = 'ECR';
EMGs{6,1} = 'ECU';
EMGs{7,1} = 'BRD';
EMGs{8,1} = 'EPL-B';
EMGs{9,1} = 'FDS-A';
EMGs{10,1} = 'FDS-B';
EMGs{11,1} = 'FDP';
EMGs{12,1} = 'FCR' ;
EMGs{13,1} = 'FCU';
EMGs{14,1} = 'FPL';
EMGs{15,1} = 'Biceps';
EMGs{16,1} = 'Triceps';

%% code section
success_timing_path = [num2str(exp_days) '/EMG_data/Data'];
picture_path = [num2str(exp_days) '/EMG_data/Picture'];
initial_dir = [pwd '/' num2str(exp_days)];
disp('【Please select _filted.mat(nmf_result -> Ni~_standard ->)】')
[EMG_file_names, EMG_fold_path] = uigetfile('*_filtered.mat',initial_dir,'MultiSelect','on');

load([success_timing_path '/' 'success_timing.mat'], 'success_timing')


[row,~] = size(success_timing);
switch row
    case 5
        start_timing = success_timing(1, start_num:(start_num+trial_num)-1);
        relative_start_timing = (start_timing - start_timing(1))+1;
        end_timing = success_timing(4, start_num:(start_num+trial_num)-1);
        relative_end_timing = end_timing - start_timing(1);
    case 2
        start_timing = success_timing(1, start_num:(start_num+trial_num)-1);
        relative_start_timing = (start_timing - start_timing(1))+1;
        end_timing = success_timing(2, start_num:(start_num+trial_num)-1);
        relative_end_timing = end_timing - start_timing(1);
end
sample_num = (end_timing(end) - start_timing(1))+1;
x = linspace(0,1, sample_num);
% plot figure
figure('Position',[100 100 1280 720]);
for ii = 1:length(EMG_file_names)
    load([EMG_fold_path EMG_file_names{ii}], 'Data', 'Name')
    sample_num = (end_timing(end) - start_timing(1))+1;
    index = find(strcmp(EMGs, Name));
    subplot(4,4,index)
    hold on;
    plot(x, Data(1,start_timing(1):end_timing(end)), 'LineWidth', 1.2)
    title(Name,'FontSize',18)
    grid on;
    xline(x(relative_start_timing(1:end)),'Color','r','LineWidth',1.1)
    xline(x(relative_end_timing(1:end)),'Color','g','LineWidth',1.1)
    if exist('y_max')
        ylim([0 y_max])
    end
end

if exist('y_max')
    saveas(gcf, [picture_path '/' 'filtered_EMG(' num2str(trial_num) 'trial)' '.png'])
    saveas(gcf, [picture_path '/' 'filtered_EMG(' num2str(trial_num) 'trial)' '.fig'])
else
    saveas(gcf, [picture_path '/' 'filtered_EMG(' num2str(trial_num) 'trial)_noAlignedAmp' '.png'])
    saveas(gcf, [picture_path '/' 'filtered_EMG(' num2str(trial_num) 'trial)_noAlignedAmp' '.fig'])
end
close all;
