function plotSynergyAll_uchida(fold_name, pcNum,nmf_fold_name, each_plot, save_setting)
%% set para & get nmf result
task = 'standard';
fold_path = fullfile(pwd, nmf_fold_name, [fold_name '_' task]);

% get the file details which is related to synergy analysis
synergy_files = get_synergy_files_name(fold_path, fold_name) ;

% load file
if isempty(synergy_files)
    error('synergy_files are not found. Please run "makeEMFNMF_btcOya.m" first');
    return
else
    for ii = 1:length(synergy_files)
        load(fullfile(fold_path, synergy_files(ii).name));
    end
end

% get the number of EMG and muscle name
EMG_num = length(TargetName);
EMGs = get_EMG_name(TargetName);

% get parameters
[~, kf] = size(test.W);
save_fig_W = save_setting.save_fig_W;
save_fig_H = save_setting.save_fig_H;
save_fig_r2 = save_setting.save_fig_r2; 
save_data = save_setting.save_data;

%% sort synergies extracted from each test data and group them by synergies of similar characteristics
cell_selD = cell(1,kf);
cell_selH = cell(1,kf);
cell_selD{1,1} = test.W{pcNum,1};
cell_selH{1,1} = test.H{pcNum,1};
comD = zeros(EMG_num, pcNum);
selD = zeros(EMG_num,pcNum);
selH = zeros(pcNum,length(test.H{pcNum,1}(1,:)));
m = zeros(1,pcNum);
k = zeros(kf-1,pcNum);
for n = 1:kf-1%make no doubled!!!!!!
    for i = 1:pcNum
        for j = 1:pcNum
            comD(:,j) = test.W{pcNum,1}(:,i);
        end
        comD_state = abs(comD - test.W{pcNum,n+1});
        for j = 1:pcNum
            m(1,j) = sum(comD_state(:,j)); 
            for l=1:pcNum              
                if j == k(n,l)
                    m(1,j) = 1000000;
                end
            end
        end
        min_ar = find( m(1,:) == min(m));
        k(n,i) = min_ar;
        selD(:,i) = test.W{pcNum,n+1}(:,min_ar);
        selH(i,:) = test.H{pcNum,n+1}(min_ar,:);
    end
    cell_selD{1,n+1} = selD;
    cell_selH{1,n+1} = selH;
end

