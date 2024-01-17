%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
[function]
各フォルダにnmfファイルを移す(MoveFile.m)の前に,nmfファイルの名前を変更するための関数

[procedure]
pre: makeEMGNMF_Oya.m
post: MoveFile.m 

[改善点]
決まった名前の変更にしか対応していないので, 汎用性を広げる.
WH => t_Ya170516.mat
VAF => Ya170516.mat
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

%% set param
data_fold_name = 'data_fold(dist-dist)';
file_prefix = 'Ya';
target_prefix = 'F';

%% code section
data_name_struct = struct();

disp(['Please select all t_' file_prefix '~.m file'])
[data_name_struct.files1, file_dir_path] = uigetfile(fullfile(pwd, data_fold_name), "MultiSelect","on");
disp(['Please select all ' file_prefix '~.m file'])
data_name_struct.files2 = uigetfile(fullfile(pwd, data_fold_name), "MultiSelect","on");
% 使用したEMGの数の取得
load(fullfile(file_dir_path, data_name_struct.files2{1}), 'TargetName')
muscle_num = length(TargetName);

for ii = 1:2 % WHとVAF
    ref_files_name = data_name_struct.(['files' num2str(ii)]);
    if ii == 1 % WH
        change_file_name(file_dir_path, ref_files_name, 'WH', muscle_num, file_prefix, target_prefix)
    elseif ii == 2 % VAF
        change_file_name(file_dir_path, ref_files_name, 'VAF', muscle_num, file_prefix, target_prefix)
    end
end

%% define function

function [] = change_file_name(file_dir_path, ref_files_name, file_type, muscle_num, file_prefix, target_prefix)
file_num = length(ref_files_name);
for ii = 1:file_num
    ref_file_name = ref_files_name{ii};
    temp_name = strrep(ref_file_name, file_prefix, target_prefix);
    num_part = regexp(ref_file_name, '\d+', 'match');
    num_part = num_part{1};
    switch file_type
        case 'WH'
            temp_name = strrep(temp_name, 't_', '');
            changed_file_name = strrep(temp_name, num_part, [num_part '_' num2str(muscle_num) '_nmf']);
        case 'VAF'
            changed_file_name = strrep(temp_name, num_part, [num_part '_' num2str(muscle_num)]);
    end
    % change file name
    movefile(fullfile(file_dir_path, ref_file_name), fullfile(file_dir_path, changed_file_name))
end
end


