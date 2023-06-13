%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%440行目の、xlineのパラメータを変更するように注意する
%{
TimeNormalizedにうまく対応できていない
変数設定が冗長．パス名が長くなる場合はUIで取得できるように書き換える
書き換える必要のある変数はSYNERGYPLOT内で完結させる
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotSynergyAll_uchida(fold_name,emg_group,pcNum,plk,monkey_name,exp_day)
%% set param
% fold_name = 'Wa180928';
% 
EMG_num = 16;
% emg_group = 1;
pre_frame = 300; %pre_frame数を代入(xlineで使用する)

task = 'standard_filtNO5'; %各筋シナジーフォルダー内の語尾の部分(全部standard_filtNO5で統一されているはず)
synergy_type = 'TimeNormalized_task'; %筋シナジーの種類(tim1,tim2,tim3,TimeNormalized_task,allData_task etc...)
save_fold = 'nmf_result';

%% code section
cd([num2str(exp_day) '/' save_fold])
cd([fold_name '_' task '_' synergy_type])


% everyday nomalization(nmfファイルの読み込み)←これの前にmakefoldで、筋シナジーごとにfolderを分けて作成するようにすべき
load([fold_name '_' task '_' sprintf('%02d',EMG_num) '.mat']);
load([fold_name '_' task '_' sprintf('%02d',EMG_num) '_nmf.mat']);
switch emg_group
%     case 1%without 'Deltoid'
%         EMG_num = 12;
%         EMGs = {'BRD';'ECR';'ECU';'ED45';'EDCdist';'EDCprox';'FCR';'FCU';'FDP';...
%                 'FDSdist';'FDSprox';'PL'};
%     case 2%only extensor
%         EMG_num = 5;
%         EMGs = {'ECR';'ECU';'ED23';'ED45';'EDC'};
%     case 3%only flexor
%         EMG_num = 4;
%         EMGs = {'FCR';'FCU';'FDP';'FDS'};
%     case 4%forearm?
%         EMG_num = 10;
%         EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS'};
%     case 5%~11/27
%         EMG_num = 11;
%         EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'Triceps'}; 
%     case 6%11/30~
%         EMG_num = 10;
%         EMGs = {'BRD';'ECR';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'Triceps'}; 
    case 1
        EMG_num = 16;
        %EMGsの名前をnmfで得られたstandard.mat内のTargetNameに変更する(現状のEMGは名前が違う)
        EMGs = TargetName;
end

% down_sample = 0; %NMFに用いた前処理済みのEMGがダウンサンプリングされているかどうか(filterBatでフィルタリングを行った場合は1にする) 
%{
tim_file_num = 3; %タイミングデータ関連の変数が何個あるか(使用するCAIとCTTLのファイルの総和).基本は1(CAI_001のみ)か3(CAI_001,CTTL_002,CTTL_003の三つ)
if tim_file_num == 3
    define_task = 1; %タスク定義の設定　1:1~5を満たせばいい 2:1~5を満たし、平均フレームからのズレがdef_per%以内(def_perは任意の値)
    if define_task == 2
        def_per = 10;
    end
end
%}

% pcNum = 3;
kf = 1; %データの分割数(クロスバリデージョンしないときは1)
% freq = 100;
% range_t = Info.TimeRange(1,2) - Info.TimeRange(1,2);
% filt_on = 0;

save_fig_W = 1;
% save_fig_H = 1;
% save_fig_VAF = 1;
save_fig_r2 = 1; 

save_data = 1;
%% make W&T good by W 2 (クロスバリデージョンしたとき、各テストデータのシナジーを合わせるためのもの)※詳しくはMATLAB関数のP17参照
if kf > 1 %クロスバリデージョンしたとき
    cell_selD = cell(1,kf);
    cell_selH = cell(1,kf);
    cell_selD{1,1} = test.W{pcNum,1};
    cell_selH{1,1} = test.H{pcNum,1};
    comD = zeros(EMG_num, pcNum);
    comD_state = zeros(EMG_num, pcNum);
    selD = zeros(EMG_num,pcNum);
    selH = zeros(pcNum,length(test.H{pcNum,1}(1,:)));
    m = zeros(1,pcNum);
    k = zeros(kf-1,pcNum);
    for n = 1:kf-1%make no doubled!!!!!!
        for i = 1:pcNum
            for j = 1:pcNum
                comD(:,j) = test.W{pcNum,1}(:,i);
            end
            comD_state = abs(comD - test.W{pcNum,n+1});
            for j = 1:pcNum
                m(1,j) = sum(comD_state(:,j)); 
                for l=1:pcNum              
                    if j == k(n,l)
                        m(1,j) = 1000000;
                    end
                end
            end
            min_ar = find( m(1,:) == min(m));
            k(n,i) = min_ar;
            selD(:,i) = test.W{pcNum,n+1}(:,min_ar);
            selH(i,:) = test.H{pcNum,n+1}(min_ar,:);
        end
        cell_selD{1,n+1} = selD;
        cell_selH{1,n+1} = selH;
    end
else
end
%% plot W

