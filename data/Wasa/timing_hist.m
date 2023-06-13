%This program is analysis for EMG averaging


clear
%% set file name and so on
monkeyname = 'Wa' ; 
xpdate = '181227'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [2:3];
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
save_fig = 1;

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
event_ID(event_ID==1345)=38;   % WRONG_TRIAL_ORDER
event_ID(event_ID==1024)=0;    % success !
event_ID(event_ID==256)=1;    % failed: trial never started
event_ID(event_ID==1280)=2;    % failed: release lever 1 early
event_ID(event_ID==64)=3;     % failed: release lever 2 early
event_ID(event_ID==1088)=4;    % failed: took too long to pull lever 2
event_ID(event_ID==1089)=36;   % failed: release lever 3 early
event_ID(event_ID==321)=37;   % failed: took too long to pull lever 3

% task events
event_ID(event_ID==1296)=10;   % start pulling lever 1
event_ID(event_ID==80)=11;   % end pulling lever 1
event_ID(event_ID==1104)=12;   % start pulling lever 2
event_ID(event_ID==336)=13;   % end pulling lever 2
event_ID(event_ID==1360)=14;   % start release GO signal 1
event_ID(event_ID==4)=15;    % end release GO signal 1
event_ID(event_ID==1028)=16;   % start release GO signal 2
event_ID(event_ID==260)=17;   % end release GO signal 2
event_ID(event_ID==1284)=18;   % start reward
event_ID(event_ID==68)=19;   % end reward
event_ID(event_ID==1092)=20;   % trial start

% event_ID(event_ID==63488)=30;   % end hold item
% event_ID(event_ID==1024)=31;   % end hold item
event_ID(event_ID==1025)=32;   % PULL_LEVER_3
event_ID(event_ID==257)=33;   % RELEASE_LEVER_3
event_ID(event_ID==1281)=34;   % BEGIN_GO_3
event_ID(event_ID==65)=35;   % END_GO_3


% event_ID(event_ID==0)=38;   % WRONG_TRIAL_ORDER

% % event_ID(event_ID==24576)=5;    % failed: RT too long
% % event_ID(event_ID==57344)=6;    % failed: MT too long
% % event_ID(event_ID==4096)=7;     % failed: delay between touching and pulling item too long
% % event_ID(event_ID==36864)=8;    % failed: too long to take lever to final position
% % event_ID(event_ID==20480)=9;    % failed: EMG too high during human's turn
% 
% % % add code 20 from manipulandum, meaning "press HP a beginning of trial"
% % event_ID(event_ID==1024)=21;    % start delay 1
% % event_ID(event_ID==10240)=22;   % item visible (panel ON)
% % event_ID(event_ID==43008)=23;   % leave HP before GO (timing corrected afterwards)
% % event_ID(event_ID==26624)=24;   % start GO signal
% % event_ID(event_ID==59392)=25;   % end GO signal
% % event_ID(event_ID==63488)=26;   % leave HP (for RT) (timing corrected afterwards)
% % event_ID(event_ID==6144)=27;    % start touching item (timing corrected afterwards)
% % event_ID(event_ID==38912)=28;   % start pulling item
% % event_ID(event_ID==22528)=29;   % start hold period of item
% % event_ID(event_ID==55296)=30;   % end hold item
% % % add code 31 from manipulandum meaning "end touch item"
% % event_ID(event_ID==17408)=32;   % start release GO signal
% % event_ID(event_ID==50176)=33;   % end release GO signal
% % %event_ID(event_ID==14336);   % unused
% % event_ID(event_ID==47104)=34;   % start reward
% % event_ID(event_ID==30720)=35;   % end reward

event_ID2 = event_ID ;
event_t2  = event_t ;

%% select sucsess timing data

%plot obj2 start timing

load([monkeyname xpdate '-' sprintf('%04d', file_num(1,1)) '.mat'], 'CEMG_001_KHz');
load([monkeyname xpdate '-' sprintf('%04d', file_num(1,1)) '.mat'], 'CEMG_001_Time*');



load([monkeyname xpdate '-' sprintf('%04d', file_num(1,1)) '.mat'], 'CInPort_001*');
    Timing1 = AllInPort(:,find(AllInPort(2,:)==1296));
    Timing1(1,:) = Timing1(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
    Timing1(1,:) = floor(Timing1(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    
    Timing2 = AllInPort(:,find(AllInPort(2,:)==80));
    Timing2(1,:) = Timing2(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
    Timing2(1,:) = floor(Timing2(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    
    Timing3 = AllInPort(:,find(AllInPort(2,:)==1104));
    Timing3(1,:) = Timing3(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
    Timing3(1,:) = floor(Timing3(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
   
    Timing4 = AllInPort(:,find(AllInPort(2,:)==336));
    Timing4(1,:) = Timing4(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000;
    Timing4(1,:) = floor(Timing4(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    
    Timing5 = AllInPort(:,find(AllInPort(2,:)==1024));
    Timing5(1,:) = Timing5(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
    Timing5(1,:) = floor(Timing5(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    %Timing = zeros(2,length(Timing1) + length(Timing2) + length(Timing3) + length(Timing4) + length(Timing5));
    Timing = [Timing1 Timing2 Timing3 Timing4 Timing5];
    
    [B,I] = sort(Timing(1,:));
    Timing = Timing(:,I); 
    
    suc = find(Timing(2,:)==1024);
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
        if Timing(2,suc_i - 4)==1296 && Timing(2,suc_i - 3)==80 && Timing(2,suc_i - 2)==1104 && ...
            Timing(2,suc_i - 1)==336
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
            if 5500<time_w1 && time_w1<(22000) 
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
    cd ../
end
%% save figure
if save_fig == 1;
    cd timing_histogram_figures
        saveas(gcf,[ monkeyname xpdate '.fig']);
    cd ../
end