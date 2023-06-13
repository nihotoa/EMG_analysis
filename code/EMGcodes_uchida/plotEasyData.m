%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% coded by Naoki Uchida
% last modification : 2019.05.10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [alignedDataAVE,taskRange,AllT,Timing_ave,TIME_W,Res,D] = plotEasyData( monkeyname, xpdate_num, EMGp, ECoGp )
%PLOTEASYDATA Summary of this function goes here
%   Detailed explanation goes here

switch monkeyname
    case 'Wa'
        real_name = 'Wasa';
    case 'Ya'
        real_name = 'Yachimun';
    case 'Sa'
        real_name = 'Sakiika';
    case 'Su'
        real_name = 'Suruku';
    case 'Se'
        real_name = 'SesekiR';
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
L = size(TimingT1);
s_num = L(1); %the number of success tials

% pullData = cell(s_num,2);
%% filter EMG
if plot_mode == 1 || plot_mode == 3
    filt_mode = 1;%Takei method:1, Roland method:2
    [filtData_EMG,SR_EMG,Timing_EMG,filtP] = filterEMG(EMGd,filt_mode,SR,EMG_num,TimingT1);
    
    for i = 1:s_num
        
    end
end
%% filter ECoG
if plot_mode == 1 || plot_mode == 4
    [op] = filterECoG(ECoGd,filt_mode,SR);
end
%%
pre_per = 50; % How long do you want to see the signals before hold_on 1 starts.
post_per = 50; % How long do you want to see the signals after hold_off 2 starts.
[alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(filtData_EMG, SR_EMG, Timing_EMG,s_num,pre_per,post_per, EMG_num);
taskRange = [-1*pre_per, 100+post_per];
D.obj1_per = [50 50];
D.obj2_per = [50 50];
D.task_per = [25,105];
[Res] = alignDataEX(alignedData,Timing_EMG, D,pre_per,post_per,TIME_W,EMG_num);
D.Ld1 = length(Res.tData1_AVE{1});
D.Range1 = D.obj1_per;
D.Ld2 = length(Res.tData2_AVE{1});
D.Range2 = D.obj2_per;
D.Ld3 = length(Res.tData3_AVE{1});
D.Range3 = D.task_per;
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
         case 'Ya'
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
            
            [B,A] = butter(6, (filt_h .* 2) ./ 5000, 'high');
            for i = 1:EMG_num
                filtData(:,i) = filter(B,A,filtData(:,i));
            end

            filtData = abs(filtData);

            [B,A] = butter(6, (filt_l .* 2) ./ 5000, 'low');
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
        case 3

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
TIME_W = round(sum(Timing(:,end)-Timing(:,2) + 1)/s_num);
pre1_TIME = round(per1*sum(Timing(:,end)-Timing(:,2) + 1)/s_num);
post2_TIME = round(per2*sum(Timing(:,end)-Timing(:,2) + 1)/s_num);
trialData = cell(s_num,3);
AllT = pre1_TIME+TIME_W+post2_TIME;
%j:muscle number 
%i:trial number
outData = cell(s_num,EMG_num);
sec = zeros(3,1);
alignedData = cell(1,EMG_num);
alignedDataAVE = cell(1,EMG_num);
for j = 1:EMG_num
    DataA = zeros(s_num,AllT);
    for i = 1:s_num
%         trialData{i,2} = Data(j,Timing(i,2):Timing(i,5));???
         time_w = round(Timing(i,5) - Timing(i,2) +1);
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
per1 = Da.obj1_per/100;
per2 = Da.obj2_per/100;
per3 = Da.task_per/100;
L = length(Timing(:,1));
Ti = [Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2)];
Timing = Timing - Ti;
TimingPer = zeros(L,6);
centerP1 = zeros(L,2);
centerP2 = zeros(L,2);
centerP3 = zeros(L,2);
Re.tData1 = cell(1,EMG_num);
Re.tData2 = cell(1,EMG_num);
Re.tData3 = cell(1,EMG_num);
Re.tData1_AVE = cell(1,EMG_num);
Re.tData2_AVE = cell(1,EMG_num);
Re.tData3_AVE = cell(1,EMG_num);
for m = 1:EMG_num
        tD1 = cell(L,1);
        tD2 = cell(L,1);
        tD3 = cell(L,1);
    for i = 1:L%Trial loop
        TimingPer(i,:) = Timing(i,:)./Timing(i,5);
        centerP1(i,:) = [(pre_per+TimingPer(i,3)-per1(1))*TIME_W+1,(pre_per+TimingPer(i,3)+per1(2))*TIME_W];
        centerP2(i,:) = [(pre_per+TimingPer(i,4)-per2(1))*TIME_W+1,(pre_per+TimingPer(i,4)+per2(2))*TIME_W];
        centerP3(i,:) = [(pre_per+TimingPer(i,2)-per3(1))*TIME_W+1,(pre_per+TimingPer(i,2)+per3(2))*TIME_W];
        centerP1 = round(centerP1);
        centerP2 = round(centerP2);
        centerP3 = round(centerP3);
        tD1{i,1} = D{1,m}(i,centerP1(i,1):centerP1(i,2));
        tD2{i,1} = D{1,m}(i,centerP2(i,1):centerP2(i,2));
        tD3{i,1} = D{1,m}(i,centerP3(i,1):centerP3(i,2));
    
       StD1 = size(tD1{i,1});
       StD2 = size(tD2{i,1});
       StD3 = size(tD3{i,1});
       if  StD1(2) ~= TIME_W*sum(per1)
           tD1{i,1} = resample(tD1{i,1},round(TIME_W*sum(per1)),StD1(2));
       end
       if  StD2(2) ~= TIME_W*sum(per2)
           tD2{i,1} = resample(tD2{i,1},round(TIME_W*sum(per2)),StD2(2));
       end
       if  StD3(2) ~= TIME_W*sum(per3)
           tD3{i,1} = resample(tD3{i,1},round(TIME_W*sum(per3)),StD3(2));
       end
    end
    Re.tData1{m} = cell2mat(tD1);
    Re.tData1_AVE{m} = mean(Re.tData1{m});
    Re.tData2{m} = cell2mat(tD2);
    Re.tData2_AVE{m} = mean(Re.tData2{m});
    Re.tData3{m} = cell2mat(tD3);
    Re.tData3_AVE{m} = mean(Re.tData3{m});
end

end