f1 = figure('Position',[100,100,1200,800]);
x = categorical(EMGs');

if kf > 1 %クロスバリデージョンしたとき 
    aveW = zeros(EMG_num,pcNum);
    for i = 1:pcNum
        subplot(pcNum,1,i); 
        bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i) cell_selD{1,3}(:,i) cell_selD{1,4}(:,i)]);
        aveW(:,i) = (cell_selD{1,1}(:,i) + cell_selD{1,2}(:,i) + cell_selD{1,3}(:,i) + cell_selD{1,4}(:,i)) ./ 4;
    %     bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i)]);
        ylim([0 3.5]);
        title([fold_name ' W pcNum = ' sprintf('%d',pcNum)]);
    end
    if save_data == 1
        cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
        cd ([fold_name '_W'])
        comment = 'this data will be used for dispW';
        save([fold_name '_aveW_' sprintf('%d',pcNum) '.mat'], 'aveW','k','pcNum','fold_name','comment');
        cd ../../
    end
    if save_fig_W ==1
        cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
        cd ([fold_name '_W'])
        saveas(gcf,[fold_name ' W pcNum = ' sprintf('%d',pcNum) '.png']);
        cd ../
        cd ../
    end
    close all;
    %空間成分の平均のプロット
    f1 = figure('Position',[0,1000,800,1700]);
    for i = 1:pcNum
        subplot(pcNum,1,i); 
        bar(x,aveW(:,i))
    %     bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i)]);
        ylim([0 3.5]);
        title([fold_name ' aveW pcNum = ' sprintf('%d',pcNum)]);
    end
    %↓図の保存(Wの平均)
    if save_fig_W ==1
        cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
        cd ([fold_name '_W'])
        saveas(gcf,[fold_name ' aveW pcNum = ' sprintf('%d',pcNum) '.png']);
        close all;
        cd ../
        cd ../
    end
else %交差検証ないとき
    for i = 1:pcNum
        subplot(pcNum,1,i); 
        bar(x,W{pcNum,1}(:,i));
    %     bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i)]);
        ylim([0 2]);
        title([fold_name ' W pcNum = ' sprintf('%d',pcNum)]);
    end
    if save_data == 1
        cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
        cd ([fold_name '_W'])
        comment = 'this data will be used for dispW';
        used_W = W{i,1}; %Wの重みの値
        save([fold_name '_W_' sprintf('%d',pcNum) '.mat'], 'used_W','pcNum','fold_name','comment');
        cd ../../
    end
    if save_fig_W ==1
        cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
        cd ([fold_name '_W'])
        saveas(gcf,[fold_name ' W pcNum = ' sprintf('%d',pcNum) '.png']);
        cd ../
        cd ../
    end
    close all;
end

%% plot T
% load([fold_name '_SUC_Timing.mat']);
% SUC_Timing_A = floor(SUC_Timing_A ./ 110);

%{         
task_base = strrep(task,strrep(task,'standard',''),'');
%
cd ../../easyData
cd([fold_name '_' task_base])
load([fold_name '_EasyData.mat'],'Tp','SampleRate');
%RUNNINGEASYFUNC関数を実行しないと、このMATファイルは得られない
cd ../../
cd([save_fold '/' fold_name '_' task])
%Cd(nmf_result/Se200311_standard_filtNO5)と同義

SUC_Timing_A = floor(Tp.*(100/SampleRate));
%FLOORは切り捨て
SUC_num = length(Tp(:,1))-1;

if filt_on == 1
 [bH,aH]=butter(2,0.05/(freq/2),'high'); 
 [bL,aL]=butter(2,30/(freq/2),'low');
%smooth_num = 100;
end

if plk == 1
%}
%% define All_T(testの各セクションのデータを寄せ集めて、シナジー数*時系列の時間シナジーを作る)(クロスバリデージョンしたとき)
if kf > 1
    len_kf = length(test.H{1,1}(1,:));
    All_T = zeros(pcNum,len_kf .* kf);
    for i = 1:pcNum                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
        for j = 1:kf
            All_T(i,((j-1) * len_kf + 1):(j * len_kf)) = cell_selH{1,j}(i,:);
        end
    end
end

