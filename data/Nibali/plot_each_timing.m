%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by: Naohito Ota   

pre: SensorCenteredEMG.m 
post: nothing

[function]
plot stack each timing EMG with referencing extracted mean_data(which is extracted by SensorCenteredEMG.m)

[how to use]
please use this in 'Nibali' directory

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
monkeyname='Ni';
exp_days = [20230707 20230710 20230711 20230712 20230714 20230718 20230719 20230720 20230721 20230724 20230726 20230807 20230808 20230814 20230815 20230816];
% exp_days = [20230707 20230710 20230711 20230712 20230726 20230807 20230808];
control_days = [20230707, 20230710, 20230711 20230712]; %please don't change!!
merge_type = 'Control'; %whether to represent the control data in one ('None'/ 'Control')
save_NMF_fold='nmf_result'; %元save_fold
trim_range = 200;
timing_name = {'pull', 'food on', 'food off'};
save_each_fig = 0;
save_combine_fig = 1; 
save_normalized_fig = 0; %(注意!!)他の2つと併用不可
most_dark_value = 120; %setting of color of most dark line
plot_legend = 0;

EMGs=cell(3,1) ;
EMGs{1,1}= 'EPL';
EMGs{2,1}= 'FCU';
EMGs{3,1}= 'FDS';
%% code section
switch merge_type
    case 'None'
        day_num = length(exp_days);
    case 'Control'
        day_num = length(setdiff(exp_days, control_days)) + 1;
        post_days = setdiff(exp_days, control_days);
end
figure('position', [100, 100, 1200, 800])
hold on;
all_max_lim = 0;
for ii = 1:day_num
    if strcmp(merge_type, 'Control')
        if ii == 1
            for jj = 1:length(control_days)
                exp_day = control_days(jj);
                load([num2str(exp_day) '/' 'nmf_result' '/' monkeyname num2str(exp_day) '_standard' '/' 'each_timing_mean_data(trim_range=' num2str(trim_range) 'ms).mat'], 'EMG_mean_data', 'max_lim', 'min_value')
                [EMG_num, timing_num] = size(EMG_mean_data);
                if max_lim > all_max_lim
                    all_max_lim = max_lim;
                end
                for kk = 1:EMG_num
                    for ll = 1:timing_num
                        EMG_mean_data{kk,ll} = EMG_mean_data{kk,ll} - min_value(kk);
                    end
                end
                if jj == 1
                    All_EMG_mean_data = cell(length(control_days), EMG_num * timing_num);
                end
                All_EMG_mean_data(jj, :) = reshape(EMG_mean_data, [], 1);
            end

            EMG_mean_data = cell(EMG_num, timing_num); 
            EMG_std_data = cell(EMG_num, timing_num); 

            for jj = 1:(EMG_num * timing_num)
                a = cell2mat(All_EMG_mean_data(:,jj)); %a is the EMG_data(specific muscle & specific timing) of all pre day
                EMG_mean_data{jj} = mean(a);
                EMG_std_data{jj} = std(a);
            end

            x = linspace(-1*trim_range, trim_range, length(EMG_mean_data{1,1}));
            for kk = 1:EMG_num
                for ll = 1:timing_num
                    subplot(EMG_num, timing_num, timing_num*(kk-1)+ll)
                    curve1 = EMG_mean_data{kk, ll} + EMG_std_data{kk, ll};
                    curve2 = EMG_mean_data{kk, ll} - EMG_std_data{kk, ll};
                    x2 = [x, fliplr(x)];
                    inBetween = [curve1, fliplr(curve2)];
                    fill(x2, inBetween, 'b', 'FaceAlpha',0.1, 'LineStyle',':', 'EdgeColor','b', 'DisplayName', '');
                    hold on;
                    plot(x, EMG_mean_data{kk,ll}, 'b', 'LineWidth', 2, 'DisplayName', 'Control-data')
