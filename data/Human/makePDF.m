%% set param
patient_name = 'patientB';
loop_num = 3; %何回ループするか
task_names = {'pre', 'post'}; %階層構造を指定せずに，特定の文字列を持ってくるために必要
%% code section
disp(['【Please select .png which you want to add pdf files']);
% [pictureNames,def_pathName] = selectGUI(patient_name, 'EMG');
select_dir = [pwd '/' patient_name];

for ii = 1:loop_num
    disp(['【Please select .png which you want to add pdf files(' num2str(ii) 'loop)】']);
    [fileNames, pathName] = uigetfile('*.png',select_dir,'MultiSelect','on');
    common_string = common_string_extraction(fileNames); %pngファイルの共通部分の抜き出し
    path_elements = split(pathName, filesep);
    task_names = get_task_dirs(patient_name,path_elements, task_names); %タスクのディレクトリ情報を抽出

    %pdfファイルの作成
    templateFile = 'template.pptx';
    outputFile =  [task_names{ii} '_' common_string '.pptx'];
    copyfile(templateFile, outputFile)
end

%% set local function
function common_string = common_string_extraction(file_Names)
ref_muscle = 'Biceps';
for ii = 1:length(file_Names)
    file_Name = file_Names{ii};
    if contains(file_Name, ref_muscle)
        common_string = strrep(file_Name,ref_muscle,'');
        common_string = strrep(common_string,'.png','');%拡張子を文字列から排除する
        break;
    end
end
end