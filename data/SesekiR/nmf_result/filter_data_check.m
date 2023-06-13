%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code written by: Naohito Ohta
% Last modification:2021/12/23
% フィルタリング後の各筋電データを一つのグラフにプロットし、保存してくれる。
% 保存する図の名前、拡張子は適宜変更すること。
% カレントディレクトリをNibali->nmf_resultにして使用すること
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% define variable
real_name='SesekiR';
fold_name='nmf_result';
monkey_name='Se';
exp_day='200317';
task_name='standard';
%% code part

%筋肉の定義
switch real_name
     case 'SesekiR'
        selEMGs=[1:12];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,3) ;
        EMGs{1,1}= 'EDC';
        EMGs{2,1}= 'ED23';
        EMGs{3,1}= 'ED45';
        EMGs{4,1}= 'ECU';
        EMGs{5,1}= 'ECR';
        EMGs{6,1}= 'Deltoid';
        EMGs{7,1}= 'FDS';
        EMGs{8,1}= 'FDP';
        EMGs{9,1}= 'FCR';
        EMGs{10,1}= 'FCU';
        EMGs{11,1}= 'PL';
        EMGs{12,1}= 'BRD';
        EMG_num = 12;
        make_ECoG = 0;
    case 'Nibali'
        selEMGs=[1:16];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
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
end

%プロット範囲の定義
[Max,Min] = DefLim(EMG_num,1);

%プロット＋保存
cd([ monkey_name exp_day '_' task_name]);
figure('Position',[0,0,1000,1000]);
for ii=1:EMG_num
    subplot(4,4,ii);
    load([EMGs{ii,1} '-hp50Hz-rect-lp20Hz-ds100Hz.mat']);
    plot(Data);
    ylim([Min Max])
    title(EMGs{ii,1})
end
saveas(gcf,'filtered-data-check.png')
cd ../

%% define ylim
function [Max,Min]=DefLim(EMG_num,get_first)
    for ii=1:EMG_num
        if get_first == 1
            load([EMGs{1,1} '-hp50Hz-rect-lp20Hz-ds100Hz.mat']);
            Max = max(Data);
            Min = min(Data);
            get_first = 0;
        else
            load([EMGs{1,1} '-hp50Hz-rect-lp20Hz-ds100Hz.mat']);
            if max(Data) > Max
                Max = max(Data);
            end

            if min(Data) < Min
                Min = min(Data);
            end
        end
    end
end