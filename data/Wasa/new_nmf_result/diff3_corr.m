
clear
%% set file name and so on
monkeyname = 'Wa' ; 
xpdate = '180925'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
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
EMG_Hz = 11000;%sampling rate [Hz]
wk = 1; %1:plot obj2 start timing, 2:plot stim timing
save_fold = 'new_nmf_result';
save_data = 1;
save_fig = 1;


%% load
All3Data_sel = cell(1,EMG_num);
cd([monkeyname xpdate])
for ii = 1:EMG_num
    load([EMGs{ii} '''''''.mat']);
    All3Data_sel{ii} = Data';
end
cd ../
All3Data = cell2mat(All3Data_sel);

downsample = 1;
downdata_to = 5000; %sampling frequency [Hz]
filtData = All3Data;
if downsample==1
    filtData = resample(filtData,downdata_to,EMG_Hz);
    SampleRate = downdata_to;
end

%% xcorr
R = cell(EMG_num);
LAGs = cell(EMG_num);
for i=1:EMG_num
    for j=1:EMG_num
        [r,lag] = xcorr(filtData(:,i),filtData(:,j));
        R{i,j} = r;
        LAGs{i,j} = lag;
%         figure;
%         plot(LAGs{i,j},R{i,j});
%         title([EMGs{i} '-' EMGs{j}]);
    end
end

%% 
for i=1:EMG_num
    for j=1:EMG_num
        figure;
        plot(LAGs{i,j},R{i,j});
        title([EMGs{i} '-' EMGs{j}]);
    end
end