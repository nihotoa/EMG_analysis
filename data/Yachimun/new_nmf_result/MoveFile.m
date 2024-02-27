%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
太田が作った関数
makeEMGNMFで生成されたファイルが1箇所に保存されている(ex. Yachimun -> new_nmf_result ->dist-dist)ので、それを正しい場所に移す関数
カレントディレクトリをnew_nmf_resultにして使用する
用途がYachimunに限定されているので、もっと汎用性を高めたい場合は新しく変数を作って該当箇所を変数に置き換える(サル名、使用する筋肉の数など)
pre_operate: change_name.m
post_operate:SYNERGYPLOT.m

備考:
makeEMGNMF_btcOyaの方で対応できればいらないかも
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
    if any(contains(des_folders, day_name)) %その日付のフォルダがセーブ先フォルダとして存在している場合
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




