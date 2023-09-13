%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
% coded by Naoki Uchida
% modified by Naohito Ota

[your operation]
1. Please complete the steps up to pre-procedure (refer to below ([procedure]))
2. Go to the directory named 'data' (directory where this code exists)
3. Change some parameters (please refer to 'set param' section)
4. Please run this code & select data by following guidance (which is displayed in command window after Running this code)

[role of this code]
the role of this code is to perform various processing(trimming for each task-trials, filtering, etc...) to raw EMG data
& save these data

[caution!!]
Sometimes the function 'uigetfile' is not executed and an error occurs
-> please reboot MATLAB

[Saved data location]
location: data -> Yachimun -> easyData -> ~_standard -> here!!
file_name: ~_EasyData.mat -> timing data & EMGdata (muscle_name: 'EMGs', EMG: 'AllData_EMG', taiming_data: 'Tp')
           ~_CTcheckData.mat -> about the data of cross-talk of EMG
           ~_CTR.mat -> about the data of cross-talk of EMG
           ~_alignedData_uchida -> 

(one more file!!)
location: data -> Yachimun -> easyData -> P-DATA -> here!! 
file_name: ~_Pdata.mat -> contains some data for synergy analysis (timing_data, trimmed_EMG, etc...)
           ~_PdataTrigEMG.mat -> not used 
           ~_PdataTrigEMG_NDfilt.mat -> not used
           ~_PdataTrigSyn.mat -> not used

[procedure]
pre: SaveFileInfo.m
post: plotTarget.m
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
%% set param
% which save pttern?(if you set all of them to 1, there is basically no problem.)
saveP = 1; 
saveE = 1;  
saveS = 1; 
saveE_filt = 1; 

% which monkey?
%realname = 'Wasa';
% realname = 'Yachimun'; 
realname = 'SesekiL';
% realname = 'SesekiR';
% realname = 'Matatabi';
% realname = 'Nibali';


%% code section
% get target files(select standard.mat files which contain file information, e.g. file numbers)
global task;
task = 'standard';
save_fold = 'easyData';
disp(['yget target files(select all ~_standard.mat of all dates you want to analyze (location: ' realname ' -> easyData ->) which contain file information, e.g. file numbers)z'])
[Allfiles_S,path] = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
%change 'char' to 'cell'
if ischar(Allfiles_S)
    Allfiles_S={Allfiles_S};
end
    
S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S,['_' task '.mat'],'');
%% RUNNING FUNC LIST (make data)
for i = 1:S(2)
   try
    cd([realname '/easyData'])
    load(Allfiles_S{i});
%     load(Allfiles_S);
    cd ../../
    monkeyname = fileInfo.monkeyname;
    xpdate = fileInfo.xpdate;
    file_num = fileInfo.file_num;
    
    % if successfully done, CTcheckData.mat & EasyData.mat is saved in '~_standard' fold 
    [EMGs,ECoGs,Tp,Tp3] = makeEasyData_all(monkeyname,xpdate,file_num,save_fold); 
    [Yave,Y3ave] = CTcheck(monkeyname,xpdate,save_fold,1);
    [alignedDataAVE,alignedData_all,taskRange,AllT,Timing_ave,TIME_W,Res,D] = plotEasyData_utb(monkeyname, xpdate, 1, 0);
    
    %make data for Pdata & dataTrigEMG
    ResAVE.tData1_AVE = Res.tData1_AVE;
    ResAVE.tData2_AVE = Res.tData2_AVE;
    ResAVE.tData3_AVE = Res.tData3_AVE;
   %this is the cause of error
    ResAVE.tData4_AVE = Res.tData4_AVE;
    ResAVE.tDataTask_AVE = Res.tDataTask_AVE;
    alignedData_trial.tData1 = Res.tData1;
    alignedData_trial.tData2 = Res.tData2;
    alignedData_trial.tData3 = Res.tData3;
    alignedData_trial.tData4 = Res.tData4;
    alignedData_trial.tDataTask = Res.tDataTask;
%%
    if not(exist([realname '/easyData/P-DATA']))
        mkdir([realname '/easyData/P-DATA'])
    end
    cd([realname '/easyData/P-DATA'])
    if saveP == 1
        % dataset for synergy analysis 
        save([monkeyname sprintf('%d',xpdate) '_Pdata.mat'], 'monkeyname', 'xpdate', 'file_num','EMGs','ECoGs',...
                                               'Tp','Tp3',... 
                                               'Yave','Y3ave',...%'Yave':CT results of RAW data,'Y3ave':CT results of 3rd differential data
                                               'alignedDataAVE','taskRange','AllT','Timing_ave','TIME_W','ResAVE','D'...,'tData1','tData2'...%'alignedDataAVE'one day averaged temporal data of task,'taskRange':percentage,'AllT':average time of trial
                                               );
    end
    if saveE == 1
        %dataset for synergy analysis after'trig data' filtered by TakeiMethod same as his paper
        save([monkeyname sprintf('%d',xpdate) '_dataTrigEMG.mat'], ...
                                               'alignedData_trial','alignedData_all',...
                                               'D'...
                                               );
    end
    if saveE_filt == 1
        %dataset for synergy analysis after'trig data' filtered by Uchida same as his paper
        save([monkeyname sprintf('%d',xpdate) '_dataTrigEMG_NDfilt.mat'], ...
                                               'alignedData_trial','alignedData_all',...
                                               'D'...
                                               );
    end
    if saveS == 1
        %dataset for synergy analysis after'trig data' filtered by TakeiMethod same as his paper
        save([monkeyname sprintf('%d',xpdate) '_dataTrigSyn.mat'], ...
                                               'alignedData_trial','D'...
                                               );
    elseif saveS == 2
        %dataset for synergy analysis after'trig data' filtered by TakeiMethod same as his paper
        save([monkeyname sprintf('%d',xpdate) '_dataTrigSyn_filt2.mat'], ...
                                               'alignedData_trial', 'D'...
                                               );
    end
    cd ../../../
   catch exception
      cd(path)
      cd ../../
      disp(['****** Error occured in ',Allfiles_S{i}]) ; 
      print_error_message(exception)
   end
end

%% define local functon
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