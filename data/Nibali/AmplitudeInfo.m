%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% coded by:Naohito Ohta
% Last Modification:2022/2/15
% how to use:
% Nibaliをカレントディレクトリにして使う。その日のタスク中の筋電データの平均から振幅情報を取得してプロットする＋そのデータをMatファイルにして保存する
% タスク中の筋電データが必要なので、SYNERGYPLOTを回した結果得られるtask_EMG_Data.matが必要
% このプログラムでは、振幅情報を離散信号のroot mean square (RMS)を用いて求めている
% RMSは２乗値の平均に平方根をとったもの
% 保存場所は日付→EMG_Data→AmplitudeInfoの中
% 改善点：
% group_numをデータ数に対する公約数にしないとエラー吐くから、resamplingするなどして対処する
% 平均する区間をgroup_numではなくて、秒数で指定できるようにすべき
% タスクに対してうまく作動してない
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 変数の定義
clear;
monkey_name = 'Ni';
xpdate = 211222;
group_num = 1; %←何個のデータをひとまとまりとするかを選択(データ数に対する公約数じゃないとエラー吐く)
data_fold = 'Data';
picture_fold = 'picture';
%↓生データに対する振幅情報か、タスクデータに対する振幅情報かを選択する
plot_task = 1;
plot_RAW = 0; %plot_task

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
cd([num2str(xpdate) '/EMG_Data/Data'])

if plot_task == 1
    load('task_EMG_Data.mat') %SYNERGYPLOTで作られるMATファイル    
    T = (ave_sample_num/1350) * (group_num/1000);
    %↑RMSのデータのひとまとまりが何秒であるかをTに代入(単位は[s])
elseif plot_RAW ==1
    load('AllData_EMG.mat')
    AllData_EMG = transpose(AllData_EMG);
    T = group_num/1350; %
end

for ii = 1:EMG_num
    %↓RMS
    if plot_task == 1
        Data = reshape(All_ave_task_EMG(ii,:),group_num,length(All_ave_task_EMG)/group_num);
        Data = rms(Data);
        AmpInfo_sel{ii,1} = Data;
    elseif plot_RAW == 1
        Data = reshape(AllData_EMG(ii,:),group_num,length(AllData_EMG)/group_num);
        Data = rms(Data);
        AmpInfo_sel{ii,1} = Data;
    end
end

figure('Position',[0,0,1700,1700]);
for jj = 1:EMG_num
    subplot(4,4,jj)
    plot(AmpInfo_sel{jj,1})
    title([EMGs{jj,1} '(uV)'])
    hold on
end
hold off

AmpInfo = cell2mat(AmpInfo_sel);

cd ../;

mkdir(data_fold);
mkdir(picture_fold);

if plot_task == 1 
    saveas(gcf,['AmplitudeInfo(task_ave group=' num2str(group_num) ').png'])
    movefile(['AmplitudeInfo(task_ave group=' num2str(group_num) ').png'],picture_fold)
    save(['AmplitudeInfo(task_ave group=' num2str(group_num) ').mat'],'AmpInfo','group_num','T')
    movefile(['AmplitudeInfo(task_ave group=' num2str(group_num) ').mat'],data_fold)
    close all;
elseif plot_RAW == 1
    saveas(gcf,['AmplitudeInfo(RAW group=' num2str(group_num) ').png'])
    movefile(['AmplitudeInfo(RAW group=' num2str(group_num) ').png'],picture_fold)
    save(['AmplitudeInfo(RAW group=' num2str(group_num) ').mat'],'AmpInfo','group_num','T')
    movefile(['AmplitudeInfo(RAW group=' num2str(group_num) ').mat'],data_fold)
    close all;
end
cd ../../
