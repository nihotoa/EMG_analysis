%This program is analysis for EMG averaging


clear
%% set file name and so on
monkeyname = 'Wa' ; 
xpdate = '181114'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [5:6];
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
wk = 3; %1:plot obj2 start timing, 2:plot stim timing
save_data = 0;
%% create All Data matrix
get_first_data = 1;
for i = file_num(1,1):file_num(1,length(file_num))
    for j = 1:length(selEMGs)
        load([monkeyname xpdate '-' sprintf('%04d',i) '.mat'],['CEMG_0' sprintf('%02d',j)]);
        if get_first_data
            load([monkeyname xpdate '-' sprintf('%04d',i)],'CEMG_001_KHz');
            EMG_Hz = CEMG_001_KHz .* 1000;
            Data_num = length(CEMG_001);
            AllData1 = zeros(Data_num, EMG_num);
            AllData1(:,1) = CEMG_001';
            get_first_data = 0;
        else
            load([monkeyname xpdate '-' sprintf('%04d',i)],['CEMG_0' sprintf('%02d',j)]);
            eval(['AllData1(:, j ) = CEMG_0' sprintf('%02d',j) ''';']);
        end
    end
    if i == file_num(1,1)
        AllData = AllData1;
    else
        AllData = [AllData; AllData1];
        %cell2mat(AllData);
    end
    get_first_data = 1;
end

%plot(AllData(:,10)');

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

%% plot & save data

%plot obj2 start timing

load([monkeyname xpdate '-000' sprintf('%d', file_num(1,1)) '.mat'], 'CEMG_001_KHz');
load([monkeyname xpdate '-000' sprintf('%d', file_num(1,1)) '.mat'], 'CEMG_001_Time*');

switch wk
    case 1
        load([monkeyname xpdate '-000' sprintf('%d', file_num(1,1)) '.mat'], 'CInPort_001*');
        Timing = AllInPort(1,find(AllInPort(2,:)==1104))-CEMG_001_TimeBegin*CInPort_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! ==80 for new filesa !!!!!!!!!!!!
        Timing = floor(Timing/(CInPort_001_KHz/CEMG_001_KHz));
        
        %10:(length(AllInPort(1,:))-10
        
%         Timing_all = AllInPort(1,find(AllInPort(2,10:length(AllInPort(1,:)))==1104))-CEMG_001_TimeBegin*CInPort_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! ==80 for new filesa !!!!!!!!!!!!
%         Timing_all = floor(Timing_all/(CInPort_001_KHz/CEMG_001_KHz));
        
%         cd Wasa181018
%             TimeRange = [CEMG_001_TimeBegin*CEMG_001_KHz*1000, CEMG_001_TimeEnd*CEMG_001_KHz*1000];
%             Name = 'obj2_start_timing';
%             Class = 'obj2_start';
%             SampleRate = CEMG_001_KHz * 1000;
%             AllInPort(1,:) = floor((AllInPort(1,:)-CEMG_001_TimeBegin*CInPort_001_KHz*1000) ./ (CInPort_001_KHz/CEMG_001_KHz));   %11KHz
%             Unit = 'data_num(EMG_Hz)';
%             EMG_Data_num =floor(TimeRange(1,2) - TimeRange(1,1));
%             save([monkeyname xpdate '_AllInPort.mat'], 'TimeRange', 'Name', 'Class', 'SampleRate', 'AllInPort', 'Unit','Timing_all','EMG_Data_num');
%         cd ../
        
        pullData = zeros(12001,length(Timing));
        x =  6001;
        filt_l = 20;
        filt_h = 50;
        
        f = figure;
        p = uipanel('Parent',f,'BorderType','none'); 
        p.Title = [ xpdate '   start_obj2   ' sprintf('%d', filt_h) 'Hz-' sprintf('%d', filt_l) 'Hz'];
        p.TitlePosition = 'centertop'; 
        p.FontSize = 12;
        p.FontWeight = 'bold';
        %y = -0.25:0.001:0.25;
        for j = 1:EMG_num
            for i=1:length(Timing)
                if Timing(1,i)-6000>0 && Timing(1,i)+6000<Timing(1,length(Timing))
                pullData(:,i) = AllData(Timing(1,i)-6000:Timing(1,i)+6000,j);
                else
                    pullData(1,i) = 1000;
                end
            end

            [B,A] = butter(2, (filt_h .* 2) ./ 11000, 'high');
            pullData = filter(B,A,pullData);
            [B,A] = butter(2, (filt_l .* 2) ./ 11000, 'low');
            pullData = filter(B,A,abs(pullData));
            %eval([EMGs{j,1} '= figure;']);
            %eval(['figure(' EMGs{j,1} ');']);
            %title(EMGs{j,1});

            ave = zeros(length(pullData(:,1)),1); 
            for i=1:length(Timing)
                if pullData(1,i) ~= 1000
                    subplot(4,4,j,'Parent',p); plot(pullData(:,i),'Color',[0,0,0]);
                    hold on;
                    ave = ((ave .* (i-1)) + pullData(:,i)) ./ i;
                end
            end
            plot([x x],[-50 50],'r');
            hold on;
            %eval([ EMGs{j,1} '_ave = figure;']);
            %eval(['figure(' EMGs{j,1} '_ave);']);
            plot(ave,'r');
            ylim([-50 50]);
            xlim([0 12001]);
            hold on;
            title(EMGs{j,1});
            %hold on;
            %plot(x,y,'r*');

            if save_data == 1
                Data = zeros(1,length(ave));
                TimeRange = [0, 6001];
                Name = cell2mat(EMGs(j,1));
                Class = 'continuous channel';
                SampleRate = CEMG_001_KHz * 1000;
                Data = ave';
                Unit = 'uV';
                save([ cell2mat(EMGs(j,1)) '(uV)_obj2ave.mat'], 'TimeRange', 'Name', 'Class', 'SampleRate', 'Data', 'Unit');
            end    
            
        end
    
    case 2
        load([monkeyname xpdate '-000' sprintf('%d', file_num(1,1)) '.mat'], 'CTTL_001*');
        Timing = CTTL_001_Up; %- CEMG_001_TimeBegin*CInPort_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! ==80 for new filesa !!!!!!!!!!!!
        Timing = floor(Timing/(CTTL_001_KHz/CEMG_001_KHz));
        %load([monkeyname xpdate '-0003.mat'], 'CTTL_001*');

        pullData = zeros(12001,length(Timing));
        x =  6001;
        y = -0.25:0.01:0.25;
        for j = 1:EMG_num
            for i=1:length(Timing)
                pullData(:,i) = AllData(abs(Timing(1,i)-6000):Timing(1,i)+6000,j);
            end

            [B,A] = butter(2, (20.*2) ./ 11000, 'high');
            pullData = filter(B,A,pullData);
            [B,A] = butter(2, (1.*2) ./ 11000, 'low');
            pullData = filter(B,A,pullData);

            %eval([EMGs{j,1} '= figure;']);
            %eval(['figure(' EMGs{j,1} ');']);
            %title(EMGs{j,1});
            ave = zeros(length(pullData(:,1)),1);
            for i=1:length(Timing)
                subplot(4,4,j); plot(pullData(:,i),'Color',[0,0,0]);
                hold on;
                ave = ((ave .* (i-1)) + pullData(:,i)) ./ i;
            end
            plot([6000 6000],[-0.1 0.1],'r');
            hold on;
            %title(EMGs{j,1});
            %eval([ EMGs{j,1} '_ave = figure;']);
            %eval(['figure(' EMGs{j,1} '_ave);']);
            plot(ave,'r');
            %hold on;
            %plot(x,y,'r*');
        end
    case 3
        load([monkeyname xpdate '-000' sprintf('%d', file_num(1,1)) '.mat'], 'CEMG_001_KHz');
        load([monkeyname xpdate '-000' sprintf('%d', file_num(1,1)) '.mat'], 'CEMG_001_TimeBegin');
        
        load([monkeyname xpdate '-000' sprintf('%d', file_num(1,1)) '.mat'], 'CStimMarker_001*');
        Timing = CStimMarker_001(1,2:length(CStimMarker_001)-3) - CEMG_001_TimeBegin*CStimMarker_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! ==80 for new filesa !!!!!!!!!!!!
        Timing = floor(Timing/(CStimMarker_001_KHz/CEMG_001_KHz));
        %load([monkeyname xpdate '-0003.mat'], 'CStimMarker_001*');

        pullData = zeros(6001,length(Timing));
        x =  3001;
        y = -0.25:0.01:0.25;
        for j = 1:EMG_num
            for i=1:length(Timing)
                pullData(:,i) = AllData(Timing(1,i)-3000:Timing(1,i)+3000,j);
            end

            [B,A] = butter(2, (1.*2) ./ 11000, 'high');
            pullData = filter(B,A,pullData);
            [B,A] = butter(2, (20.*2) ./ 11000, 'low');
            pullData = filter(B,A,pullData);

%             eval(['f' sprintf('%d', j) '= figure;']);
%             p = uipanel('Parent',sprintf('f%d',j),'BorderType','none'); 
%             f = figure;
%             p = uipanel('Parent',f,'BorderType','none'); 
%             p.Title = 'SR_Stim';
%             p.TitlePosition = 'centertop'; 
%             p.FontSize = 12;
%             p.FontWeight = 'bold';
            
            
            %eval([EMGs{j,1} '= figure;']);
            %eval(['figure(' EMGs{j,1} ');']);
            %title(EMGs{j,1});
            f = figure;
            sample_num = CEMG_001_KHz;
            ave = zeros(length(pullData(:,1)),1);
            for i=1:length(Timing)
                %down_pullData = downsample(pullData, sample_num);
                %subplot(14,1,j); 
                plot(pullData(:,i),'Color',[0,0,0]);
                hold on;
                ave = ((ave .* (i-1)) + pullData(:,i)) ./ i;
            end
            plot([3001 3001],[-20 20],'r');
            hold on;
            plot([3111 3111],[-20 20],'r');
            hold on;
            plot([3221 3221],[-20 20],'r');
            hold on;
            plot([3331 3331],[-20 20],'r');
            hold on;
            plot([3441 3441],[-20 20],'r');
            hold on;
            plot([3551 3551],[-20 20],'r');
            hold on;
            %title(EMGs{j,1});
            %eval([ EMGs{j,1} '_ave = figure;']);
            %eval(['figure(' EMGs{j,1} '_ave);']);
            plot(ave,'r');
            ylim([-6 6]);
            xlim([2500 6001]);
            title(EMGs{j,1});
            %hold on;
            %plot(x,y,'r*');
        end
    case 4
    load([monkeyname xpdate '-000' sprintf('%d', file_num(1,1)) '.mat'], 'CInPort_001*');
    Timing1 = AllInPort(:,find(AllInPort(2,:)==80));
    Timing1(1,:) = Timing1(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! ==80 for new filesa !!!!!!!!!!!!
    Timing1(1,:) = floor(Timing1(1,:)/(CInPort_001_KHz/CEMG_001_KHz));

    Timing2 = AllInPort(:,find(AllInPort(2,:)==336));
    Timing2(1,:) = Timing2(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! ==80 for new filesa !!!!!!!!!!!!
    Timing2(1,:) = floor(Timing2(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    
    Timing3 = AllInPort(:,find(AllInPort(2,:)==1024));
    Timing3(1,:) = Timing3(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! ==80 for new filesa !!!!!!!!!!!!
    Timing3(1,:) = floor(Timing3(1,:)/(CInPort_001_KHz/CEMG_001_KHz));
    
    Timing = zeros(2,length(Timing1) + length(Timing2) + length(Timing3));
    Timing = [Timing1 Timing2 Timing3];
    
    [B,I] = sort(Timing(1,:));
    Timing = Timing(:,I); 
%         cd Wasa181018
%             TimeRange = [CEMG_001_TimeBegin*CEMG_001_KHz*1000, CEMG_001_TimeEnd*CEMG_001_KHz*1000];
%             Name = 'obj2_start_timing';
%             Class = 'obj2_start';
%             SampleRate = CEMG_001_KHz * 1000;
%             AllInPort(1,:) = floor((AllInPort(1,:)-CEMG_001_TimeBegin*CInPort_001_KHz*1000) ./ (CInPort_001_KHz/CEMG_001_KHz));   %11KHz
%             Unit = 'data_num(EMG_Hz)';
%             EMG_Data_num =floor(TimeRange(1,2) - TimeRange(1,1));
%             save([monkeyname xpdate '_AllInPort.mat'], 'TimeRange', 'Name', 'Class', 'SampleRate', 'AllInPort', 'Unit','Timing_all','EMG_Data_num');
%         cd ../
    suc = find(Timing(2,:)==336);
    suc_num = length(suc);
    
    suc_num_al = suc_num;
    for i=1:suc_num_al
        if suc(1,i)-2 > 0 && suc(1,i)-1 > 0
        else 
            suc_num = suc_num -1;
        end
    end
    suc_num = 312;
    T_timing = zeros(suc_num,2);
    for i=1:suc_num
       T_timing(i,1) = Timing(1,suc(1,i+suc_num_al-suc_num)-2);
       T_timing(i,2) = Timing(1,suc(1,i+suc_num_al-suc_num)-1);
    end
    
    max_len = min(T_timing(:,2) - T_timing(:,1));
    sel_task = cell(1,EMG_num);
    taskData = zeros(suc_num,max_len);
    ave = zeros(1,max_len);
    x =  1;
    filt_l = 20;
    filt_h = 0.5;

    for j = 1:EMG_num
        for i=1:suc_num
            timing_w = T_timing(i,2) -T_timing(i,1);
            taskData(i,:) = resample(AllData(T_timing(i,1):T_timing(i,2),j)',max_len,timing_w+1);
%             taskData(i,:) = interpft(AllData(T_timing(i,1):T_timing(i,2),j)',max_len);
%             if timing_w<11000
%                 taskData(i,:) = interpft(AllData(T_timing(i,1):T_timing(i,2),j)',11000);
%             end
%             if timing_w>=11000
%                 taskData(i,:) = resample(AllData(T_timing(i,1):T_timing(i,2),j)',11000,timing_w+1);
%             end
        end
        sel_task{1,j} = taskData;
    end
    
    %plot data
%      plotData = zeros(suc_num,max_len);
%       for j=1:EMG_num
%           for i=1:suc_num
%               [B,A] = butter(2, (1.*2) ./ 11000, 'high');
%               plotData(i,:) = filter(B,A,sel_task{1,j}(i,:));
%               [B,A] = butter(2, (10.*2) ./ 11000, 'low');
%               plotData(i,:) = filter(B,A,plotData(i,:));
%               
%               subplot(4,4,j); plot(downsample(plotData(i,:),11),'Color',[0,0,0]);
%               hold on;
%               ave = ((ave .* (i-1)) + plotData(i,:)) ./ i;
%           end
%           plot([x x],[-50 50],'r');
%           hold on;
%           %eval([ EMGs{j,1} '_ave = figure;']);
%           %eval(['figure(' EMGs{j,1} '_ave);']);
%           plot(downsample(ave,11),'r');
%           %ylim([0 20]);
%           xlim([0 max_len/11]);
%           hold on;
%           title(EMGs{j,1});
%           %hold on;
%           %plot(x,y,'r*');
%       end

    if save_data == 1
        %Data = zeros(1,length(ave));
        Class = 'continuous channel';
        SampleRate = CEMG_001_KHz * 1000;
        TimeRange = [0, max_len/SampleRate];
        Unit = 'uV';
        cd Wa181019;
        save([ monkeyname xpdate '_for_nmf_H_1e-2e.mat'], 'max_len','TimeRange', 'EMGs', 'Class', 'SampleRate', 'sel_task', 'Unit','T_timing');
    end    
end

%a = find(event_ID == 12);
%item2_on=zeros(1,length(event_t(a)));
%b=knnsearch(item2_on',event_t(a)','K',2) ;
%bb=[item2_on(b(:,1))' item2_on(b(:,2))'] - repmat(event_t(a)',1,2);
%b = event_t(:,a);
%b = floor(b ./ 4);
%start_hold = AllData(b(:,1) - 11000: b(:,1) + 11000 , 10);