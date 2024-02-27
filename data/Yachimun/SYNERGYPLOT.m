%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
[your operation]
1. Go to the directory named monkey name (ex.) if you want to analyze Yachimun's data, please go to 'EMG_analysis/data/Yachimun'
2. Please change parameters

[role of this code]
Plot muscle synergies extracted from EMG for each exoerimental day

[Saved data location]
location: Directory youhave chosen as save folder (A dialog box will pop up during the process, so please select a save folder)
file name: 

[procedure]
pre: makeEMGNMF_btcOya.m
post: dispNMF_W (path:
EMG_analysis/data/Yachimun/new_nmf_result/dispNMF_W.m), (This file is not yet fully described)

[caution!!]
In order to complete this function, in addtion to the analysis flow of synergy analysis, it is necessary to finish the flow up to runningEasyfunc.m of EMG analysis

[Improvement points(Japanaese)]
注意点: タイミングデータの取得のために, EMG_analysisのフローをrunnningEasyfuncまで行う必要がある
disp_NMFの説明が十分じゃないことを, procedureの中で書いているので, 編集したらその部分を消す
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
monkeyname = 'F'; % initials that each monkey has uniquery
synergy_num_list = [4]; % which synergy number of synergies to plot
type = '_filtNO5';% _filt5 means'both' direction filtering used 'filtfilt' function (don't need to change)
nmf_fold_name = 'new_nmf_result';
each_plot = 0; % whether you want to plot spatial_pattern figure for each synergy

% save_setting
save_setting.save_fig_W = 1; % whether you want to save synergy
save_setting.save_fig_H = 1;
save_setting.save_fig_r2 = 1; 
save_setting.save_data = 1;

     
%% code section
% get the list of day
disp('Please select all date folder you want to analyze')
InputDirs   = uiselect(dirdir(fullfile(pwd, 'new_nmf_result')), 1, 'Please select all date folder you want to analyze');
days = get_days(InputDirs);

% loop for each experimental day
for ii = 1:length(days)
    fold_name = [monkeyname sprintf('%d',days(ii))];

    % loop for each number of synergies 
    for jj = 1:length(synergy_num_list)
        synergy_num = synergy_num_list(jj);
        plotSynergyAll_uchida(fold_name, synergy_num, nmf_fold_name, each_plot, save_setting);
    end
    close all
end

%% set local function
function [days] = get_days(InputDirs)
%{
explanation of this func:
Extract the numerical part from each element of InputDirs(cell array) and create a list of double array
%}

days = zeros(length(InputDirs), 1);
for ii = 1:length(InputDirs)
    ref_element = InputDirs{ii};
    number_part = regexp(ref_element, '\d+', 'match');
    day = str2double(number_part{1});
    days(ii) = day;
end
end
