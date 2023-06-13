clear
%% name set

%file info
monkeyname = 'Wa' ; 
xpdate = '181019'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %


band_select = 7;
band_name =  {'delta', 'theta', 'alpha', 'beta1', 'beta2', 'gammma1', 'gamma2', 'high1', 'high2', 'high3'};
band_Hz = [1.5, 4;...  %delta band[Hz]
           4, 8;...    %theta
           8, 14;...   %alpha
           14, 20;...  %beta1
           20, 30;...  %beta2
           30, 50;...  %gammma1
           50, 90;...  %gammma2
           90, 130;... %high1
           130, 170;...%high2
           170, 200];  %high3

plot_range = [0, 100, -1, 1;...  %delta band[Hz]
               0, 40, -1, 1.5;...    %theta
               0, 15, -0.5, 1;...   %alpha
               0, 15, -0.5, 0.5;...  %beta1
               0, 15, -0.5, 0.5;...  %beta2
               0, 15, -1, 1;...  %gammma1
               0, 15, -0.3, 0.3;...  %gammma2
               0, 15, -0.2, 0.2;... %high1
               0, 10, -0.2, 0.2;...%high2
               0, 5, -0.1, 0.1];  %high3
electlode = 20;
map = [2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]; 
%filt_type = '-hp50Hz-rect-lp20Hz-lnsmth100-ds100Hz';
plk = 1;
downdata_to = 100;

%ECoG set
selECoGs=[1:32];
ECoG_num = 32;
ECoG_Hz = 5000;
EMG_Hz = 11000;
EMG_num = 1;
CRAW = 1;
CLFP = 0;
trig = 3;
trig_name = {'StartObj1', 'EndObj1', 'StartObj2', 'EndObj2', 'success'};
rangeF_ms = 1000; %how long do you want to see former part of trigger[msec] 
rangeL_ms = 1000; %how long do you want to see latter part of trigger[msec]

%trig to trig plot
trig_2 = [3 4]; %1:plot obj1 start timing, 
                %2:plot obj1 end timing, 
                %3:plot obj2 start timing, 
                %4:plot obj2 end timing, 
range_normalize = 500;%normalize range of task[msec] 
%% create All Data matrix (CRAW)

cd ECoGData;
cd ([monkeyname xpdate]);
if CRAW == 1
    get_first_data = 1;
        for j = 1:ECoG_num
            load(['CRAW_' sprintf('%03d',j) '(uV)-ds5kHz.mat']);
            if get_first_data
                %load(['CRAW_' sprintf('%03d',j) '-hp50Hz-rect-lp20Hz-lnsmth100-ds100Hz.mat']);
                ECoG_Hz = SampleRate;
                Data_num = length(Data);
                AllECoGData = zeros(Data_num, ECoG_num);
                AllECoGData(:,1) = Data';
                get_first_data = 0;
            else
                %load(['CRAW_' sprintf('%03d',j) '-hp50Hz-rect-lp20Hz-lnsmth100-ds100Hz.mat']);
                AllECoGData(:, j ) = Data';
            end
        end
        get_first_data = 1;
end

%load(['CRAW_' sprintf('%03d',electlode) '(uV)-ds5kHz.mat']);

load([monkeyname xpdate '_SUC_Timing.mat']);
SUC_Timing_A = floor(SUC_Timing_A ./ (EMG_Hz/downdata_to));

cd ../../


%% filt data
%do you use these filt? 1/0 means y/n
%50Hz_hp-rect-20Hz_lp_down_to_100Hz is recommended

%[1]high-pass filter settings
hp_filt = 1;
filt_h = band_Hz(band_select, 1); %cut off frequency [Hz]

%[2]rectify
rectify = 1;

%[3]low-pass filter settings
lp_filt = 1;
filt_l = band_Hz(band_select, 2); %cut off frequency [Hz]

%[4]data smooth settings
datasmooth = 1;
np = 20;%smooth num
kernel = ones(np,1)/np; 
kernel2 = ones(np*50,1)/(np*50); 
%[5]downsampling settings
downsample = 1;
downdata_to = 100; %sampling frequency [Hz]

%which data do you use?
filtData = AllECoGData;
for i=1:ECoG_num
    filtData(:,i) = filtData(:,i) - mean(filtData(:,i));
end
%filter
if hp_filt==1
    [B,A] = butter(4, (filt_h .* 2) ./ ECoG_Hz, 'high');
    for i = 1:ECoG_num
        filtData(:,i) = filter(B,A,filtData(:,i));
    end
end

if lp_filt==1
    [B,A] = butter(4, (filt_l .* 2) ./ ECoG_Hz, 'low');
    for i = 1:ECoG_num
        filtData(:,i) = filter(B,A,filtData(:,i));
    end
end

if rectify==1
    filtData = abs(filtData);
end

