%% This program is analysis for EMG averaging
%
clear
%% set parameter

%file info
monkeyname = 'Wa' ; 
xpdate = '181217'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [15,15];
SUC_fold = 'new_nmf_result';

E = 2;

%EMG set
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

%plot & save settings
plk = 1; %set plot kinds(1:EMG stim plot, 2:SCMS plot )
          
ex_CTTL = 0;
ex_CStimMarker =1;
% stim_type = ['ICMS16-11_' sprintf('%02d',file_num(1))];%SRstim,ICMS,EMGstim
stim_type = 'ICMS19-29';
rangeF_ms = 500; %how long do you want to see former part of trigger[msec] 
rangeL_ms = 500; %how long do you want to see latter part of trigger[msec]

%trig to trig plot
trig_2 = [1 4]; %1:plot obj1 start timing, 
                %2:plot obj1 end timing, 
                %3:plot obj2 start timing, 
                %4:plot obj2 end timing, 
range_normalize = 1500;%normalize range of task[msec]           

%all trig normalized plot
save_fold = 'new_nmf_result';
save_data = 0; %1/0 means y/n 
save_fig =0; %1/0 means y/n

%% load stim timing file
cd(save_fold)
cd([monkeyname xpdate])
cd([monkeyname xpdate '_' stim_type])
load([monkeyname xpdate '_Stim_Timing_CStimMarker.mat'])
cd ../../../
% CStimMarker_002(1,:) = CStimMarker_002(1,:) - TimeRange(1)*44000;
% CStimMarker_002(1,:) = floor(CStimMarker_002(1,:) ./ 4);

