%{
Coded by: Naohito Ohta
Last modification : 2022/03/31
このコードの使い方：
1.カレントディレクトリをNibaliにする
2.必要な変数(monkeyname,exp_day等)を適宜変更する
以上を満たした状態で実行する

【得られるデータ】
・タスクタイミングと、タスクの各セクション(timing1→timing2とか)での平均時間と標準偏差
・タスクの各タイミング付近での筋電データ(ハイパスフィルターをかけるかどうかのオプションもついている)
・筋電データの振幅情報(筋シナジー解析で使用する、フィルタ済みの筋電データ)
これらのデータとグラフを、この関数を実行することで得られる

【注意点】:
filterとhigh_passは併用不可(両者1:うまく作動しない,filterのみ1:筋シナジー解析用の下処理を施した筋電解析と、下処理済みのEMGがnmf_resultに保存される high_passのみ1:filt_hのカットオフ周波数のハイパスが施された筋電解析が保存される 両者0:RAWデータの筋電解析が行われる)
%【やるべきこと】: フィルタリング後の筋電の図の背景に、標準偏差の背景をつける
 NaN値が出ないような範囲で、タイミング前後の値をトリミングすべき(NaN値があると、時系列によって参照しているタスク数が違うため、論文等に載せられない)
 NMF用に筋電に対してフィルタリングをかけた際に、どのような処理をしたかをデータないし図のタイトルに書くべき

【改善点】
タスク間で平均した図の背景にデータの標準偏差を挿入する 
それぞれの図をgrid onする
noise_criやafter_rect_filterの値を、含めたほうがいい
フィルタリング前の筋電(hpとrectのみ)も、正規化してからプロットした方がいい(rectしていない状態で正規化すると、平均が0になるのであまり意味を為さないと思われ)
SYNERGYPLOTの方で,TIM2とTIM3の時間シナジーの方に,タイミングの縦棒(xlim)を入れる
機能をこの関数に集約しすぎ(機能を分散して,複数の関数に分ける)
task_typeを自動で変更する:日付の閾値を設定して，それを超えている日付の時はdrawerにするように変更する
現状でfew_taskは使えないので書き換える → 別の関数で作った方がいいかも

【procedure】
pre : CombineMatfile.m
post : makeEMGNMF_btcOhta.m
after-post: makefold.m
%}

function [] = untitled(exp_day)
%% set parameters
monkeyname='Ni';
% exp_day = '20220805';
save_NMF_fold='nmf_result'; %元save_fold
few_signal = 0; %few_signal(タイミングsignalがLEDカーテンしかない)かどうか
task_type = 'drawer'; %'default'/'drawer'
high_pass = 0; %基線の動揺をなくすためにハイパスをかけるかどうか
SR = 1375; %筋電データのサンプリングレート
filt_h = 50;%カットオフ周波数の値
%↓シナジー解析用のフィルタリングに関する変数
filter = 1; %フィルターをかけるかどうか
filter_h = 50; %筋シナジー用のハイパスフィルターのカットオフ周波数(筋電解析のためのハイパスカットオフ周波数filt_hと混合しないように注意する)
filter_l = 500; %筋シナジー用のローパスフィルターのカットオフ周波数
after_rect_filter = 20;%整流(rect)後の平滑化のためのローパスフィルターのカットオフ周波数
% y_max = 10;
% around timing1
pre_frame1 = 400;
post_frame1 = 200;

% around timing2
pre_frame2 = 200;
post_frame2 = 300;

% around timing3
pre_frame3 = 300;
post_frame3 = 100;

% around timing4
pre_frame4 = 300;
post_frame4 = 400;

% selEMGs= 1:16;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
% EMGs=cell(16,1) ;
% EMGs{1,1}= 'EDC-A';
% EMGs{2,1}= 'EDC-B';
% EMGs{3,1}= 'ED23';
% EMGs{4,1}= 'ED45';
% EMGs{5,1}= 'ECR';
% EMGs{6,1}= 'ECU';
% EMGs{7,1}= 'BRD';
% EMGs{8,1}= 'EPL-B';
% EMGs{9,1}= 'FDS-A';
% EMGs{10,1}= 'FDS-B';
% EMGs{11,1}= 'FDP';
% EMGs{12,1}= 'FCR';
% EMGs{13,1}= 'FCU';
% EMGs{14,1}= 'FPL';
% EMGs{15,1}= 'Biceps';
% EMGs{16,1}= 'Triceps';
% EMG_num = 16;

selEMGs= 1:3;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
EMGs=cell(3,1) ;
EMGs{1,1}= 'FDS';
EMGs{2,1}= 'PL';
EMGs{3,1}= 'EPL';
EMG_num = 3;
%% make timing data
cd(num2str(exp_day))
load(['AllData_' monkeyname exp_day '.mat'],'CAI*','CTTL*','CEMG*','TimeRange')

%それぞれのデータ(筋電やタイミング)を構造体配列にまとめる
workspaceVars = who; %現在のワークスペース変数の名前を取得
prefix_EMG = 'CEMG';
prefix_timing = 'CTTL';
%EMG関連をまとめる
EMG_matchedVars = MakeStruct(prefix_EMG, workspaceVars);
for ii = 1:length(EMG_matchedVars)
    varName = EMG_matchedVars{ii};
    EMG_struct.(varName) = eval(varName);
end
%timing関連をまとめる
timing_matchedVars = MakeStruct(prefix_timing, workspaceVars);
for ii = 1:length(timing_matchedVars)
    varName = timing_matchedVars{ii};
    timing_struct.(varName) = eval(varName);
end


%↓アナログ信号(CAI_001)のデジタイズ化(timing1,timing4の作成)
switch task_type
    case 'default'
        [timing1,timing4] = timing_func1(CAI_001, task_type);
    case 'drawer'
        [timing1,timing5] =  timing_func1(CAI_001, task_type);
end

%↓timing2,timing3,timing5の作成(CombineMatfileで、信号間の偏差は補完済みだからそのまま代入するだけでいい)
%↓default
switch task_type    
    case 'default'
        if exist('CTTL_003_Up')
            [~,timing2, timing3, timing5] = timing_func2(timing_struct, task_type);
        else
            [~, timing2, timing3] = timing_func2(timing_struct, task_type);
        end
        all_timing = {timing1 timing2 timing3 timing4};
    case 'drawer'
        if exist('CTTL_003_Up')
            [timing2, timing3, timing4, timing6] = timing_func2(timing_struct, task_type);
        else
            [timing2, timing3,timing4] = timing_func2(timing_struct, task_type);
        end
        all_timing = {timing1 timing2 timing3 timing4 timing5};
end