%% define timing DATA(untitledで定義するように変更したから必要ないかもしれない)\
%{
cd ../../

load(['AllData_' monkey_name num2str(exp_day) '.mat'],['CAI_' sprintf('%03d',1)],['CAI_'  sprintf('%03d',1) '_KHz'],'CTTL*')

judge_arrange =  CAI_001(1,:) > -500;
judge_ID = find(judge_arrange);

%↓trim_sectionの作成
trim_section(1,1) = judge_ID(1,1);
count = 1;
for ii = 2:length(judge_ID)
    disting = judge_ID(1,ii) - judge_ID(1,ii-1);
    if disting == 1

    else
        trim_section(2,count) = judge_ID(1,ii-1);
        count = count+1;
        trim_section(1,count) = judge_ID(1,ii);
    end
end
trim_section(2,end) = judge_ID(1,end);
timing1 = [trim_section(1,:);repmat(1,1,length(trim_section))];
timing4 = [trim_section(2,:);repmat(4,1,length(trim_section))];
%↓CTTLが存在するときの操作
if tim_file_num == 3
    %TTL信号をCAI信号にalignするための偏差
    e1 = round((CTTL_002_TimeBegin - CAI_001_TimeBegin) * 1375); %基準をCAI_001のTimeBeginにするかCTTL_001のTimeBeginにするか検討する(現状はCAI_001になっている)
    CTTL_002_Up = e1 + CTTL_002_Up;
    CTTL_002_Down = e1 + CTTL_002_Down;
    e2 = round((CTTL_003_TimeBegin - CAI_001_TimeBegin) * 1375); %基準をCAI_001のTimeBeginにするかCTTL_001のTimeBeginにするか検討する
    CTTL_003_Up = e2 + CTTL_003_Up;
    CTTL_003_Down = e2 + CTTL_003_Down;
    %↑ここまで
    timing2 = [CTTL_002_Down;repmat(2,1,length(CTTL_002_Down))];
    timing3 = [CTTL_002_Up;repmat(3,1,length(CTTL_002_Up))];
    timing5 = [CTTL_003_Down;repmat(5,1,length(CTTL_003_Down))];
end

all_timing = {timing1 timing2 timing3 timing4};
all_timing = cell2mat(all_timing);
all_timing = sort_timing(all_timing,1);
if temporary_term == 1
    for ii = 1:length(all_timing)
        if all_timing(1,ii) > 4.128*10^5
            all_timing(2,ii) = 0;
        end
    end
end
%{
%↓サンプリングレートをカメラのフレームレートに合わせる(カメラとの同期ができているかどうかの確認用の変数)
cam_trim_section = round(trim_section * (240/1375));
cam_task_frame = cam_trim_section(2,:) - cam_trim_section(1,:);
trim_number = 2 : length(trim_section) + 1;%カメラのトリミング動画のトライアル数との照合のための番号(カメラのトリミングプログラムの便宜上2から始まっている)
cam_data = [cam_trim_section ; cam_task_frame ; trim_number];
%タスク中のフレーム数(タスクの長さに関してソート)
cam_data = sort_timing(cam_data);
%↑ここまで
%}
count = 1; 
for ii = 1:length(all_timing)
    if all_timing(2,ii) == 1
        if (all_timing(2,ii+1)==2 && all_timing(2,ii+2)==3 && all_timing(2,ii+3)==4)
            success_timing1{1,count} = all_timing(:,ii:ii+3);
            count = count+1;
        end
    end
end
success_timing1 = cell2mat(success_timing1);
all_timing2 = {success_timing1 timing5};
all_timing2 = sort_timing(cell2mat(all_timing2),1); 

count = 1;
for ii = 1:length(all_timing2)
    if all_timing2(2,ii) == 1
        %↓エラーを避けるために必要
        if length(all_timing2) - ii < 4 
        
        elseif (all_timing2(2,ii+1)==2 && all_timing2(2,ii+2)==3 && all_timing2(2,ii+3)==4 && all_timing2(2,ii+4)==5)
            success_timing{1,count} =  transpose(all_timing2(1,ii:ii+3));
            success_timing2{1,count} = all_timing2(:,ii:ii+4);
            count = count+1;
        end
    end
end

success_timing = cell2mat(success_timing); 
success_timing2 = cell2mat(success_timing2);
success_timing = [success_timing;success_timing(4,:) - success_timing(1,:)];
%↓success_timingをタスクの長さ順にソートしたもの
sorted_success_timing = [sort_timing(success_timing,5);sort_timing(success_timing(5,:)/mean(success_timing(5,:)),1)];
if define_task ==2
    define_judge = (1-(def_per/100)) < sorted_success_timing(6,:) & sorted_success_timing(6,:) < (1+(def_per/100));
    define_start =find(define_judge,1,'first'); 
    define_end = find(define_judge,1,'last');
    success_timing = sort_timing(success_timing,5);
    success_timing = success_timing(:,define_start:define_end);
    sorted_success_timing = sorted_success_timing(:,define_start:define_end);
    %{
    for ii = 1:length(success_timinged_success_timing)
        if (success_timinged_success_timing(6,ii) > 1-(def_per/100)) &&  (sorted_success_timing(6,ii) > 1+(def_per/100))
            
        end
    end
    %}
end
if down_sample == 1
    trim_section = round(trim_section * (100/1375));
end
%↑trim_sectionここまで
%task_frame = trim_section(2,:) - trim_section(1,:);
%timing_data = [trim_section ; task_frame ; trim_number];

%タイミングデータを、タスクのフレーム数に関して並び替え(冗長なコード)
%timing_data = sort_timing(timing_data);
 %↓CAI_001しかタイミングデータがなかったときの成功定義
if tim_file_num == 1
    criterion_num = 1240;%基準となるタスクのフレーム数
    error_per = 10; %基準からの許容する誤差(%)
    min_num = criterion_num - (criterion_num * (error_per/100));
    max_num = criterion_num + (criterion_num * (error_per/100));
    trim_count = 1; 
    for ii = 1:length(timing_data)
        task_range = timing_data(3,ii);
        if and(min_num<task_range,task_range<max_num)
            success_timing(:,trim_count) = timing_data(:,ii);
            trim_count = trim_count + 1;
        end
    end
end
%↑ここまで
%↓CAIデータが2個あるときの成功定義
%{
if tim_file_num ==2
    if tf == 1
        timing1(1,:) = trim_section(1,:);
        timing1(2,:) = 1;
        timing4(1,:) = trim_section(2,:);
        timing4(2,:) = 4;
    elseif tf==2
        timing2(1,:) = trim_section(1,:);
        timing2(2,:) = 2;
        timing3(1,:) = trim_section(2,:);
        timing3(2,:) = 3;
    end
end
%}

if pcNum == 3
    if define_task == 1
        cd EMG_Data/Data;
        save('define1_success_timing.mat','success_timing','success_timing2','sorted_success_timing');
        cd ../../
    elseif define_task == 2
        cd EMG_Data/Data;
        save('define2_success_timing.mat','success_timing','sorted_success_timing');
        cd ../../
    end
end
%{
if tim_file_num == 2
    candidate_timing_sel = {timing1 timing2 timing3 timing4};
    candidate_timing = cell2mat(candidate_timing_sel);


    %↓candidate_timingの並び替え(時系列順に)
    candidate_timing = transpose(sortrows(transpose(candidate_timing)));

    %candidate_timingをもとに、条件を指定してsuccess_timingを決定する(CAI_002がないとできない)
    count = 1;
    for ii = 1:length(candidate_timing)-3
        if candidate_timing(2,ii) == 1 && candidate_timing(2,ii+1) == 2 && candidate_timing(2,ii+2) == 3 && candidate_timing(2,ii+3) == 4
            success_timing_sel{1,count}=transpose([candidate_timing(1,ii) candidate_timing(1,ii+1) candidate_timing(1,ii+2) candidate_timing(1,ii+3)]);
            count = count + 1;
        end
    end
    success_timing = cell2mat(success_timing_sel);
end
%}

%% trimming EMG section
%↓この処理は1データにつき1回でいいからシナジー数が3の処理の時だけ実行するようにした
if pcNum == 3
    cd([save_fold '/' monkey_name num2str(exp_day) '_standard' ]);
    if tim_file_num == 3
        [All_task_EMG,All_ave_task_EMG,tim_hist] = trimingEMG(EMG_num,EMGs,success_timing,down_sample,define_task); 
        cd ../
        %↓タスクの平均サンプル数。正規化した後のおおよそのサンプリングレートを導出するのに必要
        ave_sample_num = mean(success_timing(2,:) - success_timing(1,:));
        cd Data
        if tim_file_num == 3
            if define_task == 1
                 save('define1_tim_hist.mat','tim_hist');
            elseif define_task == 2
                 save('define2_tim_hist.mat','tim_hist');
            end
        end
        if down_sample == 1
            save('filtered_task_EMG_Data(down_sample).mat','All_task_EMG','All_ave_task_EMG','ave_sample_num');
        else
            if define_task == 1
                save('define1_filtered_task_EMG_Data.mat','All_task_EMG','All_ave_task_EMG','ave_sample_num');
            elseif define_task == 2
                save('define2_filtered_task_EMG_Data.mat','All_task_EMG','All_ave_task_EMG','ave_sample_num');
            end
        end
        cd ../
    end
cd ../;
%↑カレントディレクトリを日付に直す
end
cd ../
%↑カレントディレクトリをNibaliに直す
%}
cd ../../../
%↑カレントディレクトリをNibaliに直す
%% trimming synergy_H section(クロスバリデージョンするとき)
if kf > 1
    trimingSynergyH(pcNum,All_T,success_timing,save_fold,monkey_name,exp_day,task);
