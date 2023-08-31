%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
【function】
*calc & plot Joint Angle
【improvements】
* consider how we adjust location and range of coordination
* change so that skelton can be created by GUI opearation
% make figure which contains mean line & std back ground
post2での関節角度の求め方

[作りたいもの]
・タスク中に回内外があったかどうか
・関節角度を求める
・mean + stdを作る
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
task_num = 5; %number of task
% ↓pre1, post1の時
use_val.marker_point1 = {'wrist', 'MPH', 'PIP', 'DIP'};
use_val.JointAngle_var = {'MPH', 'PIP'};
%↓post2の時
use_val.marker_point2 = {'Ulnar', 'MPH3', 'RAD' ,'PIP3', 'DIP3', 'DIP4'};
%% code section
patient_path = [pwd '/' patient_name '/'];
directoryInfo = getDirectoryInfo(patient_path);
for ii = 1:length(directoryInfo) %number of recording day
    for jj = 1:task_num
        try
            load([patient_path directoryInfo{ii}.name '/' 'task' sprintf('%02d', jj) '_Traj.mat'], 'data')
        catch
            continue; %if you don't have this task data, process next task
        end
        all_degree_list = zeros(length(data), length(use_val.JointAngle_var));
        for kk = 1:length(use_val.JointAngle_var) %variation of joint angle
            all_degree = GetJointAngle(use_val, data, kk, directoryInfo{ii}.name);
            all_degree_list(:,kk) = all_degree;
        end
        y_Max = max(all_degree_list);
        y_Max = ceil(y_Max/10) * 10;
        % plot each joint angle of each task
        load([patient_path directoryInfo{ii}.name '/' 'task' sprintf('%02d', jj) '_timing.mat'], 'all_timing_data')
        figure('position', [100, 100, 1200, 800]);
        for kk = 1:length(use_val.JointAngle_var) %number of joint angle
            subplot(length(use_val.JointAngle_var), 1, kk)
            hold on;
            for ll = 1:length(all_timing_data) %trial num
                plotted_degree = all_degree_list(all_timing_data(1, ll):all_timing_data(2, ll), kk);
                x = linspace(0, 1, length(plotted_degree));
                plot(x, plotted_degree, 'LineWidth',1.5)
            end
            %decoration
            ylim([0 y_Max(kk)])
            grid on;
            title([ use_val.JointAngle_var{kk} '-angle'], 'FontSize',25)
            hold off
        end
        %save figure
        saveas(gcf, [patient_path directoryInfo{ii}.name '/task' sprintf('%02d', jj) '/' 'task' sprintf('%02d', jj) '_JointAngle.png'])
        saveas(gcf, [patient_path directoryInfo{ii}.name '/task' sprintf('%02d', jj) '/' 'task' sprintf('%02d', jj) '_JointAngle.fig'])
        close all;
    end
end

%% set local function
function all_degree = GetJointAngle(use_val, data, kk, exp_day)
switch exp_day
    case 'post2'
        marker_index = find(contains(use_val.marker_point2, use_val.JointAngle_var{kk}));
        switch marker_index
            case 2 %if marker_index references 'MPH' joint.
                wrist_data = getWristPosistion(data, 1, 3);
            otherwise
        end
        
    otherwise
        marker_index = find(strcmp(use_val.marker_point1, use_val.JointAngle_var{kk}));
        % extract each marker data
        p_index = {marker_index-1, marker_index, marker_index+1};
        p1_data = data(:, 3*(p_index{1}-1)+1:3*(p_index{1}-1)+3);
        p2_data = data(:, 3*(p_index{2}-1)+1:3*(p_index{2}-1)+3);
        p3_data = data(:, 3*(p_index{3}-1)+1:3*(p_index{3}-1)+3);
        
        V1 = p2_data - p1_data;
        V2 = p3_data - p2_data;
        
        all_degree = zeros(length(V1), 1);
        % calcurate each frame degree
        for ii = 1:length(V1)
            V1_data = V1(ii, :);
            V2_data = V2(ii, :);
            dot_value = dot(V1_data, V2_data);
            V1_norm = norm(V1_data);
            V2_norm = norm(V2_data);
            cos_theta = dot_value / (V1_norm * V2_norm);
            theta_rad = acos(cos_theta);
            theta_dig = rad2deg(theta_rad);
            all_degree(ii) = theta_dig;  
        end
end
end

function wrist_data = getWristPosistion(data, ulnar_index, radial_index)
ulnar_data = data(:, 3*(ulnar_index-1)+1:3*(ulnar_index-1)+3);
radial_data = data(:, 3*(radial_index-1)+1:3*(radial_index-1)+3);

UtoD_data = ulnar_data - radial_data;
wrist_data = ulnar_data + (UtoD_data)*(1/2);
end