%% plot W (spatial pattern)
figure('Position',[0,1000,800,1300]);
x = categorical(EMGs');
zeroBar = zeros(EMG_num,1);
aveW = zeros(EMG_num,pcNum);
std_value = cell(1, pcNum);

% subplot for each synergy
for i = 1:pcNum
    subplot(pcNum,1,i); 

    % organize value to be plotted
    plotted_W = nan(EMG_num, kf);
    for jj = 1:kf
        plotted_W(:, jj) = cell_selD{jj}(:, i);
    end
    
    % barplot
    bar(x,[zeroBar plotted_W]);

    % calc the mean value of test data
    aveW(:, i) = mean(plotted_W, 2);
    std_value{1,i} = std(plotted_W, 0, 2);

    % decoration of figure
    ylim([0 3.5]);
    title([fold_name ' W pcNum = ' sprintf('%d',pcNum)]);
end

% set the path to save data & figure
save_fold = fullfile(fold_path, [fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
if not(exist(save_fold))
    mkdir(fullfile(fold_path, save_fold))
end

% save_data
if save_data == 1
    save_fold_W = fullfile(save_fold, [fold_name '_W']);
    if not(exist(save_fold_W))
        mkdir(save_fold_W)
    end
    comment = 'this data will be used for dispW';
    save(fullfile(save_fold_W, [fold_name '_aveW_' sprintf('%d',pcNum) '.mat']), 'aveW','k','pcNum','fold_name','comment');
end

% save figure
if save_fig_W ==1
    saveas(gcf,fullfile(save_fold_W, [fold_name ' W pcNum = ' sprintf('%d',pcNum) '.png']));
end
close all;

%% plot ave_W
figure('Position',[0,1000,800,1700]);
for i = 1:pcNum
    subplot(pcNum,1,i); 

    % barplot
    bar(x,aveW(:,i))
    hold on

    % add error bar
    er = errorbar(x,aveW(:,i),std_value{i},std_value{i});
    er.Color = [0 0 0];
    er.LineStyle = 'none';

    % decoration
    ylim([0 3.5]);
    title([fold_name ' aveW pcNum = ' sprintf('%d',pcNum)]);
end

% save figure
if save_fig_W ==1
    saveas(gcf,fullfile(save_fold_W, [fold_name ' aveW pcNum = ' sprintf('%d',pcNum) '.png']));
end
close all;

if each_plot == 1
    for i = 1:pcNum
        figure('Position',[0,1000,600,400]);

        % bar plot
        bar(x,aveW(:,i))
        hold on

        % add error bar
        er = errorbar(x,aveW(:,i),std_value{i},std_value{i});
        er.Color = [0 0 0];
        er.LineStyle = 'none';

        % decoration
        ylim([0 3.5]);
        title([fold_name ' aveW pcNum = ' sprintf('%d',pcNum) ' synergy' num2str(i)]);

        % save figure
        if save_fig_W ==1
            saveas(gcf,fullfile(save_fold_W, [fold_name ' aveW pcNum = ' sprintf('%d',pcNum) '_synergy' num2str(i) '.png']));
        end
        close all;
    end
end

%% plot H (temporal pattern of synergy)
% load timing data (which is created by )
easyData_path = fullfile(pwd, 'easyData', [fold_name '_' task]);
load(fullfile(easyData_path, [fold_name '_EasyData.mat']), 'Tp', 'SampleRate');

% 
SUC_Timing_A = floor(Tp.*(100/SampleRate));
SUC_num = length(Tp(:,1))-1;

% concatenate all test data to create a temporal pattern of synergy in the entire recording interval (as All_H)
len_kf = length(test.H{1,1}(1,:));
All_H = zeros(pcNum,max(len_kf .* kf, SUC_Timing_A(end,end)));
for i = 1:pcNum
    for j = 1:kf
        All_H(i,((j-1) * len_kf + 1):(j * len_kf)) = cell_selH{1,j}(i,:);
    end
end

TIMEr = [-100 100]; %range of cutting out
TIMEl = abs(TIMEr(1))+abs(TIMEr(2))+1; % number of samples to be cut out
aveH = zeros(pcNum, TIMEl);
pullData = zeros(SUC_num, TIMEl);

figure('Position',[900,1000,800,1300]);

% each synergy
for ii=1:pcNum
    % each trial
   for jj=1:SUC_num-1
      subplot(pcNum,1,ii);

      % cut out temporal data for 'lever1 off' timng +-1 [sec] for each trial
      pullData(jj, :) = All_H(ii, SUC_Timing_A(jj,3)+TIMEr(1):SUC_Timing_A(jj, 3)+TIMEr(2));

       % plot each trial temporal data (around 'lever1 off' timing)
      plot(pullData(jj,:));
        
      % update averarge value up to the current trial
      aveH(ii, :) = ((aveH(ii, :) .* (jj-1)) + pullData(jj,:)) ./ jj ;

      % decoration
      ylim([0 2]);
      hold on;
   end
end

%% save figure & data about H (temporal pattern of synergy)
if save_data == 1
    save_fold_H = fullfile(save_fold, [fold_name '_H']);
    if not(exist(save_fold_H))
        mkdir([fold_name '_H'])
    end
    comment = 'this data will be used for dispH';
    save(fullfile(save_fold_H, [fold_name '_aveH3_' sprintf('%d',pcNum) '.mat']), 'aveH','k','pcNum','fold_name','comment');
end

% save figure
if save_fig_H ==1
    saveas(gcf, fullfile(save_fold_H, [fold_name ' HS_2 pcNum = ' sprintf('%d',pcNum) '.fig']));
    saveas(gcf, fullfile(save_fold_H, [fold_name ' HS_2 pcNum = ' sprintf('%d',pcNum) '.png']));
end
close all;

% plot trial average value of temporal pattern for each synergy &
 figure('Position',[900,1000,800,1300]);
 for j=1:pcNum
     subplot(pcNum,1,j);
     plot(aveH(j,:), 'r');
     ylim([0 2]);
     hold on;
 end

 % save figure (averarge of temporal pattern)
 if save_fig_H ==1
     saveas(gcf,fullfile(save_fold_H  , [fold_name ' H3_ave pcNum = ' sprintf('%d',pcNum) '.fig']));
     saveas(gcf,fullfile(save_fold_H  , [fold_name ' H3_ave pcNum = ' sprintf('%d',pcNum) '.png']));
 end
 close all;

%% plot & save VAF figure
figure;
% load synergy file (for the one containing r2 information)
file_sizes = [synergy_files.bytes];
[~, min_idx] = min(file_sizes);
load(fullfile(fold_path, fullfile(synergy_files(min_idx).name)));

% plot VAF
for i= 1:kf
    plot(test.r2(:,i));
    ylim([0 1]);
    hold on;
    plot(shuffle.r2(:,i),'Color',[0,0,0]);
    hold on
end

% draw a line indicating the threshold
plot([0 EMG_num + 1],[0.8 0.8]);
title([fold_name ' R^2']);

% save VAF figure
if save_fig_r2 ==1
    save_fold_VAF = fullfile(save_fold, [fold_name '_r2']);
    if not(exist(save_fold_VAF))
        mkdir([fold_name '_r2'])
    end
    saveas(gcf, fullfile(save_fold_VAF, [fold_name ' R2 pcNum = ' sprintf('%d',pcNum) '.png']));
    close all;
end
end

