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
uchidaのやつ参照しながら改善していく
使っていない変数を削除する

【procedure】
pre : CombineMatfile.m
post : makeEMGNMF_btcOhta.m
after-post: makefold.m
%}

function [] = SensorCenteredEMG(exp_day)
%% set parameters
monkeyname='Ni';
% exp_day = '20220805';
save_NMF_fold='nmf_result'; %元save_fold
few_signal = 0; %few_signal(タイミングsignalがLEDカーテンしかない)かどうか
SR = 1375; %筋電データのサンプリングレート
trim_range = 200; %[ms] range of the trimmed EMG(片方向のみ)
timing_name = {'pull', 'food on', 'food off'};
filt_h = 50;%カットオフ周波数の値
%↓シナジー解析用のフィルタリングに関する変数
filter = 1; %フィルターをかけるかどうか
filter_h = 50; %筋シナジー用のハイパスフィルターのカットオフ周波数(筋電解析のためのハイパスカットオフ周波数filt_hと混合しないように注意する)
filter_l = 500; %筋シナジー用のローパスフィルターのカットオフ周波数
after_rect_filter = 20;%整流(rect)後の平滑化のためのローパスフィルターのカットオフ周波数
outlier_threshold = 120; %(mV)スパイクと判断するoutlierの閾値
save_each_fig = 0;
save_combine_fig = 1; 
save_normalized_fig = 0; %(注意!!)他の2つと併用不可

selEMGs= 1:3;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
EMGs=cell(3,1) ;
EMGs{1,1}= 'EPL';
EMGs{2,1}= 'FCU';
EMGs{3,1}= 'FDS';
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
[timing2, timing3, timing4, timing6] = timing_func2(timing_struct);
sensor_data1 = sort_timing([timing2, timing3, timing4], 1);
count = 1;
for ii = 1:length(sensor_data1)-2
    if sensor_data1(2, ii) == 2
        if and(sensor_data1(2, ii+1)==3, sensor_data1(2, ii+2)==4) %2->3->4 
            sensor_data2{1, count} = sensor_data1(:, ii:ii+2);
            count = count + 1;
        end
    end
end
sensor_data2 = cell2mat(sensor_data2);
sensor_data3 = sort_timing([sensor_data2, timing6], 1);
count = 1;
for ii = 1:length(sensor_data3)-3
    if sensor_data3(2, ii) == 2
        if sensor_data3(2, ii+1)==3 && sensor_data3(2, ii+2)==4 && sensor_data3(2, ii+3)==6 %2->3->4->6
            sensor_data4{1, count} = sensor_data3(:, ii:ii+3);
            count = count + 1;
        end
    end
end
sensor_data4 = cell2mat(sensor_data4);
tim_data = [sensor_data4(1, find(sensor_data4(2,:)==2)); sensor_data4(1, find(sensor_data4(2,:)==3)); sensor_data4(1, find(sensor_data4(2,:)==4))];
%% filtering
 %基線の動揺をなくすためにレコードEMGデータにハイパスフィルターをかけるオプション
for ii = 1 : EMG_num
    temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]);
    %outlierの除去と補完(一番近い非欠損値で補完)
    temp_EMG(abs(temp_EMG) > outlier_threshold) = NaN;
    temp_EMG = fillmissing(temp_EMG, 'nearest');
    %offset
    temp_EMG = offset(temp_EMG, 'mean');
    eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
    if save_normalized_fig
        %何もしない
    else
    %high_pass
        [B,A] = butter(6, (filter_h .* 2) ./ SR, 'high');
        temp_EMG = filtfilt(B,A,temp_EMG);
        eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
        %rect
        eval(['CEMG_' sprintf('%03d',ii) ' = abs(CEMG_' sprintf('%03d',ii) ');'])
    end
end    
%↑ハイパスここまで