else
    figure('Position',[100,100,1200,800]);
    for ii = 1:pcNum
        subplot(pcNum,1,ii)
        plot(H{pcNum,1}(ii,:),'LineWidth',2)
        xlim([0 length(H{pcNum,1})]);
        ylim([0 3])
        %↓この分は冗長なので書き換えた方がいい
        switch synergy_type
            case 'tim1'
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
            case 'tim2'
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
            case 'tim3'
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
            case 'TimeNormalized_task'
               cd([num2str(exp_day) '/EMG_Data/Data']) 
               load('task_normalized_hist.mat');
               hold on;
               yyaxis right;
               ylim([0 40])
               histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
               histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
               tim2_median = median(tim_hist(1,:));
               tim3_median = median(tim_hist(2,:));
               xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
               xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
               title(['synergy' num2str(ii)])
               hold off
               cd ../../../
        end
    end
    cd([num2str(exp_day) '/' save_fold '/' monkey_name num2str(exp_day) '_' task '_' synergy_type '/' monkey_name num2str(exp_day) '_syn_result_16/' monkey_name num2str(exp_day) '_H']);
    saveas(gcf,['task_synergyH(pcNum=' num2str(pcNum) ').png'])
    close all
    cd ../../../../
end
%% plk値によって、W,T,R^2の保存場所の設定を変更する
if plk == 1
    %まだ割り当ててない
elseif plk==3
    %plot r2
    f5 = figure('Position',[100,100,800,800]);
