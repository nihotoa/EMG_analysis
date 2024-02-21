%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
���c��������֐�
makeEMGNMF�Ő������ꂽ�t�@�C����1�ӏ��ɕۑ�����Ă���(ex. Yachimun -> new_nmf_result ->dist-dist)�̂ŁA����𐳂����ꏊ�Ɉڂ��֐�
�J�����g�f�B���N�g����new_nmf_result�ɂ��Ďg�p����
�p�r��Yachimun�Ɍ��肳��Ă���̂ŁA�����Ɣėp�������߂����ꍇ�͐V�����ϐ�������ĊY���ӏ���ϐ��ɒu��������(�T�����A�g�p����ؓ��̐��Ȃ�)
pre_operate: change_name.m
post_operate:SYNERGYPLOT.m

���l:
makeEMGNMF_btcOya�̕��őΉ��ł���΂���Ȃ�����
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
reference_dir = 'F170516_standard';
prefix_name = 'F';
saved_folder_prefix = 'F';
first_day = 170516;
last_day = 170929;
%% code section
nmf_files = dir(fullfile(pwd, reference_dir, [prefix_name '*']));
nmf_files = nmf_files(~[nmf_files.isdir]);
des_folders = dir(pwd);
des_folders = {des_folders([des_folders.isdir]).name};
des_folders = des_folders(startsWith(des_folders, saved_folder_prefix));
for ii = 1:length(nmf_files)
    file_name = nmf_files(ii).name;
    numParts = regexp(file_name, '\d+', 'match');
    day_name = numParts{1};
    if any(contains(des_folders, day_name)) %���̓��t�̃t�H���_���Z�[�u��t�H���_�Ƃ��đ��݂��Ă���ꍇ
        des_folders_idx = find(contains(des_folders, day_name));
        des_folders_path = fullfile(pwd, des_folders{des_folders_idx});
        file_path = fullfile(pwd, reference_dir, file_name);
        file_dir_path = get_file_dir_path(file_path);
        if des_folders_path ~= file_dir_path
            movefile(file_path, des_folders_path);
        end
    else
        continue
    end
end

%% define local function
function [file_dir_path] = get_file_dir_path(file_path)
file_path_components = split(file_path, '/');
file_dir_path_components = file_path_components(1:end-1);
file_dir_path = join(file_dir_path_components, '/');
file_dir_path = file_dir_path{1};
end




