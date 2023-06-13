%{ 
how to use this:
set current directry as 'Yachimun'
please change 'set param' while referencing the RAW_data(ex.)F170516_0002
【function】
get the information which is used for merge data & analyze 

【procedure】
pre: Nothing
post : SAVE4NMF
%}

%% set param
monkeyname = 'F' ;
taskname = 'standard';
save_fold = 'easyData';
file_list = dir([monkeyname '*.mat']);
pat = digitsPattern;
for ii = 1:length(file_list)
    exp_day = extract(file_list(ii).name,pat);
    tarsessions(ii,1) = str2double(exp_day{1});
end
tarsessions = unique(tarsessions);
%tarfiles = {2 4};

%% code section
for tarN = 1:length(tarsessions)
    fileInfo.monkeyname = monkeyname;
    fileInfo.xpdate = tarsessions(tarN);
    ref_file = dir([monkeyname num2str(tarsessions(tarN)) '*.mat']);
    temp_start = extract(ref_file(1).name,pat);
    temp_end = extract(ref_file(end).name,pat);
    tarfiles = [str2double(temp_start{2}) str2double(temp_end{2})];
    fileInfo.file_num = [tarfiles(1),tarfiles(2)];
    save([save_fold '/' monkeyname num2str(tarsessions(tarN)) '_' taskname '.mat'],'fileInfo')
end