%mege & sort
all_timing = cell2mat(all_timing);
all_timing = sort_timing(all_timing,1);

%timingデータの保存場所の作成
Data_save_dir = 'EMG_Data/Data';
if not(isfolder(Data_save_dir))
    mkdir(Data_save_dir)
end
%success_timingの作成
if few_signal == 1
    start_end = [timing1(1,:);timing4(1,:)];
    diff_sample = start_end(2,:) - start_end(1,:);
    ex_tim1 = timing1(1,:);
    ex_tim4 = timing4(1,:);
    timing1 = ex_tim1(and(diff_sample >= 2500, diff_sample <= 4000));
    timing4 = ex_tim4(and(diff_sample >= 2500, diff_sample <= 4000));
    success_timing = [timing1;timing4];
    %データのセーブ
    save([Data_save_dir '/' 'success_timing.mat'],'success_timing')
else
    %success_timingの抽出
    switch task_type
        case 'default'
            if exist('CTTL_003_Up')
                success_timing = timing_func3(all_timing,timing5);
            else
                success_timing = timing_func3(all_timing);
            end
        case 'drawer'
            %CAI,CTTL_002からのデータで，余計なものを除外していく
            %CAIに関して,確実にタスクじゃない1,5の区間を消していく
            data_diff = [timing5(1,:)-timing1(1,:)];
            task_index = find(data_diff>(SR*0.8)); %0.8秒以上かかるもの
            timing1 = timing1(:,task_index);
            timing5 = timing5(:,task_index);
            %CTTL_002に関して
            sensor_data = sort_timing([timing2, timing3, timing4], 1);
            sensor_procedure = sensor_data(2,:);
            sensor_index = [];
            for ii = 1:length(sensor_procedure)
                if ii+3 > length(sensor_procedure)
                    break
                end
                if sensor_procedure(ii) == 2 && sensor_procedure(ii+1) == 3 && sensor_procedure(ii+2) == 4 && sensor_procedure(ii+3) == 2
                    A = [ii; ii+1; ii+2; ii+3];
                    sensor_index = [sensor_index, A];
                end
            end
            timing2 = sensor_data(:,sensor_index(1,:));
            timing3 = sensor_data(:,sensor_index(2,:));
            timing4 = sensor_data(:,sensor_index(3,:));
            all_timing = sort_timing([timing1, timing2, timing3, timing4, timing5], 1);
            if exist('CTTL_003_Up')
                success_timing = timing_func3(all_timing,timing6);
            else
                success_timing = timing_func3(all_timing);
            end
    end
    %セーブ用データをまとめる
    [tim_num,~] = size(success_timing); 
    success_timing = [success_timing;success_timing(tim_num,:) - success_timing(1,:)];
    sorted_success_timing = [sort_timing(success_timing,tim_num+1);sort_timing(success_timing(tim_num+1,:)/mean(success_timing(tim_num+1,:)),1)];%success_timingをタスクの長さ順にソートしたもの。最終行は、平均サンプル数に対する割合
    %↓これ以降は，drawerタスクに対応していないので，必要になったら変更すること
    success_distance = [success_timing(2,:) - success_timing(1,:);success_timing(3,:) - success_timing(2,:);success_timing(4,:) - success_timing(3,:);success_timing(4,:) - success_timing(1,:)];%前の信号とのフレーム差を表したもの(1と2,2と3,3と4)
    %↓success_distanceをもとに、各セクションでのサンプル数の平均値と標準偏差をsuccess_distance_stdに代入する
    a1 = round(mean(success_distance(1,:)));
    a2 = round(std(success_distance(1,:)));
    b1 = round(mean(success_distance(2,:)));
    b2 = round(std(success_distance(2,:)));
    c1 = round(mean(success_distance(3,:)));
    c2 = round(std(success_distance(3,:)));
    d1 = round(mean(success_distance(4,:)));
    d2 = round(std(success_distance(4,:)));
    success_distance_std{1,1}= [num2str(a1) ' ± ' num2str(a2)];%[num2str(b1) ' ± ' num2str(b2)];[num2str(c1) ' ± ' num2str(c2)];[num2str(d1) ' ± ' num2str(d2)]];
    success_distance_std{2,1}= [num2str(b1) ' ± ' num2str(b2)];
    success_distance_std{3,1}= [num2str(c1) ' ± ' num2str(c2)];
    success_distance_std{4,1}= [num2str(d1) ' ± ' num2str(d2)];
    success_timing_video = round(success_timing * (240/1375));%success_timingの値を、ビデオのfpsに変換して出力したもの。動画との称号のために使う
    success_distance_video = [round(success_distance * (240/1375));success_timing_video(1,:)];
    success_distance_video_std{1,1}= [num2str(round(a1*240/1375)) ' ± ' num2str(round(a2*240/1375))];%[num2str(b1) ' ± ' num2str(b2)];[num2str(c1) ' ± ' num2str(c2)];[num2str(d1) ' ± ' num2str(d2)]];
    success_distance_video_std{2,1}= [num2str(round(b1*240/1375)) ' ± ' num2str(round(b2*240/1375))];
    success_distance_video_std{3,1}= [num2str(round(c1*240/1375)) ' ± ' num2str(round(c2*240/1375))];
    success_distance_video_std{4,1}= [num2str(round(d1*240/1375)) ' ± ' num2str(round(d2*240/1375))];
    %データのセーブ
    save([Data_save_dir '/' 'success_timing.mat'],'success*','sorted_success_timing')
end

%% filtering
 %基線の動揺をなくすためにレコードEMGデータにハイパスフィルターをかけるオプション
 %highpass==1は筋電解析用、filter==1はシナジー解析用。両方が1である時は正常に作動しないことに注意(両方が1でもダメ)
if high_pass == 1
    for ii = 1 : EMG_num
        [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
        temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]);
        temp_EMG = filtfilt(B,A,temp_EMG);
        eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
    end
elseif filter == 1
    for ii = 1 : EMG_num
        %offset
        temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]);
        temp_EMG = offset(temp_EMG, 'mean');
        %high_pass
        [B,A] = butter(6, (filter_h .* 2) ./ SR, 'high');
        temp_EMG = filtfilt(B,A,temp_EMG);
        eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
        %rect
        eval(['CEMG_' sprintf('%03d',ii) ' = abs(CEMG_' sprintf('%03d',ii) ');'])
%         %offset
%         temp_EMG =  eval(['CEMG_' sprintf('%03d',ii)]);
%         offset_value = mean(temp_EMG(1:1000)); %活動していないときの，平均値をとってくる
%         temp_EMG = temp_EMG - offset_value;
%         eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
        %low_pass
