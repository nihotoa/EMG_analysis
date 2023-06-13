function [ AVE ] = YaEMGeach_func( monkeyname, xpdate, file_num,SUC_Timing_A,timw_ave )
%YAEMGEACH_FUNC Summary of this function goes here
%   Detailed explanation goes here
%% set parameter

%file info
% monkeyname = 'Ya' ; 
% xpdate = '170529'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
% file_num = [2,5];
% SUC_fold = 'new_nmf_result';

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
plk = 3; %set plot kinds(1:center trig plot, 2:trig to trig, )

% each trig plot
% each_nomalized_per = [30 50 50 50 30];

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
hp_filt = 1;
filt_h = 50; %cut off frequency [Hz]

%[2]rectify
rectify = 1;

%[3]low-pass filter settings
lp_filt = 1;
filt_l = 20; %cut off frequency [Hz]

%[4]data smooth settings
datasmooth = 1; 
np = 220;%smooth num
kernel = ones(np,1)/np; 

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

if datasmooth==1
    for i = 1:EMG_num
%     filtData = smooth(filtData,1,'movmean',smooth_num);
        filtData(:,i) = conv2(filtData(:,i),kernel,'same');
    end
end


if downsample==1
    filtData = resample(filtData,downdata_to,EMG_Hz);
    SampleRate = downdata_to;
else 
    downdata_to = EMG_Hz;
end

%% plot settings
SUC_num = length(SUC_Timing_A(:,1));
SUC_Timing_A = floor(SUC_Timing_A ./ (EMG_Hz/downdata_to));
timw_ave = floor(timw_ave ./ (EMG_Hz/downdata_to));
timing_ave = zeros(1,6);
timing_ave(2) = timw_ave(1);
timing_ave(3) = timw_ave(1) + timw_ave(2)-1;
timing_ave(4) = timing_ave(3) + timw_ave(3) - 1;
timing_ave(5) = timing_ave(4) + timw_ave(4) - 1;
timing_ave(6) = timing_ave(5) + timw_ave(5) - 1;

if downsample==1
    SampleRate = downdata_to;
end
% f = figure('Position',[500,500,1500,1000]);
% f = figure('Position',[300,0,1300,900]);

%% plot data('pullData')

%plot trig to trig(each trig)
if plk == 3
%     SUC_num = 142;
    sec = zeros(3,1);
    Tim_range_ave = timw_ave;
    all_pullData = zeros(SUC_num,sum(Tim_range_ave)-4);
    x = linspace(0,sum(Tim_range_ave)*1000/SampleRate,sum(Tim_range_ave)-4);
    for j = 1:EMG_num   
        for k = 1:5
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
                    all_pullData(:,Tim_range_ave(k-2)+Tim_range_ave(k-1):Tim_range_ave(k-2)+Tim_range_ave(k-1)+Tim_range_ave(k)-2) = pullData(:,2:Tim_range_ave(k)); 
                end
                if k == 4
                    all_pullData(:,Tim_range_ave(k-3)+Tim_range_ave(k-2)+Tim_range_ave(k-1)-1:Tim_range_ave(k-3)+Tim_range_ave(k-2)+Tim_range_ave(k-1)+Tim_range_ave(k)-3) = pullData(:,2:Tim_range_ave(k)); 
                end
                if k == 5
                    all_pullData(:,Tim_range_ave(k-4)+Tim_range_ave(k-3)+Tim_range_ave(k-2)+Tim_range_ave(k-1)-2:sum(Tim_range_ave)-4) = pullData(:,2:Tim_range_ave(k)); 
                end
        end

        if j == 1
            timing_ave_ms = timing_ave*1000/SampleRate;
        end
            figure;
        for i=1:SUC_num
            plot(x,all_pullData(i,:),'Color',[0,0,0]);
            hold on;
        end
            plot([timing_ave_ms(2) timing_ave_ms(2)],[0 100],'y');
%             hold on;
            plot([timing_ave_ms(3) timing_ave_ms(3)],[0 100],'y');
%             hold on;
            plot([timing_ave_ms(4) timing_ave_ms(4)],[0 100],'y');
%             hold on;
            plot([timing_ave_ms(5) timing_ave_ms(5)],[0 100],'y');
%             hold on;
            AVE = mean(all_pullData);
            plot(x,AVE,'r');
            ylim([0 100]);
            xlim([0 timing_ave_ms(end)]);
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

 

end

