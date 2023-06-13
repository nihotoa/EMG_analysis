%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Coded by: Naohito Ohta
%Last Modification:2022/06/02
%EMGと動作解析の結果を比較するためのコード
%利便性ために、カレントディレクトリをMATLABにして実行する
%事前準備:

%改善点(注意点)
%EMGデータを読み込んで入るが,現状使用していない(3次元座標の軌跡とEMGの菌活動の変遷を一つの図で表したい時には使えるが,現状作ってない)
%日毎のデータの平均に使うかもしれないので,stackだけでなく,平均の標準偏差の図作る(平均のデータはmatファイルとして出力する→全体データを.matで出力すればいい)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
conducted_path = pwd; %カレントディレクトリの絶対パスを代入
experiment_date1 = 20220520;
experiment_date2 = 220520;
monkey_name = 'Nibali';
timing_type = 'tim3'; %どのタイミングを基準にするか?(現状tim3にしか対応していない)
extra_information = 1; %1になっている場合は,pre_frame前,post_frame前も考慮して(pre_trimmed,post_trimmedを用いて)プロットを行う
pre_frame = 300; %上記のtiming_typeの時に、そのタイミングからpre,post何サンプル分をトリミングするか
post_frame = 100;
pre_trimmed= 600;%タスクとは別に,pre何サンプル分までプロットするか?
post_trimmed = 200;
orig_frame_rate = 180;%動作解析に使用した動画のフレームレート
EMG_SR = 1375;
judge = 1; %MonkeyExp_DLTのDLT_resultのjudgeONとjudgeOFFのどちらを使うか(judge = 1 → judgeON)
use_point = [1 4]; %使用するマーカーポイント(複数選択可能) 1:親指の爪 2:人差し指の爪 3:人差し指のDIP 4:人差し指のPIP 
graph_header = {'thumb1 X' 'thumb1 Y' 'thumb1 Z'...
                'index3 X','index3 Y','index3 Z'};

%% code section

%必要なデータを読み込む
load(['3D-pose-estimation/MonkeyExp_DLT/DLT_result/judgeON/' num2str(experiment_date2) '/task_3D_coodinate.mat']) %動作解析の3次元座標データ
load(['3D-pose-estimation/compileTrimingMovie/referenceMovie/' num2str(experiment_date1) '/red_LED_timing.mat']) %red_LEDのタイミングデータ
load(['data/' monkey_name '/' num2str(experiment_date1) '/EMG_Data/Data/task_' timing_type '_pre-' num2str(pre_frame) '_post-' num2str(post_frame) 'RAW_EMG.mat']) %指定したタイミング周りで切り出されたEMGデータ

%% 動作解析データを処理していく
if strcmp(timing_type,'tim3')
    max_frame = max(red_LED_timing(:,2)); %タイミング1→3で、最も時間がかかったタスクのフレーム数を抽出
end

align_frame = max_frame; %下のfor文で作る行列のタイミング3の位置は,max_frameと同じなので、可読性の向上のため、その値を新しい変数に代入

for ii = 1:length(All_output)
    for jj = use_point
        point_x = transpose(All_output{1,ii}(:,(3*jj)-2));  %(3*jj)-2は、ポイントjjのx座標
        point_y = transpose(All_output{1,ii}(:,(3*jj)-1));
        point_z = transpose(All_output{1,ii}(:,(3*jj)));
        
        if strcmp(timing_type,'tim3')
            if jj == use_point(1,1) %1タスクにつき、この操作は一回で十分
                ex_frame = max_frame - red_LED_timing(ii,2);
            end
        end
        temp = [NaN(1,ex_frame) point_x];  
        eval([timing_type '_point' num2str(jj) '_x{ii,1} = evalin("base","temp");']);
        temp = [NaN(1,ex_frame) point_y];  
        eval([timing_type '_point' num2str(jj) '_y{ii,1} = evalin("base","temp");']);
        temp = [NaN(1,ex_frame) point_z];  
        eval([timing_type '_point' num2str(jj) '_z{ii,1} = evalin("base","temp");']);
    end
end

%直前のfor文で得られたデータをリサンプリングしていく
for ii = 1:length(All_output)
    for jj = use_point
        eval([timing_type '_point' num2str(jj) '_x{ii,1} = resample(' timing_type '_point' num2str(jj) '_x{ii,1},EMG_SR,orig_frame_rate);']);
        eval([timing_type '_point' num2str(jj) '_y{ii,1} = resample(' timing_type '_point' num2str(jj) '_y{ii,1},EMG_SR,orig_frame_rate);']);
        eval([timing_type '_point' num2str(jj) '_z{ii,1} = resample(' timing_type '_point' num2str(jj) '_z{ii,1},EMG_SR,orig_frame_rate);']);
    end