%         [B,A] = butter(6, (filter_l .* 2) ./ SR, 'low');
%         temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]);
%         temp_EMG = filtfilt(B,A,temp_EMG);
%         eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
    end    
end
%↑ハイパスここまで

%% 各タイミング、タスクごとにデータを切り出して図やデータを保存するセクション
%タスク部分を切り出して、時間正規化して比較(一応タイミング2,3のヒストグラムと中央値の線をつける.タイミング2,3と同じようにして、2段階の正規化でノイズを除去する)
% タスク中のEMGのプロット
h = figure();
h.WindowState = 'maximized';
for ii=1:EMG_num
    Data = eval(['CEMG_' sprintf('%03d',ii)]); %各筋肉の全体データをDataに代入する
    task_EMG_sel={};
    %[~,col] = size(success_timing);
    for jj = 1:length(success_timing)
        if few_signal == 1
            task_trim = Data(success_timing(1,jj)+1:success_timing(2,jj));
            task_trim = resample(task_trim,1000,length(task_trim)); %タスクを時間正規化したデータを代入
            task_EMG_sel{jj,1} = task_trim;
        else
            task_trim = Data(success_timing(1,jj)+1:success_timing(tim_num,jj));
            tim_hist(1,jj) = ((success_timing(2,jj))-(success_timing(1,jj)+1)) * (1000/length(task_trim));
            tim_hist(2,jj) = ((success_timing(3,jj))-(success_timing(1,jj)+1)) * (1000/length(task_trim));
            if strcmp(task_type, 'drawer')
                tim_hist(3,jj) = ((success_timing(4,jj))-(success_timing(1,jj)+1)) * (1000/length(task_trim));
            end
            task_trim = resample(task_trim,1000,length(task_trim)); %タスクを時間正規化したデータを代入
            task_EMG_sel{jj,1} = task_trim;
        end
    end
    save([Data_save_dir '/' 'task_normalized_hist.mat'], "tim_hist")
    task_EMG = cell2mat(task_EMG_sel);
    ave_task_EMG = mean(task_EMG);
    subplot(4,ceil(EMG_num/4), ii)
    for kk = 1:length(task_EMG_sel) %kk:trial_num
        plot(task_EMG(kk,:));
        hold on;
        if filter == 1
            if kk == 1 
                yMax = quantile(max(task_EMG,[], 2), 0.75);
                ylim([0 ceil(ceil(yMax)/10)*10+10]);
            end
        else
            if kk == 1 
                yMax = max(task_EMG(kk,:));
                yMin = min(task_EMG(kk,:)); 
                ylim([yMin-10 yMax+10]);
            elseif max(task_EMG(kk,:)) > yMax
                yMax = max(task_EMG(kk,:));
                ylim([yMin-10 yMax+10]);
            elseif min(task_EMG(kk,:)) < yMin
                yMin = min(task_EMG(kk,:)); 
                ylim([yMin-10 yMax+10]);
            end
        end
        
    end
    if few_signal == 1
        yyaxis right; 
        ylim([0 40])
        title([EMGs{ii} '(uV)'])
        hold off
        All_task_EMG{ii,1} = task_EMG;
        All_ave_task_EMG{ii,1} = ave_task_EMG;
    else
        yyaxis right; 
        ylim([0 60])
        histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
        histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
        tim2_median = median(tim_hist(1,:));
        tim3_median = median(tim_hist(2,:));
        if strcmp(task_type, 'drawer')
            histogram(tim_hist(3,:),15,'FaceColor',[53 187 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
            tim4_median = median(tim_hist(3,:));
            xline(tim4_median , 'green','Color',[53 187 0]/255,'LineWidth',1);
        end
        xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
        xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
        title([EMGs{ii} '(uV)'])
        hold off
        All_task_EMG{ii,1} = task_EMG;
        All_ave_task_EMG{ii,1} = ave_task_EMG;
    end
end

Picture_save_dir = 'EMG_Data/picture';
if not(isfolder(Picture_save_dir))
    mkdir(Picture_save_dir)
end

if high_pass == 1
    saveas(gcf,[Picture_save_dir '/' 'filtered_taskEMG(highpass-' num2str(filt_h) 'Hz).png']);
elseif filter == 1
    saveas(gcf,[Picture_save_dir '/' 'filtered_taskEMG(highpass-' num2str(filter_h) 'Hz-rect).png']);
else
    saveas(gcf,[Picture_save_dir '/' 'RAW_taskEMG.png']);
end

close all;
All_ave_task_EMG = cell2mat(All_ave_task_EMG);

% タスク中のEMGの平均をプロット
figure('Position',[100,100,800,1200]);

for ll = 1:EMG_num
    subplot(4,ceil(EMG_num/4), ll)
    plot(All_ave_task_EMG(ll,:))
%     ylim([0 ceil(max(All_ave_task_EMG(ll,:)))])
    if exist('y_max')
        ylim([0 y_max])
    end
    hold on;
    if few_signal == 0
        yyaxis right;
        ylim([0 40])
        histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
        histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
        if strcmp(task_type, 'drawer')
            histogram(tim_hist(3,:),15,'FaceColor',[53 187 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
            tim4_median = median(tim_hist(3,:));
            xline(tim4_median , 'green','Color',[53 187 0]/255,'LineWidth',1);
        end
        tim2_median = median(tim_hist(1,:));
        tim3_median = median(tim_hist(2,:));
        xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
        xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
    end
    title([EMGs{ll} '(uV)'])
    hold on
end
hold off


if high_pass == 1
    saveas(gcf,[Picture_save_dir '/' 'ave_filtered_taskEMG(highpass-' num2str(filt_h) 'Hz).png']);
elseif filter == 1
    saveas(gcf,[Picture_save_dir '/' 'ave_filtered_taskEMG(highpass-' num2str(filter_h) 'Hz-rect).png']);
else
    saveas(gcf,[Picture_save_dir '/' 'ave_RAW_taskEMG.png']);
end
close all;

% タイミングごとのプロット
if or(few_signal == 1,strcmp(task_type, 'drawer'))
else
%タイミング1にalignして,時間正規化せずにタスクをプロットする(ii:筋肉の数 jj:タスクの数)
    for ii = 1:EMG_num
        for jj = 1:length(success_timing)
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '((success_timing(1,jj)-pre_frame1)+1 : success_timing(1,jj)+post_frame1);'])
            task_EMG_sel{jj,1} = task_trim;
        end
        eval(['task_tim1_EMG_' sprintf('%03d',ii) ' = cell2mat(task_EMG_sel);'])
    end
    
    %↓task_EMG_tim1を用いて、プロット(平滑化前、整流後の重ね合わせの図)
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        subplot(4,ceil(EMG_num/4), ii)
        for jj = 1:length(success_timing)
            hold on;
            plot(eval(['task_tim1_EMG_' sprintf('%03d',ii) '(jj,:)']))
        end
        xline(pre_frame1,'red','Color',[186 85 211]/255,'LineWidth',2);
        title([EMGs{ii,1} '(uV)'])
        hold off;
    end

    if high_pass == 0
        if filter == 1
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim1-pre' num2str(pre_frame1) '_post-' num2str(post_frame1) 'frame_filtered.png'])
        else
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim1-pre' num2str(pre_frame1) '_post-' num2str(post_frame1) 'frame_RAW.png'])
        end
    else
        saveas(gcf,[Picture_save_dir '/' 'task_aroundTim1-post' num2str(post_frame1) 'frame(high-pass' num2str(filt_h) 'Hz).png']);
    end
    close all;
    
    %↓タイミング2と3でほとんど同じ操作をしているから、関数にして完結化するべき
    %タイミング2にalignして,時間正規化せずにタスクをプロットする(ii:筋肉の数 jj:タスクの数)
    timing1_2_maxframe = max(success_distance(1,:)); %タイミング1~2のフレーム数の最大値、これをもとに、他のタスクデータをNaNで補償する 
    for ii = 1:EMG_num
        for jj = 1:length(success_timing)
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(2,jj)+post_frame2);'])
            e_Maxframe = timing1_2_maxframe - success_distance(1,jj); %timing1_2_maxframeとのフレーム数の誤差。この値分だけNaNを代入
            if e_Maxframe == 0 %最大値を取る時
                
            else
                comp_frame = NaN(1,e_Maxframe);
                task_trim = {comp_frame,task_trim};
                task_trim = cell2mat(task_trim);
            end
            task_EMG_sel{jj,1} = task_trim;
        end
        eval(['task_tim2_EMG_' sprintf('%03d',ii) ' = task_EMG_sel;'])
    end
    
    %↓task_EMG_tim2を用いて、プロット(平滑化前、整流後の重ね合わせの図)
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        subplot(4,ceil(EMG_num/4), ii)
        for jj = 1:length(success_timing)
            hold on;
            task_trim_tim2 = eval(['task_tim2_EMG_' sprintf('%03d',ii) '{jj,1}((timing1_2_maxframe-pre_frame2)+1 : (timing1_2_maxframe + post_frame2));']);
            plot(task_trim_tim2)
            task_EMG_sel{jj,1} = task_trim_tim2;
        end
        task_EMG_tim2{ii,1} = task_EMG_sel;
        xline(pre_frame2,'red','Color',[186 85 211]/255,'LineWidth',2);
        title([EMGs{ii,1} '(uV)'])
        if ii == 1 
            dim = [0.01 0.6 0.3 0.3];
            str = 'x-axis-unit = 1/1375 [s]';
            annotation('textbox',dim,'String',str,'FitBoxToText','on');
        end
        hold off;
    end
   
    if high_pass == 0
        if filter == 1
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim2-pre' num2str(pre_frame2) '-post' num2str(post_frame2) 'frame_filtered.png'])
        else
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim2-pre' num2str(pre_frame2) '-post' num2str(post_frame2) 'frame_RAW.png'])
        end
    else
        saveas(gcf,['task_aroundTim2-pre' num2str(pre_frame2) '-post' num2str(post_frame2) 'frame(high-pass' num2str(filt_h) 'Hz).png']);
    end
    close all;
    %↑ここまで
    %タイミング3にalignして,時間正規化せずにタスクをプロットする(ii:筋肉の数 jj:タスクの数)
    timing1_3_maxframe = max(success_distance(1,:) + success_distance(2,:)); %タイミング1~3のフレーム数の最大値、これをもとに、他のタスクデータをNaNで補償する 
    for ii = 1:EMG_num
        for jj = 1:length(success_timing)
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(3,jj)+post_frame3);'])
            e_Maxframe = timing1_3_maxframe - (success_distance(1,jj)+success_distance(2,jj)); %timing1_3_maxframeとのフレーム数の誤差。この値分だけNaNを代入
            if e_Maxframe == 0 %最大値を取る時
                
            else
                comp_frame = NaN(1,e_Maxframe);
                task_trim = {comp_frame,task_trim};
                task_trim = cell2mat(task_trim);
            end
            task_EMG_sel{jj,1} = task_trim;
        end
        eval(['task_tim3_EMG_' sprintf('%03d',ii) ' = task_EMG_sel;'])
    end
    
    %↓task_EMG_tim3を用いて、プロット
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        subplot(4,ceil(EMG_num/4), ii)
        for jj = 1:length(success_timing)
            hold on;
            task_trim_tim3 = eval(['task_tim3_EMG_' sprintf('%03d',ii) '{jj,1}((timing1_3_maxframe-pre_frame3)+1 : (timing1_3_maxframe + post_frame3));']);
            plot(task_trim_tim3);
            task_EMG_sel{jj,1} = task_trim_tim3;
        end
        task_EMG_tim3{ii,1} = task_EMG_sel;
        xline(pre_frame3,'red','Color',[186 85 211]/255,'LineWidth',2);
        title([EMGs{ii,1} '(uV)'])
        if ii == 1 
            dim = [0.01 0.6 0.3 0.3];
            str = 'x-axis-unit = 1/1375 [s]';
            annotation('textbox',dim,'String',str,'FitBoxToText','on');
        end
        hold off;
    end
   
    if high_pass == 0
        if filter == 1
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim3-pre' num2str(pre_frame3) '-post' num2str(post_frame3) 'frame_filtered.png'])
        else
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim3-pre' num2str(pre_frame3) '-post' num2str(post_frame3) 'frame_RAW.png'])
        end
    else
        saveas(gcf,[Picture_save_dir '/' 'task_aroundTim3-pre' num2str(pre_frame3) '-post' num2str(post_frame3) 'frame(high-pass' num2str(filt_h) 'Hz).png']);
    end
    close all;
    
    %タイミング4にalignして,時間正規化せずにタスクをプロットする(ii:筋肉の数 jj:タスクの数)
    for ii = 1:EMG_num
        for jj = 1:length(success_timing)
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(4,jj)-pre_frame4 + 1 : success_timing(4,jj)+post_frame4);'])
            task_EMG_sel{jj,1} = task_trim;
        end
        eval(['task_tim4_EMG_' sprintf('%03d',ii) ' = cell2mat(task_EMG_sel);'])
    end
    
    %↓task_EMG_tim4を用いて、プロット(平滑化前、整流後の重ね合わせの図)
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        subplot(4,ceil(EMG_num/4), ii)
        for jj = 1:length(success_timing)
            hold on;
            plot(eval(['task_tim4_EMG_' sprintf('%03d',ii) '(jj,:)']))
        end
        title([EMGs{ii,1} '(uV)'])
        xline(pre_frame4,'red','Color',[186 85 211]/255,'LineWidth',2);
        hold off;
    end

    if high_pass == 0
        if filter == 1
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim4-pre' num2str(pre_frame4) '_post' num2str(post_frame4) 'frame_filtered.png'])
        else
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim4-pre' num2str(pre_frame4) '_post' num2str(post_frame4) 'frame_RAW.png'])
        end
    else
        saveas(gcf,[Picture_save_dir '/' 'task_aroundTim4-pre' num2str(post_frame4) 'frame(high-pass' num2str(filt_h) 'Hz).png']);
    end
    close all;