%         load([fold_name '_' sprintf('%02d',EMG_num) 'fix.mat']);
    cd(['nmf_result/' fold_name '_' task '_' synergy_type])
    load([fold_name '_' task '_' sprintf('%02d',EMG_num) '.mat']);
    if kf > 1
        for i= 1:kf
            %plot((1 - cell2mat(test.D(:,i)))*100);
            plot(test.r2(:,i));
            %plot((1 - cell2mat(train.D(:,i)))*100);
            ylim([0 1]);
            hold on;
            plot(shuffle.r2(:,i),'Color',[0,0,0]);
            hold on
        end
    else
        plot(r2,'Color',[1,0,0])
        ylim([0 1])
        hold on;
        plot(shuffle.r2,'Color',[0,0,0])
        hold on
    end

    plot([0 EMG_num + 1],[0.8 0.8]);
    title([fold_name ' R^2']);
    xlim([0 length(EMGs)])

    if save_fig_r2 ==1
        cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
        cd ([fold_name '_r2'])
        saveas(gcf,[fold_name ' R2 .png']);
        close all;
        cd ../;
        cd ../;
    end

    cd ../
    cd ../
end

cd ../;
end
%% trimngEMG
%タスク中のフィルタリング済みのEMGをプロットして保存する関数
%改善点:　データの保存場所をEMG_Data→pictureに変更する
%この関数内でタスク中のRAW_EMGもプロットして保存できるようにする
function [All_task_EMG,All_ave_task_EMG,tim_hist] = trimingEMG(EMG_num,EMGs,success_timing,down_sample,define_task)
    % タスク中のEMGのプロット
    figure('Position',[0,0,1700,1700]);
    
    for ii=1:EMG_num
        if down_sample == 1
            load([EMGs{ii} '-hp50Hz-rect-lp20Hz-ds100Hz.mat'],'Data')
        else
            load(['NEW_' EMGs{ii} '-hp50Hz-rect-lp20Hz.mat'],'Data')
        end
        
        %{ 
        %多分もう使わない(ロードするデータがフィルタリング済みだから)
        if RAW_filt == 1
            % cut low frequency noise
            filt_h = 10;
            SR = 1375;
            [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
            Data = filtfilt(B,A,Data);
            
            % cut high frequency noise
            filt_l = 500;
            [B,A] = butter(6, (filt_l .* 2) ./ SR, 'low');
            Data = filtfilt(B,A,Data);
        end
        %}
        
        task_EMG_sel={};
        %[~,col] = size(success_timing);
        for jj = 1:length(success_timing)
            task_trim = Data(success_timing(1,jj)+1:success_timing(4,jj));
            tim_hist(1,jj) = ((success_timing(2,jj))-(success_timing(1,jj)+1)) * (1000/length(task_trim));
            tim_hist(2,jj) = ((success_timing(3,jj))-(success_timing(1,jj)+1)) * (1000/length(task_trim));
            %↓成功タスクを時間正規化するとき、100Hzにダウンサンプリングされた方は、サンプル数が100になるようにリサンプリングし、
            % ダウンサンプリングしないフィルタリング処理EMGを使用している場合は、ひとまずサンプル数が1000になるようにリサンプリングする\
            if down_sample == 1
                task_trim = resample(task_trim,100,length(task_trim));
            else
                task_trim = resample(task_trim,1000,length(task_trim));
            end
            task_EMG_sel{jj,1} = task_trim;
        end
        task_EMG = cell2mat(task_EMG_sel);
        ave_task_EMG = mean(task_EMG);
        subplot(4,4,ii)
        for kk = 1:length(task_EMG_sel)
            plot(task_EMG(kk,:));
            hold on;
            if kk == 1 
                yMax = max(task_EMG(kk,:));
                ylim([0 yMax+10]);
            elseif max(task_EMG(kk,:)) > yMax
                yMax = max(task_EMG(kk,:));
                ylim([0 yMax+10]);
            end
        end
        yyaxis right;
        ylim([0 40])
        histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
        histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
        tim2_median = median(tim_hist(1,:));
        tim3_median = median(tim_hist(2,:));
        xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
        xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
        title([EMGs{ii} '(uV)'])
        hold off
        All_task_EMG{ii,1} = task_EMG;
        All_ave_task_EMG{ii,1} = ave_task_EMG;
    end
    
    cd ../../
    cd EMG_Data/picture
    
    if down_sample == 1
        saveas(gcf,'filtered_taskEMG(ds100Hz).png');
    else
        if define_task == 1
            saveas(gcf,'define1_filtered_taskEMG.png');
        elseif define_task == 2
            saveas(gcf,'define2_filtered_taskEMG.png');
        end
    end
    close all;
    All_ave_task_EMG = cell2mat(All_ave_task_EMG);
    
    % タスク中のEMGの平均をプロット
    figure('Position',[0,0,1700,1700]);
    
    for ll = 1:EMG_num
        subplot(4,4,ll)
        plot(All_ave_task_EMG(ll,:))
        hold on;
        yyaxis right;
        ylim([0 40])
        histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
        histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
        tim2_median = median(tim_hist(1,:));
        tim3_median = median(tim_hist(2,:));
        xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
        xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
        title([EMGs{ll} '(uV)'])
        hold on
    end
    hold off
    
    if down_sample == 1
        saveas(gcf,'ave_filtered_taskEMG(ds100Hz).png');
    else
        if define_task == 1
            saveas(gcf,'define1_ave_filtered_taskEMG.png');
        elseif define_task == 2
            saveas(gcf,'define2_ave_filtered_taskEMG.png');
        end
    end
    close all;
        
end

%% triming synergyH
function [] = trimingSynergyH(pcNum,All_T,success_timing,save_fold,monkey_name,exp_day,task)
    %↓時間シナジーのプロット
    figure('Position',[0,0,1000,1700]);
    for ii=1:pcNum
        %[~,col] = size(success_timing);
        for jj = 1:length(success_timing)
            use_synergy = All_T(ii,:);
            synergy_trim = use_synergy(success_timing(1,jj)+1:success_timing(4,jj));
            synergy_trim = resample(synergy_trim,250,length(synergy_trim));
            task_synergy_sel{jj,1} = synergy_trim;
        end
        task_synergy = cell2mat(task_synergy_sel);
        ave_task_synergy_sel{ii,1} = mean(task_synergy);
        subplot(pcNum,1,ii)
        for kk = 1:length(task_synergy_sel)
            plot(task_synergy(kk,:));
            hold on;
        end
        %ここにヒストグラムのコードを挿入
        hold off
    end
    
    cd([num2str(exp_day) '/' save_fold '/' monkey_name num2str(exp_day) '_' task '/' monkey_name num2str(exp_day) '_syn_result_16/' monkey_name num2str(exp_day) '_H']);
    saveas(gcf,['task_synergyH(pcNum=' num2str(pcNum) ').png'])
    close all
    
    %↓時間シナジーの平均のプロット
    figure('Position',[0,0,1000,1700]);
    
    ave_task_synergy = cell2mat(ave_task_synergy_sel);
    
    for ll = 1:pcNum
        subplot(pcNum,1,ll)
        plot(ave_task_synergy(ll,:))
    end
    saveas(gcf,['ave_task_synergyH(pcNum=' num2str(pcNum) ').png'])
    close all
    cd ../../../../
end

%% データをソートするためのファンクション,refine_rowsは、どの行に関してソートするか
function sorted_data = sort_timing(use_data,refine_rows)
    sort_data = transpose(use_data);
    sorted_data = transpose(sortrows(sort_data,refine_rows,'ascend'));
end

     %SUC_num = 72;%length(T_timing(:,1));
% %     TIME_W = 150;
% %     ave = zeros(pcNum,TIME_W);
% %     pullData = zeros(SUC_num,TIME_W);
% %     sec = zeros(3,1);
% %     f2 = figure('Position',[900,1000,800,1300]);
% %     for j=1:pcNum
% %         for i=1:SUC_num
% %            subplot(pcNum,1,j);
% %            time_w = SUC_Timing_A(i,4) - SUC_Timing_A(i,1) +1;
% %            if time_w == TIME_W
% %                sec(1,1) = sec(1,1)+1;
% %                if filt_on == 1
% %                    pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)))));
% %                else
% %                    pullData(i,:) = All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4));
% %                end
% %            elseif time_w<TIME_W 
% %                sec(2,1) = sec(2,1)+1;
% %                if filt_on == 1
% %                pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W))));
% %                else
% %                    pullData(i,:) = interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W);
% %                end
% %            else
% %                sec(3,1) = sec(3,1)+1;
% %                if filt_on == 1
% %                    pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w))));
% %                else
% %                    pullData(i,:) = resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w);
% %                end
% %            end
% %            plot(pullData(i,:));
% %            ave(j,:) = ((ave(j,:) .* (i-1)) + pullData(i,:)) ./ i ;
% %            ylim([0 2]);
% %            hold on;
% %         end
% %     end

