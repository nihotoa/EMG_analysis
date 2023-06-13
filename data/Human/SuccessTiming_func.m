%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Last modification:2023.05.01
Coded by: Naohito Ota
【procedure】
・pre:ReadCsv.m
・post:EXtractMotionData.m and temp_SynergyAnalysis.m
【function】
・手動でタスクのstart,endを見つけて，それぞれのタイミング情報を.matファイルで出力
・タスクごとに作る必要がある
(保存場所はpatient -> date -> task)
【注意点】
・macbookから回すと，pause中のGUI操作がなぜかできないので，plotとpauseの間にデバッガーをおいて
　解析する
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
SamplingRate = 100;
%% code section
select_dir = [pwd '/' patient_name];
disp('【please select Traj.mat file (patient -> day ->)】')
[fileNames,pathName] = selectGUI(patient_name, 'Trajectry');
if ischar(fileNames)
    temp = fileNames;
    clear fileNames;
    fileNames{1} = temp;
end
for task_num = 1:length(fileNames)
    fileName = fileNames{task_num};
    load([pathName fileName])
    for ii = 1:2 %start/end
        fig = figure('position', [100, 100, 1600, 1000]);
        for jj = 1:3 % x, y, z
            subplot(3,1,jj)
            hold on;
            plot(data(:,jj))
            hold off;
        end
        if ii == 1
            disp('【start位置をすべて選んだ後に後述の操作をした後，Enterを押してください】')
        else
            disp('【end位置をすべて選んだ後に後述の操作をした後，Enterを押してください】')
        end
        disp('【plotwindow上で右クリック → カーソルデータをワークスペースにエクスポート】')
        pause;
        cursor_info;
        timing_data = create_timing(cursor_info);
        all_timing_data{ii,1} = timing_data;
        close all;
    end
    all_timing_data = cell2mat(all_timing_data);
    task_name = strrep(fileName ,'_Traj.mat', '');  
    save([pathName task_name '_timing.mat'], 'all_timing_data', 'SamplingRate')
    clear all_timing_data
end


%% define local function
function timing_data = create_timing(cursor_info)
for jj = 1:length(cursor_info)
    timing_data(1,jj) = round(cursor_info(jj).Position(1));
end
timing_data = sort(timing_data);
end
