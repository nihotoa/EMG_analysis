%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota   
[function]
processing & displaying stimulation experiment(which is conducted to confirm changes caused by Botox injgection) data
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%% set param

%% code section
stimulation_dirs = getDirectoryInfo(pwd, '_ulnar stimulation', 'name');
for ii = 1:length(stimulation_dirs)
    dir_path = [pwd '/' stimulation_dirs{ii}];
    file_names = getDirectoryFile(dir_path, 'name');
    for jj = 1:length(file_names)
        file_name = file_names{jj};
        load([dir_path '/' file_name])
        a = 1;
    end
end