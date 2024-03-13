%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{

[your operation]
1. Go to the directory named 'new_nmf_result(directory where this file exists)''
2. Please change parameters

[role of this code]
・Output a single figure of the spatial pattern of each synergy for all dates selected by the UI operation.
・Store data on the mapping of each synergy on each date and on the spatial pattern of synergies (synergy W) summarised.

[Saved data location]
    As for figure:
        Yachimun/new_nmf_result/syn_figures/F170516to170526_4/      (if you selected 4days from 170516 to 170526)

    As for synergy order data:
        Yachimun/new_nmf_result/order_tim_list/F170516to170526_47/     (if you selected 4days from 170516 to 170526)

    As for synergy W data (for anova):
        Yachimun/new_nmf_result/W_synergy_data

    As for synergy W data:
        Yachimun/new_nmf_result/spatial_synergy_data/dist-dist

[procedure]
pre: SYNERGYPLOT.m
post: MakeDataForPlot_H_utb(EMG_analysis/data/Yachimun/new_nmf_result/MakeDataForPlot_H_utb)

[Improvement points(Japanaese)]
・シナジーのソートの部分を関数に直す
・preとpostのシナジーの対応づけを自動で行うように変更する
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

%% set param
syn_num = 4; % number of synergy you want to analyze
save_WDaySynergy = 1;% Whether to save synergy W (to be used for ANOVA)
save_data = 1; % Whether to store data on synergy orders in 'order_tim_list' folder (should basically be set to 1).
save_fig = 1; % Whether to save the plotted synergy W figure
synergy_order = [4, 2, 1, 3]; % Array for mapping synergies between 'pre' and 'post'
synergy_combination = 'dist-dist'; % dist-dist/prox-dist/all etc..

%% code section

% get the list of day
disp('Please select all date folder you want to analyze')
InputDirs   = uiselect(dirdir(pwd), 1, 'Please select all date folder you want to analyze');
days = get_days(InputDirs);

% get prefix of selected folder name (to be used for newly created file & folder name)
split_str = regexp(InputDirs{1}, '\d+', 'split');
monkeyname = split_str{1};

% do not change(Pre dates in Yachimun's experiments)
pre_days = [...
                 170516; ...
                 170517; ...
                 170524; ...
                 170526; ...
                 ];

% determine 'term_group'
if any(ismember(days, pre_days))
    term_group = 'pre';
else
    term_group = 'post';
end

%% Get the name of the EMG used for the synergy analysis
first_date_fold_name = InputDirs{1};

% Get the path of the file that has name information of EMG used for muscle synergy analysis
first_date_file_path = fullfile(pwd, first_date_fold_name, [first_date_fold_name '.mat']);

% get name information of EMG used for muscle synergy analysis
load(first_date_file_path, 'TargetName');
EMGs = get_EMG_name(TargetName);
EMG_num = length(EMGs);

%% load spatial syenergy data & sort synergies

% Create an empty array to store synergy W values
Wx =  cell(1,length(days));

% Read the daily synergy W values & create an array.
for i = 1:length(days)
    % Load the W synergy data created in the previous phase
    synergy_W_file_path = fullfile(pwd, [monkeyname mat2str(days(i)) '_standard'], [monkeyname mat2str(days(i)) '_syn_result_' sprintf('%d',EMG_num)], [monkeyname mat2str(days(i)) '_W'], [monkeyname mat2str(days(i)) '_aveW_' sprintf('%d',syn_num)]);
    load(synergy_W_file_path, 'aveW');
    Wx{i} = aveW;
end

%% Reorder the synergies to match the synergies on the first day.
Wcom = zeros(EMG_num,syn_num);
Wt = Wx;
Wxs = Wx;
aveWt = Wt{1};
m = zeros(length(days),syn_num);
k_arr = ones(syn_num, length(days));
for i =  1:syn_num
    k_arr(i,1) = i; %初日
    for j = 2:length(days)
        for l = 1:syn_num
            Wcom(:,l) = (Wx{1,1}(:,i) - Wx{1,j}(:,l)).^ 2; % Square the difference between synergy I on day 1 and synergy l on day j
            m(j,l) = sum(Wcom(:,l)); % Add the values together (the smallest one should be the corresponding synergy).
        end
        Wt{1,j}(:,i) = Wx{1,j}(:,find(m(j,:)==min(m(j,:))));
        Wx{1,j}(:,find(m(j,:)==min(m(j,:)))) = ones(EMG_num,1).*1000;
        k_arr(i,j) = find(m(j,:)==min(m(j,:)));
    end
end
Walt = cell2mat(Wt);
Wall = Walt;
for i = 1:syn_num
    for j=1:length(days)
        Wall(:,(i-1)*length(days)+j) = Walt(:,(j-1)*syn_num+i);
    end
end

%% plot figure(Synergy_W)

% Organize the information needed for plot.
x = categorical(EMGs');
muscle_name = x; 
zeroBar = zeros(EMG_num,1);

% make folder to save figures
save_figure_folder_path = fullfile(pwd, 'syn_figures', [monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
if not(exist(save_figure_folder_path))
    mkdir(fullfile(save_figure_folder_path))
end

for i=1:syn_num 
    f1 = figure('Position',[300,250*i,750,400]);
    hold on;
    
    % create plotted_W
    plotted_W = nan(EMG_num, length(days));
    for jj = 1:length(days)
        switch term_group
            case 'pre'
                plotted_W(:, jj) = Wt{jj}(:, i);
            case 'post'
                plotted_W(:, jj) = Wt{jj}(:, synergy_order(i));
        end
    end
    bar(x,[zeroBar plotted_W],'b','EdgeColor','none');

    % decoration
    ylim([0 2.5]);
    a = gca;
    a.FontSize = 20;
    a.FontWeight = 'bold';
    a.FontName = 'Arial';
    if save_fig == 1
        figure1_name = ['W' sprintf('%d',syn_num) '_' mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i)];
        saveas(f1, fullfile(save_figure_folder_path, [figure1_name '.fig']));
        saveas(f1, fullfile(save_figure_folder_path, [figure1_name '.png']));
    end
end
close all;

% make directory to save synergy_W data & save data.
if save_WDaySynergy == 1
    if not(exist('W_synergy_data'))
        mkdir('W_synergy_data')
    end

    % Changing the structure of an array
    WDaySynergy = cell(1,syn_num);
    for ii = 1:syn_num
        for jj = 1:length(days)
            WDaySynergy{ii}(:, jj) = Wt{jj}(:, ii);
        end
    end

    % match the order of synergies in 'pre'
    if strcmp(term_group, 'post')
        temp = cell(1,4);
        for ii = 1:syn_num
            temp{ii} = WDaySynergy{synergy_order(ii)};
        end
        WDaySynergy = temp;
    end

    % save_data
    data_file_name = [monkeyname num2str(days(1)) 'to' num2str(days(end)) '_' num2str(length(days)) '(' term_group ')'];
    save(fullfile(pwd, 'W_synergy_data', data_file_name), 'WDaySynergy', 'x');
end

%% Plot the average value of synergy_W for all selected dates

% calcrate the average of synergy W
for j=1:length(days)
    aveWt = (aveWt.*(j-1) + Wt{j})./j;
end

% plot figure of averarge synergyW
errt = zeros(EMG_num,syn_num);
for i=1:syn_num
    f2 = figure('Position',[900,250*i,750,400]);

    % Calculate standard deviation
    errt(:,i) = std(Wall(:,(i-1)*length(days)+1:i*length(days)),1,2)./sqrt(length(days));

    % plot
    bar(x,aveWt(:,i));
    hold on;

    % decoration
    e1 =errorbar(x, aveWt(:,i), errt(:,i), 'MarkerSize',1);
    ylim([-1 4])
    e1.Color = 'r';
    e1.LineWidth = 2;
    e1.LineStyle = 'none';
    ylim([0 2.5]);
    a = gca;
    a.FontSize = 20;
    a.FontWeight = 'bold';
    a.FontName = 'Arial';
    
    % save figure
    if save_fig == 1
        figure_average_name = ['aveW' sprintf('%d',syn_num) '_' mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i)];
        saveas(f2, fullfile(save_figure_folder_path, [figure_average_name '.fig']));
        saveas(f2, fullfile(save_figure_folder_path, [figure_average_name '.png']));
    end
end
close all;
%% save order for next phase analysis

if save_data == 1
    % save data of synergyW
    save_W_data_dir = fullfile(pwd, 'spatial_synergy_data', synergy_combination);
    if not(exist(save_W_data_dir))
        mkdir(save_W_data_dir)
    end
    save_W_data_file_name = [term_group '(' num2str(length(days)) 'days)_data.mat'];
    save(fullfile(save_W_data_dir, save_W_data_file_name),"Wt","muscle_name","days")

    % save data which is related to the order of synergy
    save_order_data_dir = fullfile(pwd, 'order_tim_list',  [monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
    if not(exist(save_order_data_dir))
        mkdir(save_order_data_dir);
    end

    comment = 'this data were made for aveH plot';
    save_order_data_file_name = [monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_' sprintf('%d',syn_num) '.mat'];
    save(fullfile(save_order_data_dir, save_order_data_file_name), 'k_arr','comment', 'days', 'EMG_num', 'syn_num');
end

