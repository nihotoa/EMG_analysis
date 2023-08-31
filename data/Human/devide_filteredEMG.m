%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by: Naohito Ota
function:
devide whole recorded data into each task data and save these data
procedure:
pre: filtered data
post: makeEMGNMFbtcOya or Ohta
after-post: LoopMergeEachTrialSynergy.m
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
%% set param
patient_name = 'patientB';
task_num = 5; %taskの個数(日によって4の時もあるが,大きい方に合わせた)
day_names_prefix = {'pre', 'post'};
specific_muscle_name = 'IOD-1'; %処理の接尾語を見つけるための文字列
%% code sectionwhi
day_fold_path = [pwd '/' patient_name];
day_names = getDirectoryInfo(day_fold_path, day_names_prefix, 'name');
task_names = MakeTaskFoldersCell(task_num);
disp('please select directory which contains filtered EMG (day -> task -> nmf_result -> patientB_standard)')
original_path = uigetdir(day_fold_path); 
original_path_elements = split(original_path, '/');
day_fold_idx = find(contains(original_path_elements, day_names_prefix));
task_fold_idx = find(contains(original_path_elements, task_names));
a = 1;
for ii = 1:length(day_names)
    for jj = 1:length(task_names)
        % データの入っているdirectoryのpathを作成
        used_path = original_path;
        used_path = strrep(used_path, original_path_elements{day_fold_idx}, day_names{ii});
        used_path = strrep(used_path, original_path_elements{task_fold_idx}, task_names{jj});
        %初回だけ，筋肉名と処理内容名の取得のためにif内を行う.
        if and(ii == 1, jj == 1)
            disp('please select filteredEMG_data')
            filteredEMG_name_list = uigetfile(used_path, 'MultiSelect', 'on');
            % 接尾語(処理内容の文字列)を探していく
            for kk = 1:length(filteredEMG_name_list)
                if contains(filteredEMG_name_list{kk}, specific_muscle_name)
                    file_name_suffix = strrep(filteredEMG_name_list{kk}, specific_muscle_name, '');
                    break;
                end
            end
            muscle_names = strrep(filteredEMG_name_list, file_name_suffix, '')';
        end
        if not(exist([used_path '/' 'each_trials']))
            mkdir([used_path '/' 'each_trials'])
        end
        % all_timingの取得
        try
            load([day_fold_path '/' day_names{ii} '/' task_names{jj} '_timing.mat'], 'all_timing_data')
        catch
            continue
        end
        %筋肉のloopが外，trialのループが中
        for kk = 1:length(muscle_names)
            try
                load([used_path '/' muscle_names{kk} file_name_suffix], 'Class', 'Data', 'Name', 'SampleRate', 'TimeRange', 'Unit')
                data = Data;
            catch %その筋肉が存在しなかった時
                continue
            end
            for ll = 1:length(all_timing_data)
                %切り出し(一応dataとして保存したが,makeEMGNMFでエラー吐くかもしれない(Dataじゃないから))
                Data = data(1, all_timing_data(1,ll)+1:all_timing_data(2,ll));
                %trial別のフォルダに保存
                if not(exist([used_path '/' 'each_trials' '/' 'trial' sprintf('%02d', ll)]))
                    mkdir([used_path '/' 'each_trials' '/' 'trial' sprintf('%02d', ll)])
                end
                save([used_path '/' 'each_trials' '/' 'trial' sprintf('%02d', ll) '/' muscle_names{kk} file_name_suffix],'Class', 'Data', 'Name', 'SampleRate', 'TimeRange', 'Unit')
            end
        end
    end
end