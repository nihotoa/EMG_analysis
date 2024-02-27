%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by Naoki Uchida
modified by Naohito Ota

[your operation]
1. Please complete the steps up to pre-procedure (refer to below ([procedure]))
2. Go to the directory named 'data' (directory where this code exists)
3. Change some parameters (please refer to 'set param' section)
4. Please run this code & select data by following guidance (which is displayed in command window after Running this code)

[role of this code]
the role of this code is to perform various processing(trimming for each task-trials, filtering, etc...) to raw EMG data
& save these data

[Saved data location]
1.
location: data/Yachimun/easyData/~_standard/
file_name: ~_EasyData.mat:  timing data & EMGdata (muscle_name: 'EMGs', EMG: 'AllData_EMG', taiming_data: 'Tp')
                 ~_CTcheckData.mat:  about the data of cross-talk of EMG
                 ~_CTR.mat:  about the data of cross-talk of EMG
                 ~_alignedData_uchida: 

2.
location: data/Yachimun/easyData/P-DATA/
file_name: ~_Pdata.mat:  contains some data for synergy analysis (timing_data, trimmed_EMG, etc...)
                 ~_PdataTrigEMG.mat:  (not used in any process)
                 ~_PdataTrigEMG_NDfilt.mat:  (not used in any process)
                 ~_PdataTrigSyn.mat:  (not used in any process)

[procedure]
pre: SaveFileInfo.m
post: plotTarget.m

[caution!!]
Sometimes the function 'uigetfile' is not executed and an error occurs
-> please reboot MATLAB

[Improvement points(Japanaese)]
makeEasyData_all/makeEasyTiming内のSu, Seの条件分岐の意味を把握していない => Sesekiで試す or チュートリアル用のリポジトリを作った後に消す
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
%% set param
task = 'standard'; % you don't need to change
save_fold = 'easyData'; % you don't need to change

% set param for 'makeEasyData_all'
mE = struct();
mE.make_EMG = 1; % whether you want to make EMG data
mE.save_E = 1; % wheter you want to save EMG data
mE.down_E = 1; % whether you want to perform down sampling
mE.make_Timing = 1; % whether you want to make timing data
mE.downdata_to = 5000; % (if down_E ==1)sampling rate of after resampling

% which save pttern?(if you set all of them to 1, there is basically no problem.)
saveP = 1; 
saveE = 1;  
saveS = 1; 
saveE_filt = 1; 

% which monkey?
realname = 'Yachimun';  % 'Wasa', 'Yachimun', 'SesekiL', 'SesekiR', 'Matatabi', 'Nibali' 

%% code section
% get target files(select standard.mat files which contain file information, e.g. file numbers)

easyData_fold_path = fullfile(pwd, realname, 'easyData');
disp(['【Please select files(select all ~_standard.mat of all dates you want to analyze (files path: ' realname ' /easyData/)】'])
[Allfiles_S,path] = uigetfile('*.mat', 'Select One or More Files', 'MultiSelect', 'on', easyData_fold_path);

if not(Allfiles_S)
    disp('user press canceled')
    return
end

%change 'char' to 'cell'
if ischar(Allfiles_S)
    Allfiles_S={Allfiles_S};
end
    
S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S,['_' task '.mat'],'');
%% RUNNING FUNC LIST (make data)
for i = 1:S(2)
   try
        load(fullfile(easyData_fold_path, Allfiles_S{i}), 'fileInfo');
        monkeyname = fileInfo.monkeyname;
        xpdate = fileInfo.xpdate;
        file_num = fileInfo.file_num;
        
        % Perform all preprocessing with 3 functions

        % 1. Perform data concatenation & filtering processing & Obtain information on each timing for EMG trial-by-trial extraction
        [EMGs,Tp,Tp3] = makeEasyData_all(monkeyname, realname, xpdate, file_num, save_fold, mE, task); 

        % 2. Check for cross-talk between measured EMGs
        [Yave,Y3ave] = CTcheck(monkeyname, xpdate, save_fold, 1, task, realname);

        % 3. Cut out EMG for each trial & Focusing on various timings and cut out EMG around them
        [alignedDataAVE,alignedData_all,taskRange,AllT,Timing_ave,TIME_W,Res,D] = plotEasyData_utb(monkeyname, xpdate, save_fold, task, realname);
        
        % create struct(Store the EMG trial average data around each timing in another structure)
        ResAVE.tData1_AVE = Res.tData1_AVE;
        ResAVE.tData2_AVE = Res.tData2_AVE;
        ResAVE.tData3_AVE = Res.tData3_AVE;
        ResAVE.tData4_AVE = Res.tData4_AVE;
        ResAVE.tDataTask_AVE = Res.tDataTask_AVE;
        alignedData_trial.tData1 = Res.tData1;
        alignedData_trial.tData2 = Res.tData2;
        alignedData_trial.tData3 = Res.tData3;
        alignedData_trial.tData4 = Res.tData4;
        alignedData_trial.tDataTask = Res.tDataTask;
        %% save data(location: easyData/P-Data)

        % get folder path & make folder
        P_Data_fold_path = fullfile(easyData_fold_path, 'P-DATA');
        if not(exist(P_Data_fold_path))
            mkdir(P_Data_fold_path)
        end
        
        % save data as .mat file
        if saveP == 1
            % dataset for synergy analysis 
            save(fullfile(P_Data_fold_path, [monkeyname sprintf('%d',xpdate) '_Pdata.mat']), 'monkeyname', 'xpdate', 'file_num','EMGs',...
                                                   'Tp','Tp3',... 
                                                   'Yave','Y3ave',...
                                                   'alignedDataAVE','taskRange','AllT','Timing_ave','TIME_W','ResAVE','D'...,
                                                   );
        end
        if saveE == 1
            %dataset for synergy analysis after'trig data' filtered by TakeiMethod same as his paper
            save(fullfile(P_Data_fold_path, [monkeyname sprintf('%d',xpdate) '_dataTrigEMG.mat']), ...
                                                   'alignedData_trial','alignedData_all',...
                                                   'D'...
                                                   );
        end
        if saveE_filt == 1
            %dataset for synergy analysis after'trig data' filtered by Uchida same as his paper
            save(fullfile(P_Data_fold_path, [monkeyname sprintf('%d',xpdate) '_dataTrigEMG_NDfilt.mat']), ...
                                                   'alignedData_trial','alignedData_all',...
                                                   'D'...
                                                   );
        end
        if saveS == 1
            %dataset for synergy analysis after'trig data' filtered by TakeiMethod same as his paper
            save(fullfile(P_Data_fold_path, [monkeyname sprintf('%d',xpdate) '_dataTrigSyn.mat']), ...
                                                   'alignedData_trial','D'...
                                                   );
        end
   catch exception
      disp(['****** Error occured in ',Allfiles_S{i}]) ; 
      print_error_message(exception)
   end
end

%% define local functon

% Function to describe the error contents when an error occurs
function [] = print_error_message(exception)
disp(['error message: ', exception.message]);
string_cell = cell(length(exception.stack),1);
count = 1;
for ii = length(exception.stack):-1:1
    elements = exception.stack(ii);
    string_cell{count} = [elements.name '.m line ' num2str(elements.line)];
    count = count + 1;
end
delimiter = ' -> ';
result = strjoin(string_cell, delimiter);
disp(['Error location : ' result]);
end