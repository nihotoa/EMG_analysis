%% This program is analysis for EMG averaging
%
clear
%% set parameter

%file info
monkeyname = 'Wa' ; 
xpdate = '180928'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
SUC_fold = 'new_nmf_result';

%ECoG set
selECoGs=(1:64);
ECoGs = {'CRAW_001';'CRAW_002';'CRAW_003';'CRAW_004';'CRAW_005';'CRAW_006';'CRAW_007';'CRAW_008';'CRAW_009';'CRAW_010';...
           'CRAW_011';'CRAW_012';'CRAW_013';'CRAW_014';'CRAW_015';'CRAW_016';'CRAW_017';'CRAW_018';'CRAW_019';'CRAW_020';...
           'CRAW_021';'CRAW_022';'CRAW_023';'CRAW_024';'CRAW_025';'CRAW_026';'CRAW_027';'CRAW_028';'CRAW_029';'CRAW_030';...
           'CRAW_031';'CRAW_032';'CRAW_033';'CRAW_034';'CRAW_035';'CRAW_036';'CRAW_037';'CRAW_038';'CRAW_039';'CRAW_040';...
           'CRAW_041';'CRAW_042';'CRAW_043';'CRAW_044';'CRAW_045';'CRAW_046';'CRAW_047';'CRAW_048';'CRAW_049';'CRAW_050';...
           'CRAW_051';'CRAW_052';'CRAW_053';'CRAW_054';'CRAW_055';'CRAW_056';'CRAW_057';'CRAW_058';'CRAW_059';'CRAW_060';...
           'CRAW_061';'CRAW_062';'CRAW_063';'CRAW_064'};
ECoG_num = length(ECoGs);

%plot & save settings
plk = 3; %set plot kinds(1:center trig plot, 2:trig to trig, )

%center trig plot
trig = 3; %1:plot obj1 start timing, 
          %2:plot obj1 end timing, 
          %3:plot obj2 start timing, 
          %4:plot obj2 end timing, 
          %5:plot StimMarker(AO) timing
          %6:plot CTTL(NK) timing
rangeF_ms = 750; %how long do you want to see former part of trigger[msec] 
rangeL_ms = 750; %how long do you want to see latter part of trigger[msec]

%trig to trig plot
trig_2 = [1 4]; %1:plot obj1 start timing, 
                %2:plot obj1 end timing, 
                %3:plot obj2 start timing, 
                %4:plot obj2 end timing, 
range_normalize = 1500;%normalize range of task[msec]           

%all trig normalized plot
save_data = 0; %1/0 means y/n 
save_fig =1; %1/0 means y/n

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
    end
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

f = figure('Position',[500,500,1500,1000]);
p = uipanel('Parent',f,'BorderType','none');
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';
if plk ==1
    p.Title = [ monkeyname xpdate '   start obj2   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz'];
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
    
    if trig>=5
      %I will write code to plot stim trigger signals
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
                subplot(4,4,j,'Parent',p); plot(all_pullData(i,:),'Color',[0,0,0]);
                hold on;
        end
        plot([Tim_range_ave(1) Tim_range_ave(1)],[0 100],'r');
        hold on;
        plot([Tim_range_ave(1)+Tim_range_ave(2)-1 Tim_range_ave(1)+Tim_range_ave(2)-1],[0 100],'r');
        hold on;
        plot(mean(all_pullData),'r');
        ylim([0 70]);
        xlim([0 sum(Tim_range_ave)-2]);
        hold on;
        title(EMGs{j,1});
    end
end
%% save figure
 if save_fig == 1
     cd EMG_plot_figures;
     saveas(gcf,[ monkeyname xpdate '   each trig   ' sprintf('%d', filt_h) 'HzHP-rect-' sprintf('%d', filt_l) 'HzLP-100Hz.bmp']);
     cd ../;
 end