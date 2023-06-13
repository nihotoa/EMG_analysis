%this is plot program of takei sensei filter program


clear
%% set file name and so on
monkeyname = 'Wa' ; 
xpdate = '180928'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [2:4];
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

trig = 3; %1:plot obj1 start timing, 
          %2:plot obj1 end timing, 
          %3:plot obj2 start timing, 
          %4:plot obj2 end timing, 

downdata_to = 100;
rangeF_ms = 750; %how long do you want to see former part of trigger[msec] 
rangeL_ms = 750; %how long do you want to see latter part of trigger[msec]

plk = 3; %1:plot obj2 start timing, 2:plot stim timing

range_normalize = 1500;%normalize range of task[msec]       

wk_filt = '-hp50Hz-rect-lp20Hz-lnsmth100-ds100Hz';
save_fold ='new_nmf_result';
save_data = 0;
save_fig = 0;

%% load data
filtData = zeros(19596,EMG_num);
cd(save_fold)
cd ([monkeyname xpdate])
    load([monkeyname xpdate '_SUC_Timing.mat']);
    for i = 1:EMG_num
        load([cell2mat(EMGs(i,1)) wk_filt '.mat']);
        filtData(:,i) = Data'; 
    end
cd ../
cd ../
EMG_Hz = 11000;
SUC_Timing_A = floor(SUC_Timing_A ./ (EMG_Hz/downdata_to));
%% plot

f = figure;
p = uipanel('Parent',f,'BorderType','none');
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

if plk == 1
    %convert to data number
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
        ylim([0 65]);
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