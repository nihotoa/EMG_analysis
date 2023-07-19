%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last Modification:2023.05.11
【procedure】
pre:SuccessTiming_func.m
post:plotSTDtraj.m(if you want to plot mean+-std figure)
【function】
*save motion trajectory & movie from obtained .mat file(~_Traj,mat) (save dir: day -> task -> Motion)
【improvements】
* consider how we adjust location and range of coordination
* change so that skelton can be created by GUI opearation
% make figure which contains mean line & std back ground

[作りたいもの]
・タスク中の期間に回内外があったかどうか
・関節角度を求める
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
use_val.FrameRate = 100; %frame rate when playing(100 is real speed)
use_val.line_width_size = 1.5;
VideoWrite = 0; % whethere you create trajectory movie or not 
% ↓pre1, post1の時
% use_val.marker_point = {'wrist', 'MPH', 'PIP', 'DIP'};
%↓post2の時
use_val.marker_point = {'Ulnar', 'MPH3', 'RAD' ,'PIP3', 'DIP3', 'DIP4'};
%% code section
disp('【Please select _Traj.mat (patient -> day)】')
[fileNames,use_val.pathName] = selectGUI(patient_name, 'Marker');

%↓if selected file is only 1 file, we should deal with it as char type
if ischar(fileNames)
    temp = fileNames;
    clear fileNames;
    fileNames{1} = temp;
end

%↓save the movie for each task type
use_val.task_traj_list = cell(length(fileNames), 1);
for ii = 1:length(fileNames)% loop for each task type 
    use_val.fileName = fileNames{ii};
    [data,use_val] = calcMovie(use_val); %
    success_timing_file_name = strrep(fileNames{ii}, 'Traj', 'timing');
    load([use_val.pathName success_timing_file_name], 'all_timing_data');
    use_val.all_timing_data = all_timing_data;
    use_val = plotPackage(data, use_val, ii);
    if VideoWrite
        VideoPackage(data, use_val) 
    end
end
% save trajctory data(for mean & std plot fucntion)
traj_data = use_val.task_traj_list;
save([use_val.pathName 'All_Traj_data.mat'], 'traj_data')

%% define internal function
%% make fold & hierarchical structure
function [data,use_val] = calcMovie(use_val)
use_val.fold_name = strrep(use_val.fileName,'_Traj.mat','');
%↓make fold
use_val.file_save_dir = [use_val.pathName use_val.fold_name '/' 'Motion'];
if not(exist(use_val.file_save_dir,'dir'))
    mkdir([use_val.file_save_dir])
end
%devide data into each task type 
load([use_val.pathName use_val.fileName],'data'); 
end

%% plot & save motion data
function use_val = plotPackage(data, use_val, task_num)
%plot each merker trajectory(no trimming)
for ii = 1:length(use_val.marker_point)
    figure('position', [100, 100, 1200, 800]);
    hold on
    ref_col = 1 + 3 * (ii-1); %colmuns number of merker point in csv file
    for jj = 1:3 %x,y,z
        subplot(3,1,jj);
        plot(data(:,ref_col),'LineWidth', use_val.line_width_size);
        grid on;
        if jj==1
            title([use_val.marker_point{ii} '-x'],'FontSize',25)
        elseif jj==2
            title([use_val.marker_point{ii} '-y'],'FontSize',25)
        elseif jj==3 
            title([use_val.marker_point{ii} '-z'],'FontSize',25)
        end
        ref_col = ref_col + 1;
    end
    %save section
    if not(exist(use_val.file_save_dir))
        mkdir(use_val.file_save_dir)
    end
    saveas(gcf, [use_val.file_save_dir '/' use_val.marker_point{ii}  '_all_traj.png'])
    saveas(gcf, [use_val.file_save_dir '/' use_val.marker_point{ii}  '_all_traj.fig'])
    close all;
end