%{
   TIME_W = 150;
       ave = zeros(pcNum,TIME_W);
       pullData = zeros(SUC_num,TIME_W);
       sec = zeros(3,1);
       f2 = figure('Position',[900,1000,800,1300]);
       for j=1:pcNum
           for i=1:SUC_num
              subplot(pcNum,1,j);
              time_w = SUC_Timing_A(i,4) - SUC_Timing_A(i,1) +1;
              if time_w == TIME_W
                  sec(1,1) = sec(1,1)+1;
                  if filt_on == 1
                      pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)))));
                  else
                      pullData(i,:) = All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4));
                  end
              elseif time_w<TIME_W 
                  sec(2,1) = sec(2,1)+1;
                  if filt_on == 1
                  pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W))));
                  else
                      pullData(i,:) = interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W);
                  end
              else
                  sec(3,1) = sec(3,1)+1;
                  if filt_on == 1
                      pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w))));
                  else
                      pullData(i,:) = resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w);
                  end
              end
              plot(pullData(i,:));
              ave(j,:) = ((ave(j,:) .* (i-1)) + pullData(i,:)) ./ i ;
              ylim([0 2]);
              hold on;
           end
       end
end

if plk == 2
    len_kf = length(test.H{1,1}(1,:));
    All_T = zeros(pcNum,len_kf .* kf);
    for i = 1:pcNum
        for j = 1:kf
            All_T(i,((j-1) * len_kf + 1):(j * len_kf)) = cell_selH{1,j}(i,:);
        end
    end
     %SUC_num = 72;%length(T_timing(:,1));
    TIME_W = 150;
    ave = zeros(pcNum,TIME_W);
    pullData = zeros(SUC_num,TIME_W);
    sec = zeros(3,1);
    f2 = figure('Position',[900,1000,800,1300]);
    for j=1:pcNum
        for i=1:SUC_num
           subplot(pcNum,1,j);
           time_w = SUC_Timing_A(i,4) - SUC_Timing_A(i,1) +1;
           if time_w == TIME_W
               sec(1,1) = sec(1,1)+1;
               if filt_on == 1
                   pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)))));
               else
                   pullData(i,:) = All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4));
               end
           elseif time_w<TIME_W 
               sec(2,1) = sec(2,1)+1;
               if filt_on == 1
               pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W))));
               else
                   pullData(i,:) = interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W);
               end
           else
               sec(3,1) = sec(3,1)+1;
               if filt_on == 1
                   pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w))));
               else
                   pullData(i,:) = resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w);
               end
           end
           plot(pullData(i,:));
           ave(j,:) = ((ave(j,:) .* (i-1)) + pullData(i,:)) ./ i ;
           ylim([0 2]);
           hold on;
        end
    end
