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
exp_days = [20230707, 20230710, 20230711 20230712];
save_NMF_fold='nmf_result'; %元save_fold
trim_range = 200;
timing_name = {'pull', 'food on', 'food off'};
save_each_fig = 0;
save_combine_fig = 1; 
save_normalized_fig = 0; %(注意!!)他の2つと併用不可

EMGs=cell(3,1) ;
EMGs{1,1}= 'EPL';
EMGs{2,1}= 'FCU';
EMGs{3,1}= 'FDS';
%% code section
day_num = length(exp_days);
figure('position', [100, 100, 1200, 800])
hold on;
all_max_lim = 0;
for ii = 1:day_num
    exp_day = exp_days(ii);
    % load data
    load([num2str(exp_day) '/' 'nmf_result' '/' monkeyname num2str(exp_day) '_standard' '/' 'each_timing_mean_data(trim_range=' num2str(trim_range) 'ms).mat'], 'EMG_mean_data', 'max_lim')
    if max_lim > all_max_lim
        all_max_lim = max_lim;
    end
    x = linspace(-1*trim_range, trim_range, length(EMG_mean_data{1,1}));
    [EMG_num, timing_num] = size(EMG_mean_data);
    for jj = 1:EMG_num
        for kk = 1:timing_num
            subplot(EMG_num, timing_num, timing_num*(jj-1)+kk)
            hold on;
            plot(x, EMG_mean_data{jj,kk}, 'LineWidth', 1.5, 'DisplayName',num2str(exp_day))
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
                legend()
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
saveas(gcf, ['fig_fold' '/' 'all_day_all_centered_EMG(range=' num2str(trim_range) ')' '.fig'])
saveas(gcf, ['fig_fold' '/' 'all_day_all_centered_EMG(range=' num2str(trim_range) ')' '.png'])
hold off;
close all;
%% define local function