%% create All Data matrix
switch E
    case 1
        get_first_data = 1;
        load([monkeyname xpdate '-' sprintf('%04d',file_num(1,1)) '.mat'],'CEMG_001_TimeBegin');
        TimeRange = zeros(1,2);
        TimeRange(1,1) = CEMG_001_TimeBegin;
        for i = file_num(1,1):file_num(1,length(file_num))
            for j = 1:length(selEMGs)
                load([monkeyname xpdate '-' sprintf('%04d',i) '.mat'],['CEMG_0' sprintf('%02d',j)]);
                if get_first_data
                    load([monkeyname xpdate '-' sprintf('%04d',i)],'CEMG_001*');
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
            end
            TimeRange(1,2) = CEMG_001_TimeEnd;
            get_first_data = 1;
        end
        
    case 2
        
        map = [2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]; 
        %EMG set
        selECoGs=[1:64];
        tECoG = [1:64];
        EMG_num = length(tECoG);
        
        get_first_data = 1;
        load([monkeyname xpdate '-' sprintf('%04d',file_num(1,1)) '.mat'],'CRAW_001_TimeBegin');
        TimeRange = zeros(1,2);
        TimeRange(1,1) = CRAW_001_TimeBegin;
        for i = file_num(1,1):file_num(1,length(file_num))
            for j = 1:length(selECoGs)
                load([monkeyname xpdate '-' sprintf('%04d',i) '.mat'],['CRAW_0' sprintf('%02d',j)]);
                if get_first_data
                    load([monkeyname xpdate '-' sprintf('%04d',i)],'CRAW_001*');
                    EMG_Hz = CRAW_001_KHz .* 1000;
                    Data_num = length(CRAW_001);
                    AllData1 = zeros(Data_num, EMG_num);
                    AllData1(:,1) = CRAW_001';
                    get_first_data = 0;
                else
                    load([monkeyname xpdate '-' sprintf('%04d',i)],['CRAW_0' sprintf('%02d',j)]);
                    eval(['AllData1(:, j ) = CRAW_0' sprintf('%02d',j) ''';']);
                end
            end
            if i == file_num(1,1)
                AllData = AllData1;
            else
                AllData = [AllData; AllData1];
            end
            TimeRange(1,2) = CRAW_001_TimeEnd;
            get_first_data = 1;
        end
        
end
%% plot section

switch E
    case 1
    CStimMarker(1,:) = floor(CStimMarker(1,:) ./ 4);
    CStimMarker(1,:) = CStimMarker(1,:) - TimeRange(1)*11000;
    
    case 2
    CStimMarker(1,:) = floor(CStimMarker(1,:) ./ 2);
    CStimMarker(1,:) = CStimMarker(1,:) - TimeRange(1)*22000;
end

%non average all matrix plot
if plk == 1
    cycle =10;
    burstduration = 90; %[msec]
    burstinterval = 910;%[msec]
    freq = 333;%[Hz] 
    amp = 3000; %[uA]
    
    see_pre = 60;%[msec]
    see_res = 160; %[msec]
    
    pre = floor(EMG_Hz * see_pre/1000);
    res = floor(EMG_Hz * see_res/1000);

    stim_time = 1;
    for ii=1:length(CStimMarker(1,:))-1
        if 500<CStimMarker(1,ii+1)-CStimMarker(1,ii) %&& CStimMarker(1,ii+1)-CStimMarker(1,ii)<45
            CStimMarker(2,ii) = stim_time;
            stim_time = stim_time + 1;
        else
            CStimMarker(2,ii) = stim_time;
            
        end
    end
  
   
    trig_f = zeros(stim_time,1);
    for i = 1:stim_time
        trig_f(i,1) = min(find(CStimMarker(2,:)==i));
    end
    
    range_n = 1+res+pre;
    x = linspace(-see_pre,see_res,range_n);
    
    %filter settings
    hp_filt = 0;
    filt_h = 10; %cut off frequency [Hz]
    
    rect = 0;
    
    lp_filt = 0;
    filt_l = 100; %cut off frequency [Hz]
    
    datasmooth = 0; 
    np = 10;%smooth num
    kernel = ones(np,1)/np; 
    
    filtData = AllData;
    for ii = 1:EMG_num
        filtData(:,ii) = filtData(:,ii)-mean(filtData(:,ii));
    end
    %filtering
    if hp_filt==1
        [B,A] = butter(4, (filt_h .* 2) ./ 11000, 'high');
        for i = 1:EMG_num
            filtData(:,i) = filter(B,A,AllData(:,i));
        end
    end
    
    if rect == 1
        filtData = abs(filtData);
    end
    
    if lp_filt==1
        [B,A] = butter(2, (filt_l .* 2) ./ 11000, 'low');
        for i = 1:EMG_num
            filtData(:,i) = filter(B,A,filtData(:,i));
        end
    end
    
    if datasmooth==1
        for i = 1:EMG_num
    %     filtData = smooth(filtData,1,'movmean',smooth_num);
            filtData(:,i) = conv2(filtData(:,i),kernel,'same');
        end
    end

    
    %plot
    f1 = figure('Position',[500,0,1000,1200]);
    Yl = 100;%ylim
    pullData = zeros(stim_time,range_n);
    for j =1:EMG_num
        switch E
            case 1
                subplot(7,2,j);
                
            case 2
                subplot(8,8,map(j));
        end
        
        for i = 1:stim_time
%             time_w = CStimMarker(1,burst_num*i)-CStimMarker(1,burst_num*(i-1)+1)+1 +res+pre;
%             
%             if time_w == range_n
%                 sec(1,1) = sec(1,1)+1;
%                 pullData(i,:) = filtData(CStimMarker(1,burst_num*(i-1)+1)-pre:CStimMarker(1,burst_num*i)+res,j)';
%             elseif time_w<range_n 
%                 sec(2,1) = sec(2,1)+1;
%                 pullData(i,:) = interpft(filtData(CStimMarker(1,burst_num*(i-1)+1)-pre:CStimMarker(1,burst_num*i)+res,j),range_n)';
%             else
%                 sec(3,1) = sec(3,1)+1;
%                 pullData(i,:) = resample(filtData(CStimMarker(1,burst_num*(i-1)+1)-pre:CStimMarker(1,burst_num*i)+res,j),range_n,time_w)';
%             end
            
%             plot(AllData(CStimMarker(1,burst_num*(i-1)+1):CStimMarker(1,burst_num*i),j),'Color',[0 0 0])

            ave = zeros(1,range_n);
            pullData(i,:) = filtData(CStimMarker(1,trig_f(i)) - pre:CStimMarker(1,trig_f(i)) + res,j);
            plot(x,pullData(i,:),'Color',[0,0,0]);
            hold on;
            ave = ((ave .* (i-1)) + pullData(i,:)) ./ i;
            
%             for k = 1:burst_num
    %             tim = CStimMarker_002(1,k+(i-1)*burst_num);
    %             plot([tim tim],[-100 100],'r');
    %             ylim([-100,100]);
%             end
        end
        ylim([-Yl,Yl]);
        for ii=1:length(find(CStimMarker(2,:)==i))
            plot([(CStimMarker(1,trig_f(1)+ii)-CStimMarker(1,trig_f(1)))*1000/EMG_Hz (CStimMarker(1,trig_f(1)+ii)-CStimMarker(1,trig_f(1)))*1000/EMG_Hz],[-Yl Yl],'y');
            hold on;
            if i == stim_time
                plot([(CStimMarker(1,trig_f(1))-CStimMarker(1,trig_f(1)))*1000/EMG_Hz (CStimMarker(1,trig_f(1))-CStimMarker(1,trig_f(1)))*1000/EMG_Hz],[-Yl Yl],'y');
                hold on;    
                plot([(CStimMarker(1,trig_f(1)+ii+1)-CStimMarker(1,trig_f(1)))*1000/EMG_Hz (CStimMarker(1,trig_f(1)+ii+1)-CStimMarker(1,trig_f(1)))*1000/EMG_Hz],[-Yl Yl],'y');
            end
        end
        plot(x,ave,'r');
        xlabel('time[msec]') % x-axis label
        ylabel('amplitude[uV]') % y-axis label
%         title(EMGs{j})
         xlim([-see_pre,see_res]);
%         figure;
% %         for ii=1:length(find(CStimMarker(2,:)==i))
% %             plot(x,[CStimMarker(1,trig_f(ii)) CStimMarker(1,trig_f(ii))],[-50 50],'Color',[1 1 0]);
% %             hold on;EMG
% %         end
%         plot(x,ave,'r');
%         ylim([-50,50]);
%         xlim([-see_pre,see_res]);
%         xlabel('time[msec]') % x-axis label
%         ylabel('amplitude[uV]') % y-axis label
% %         title([EMGs{j} '  ave'])
%         figure(f1);
    end
end

%average plot
if plk == 2
    cycle =10;
    burstduration = 90; %[msec]
    burstinterval = 910;%[msec]
    freq = 333;%[Hz] 
    amp = 3000; %[uA]
    
    see_pre = 200;%[msec]
    see_res = 1000; %[msec]
    
    pre = floor(EMG_Hz * see_pre/1000);
    res = floor(EMG_Hz * see_res/1000);
%     x = -see_res:1000/EMG_Hz:burstduration+see_res;
    
%     range_n = EMG_Hz * floor(burstduration/1000);
    burst_num = floor(length(CStimMarker(1,:)) / cycle);
    sec = zeros(3,1);
    
    Tim = zeros(cycle,burst_num);
    for i = 1:cycle
        Tim(i,:) = CStimMarker(1,burst_num*(i-1)+1:burst_num*i);
        Tim(i,:) = Tim(i,:) - Tim(i,1);
    end
    range_n = floor(mean(Tim(:,end)))+1+res+pre;
    pullData = zeros(cycle,range_n);
    ave = zeros(1,range_n);
    x = linspace(-see_pre,(floor(mean(Tim(:,end)))+1)*1000/EMG_Hz+see_res,range_n);
    
    %filter settings
    hp_filt = 1;
    filt_h = 60; %cut off frequency [Hz]
    
    rect = 1;
    
    lp_filt = 1;
    filt_l = 20; %cut off frequency [Hz]
    filtData = AllData;
    
    %filtering
    if hp_filt==1
        [B,A] = butter(4, (filt_h .* 2) ./ 11000, 'high');
        for i = 1:EMG_num
            filtData(:,i) = filter(B,A,AllData(:,i));
        end
    end
    
    if rect == 1
        filtData = abs(filtData);
    end
    
    if lp_filt==1
        [B,A] = butter(2, (filt_l .* 2) ./ 11000, 'low');
        for i = 1:EMG_num
            filtData(:,i) = filter(B,A,filtData(:,i));
        end
    end
    
    %plot
    f1 = figure('Position',[500,0,1000,1200]);
    Yl = 50;%ylim
    for j =1:EMG_num
        
        subplot(7,2,j);
        
        for i = 1:cycle
            time_w = CStimMarker(1,burst_num*i)-CStimMarker(1,burst_num*(i-1)+1)+1 +res+pre;
            
            if time_w == range_n
                sec(1,1) = sec(1,1)+1;
                pullData(i,:) = filtData(CStimMarker(1,burst_num*(i-1)+1)-pre:CStimMarker(1,burst_num*i)+res,j)';
            elseif time_w<range_n 
                sec(2,1) = sec(2,1)+1;
                pullData(i,:) = interpft(filtData(CStimMarker(1,burst_num*(i-1)+1)-pre:CStimMarker(1,burst_num*i)+res,j),range_n)';
            else
                sec(3,1) = sec(3,1)+1;
                pullData(i,:) = resample(filtData(CStimMarker(1,burst_num*(i-1)+1)-pre:CStimMarker(1,burst_num*i)+res,j),range_n,time_w)';
            end
            
%             plot(AllData(CStimMarker(1,burst_num*(i-1)+1):CStimMarker(1,burst_num*i),j),'Color',[0 0 0])
            
            plot(x,pullData(i,:),'Color',[0,0,0]);
            hold on;
            ave = ((ave .* (i-1)) + pullData(i,:)) ./ i;
            
%             for k = 1:burst_num
    %             tim = CStimMarker_002(1,k+(i-1)*burst_num);
    %             plot([tim tim],[-100 100],'r');
    %             ylim([-100,100]);
%             end
        end
        ylim([-Yl,Yl]);
        for k=1:burst_num
            plot([Tim(1,k)*1000/EMG_Hz Tim(1,k)*1000/EMG_Hz],[-Yl Yl],'y');
            hold on;
        end
        plot(x,ave,'r');
        xlabel('time[msec]') % x-axis label
        ylabel('amplitude[uV]') % y-axis label
        title(EMGs{j})
        xlim([-see_pre,see_res]);
        figure;
        for k=1:burst_num
            plot([Tim(1,k)*1000/EMG_Hz Tim(1,k)*1000/EMG_Hz],[-50 50],'Color',[1 1 0]);
            hold on;
        end
        plot(x,ave,'r');
%         ylim([-50,50]);
        xlim([-see_pre,see_res]);
        xlabel('time[msec]') % x-axis label
        ylabel('amplitude[uV]') % y-axis label
        title([EMGs{j} '  ave'])
        figure(f1);
    end
end

%% save fig
if save_fig == 1
    cd ICMS_plot_figures;
    saveas(gcf,[ monkeyname xpdate '_' stim_type '_a' sprintf('%d',amp) '_f' sprintf('%d',freq) '_du' sprintf('%d',burstduration) '_in' sprintf('%d',burstinterval) '_cy' sprintf('%d', cycle) '.bmp']);
    cd ../;
end

