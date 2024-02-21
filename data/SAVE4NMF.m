%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
[your operation]
1. Go to the directory named 'Data' (directory where this code exists)
2. Change some parameters (please refer to 'set param' section)
3. Please run this code

[role of this code]
concatenate & create one-day EMG data (with resampling(5000Hz)) & save individual muscle data as '(uv).mat' 

[Saved data location]
location: Yachimun/new_nmf_result/'~_standard' (ex.) F170516_standard
file name: muscle_name(uV).mat (ex.) PL(uV).mat

[procedure]
pre:SaveFileInfo
post:filterBat_SynNMFPre.m

[Improvement points(Japanaese)]
ファイルを連結する時に, 連番じゃ無いものは対応していないことを念頭に置いておく
(例)file 002, file004が使用するファイルだった時にはエラー吐く(002, 003, 004をloadしようとするから)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set param
real_name = 'Yachimun'; % Name of the directory containing the data you want to analyze
task = 'standard'; % you don't need to change this parameter
% parameters used in local function(MakeData4nmf)
param_struct = struct();
param_struct.save_fold = 'new_nmf_result';
param_struct.downsample = 1; % whether you want to perform down sampling(1 or 0)
param_struct.downdata_to =5000; % Sampling frequency after down sapling
param_struct.make_EMG = 1; % whether you want to make EMG data(1 or 0)
param_struct.save_EMG = 1; % whether you want to save EMG data(1 or 0)
% as for ECoG analysis
param_struct.save_fold_ECoG = 'ECoGData';
param_struct.make_ECoG = 0; % whether you want to make ECoG data(1 or 0)
param_struct.save_ECoG = 0; % whether you want to save ECoG data(1 or 0)

%% code section
% read '~standard.mat'
disp(['Please select standard.mat for the date you want to analyze(multiple slelections possible)(location:' real_name ' /easyData/~_standard.mat)']);
TarSessions = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
if iscell(TarSessions)
   S = size(TarSessions);
   elseif ischar(TarSessions)
      S = [1,1];
      TarSessions = cellstr(TarSessions);
end
session_num = S(2);% number of files you selected
AllSessions = strrep(TarSessions,['_' task '.mat'],'');

easy_data_fold_path = fullfile(pwd, real_name, 'easyData');
for s = 1:session_num
   load(fullfile(easy_data_fold_path, [AllSessions{s} '_' task '.mat']), 'fileInfo'); 

   % concatenate experiment data and save each EMG as individual file
   MakeData4nmf(fileInfo.monkeyname, real_name, sprintf('%d',fileInfo.xpdate), fileInfo.file_num, task, param_struct)
   disp(['finish making data file for nmf : ' real_name '-' AllSessions{s} ])
end

%% define local function

