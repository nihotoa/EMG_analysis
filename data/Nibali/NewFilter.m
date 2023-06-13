%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%【現在使用していない関数】
%coded by : Naohito Ohta
%Last modification : 2022.1.12
%RAWデータに前処理を施す関数
%実験日、サルの名前、ハイパス、ローパスの周波数、RAWデータのサンプリング周波数などを設定して回す
%カレントディレクトリをNibaliにして使用する
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set parameters
exp_day = '20220301';
monkey_name = 'Ni';

EMGs=cell(16,1) ;
EMGs{1,1}= 'EDC-A';
EMGs{2,1}= 'EDC-B';
EMGs{3,1}= 'ED23';
EMGs{4,1}= 'ED45';
EMGs{5,1}= 'ECR';
EMGs{6,1}= 'ECU';
EMGs{7,1}= 'BRD';
EMGs{8,1}= 'EPL-B';
EMGs{9,1}= 'FDS-A';
EMGs{10,1}= 'FDS-B';
EMGs{11,1}= 'FDP';
EMGs{12,1}= 'FCR';
EMGs{13,1}= 'FCU';
EMGs{14,1}= 'FPL';
EMGs{15,1}= 'Biceps';
EMGs{16,1}= 'Triceps';
EMG_num = 16;

filt_h = 50; %cut off frequency [Hz]
filt_l = 20; %cut off frequency [Hz]
SR = 1375; %SamplingRate
%% program section
cd([exp_day '/nmf_result/' monkey_name exp_day '_standard' ])
for ii = 1:EMG_num
    load([EMGs{ii,1} '(uV).mat'])
    Data(1,:) = Data(1,:) - mean(Data(1,:));
    [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
    Data(1,:) = filtfilt(B,A,Data(1,:));
    
    Data = abs(Data);

    [B,A] = butter(6, (filt_l .* 2) ./ SR, 'low');
    Data(1,:) = filtfilt(B,A,Data(1,:));
    
    Name = ['NEW_' EMGs{ii,1} '-hp' num2str(filt_h) 'Hz-rect-lp' num2str(filt_l) 'Hz'];
    save([Name '.mat'],'Class','Data','Name','SampleRate','TimeRange','Unit')
end

