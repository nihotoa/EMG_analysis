%This program is analysis for EMG averaging


clear
%% set file name and so on
monkeyname = 'Wa' ; 
xpdate = '181114'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [5,6];
selEMGs=[1:14];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
EMGs=cell(14,1) ;
EMGs{1,1}= 'Delt';
EMGs{2,1}= 'Biceps';
EMGs{3,1}= 'Triceps';
EMGs{4,1}= 'BRD';
EMGs{5,1}= 'cuff';
EMGs{6,1}= 'ED23';
EMGs{7,1}= 'ED45';
EMGs{8,1}= 'ECR';
EMGs{9,1}= 'ECU';
EMGs{10,1}= 'EDC';
EMGs{11,1}= 'FDS';
EMGs{12,1}= 'FDP';
EMGs{13,1}= 'FCU';
EMGs{14,1}= 'FCR';
a = cummax(selEMGs,'reverse');
EMG_num = a(1,1);


ex_CTTL = 0;
ex_CStimMarker = 1;
% stim_type = ['ICMS16-11_' sprintf('%02d',file_num(1))];%SRstim,ICMS,EMGstim
% stim_type = 'ICMS1000';
%stim_type = 'ICMS19-29';
stim_type = 'SRstim';
save_fold = 'new_nmf_result';
save_data = 1;

%% cut  data on stim timing
if ex_CTTL==1
    get_first_portin = 1;
    for i = file_num(1,1):file_num(1,length(file_num))
        if get_first_portin
            load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CTTL*');
            CTTL = cell(length(file_num));
            CTTL{1} = CTTL_001_Up;
            CTTL_Time = zeros(2);
            CTTL_Time(1) = CTTL_001_TimeBegin;
            CTTL_Time(2) = CTTL_001_TimeEnd;
            CTTL_KHz = CTTL_001_KHz;
        else
            load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CTTL*');
            CTTL{i-file_num(1)+1} = CTTL_001_Up;
            CTTL_Time(2) = CTTL_001_TimeEnd;
        end
        if i == file_num(1,1)
            AllCTTL = CTTL{i-file_num(1)+1};
        else
            AllCTTL = [AllCTTL,CTTL{i-file_num(1)+1}];
        end
        get_first_portin = 0;
    end
end

if ex_CStimMarker==1
    load([monkeyname xpdate '-' sprintf('%04d', file_num(1)) '.mat'], 'CStimMarker*');
    CStimMarker0 = CStimMarker_001;
    CStimMarker_KHz = CStimMarker_001_KHz;
     get_first_portin = 1;
     for i = file_num(1,1):file_num(1,length(file_num))
         if get_first_portin
             load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CStimMarker*');
             CStimMarker0 = cell(length(file_num));
             CStimMarker0{1} = CStimMarker_001;
 %             CStimMarker_Time = zeros(2);
 %             CStimMarker_Time(1) = CStimMarker_001_TimeBegin;
 %             CStimMarker_Time(2) = CStimMarker_001_TimeEnd;
             CStimMarker_KHz = CStimMarker_001_KHz;
         else
             load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CStimMarker*');
             CStimMarker0{i-file_num(1)+1} = CStimMarker_001;
 %             CStimMarker_Time(2) = CStimMarker_001_TimeEnd;
         end
         if i == file_num(1,1)
             CStimMarker = CStimMarker0{i-file_num(1)+1};
         else
             CStimMarker = [CStimMarker,CStimMarker0{i-file_num(1)+1}];
         end
         get_first_portin = 0;
     end
end



%% save data
if save_data == 1;
    cd(save_fold)
    cd([monkeyname xpdate])
    cd([monkeyname xpdate '_' stim_type])
    if ex_CTTL ==1
        TimeRange = [CTTL_Time(1)*CTTL_KHz*1000, CTTL_Time(2)*CTTL_KHz*1000];
        Name = 'stim_Timing';
        SampleRate = CTTL_KHz * 1000;
        Unit = 'data_num(CTTL_Hz)';
        save([monkeyname xpdate '_Stim_Timing_CTTL.mat'], 'TimeRange', 'Name', 'SampleRate_CTTL','AllCTTL', 'Unit');
    end
    if ex_CStimMarker ==1
%         TimeRange = [CStimMarker_Time(1)*CStimMarker_KHz*1000, CStimMarker_Time(2)*CStimMarker_KHz*1000];
        Name = 'stim_Timing';
        SampleRate_CStimMarker = CStimMarker_KHz * 1000;
        Unit = 'data_num(CStimMarker_Hz)';
        save([monkeyname xpdate '_Stim_Timing_CStimMarker.mat'], 'Name', 'SampleRate_CStimMarker', 'CStimMarker', 'Unit');
    end
    cd ../
    cd ../
    cd ../
end