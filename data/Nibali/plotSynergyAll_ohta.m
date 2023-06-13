%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
全体データから筋シナジーを解析するときはこっちを使う
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotSynergyAll_ohta(fold_name,emg_group,pcNum,plk,monkey_name,exp_day,trim_package)
%% set para & get nmf result
% fold_name = 'Wa180928';
% 
% emg_group = 1;
task = 'standard';

switch emg_group
    case 1
        EMG_num = 16;
        EMGs = {'Biceps','BRD','ECR','ECU','ED23','ED45','EDC-A','EDC-B','EPL','FCR','FCU','FDP','FDS-A','FDS-B','FPL','Triceps'};
end

save_fold = 'nmf_result';
cd([num2str(exp_day) '/' save_fold])
%cd([fold_name '_' task])
folder_list = dir;
for ii = 1:length(folder_list)
    if contains(folder_list(ii).name,'allData')
        next_dir = folder_list(ii).name;
        break
    end
end
% % everyday nomalization
% load([fold_name '_' task '_' sprintf('%02d',EMG_num) '.mat']);
% load([fold_name '_' task '_' sprintf('%02d',EMG_num) '_nmf.mat']);
cd(next_dir);
loaded_file = dir('*.mat');
for ii = 1:length(loaded_file)
    load(loaded_file(ii).name)
end


% fixed nomalization
% load([fold_name '_' sprintf('%02d',EMG_num) 'fix.mat']);
% load([fold_name '_' sprintf('%02d',EMG_num) 'fix_nmf.mat']);

% pcNum = 3;
kf = 4; 
freq = 100;
filt_on = 0;
each_plot = 0;

save_fig_W = 1;
save_fig_H = 1;
save_fig_VAF = 1;
save_fig_r2 = 1; 

save_data = 1;
%% make W&T good by W 2
cell_selD = cell(1,kf);
cell_selH = cell(1,kf);
cell_selD{1,1} = test.W{pcNum,1};
cell_selH{1,1} = test.H{pcNum,1};
comD = zeros(EMG_num, pcNum);
comD_state = zeros(EMG_num, pcNum);
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
%% plot W
f1 = figure('Position',[0,1000,800,1300]);
x = categorical(EMGs');
aveW = zeros(EMG_num,pcNum);
for i = 1:pcNum
    subplot(pcNum,1,i); 
    bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i) cell_selD{1,3}(:,i) cell_selD{1,4}(:,i)]);
    aveW(:,i) = (cell_selD{1,1}(:,i) + cell_selD{1,2}(:,i) + cell_selD{1,3}(:,i) + cell_selD{1,4}(:,i)) ./ 4;
    std_value{1,i} = std([cell_selD{1,1}(:,i) cell_selD{1,2}(:,i) cell_selD{1,3}(:,i) cell_selD{1,4}(:,i)],0,2);
%     bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i)]);
    ylim([0 3.5]);
    title([fold_name ' W pcNum = ' sprintf('%d',pcNum)]);
end
if save_data == 1
    cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
    cd ([fold_name '_W'])
    comment = 'this data will be used for dispW';
    save([fold_name '_aveW_' sprintf('%d',pcNum) '.mat'], 'aveW','k','pcNum','fold_name','comment');
    cd ../../
end
if save_fig_W ==1
    cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
    cd ([fold_name '_W'])
    saveas(gcf,[fold_name ' W pcNum = ' sprintf('%d',pcNum) '.png']);
    cd ../
    cd ../
end
close all;
%plot ave_W
f1 = figure('Position',[0,1000,800,1700]);
for i = 1:pcNum
    subplot(pcNum,1,i); 
     bar(x,aveW(:,i))
     hold on
%     bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i)]);
    er = errorbar(x,aveW(:,i),std_value{i},std_value{i});
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    ylim([0 3.5]);
    title([fold_name ' aveW pcNum = ' sprintf('%d',pcNum)]);
end
%↓図の保存(Wの平均)
if save_fig_W ==1
    cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
    cd ([fold_name '_W'])
    saveas(gcf,[fold_name ' aveW pcNum = ' sprintf('%d',pcNum) '.png']);
    close all;
    cd ../
    cd ../