% plot each merker trajectory(trimmed and stack)
figure('position', [100, 100, 1200, 800]);
use_val.task_traj_list{task_num} = cell(length(use_val.all_timing_data), 3*length(use_val.marker_point));
for ii = 1:length(use_val.marker_point)
    hold on;
    ref_col = 1 + 3 * (ii-1); %colmuns number of merker point in csv file
    for jj = 1:3 %x,y,z
        subplot(length(use_val.marker_point), 3, ref_col);
        ref_data = data(:,ref_col);
        for kk = 1:length(use_val.all_timing_data) %trial num
            trimmed_data = ref_data(use_val.all_timing_data(1, kk):use_val.all_timing_data(2, kk));
            use_val.task_traj_list{task_num}{kk, 3*(ii-1)+jj} = trimmed_data';
            x = linspace(0, 1, length(trimmed_data));
            plot(x, trimmed_data, 'LineWidth',use_val.line_width_size);
            hold on;
        end
        %decoration
        grid on;
        if jj==1
            title([use_val.marker_point{ii} '-x'],'FontSize',25)
        elseif jj==2
            title([use_val.marker_point{ii} '-y'],'FontSize',25)
        elseif jj==3 
            title([use_val.marker_point{ii} '-z'],'FontSize',25)
        end
        ref_col = ref_col + 1;
    end
end
%save section
saveas(gcf, [use_val.file_save_dir '/' use_val.marker_point{ii}  '_task_traj(stack).png'])
saveas(gcf, [use_val.file_save_dir '/' use_val.marker_point{ii}  '_task_traj(stack).fig'])
close all;
end

%% create & save Movie data from Motion data
function [] = VideoPackage(data, use_val)
% create object which is neccesarry to create movie
movie_path = [use_val.file_save_dir '/' 'Motion_trajectory.mp4'];
if not(exist(movie_path))
    vidObj = VideoWriter([use_val.file_save_dir '/' 'Motion_trajectory.mp4'], 'MPEG-4');
    vidObj.FrameRate = use_val.FrameRate;
    open(vidObj);
    %Setting the Axis range
    max_value = 0;
    min_value = 0;
    [~,col] = size(data);
    for j = 1:col %x.y.z axis
        max_candidate = max(data(:,j));
        min_candidate = min(data(:,j));
        if max_candidate > max_value
            max_value = max_candidate;
        end
        if min_candidate < min_value
            min_value = min_candidate;
        end
    end
    upper_lim = ceil(max_value/10)*10;% round up
    lower_lim = floor(min_value/10)*10; %move down
    
    %settings of variable for drawing each axis
    axis_length = (upper_lim - lower_lim) * 1/3;
    axis_vector = [axis_length,0 0; 0 axis_length 0; 0 0 axis_length];
    point = [0;0;0];
    
    figure('Position',[100 100 1280 720]);
    % 4. write each frame image to Video object
    marker_num = col / 3; %3 is demention num(x, y, z)
    marker_point = use_val.marker_point;
    
    for i = 1:size(data, 1)
        % renew the 3D plot
        for j = 1:marker_num
            x_value(j) = data(i, (3*j)-2);
            y_value(j) = data(i, (3*j)-1);
            z_value(j) = data(i, 3*j);
            plot3(data(i, (3*j)-2), data(i, (3*j)-1), data(i, 3*j), 'o', 'MarkerFaceColor', 'red');
            hold on;
        end

        %create skelton
        for j = 1:(marker_num-1)
            switch marker_num
                case 4 %if we have no marker both ulnar and radial
                    plot3([x_value(j),x_value(j+1)],[y_value(j),y_value(j+1)],[z_value(j),z_value(j+1)],'r','LineWidth',2);

                case 6 %
                    if j == 1
                        for k = [2,3]
                            plot3([x_value(j),x_value(k)],[y_value(j),y_value(k)],[z_value(j),z_value(k)],'r','LineWidth',2);
                        end
                    elseif j == 2
                        for k = [3,4,6]
                            plot3([x_value(j),x_value(k)],[y_value(j),y_value(k)],[z_value(j),z_value(k)],'r','LineWidth',2);
                        end
                    elseif j == 4
                        plot3([x_value(j),x_value(5)],[y_value(j),y_value(5)],[z_value(j),z_value(5)],'r','LineWidth',2);
                    end
            end
            
        end
        %decoration of figure
        grid on;
        xlim([lower_lim upper_lim]);
        xlabel('X-axis[mm]','FontSize',30)
        ylim([lower_lim upper_lim]);
        ylabel('Y-axis[mm]','FontSize',30)
        zlim([lower_lim upper_lim]);
        zlabel('Z-axis[mm]','FontSize',30)
        quiver3(point,point,point, axis_vector(:,1), axis_vector(:,2), axis_vector(:,3),0)
        view(45,30) %change the angle of 3D coordination
        title(use_val.fold_name,'FontSize',25)
        hold off;
        
        drawnow;
        % get the frame information and wirte to movie object
        frame = getframe(gcf);
        writeVideo(vidObj, frame);
    end
    
    % 5. save video object and finish processing
    close(vidObj);
    close all;
end
end