% [role of this function] catenate experiment data and save each EMG as individual file
function [output_args] = MakeData4nmf(monkeyname, real_name, xpdate, file_num, task, param_struct)
% Make EMG set(define muscle names for each electrode)
switch real_name
    case 'Wasa'
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
    case 'Yachimun'
        selEMGs=[1:12];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,3) ;
        EMGs{1,1}= 'FDP';
        EMGs{2,1}= 'FDSprox';
        EMGs{3,1}= 'FDSdist';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'PL';
        EMGs{6,1}= 'FCR';
        EMGs{7,1}= 'BRD';
        EMGs{8,1}= 'ECR';
        EMGs{9,1}= 'EDCprox';
        EMGs{10,1}= 'EDCdist';
        EMGs{11,1}= 'ED23';
        EMGs{12,1}= 'ECU';
    case 'Suruku'
        selEMGs=[1:12];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,3) ;
        EMGs{1,1}= 'FDS';
        EMGs{2,1}= 'FDP';
        EMGs{3,1}= 'FCR';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'PL';
        EMGs{6,1}= 'BRD';
        EMGs{7,1}= 'EDC';
        EMGs{8,1}= 'ED23';
        EMGs{9,1}= 'ED45';
        EMGs{10,1}= 'ECU';
        EMGs{11,1}= 'ECR';
        EMGs{12,1}= 'Deltoid';
   case 'SesekiR'
        selEMGs=[1:12];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,3) ;
        EMGs{1,1}= 'EDC';
        EMGs{2,1}= 'ED23';
        EMGs{3,1}= 'ED45';
        EMGs{4,1}= 'ECU';
        EMGs{5,1}= 'ECR';
        EMGs{6,1}= 'Deltoid';
        EMGs{7,1}= 'FDS';
        EMGs{8,1}= 'FDP';
        EMGs{9,1}= 'FCR';
        EMGs{10,1}= 'FCU';
        EMGs{11,1}= 'PL';
        EMGs{12,1}= 'BRD';
   case 'SesekiL'
        selEMGs=[1:12];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,3) ;
        EMGs{1,1}= 'EDC';
        EMGs{2,1}= 'ED23';
        EMGs{3,1}= 'ED45';
        EMGs{4,1}= 'ECU';
        EMGs{5,1}= 'ECR';
        EMGs{6,1}= 'Deltoid';
        EMGs{7,1}= 'FDS';
        EMGs{8,1}= 'FDP';
        EMGs{9,1}= 'FCR';
        EMGs{10,1}= 'FCU';
        EMGs{11,1}= 'PL';
        EMGs{12,1}= 'BRD';
   case 'Matatabi'
        Mn = 8;
        selEMGs=1:Mn;
        EMGs=cell(Mn,1) ;
        EMGs{1,1}= 'EDC';
        EMGs{2,1}= 'ECR';
        EMGs{3,1}= 'BRD_1';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'FCR';
        EMGs{6,1}= 'BRD_2';
        if Mn == 8
           EMGs{7,1}= 'FDPr';
           EMGs{8,1}= 'FDPu';
        end
end
EMG_num = length(EMGs);

