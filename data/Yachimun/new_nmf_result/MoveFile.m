%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
���c��������֐�
makeEMGNMF�Ő������ꂽ�t�@�C����1�ӏ��ɕۑ�����Ă���(ex. Yachimun -> new_nmf_result ->dist-dist)�̂ŁA����𐳂����ꏊ�Ɉڂ��֐�
�J�����g�f�B���N�g����new_nmf_result�ɂ��Ďg�p����
�p�r��Yachimun�Ɍ��肳��Ă���̂ŁA�����Ɣėp�������߂����ꍇ�͐V�����ϐ�������ĊY���ӏ���ϐ��ɒu��������(�T�����A�g�p����ؓ��̐��Ȃ�)
pre_operate: makeEMGNMF
post_operate:SYNERGYPLOT.m
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
reference_dir = 'data_fold_(12_muscle)';
prefix_name = 'Ya';
saved_folder_prefix = 'F';
first_day = 170516;
last_day = 170929;
%% code section
nmf_files = dir(fullfile(pwd, reference_dir, [prefix_name '*']));
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
        movefile(file_path, des_folders_path);
    else
        continue
    end
end




