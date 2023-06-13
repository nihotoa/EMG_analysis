%% This program is analysis for EMG averaging
%
clear
%% set parameter

%file info
monkeyname = 'Ma' ; 
xpdate = '170327'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [2,2];
SUC_fold = 'new_nmf_result';

%EMG set
selEMGs=[1:8];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
EMGs=cell(8,1) ;
EMGs{1,1}= 'EDC';
EMGs{2,1}= 'ECR';
EMGs{3,1}= 'BRD_1';
EMGs{4,1}= 'FCU';
EMGs{5,1}= 'FCR';
EMGs{6,1}= 'BRD_2';
EMGs{7,1}= 'FDPr';
EMGs{8,1}= 'FDPu';
% EMGs{9,1}= 'ECU';
% EMGs{10,1}= 'EDC';
% EMGs{11,1}= 'FDS';
% EMGs{12,1}= 'FDP';
% EMGs{13,1}= 'FCU';
% EMGs{14,1}= 'FCR';
a = cummax(selEMGs,'reverse');
EMG_num = a(1,1);

%plot & save settings
plk = 3; %set plot kinds(1:center trig plot, 2:trig to trig, )

%center trig plot
trig = 3; %1:plot obj1 start timing, 
          %2:plot obj1 end timing, 
          %3:plot obj2 start timing, 
          %4:plot obj2 end timing, 
          %5:plot StimMarker(AO) timing
          %6:plot CTTL(NK) timing
          
ex_CTTL = 0;
ex_CStimMarker =1;
stim_type = 'ICMS11-8_12';%SRstim,ICMS,EMGstim

rangeF_ms = 500; %how long do you want to see former part of trigger[msec] 
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
save_fig =1; %1/0 means y/n

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
hp_filt = 1;
filt_h = 50; %cut off frequency [Hz]

%[2]rectify
rectify = 1;

%[3]low-pass filter settings
lp_filt = 1;
filt_l = 20; %cut off frequency [Hz]

%[4]data smooth settings
datasmooth = 0;
smooth_num = 200; 

%[5]downsampling settings
downsample = 1;
downdata_to = 100; %sampling frequency [Hz]

%which data do you use?
filtData = AllData;

if hp_filt==1
    [B,A] = butter(2, (filt_h .* 2) ./ 11000, 'high');
    for i = 1:EMG_num
        filtData(:,i) = filter(B,A,filtData(:,i));
    end
end

if rectify==1
    filtData = abs(filtData);
end

if lp_filt==1
    [B,A] = butter(2, (filt_l .* 2) ./ 11000, 'low');
    for i = 1:EMG_num
        filtData(:,i) = filter(B,A,filtData(:,i));
    end
end

% if datasmooth==1
%     filtData = smooth(filtData,1,'movmean',smooth_num);
% end


if downsample==1
    filtData = resample(filtData,downdata_to,EMG_Hz);
    SampleRate = downdata_to;
end

%% plot settings

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
SUC_Timing_A = floor(SUC_Timing_A ./ (EMG_Hz/downdata_to));
if downsample==1
    SampleRate = downdata_to;
end
% f = figure('Position',[500,500,1500,1000]);
f = figure('Position',[300,0,1300,900]);
p = uipanel('Parent',f,'BorderType','none');
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';
if plk ==1
    p.Title = [ monkeyname xpdate '   start obj2   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz'];
    if trig>=5
        p.Title = [ monkeyname xpdate '   ' stim_type '   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz'];
    end