end 
if plk == 3
    len_kf = length(test.H{1,1}(1,:));
    All_T = zeros(pcNum,len_kf .* kf);
    for i = 1:pcNum
        for j = 1:kf
            All_T(i,((j-1) * len_kf + 1):(j * len_kf)) = cell_selH{1,j}(i,:);
        end
    end
     %SUC_num = 72;%length(T_timing(:,1));
    TIME_W = 200;
    ave = zeros(pcNum,TIME_W + TIME_W/4);
    pullData = zeros(SUC_num,TIME_W);
    pre_term1 = zeros(SUC_num, TIME_W/4);
    AllPullData = zeros(SUC_num, TIME_W + TIME_W/4);
    sec = zeros(3,1);
    f2 = figure('Position',[900,1000,800,1300]);
    for j=1:pcNum
        for i=1:SUC_num
           subplot(pcNum,1,j);
           time_w = SUC_Timing_A(i,4) - SUC_Timing_A(i,1) +1;
           if time_w == TIME_W
               sec(1,1) = sec(1,1)+1;
               if filt_on == 1
                   pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)))));
               else
                   pullData(i,:) = All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4));
                   pre_term1(i,:) =  All_T(j,SUC_Timing_A(i,1)-TIME_W/4:SUC_Timing_A(i,1)-1);
               end
           elseif time_w<TIME_W 
               sec(2,1) = sec(2,1)+1;
               if filt_on == 1
               pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W))));
               else
                   %竊灘撫鬘後?ｮ陦?
                   pullData(i,:) = interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W);
                   pre_term1(i,:) = interpft(All_T(j,SUC_Timing_A(i,1)-50/(TIME_W/time_w):SUC_Timing_A(i,1)-1),TIME_W/4);
               end
           else
               sec(3,1) = sec(3,1)+1;
               if filt_on == 1
                   pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w))));
               %竊灘撫鬘後?ｮ陦?
               else
                   pullData(i,:) = resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w);
                   pre_term1(i,:) = resample(All_T(j,SUC_Timing_A(i,1)-50/(TIME_W/time_w):SUC_Timing_A(i,1)-1),TIME_W,time_w);
               end
           end
           AllPullData(i,:) = [pre_term1(i,:) pullData(i,:)];
           plot(AllPullData(i,:));
           ave(j,:) = ((ave(j,:) .* (i-1)) + AllPullData(i,:)) ./ i ;
           ylim([0 2]);
           hold on;
        end
    end
end

if plk == 4
    len_kf = length(test.H{1,1}(1,:));
    All_T = zeros(pcNum,len_kf .* kf);
    for i = 1:pcNum
        for j = 1:kf
            All_T(i,((j-1) * len_kf + 1):(j * len_kf)) = cell_selH{1,j}(i,:);
        end
    end
     %SUC_num = 72;%length(T_timing(:,1));
    TIME_W = 200;
    ave = zeros(pcNum,TIME_W + TIME_W/4);
    pullData = zeros(SUC_num,TIME_W);
    pre_term1 = zeros(SUC_num, TIME_W/4);
    AllPullData = zeros(SUC_num, TIME_W + TIME_W/4);
    sec = zeros(3,1);
    f2 = figure('Position',[900,1000,800,1300]);
    for j=1:pcNum
        for i=1:SUC_num
           subplot(pcNum,1,j);
           time_w = SUC_Timing_A(i,4) - SUC_Timing_A(i,1) +1;
           if time_w == TIME_W
               sec(1,1) = sec(1,1)+1;
               if filt_on == 1
                   pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)))));
               else
                   pullData(i,:) = All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4));
                   pre_term1(i,:) =  All_T(j,SUC_Timing_A(i,1)-TIME_W/4:SUC_Timing_A(i,1)-1);
               end
           elseif time_w<TIME_W 
               sec(2,1) = sec(2,1)+1;
               if filt_on == 1
               pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W))));
               else
                   pullData(i,:) = interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W);
                   pre_term1(i,:) = interpft(All_T(j,SUC_Timing_A(i,1)-50/(TIME_W/time_w):SUC_Timing_A(i,1)-1),TIME_W/4);
               end
           else
               sec(3,1) = sec(3,1)+1;
               if filt_on == 1
                   pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w))));
               else
                   pullData(i,:) = resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w);
                   pre_term1(i,:) = resample(All_T(j,SUC_Timing_A(i,1)-50/(TIME_W/time_w):SUC_Timing_A(i,1)-1),TIME_W,time_w);
               end
           end
           AllPullData(i,:) = [pre_term1(i,:) pullData(i,:)];
           plot(AllPullData(i,:));
           ave(j,:) = ((ave(j,:) .* (i-1)) + AllPullData(i,:)) ./ i ;
           ylim([0 2]);
           hold on;
        end
    end