end
align_frame = round(align_frame * (EMG_SR/orig_frame_rate)); %align_frameも、リサンプリングする

%指定された範囲でトリミングして、行列にまとめる
for ii = 1:length(All_output)
    for jj = use_point
        if extra_information == 1
            % trimed_tim3_point1_x(1,:) = tim3_point1_x{1,1}(align_frame - pre_frame+1 : align_frame + post_frame);
            eval(['trimed_' timing_type '_point' num2str(jj) '_x(ii,:) =' timing_type '_point' num2str(jj) '_x{ii,1}(align_frame - pre_trimmed+1 : align_frame + post_trimmed);' ])
            eval(['trimed_' timing_type '_point' num2str(jj) '_y(ii,:) =' timing_type '_point' num2str(jj) '_y{ii,1}(align_frame - pre_trimmed+1 : align_frame + post_trimmed);' ])
            eval(['trimed_' timing_type '_point' num2str(jj) '_z(ii,:) =' timing_type '_point' num2str(jj) '_z{ii,1}(align_frame - pre_trimmed+1 : align_frame + post_trimmed);' ])
        elseif extra_information == 0
            % trimed_tim3_point1_x(1,:) = tim3_point1_x{1,1}(align_frame - pre_frame+1 : align_frame + post_frame);
            eval(['trimed_' timing_type '_point' num2str(jj) '_x(ii,:) =' timing_type '_point' num2str(jj) '_x{ii,1}(align_frame - pre_frame+1 : align_frame + post_frame);' ])
            eval(['trimed_' timing_type '_point' num2str(jj) '_y(ii,:) =' timing_type '_point' num2str(jj) '_y{ii,1}(align_frame - pre_frame+1 : align_frame + post_frame);' ])
            eval(['trimed_' timing_type '_point' num2str(jj) '_z(ii,:) =' timing_type '_point' num2str(jj) '_z{ii,1}(align_frame - pre_frame+1 : align_frame + post_frame);' ])
        end
    end
end

%プロットする
plot_axis = {'x','y','z'};
h = figure;
h.WindowState = 'maximized';
for ii = use_point
    for jj = 1:3 %x,y,z
        subplot(length(use_point),3,3*(find(use_point == ii)-1)+jj);
        for kk = 1:length(All_output)
            grid on;
            reference_data = eval(['trimed_' timing_type '_point' num2str(ii) '_' plot_axis{jj} '(kk,:);']);
            plot(reference_data)
            hold on
        end
        if extra_information == 1
            xline(pre_trimmed,'red','Color',[186 85 211]/255,'LineWidth',2.5);
            xline(pre_trimmed-pre_frame+1,'red','Color',[255 0 0]/255,'LineWidth',2.5);
            xline(pre_trimmed+post_frame,'red','Color',[0 255 0]/255,'LineWidth',2.5);
        else
            xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2.5);
        end
        title(graph_header{3*(find(use_point == ii)-1)+jj},'FontSize',20)
        hold off
    end
end
%図を保存する
mkdir(['resampled_3D_coodination/data/' num2str(experiment_date1)])
mkdir(['resampled_3D_coodination/image/' num2str(experiment_date1)])
if extra_information == 1
    saveas(gcf,['resampled_3D_coodination/image/' num2str(experiment_date1) '/extra_resampled_3D_coodinate(pre-' num2str(pre_trimmed)  '_post-' num2str(post_trimmed) ').png'])
    save(['resampled_3D_coodination/data/' num2str(experiment_date1) '/extra_resampled_3D_coodinate(pre-' num2str(pre_trimmed)  '_post-' num2str(post_trimmed) ').mat'],'trimed*','use_point')
else
    saveas(gcf,['resampled_3D_coodination/image/' num2str(experiment_date1) '/resampled_3D_coodinate(pre-' num2str(pre_frame)  '_post-' num2str(post_frame) ').png'])
    save(['resampled_3D_coodination/data/' num2str(experiment_date1) '/resampled_3D_coodinate(pre-' num2str(pre_frame)  '_post-' num2str(post_frame) ').mat'],'trimed*','use_point')
end
close all;