end
%使用した変数を.matファイルに保存する
if and(few_signal == 0, strcmp(task_type, 'default'))
    if high_pass == 0
        save([Data_save_dir '/' 'task_tim2_pre-' num2str(pre_frame2) '_post-' num2str(post_frame2) 'RAW_EMG.mat'],'task_tim2_EMG*')
        save([Data_save_dir '/' 'task_tim3_pre-' num2str(pre_frame3) '_post-' num2str(post_frame3) 'RAW_EMG.mat'],'task_tim3_EMG*')
    else
        save([Data_save_dir '/' 'task_tim2_pre-' num2str(pre_frame2) '_post-' num2str(post_frame2) '_(highpass-' num2str(filt_h) 'Hz)EMG.mat'],'task_tim2_EMG*')
        save([Data_save_dir '/' 'task_tim3_pre-' num2str(pre_frame3) '_post-' num2str(post_frame3) '_(highpass-' num2str(filt_h) 'Hz)EMG.mat'],'task_tim3_EMG*')
    end
end

%alignしたものではなく、各筋肉、各タスクのタスク全体の筋電を保存する
for ii = 1:EMG_num
    for jj = 1:length(success_timing)
        if few_signal == 1
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(2,jj));'])
        else
            switch task_type
                case 'default'
                    eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(4,jj));'])
                case 'drawer'
                    eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(5,jj));'])
            end   
        end
        task_EMG_sel{jj,1} = task_trim;
    end
    eval(['task_EMG_' sprintf('%03d',ii) ' = task_EMG_sel;'])
