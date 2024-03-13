%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
[your operation]
1. Go to the directory named 'new_nmf_result(directory where this file exists)''
2. Please change parameters

[role of this code]
・cut out the temporal pattern of muscle synergy for each trial and put it into array
・save data which is related in displaying temporal synergy
saved location is new_nmf_result -> synData -> (ex.)YaSyn4170630_Pdata.mat

[Saved data location]
location: 
    EMG_analysis/data/Yachimun/new_nmf_result/synData/

[procedure]
pre: dispNMF_W.m
post: plotTarget.m (EMG_analysis/data/plotTarget.m)

[caution!!]
In order to use the function 'resample', 'signal processing toolbox' must be installed

[Improvement points(Japanaese)]
・Kを用いてtestデータを連結させるところがkf=4の前提で書かれているので改善する
・timを求める際のダウンサンプリング後のサンプリング周波数が100Hzの前提で書かれているので改善する
・alignDataと,alignDataEXはmakeEasyData_allと全く同じものを使っているので、ローカル関数ではなくて、独立した関数として作って、
それを読み込んで使うように変更する
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set param
monkeyname = 'F';  % Name prefix of the folder containing the synergy data for each date
synergy_type = 'pre';  % Whether to analyse pre or post synergies. ('pre' / 'post')
% group_num = 2;
synergy_num = 4; % number of synergy you want to analyze
save_data = 1; % whether you want to save data (basically, set 1)

%  Specifying ranges in data cut-outs. (Basically, don't change it)
D.trig1_per = [50 50];
D.trig2_per = [50 50];
D.trig3_per = [50 50];
D.trig4_per = [50 50];
D.task_per = [25,105];

%% code section

% Create a list of folders containing the synergy data for each date.
data_folders = dir(pwd);
folderList = {data_folders([data_folders.isdir]).name};
Allfiles_S = folderList(startsWith(folderList, monkeyname));

% Further refinement by synergy_type
switch synergy_type
    case 'pre'
        Allfiles_S = Allfiles_S(1:4);
    case 'post'
        Allfiles_S = Allfiles_S(5:end);
end

S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S, '_standard','');
AllDays = strrep(Allfiles, monkeyname, '');

% Find the number of EMGs used in the synergy analysis
load(fullfile(pwd, Allfiles_S{1}, [Allfiles_S{1} '.mat']), 'TargetName'); 
EMG_num = length(TargetName);

%% code section

% Create an empty array to store the synergy time pattern (synergy H)
allH = cell(S);

% load order information (as OD)
order_fold_path = fullfile(pwd, 'order_tim_list', [Allfiles{1} 'to' AllDays{end} '_' num2str(length(Allfiles))]);

disp("Please select the file related to order created with 'dispNMF_W.m'");
[fName] = uigetfile(order_fold_path, ['*_' sprintf('%d',synergy_num) '.mat']); 
OD = load(fullfile(order_fold_path, fName));

%% Linking temporal pattern data(synergy H) & arrange order of Synergies between each date.

