%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
% coded by Naoki Uchida
% modified by Naohito Ota
% last modification : 2019.05.10
this code is used in runnningEasyfunc.m
[role of this function]
1.
2.
3.
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [alignedDataAVE,alignedData,taskRange,AllT,Timing_ave,TIME_W,Res,D] = plotEasyData_utb( monkeyname, xpdate_num, EMGp, ECoGp )
%PLOTEASYDATA Summary of this function goes here
%   Detailed explanation goes here

switch monkeyname
    case 'Wa'
        real_name = 'Wasa';
    case 'Ya'
        real_name = 'Yachimun';
    case 'F'
        real_name = 'Yachimun';
    case 'Sa'
        real_name = 'Sakiika';
    case 'Su'
        real_name = 'Suruku';
    case 'Se'
        real_name = 'SesekiL';
%         real_name = 'SesekiR';
        
    case 'Ma'
        real_name = 'Matatabi';
end
global task
xpdate = sprintf('%d',xpdate_num);
 disp(['START TO MAKE & SAVE ' monkeyname xpdate '_Plot Data']);
cd(real_name)

cd(['easyData/' monkeyname xpdate '_' task])
S = load([monkeyname xpdate '_EasyData.mat']); %load EASY file
cd ../../

% plot mode 1:EMG-ECoG,2:nothing, 3:EMG, 4:ECoG 
if EMGp == 1 && ECoGp == 1
    EMGd = S.AllData_EMG;
    ECoGd = S.AllDataECoG;
    TimingT1 = S.Tp;
    SR = S.SampleRate;
    plot_mode = 1;
elseif EMGp ~= 1 && ECoGp ~= 1
    TimingT1 = S.Tp;
    SR = S.SampleRate;
    plot_mode = 2;
elseif ECoGp ~= 1
    EMGd = S.AllData_EMG;
    TimingT1 = S.Tp;
    SR = S.SampleRate;
    plot_mode = 3;
else
    ECoGd = S.AllDataECoG;
    TimingT1 = S.Tp;
    SR = S.SampleRate;
    plot_mode = 4;
end 

% global EMGs
% global EMG_num 
EMGs = S.EMGs; % EMG list
EMG_num = length(EMGs);% the number of EMGs
TimingT1 = TimingT1(1:end-1,:);
L = size(TimingT1);
s_num = L(1); %the number of success tials

% pullData = cell(s_num,2);
%% filter EMG
if plot_mode == 1 || plot_mode == 3
    filt_mode = 5;%Takei method:1, Next method:2, Roland method:3, Uchida method:5
    [filtData_EMG,SR_EMG,Timing_EMG,filtP] = filterEMG(EMGd,filt_mode,SR,EMG_num,TimingT1);
end
%% filter ECoG
if plot_mode == 1 || plot_mode == 4
    [op] = filterECoG(ECoGd,filt_mode,SR);
end
%%
%define time window
pre_per = 50; % How long do you want to see the signals before hold_on 1 starts.
post_per = 50; % How long do you want to see the signals after hold_off 2 starts.

[alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(filtData_EMG, SR_EMG, Timing_EMG,s_num,pre_per,post_per, EMG_num);
taskRange = [-1*pre_per, 100+post_per];
D.trig1_per = [50 50];
D.trig2_per = [50 50];
D.trig3_per = [50 50];
D.trig4_per = [50 50];
D.task_per = [25,105];
[Res] = alignDataEX(alignedData,Timing_EMG, D,pre_per,post_per,TIME_W,EMG_num);
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
% All.pD = alignedData;
% All.pDave = alignedDataAVE;
% All.AllT = AllT;

cd(['easyData/' monkeyname xpdate '_' task])
    %save outData with filter preference daata
    switch monkeyname
         case 'Wa'
             save([monkeyname xpdate '_alignedData_' filtP.whose '.mat'], 'monkeyname', 'xpdate','EMGs', ...
                                                        'alignedData', 'alignedDataAVE','filtP','s_num','taskRange','Timing_ave'...
                                                        );
         case {'Ya','Ma','F'}
             save([monkeyname xpdate '_alignedData_' filtP.whose '.mat'], 'monkeyname', 'xpdate','EMGs', ...
                                                        'alignedData', 'alignedDataAVE','filtP','s_num','taskRange','Timing_ave'...
                                                        );
         case {'Su','Se'}
             save([monkeyname xpdate '_alignedData_' filtP.whose '.mat'], 'monkeyname', 'xpdate','EMGs', ...
                                                        'alignedData', 'alignedDataAVE','filtP','s_num','taskRange','Timing_ave'...
                                                        );
    end
cd ../../../
disp(['END TO MAKE & SAVE ' monkeyname xpdate '_Plot Data']);
end

function [filtData, newSR,newTiming,filtP] = filterEMG(filtData,filt_mode,SR,EMG_num,Timing)
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
        case 2
            filt_h = 50; %cut off frequency [Hz]
            filt_l = 10; %cut off frequency [Hz]
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
            filtP = struct('whose','TTakei-10HzLPFversion','Hp',filt_h, 'Rect','on','Lp',filt_l,'smooth',np,'down',downdata_to);
        case 3 %Roland filter
            np = round(5000*0.22);%smooth num
            kernel = ones(np,1)/np; 
            downdata_to = 1000; %sampling frequency [Hz]

%             [B,A] = butter(6, (filt_h .* 2) ./ 5000, 'high');
%             for i = 1:EMG_num
%                 filtData(:,i) = filter(B,A,filtData(:,i));
%             end
            for i=1:EMG_num
                filtData(:,i) = abs(filtData(:,i)-mean(filtData(:,i)));
            end
%             [B,A] = butter(6, (filt_l .* 2) ./ 5000, 'low');
%             for i = 1:EMG_num
%                 filtData(:,i) = filter(B,A,filtData(:,i));
%             end

            for i = 1:EMG_num
        %     filtData = smooth(filtData,1,'movmean',smooth_num);
                filtData(:,i) = conv2(filtData(:,i),kernel,'same');
            end

            filtData = resample(filtData,downdata_to,SR);
            newSR = downdata_to;
            newTiming = Timing*newSR/SR;
            filtP = struct('whose','Roland','Hp','no', 'Rect','on','Lp','no','smooth',np,'down',downdata_to);
        case 4 %Uchida filter (for no delay filtering)
           %
           
            filt_h = 50; %cut off frequency [Hz]
            filt_l = 20; %cut off frequency [Hz]
            np = 100;%smooth num
            kernel = ones(np,1)/np; 
            downdata_to = 100; %sampling frequency [Hz]

            rng default;
            
            for i = 1:EMG_num
                filtData(:,i) = filtData(:,i)-mean(filtData(:,i));
            end
            
            Ap = 1;
            Ast = 60;
            dfH = designfilt('highpassiir','PassbandFrequency',filt_h,...
            'StopbandFrequency',filt_h-8.8,'PassbandRipple',Ap,...
            'StopbandAttenuation',Ast,'SampleRate',SR,'DesignMethod','butter');
            for i = 1:EMG_num
                filtData(:,i) = filtfilt(dfH,filtData(:,i));
            end
            filtData = abs(filtData);
            
            dfL = designfilt('lowpassiir','PassbandFrequency',filt_l,...
            'StopbandFrequency',filt_l+2.1,'PassbandRipple',Ap,...
            'StopbandAttenuation',Ast,'SampleRate',SR,'DesignMethod','butter');
            for i = 1:EMG_num
                filtData(:,i) = filtfilt(dfL,filtData(:,i));
            end
            
            for i = 1:EMG_num
        %     filtData = smooth(filtData,1,'movmean',smooth_num);
                filtData(:,i) = conv2(filtData(:,i),kernel,'same');
            end
             FOrderH = filtord(dfH);
             FOrderL = filtord(dfL);
            filtData = resample(filtData,downdata_to,SR);
            newSR = downdata_to;
            newTiming = Timing*newSR/SR;
            filtP = struct('whose','NUchida','dfH',dfH, 'dfL', dfL,'filtOrderH',FOrderH,'filtOrderL',FOrderL,'Hp',filt_h, 'Rect','on','Lp',filt_l,'smooth',np,'down',downdata_to);
            
       case 5 %Uchida filtfilt
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

function [] = filterECoG(data,filt_mode,SR)
    switch filt_mode
        case 1

        case 2

        case 3

    end
end

function [alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(Data_in, SR, Timing,s_num,pre_per,post_per, EMG_num)
% this function estimate that Timing is constructed by 6 kinds of timing.
%1:start trial
%2:hold on 1
%3:hold off 1
%4:hold on 2
%5:hold off 2
%6:success
%Please comfirm this construction is correct.  
Data = Data_in';
per1 = pre_per/100;
per2 = post_per/100;
% Timing = cast(Timing,'int32');
TIME_W = round(sum(Timing(:,5)-Timing(:,2) + 1)/s_num); % averarge sample 
pre1_TIME = round(per1*sum(Timing(:,5)-Timing(:,2) + 1)/s_num);
post2_TIME = round(per2*sum(Timing(:,5)-Timing(:,2) + 1)/s_num);
trialData = cell(s_num,3);
AllT = pre1_TIME+TIME_W+post2_TIME;
%j:muscle number
%i:trial number
outData = cell(s_num,EMG_num);
sec = zeros(3,1);
alignedData = cell(1,EMG_num);
alignedDataAVE = cell(1,EMG_num);
%Time Normalize
for j = 1:EMG_num
    DataA = zeros(s_num,AllT);
    for i = 1:s_num
%         trialData{i,2} = Data(j,Timing(i,2):Timing(i,5));???
         time_w = round(Timing(i,5) - Timing(i,2) +1);
        %compare average frames of all task(TIME_W) and the frames of this task(time_w) 
        if time_w == TIME_W
            sec(1,1) = sec(1,1)+1;
            trialData{i,1} = Data(j,floor(Timing(i,2)-time_w*per1):floor(Timing(i,2)-1));
            trialData{i,2} = Data(j,floor(Timing(i,2)):floor(Timing(i,5)));
            trialData{i,3} = Data(j,floor(Timing(i,5)+1):floor(Timing(i,5)+time_w*per2));
        
        elseif time_w<TIME_W 
            sec(2,1) = sec(2,1)+1;
            trialData{i,1} = interpft(Data(j,floor(Timing(i,2)-time_w*per1):floor(Timing(i,2)-1)),pre1_TIME);
            trialData{i,2} = interpft(Data(j,floor(Timing(i,2)):floor(Timing(i,5))),TIME_W);
            trialData{i,3} = interpft(Data(j,floor(Timing(i,5)+1):floor(Timing(i,5)+time_w*per2)),post2_TIME);
        
        else
            sec(3,1) = sec(3,1)+1;
            trialData{i,1} = resample(Data(j,floor(Timing(i,2)-time_w*per1):floor(Timing(i,2)-1)),pre1_TIME,round(time_w*per1));
            trialData{i,2} = resample(Data(j,floor(Timing(i,2)):floor(Timing(i,5))),TIME_W,time_w);
            trialData{i,3} = resample(Data(j,floor(Timing(i,5)+1):floor(Timing(i,5)+time_w*per2)),post2_TIME,round(time_w*per2));
        end
        outData{i,j} = [trialData{i,1} trialData{i,2} trialData{i,3}];
        size_out = size(outData{i,j});
        if size_out(2) == AllT
            DataA(i,:) = outData{i,j}(1,:);
        else
            DataA(i,:) = resample(outData{i,j}(1,:),AllT,size_out(2));
            outData{i,j} = resample(outData{i,j}(1,:),AllT,size_out(2));
        end
    end 
    alignedData{1,j} = DataA;
    alignedDataAVE{1,j} = mean(DataA,1);
end
Ti = [Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2)];
Timing_ave = mean(Timing - Ti);
% alignedData = cell(1,EMG_num);

% for k = 1:EMG_num
%     SS = outData{:,k};
%     alignedData{1,k} = SS;%cell2mat(SS);
%     alignedDataAVE{1,k} = mean(SS,1);
% end
end

function [Re] = alignDataEX(Data_in,Timing,Da,pre_per,post_per,TIME_W,EMG_num)
% this function estimate that Timing is constructed by 6 kinds of timing.
%1:start trial
%2:hold on 1
%3:hold off 1
%4:hold on 2
%5:hold off 2
%6:success
%Please comfirm this construction is correct.  
D = Data_in;
pre_per = pre_per/100;
% post_per = post_per/100;
per1 = Da.trig1_per/100;
per2 = Da.trig2_per/100;
per3 = Da.trig3_per/100;
per4 = Da.trig4_per/100;
pertask = Da.task_per/100;
L = length(Timing(:,1));
Ti = [Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2)];
Timing = Timing - Ti;
TimingPer = zeros(L,6);
centerP1 = zeros(L,2);
centerP2 = zeros(L,2);
centerP3 = zeros(L,2);
centerP4 = zeros(L,2);
centerPTask = zeros(L,2);
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
        tD1 = cell(L,1);
        tD2 = cell(L,1);
        tD3 = cell(L,1);
        tD4 = cell(L,1);
        tDTask = cell(L,1);
    for i = 1:L%Trial loop
        TimingPer(i,:) = Timing(i,:)./Timing(i,5);
        centerP1(i,:) = [round((pre_per+TimingPer(i,2)-per1(1))*TIME_W+1),floor((pre_per+TimingPer(i,2)+per1(2))*TIME_W-1)];
        centerP2(i,:) = [round((pre_per+TimingPer(i,3)-per2(1))*TIME_W+1),floor((pre_per+TimingPer(i,3)+per2(2))*TIME_W-1)];
        centerP3(i,:) = [round((pre_per+TimingPer(i,4)-per3(1))*TIME_W+1),floor((pre_per+TimingPer(i,4)+per3(2))*TIME_W-1)];
        centerP4(i,:) = [round((pre_per+TimingPer(i,5)-per4(1))*TIME_W+1),floor((pre_per+TimingPer(i,5)+per4(2))*TIME_W-1)];
        centerPTask(i,:) = [round((pre_per+TimingPer(i,2)-pertask(1))*TIME_W+1),floor((pre_per+TimingPer(i,2)+pertask(2))*TIME_W-1)];
        tD1{i,1} = D{1,m}(i,centerP1(i,1):centerP1(i,2));
        tD2{i,1} = D{1,m}(i,centerP2(i,1):centerP2(i,2));
        tD3{i,1} = D{1,m}(i,centerP3(i,1):centerP3(i,2));
        tD4{i,1} = D{1,m}(i,centerP4(i,1):centerP4(i,2));
        tDTask{i,1} = D{1,m}(i,centerPTask(i,1):centerPTask(i,2));
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