% set param
save_fold = param_struct.save_fold;
save_fold_ECoG = param_struct.save_fold_ECoG;
downsample = param_struct.downsample;
downdata_to =param_struct.downdata_to;
make_EMG = param_struct.make_EMG;
save_EMG = param_struct.save_EMG ;
make_ECoG = param_struct.make_ECoG;
save_ECoG = param_struct.save_ECoG;
%% create EMG All Data matrix
if make_EMG == 1
    AllData_EMG_sel = cell(length(file_num),1);
    load([monkeyname xpdate '-' sprintf('%04d',file_num(1,1)) '.mat'],'CEMG_001_TimeBegin');
    TimeRange = zeros(1,2);
    TimeRange(1,1) = CEMG_001_TimeBegin;
    get_first_data = 1; % whether jj==1 or not

    for i = file_num(1,1):file_num(1,length(file_num)) % Loop according to file number
        for j = 1:length(selEMGs) % Perform processing for each EMG
            % Load RAW data
            load(fullfile(pwd, real_name, [monkeyname xpdate '-' sprintf('%04d',i) '.mat']), ['CEMG_' sprintf('%03d',j)]);
            if get_first_data
                % compile information common to all EMGs
                load(fullfile(pwd, real_name, [monkeyname xpdate '-' sprintf('%04d',i) '.mat']), 'CEMG_001*');
                EMG_Hz = CEMG_001_KHz .* 1000;
                Data_num_EMG = length(CEMG_001);
                % make an empty array to summarize all EMG data from file now focused on
                AllData1_EMG = zeros(Data_num_EMG, EMG_num);
                AllData1_EMG(:,1) = CEMG_001';
                get_first_data = 0;
            else
                % Assign EMG data from j th electrode to prepared array
                load([monkeyname xpdate '-' sprintf('%04d',i) '.mat'],['CEMG_0' sprintf('%02d',j)]);
                eval(['AllData1_EMG(:, j ) = CEMG_0' sprintf('%02d',j) ''';']);
            end
        end

        % Assign AllData1_EMG to empty cell array (for concatenate)
        if i == file_num(1,1)
            AllData_EMG_sel{1,1} = AllData1_EMG;
        else
            AllData_EMG_sel{1+i-file_num(1,1),1} = AllData1_EMG;
        end

        % Assign the time when recording of this file ended to TimeRange(1, 2)
        load([monkeyname xpdate '-' sprintf('%04d',i)],'CEMG_001_TimeEnd')
        TimeRange(1,2) = CEMG_001_TimeEnd;
        get_first_data = 1;
    end

    % concatenate EMG from all files for xpdate
    AllData_EMG = cell2mat(AllData_EMG_sel);

    % Down sample these EMG data (from 'EMG_Hz'[Hz] to 'down_data_to'[Hz])
    if downsample==1
        AllData_EMG = resample(AllData_EMG,downdata_to,EMG_Hz);
    end
end
%% save EMG data as .mat file for nmf

if save_EMG == 1
    common_save_fold_path = fullfile(pwd, real_name, save_fold);
   save_fold_path = fullfile(common_save_fold_path, [monkeyname xpdate '_' task]);
   if not(exist(save_fold_path))
       mkdir(save_fold_path)
   end
        % save each muscle EMG data to a file
        for i = 1:EMG_num
            Name = cell2mat(EMGs(i,1));
            Class = 'continuous channel';
            SampleRate = downdata_to;
            Data = AllData_EMG(:, i)';
            Unit = 'uV';
            save(fullfile(save_fold_path, [cell2mat(EMGs(i,1)) '(uV).mat']), 'TimeRange', 'Name', 'Class', 'SampleRate', 'Data', 'Unit');
        end
end
%% create ECoG All Data matrix
if make_ECoG ==1
    %ECoG set
    ECoGs = {'CRAW_001';'CRAW_002';'CRAW_003';'CRAW_004';'CRAW_005';'CRAW_006';'CRAW_007';'CRAW_008';'CRAW_009';'CRAW_010';...
               'CRAW_011';'CRAW_012';'CRAW_013';'CRAW_014';'CRAW_015';'CRAW_016';'CRAW_017';'CRAW_018';'CRAW_019';'CRAW_020';...
               'CRAW_021';'CRAW_022';'CRAW_023';'CRAW_024';'CRAW_025';'CRAW_026';'CRAW_027';'CRAW_028';'CRAW_029';'CRAW_030';...
               'CRAW_031';'CRAW_032';'CRAW_033';'CRAW_034';'CRAW_035';'CRAW_036';'CRAW_037';'CRAW_038';'CRAW_039';'CRAW_040';...
               'CRAW_041';'CRAW_042';'CRAW_043';'CRAW_044';'CRAW_045';'CRAW_046';'CRAW_047';'CRAW_048';'CRAW_049';'CRAW_050';...
               'CRAW_051';'CRAW_052';'CRAW_053';'CRAW_054';'CRAW_055';'CRAW_056';'CRAW_057';'CRAW_058';'CRAW_059';'CRAW_060';...
               'CRAW_061';'CRAW_062';'CRAW_063';'CRAW_064'};
    ECoG_num = length(ECoGs);
    AllData_ECoG_sel = cell(length(file_num),1);
    load([monkeyname xpdate '-' sprintf('%04d',file_num(1,1))],'CRAW_001_TimeBegin');
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
%             AllData_ECoG = AllData1_ECoG;
            AllData_ECoG_sel{1,1} = AllData1_ECoG;
        else
%             AllData_ECoG = [AllData_ECoG; AllData1_ECoG];
            AllData_ECoG_sel{1+i-file_num(1,1),1} = AllData1_ECoG;
        end
        AllData_ECoG = cell2mat(AllData_ECoG_sel);
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

end

