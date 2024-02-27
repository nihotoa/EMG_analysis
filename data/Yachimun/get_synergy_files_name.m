function [synergy_files] = get_synergy_files_name(fold_path, fold_name)
%{
explanation of this func:
get the names of synergy-related files in a folder by list
this function is used in plotSynergyAll_uchida.m
%}

candidate_files = dir(fold_path);

% filtering (Leaves only files)
candidate_files = candidate_files(~[candidate_files.isdir]);

% extract only files with specific strings(fold_name)
synergy_files = candidate_files(contains({candidate_files.name}, fold_name));
end

