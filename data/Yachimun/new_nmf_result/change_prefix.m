%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
指定したファイルのprefixを変更するための関数.解析には関係ない
Fフォルダの中にYa~.matが入っているのが煩わしいので,Fに接頭語を変更するために応急的に作ったファイル
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
original_prefix = 'Ya';
post_prefix = 'F';

%% code section
ref_folders = dir(pwd);
ref_folders = {ref_folders([ref_folders.isdir]).name};
ref_folders = ref_folders(startsWith(ref_folders, post_prefix));
for ii = 1:length(ref_folders)
    a = dir(fullfile(pwd, ref_folders{ii}));
    a = {a(~[a.isdir]).name};
    changed_files = a(startsWith(a, original_prefix));
    for jj = 1:length(changed_files)
        old_file_name = changed_files{jj};
        new_file_name = strrep(old_file_name, original_prefix, post_prefix);
        movefile(fullfile(pwd, ref_folders{ii}, old_file_name), fullfile(pwd, ref_folders{ii}, new_file_name))
    end
end