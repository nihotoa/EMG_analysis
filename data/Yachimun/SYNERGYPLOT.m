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
pre: (change_name.m) or makeEMGNMF_oya.m
post: dispNMF_W (path: EMG_analysis/data/Yachimun/new_nmf_result/dispNMF_W.m)


[Improvement points(Japanaese)]
%めちゃめちゃ冗長
階層移りすぎ,変える必要のあるパラメータが，中で使う関数に散らばりすぎ．
ロードする変数が指定されていない．筋肉名や筋肉の数を自分で指定する必要がある
具体的な変更点:
emg_groupを定義しないで, loadしたシナジーの情報から定義するように変更する
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set param
monkeyname = 'F'; % initials that each monkey has uniquery
emg_group = 4;
plk = 3; % how to save data (don't need to change)
synergy_num_list = [3, 4]; % which synergy number of synergies to plot
type = '_filtNO5';% _filt5 means'both' direction filtering used 'filtfilt' function (don't need to change)

     
%% code section
% get the list of day
disp('Please select all date folder you want to analyze')
InputDirs   = uiselect(dirdir(fullfile(pwd, 'new_nmf_result')),1,'??????????Experiments???I??????????????');
days = get_days(InputDirs);

for ii = 1:length(days)
    fold_name = [monkeyname sprintf('%d',days(ii))];
    synergyplot_func(fold_name, emg_group, plk, synergy_num_list);
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
