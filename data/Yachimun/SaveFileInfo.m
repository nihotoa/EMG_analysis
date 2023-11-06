%{ 
[your operation]
1. Go to the directory named 'Yachimun' (directory where this code exists)
2. Change some parameters (please refer to 'set param' section)
3. Please run this code

[role of this code]
get the information which is used for merge data


[Saved data location]
location: Yachimun/easyData
file_name: ~_standard.mat (ex.) F170516_standard.mat

[procedure]
pre: Nothing
post : (if you want to conduct synergy analysis) SAVE4NMF.m
       (if you want to conduct EMG analysis) runnningEasyfunc.m
%}
clear;
%% set param
monkeyname = 'Se' ; % prefix of recorded file(ex. F1710516-0002)
taskname = 'standard'; %you don't need to change
save_fold = 'easyData'; %you don't need to change

%% code section
file_list = dir([monkeyname '*.mat']);
for ii = 1:length(file_list)
    exp_day = regexp(file_list(ii).name, '\d+', 'match');
    tarsessions(ii,1) = str2double(exp_day{1});
end
tarsessions = unique(tarsessions);
%tarfiles = {2 4};

for tarN = 1:length(tarsessions)
    fileInfo.monkeyname = monkeyname;
    fileInfo.xpdate = tarsessions(tarN);
    ref_file = dir([monkeyname num2str(tarsessions(tarN)) '*.mat']);
    temp_start = regexp(ref_file(1).name, '\d+', 'match');
    temp_end = regexp(ref_file(end).name, '\d+', 'match');
    tarfiles = [str2double(temp_start{2}) str2double(temp_end{2})];
    fileInfo.file_num = [tarfiles(1),tarfiles(2)];
    save([save_fold '/' monkeyname num2str(tarsessions(tarN)) '_' taskname '.mat'],'fileInfo')
end