end

    if plk == 1
        if save_data == 1
            cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
            cd ([fold_name '_H'])
            aveH = ave;
            comment = 'this data will be used for dispH';
            save([fold_name '_aveH_' sprintf('%d',pcNum) '.mat'], 'aveH','k','pcNum','fold_name','comment');
            cd ../../
        end

        if save_fig_H ==1
            cd ([fold_name '_syn_result_' sprintf('%02d',EMG_num)])
            cd ([fold_name '_H'])
            saveas(gcf,[fold_name ' H_2 pcNum = ' sprintf('%d',pcNum) '.fig']);
            saveas(gcf,[fold_name ' H_2 pcNum = ' sprintf('%d',pcNum) '.png']);
            cd ../;
            cd ../;
        end

         f3=figure('Position',[900,1000,800,1300]);
         for j=1:pcNum
             subplot(pcNum,1,j);
             plot(ave(j,:),'r');
             ylim([0 2]);
             hold on;
         end

         if save_fig_H ==1
             cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
             cd ([fold_name '_H'])
             saveas(gcf,[fold_name ' H_ave pcNum = ' sprintf('%d',pcNum) '.fig']);
             saveas(gcf,[fold_name ' H_ave pcNum = ' sprintf('%d',pcNum) '.png']);
             cd ../;
             cd ../;
         end

        %% plot r2
        f5 = figure;
        load([fold_name '_' sprintf('%02d',EMG_num) '.mat']);
        for i= 1:kf
            %plot((1 - cell2mat(test.D(:,i)))*100);
            plot(test.r2(:,i));
            %plot((1 - cell2mat(train.D(:,i)))*100);
            ylim([0 1]);
            hold on;
            plot(shuffle.r2(:,i),'Color',[0,0,0]);
            hold on
        end

            plot([0 EMG_num + 1],[0.8 0.8]);
            title([fold_name ' R^2']);

        if save_fig_r2 ==1
            cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
            cd ([fold_name '_r2'])
            saveas(gcf,[fold_name ' R2 pcNum = ' sprintf('%d',pcNum) '.png']);
            cd ../;
            cd ../;
        end

        cd ../
        cd ../
    elseif plk == 3
        if save_data == 1
            cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
            cd ([fold_name '_H'])
            aveH = ave;
            comment = 'this data will be used for dispH';
            save([fold_name '_aveH3_' sprintf('%d',pcNum) '.mat'], 'aveH','k','pcNum','fold_name','comment');
            cd ../../
        end

        if save_fig_H ==1
            cd ([fold_name '_syn_result_' sprintf('%02d',EMG_num)])
            cd ([fold_name '_H'])
            saveas(gcf,[fold_name ' HS_2 pcNum = ' sprintf('%d',pcNum) '.fig']);
            saveas(gcf,[fold_name ' HS_2 pcNum = ' sprintf('%d',pcNum) '.png']);
            cd ../;
            cd ../;
        end

         f3=figure('Position',[900,1000,800,1300]);
         for j=1:pcNum
             subplot(pcNum,1,j);
             plot(ave(j,:),'r');
             ylim([0 2]);
             hold on;
         end

         if save_fig_H ==1
             cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
             cd ([fold_name '_H'])
             saveas(gcf,[fold_name ' H3_ave pcNum = ' sprintf('%d',pcNum) '.fig']);
             saveas(gcf,[fold_name ' H3_ave pcNum = ' sprintf('%d',pcNum) '.png']);
             cd ../;
             cd ../;
         end

        %% plot r2
        f5 = figure;
%         load([fold_name '_' sprintf('%02d',EMG_num) 'fix.mat']);
        load([fold_name '_' task '_' sprintf('%02d',EMG_num) '.mat']);
        for i= 1:kf
            %plot((1 - cell2mat(test.D(:,i)))*100);
            plot(test.r2(:,i));
            %plot((1 - cell2mat(train.D(:,i)))*100);
            ylim([0 1]);
            hold on;
            plot(shuffle.r2(:,i),'Color',[0,0,0]);
            hold on
        end

            plot([0 EMG_num + 1],[0.8 0.8]);
            title([fold_name ' R^2']);

        if save_fig_r2 ==1
            cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
            cd ([fold_name '_r2'])
            saveas(gcf,[fold_name ' R2 pcNum = ' sprintf('%d',pcNum) '.png']);
            cd ../;
            cd ../;
        end

        cd ../
        cd ../
    end
end
%}