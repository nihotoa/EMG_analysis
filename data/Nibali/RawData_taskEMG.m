%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%【現在使用していない関数】
% coded by:Naohito Ohta
% Last Modification:2022/2/16
% how to use:
% Nibaliをカレントディレクトリにして使う。その日のタスク中の生の筋電データを取得してプロットする(重ね合わせと、平均の2つをプロット)＋そのデータをMatファイルにして保存する
% 基線の動揺をなくすために、低いカットオフ周波数のハイパスをかけるオプションもある
% タスク中の筋電データが必要なので、SYNERGYPLOTを回した結果得られるsuccess_timing.matが必要(EMG_Data→Dataの中にある.matファイル)
% AllData_EMGは、untitled.m内で定義された変数。入っているデータは生データ.転置された状態で保存されているため、解析が少々めんどくさい
% 事前のパラメータの設定を忘れずに行う(monkey_name,exp_dayなど)
% 保存場所は日付→EMG_Dataの中
% 改善点：
% ds100Hzに対応していない(SYNERGYPLOT側で、ds100Hzのsuccess_timingのMATファイルを作って、それを読み込み、生データを1375Hzから100Hzにダウンサンプリングして比較する)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 変数の定義
clear;
monkey_name = 'Ni';
xpdate = 20220301;
data_fold = 'Data';
picture_fold = 'picture';
%↓生データに対する振幅情報か、タスクデータに対する振幅情報かを選択する
plot_task = 1;
high_pass = 1; %ハイパスをかけるかどうか
%↓ハイパスをかける場合
filt_h = 20; %(ハイパスをかける場合の)カットオフ周波数[HZ]
SR = 1375;%(データのサンプリングレート)
define_timing = 1; %0:CAI001のみでの条件 1:define_task=1の時のタイミングデータを使用する 2:define_task=2の時のタイミングデータを使用する


selEMGs= 1:16 ;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
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
%% 筋電データの取得
cd([num2str(xpdate) '/EMG_Data/Data']);

load('AllData_EMG.mat');
%使用するタイミングデータの選択
if define_timing == 0
    load('success_timing.mat')
elseif define_timing == 1
    load('define1_success_timing.mat')
    load('define1_tim_hist.mat')
elseif define_timing == 2
    load('define2_success_timing.mat')
    load('define2_tim_hist.mat')
end


if high_pass == 1
    AllData_EMG = transpose(AllData_EMG);
    for ii = 1 : EMG_num
        [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
        AllData_EMG(ii,:) = filtfilt(B,A,AllData_EMG(ii,:));
    end
else
    AllData_EMG = transpose(AllData_EMG);
end

figure('Position',[0,0,1700,1700]);
for ii=1:EMG_num
    RAW_task_EMG_sel = {};
    for jj = 1:length(success_timing)
        raw_task_trim = AllData_EMG(ii,success_timing(1,jj):success_timing(4,jj));
        %時間正規化
        raw_task_trim = resample(raw_task_trim,1000,length(raw_task_trim));
        RAW_task_EMG_sel{jj,1} = raw_task_trim;
    end
    RAW_task_EMG = cell2mat(RAW_task_EMG_sel);
    RAW_ave_task_EMG = mean(RAW_task_EMG);
    subplot(4,4,ii)
    count = 1;
    for kk = 1:length(RAW_task_EMG_sel)
        for ll = 1:length(RAW_task_EMG)
            if ll == 1
                abs_maxEMG = abs(RAW_task_EMG(kk,ll));
            elseif abs(RAW_task_EMG(kk,ll)) > abs_maxEMG
                abs_maxEMG = abs(RAW_task_EMG(kk,ll));
            end
        end
        if abs_maxEMG < 1000
            plot(RAW_task_EMG(kk,:));
            hold on;
            eval(['number' num2str(ii) '_RAW_task_EMG_sel{' num2str(count) ',1} = RAW_task_EMG(' num2str(kk) ',:);'])
            count = count+1; 
        else
            
        end
    end
    RAW_task_EMG = eval(['number' num2str(ii) '_RAW_task_EMG_sel']);
    RAW_task_EMG = cell2mat(RAW_task_EMG);
    title([EMGs{ii} '(uV)'])
    yyaxis right;
    ylim([0 40])
    histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
    histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
    tim2_median = median(tim_hist(1,:));
    tim3_median = median(tim_hist(2,:));
    xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
    xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
    hold off
    All_RAW_task_EMG{ii,1} = RAW_task_EMG;
    All_RAW_ave_task_EMG{ii,1} = RAW_ave_task_EMG;
end
cd ../../
cd EMG_Data/picture
if define_timing == 0
    if high_pass == 1
        saveas(gcf,['RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'RAW_taskEMG.png');
    end
elseif define_timing == 1
    if high_pass == 1
        saveas(gcf,['define1_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'define1_RAW_taskEMG.png');
    end
elseif define_timing == 2
    if high_pass == 1
        saveas(gcf,['define2_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'define2_RAW_taskEMG.png');
    end
end
close all;
All_RAW_ave_task_EMG = cell2mat(All_RAW_ave_task_EMG);


% タスク中のEMGの平均をプロット
figure('Position',[0,0,1700,1700]);

for ll = 1:EMG_num
    subplot(4,4,ll)
    plot(All_RAW_ave_task_EMG(ll,:))
    hold on
    title([EMGs{ll} '(uV)'])
    yyaxis right;
    ylim([0 40])
    histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
    histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
    tim2_median = median(tim_hist(1,:));
    tim3_median = median(tim_hist(2,:));
    xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
    xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
    hold off
end

if define_timing == 0
    if high_pass == 1
        saveas(gcf,['ave_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'ave_RAW_taskEMG.png');
    end
elseif define_timing == 1 
    if high_pass == 1
        saveas(gcf,['define1_ave_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'define1_ave_RAW_taskEMG.png');
    end
elseif define_timing == 2
    if high_pass == 1
        saveas(gcf,['define2_ave_RAW_taskEMG(highpass_' num2str(filt_h) 'Hz).png']);
    else
        saveas(gcf,'define2_ave_RAW_taskEMG.png');
    end
end
close all;

%データの保存
cd ../
cd Data
if define_timing == 0
    if high_pass == 1
        save(['RAW_task_EMG_Data(highpass_' num2str(filt_h) 'Hz).mat'],'All_RAW_task_EMG','All_RAW_ave_task_EMG');
    else
        save('RAW_task_EMG_Data.mat','All_RAW_task_EMG','All_RAW_ave_task_EMG');
    end
elseif define_timing == 1
    if high_pass == 1
        save(['define1_RAW_task_EMG_Data(highpass_' num2str(filt_h) 'Hz).mat'],'All_RAW_task_EMG','All_RAW_ave_task_EMG');
    else
        save('define1_RAW_task_EMG_Data.mat','All_RAW_task_EMG','All_RAW_ave_task_EMG');
    end
elseif define_timing == 2
    if high_pass == 1
        save(['define2_RAW_task_EMG_Data(highpass_' num2str(filt_h) 'Hz).mat'],'All_RAW_task_EMG','All_RAW_ave_task_EMG');
    else
        save('define2_RAW_task_EMG_Data.mat','All_RAW_task_EMG','All_RAW_ave_task_EMG');
    end
end
cd ../../../