%% 各タイミング、タスクごとにデータを切り出して図やデータを保存するセクション
% EMGをトリミングしてその平均値を求める(各タイミングごと)
trim_sample_num = trim_range*(SR/1000);
[trimmed_timing_num,trial_num] = size(tim_data);
x = linspace(-1*trim_range, trim_range, trim_sample_num*2);

if save_each_fig
    for ii = 1:EMG_num
        EMG_data = eval(['CEMG_' sprintf('%03d', ii)]);
        for jj = 1:trimmed_timing_num %tim2, tim3, tim4
            EMG_sel = zeros(length(tim_data), trim_sample_num*2);
            for kk = 1:trial_num
                centred_timing = tim_data(jj, kk);
                EMG_sel(kk, :) = EMG_data(1, centred_timing-trim_sample_num+1:centred_timing+trim_sample_num);
            end
            %mean & std を求める
            EMG_mean = mean(EMG_sel);
            EMG_std = std(EMG_sel);
            % plot mean & std(no smoothing)
            figure('position', [100, 100, 1200, 800]);
            curve1 = EMG_mean + EMG_std;
            curve2 = EMG_mean - EMG_std;
            x2 = [x, fliplr(x)];
            inBetween = [curve1, fliplr(curve2)];
            fill(x2, inBetween, 'r', 'FaceAlpha',0.1, 'LineStyle',':', 'EdgeColor','r');
            hold on;
            plot(x, EMG_mean, 'r', 'LineWidth', 1.5)
            %decoration
            %ylim,title,xline
            grid on;
            ylim([0 Inf])
            xline(0, 'LineWidth',1.5)
            xlabel('0 centered EMG[ms]', 'FontSize',30)
            ylabel('Amplitude[mV]', 'FontSize',30)
            set(gca, 'FontSize', 20)
            title([EMGs{ii} '-' timing_name{jj}  ' centered EMG'], 'FontSize',30)
            %save data
            if not(exist([save_NMF_fold '/' monkeyname exp_day '_standard']))
                mkdir([save_NMF_fold '/' monkeyname exp_day '_standard'])
            end
            saveas(gcf, [save_NMF_fold '/' monkeyname exp_day '_standard' '/' timing_name{jj} '_centered_' EMGs{ii} '_EMG(range=' num2str(trim_range) ')' '.png'])
            saveas(gcf, [save_NMF_fold '/' monkeyname exp_day '_standard' '/' timing_name{jj} '_centered_' EMGs{ii} '_EMG(range=' num2str(trim_range) ')' '.fig'])
            hold off;
            close all;
        end
    end
end

