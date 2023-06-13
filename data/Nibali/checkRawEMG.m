%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%coded by : Naohito Ohta
%final update : 2022.03.15
%purpose:
%EMGが適切に記録できているか(振幅がおかしな値を取っていないか、レシーバーが外れていないか等)を確認するためのプログラム
%必ずしも必要なステップではなく、解析結果がおかしいときに使うコードという認識で使ってください。
%使用方法:
%カレントディレクトリをNibaliにして使用する
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set parameter
monkey_name = 'Ni';
xpdate = 20220301;
picture_fold = 'picture';

selEMGs= 1:16 ;
EMGs=cell(16,1);
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
%% program section
cd(num2str(xpdate));
load(['AllData_' monkey_name num2str(xpdate) '.mat']);

figure('Position',[0,0,1700,1700]);
for ii = 1:EMG_num
    subplot(4,4,ii);
    EMG_file = eval(['CEMG_' sprintf('%03d',ii)]);
    plot(EMG_file);
    hold on;
    title([EMGs{ii} '(uV)'])
end
hold off
cd(['EMG_Data/' picture_fold])
saveas(gcf,'checkRawEMG.png')
close all;
cd ../../../