end
if high_pass == 0
    save([Data_save_dir '/' 'task_EMG(RAW_data).mat'],'task_EMG_0*')
else
    save([Data_save_dir '/' task_EMG(high_pass=' num2str(filt_h) ').mat'],'task_EMG_0*')
end

%% compile EMG to use synergy analysis (筋シナジー用のフィルタリング済みの筋電をNMF_RESULTにMATファイルとして保存するためのセクション)
if filter == 1
    nmf_save_fold = [save_NMF_fold '/' monkeyname num2str(exp_day) '_standard'];
    if not(isfolder(nmf_save_fold))
        mkdir(nmf_save_fold);
    end

    %時間正規化したタスクデータを振幅正規化し(ノイズ除去のため2回)、タスク間の平均を取り、プロットする。その後、NMF用に、各筋電をMATファイルにしてnmf_resultの所定のディレクトリに保存
    for ii = 1:EMG_num
        clear temp_EMG_sel; %前ループ でのtemp_EMG_selを消す
        temp_EMG = All_task_EMG{ii,1}; %ある筋電の全タスクデータをtemp_EMGに代入
        stack_EMG{ii,1} = temp_EMG; %正規化＆ノイズタスク除去したEMGがどんな感じか確認するための変数
        temp_EMG = median(temp_EMG); %タスクデータを平均する(nanmeanの使用にはtoolboxが必要な場合がある)
        temp_EMG_std = std(temp_EMG); %タスクデータの標準偏差を求める
        %↓ローパスフィルターをかけて平滑化
        [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
        temp_EMG = filtfilt(B,A,temp_EMG);
        average_value = median(temp_EMG);
        temp_EMG = temp_EMG / average_value;
        temp_EMG = temp_EMG - min(temp_EMG); %offset
        all_temp_EMG{ii,1} = temp_EMG;
    end
    %正規化＆ノイズタスク除去したEMGがどんな感じか確認したい
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
       subplot(4,ceil(EMG_num/4), ii)
       hold on
       [trial_num,~] = size(stack_EMG{ii,1}); %ノイズタスク除去後のタスク数
       for jj = 1:trial_num
           plot(stack_EMG{ii,1}(jj,:))
       end
%        ylim([0 noize_cri+5]);
       yyaxis right;
       ylim([0 40])
       title([EMGs{ii,1} '(uV)'])
       if few_signal == 0
           histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
           histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
           xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
           xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
       end
       grid on;
    end
    saveas(gcf,[nmf_save_fold '/' 'EMG_stack_TaskTimeNormalized.png'])
    close all;
    %平滑化した結果がどんな感じかを確認したい(for文でプロットした図にする)
%     h = figure();
    figure('Position',[100,100,800,1200]);
    for ii = 1:EMG_num
       subplot(4,ceil(EMG_num/4), ii)
       hold on
       plot(all_temp_EMG{ii,1},'LineWidth',2)
       ylim([0 2])
       yyaxis right;
       ylim([0 40])
       title([EMGs{ii,1} '(uV)'])
       if few_signal == 0
           histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
           histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
           xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
           xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
       end
       grid on;
    end
    hold off
    saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_TaskTimeNormalized.png']) %保存場所がnmf_resultの中であることに注意
    close all;
    %↓保存する変数をまとめてmatファイルに保存
    for ii = 1:EMG_num
        Name = cell2mat(EMGs(ii,1));
        Class = 'continuous channel';
        SampleRate = CEMG_001_KHz*1000;
        Data = all_temp_EMG{ii,1};
        Unit = 'uV';
        save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_TimeNormalized.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
    end

    if and(few_signal == 0, strcmp(task_type, 'default'))
         %tim1の周りの筋電をMATファイルにまとめる
        for ii = 1:EMG_num
            clear temp_EMG_sel; %前ループ でのtemp_EMG_selを消す
            temp_EMG = eval(['task_tim1_EMG_' sprintf('%03d',ii)]); %ある筋電の全タスクデータをtemp_EMGに代入(task_tim1は,pre_frame1,post_frame1を基に取り出したEMG)
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %正規化のために、筋電の平均値を出す
            temp_EMG = temp_EMG/ave_EMG; %正規化(1回目) 
            noize_cri = 10; %ノイズ判定される振幅の閾値(振幅平均の何倍か？)
            %↓閾値を基に、大きすぎる振幅(おそらくノイズ)を持つタスクを除去する
            count = 1;
            for jj = 1:length(success_timing) %タスク回数分
                max_amp = max(temp_EMG(jj,:));
                if max_amp < noize_cri
                    temp_EMG_sel{count,1} = temp_EMG(jj,:);
                    count = count+1;
                else
                end
            end
            temp_EMG = cell2mat(temp_EMG_sel);%条件を満たしているものを再びtemp_EMGに代入
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %条件を満たしたデータでの正規化のために、筋電の平均値を出す
            temp_EMG = temp_EMG/ave_EMG; %正規化(2回目) 
            stack_EMG{ii,1} = temp_EMG; %正規化＆ノイズタスク除去したEMGがどんな感じか確認するための変数
            temp_EMG = nanmean(temp_EMG); %ハイパス→整流後のタスクデータを平均する(nanmeanの使用にはtoolboxが必要な場合がある)
            temp_EMG_std = nanstd(temp_EMG); %整流後のタスクデータの標準偏差を求める
            %↓ローパスフィルターをかけて平滑化
            [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
            temp_EMG = filtfilt(B,A,temp_EMG);
            all_temp_EMG{ii,1} = temp_EMG;
        end
        %正規化＆ノイズタスク除去したEMGがどんな感じか確認したい
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           [trial_num,~] = size(stack_EMG{ii,1}); %ノイズタスク除去後のタスク数
           for jj = 1:trial_num
               plot(stack_EMG{ii,1}(jj,:))
           end
           ylim([0 noize_cri+5]);
           title([EMGs{ii,1} '(uV)'])
           grid on;
           xline(pre_frame1,'red','Color',[186 85 211]/255,'LineWidth',2);
        end
        saveas(gcf,[nmf_save_fold '/' 'EMG_stack_tim1_pre-' num2str(pre_frame1) '_post' num2str(post_frame1) '.png'])
        close all;
        
        %平滑化した結果がどんな感じかを確認したい(for文でプロットした図にする)
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           plot(all_temp_EMG{ii,1})
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame1,'red','Color',[186 85 211]/255,'LineWidth',2);
           ylim([0 2]);grid on;
        end
        hold off
        saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_tim1_pre-' num2str(pre_frame1) '_post' num2str(post_frame1) '.png']) %保存場所がnmf_resultの中であることに注意
        close all;
        %↓保存する変数をまとめてmatファイルに保存
        for ii = 1:EMG_num
            Name = cell2mat(EMGs(ii,1));
            Class = 'continuous channel';
            SampleRate = CEMG_001_KHz*1000;
            Data = all_temp_EMG{ii,1};
            Unit = 'uV';
            save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_tim1_pre-' num2str(pre_frame1) '_post' num2str(post_frame1) '.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
        end
        
        %tim2の周りの筋電をMATファイルにまとめる
        
        for ii = 1:EMG_num
            clear temp_EMG_sel; %前ループ でのtemp_EMG_selを消す
            temp_EMG = cell2mat(task_EMG_tim2{ii,1}); %ある筋電の全タスクデータをtemp_EMGに代入
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %正規化のために、筋電の平均値を出す
            temp_EMG = temp_EMG/ave_EMG; %正規化(1回目) 
            noize_cri = 10; %ノイズ判定される振幅の閾値(振幅平均の何倍か？)
            %↓閾値を基に、大きすぎる振幅(おそらくノイズ)を持つタスクを除去する
            count = 1;
            for jj = 1:length(success_timing) %タスク回数分
                max_amp = max(temp_EMG(jj,:));
                if max_amp < noize_cri
                    temp_EMG_sel{count,1} = temp_EMG(jj,:);
                    count = count+1;
                else
                end
            end
            temp_EMG = cell2mat(temp_EMG_sel);%条件を満たしているものを再びtemp_EMGに代入
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %条件を満たしたデータでの正規化のために、筋電の平均値を出す
            temp_EMG = temp_EMG/ave_EMG; %正規化(2回目) 
            stack_EMG{ii,1} = temp_EMG; %正規化＆ノイズタスク除去したEMGがどんな感じか確認するための変数
            temp_EMG = nanmean(temp_EMG); %ハイパス→整流後のタスクデータを平均する(nanmeanの使用にはtoolboxが必要な場合がある)
            temp_EMG_std = nanstd(temp_EMG); %整流後のタスクデータの標準偏差を求める
            %↓ローパスフィルターをかけて平滑化
            [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
            temp_EMG = filtfilt(B,A,temp_EMG);
            all_temp_EMG{ii,1} = temp_EMG;
        end
        %正規化＆ノイズタスク除去したEMGがどんな感じか確認したい
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           [trial_num,~] = size(stack_EMG{ii,1}); %ノイズタスク除去後のタスク数
           for jj = 1:trial_num
               plot(stack_EMG{ii,1}(jj,:))
           end
           ylim([0 noize_cri+5]);
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame2,'red','Color',[186 85 211]/255,'LineWidth',2);
           grid on;
        end
        saveas(gcf,[nmf_save_fold '/' 'EMG_stack_tim2_pre-' num2str(pre_frame2) 'post-' num2str(post_frame2) '.png'])
        close all;
        
        %平滑化した結果がどんな感じかを確認したい(for文でプロットした図にする)
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           plot(all_temp_EMG{ii,1})
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame2,'red','Color',[186 85 211]/255,'LineWidth',2);
           ylim([0 2]);grid on;
        end
        hold off
        saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_tim2_pre-' num2str(pre_frame2) 'post-' num2str(post_frame2) '.png']) %保存場所がnmf_resultの中であることに注意
        close all;
        %↓保存する変数をまとめてmatファイルに保存
        for ii = 1:EMG_num
            Name = cell2mat(EMGs(ii,1));
            Class = 'continuous channel';
            SampleRate = CEMG_001_KHz*1000;
            Data = all_temp_EMG{ii,1};
            Unit = 'uV';
            save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_tim2_pre-' num2str(pre_frame2) '_post-' num2str(post_frame2) '.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
        end
        
        %tim3の周りの筋電をmatファイルにまとめる
        for ii = 1:EMG_num
            clear temp_EMG_sel; %前データで使用したtemp_EMGを消す
            temp_EMG = cell2mat(task_EMG_tim3{ii,1}); %ある筋電の全タスクデータをtemp_EMGに代入
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %正規化のために、筋電の平均値を出す
            temp_EMG = temp_EMG/ave_EMG; %正規化(1回目)
            noize_cri = 10; %ノイズ判定される振幅の閾値(振幅平均の何倍か？)
            %↓閾値を基に、大きすぎる振幅(おそらくノイズ)を持つタスクを除去する
            count = 1;
            for jj = 1:length(success_timing) %タスク回数分
                max_amp = max(temp_EMG(jj,:));
                if max_amp < noize_cri
                    temp_EMG_sel{count,1} = temp_EMG(jj,:);
                    count = count+1;
                else
                end
            end
            temp_EMG = cell2mat(temp_EMG_sel);
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %条件を満たしたデータでの正規化のために、筋電の平均値を出す
            temp_EMG = temp_EMG/ave_EMG; %正規化(2回目) 
            stack_EMG{ii,1} = temp_EMG; %正規化＆ノイズタスク除去したEMGがどんな感じか確認するための変数
            temp_EMG = nanmean(temp_EMG); %ハイパス→整流後のタスクデータを平均する(nanmeanの使用にはtoolboxが必要な場合がある)
            %↓ローパスフィルターをかけて平滑化
            [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
            temp_EMG = filtfilt(B,A,temp_EMG);
            all_temp_EMG{ii,1} = temp_EMG;
        end
        %正規化＆ノイズタスク除去したEMGがどんな感じか確認したい
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           [trial_num,~] = size(stack_EMG{ii,1}); %ノイズタスク除去後のタスク数
           for jj = 1:trial_num
               plot(stack_EMG{ii,1}(jj,:))
           end
           ylim([0 noize_cri+5]);
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame3,'red','Color',[186 85 211]/255,'LineWidth',2);
           grid on;
        end
        saveas(gcf,[nmf_save_fold '/' 'EMG_stack_tim3_pre-' num2str(pre_frame3) 'post-' num2str(post_frame3) '.png'])
        close all;
        
        %平滑化した結果がどんな感じかを確認したい(for文でプロットした図にする)(タスク間の標準偏差を出して、背景にプロットすべき)
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           plot(all_temp_EMG{ii,1})
           ylim([0 2]);
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame3,'red','Color',[186 85 211]/255,'LineWidth',2);grid on;
        end
        hold off
        saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_tim3_pre-' num2str(pre_frame3) 'post-' num2str(post_frame3) '.png']) %保存場所がnmf_resultの中であることに注意
        close all;
        %↓保存する変数をまとめてmatファイルに保存
        for ii = 1:EMG_num
            Name = cell2mat(EMGs(ii,1));
            Class = 'continuous channel';
            SampleRate = CEMG_001_KHz*1000;
            Data = all_temp_EMG{ii,1};
            Unit = 'uV';
            save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_tim3_pre-' num2str(pre_frame3) '_post-' num2str(post_frame3) '.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
        end
        %tim4の周りの筋電をMATファイルにまとめる
        for ii = 1:EMG_num
            clear temp_EMG_sel; %前ループ でのtemp_EMG_selを消す
            temp_EMG = eval(['task_tim4_EMG_' sprintf('%03d',ii)]); %ある筋電の全タスクデータをtemp_EMGに代入
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %正規化のために、筋電の平均値を出す
            temp_EMG = temp_EMG/ave_EMG; %正規化(1回目) 
            noize_cri = 10; %ノイズ判定される振幅の閾値(振幅平均の何倍か？)
            %↓閾値を基に、大きすぎる振幅(おそらくノイズ)を持つタスクを除去する
            count = 1;
            for jj = 1:length(success_timing) %タスク回数分
                max_amp = max(temp_EMG(jj,:));
                if max_amp < noize_cri
                    temp_EMG_sel{count,1} = temp_EMG(jj,:);
                    count = count+1;
                else
                end
            end
            temp_EMG = cell2mat(temp_EMG_sel);%条件を満たしているものを再びtemp_EMGに代入
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %条件を満たしたデータでの正規化のために、筋電の平均値を出す
            temp_EMG = temp_EMG/ave_EMG; %正規化(2回目) 
            stack_EMG{ii,1} = temp_EMG; %正規化＆ノイズタスク除去したEMGがどんな感じか確認するための変数
            temp_EMG = nanmean(temp_EMG); %ハイパス→整流後のタスクデータを平均する(nanmeanの使用にはtoolboxが必要な場合がある)
            temp_EMG_std = nanstd(temp_EMG); %整流後のタスクデータの標準偏差を求める
            %↓ローパスフィルターをかけて平滑化
            [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
            temp_EMG = filtfilt(B,A,temp_EMG);
            all_temp_EMG{ii,1} = temp_EMG;
        end
        %正規化＆ノイズタスク除去したEMGがどんな感じか確認したい
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           [trial_num,~] = size(stack_EMG{ii,1}); %ノイズタスク除去後のタスク数
           for jj = 1:trial_num
               plot(stack_EMG{ii,1}(jj,:))
           end
           ylim([0 noize_cri+5]);
           xline(pre_frame4,'red','Color',[186 85 211]/255,'LineWidth',2);
           title([EMGs{ii,1} '(uV)'])
           grid on;
        end
        saveas(gcf,[nmf_save_fold '/' 'EMG_stack_tim4_pre-' num2str(pre_frame4) '_post' num2str(post_frame4) '.png'])
        close all;
        
        %平滑化した結果がどんな感じかを確認したい(for文でプロットした図にする)
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           plot(all_temp_EMG{ii,1})
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame4,'red','Color',[186 85 211]/255,'LineWidth',2);
           ylim([0 2]);grid on;
        end
        hold off
        saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_tim4_pre-' num2str(pre_frame4) 'post-' num2str(post_frame2) '.png']) %保存場所がnmf_resultの中であることに注意
        close all;
        %↓保存する変数をまとめてmatファイルに保存
        for ii = 1:EMG_num
            Name = cell2mat(EMGs(ii,1));
            Class = 'continuous channel';
            SampleRate = CEMG_001_KHz*1000;
            Data = all_temp_EMG{ii,1};
            Unit = 'uV';
            save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_tim4_pre-' num2str(pre_frame4) '_post' num2str(post_frame4) '.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
        end
    end
    %全体からの筋シナジー抽出用に、全体からのフィルタリングEMGも保存する
    for ii = 1:EMG_num
        temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]); 
        %↓ローパスフィルターをかけて平滑化
        [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
        temp_EMG = filtfilt(B,A,temp_EMG);
        all_temp_EMG{ii,1} = temp_EMG;
    end
    %↓保存する変数をまとめてmatファイルに保存
    for ii = 1:EMG_num
        Name = cell2mat(EMGs(ii,1));
        Class = 'continuous channel';
        SampleRate = CEMG_001_KHz*1000;
        Data = all_temp_EMG{ii,1};
        Unit = 'uV';
        save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_filtered.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
    end
end
cd ../
end

%% set local function
%タイミング切り出しの関数
function [start_timing,end_timing] = timing_func1(CAI_001, task_type)
%【説明】
%CAI001からtask_startとtask_endのタイミングを抽出する

judge_arrange =  CAI_001(1,:) > -500; %-500以上→タスク中(LEDカーテンを遮っている)
judge_ID = find(judge_arrange);
%↓trim_sectionの作成(2行の配列で、1行目がtiming1,2行目がtiming4になっている)
trim_section(1,1) = judge_ID(1,1);
count = 1;
for ii = 2:length(judge_ID)
    disting = judge_ID(1,ii) - judge_ID(1,ii-1);
    if not(disting == 1)
        trim_section(2,count) = judge_ID(1,ii-1);
        count = count+1;
        trim_section(1,count) = judge_ID(1,ii);
    end
end
trim_section(2,end) = judge_ID(1,end);
switch task_type
    case 'default' %Nibaliの実験タスクの時(repmatでID付けをする)
        start_timing = [trim_section(1,:);repmat(1,1,length(trim_section))];
        end_timing = [trim_section(2,:);repmat(4,1,length(trim_section))];
    case 'drawer' %drawerタスクの時
        start_timing = [trim_section(1,:);repmat(1,1,length(trim_section))];
        end_timing = [trim_section(2,:);repmat(5,1,length(trim_section))];
end
end

% 構造体の作成
function matchedVars = MakeStruct(prefix, workspaceVars)
matchedVars = cell(0);
for ii = 1:length(workspaceVars) 
    VarName = workspaceVars{ii};
    if startsWith(VarName, prefix)
        matchedVars{end+1} = VarName;
    end
end
end

%タイミング切り出しの関数2
function [pull_timing, food_on_timing, food_off_timing, success_botton_timing] = timing_func2(timing_struct, task_type)
%【説明】
% CTLLからfood on, food off, success_bottonのタイミングを抽出する

switch task_type
    case 'default' %Nibaliのexperiment
        pull_timing = ''; %一応割り振っとかないとエラー吐く
        food_on_timing = [timing_struct.CTTL_002_Down;repmat(2,1,length(timing_struct.CTTL_002_Down))];
        food_off_timing = [timing_struct.CTTL_002_Up;repmat(3,1,length(timing_struct.CTTL_002_Up))];
        if nargout > 3 %指定した出力結果が4つの時(success_bottonがある時)
            CTTL_003_Down = timing_struct.CTTL_003_Down;
            success_botton_timing = [CTTL_003_Down;repmat(5,1,length(CTTL_003_Down))]; %CTTL_003のDownの方を採用
        end
    case 'drawer' %新しいタスク
        sensor_signal = [timing_struct.CTTL_002_Down;timing_struct.CTTL_002_Up];
        sensor_signal_diff = sensor_signal(2,:) - sensor_signal(1,:);
        time_threshold = 200; %主観で閾値設定
        food_index = find(sensor_signal_diff > time_threshold);
        pull_index = setdiff(1:length(sensor_signal_diff), food_index);
        food_data = sensor_signal(:,food_index);
        pull_data = sensor_signal(:, pull_index);
        pull_timing = [pull_data(1,:);repmat(2,1,length(pull_data))];
        food_on_timing = [food_data(1,:); repmat(3,1,length(food_data))];
        food_off_timing = [food_data(2,:); repmat(4,1,length(food_data))]; 
        
        if nargout > 3 %指定した出力結果が4つの時(success_bottonがある時)
            CTTL_003_Down = timing_struct.CTTL_003_Down;
            success_botton_timing = [CTTL_003_Down;repmat(6,1,length(CTTL_003_Down))]; %CTTL_003のDownの方を採用
        end

end

end

%タイミング切り出しの関数3
function success_timing = timing_func3(all_timing,success_botton_timing)
% タイミングデータを整理して，成功タスクの情報だけを抽出する
all_timing_num = max(all_timing(2,:)); %4→default 5→drawer
%タスクごとに処理を分ける
switch all_timing_num
    case 4
        %1→2→3→4
        task_term1 = '(all_timing(2,ii+1)==2 && all_timing(2,ii+2)==3 && all_timing(2,ii+3)==4)';
        %122345 or 12354
        task_term2 = '(all_timing2(2,ii+1)==2 && all_timing2(2,ii+2)==3 && all_timing2(2,ii+3)==4 && all_timing2(2,ii+4)==5) || (all_timing2(2,ii+1)==2 && all_timing2(2,ii+2)==3 && all_timing2(2,ii+3)==5 && all_timing2(2,ii+4)==4)';
    case 5
        %1→2→3→4→5
        task_term1 = '(all_timing(2,ii+1)==2 && all_timing(2,ii+2)==3 && all_timing(2,ii+3)==4 && all_timing(2,ii+4)==5)';
        %123456
        task_term2 = '(all_timing2(2,ii+1)==2 && all_timing2(2,ii+2)==3 && all_timing2(2,ii+3)==4 && all_timing2(2,ii+4)==5 && all_timing2(2,ii+5)==6)';
end

%↓タスクタイミングの定義①(1~4を順番に満たしているものの抽出)
count = 1; 
for ii = 1:length(all_timing)
    if all_timing(2,ii) == 1
        if eval(task_term1)
            success_timing1{1,count} = all_timing(:,ii:ii+(all_timing_num-1));
            count = count+1;
        end
    end
end
success_timing1 = cell2mat(success_timing1);

switch nargin %success_timingの作成(success_bottonがあるかどうか別)
    case 1 %success_bottonがない時
        task_trial = length(success_timing1)/4; %トライアル数
        for ii = 1:task_trial
            success_timing{1,ii} =  transpose(success_timing1(1,4*(ii-1)+1:4*ii));
        end

    case 2 %success_bottonあり
        %↓タスクタイミングの定義②(①を満たしているものにtiming5を加えて同じ操作を行う)
        all_timing2 = {success_timing1 success_botton_timing};
        all_timing2 = sort_timing(cell2mat(all_timing2),1); 
        count = 1;
        for ii = 1:length(all_timing2)
            if all_timing2(2,ii) == 1
                %↓エラーを避けるために必要
                if length(all_timing2) - ii < 5 
    
                elseif eval(task_term2) 
                    success_timing{1,count} =  transpose(all_timing2(1,ii:ii+(all_timing_num-1)));       
                    count = count+1;
                end
            end
        end
end
success_timing = cell2mat(success_timing); 
end