end
close all;
if each_plot == 1
    for i = 1:pcNum
         f1 = figure('Position',[0,1000,600,400]);
         bar(x,aveW(:,i))
         hold on
    %     bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i)]);
        er = errorbar(x,aveW(:,i),std_value{i},std_value{i});
        er.Color = [0 0 0];
        er.LineStyle = 'none';
        ylim([0 3.5]);
        title([fold_name ' aveW pcNum = ' sprintf('%d',pcNum) ' synergy' num2str(i)]);
        %↓図の保存(Wの平均)
        if save_fig_W ==1
            cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
            cd ([fold_name '_W'])
            saveas(gcf,[fold_name ' aveW pcNum = ' sprintf('%d',pcNum) '_synergy' num2str(i) '.png']);
            close all;
            cd ../
            cd ../
        end
        close all;
    end
end
%% plot T
cd ../../;
load('EMG_Data/Data/success_timing','success_timing');
cd([save_fold '/' next_dir])

% SUC_Timing_A = floor(Tp.*(100/SampleRate));
% SUC_num = length(Tp(:,1))-1;
% len_kf = length(test.H{1,1}(1,:));
% All_T = zeros(pcNum,max(len_kf .* kf,SUC_Timing_A(end,end)));
% for i = 1:pcNum
%     for j = 1:kf
%         All_T(i,((j-1) * len_kf + 1):(j * len_kf)) = cell_selH{1,j}(i,:);
%     end
% end
All_T = cell2mat(cell_selH);
[stack_figure,average_figure,trimmed_synergy] = trim_func(All_T, success_timing,pcNum,trim_package);
% TIMEr = [-100 100];
% TIMEl = abs(TIMEr(1))+abs(TIMEr(2))+1;
% ave = zeros(pcNum,TIMEl);
% pullData = zeros(SUC_num,TIMEl);
% sec = zeros(3,1);
% f2 = figure('Position',[900,1000,800,1300]);
% for j=1:pcNum
%    for i=1:SUC_num-1
%       subplot(pcNum,1,j);
%       time_w = SUC_Timing_A(i,4) - SUC_Timing_A(i,2) +1;
%       pullData(i,:) = All_T(j,SUC_Timing_A(i,3)+TIMEr(1):SUC_Timing_A(i,3)+TIMEr(2));
%       plot(pullData(i,:));
%       ave(j,:) = ((ave(j,:) .* (i-1)) + pullData(i,:)) ./ i ;
%       ylim([0 2]);
%       hold on;
%    end
% end


if plk == 1
    if save_data == 1
        cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
        cd ([fold_name '_H'])
%         aveH = ave;
        comment = 'this data will be used for dispH';
        save([fold_name '_aveH_' sprintf('%d',pcNum) '.mat'], 'aveH','k','pcNum','fold_name','comment');
        cd ../../
    end

    if save_fig_H ==1
        cd ([fold_name '_syn_result_' sprintf('%02d',EMG_num)])
        cd ([fold_name '_H'])
        saveas(gcf,[fold_name ' H_2 pcNum = ' sprintf('%d',pcNum) '.fig']);
        saveas(gcf,[fold_name ' H_2 pcNum = ' sprintf('%d',pcNum) '.png']);
        cd ../;
        cd ../;
    end

     f3=figure('Position',[900,1000,800,1300]);
     for j=1:pcNum
         subplot(pcNum,1,j);
