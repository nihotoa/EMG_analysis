%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% coded by Naoki Uchida
% last modification : 2019.05.17
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
%% RUNNING DATA LIST
realname = 'Yachimun'; % name of monkey folder
% global task;
task = 'standard';
save_fold = 'easyData';
Allfiles_S = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S,['_' task '.mat'],'');
%% RUNNING FUNC LIST (make data)
for i = 1:S(2)
    cd([realname '/easyData'])
    load(Allfiles_S{i});
%     load(Allfiles_S);
    cd ../../
    monkeyname = fileInfo.monkeyname;
    xpdate = fileInfo.xpdate;
    file_num = fileInfo.file_num;
    
    [EMGs,ECoGs,Tp,Tp3] = makeEasyData_all(monkeyname,xpdate,file_num,save_fold);

    [Yave,Y3ave] = CTcheck(monkeyname,xpdate,save_fold,1);

    [alignedDataAVE,taskRange,AllT,Timing_ave,TIME_W,Res,D] = plotEasyData(monkeyname, xpdate, 1, 0);
    ResAVE.tData1_AVE = Res.tData1_AVE;
    ResAVE.tData2_AVE = Res.tData2_AVE;
    ResAVE.tData3_AVE = Res.tData3_AVE;
%%
    cd([realname '/easyData/P-DATA'])
    save([monkeyname sprintf('%d',xpdate) '_Pdata.mat'], 'monkeyname', 'xpdate', 'file_num','EMGs','ECoGs',...
                                           'Tp','Tp3',... 
                                           'Yave','Y3ave',...%'Yave':CT results of RAW data,'Y3ave':CT results of 3rd differential data
                                           'alignedDataAVE','taskRange','AllT','Timing_ave','TIME_W','ResAVE','D'...,'tData1','tData2'...%'alignedDataAVE'one day averaged temporal data of task,'taskRange':percentage,'AllT':average time of trial
                                           );
    cd ../../../
end