%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by:Naohito Ota

function:
Check if there was any rotation of the wrist joint during the task

procedure:
pre:
post:

(+) -> supination (-) -> pronation
%課題点：
全区間ではなくて,タスクごとに区間を分ける
3次元ではなく二次元的な(回転平面での)回内外のdegreeを知りたい
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
marker_point = {'Ulnar', 'MPH', 'RAD' ,'PIP', 'DIP', 'DIP4'};
%% code section
[fileNames,pathName] = selectGUI(patient_name,'*Traj.mat');
for ii = 1:length(fileNames)
    clear all_degree
    load([pathName fileNames{ii}], 'data');
    ulnar_index = find(strcmp(marker_point, 'Ulnar'));
    radial_index = find(strcmp(marker_point, 'RAD'));
    ulnar_traj = data(:, 3*(ulnar_index-1)+1:3*(ulnar_index-1)+3);
    radial_traj = data(:, 3*(radial_index-1)+1:3*(radial_index-1)+3);
    ul_to_rad = radial_traj - ulnar_traj;
    reference_line = ul_to_rad(1,:);
    all_degree = zeros(length(data)-1,1);
    for jj = 2:length(data)
        compared_line = ul_to_rad(jj,:);
        % Inner product of vectors ref and compared
        dot_product = dot(reference_line, compared_line);
        % calcurate degree
        cos_theta = dot_product / (norm(reference_line) * norm(compared_line));
        theta_rad = acos(cos_theta);
        % translate [rad] to [deg]
        theta_deg = rad2deg(theta_rad);
        all_regree(jj-1) = theta_deg;
    end
    figure('position', [100, 100, 1200, 800]);
    plot(all_regree)
end
%% set local function