if save_combine_fig
    % subplotで出力する
    figure('position', [100, 100, 1200, 800])
    EMG_mean_data = cell(length(EMG_num), length(trimmed_timing_num));
    max_lim = 0;
    for ii = 1:EMG_num
        EMG_data = eval(['CEMG_' sprintf('%03d', ii)]);
        for jj = 1:trimmed_timing_num %tim2, tim3, tim4
            EMG_sel = zeros(length(tim_data), trim_sample_num*2);
            for kk = 1:trial_num
                centred_timing = tim_data(jj, kk);
                EMG_sel(kk, :) = EMG_data(1, centred_timing-trim_sample_num+1:centred_timing+trim_sample_num);
            end
            %mean & std を求める
            EMG_mean = mean(EMG_sel);
            EMG_mean_data{ii, jj} = EMG_mean;
            EMG_std = std(EMG_sel);
            if round(max(EMG_mean)) > max_lim
                max_lim = round(max(EMG_mean));
                max_lim = ceil(max_lim/10)*10;
            end
            % plot mean & std(no smoothing)
            subplot(EMG_num, trimmed_timing_num, 3*(ii-1)+jj)
            hold on;
            curve1 = EMG_mean + EMG_std;
            curve2 = EMG_mean - EMG_std;
            x2 = [x, fliplr(x)];
            inBetween = [curve1, fliplr(curve2)];
            fill(x2, inBetween, 'r', 'FaceAlpha',0.1, 'LineStyle',':', 'EdgeColor','r');
            plot(x, EMG_mean, 'r', 'LineWidth', 1.5)
            %decoration
            %ylim,title,xline
            grid on;
            xline(0, 'LineWidth',1.5)
            xlabel('elapsed time[ms]', 'FontSize',15)
            ylabel('Amplitude[mV]', 'FontSize',15)
            set(gca, 'FontSize', 15)
            title([EMGs{ii} '-' timing_name{jj}  ' centered EMG'], 'FontSize',15)
            hold off
        end
    end
    axes_handles = findobj(gcf, 'type', 'axes');
    for ii = 1:numel(axes_handles)
        ylim(axes_handles(ii), [0 max_lim])
    end
    %save figure
    if not(exist([save_NMF_fold '/' monkeyname exp_day '_standard']))
        mkdir([save_NMF_fold '/' monkeyname exp_day '_standard'])
    end
    saveas(gcf, [save_NMF_fold '/' monkeyname exp_day '_standard' '/' 'all_centered_EMG(range=' num2str(trim_range) ')' '.png'])
    saveas(gcf, [save_NMF_fold '/' monkeyname exp_day '_standard' '/' 'all_centered_EMG(range=' num2str(trim_range) ')' '.fig'])
    hold off;
    close all;
    %save data
    save([save_NMF_fold '/' monkeyname exp_day '_standard' '/' 'each_timing_mean_data(trim_range=' num2str(trim_range) 'ms).mat'], 'EMG_mean_data', 'max_lim');
end

if save_normalized_fig
    % subplotで出力する
    figure('position', [100, 100, 1200, 800])
    max_lim = 0;
    for ii = 1:EMG_num
        EMG_data = eval(['CEMG_' sprintf('%03d', ii)]);
        EMG_sel = cell(length(tim_data), 1);
        for kk = 1:trial_num
            temp_EMG = EMG_data(1, tim_data(1,kk)-trim_sample_num+1:tim_data(3,kk)+trim_sample_num);
            %high_pass
            [B,A] = butter(6, (filter_h .* 2) ./ SR, 'high');
            temp_EMG = filtfilt(B,A,temp_EMG);
            %rect
            temp_EMG = abs(temp_EMG);
            %low pass 
%             [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
%             temp_EMG = filtfilt(B,A,temp_EMG);
            EMG_sel{kk} = temp_EMG;
            if ii == 1
                timing_diviation(1,kk) = trim_sample_num/length(temp_EMG);
                timing_diviation(2,kk) = (trim_sample_num+(tim_data(2,kk)-tim_data(1,kk)))/length(temp_EMG);
                timing_diviation(3,kk) = 1-(trim_sample_num/length(temp_EMG));
            end
        end
        if ii == 1
            timing_diviation_mean = mean(timing_diviation, 2);
            timing_diviation_std = std(timing_diviation, [], 2);
            all_count = 0;
            for jj = 1:length(EMG_sel)
                all_count = all_count + length(EMG_sel{jj});
            end
            mean_sample_num = round(all_count/length(EMG_sel));
        end
        % resample & align size of data
        for jj = 1:length(EMG_sel)
            EMG_sel{jj} = resample(EMG_sel{jj}, mean_sample_num, length(EMG_sel{jj}));
        end
        all_EMG_data = cell2mat(EMG_sel);
        %plot std & mean
        EMG_mean = mean(all_EMG_data);
        EMG_std = std(all_EMG_data);
        x = linspace(0,1,length(all_EMG_data));
        %plot stack
        for jj = 1:length(EMG_sel)
            plot(x, all_EMG_data(jj,:),'LineWidth',1.3);
            hold on;
        end
        grid on;
        a = 1;
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
function [pull_timing, food_on_timing, food_off_timing, success_botton_timing] = timing_func2(timing_struct)
%【説明】
% CTLLからfood on, food off, success_bottonのタイミングを抽出する
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