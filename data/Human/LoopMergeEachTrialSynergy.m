%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota

function:
merge all trials data and plot mean +- std data of r2, W, H

procedure:
pre: loopmakeEMGNMF_btcOhta.m
before-pre: devide_filteredEMG.m
post: nothing

[改善点]
この関数は外から呼び出せるようにして，予め入力引数として，dayとtaskが渡されている状態からスタートするようにする
タスクによってシナジーがかなり異なる(programのせいではないことを確認済み)ので,H_syenrgyのalignも追加する
%この関数を回す側を作る
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%% set param
patient_name = 'patientB';  
day_names_prefix = {'pre', 'post'};
% day_name = 'post1'; 
% task_name = 'Task01'; 
common_string = '-hp50Hz-rect-lp3Hz-ds100Hz'; 
ref_syn_num = 3; 
most_dark_value = 80; 
plot_type = 'stack'; %'stack' / 'mean' 
task_num = 5;
%% code section
reference_path = [pwd '/' patient_name];
day_names = getDirectoryInfo(reference_path, day_names_prefix, 'name');
task_names = MakeTaskFoldersCell(task_num, 'Task');
for ii = 1:length(day_names)
    day_name = day_names{ii};
    for jj = 1:length(task_names)
        task_name = task_names{jj};
        data_file_path = [reference_path '/' day_name '/' lower(task_name) '.mat'];
        if exist(data_file_path) == 2
            MergeEachTrialSynergy(patient_name, day_name, task_name, common_string, ref_syn_num, most_dark_value, plot_type)
        end
    end
end