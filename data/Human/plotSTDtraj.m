%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by: Naohito Ota

function:
plot mean+std figure of trajectry with using trajectory data

procedure:
pre: ExtractMotionData.m
post: nothing
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
task_num = 5; %number of task variation 
plot_color = {'r','g','b'} ; %Required as many as the number of exp_days
% ↓pre1, post1のmerker_point
use_val.marker_point1 = {'wrist', 'MPH', 'PIP', 'DIP'};
%↓post2のmerker_point
use_val.marker_point2 = {'Ulnar', 'MPH', 'RAD' ,'PIP', 'DIP', 'DIP4'};
%% code section
trans_cell = cell(length(use_val.marker_point1), 1);
for ii = 1:length(use_val.marker_point1)
    for jj = 1:length(use_val.marker_point2)
        if strcmp(use_val.marker_point1{ii}, use_val.marker_point2{jj})
            trans_cell{ii} = jj;
            break;
        end
    end
end
trans_procedure = cell(length(use_val.marker_point1), 1);
for ii = 1:length(use_val.marker_point1)
    for jj = 1:3 %x,y,z
        try
            trans_procedure{ii}(jj,1) =  3*(trans_cell{ii}-1) + jj;
        catch
            trans_procedure{ii}(jj,1) =  0;
        end
    end
end
trans_procedure = cell2mat(trans_procedure);
patient_path = [pwd '/' patient_name '/'];
directoryInfo = getDirectoryInfo(patient_path);
% put togather information
for ii = 1:length(directoryInfo)% mumber of day
    traj_data_path = [patient_path directoryInfo{ii}.name];
    legend_name{ii} = directoryInfo{ii}.name;
    load([traj_data_path '/All_Traj_data.mat'], 'traj_data')
    [mean_list_sel, std_list_sel] = calc_mean_std(traj_data);
    mean_list{ii} = mean_list_sel;
    std_list{ii} = std_list_sel;
end
% plot data
divisor = 3; %x,y,z
axis_list = ['x', 'y', 'z'];
for ii = 1:task_num
    figure('position', [100, 100, 1200, 800]);
    for jj = 1:length(use_val.marker_point1)*3 %marker_point*3
        subplot(length(use_val.marker_point1),3,jj)
        for kk = 1:length(directoryInfo) %number of day
            if strcmp(legend_name{kk}, 'post2')
                try
                    plot_mean_data = mean_list{kk}{ii}(:,trans_procedure(jj))';
                    plot_std_data = std_list{kk}{ii}(:,trans_procedure(jj))'; 
                catch
                    continue
                end
            else
                plot_mean_data = mean_list{kk}{ii}(:,jj)';
                plot_std_data = std_list{kk}{ii}(:,jj)';
            end
            x = linspace(0, 1, length(plot_mean_data));
            curve1 = plot_mean_data + plot_std_data;
            curve2 = plot_mean_data - plot_std_data;
            x2 = [x, fliplr(x)];
            inBetween = [curve1, fliplr(curve2)];
            fill(x2, inBetween, plot_color{kk}, 'FaceAlpha',0.1, 'LineStyle',':', 'EdgeColor',plot_color{kk}, 'DisplayName','');
            hold on;
            plot(x, plot_mean_data, plot_color{kk},'LineWidth',1.5, 'DisplayName',legend_name{kk});
        end
        %decoration
        grid on;
        if jj == length(use_val.marker_point1)*3
            legend
        end
        quotient = fix((jj-1)/divisor);
        remainder = rem(jj-1, divisor);
        title([use_val.marker_point1{quotient+1} '-' axis_list(remainder+1)], 'FontSize',25)
        hold off
    end
    % save
    saveas(gcf, [patient_path 'all_day_traj.fig'])
    saveas(gcf, [patient_path 'all_day_traj.png'])
    close all;
end

%% set local function
function [man_list_sel, std_list_sel] = calc_mean_std(traj_data)
man_list_sel = cell(length(traj_data),1);
std_list_sel = cell(length(traj_data),1);
for ii = 1:length(traj_data)
    task_data = traj_data{ii};
    [~, col] = size(task_data);
    for jj = 1:col
        clear resampled_data
        if jj == 1
            % find the average sample number
            [trial_num, ~] = size(task_data);
            temp = 0;
            for kk = 1:trial_num
                temp = temp + length(task_data{kk});
            end
            mean_sample_num = round(temp/length(task_data));
        end
        [trial_num, ~] = size(task_data);
        for kk = 1:trial_num
            resampled_data{kk,1} = resample(task_data{kk,jj}, mean_sample_num, length(task_data{kk,jj}));
        end
        resampled_data = cell2mat(resampled_data);
        mean_data = mean(resampled_data);
        std_data = std(resampled_data);
        man_list_sel{ii}{jj} = mean_data';
        std_list_sel{ii}{jj} = std_data';
    end
    man_list_sel{ii} = cell2mat(man_list_sel{ii});
    std_list_sel{ii} = cell2mat(std_list_sel{ii});
end
end