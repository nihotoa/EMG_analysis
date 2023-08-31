%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota
[function]
get max amplitude and calcurate adequate ylim (to fix vertical axis(ylim))
[procedure]:
pre: nothing
post:CheckRawEMG(if you use 'fix_lim' in checkRawEMG.m)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set param
patient_name = 'patientB';
max_from_above = 10;

%EMG list of pre1
pre_EMGs=cell(14,1) ;
pre_EMGs{1,1}= 'IOD-1';
pre_EMGs{2,1}= 'APB';
pre_EMGs{3,1}= 'ADQ';
pre_EMGs{4,1}= 'EDC';
pre_EMGs{5,1}= '2L';
pre_EMGs{6,1}= 'ECR';
pre_EMGs{7,1}= 'BRD';
pre_EMGs{8,1}= 'FCU';
pre_EMGs{9,1}= '3L';
pre_EMGs{10,1}= 'FCR';
pre_EMGs{11,1}= 'FDS';
pre_EMGs{12,1}= 'Biceps';
pre_EMGs{13,1}= '4L';
pre_EMGs{14,1}= 'Triceps';
%EMG list of post1,post2,post4
EMGs=cell(16,1) ;
EMGs{1,1}= 'IOD-1';
EMGs{2,1}= '2L';
EMGs{3,1}= '3L';
EMGs{4,1}= '4L';
EMGs{5,1}= 'APB';
EMGs{6,1}= 'ADQ';
EMGs{7,1}= 'EDC';
EMGs{8,1}= 'ECR';
EMGs{9,1}= 'BRD';
EMGs{10,1}= 'FCU';
EMGs{11,1}= 'FCR';
EMGs{12,1}= 'FDS';
EMGs{13,1}= 'Biceps';
EMGs{14,1}= 'Triceps';
EMGs{15,1}= 'DLA';
EMGs{16,1}= 'DLM';

%% code section
work_dir = [pwd '/' patient_name];
task_day_list = getDirectoryInfo(work_dir);
disp('[please select Task~.mat file(patient -> day ->)]')
[RawEMG_fileNames,RawEMG_pathName] = selectGUI(patient_name, 'EMG');
yMax_list = zeros(length(EMGs),length(task_day_list)*length(RawEMG_fileNames));

for ii = 1:length(task_day_list)
    parts_list = split(RawEMG_pathName, '/');
    parts_list{end-1} = task_day_list{ii}.name;
    RawEMG_pathName = strjoin(parts_list, '/');
    for jj = 1:length(RawEMG_fileNames)
        try
            load([RawEMG_pathName RawEMG_fileNames{jj}], 'data');
            data = offset(data', 'mean');
            data = data';
            if strcmp(task_day_list{ii}.name, 'pre1') %We have to arrange electrode num
%                 temp = max(data)';
                temp = max_sp(data, [RawEMG_pathName RawEMG_fileNames{jj}])';
                [procedure_matrix,electrode_matrix] = arrange_procedure(EMGs, pre_EMGs);
                yMax_list(1:length(procedure_matrix),jj+length(RawEMG_fileNames)*(ii-1)) = temp(procedure_matrix);
            else
                temp = max_sp(data, [RawEMG_pathName RawEMG_fileNames{jj}])';
                yMax_list(1:length(max(data)'),jj+length(RawEMG_fileNames)*(ii-1)) = temp;
            end
        catch
        end
    end
end
%各筋肉の筋電の最大値を求める
yMax_list = max(yMax_list,[],2);
yMax_list = round_sp(yMax_list);
%データをセーブする
save([work_dir '/' 'yMax_Data.mat'],'yMax_list','electrode_matrix')

%% define local function
function return_value_list = round_sp(input_num)
% this function is to round float num(ex.0.0057 -> 0.006)
return_value_list = zeros(length(input_num),1);
for ii = 1:length(input_num)
    decimal_places = 0; 
    while true
         if input_num(ii) >= 1
             break
         else
             input_num(ii) = input_num(ii) * 10;
             decimal_places = decimal_places + 1;
         end
    end
    return_value_list(ii,1) = round(input_num(ii)) * 10^-(decimal_places);
end
end

function [procedure_matrix,electrode_matrix] = arrange_procedure(EMGs, pre_EMGs)
procedure_matrix = zeros(length(pre_EMGs), 1);
electrode_matrix = zeros(length(pre_EMGs), 1);
for ii = 1:length(pre_EMGs)
    for jj = 1:length(EMGs)
        if strcmp(pre_EMGs{ii},EMGs{jj})
            procedure_matrix(jj) = ii;
            electrode_matrix(ii) = jj;
            break
        end
    end
end
end