if datasmooth==1
     %filtData = smooth(filtData,1,'movmean',smooth_num);
     for i = 1:ECoG_num
        filtData(:,i) = conv2(filtData(:,i),kernel,'same');
     end
end

if downsample==1
        filtData = resample(filtData,downdata_to,ECoG_Hz);
end

%% plot data('pullData')
%plot center trig timing
if plk == 1
    %convert to data number
    rangeF = floor(rangeF_ms*downdata_to/1000); 
    rangeL = floor(rangeL_ms*downdata_to/1000);
    pullData = zeros(rangeF + rangeL + 1 , SUC_num);
    aveAll = pullData;
    aveAllsm = pullData;
    x =  rangeF + 1;
    
    f1 = figure;
    p1 = uipanel('Parent',f1,'BorderType','none');
    p1.TitlePosition = 'centertop'; 
    p1.FontSize = 12;
    p1.FontWeight = 'bold';
    p1.Title = [ monkeyname xpdate '  ' cell2mat(trig_name(trig)) '  ' cell2mat(band_name(band_select)) '  ' sprintf('%d', filt_h) 'HzHP' sprintf('%d', filt_l) 'HzLP-100Hz'];
    
    f2 = figure;
    p2 = uipanel('Parent',f2,'BorderType','none');
    p2.TitlePosition = 'centertop'; 
    p2.FontSize = 12;
    p2.FontWeight = 'bold';
    p2.Title = [ monkeyname xpdate '  ' cell2mat(trig_name(trig)) '  ' cell2mat(band_name(band_select)) '  ' sprintf('%d', filt_h) 'HzHP' sprintf('%d', filt_l) 'HzLP-100Hz-rect-' sprintf('%d',np) 'smooth'];
    
    f3 = figure;
    p3 = uipanel('Parent',f3,'BorderType','none');
    p3.TitlePosition = 'centertop'; 
    p3.FontSize = 12;
    p3.FontWeight = 'bold';
    p3.Title = [ monkeyname xpdate '  ' cell2mat(trig_name(trig)) '  ' cell2mat(band_name(band_select)) '  def  ' sprintf('%d', filt_h) 'HzHP' sprintf('%d', filt_l) 'HzLP-100Hz-rect-' sprintf('%d',np) 'smooth'];
    
    for j = 1:ECoG_num
        for i=1:SUC_num
            if SUC_Timing_A(i,trig)-rangeF > 0 && SUC_Timing_A(i,trig) + rangeL < length(filtData(:,1))
                pullData(:,i) = filtData(SUC_Timing_A(i,trig) - rangeF : SUC_Timing_A(i,trig) + rangeL,j);
            else
                pullData(1,i) = 1000;
            end
        end

        ave = zeros(length(pullData(:,1)),1); 
        figure(f1);
        for i=1:SUC_num
            if pullData(1,i) ~= 1000
                subplot(8,8,map(j),'Parent',p1); 
                plot(pullData(:,i),'Color',[0,0,0]);
                hold on;
                ave = ((ave .* (i-1)) + pullData(:,i)) ./ i;
            end
        end
        
        plot([(rangeF + 1) (rangeF + 1)],[-100 100],'y');
        hold on;
        plot(ave,'r');
        
        ylim([plot_range(band_select,1) plot_range(band_select,2)]);
        xlim([0 (rangeF + rangeL + 1)]);
        hold on;
        
        figure(f2);
        aveAllsm(:,j) = ave;
        aveAll(:,j) = abs(ave)./max(abs(ave));
        aveAll(:,j) = conv2(aveAll(:,j),kernel,'same');
        subplot(8,8,map(j),'Parent',p2); 
        
        hold on;
        plot(aveAll(:,j),'Color','r');
        ylim([0 1]);
        xlim([0 (rangeF + rangeL + 1)]);
        %title(ECoGs{j,1});
    end
    figure(f3);
    aveAll = aveAllsm;
    aveave = sum(aveAllsm,2)./ECoG_num;
    for j=1:ECoG_num
        aveAll(:,j) = aveAll(:,j) - aveave;
        %aveAll(:,j) = aveAll(:,j)./max(aveave)*100;
        aveAll(:,j) = conv2(aveAll(:,j),kernel,'same');
        subplot(8,8,map(j),'Parent',p3); 
        plot([(rangeF + 1) (rangeF + 1)],[-1 1]);
        hold on;
        plot([0 (rangeF + rangeL + 1)],[0 0],'k');
        plot(aveAll(:,j),'Color','r');
        hold on;
        ylim([plot_range(band_select,3) plot_range(band_select,4)]);
        xlim([0 (rangeF + rangeL + 1)]);
    end
    figure;
    plot(aveave);
    title([ monkeyname xpdate '  ' cell2mat(trig_name(trig)) '  ' cell2mat(band_name(band_select)) 'AVERAGE BAND']);
    xlim([0 (rangeF + rangeL + 1)]);
end