%          plot(ave(j,:),'r');
         ylim([0 2]);
         hold on;
     end

     if save_fig_H ==1
         cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
         cd ([fold_name '_H'])
         saveas(gcf,[fold_name ' H_ave pcNum = ' sprintf('%d',pcNum) '.fig']);
         saveas(gcf,[fold_name ' H_ave pcNum = ' sprintf('%d',pcNum) '.png']);
         cd ../;
         cd ../;
     end

        %% plot r2
        f5 = figure;
        load([fold_name '_' sprintf('%02d',EMG_num) '.mat']);
        for i= 1:kf
            %plot((1 - cell2mat(test.D(:,i)))*100);
            plot(test.r2(:,i));
            %plot((1 - cell2mat(train.D(:,i)))*100);
            ylim([0 1]);
            hold on;
            plot(shuffle.r2(:,i),'Color',[0,0,0]);
            hold on
        end

            plot([0 EMG_num + 1],[0.8 0.8]);
            title([fold_name ' R^2']);

        if save_fig_r2 ==1
            cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
            cd ([fold_name '_r2'])
            saveas(gcf,[fold_name ' R2 pcNum = ' sprintf('%d',pcNum) '.png']);
            cd ../;
            cd ../;
        end

        cd ../
        cd ../
    elseif plk == 3
        if save_data == 1
            cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
            cd ([fold_name '_H'])
%             aveH = ave;
            comment = 'this data will be used for dispH';
            save([fold_name '_aveH3_' sprintf('%d',pcNum) '.mat'], 'aveH','k','pcNum','fold_name','comment');
            cd ../../
        end

        if save_fig_H ==1
            cd ([fold_name '_syn_result_' sprintf('%02d',EMG_num)])
            cd ([fold_name '_H'])
            saveas(gcf,[fold_name ' HS_2 pcNum = ' sprintf('%d',pcNum) '.fig']);
            saveas(gcf,[fold_name ' HS_2 pcNum = ' sprintf('%d',pcNum) '.png']);
            cd ../;
            cd ../;
        end

         f3=figure('Position',[900,1000,800,1300]);
         for j=1:pcNum
             subplot(pcNum,1,j);
%              plot(ave(j,:),'r');
             ylim([0 2]);
             hold on;
         end

         if save_fig_H ==1
             cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
             cd ([fold_name '_H'])
             saveas(gcf,[fold_name ' H3_ave pcNum = ' sprintf('%d',pcNum) '.fig']);
             saveas(gcf,[fold_name ' H3_ave pcNum = ' sprintf('%d',pcNum) '.png']);
             cd ../;
             cd ../;
         end
         close all;

        %% plot r2
        f5 = figure;
        load([fold_name '_' sprintf('%02d',EMG_num) '.mat']);
        for i= 1:kf
            plot(test.r2(:,i));
            ylim([0 1]);
            hold on;
            plot(shuffle.r2(:,i),'Color',[0,0,0]);
            hold on
        end

            plot([0 EMG_num + 1],[0.8 0.8]);
            title([fold_name ' R^2']);

        if save_fig_r2 ==1
            cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
            cd ([fold_name '_r2'])
            saveas(gcf,[fold_name ' R2 pcNum = ' sprintf('%d',pcNum) '.png']);
            close all;
            cd ../;
            cd ../;
        end

        cd ../
        cd ../
    end
end
%% define function
function [stack_figure,average_figure,trimmed_synergy] = trim_func(All_T, success_timing,pcNum,trim_package)
%使用する変数を設定する
[~,trial_num] = size(success_timing);
pattern = digitsPattern;
timing_num = str2double(cell2mat(extract(trim_package.type,pattern)));
pre_frame = trim_package.pre_frame;
post_frame = trim_package.post_frame;

%データを収納する変数の作成
trimmed_synergy = cell(pcNum,1);
for ii = 1:pcNum
    trimmed_synergy{ii} = zeros(trial_num,pre_frame + post_frame);
end

%図のプロットとデータの収納
stack_figure = figure('Position', [100 100 1280 720]);
for ii = 1:pcNum
    subplot(pcNum,1,ii)
    hold on;
    for jj = 1:trial_num 
        just_timing = success_timing(timing_num,jj);
        trimmed_data = All_T(ii,just_timing - (pre_frame)+1 : just_timing+post_frame);
        plot(trimmed_data);
        trimmed_synergy{ii}(jj,:) = trimmed_data;
    end
    %図の装飾(ylim,title,xline etc...)
    
    hold off
end
%平均のプロット
average_figure = figure('Position', [100 100 1280 720]);
for ii = 1:pcNum
    subplot(pcNum,1,ii)
    hold on;
    %平均を求める
    
    %図の装飾(ylim,title,xline etc...)
    
    hold off
end
end