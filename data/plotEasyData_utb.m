%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
% coded by Naoki Uchida
% modified by Naohito Ota
% last modification : 2024.02.26
this code is used in 'runnningEasyfunc.m'
[role of this function]
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [alignedDataAVE,alignedData,taskRange,AllT,Timing_ave,TIME_W,Res,D] = plotEasyData_utb( monkeyname, xpdate_num, save_fold, task ,real_name)
%% get informations(path of save_folder, EMG data, timing data ,etc...)
xpdate = sprintf('%d',xpdate_num);
disp(['START TO MAKE & SAVE ' monkeyname xpdate '_Plot Data']);

% get the path of save_fold
save_fold_path = fullfile(pwd, real_name, save_fold, [monkeyname xpdate '_' task]);

%load EasyData
S = load(fullfile(save_fold_path, [monkeyname xpdate '_EasyData.mat'])); 

% get EMG data & timing data & SamplingRate 
EMGd = S.AllData_EMG;
TimingT1 = S.Tp;
SR = S.SampleRate;

EMGs = S.EMGs; % name list of EMG
EMG_num = length(EMGs);% the number of EMGs
TimingT1 = TimingT1(1:end-1,:);
[trial_num, ~] = size(TimingT1);  % number of success trial 

%% filter EMG
filt_mode = 3;% the method of filter(1: Takei method, 2: Roland method, 3: Uchida method)
[filtData_EMG,Timing_EMG,filtP] = filterEMG(EMGd,filt_mode,SR,EMG_num,TimingT1);

%% Cut out EMG data for each trial(& perform time normalization(Normalize from 'lever1 on' to 'lever1 off' as 100%))

%define time window
pre_per = 50; % How long do you want to see the signals before 'lever1 on' starts.
post_per = 50; % How long do you want to see the signals after 'lever2 off' starts.

% Trim EMG data for each trial & perform time normalization for each trial
[alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(filtData_EMG, Timing_EMG,trial_num,pre_per,post_per, EMG_num);

% Setting the range to be cut out around each timing
taskRange = [-1*pre_per, 100+post_per];
D.trig1_per = [50 50];
D.trig2_per = [50 50];
D.trig3_per = [50 50];
D.trig4_per = [50 50];
D.task_per = [25,105];

% Centering on each timing, trim & get EMG data around it
[Res] = alignDataEX(alignedData,Timing_EMG, D,pre_per,TIME_W,EMG_num);

% Summary of trimming details(length of trimmed data, cut out range around each timing)
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
D.filtP = filtP;

% save data
save(fullfile(save_fold_path, [monkeyname xpdate '_alignedData_' filtP.whose '.mat']), 'monkeyname', 'xpdate','EMGs', ...
                                          'alignedData', 'alignedDataAVE','filtP','trial_num','taskRange','Timing_ave'...
                                                  );

disp(['END TO MAKE & SAVE ' monkeyname xpdate '_Plot Data']);
end

function [filtData,newTiming,filtP] = filterEMG(filtData,filt_mode,SR,EMG_num,Timing)
%{
explanation of output arguments:
filtData: EMG data after filtering
newTiming: Timing data for filtered EMG (supports downsampling)
filtP: A structure containing content about the filter contents, such as the cutoff frequency of a high-pass filter
%}

switch filt_mode
    case 1 %Takei filter
        filt_h = 50; %cut off frequency [Hz]
        filt_l = 20; %cut off frequency [Hz]
        np = 100;%smooth num
        kernel = ones(np,1)/np; 
        downdata_to = 100; %sampling frequency [Hz]
        
        for i = 1:EMG_num
            filtData(:,i) = filtData(:,i)-mean(filtData(:,i));
        end
        
        [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
        for i = 1:EMG_num
            filtData(:,i) = filter(B,A,filtData(:,i));
        end

        filtData = abs(filtData);

        [B,A] = butter(6, (filt_l .* 2) ./ SR, 'low');
        for i = 1:EMG_num
            filtData(:,i) = filter(B,A,filtData(:,i));
        end

        for i = 1:EMG_num
    %     filtData = smooth(filtData,1,'movmean',smooth_num);
            filtData(:,i) = conv2(filtData(:,i),kernel,'same');
        end

        filtData = resample(filtData,downdata_to,SR);
        newSR = downdata_to;
        newTiming = Timing*newSR/SR;
        filtP = struct('whose','TTakei','Hp',filt_h, 'Rect','on','Lp',filt_l,'smooth',np,'down',downdata_to);
    case 2 %Roland filter
        np = round(5000*0.22);%smooth num
        kernel = ones(np,1)/np; 
        downdata_to = 1000; %sampling frequency [Hz]

        for i=1:EMG_num
            filtData(:,i) = abs(filtData(:,i)-mean(filtData(:,i)));
        end

        for i = 1:EMG_num
            filtData(:,i) = conv2(filtData(:,i),kernel,'same');
        end

        filtData = resample(filtData,downdata_to,SR);
        newSR = downdata_to;
        newTiming = Timing*newSR/SR;
        filtP = struct('whose','Roland','Hp','no', 'Rect','on','Lp','no','smooth',np,'down',downdata_to);
   case 3 %Uchida filtfilt
        filt_h = 50; %cut off frequency [Hz]
        filt_l = 20; %cut off frequency [Hz]
        downdata_to = 100; %sampling frequency [Hz]
        
        % offset
        for i = 1:EMG_num
            filtData(:,i) = filtData(:,i)-mean(filtData(:,i));
        end

        %high-pass filter
        [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
 
        for i = 1:EMG_num
            filtData(:,i) = filtfilt(B,A,filtData(:,i));
        end
        
        %rect
        filtData = abs(filtData);

        % low-pass filter
        [B,A] = butter(6, (filt_l .* 2) ./ SR, 'low');
        for i = 1:EMG_num
            filtData(:,i) = filtfilt(B,A,filtData(:,i));
        end

        %down sampling
        filtData = resample(filtData,downdata_to,SR);
        newSR = downdata_to;
        newTiming = Timing*newSR/SR;
        filtP = struct('whose','Uchida','Hp',filt_h, 'Rect','on','Lp',filt_l,'down',downdata_to);
end
end


function [alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(Data_in, Timing,trial_num,pre_per,post_per, EMG_num)
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

%------------------------------------------------------------------------------
function [Re] = alignDataEX(Data_in,Timing,Da,pre_per,TIME_W,EMG_num)
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