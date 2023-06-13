%{
patient_name:patient_name = 'patientB' (directory name directly under 'Human' fold )
path_elements: get with ussing next function -> split(def_pathName,
filesep);※ def_pathName
task_names:task_names = {'pre', 'post'};
%}

function folder_names = get_task_dirs(patient_name,path_elements, task_names)
task_name = path_elements{contains(path_elements, task_names)};
task_dirs = dir([pwd '/' patient_name '/' task_name]); %ここで日付フォルダ(post1等)の中のdirを取得したい
task_dirs = task_dirs([task_dirs.isdir]); % フォルダだけに絞り込み
folder_names = {task_dirs.name}; % フォルダ名だけを抽出
folder_names = folder_names(~ismember(folder_names,{'.','..'})); % '.'や'..'を除外
end