day_length = S(2);
for ii =1:day_length %session loop
    % Get the path of the data to be accessed.
    synergy_data_fold_path = fullfile(pwd, [Allfiles{ii} '_standard']);
    synergy_data_file_path = ['t_' Allfiles_S{ii} '.mat'];

    H_synergy_data_fold_path = fullfile(synergy_data_fold_path, [Allfiles{ii} '_syn_result_' sprintf('%02d',EMG_num)], [Allfiles{ii} '_H']);
    H_synergy_data_file_name = [Allfiles{ii} '_aveH3_' sprintf('%d',synergy_num) '.mat'];

    % Load data based on PATH.
    % K is the order data required for the linkage of 'test' data to each other.
    K = load(fullfile(H_synergy_data_fold_path, H_synergy_data_file_name), 'k'); 

    % Get 'test' data on the number of synergies of the target & Concatenate all 'test' data for each synergy.
    synergyData = load(fullfile(synergy_data_fold_path, synergy_data_file_path), 'test'); 
    Hdata = synergyData.test.H; % Data on synergy_H at each synergy number.
    altH = [Hdata{synergy_num,1} Hdata{synergy_num,2}(K.k(1,:)',:) Hdata{synergy_num,3}(K.k(2,:)',:) Hdata{synergy_num,4}(K.k(3,:)',:)];

    % Store the concatenated day-by-day synergies in the order of the first day's synergies.
    % Extracting the order of synergies of date(ii) from 'k_arr'
    day_index =  find(OD.days==str2double(AllDays{ii}));
    synergy_order = OD.k_arr(:, day_index); 
    allH{ii} = altH(synergy_order, :);
end


%%  Cut out synergy H around each task timing.

% Creating arrays from which to store data.
ResAVE.tData1_AVE = cell(1,synergy_num);
ResAVE.tData2_AVE = cell(1,synergy_num);
ResAVE.tData3_AVE = cell(1,synergy_num);
ResAVE.tData4_AVE = cell(1,synergy_num);
ResAVE.tDataTask_AVE = cell(1,synergy_num);

% Get the path of the previous level.
[monkey_dir_path, ~, ~] = fileparts(pwd);

% Cutting out synergy H data for each date.
for ii = 1:day_length 
    % get the path of EasyData(which contains each timing data)
    EasyData_fold_path = fullfile(monkey_dir_path, 'easyData', Allfiles_S{ii});
    EasyData_file_name = [Allfiles{ii} '_EasyData.mat'];
   Timing = load(fullfile(EasyData_fold_path, EasyData_file_name),'Tp','Tp3','SampleRate'); % load the timing data of each trial
   tim = floor(Timing.Tp./(Timing.SampleRate/100)); %floor:切り捨て,タイミング信号を100Hzにダウンサンプリング
   [trial_num, ~] = size(tim);
   pre_per = 50; % How long do you want to see the signals before 'lever1 on' starts.
   post_per = 50; % How long do you want to see the signals after 'lever2 off' starts.
   
   % Cut out synergyH for each trial
   [alignedData, alignedDataAVE, AllT, Timing_ave,TIME_W] = alignData(allH{ii}', tim, trial_num, pre_per, post_per, synergy_num);
   taskRange = [-1*pre_per, 100+post_per];

    % Cut out synergyH for each trial, around each timing.
   [Res] = alignDataEX(alignedData, tim, D, pre_per, TIME_W, synergy_num);

   % Store the information about the cut out range around each timing in structure D
   D.Ld1 = length(Res.tData1_AVE{1});
   D.Range1 = D.trig1_per;
   D.Ld2 = length(Res.tData2_AVE{1});
   D.Range2 = D.trig2_per;
   D.Ld3 = length(Res.tData3_AVE{1});
   D.Range3 = D.trig3_per;
   D.Ld4 = length(Res.tData4_AVE{1});
   D.Range4 = D.trig4_per;
   D.LdTask = length(Res.tDataTask_AVE{1});
   D.RangeTask = D.task_per;
   
   % save data
   if save_data == 1
       % Store results in a structure ''ResAVE
       ResAVE.tData1_AVE = Res.tData1_AVE;
       ResAVE.tData2_AVE = Res.tData2_AVE;
       ResAVE.tData3_AVE = Res.tData3_AVE;
       ResAVE.tData4_AVE = Res.tData4_AVE;
       ResAVE.tDataTask_AVE = Res.tDataTask_AVE;
       xpdate = AllDays(ii);

       % Specify the path of the directory to save
       save_data_fold_path = fullfile(pwd, 'synData');
       save_data_file_name = [monkeyname '_Syn' sprintf('%d',synergy_num) '_' AllDays{ii} '_Pdata.mat'];
       
       % save data
       if not(exist(save_data_fold_path))
           mkdir(save_data_fold_path);
       end
       save(fullfile(save_data_fold_path, save_data_file_name), 'monkeyname','xpdate','D',...
                                                         'alignedDataAVE','ResAVE',...
                                                         'AllT','TIME_W','Timing_ave','taskRange');
   end
end

%% define local function
function [alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(Data_in, Timing, trial_num, pre_per, post_per, EMG_num)
%{
this function estimate that Timing is constructed by 6 kinds of timing.
1:start trial
2:lever1 on 
3:lever1 off
4:lever2 on
5:lever2 off
6:success
%}

%Please comfirm this construction is correct.  
Data = Data_in';
per1 = pre_per / 100;
per2 = post_per / 100;

TIME_W = round(sum(Timing(:,5)-Timing(:,2) + 1)/trial_num); % Find mean number of sample in 1 trial
pre1_TIME = round(per1*sum(Timing(:,5)-Timing(:,2) + 1)/trial_num); % Mean number of samples in pre direction
post2_TIME = round(per2*sum(Timing(:,5)-Timing(:,2) + 1)/trial_num);
trialData = cell(trial_num,3);
AllT = pre1_TIME+TIME_W+post2_TIME; % Average number of samples in the range to be trimmed ((pre_per + 100 + post_per)%)

% Create an empty array for the output argument
outData = cell(trial_num,EMG_num);
alignedData = cell(1,EMG_num);
alignedDataAVE = cell(1,EMG_num);

% Time Normalize
for j = 1:EMG_num
    DataA = zeros(trial_num,AllT);
    for i = 1:trial_num
        % Find the number of samples for each trial.
        time_w = round(Timing(i,5) - Timing(i,2) +1);

        % Resampling from average frames of all task (time_w) to the frames of this task(time_W)
        if time_w == TIME_W
            trialData{i,1} = Data(j,floor(Timing(i,2)-time_w*per1):floor(Timing(i,2)-1)); % pre trial data
            trialData{i,2} = Data(j,floor(Timing(i,2)):floor(Timing(i,5))); % trial_data
            trialData{i,3} = Data(j,floor(Timing(i,5)+1):floor(Timing(i,5)+time_w*per2)); % post trial data
        
        elseif time_w<TIME_W 
            trialData{i,1} = interpft(Data(j,floor(Timing(i,2)-time_w*per1):floor(Timing(i,2)-1)),pre1_TIME);
            trialData{i,2} = interpft(Data(j,floor(Timing(i,2)):floor(Timing(i,5))),TIME_W);
            trialData{i,3} = interpft(Data(j,floor(Timing(i,5)+1):floor(Timing(i,5)+time_w*per2)),post2_TIME);
        
        else
            trialData{i,1} = resample(Data(j,floor(Timing(i,2)-time_w*per1):floor(Timing(i,2)-1)),pre1_TIME,round(time_w*per1));
            trialData{i,2} = resample(Data(j,floor(Timing(i,2)):floor(Timing(i,5))),TIME_W,time_w);
            trialData{i,3} = resample(Data(j,floor(Timing(i,5)+1):floor(Timing(i,5)+time_w*per2)),post2_TIME,round(time_w*per2));
        end
        
        % Concatenate pre_trial, trial, post_trial data and save in list
        outData{i,j} = [trialData{i,1} trialData{i,2} trialData{i,3}];
        size_out = size(outData{i,j});

        % Check if the data after concatenation matches AllT(Prevent data length from varying depending on trial)
        if size_out(2) == AllT
            DataA(i,:) = outData{i,j}(1,:);
        else
            DataA(i,:) = resample(outData{i,j}(1,:),AllT,size_out(2));
            outData{i,j} = resample(outData{i,j}(1,:),AllT,size_out(2));
        end
    end 

    % Store each time-normalized EMG data
    alignedData{1,j} = DataA;
    alignedDataAVE{1,j} = mean(DataA,1);
end

% Calculate the average number of samples elapsed from the 'lever1 on' (timing2) to each timing
Ti = [Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2)];
Timing_ave = mean(Timing - Ti);
end

% %----------------------------------------------------------------------------------------------

function [Re] = alignDataEX(Data_in, Timing, Da, pre_per, TIME_W, EMG_num)
%{
% this function estimate that Timing is constructed by 6 kinds of timing.
%1:start trial
%2:lever1 on
%3:lever1 off
%4:lever2 on
%5:lever2 off
%6:success
%}

% Acquisition of data and determination of cropping range
D = Data_in;
pre_per = pre_per/100;
per1 = Da.trig1_per/100;
per2 = Da.trig2_per/100;
per3 = Da.trig3_per/100;
per4 = Da.trig4_per/100;
pertask = Da.task_per/100;

% Formatting timing data
trial_num = length(Timing(:,1));
Ti = [Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2)];
Timing = Timing - Ti;

% Creating an empty array to store data
TimingPer = zeros(trial_num,6);
centerP1 = zeros(trial_num,2);
centerP2 = zeros(trial_num,2);
centerP3 = zeros(trial_num,2);
centerP4 = zeros(trial_num,2);
centerPTask = zeros(trial_num,2);

% Creating a structure for output arguments
Re.tData1 = cell(1,EMG_num);
Re.tData2 = cell(1,EMG_num);
Re.tData3 = cell(1,EMG_num);
Re.tData4 = cell(1,EMG_num);
Re.tDataTask = cell(1,EMG_num);
Re.tData1_AVE = cell(1,EMG_num);
Re.tData2_AVE = cell(1,EMG_num);
Re.tData3_AVE = cell(1,EMG_num);
Re.tData4_AVE = cell(1,EMG_num);
Re.tDataTask_AVE = cell(1,EMG_num);


for m = 1:EMG_num
    tD1 = cell(trial_num,1);
    tD2 = cell(trial_num,1);
    tD3 = cell(trial_num,1);
    tD4 = cell(trial_num,1);
    tDTask = cell(trial_num,1);

    % For each trial, extract the EMG value centered at each timing.
    for i = 1:trial_num
        % Time elapsed from 'lever1 on' to each timing, assuming time elapsed from 'lever1 on' to 'lever2 off' as 1
        TimingPer(i,:) = Timing(i,:)./Timing(i,5);

        % Find the reference point for each timing (note that pre_per + TimingPer(i,j) is the center of timing j in trial i)
        ref_P1 = pre_per + TimingPer(i,2); % 
        ref_P2 = pre_per + TimingPer(i,3);
        ref_P3 = pre_per + TimingPer(i,4);
        ref_P4 = pre_per + TimingPer(i,5);

        % Setting the cropping range around each timing(P1(lever1 on) ~ P4(lever2 off))
        centerP1(i,:) = [round((ref_P1 - per1(1)) * TIME_W + 1), floor((ref_P1 + per1(2)) * TIME_W - 1)]; % Centered around 'lever1 on'
        centerP2(i,:) = [round((ref_P2 - per2(1)) * TIME_W + 1), floor((ref_P2 + per2(2)) * TIME_W - 1)]; % Centered around 'lever1 off'
        centerP3(i,:) = [round((ref_P3 - per3(1)) * TIME_W + 1), floor((ref_P3 + per3(2)) * TIME_W - 1)]; % Centered around 'lever2 on'
        centerP4(i,:) = [round((ref_P4 - per4(1)) * TIME_W + 1), floor((ref_P4 + per4(2)) * TIME_W - 1)]; % Centered around 'lever2 off'
        centerPTask(i,:) = [round((ref_P1-pertask(1)) * TIME_W + 1), floor((ref_P1 + pertask(2)) * TIME_W - 1)]; % Centered around 'lever1 on'

        % Cut out EMG according to the set range
        tD1{i,1} = D{1,m}(i, centerP1(i,1):centerP1(i,2));
        tD2{i,1} = D{1,m}(i, centerP2(i,1):centerP2(i,2));
        tD3{i,1} = D{1,m}(i, centerP3(i,1):centerP3(i,2));
        tD4{i,1} = D{1,m}(i, centerP4(i,1):centerP4(i,2));
        tDTask{i,1} = D{1, m}(i, centerPTask(i, 1):centerPTask(i, 2));
    end

    Re.slct = cell(5,1);
    [tD1, Re.slct{1}]=AlignDatasets(tD1,round(TIME_W*sum(per1)),'row');
    [tD2, Re.slct{2}]=AlignDatasets(tD2,round(TIME_W*sum(per2)),'row');
    [tD3, Re.slct{3}]=AlignDatasets(tD3,round(TIME_W*sum(per3)),'row');
    [tD4, Re.slct{4}]=AlignDatasets(tD4,round(TIME_W*sum(per4)),'row');
    [tDTask, Re.slct{5}]=AlignDatasets(tDTask,round(TIME_W*sum(pertask)),'row');
    Re.tData1{m} = cell2mat(tD1);
    Re.tData1_AVE{m} = mean(Re.tData1{m});
    Re.tData2{m} = cell2mat(tD2);
    Re.tData2_AVE{m} = mean(Re.tData2{m});
    Re.tData3{m} = cell2mat(tD3);
    Re.tData3_AVE{m} = mean(Re.tData3{m});
    Re.tData4{m} = cell2mat(tD4);
    Re.tData4_AVE{m} = mean(Re.tData4{m});
    Re.tDataTask{m} = cell2mat(tDTask);
    Re.tDataTask_AVE{m} = mean(Re.tDataTask{m});
end

end