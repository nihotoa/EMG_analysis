
%% This program is analysis for EMG averaging
%
clear
%% set parameter

%file info
monkeyname = 'Ya' ; 
xpdate = '170529'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [2,5];
SUC_fold = 'new_nmf_result';

%EMG sec
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
EMGs{11,1}= 'ED45';
EMGs{12,1}= 'ECU';
a = cummax(selEMGs,'reverse');
EMG_num = a(1,1);

%plot & save settings
plk = 2; %set plot kinds(1:center trig plot, 2:trig to trig, )

%center trig plot
trig = 1; %1:plot obj1 start timing, 
          %2:plot obj1 end timing, 
          %3:plot obj2 start timing, 
          %4:plot obj2 end timing, 
          %5:plot StimMarker(AO) timing
          %6:plot CTTL(NK) timing
          
ex_CTTL = 0;
ex_CStimMarker =1;
stim_type = 'SRstim';%SRstim,ICMS,EMGstim

rangeF_ms = 2000; %how long do you want to see former part of trigger[msec] 
rangeL_ms = 2000; %how long do you want to see latter part of trigger[msec]

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

%% create All Data matrix
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

%% filt data
%do you use these filt? 1/0 means y/n
%50Hz_hp-rect-20Hz_lp_down_to_100Hz is recommended

%[1]high-pass filter settings
hp_filt = 0;
filt_h = 50; %cut off frequency [Hz]

%[2]rectify
rectify = 0;

%[3]low-pass filter settings
lp_filt = 0;
filt_l = 20; %cut off frequency [Hz]

%[4]data smooth settings
datasmooth = 0; 
np = 500;%smooth num
kernel = ones(np,1)/np; 

%[5]downsampling settings
downsample1 = 1;
downdata_to = 100; %sampling frequency [Hz]

%which data do you use?
filtData = AllData;

filtData = resample(filtData,5000,EMG_Hz);
    SampleRate = 5000;

if hp_filt==1
    [B,A] = butter(2, (filt_h .* 2) ./ SampleRate, 'high');
    for i = 1:EMG_num
        filtData(:,i) = filter(B,A,filtData(:,i));
    end
end

if rectify==1
    for i = 1:EMG_num
        filtData(:,i) = filtData(:,i) - mean(filtData(:,i));
    end
    filtData = abs(filtData);
end

if lp_filt==1
    [B,A] = butter(2, (filt_l .* 2) ./ SampleRate, 'low');
    for i = 1:EMG_num
        filtData(:,i) = filter(B,A,filtData(:,i));
    end
end

% if rectify==1
%     filtData = abs(filtData);
% end

% if downsample1==1
%     filtData = resample(filtData,downdata_to,EMG_Hz);
%     SampleRate = downdata_to;
% end


if datasmooth==1
    for i = 1:EMG_num
%     filtData = smooth(filtData,1,'movmean',smooth_num);
        filtData(:,i) = conv2(filtData(:,i),kernel,'same');
    end
end


if downsample1==1
    filtData = resample(filtData,downdata_to,SampleRate);
    SampleRate = downdata_to;
end

for i = 1:EMG_num
    filtData(:,i) =filtData(:,i) ./ mean(filtData(:,i));
end
%% plot settings0

cd(SUC_fold)
cd([monkeyname xpdate])
load([monkeyname xpdate '_SUC_Timing.mat']);
%     load([monkeyname xpdate 'SUC_Timing.mat'], 'SUC_Timing_A');
%     load([monkeyname xpdate 'SUC_Timing.mat'], 'SUC_Timing_A_con');
%     load([monkeyname xpdate 'SUC_Timing.mat'], 'SUC_tim_per');
%     load([monkeyname xpdate 'SUC_Timing.mat'], 'TimeRange_EMG');
%     load([monkeyname xpdate 'SUC_Timing.mat'], 'TimeRange_EMG');
cd ../
cd ../
% AllInPort(1,:) = floor(AllInPort(1,:) ./ (EMG_Hz/downdata_to));
% if downsample1==1
%     SampleRate = downdata_to;
% end
if downsample1==1
    SampleRate = downdata_to;
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

AllInPort(2,:) = event_ID;

% trial_start = 20;
% end1 = 2560;
% start2 = 35328;
% end2 = 18944;
% success = 0;