%                     %decoration
%                     %ylim,title,xline
%                     grid on;
%                     xline(0, 'LineWidth',1.5, 'DisplayName', '')
%                     xlabel('elapsed time[ms]', 'FontSize',15)
%                     ylabel('Amplitude[mV]', 'FontSize',15)
%                     set(gca, 'FontSize', 15)
%                     title([EMGs{kk} '-' timing_name{ll}  ' centered EMG'], 'FontSize',15)
                    if kk == 1 && ll == 1
                        switch plot_legend
                            case 1
                                legend()
                            otherwise
                        end
                    end
                    hold off
                end
            end
            continue;
        end
    end

    % not Control data or not(merge_type == 'Control') 
    switch merge_type
        case 'None'
            exp_day = exp_days(ii);
            color_value = (most_dark_value + ((255-most_dark_value)/(length(post_days)-1))*(ii-1)) / 255;
        case 'Control'
            exp_day = post_days(ii-1);
            color_value = (most_dark_value + ((255-most_dark_value)/(length(post_days)-1))*(ii-2)) / 255;
    end
    % load data
    load([num2str(exp_day) '/' 'nmf_result' '/' monkeyname num2str(exp_day) '_standard' '/' 'each_timing_mean_data(trim_range=' num2str(trim_range) 'ms).mat'], 'EMG_mean_data', 'max_lim', 'min_value')
    if max_lim > all_max_lim
        all_max_lim = max_lim;
    end
    x = linspace(-1*trim_range, trim_range, length(EMG_mean_data{1,1}));
    [EMG_num, timing_num] = size(EMG_mean_data);
    for jj = 1:EMG_num
        for kk = 1:timing_num
            subplot(EMG_num, timing_num, timing_num*(jj-1)+kk)
            hold on;
            EMG_mean_data{jj,kk} = EMG_mean_data{jj,kk} - min_value(jj);
            switch merge_type
                case 'None'
                    plot(x, EMG_mean_data{jj,kk}, 'Color', [color_value,0,0], 'LineWidth', 1.5, 'DisplayName',num2str(exp_day))
                case 'Control'
                    plot(x, EMG_mean_data{jj,kk}, 'Color', [color_value,0,0], 'LineWidth', 1.3, 'DisplayName',num2str(exp_day))
            end
            if ii == day_num 
                %decoration
                %ylim,title,xline
                grid on;
                xline(0, 'LineWidth',1.5, 'DisplayName', '')
                xlabel('elapsed time[ms]', 'FontSize',15)
                ylabel('Amplitude[mV]', 'FontSize',15)
                set(gca, 'FontSize', 15)
                title([EMGs{jj} '-' timing_name{kk}  ' centered EMG'], 'FontSize',15)
            end
            if ii == 1 && jj == 1 && kk == 1
                switch plot_legend
                    case 1
                        legend()
                    otherwise
                end
            end
            hold off
        end
    end
end
% align y_lim
axes_handles = findobj(gcf, 'type', 'axes');
for ii = 1:numel(axes_handles)
    ylim(axes_handles(ii), [0 all_max_lim])
end
%save figure
if not(exist('fig_fold'))
    mkdir('fig_fold')
end

switch merge_type
    case 'None'
        saveas(gcf, ['fig_fold' '/' 'each_day_centered_EMG(range=' num2str(trim_range) ')_' num2str(exp_days(1)) 'to' num2str(exp_days(end)) '_' num2str(length(exp_days)) '.fig'])
        saveas(gcf, ['fig_fold' '/' 'each_day_centered_EMG(range=' num2str(trim_range) ')_' num2str(exp_days(1)) 'to' num2str(exp_days(end)) '_' num2str(length(exp_days)) '.png'])
    case 'Control'
        saveas(gcf, ['fig_fold' '/' 'control_vs_post_centered_EMG(range=' num2str(trim_range) ')_' num2str(post_days(1)) 'to' num2str(post_days(end)) '_' num2str(length(post_days)) '.fig'])
        saveas(gcf, ['fig_fold' '/' 'control_vs_post_centered_EMG(range=' num2str(trim_range) ')_' num2str(post_days(1)) 'to' num2str(post_days(end)) '_' num2str(length(post_days)) '.png'])
end
hold off;
close all;
%% define local function