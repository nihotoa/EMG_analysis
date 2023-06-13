function [] = timing_hist_func(xpdate,file_num)
%% set file name and so on
monkeyname = 'Ya' ; 
% real_name = 'Wasa';
% xpdate = '181207'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
% file_num = [2:2];
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

wk = 1; %1:plot obj2 start timing, 2:plot stim timing
save_fold = 'new_nmf_result';
save_data = 1;
save_fig = 0;

%% cut  data on task timing

get_first_portin = 1;
for i = file_num(1,1):file_num(1,length(file_num))
    if get_first_portin
        load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CInPort*');
        CInPort = CInPort_001;
    else
        load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CInPort_001');
        CInPort = CInPort_001;
    end
    if i == file_num(1,1)
        AllInPort = CInPort;
    else
        AllInPort = [AllInPort,CInPort];
    end
    get_first_portin = 0;
end

%% attributes codes easier to read to the main events of the task

event_ID=AllInPort(2,:); % ID of the codes
event_t=AllInPort(1,:) ; % timing of the codes

% trial outcome codes: last code of a trial

event_ID(event_ID==0)=38;   % WRONG_TRIAL_ORDER
event_ID(event_ID==32768)=0;    % success !
event_ID(event_ID==16384)=1;    % failed: trial never started
event_ID(event_ID==49152)=2;    % failed: release lever 1 early
event_ID(event_ID==2048)=3;     % failed: release lever 2 early
event_ID(event_ID==34816)=4;    % failed: took too long to pull lever 2
event_ID(event_ID==34848)=36;   % failed: release lever 3 early
event_ID(event_ID==18464)=37;   % failed: took too long to pull lever 3

% task events
event_ID(event_ID==49664)=10;   % start pulling lever 1
event_ID(event_ID==2560)=11;   % end pulling lever 1
event_ID(event_ID==35328)=12;   % start pulling lever 2
event_ID(event_ID==18944)=13;   % end pulling lever 2
event_ID(event_ID==51712)=14;   % start release GO signal 1
event_ID(event_ID==128)=15;    % end release GO signal 1
event_ID(event_ID==32896)=16;   % start release GO signal 2
event_ID(event_ID==16512)=17;   % end release GO signal 2
event_ID(event_ID==49280)=18;   % start reward
event_ID(event_ID==2176)=19;   % end reward
event_ID(event_ID==34944)=20;   % trial start

% event_ID(event_ID==63488)=30;   % end hold item
% event_ID(event_ID==1024)=31;   % end hold item
event_ID(event_ID==32800)=32;   % PULL_LEVER_3
event_ID(event_ID==16416)=33;   % RELEASE_LEVER_3
event_ID(event_ID==49184)=34;   % BEGIN_GO_3
event_ID(event_ID==2080)=35;   % END_GO_3

event_ID2 = event_ID ;
event_t2  = event_t ;

start1 = 49664;
end1 = 2560;
start2 = 35328;
end2 = 18944;
success = 32768;

%% select sucsess timing data

%plot obj2 start timing

load([monkeyname xpdate '-' sprintf('%04d', file_num(1,1)) '.mat'], 'CEMG_001_KHz');
load([monkeyname xpdate '-' sprintf('%04d', file_num(1,1)) '.mat'], 'CEMG_001_Time*');