end
if plk ==2
    p.Title = [ monkeyname xpdate ' TTL' sprintf('%d',trig_2(1)) ' to  TTL' sprintf('%d',trig_2(2)) sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz'];
end
if plk ==3
    p.Title = [ monkeyname xpdate '   each range normalized   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz'];
end

%% plot data('pullData')
%plot center trig timing
if plk == 1
    %convert to data number
    if trig<=4
        rangeF = floor(rangeF_ms*downdata_to/1000); 
        rangeL = floor(rangeL_ms*downdata_to/1000);
        pullData = zeros(rangeF + rangeL + 1 , SUC_num);
        x =  rangeF + 1;

        for j = 7:EMG_num
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
                    figure;
                    x = linspace(-rangeF_ms,rangeL_ms,length(pullData(:,i)));
%                     subplot(2,1,j-6,'Parent',p); 
                    plot(x, pullData(:,i),'Color',[0,0,0]);
%                     plot([(rangeF + 1)*((rangeF_ms + rangeL_ms)/length(pullData(:,i)))-500 (rangeF + 1)*((rangeF_ms + rangeL_ms)/length(pullData(:,i)))-500],[0 100],'r');
                    title([EMGs{j} '-' sprintf('%d', file_num(1)) '-' sprintf('%d',i)]);
                    if save_fig == 1
                     cd EMG_plot_figures;
                     saveas(gcf,[ monkeyname xpdate '-' sprintf('%d', file_num(1)) '-trig2-' EMGs{j} '-' sprintf('%d',i ) '-' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz.bmp']);
                     cd ../;
                    end
                    hold on;
%                     close;
                    ave = ((ave .* (i-1)) + pullData(:,i)) ./ i;
                end
            end
            close all;
%             plot([(rangeF + 1) (rangeF + 1)],[0 100],'r');
%             hold on;
%             plot(ave,'r');
%             ylim([0 100]);
%             xlim([0 (rangeF + rangeL + 1)]);
%             hold on;
%             title(EMGs{j,1});
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
                        subplot(4,4,j,'Parent',p); plot(pullData(:,i),'Color',[0,0,0]);
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
%         stim_tim = floor(stim_tim ./ (SampleRate_CStimMarker/downdata_to)); %down to 100Hz

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

                for i=1:stim_num
                    if pullData(1,i) ~= 1000
                        subplot(7,2,j,'Parent',p); plot(pullData(:,i),'Color',[0,0,0]);
                        hold on;
                        ave = ((ave .* (i-1)) + pullData(:,i)) ./ i;
                    end
                end

                plot([(rangeF + 1) (rangeF + 1)],[0 100],'r');
                hold on;
                plot(ave,'r');
                ylim([-50 50]);
                xlim([0 60]);
                
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
    
    for j = 7:7
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
                figure;
                plot(pullData(i,:),'Color',[0,0,0]);
                hold on;
                ave = ((ave .* (i-1)) + pullData(i,:)) ./ i;
        end
       % plot([(rangeF + 1) (rangeF + 1)],[0 100],'r');
       % hold on;
%         plot(ave,'r');
        ylim([0 60]);
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
                subplot(4,2,j,'Parent',p); plot(x,all_pullData(i,:),'Color',[0,0,0]);
                hold on;
        end
        Tim_range_ave_alt = Tim_range_ave*1000/SampleRate;
        plot([Tim_range_ave_alt(1) Tim_range_ave_alt(1)],[0 400],'y');
        hold on;
        plot([Tim_range_ave_alt(1)+Tim_range_ave_alt(2)-1*1000/SampleRate Tim_range_ave_alt(1)+Tim_range_ave_alt(2)-1*1000/SampleRate],[0 400],'y');
        hold on;
        plot(x,mean(all_pullData),'r');
        ylim([0 400]);
        xlim([0 sum(Tim_range_ave_alt)-2*1000/SampleRate]);
        hold on;
%         xlabel('time[msec]') % x-axis label
%         ylabel('amplitude[uV]') % y-axis label
        title(EMGs{j,1});
    end
    
    if save_fig == 1
     cd EMG_plot_figures;
     saveas(gcf,[ monkeyname xpdate '-' sprintf('%d', file_num(1)) '   each trig   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz.bmp']);
     cd ../;
    end
end

 