perfect_task = [20,10,11,12,13,18,19,0];
Lp = length(perfect_task);
%% select sucsess timing data

%plot obj2 start timing
load([monkeyname xpdate '-' sprintf('%04d', file_num(1,1)) '.mat'], 'CEMG_001_KHz');
load([monkeyname xpdate '-' sprintf('%04d', file_num(1,1)) '.mat'], 'CEMG_001_Time*');
load([monkeyname xpdate '-' sprintf('%04d', file_num(1,1)) '.mat'], 'CInPort_001*');

Timing_sel = cell(1,Lp);
for ii = 1:Lp
    Timing_alt = AllInPort(:,find(event_ID==perfect_task(ii)));
    Timing_alt(1,:) = Timing_alt(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
    Timing_alt(1,:) = floor(Timing_alt(1,:)/(CInPort_001_KHz/(SampleRate/1000)));
    Timing_sel{ii} = Timing_alt;
end
%     Timing2 = event_t(find(event_ID==end1));
%     Timing2(1,:) = Timing2(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
%     Timing2(1,:) = floor(Timing2(1,:)/(CInPort_001_KHz/SampleRate));
%     
%     Timing3 = event_t(find(event_ID==start2));
%     Timing3(1,:) = Timing3(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
%     Timing3(1,:) = floor(Timing3(1,:)/(CInPort_001_KHz/SampleRate));
%    
%     Timing4 = event_t(find(event_ID== end2));
%     Timing4(1,:) = Timing4(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000;
%     Timing4(1,:) = floor(Timing4(1,:)/(CInPort_001_KHz/SampleRate));
%     
%     Timing5 = event_t(find(event_ID==success));
%     Timing5(1,:) = Timing5(1,:) - CEMG_001_TimeBegin*CInPort_001_KHz*1000; 
%     Timing5(1,:) = floor(Timing5(1,:)/(CInPort_001_KHz/SampleRate));


    %Timing = zeros(2,length(Timing1) + length(Timing2) + length(Timing3) + length(Timing4) + length(Timing5));
Timing = Timing_sel{1};
for ii = 1:Lp-1
     Timing = [Timing Timing_sel{ii+1}];
end
[B,I] = sort(Timing(1,:));
Timing = Timing(:,I); 

% trial = find(Timing(2,:)==perfect_task(1));
% trial_num = length(trial);
suc = find(Timing(2,:)==perfect_task(end));
suc_num = length(suc);
perfect_suc = suc;
perfect3 = [perfect_task perfect_task perfect_task];
for s = 4:suc_num
    state = 0;
    for ii = 1:23
        if Timing(2,suc(s)-24+ii) == perfect3(ii)
            state = state +1;
        end
    end
    if state ~= 23 || Timing(1,suc(s))-Timing(1,suc(s)-23)<SampleRate*8
        perfect_suc(s) = 0; 
    end
end
perfect_SUC = perfect_suc(3+find(perfect_suc(4:end) ~= 0));

perfect_timing = zeros(length(perfect_SUC),length(perfect3));

for pp = 1:length(perfect_SUC)
     perfect_timing(pp,:) = Timing(1,perfect_SUC(pp)-23:perfect_SUC(pp));
end

Gr = gray(6);
PPm = 4;
plot_list = [2,3,4,5,10,11,12,13,18,19,20,21];
% perfect3Data_sel = cell(1,PPm);
for PP = 1:1
    perfect3Data = zeros(EMG_num,perfect_timing(PP,end)-perfect_timing(PP,1)+1);
    x_ms = linspace(0,(perfect_timing(PP,end)-perfect_timing(PP,1)+1)*10,perfect_timing(PP,end)-perfect_timing(PP,1)+1);
%     figure;
    for L = 1:EMG_num
    figure('Position',[500,500,2000,300]);
%     subplot(12,1,L);
    hold on;
%     y = filtData(perfect_timing(PP,1):perfect_timing(PP,end),L);
%     xconf = [x_ms x_ms(end:-1:1)];
%     yconf = [y' zeros(size(y'))];
% 
%     fi = fill(xconf,yconf,'r');
%     fi.FaceColor = Gr(4,:);       % make the filled area pink
%     fi.EdgeColor = 'none';  
    plot(x_ms,y,'k','LineWidth',1.5);

    for p = 1:length(plot_list)
    ver_L = perfect_timing(PP,plot_list(p))-perfect_timing(PP,1)+1;
    plot([ver_L*10 ver_L*10],[0 20],'k--','LineWidth',0.8);
    end
%     ylim([0 20]);
    set(gca,'yticklabel',[]);
       if L~=EMG_num
            set(gca,'xticklabel',[]);
%             set(gca,'yticklabel',[]);
        end
    cd EMG_plot_figures;
        saveas(gcf,[ monkeyname xpdate 'perfect3trials_smooth100ms_' EMGs{L} '.png']);
    cd ../;
    
    end
end

% cd EMG_plot_figures;
%     saveas(gcf,[ monkeyname xpdate 'perfect3.fig']);
% cd ../;
% f = figure('Position',[500,500,1500,1000]);

% f = figure('Position',[300,0,1300,900]);
% p = uipanel('Parent',f,'BorderType','none');
% p.TitlePosition = 'centertop'; 
% p.FontSize = 12;
% p.FontWeight = 'bold';
% if plk ==1
%     p.Title = [ monkeyname xpdate '   start obj2   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz'];
%     if trig>=5
%         p.Title = [ monkeyname xpdate '   ' stim_type '   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz'];
%     end
% end
% if plk ==2
%     p.Title = [ monkeyname xpdate ' TTL' sprintf('%d',trig_2(1)) ' to  TTL' sprintf('%d',trig_2(2)) sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz'];
% end
% if plk ==3
%     p.Title = [ monkeyname xpdate '   each range normalized   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz'];
% end

%% plot data('pullData')
%plot center trig timing
if plk == 1
    %convert to data number
    if trig<=4
        rangeF = floor(rangeF_ms*downdata_to/1000); 
        rangeL = floor(rangeL_ms*downdata_to/1000);
        pullData = zeros(rangeF + rangeL + 1 , SUC_num);
        x =  rangeF + 1;

        for j = 1:EMG_num
            for i=1:SUC_num
                if SUC_Timing_A(i,trig)-rangeF > 0 && SUC_Timing_A(i,trig) + rangeL < length(filtData(:,1))
                    pullData(:,i) = filtData(SUC_Timing_A(i,trig) - rangeF : SUC_Timing_A(i,trig) + rangeL,j);
                else
                    pullData(1,i) = 1000;
                end
            end

            ave = zeros(length(pullData(:,1)),1); 

            for i=1:SUC_num
                if pullData(1,i) ~= 1000
                    subplot(3,4,j,'Parent',p); plot(pullData(:,i),'Color',[0,0,0]);
                    hold on;
                    ave = ((ave .* (i-1)) + pullData(:,i)) ./ i;
                end
            end

            plot([(rangeF + 1) (rangeF + 1)],[0 100],'r');
            hold on;
            plot(ave,'r');
            ylim([0 60]);
            xlim([0 (rangeF + rangeL + 1)]);
            hold on;
            title(EMGs{j,1});
        end
        if save_fig == 1
         cd EMG_plot_figures;
         saveas(gcf,[ monkeyname xpdate '_centertrig3_corr_' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz.bmp']);
         cd ../;
        end
        if save_data == 1
            cd syn-ECoG_correlation
            comment = 'this data will be used for correlation';
            save([monkeyname xpdate '_centertrig3_corr_.mat'], 'TimeRange','comment', 'Name', 'SampleRate_CTTL','AllCTTL', 'Unit');
        end
    end
    
    if trig>=5
      %I will write code to plot stim trigger signals
      if ex_CTTL ==1;
          cd(save_fold)
          cd([monkeyname xpdate])
          cd([monkeyname xpdate '_' stim_type])
          load([monkeyname xpdate '_Stim_Timing_CTTL.mat'],'AllCTTL')
          load([monkeyname xpdate '_Stim_Timing_CStimMarker.mat'],'SampleRate_CTTL')
          cd ../
          cd ../
          cd ../
        
%           CStimMarker(1,:) = CStimMarker(1,:) - TimeRange(1)*SampleRate_CStimMarker;
          stim_tim = CTTL(1,:);
          stim_tim = floor(stim_tim ./ (SampleRate_CTTL/downdata_to)); %down to 100Hz
          stim_num = length(stim_tim);

          rangeF = floor(rangeF_ms*downdata_to/1000); 
          rangeL = floor(rangeL_ms*downdata_to/1000);
          pullData = zeros(rangeF + rangeL + 1 , stim_num);
          x =  rangeF + 1;

            for j = 1:EMG_num
                for i=1:stim_num
                    if stim_tim(i)-rangeF > 0 && stim_tim(i) + rangeL < length(filtData(:,1))
                        pullData(:,i) = filtData(stim_tim(i) - rangeF : stim_tim(i) + rangeL,j);
                    else
                        pullData(1,i) = 1000;
                    end
                end

                ave = zeros(length(pullData(:,1)),1); 

                for i=1:stim_num
                    if pullData(1,i) ~= 1000
                        subplot(3,4,j,'Parent',p); plot(pullData(:,i),'Color',[0,0,0]);
                        hold on;
                        ave = ((ave .* (i-1)) + pullData(:,i)) ./ i;
                    end
                end

                plot([(rangeF + 1) (rangeF + 1)],[0 100],'r');
                hold on;
                plot(ave,'r');
                ylim([0 60]);
                xlim([0 (rangeF + rangeL + 1)]);

                hold on;
                title(EMGs{j,1});
            end
          
          
      end
      
      if ex_CStimMarker ==1;
          cd(save_fold)
          cd([monkeyname xpdate])
          cd([monkeyname xpdate '_' stim_type])
        load([monkeyname xpdate '_Stim_Timing_CStimMarker.mat'],'CStimMarker')
        load([monkeyname xpdate '_Stim_Timing_CStimMarker.mat'],'SampleRate_CStimMarker')
        cd ../
        cd ../
        cd ../
        CStimMarker(1,:) = CStimMarker(1,:) - TimeRange(1)*SampleRate_CStimMarker;
        stim_tim = CStimMarker(1,:);
        stim_tim = floor(stim_tim ./ (SampleRate_CStimMarker/downdata_to)); %down to 100Hz

        stim_num = length(stim_tim);
        
        rangeF = floor(rangeF_ms*downdata_to/1000); 
        rangeL = floor(rangeL_ms*downdata_to/1000);
        pullData = zeros(rangeF + rangeL + 1 , stim_num);
        x = rangeF + 1;

            for j = 1:EMG_num
                for i=1:stim_num
                    if stim_tim(i)-rangeF > 0 && stim_tim(i) + rangeL < length(filtData(:,1))
                        pullData(:,i) = filtData(stim_tim(i) - rangeF : stim_tim(i) + rangeL,j);
                    else
                        pullData(1,i) = 1000;
                    end
                end

                ave = zeros(length(pullData(:,1)),1); 
                x = linspace(-rangeF_ms,rangeL_ms,rangeF + rangeL + 1);
                for i=1:stim_num
                    if pullData(1,i) ~= 1000
                        subplot(7,2,j,'Parent',p); plot(x,pullData(:,i),'Color',[0,0,0]);
                        hold on;
                        ave = ((ave .* (i-1)) + pullData(:,i)) ./ i;
                    end
                end

%                 plot([(rangeF + 1) (rangeF + 1)],[0 100],'r');
                plot([0 0],[0 100],'y');
                hold on;
                plot(x,ave,'r');
                ylim([0 60]);
%                 xlim([0 60]);
                
                hold on;
                title(EMGs{j,1});
            end
      end
      if save_fig == 1
        cd EMG_plot_figures;
        saveas(gcf,[ monkeyname xpdate '   ' stim_type '   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz.bmp']);
        cd ../;
      end
      
    end
end

%plot trig to trig
if plk == 2
    sec = zeros(3,1);
    range_n = range_normalize * downdata_to/1000;
    pullData = zeros(SUC_num, range_n);
    
    for j = 1:EMG_num
        for i=1:SUC_num
            time_w = SUC_Timing_A(i,trig_2(2)) - SUC_Timing_A(i,trig_2(1)) +1;
            if time_w == range_n
                sec(1,1) = sec(1,1)+1;
                pullData(i,:) = filtData(SUC_Timing_A(i,trig_2(1)):SUC_Timing_A(i,trig_2(2)),j)';
            elseif time_w<range_n 
                sec(2,1) = sec(2,1)+1;
                pullData(i,:) = interpft(filtData(SUC_Timing_A(i,trig_2(1)):SUC_Timing_A(i,trig_2(2)),j),range_n)';
            else
                sec(3,1) = sec(3,1)+1;
                pullData(i,:) = resample(filtData(SUC_Timing_A(i,trig_2(1)):SUC_Timing_A(i,trig_2(2)),j),range_n,time_w)';
            end
        end

        ave = zeros(1,range_n); 

        for i=1:SUC_num
                subplot(4,4,j,'Parent',p); plot(pullData(i,:),'Color',[0,0,0]);
                hold on;
                ave = ((ave .* (i-1)) + pullData(i,:)) ./ i;
        end
       % plot([(rangeF + 1) (rangeF + 1)],[0 100],'r');
       % hold on;
        plot(ave,'r');
        ylim([0 100]);
        xlim([0 range_n]);
        hold on;
        title(EMGs{j,1});
    end
end

%plot trig to trig(each trig)
if plk == 3
%     SUC_num = 142;
    sec = zeros(3,1);
    range_n = range_normalize * downdata_to/1000;
    T1 = SUC_Timing_A(:,1:3);
    T2 = SUC_Timing_A(:,2:4);
    Tim_range = T2 - T1;
    Tim_range_ave = floor(mean(Tim_range));
    all_pullData = zeros(SUC_num,sum(Tim_range_ave)-2);
    x = linspace(0,sum(Tim_range_ave)*1000/SampleRate,sum(Tim_range_ave)-2);
    for j = 1:EMG_num   
        for k = 1:3
            pullData = zeros(SUC_num, Tim_range_ave(k));
                for i=1:SUC_num
                    time_w = SUC_Timing_A(i,k+1) - SUC_Timing_A(i,k) +1;
                    if time_w == Tim_range_ave(k)
                        sec(1,1) = sec(1,1)+1;
                        pullData(i,:) = filtData(SUC_Timing_A(i,k):SUC_Timing_A(i,k+1),j)';
                    elseif time_w<Tim_range_ave(k) 
                        sec(2,1) = sec(2,1)+1;
                        pullData(i,:) = interpft(filtData(SUC_Timing_A(i,k):SUC_Timing_A(i,k+1),j),Tim_range_ave(k))';
                    else
                        sec(3,1) = sec(3,1)+1;
                        pullData(i,:) = resample(filtData(SUC_Timing_A(i,k):SUC_Timing_A(i,k+1),j),Tim_range_ave(k),time_w)';
                    end
                end

                if k == 1
                    all_pullData(:,1:Tim_range_ave(k)) = pullData; 
                end
                if k == 2
                    all_pullData(:,Tim_range_ave(k-1)+1:Tim_range_ave(k-1)+Tim_range_ave(k)-1) = pullData(:,2:Tim_range_ave(k)); 
                end
                if k == 3
                    all_pullData(:,Tim_range_ave(k-2)+Tim_range_ave(k-1):sum(Tim_range_ave)-2) = pullData(:,2:Tim_range_ave(k)); 
                end
        end

        for i=1:SUC_num
                subplot(4,4,j,'Parent',p); plot(x,all_pullData(i,:),'Color',[0,0,0]);
                hold on;
        end
        Tim_range_ave_alt = Tim_range_ave*1000/SampleRate;
        plot([Tim_range_ave_alt(1) Tim_range_ave_alt(1)],[0 100],'r');
        hold on;
        plot([Tim_range_ave_alt(1)+Tim_range_ave_alt(2)-1*1000/SampleRate Tim_range_ave_alt(1)+Tim_range_ave_alt(2)-1*1000/SampleRate],[0 100],'r');
        hold on;
        plot(x,mean(all_pullData),'r');
        ylim([0 100]);
        xlim([0 sum(Tim_range_ave_alt)-2*1000/SampleRate]);
        hold on;
        xlabel('time[msec]') % x-axis label
        ylabel('amplitude[uV]') % y-axis label
        title(EMGs{j,1});
    end
    
    if save_fig == 1
     cd EMG_plot_figures;
        saveas(gcf,[ monkeyname xpdate '   each trig   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz.bmp']);
     cd ../;
    end
    if save_data == 1
        cd EMGData
        comment = 'this data were nomalized';
        preprocess = '';
        save([monkeyname xpdate '_centertrig3_corr_.mat'], 'TimeRange','comment', 'Name', 'SampleRate_CTTL','AllCTTL', 'Unit');
    end
end

 