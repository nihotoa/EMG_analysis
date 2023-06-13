%make data(5kHz)
clear
%% set file name and so on
monkeyname = 'Wa' ; 
real_name = 'Wasa';
xpdate = '181207'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [2:2];
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

%ECoG set
selECoGs=(1:64);
ECoGs = {'CRAW_001';'CRAW_002';'CRAW_003';'CRAW_004';'CRAW_005';'CRAW_006';'CRAW_007';'CRAW_008';'CRAW_009';'CRAW_010';...
           'CRAW_011';'CRAW_012';'CRAW_013';'CRAW_014';'CRAW_015';'CRAW_016';'CRAW_017';'CRAW_018';'CRAW_019';'CRAW_020';...
           'CRAW_021';'CRAW_022';'CRAW_023';'CRAW_024';'CRAW_025';'CRAW_026';'CRAW_027';'CRAW_028';'CRAW_029';'CRAW_030';...
           'CRAW_031';'CRAW_032';'CRAW_033';'CRAW_034';'CRAW_035';'CRAW_036';'CRAW_037';'CRAW_038';'CRAW_039';'CRAW_040';...
           'CRAW_041';'CRAW_042';'CRAW_043';'CRAW_044';'CRAW_045';'CRAW_046';'CRAW_047';'CRAW_048';'CRAW_049';'CRAW_050';...
           'CRAW_051';'CRAW_052';'CRAW_053';'CRAW_054';'CRAW_055';'CRAW_056';'CRAW_057';'CRAW_058';'CRAW_059';'CRAW_060';...
           'CRAW_061';'CRAW_062';'CRAW_063';'CRAW_064'};
ECoG_num = length(ECoGs);

downsample = 1;
downdata_to =5000;

%data
save_fold = 'new_nmf_result';
save_fold_ECoG = 'ECoGData';
make_EMG = 1;
save_EMG = 1;
make_ECoG = 0;
save_ECoG = 0;

%% create EMG All Data matrix

if make_EMG == 1
    load([monkeyname xpdate '-' sprintf('%04d',file_num(1,1))],'CEMG_001_TimeBegin');
    TimeRange = zeros(1,2);
    TimeRange(1,1) = CEMG_001_TimeBegin;
    get_first_data = 1;
    for i = file_num(1,1):file_num(1,length(file_num))
        for j = 1:length(selEMGs)
            load([monkeyname xpdate '-' sprintf('%04d',i) '.mat'],['CEMG_0' sprintf('%02d',j)]);
            if get_first_data
                load([monkeyname xpdate '-' sprintf('%04d',i)],'CEMG_001*');
                EMG_Hz = CEMG_001_KHz .* 1000;
                Data_num_EMG = length(CEMG_001);
                AllData1_EMG = zeros(Data_num_EMG, EMG_num);
                AllData1_EMG(:,1) = CEMG_001';
                get_first_data = 0;
            else
                load([monkeyname xpdate '-' sprintf('%04d',i)],['CEMG_0' sprintf('%02d',j)]);
                eval(['AllData1_EMG(:, j ) = CEMG_0' sprintf('%02d',j) ''';']);
            end
        end
        if i == file_num(1,1)
            AllData_EMG = AllData1_EMG;
        else
            AllData_EMG = [AllData_EMG; AllData1_EMG];
        end
        load([monkeyname xpdate '-' sprintf('%04d',i)],'CEMG_001_TimeEnd')
        TimeRange(1,2) = CEMG_001_TimeEnd;
        get_first_data = 1;
    end
    if downsample==1
        AllData_EMG = resample(AllData_EMG,downdata_to,EMG_Hz);
    end
end
%% save EMG data as .mat file for nmf

if save_EMG == 1
    % Data = zeros(1, length(AllData_EMG(:,1)));
    load([monkeyname xpdate '-0002'],'CEMG_001*');
    % mkdir([rael_name xpdate '_EMG_for_nmf']);
    cd(save_fold)
    cd([monkeyname xpdate]) 
        for i = 1:EMG_num
          
            Name = cell2mat(EMGs(i,1));
            Class = 'continuous channel';
            SampleRate = downdata_to;
            Data = AllData_EMG(:, i)';
            Unit = 'uV';
            save([ cell2mat(EMGs(i,1)) '(uV).mat'], 'TimeRange', 'Name', 'Class', 'SampleRate', 'Data', 'Unit');
        end
    cd ../
    cd ../
end
%% create ECoG All Data matrix
if make_ECoG ==1
    get_first_data = 1;
    for i = file_num(1,1):file_num(1,length(file_num))
        for j = 1:length(ECoGs)
            load([monkeyname xpdate '-' sprintf('%04d',i) '.mat'],['CRAW_0' sprintf('%02d',j)]);
            if get_first_data
                load([monkeyname xpdate '-' sprintf('%04d',i)],'CRAW_001*');
                TimeRange = zeros(1,2);
                TimeRange(1,1) = CRAW_001_TimeBegin;
                ECoG_Hz = CRAW_001_KHz .* 1000;
                Data_num_ECoG = length(CRAW_001);
                AllData1_ECoG = zeros(Data_num_ECoG, ECoG_num);
                AllData1_ECoG(:,1) = CRAW_001';
                get_first_data = 0;
            else
                load([monkeyname xpdate '-' sprintf('%04d',i)],['CRAW_0' sprintf('%02d',j)]);
                eval(['AllData1_ECoG(:, j ) = CRAW_0' sprintf('%02d',j) ''';']);
            end
        end
        if i == file_num(1,1)
            AllData_ECoG = AllData1_ECoG;
        else
            AllData_ECoG = [AllData_ECoG; AllData1_ECoG];
        end
        load([monkeyname xpdate '-' sprintf('%04d',i)],'CRAW_001_TimeEnd')
        TimeRange(1,2) = CRAW_001_TimeEnd;
        get_first_data = 1;
    end
end
%% down data
%[5]downsampling settings
if save_ECoG == 1
    downsample = 1;
    downdata_to = 5000; %sampling frequency [Hz]

    if downsample==1
        filtData = resample(AllData_ECoG,downdata_to,ECoG_Hz);
    end
end
%% save ECoG data as .mat file for nmf

if save_ECoG == 1
    % Data = zeros(1, length(AllECoGData(:,1)));
    load([monkeyname xpdate '-0002'],'CRAW_001*');
    % mkdir([rael_name xpdate '_ECoG_for_nmf']);
    cd(save_fold_ECoG)
    cd([monkeyname xpdate]) 
        for i = 1:ECoG_num

            Name = cell2mat(ECoGs(i,1));
            Class = 'continuous channel';
            SampleRate = downdata_to;
            Data = filtData(:, i)';
            Unit = 'uV';
            save([ cell2mat(ECoGs(i,1)) '(uV)-ds5kHz.mat'], 'TimeRange', 'Name', 'Class', 'SampleRate', 'Data', 'Unit');
        end
    cd ../
    cd ../
end