load([monkeyname xpdate '-' sprintf('%04d', file_num(1,1)) '.mat'], 'CInPort_001*');
    Timing1 = AllInPort(:,find(AllInPort(2,:)==start1));
    Timing1(1,:) = Timing1(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
    Timing1(1,:) = floor(Timing1(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    
    Timing2 = AllInPort(:,find(AllInPort(2,:)==end1));
    Timing2(1,:) = Timing2(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
    Timing2(1,:) = floor(Timing2(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    
    Timing3 = AllInPort(:,find(AllInPort(2,:)==start2));
    Timing3(1,:) = Timing3(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
    Timing3(1,:) = floor(Timing3(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
   
    Timing4 = AllInPort(:,find(AllInPort(2,:)== end2));
    Timing4(1,:) = Timing4(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000;
    Timing4(1,:) = floor(Timing4(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    
    Timing5 = AllInPort(:,find(AllInPort(2,:)==success));
    Timing5(1,:) = Timing5(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
    Timing5(1,:) = floor(Timing5(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    %Timing = zeros(2,length(Timing1) + length(Timing2) + length(Timing3) + length(Timing4) + length(Timing5));
    Timing = [Timing1 Timing2 Timing3 Timing4 Timing5];
    
    [B,I] = sort(Timing(1,:));
    Timing = Timing(:,I); 
    
    suc = find(Timing(2,:)==success);
    suc_num = length(suc);
    
    suc_num_al = suc_num;
    for i=1:suc_num_al
        if suc(1,i)-4 > 0 && suc(1,i)-1 > 0
        else 
            suc_num = suc_num -1;
        end
    end
    %suc_num = 312;
    T_timing = zeros(suc_num,5);
    T_timing_con = zeros(suc_num,5);
    for i=1:suc_num
        suc_i = suc(1,i+suc_num_al-suc_num);
        if Timing(2,suc_i - 4)==start1 && Timing(2,suc_i - 3)==end1 && Timing(2,suc_i - 2)==start2 && ...
            Timing(2,suc_i - 1)==end2
           T_timing(i,1) = Timing(1,suc_i - 4);
           T_timing(i,2) = Timing(1,suc_i - 3);
           T_timing(i,3) = Timing(1,suc_i - 2);
           T_timing(i,4) = Timing(1,suc_i - 1);
           T_timing(i,5) = Timing(1,suc_i);
           T_timing_con(i,1) = Timing(2,suc_i - 4);
           T_timing_con(i,2) = Timing(2,suc_i - 3);
           T_timing_con(i,3) = Timing(2,suc_i - 2);
           T_timing_con(i,4) = Timing(2,suc_i - 1);
           T_timing_con(i,5) = Timing(2,suc_i);
        end
    end
    
    tim_per = zeros(suc_num,2);
    
    for i=1:suc_num
        if T_timing(i,1)~=0
            time_w1 = T_timing(i,4)-T_timing(i,1);
            time_w2 = T_timing(i,3)-T_timing(i,1);
            time_w3 = T_timing(i,2)-T_timing(i,1);
            if 2200<time_w1 && time_w1<(44000) 
                tim_per(i,1) = (time_w2/time_w1);
                tim_per(i,2) = (time_w3/time_w1);
            else
                T_timing(i,:) = zeros(1,5);
                T_timing_con(i,:) = zeros(1,5);
            end
        end
    end
    
    SUC_Timing_A = T_timing(find(T_timing(:,1)~=0),:);
    SUC_Timing_A_con = T_timing_con(find(T_timing_con(:,1)~=0),:);
    SUC_tim_per = tim_per(find(tim_per(:,1)~=0),:);
    SUC_num = length(SUC_Timing_A(:,1));
%% draw histogram
    f=figure;
    %histogram of 'obj1 end hold ' timing
    h1 = histogram(SUC_tim_per(:,1));
    hold on;
    tim_per_m = mean(SUC_tim_per(:,1));
    plot([tim_per_m tim_per_m],[0 30],'r');
    hold on;
    
    %histogram of 'obj1 end hold ' timing
    h2 = histogram(SUC_tim_per(:,2));
    hold on;
    tim_per_m = mean(SUC_tim_per(:,2));
    plot([tim_per_m tim_per_m],[0 30],'r');
    hold on;
    
    ylim([0 15]);
    xlim([0 1]);
    h1.NumBins = 50; %the number of devided range
    h2.NumBins = 50;
    title([monkeyname xpdate 'end obj1 & start obj2 timing histogram']);

%% save data
if save_data == 1;
    cd(save_fold)
    cd([monkeyname xpdate])
        TimeRange_EMG = [CEMG_001_TimeBegin*CEMG_001_KHz*1000, CEMG_001_TimeEnd*CEMG_001_KHz*1000];
        Name = 'SUC_Timing';
        SampleRate = CEMG_001_KHz * 1000;
        Unit = 'data_num(EMG_Hz)';
    %     AllInPort(1,:) = floor((AllInPort(1,:)-CEMG_001_TimeBegin*CInPort_001_KHz*1000) ./ (CInPort_001_KHz/CEMG_001_KHz));   %11KHz
        save([monkeyname xpdate '_SUC_Timing.mat'], 'TimeRange_EMG', 'Name', 'SampleRate',...
            'AllInPort', 'Unit','SUC_Timing_A','SUC_Timing_A_con','SUC_tim_per','SUC_num');
    cd ../
    cd order_tim_list
        eval([monkeyname xpdate '_SUC_tim_per = SUC_tim_per;']);
%         eval([monkeyname xpdate '_SUC_Timing_A = SUC_Timing_A;']);
%         save([monkeyname xpdate '_SUC_tim_per.mat'],[monkeyname xpdate '_SUC_tim_per'],[monkeyname xpdate '_SUC_Timing_A']);
        save([monkeyname xpdate '_SUC_tim_per.mat'],[monkeyname xpdate '_SUC_tim_per'],'SUC_Timing_A','file_num');
    cd ../
    cd ../
    
end
%% save figure
if save_fig == 1;
    cd timing_histogram_figures
        saveas(gcf,[ monkeyname xpdate '.fig']);
    cd ../
end
end