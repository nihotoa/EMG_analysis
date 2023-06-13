
%{
Coded by: Naohito Ohta
Last modification : 2022/04/28
このコードの使い方：
1.カレントディレクトリをNibaliにする
2.必要な変数(monkeyname,exp_day等)を適宜変更する
以上を満たした状態で実行する
【主に変更するパラメータ】
Target_date,Target_type,EMG_type,triming_contents,pre_frame,analyze period
※EMG_typeがfilteredなら,筋電解析をマージし、その他なら,筋シナジー解析データをマージす
【課題点】
ローカル関数individual_correlationについて: ylimが[0 1]なのはなぜ([-1 1]じゃないの?)
全部の筋肉だけでなく,それぞれの筋の筋活動の相関も出す
計測した筋活動だけでなく、再構成された筋活動どうしの相関も出す
preグループとpostグループで分けて出力できるようにする
相互相関も自己相関と同様他の関数にまとめて,記述を減らす
synergy_xcorrのlegendのところを書き換える(pcNum == 2にしか対応できていない)
【やること】:
求めた相関をプロットする(EMG)
同じ系統の色を、日の経過で濃くする(or薄くする)用にプロットする
筋肉全体ではなくて、各筋肉ごとの相関係数を求める
first_dayとaverage_dayでEMG_Dataの構造が異なっているのを直す(average_dayの方に合わせる)
寄与率もstackして出す
MEMO:
文字列をfor文で使うときはcharではなくstringを使う(394行目付近を参照)
charとstringの違いがよくわかる
【注意点】
setting_Target_date = 1の時は,あらかじめDevideExperiment.mを回しておくこと
ファイル名にminimum_trialとmaximum_trialで指定した値が含まれていることを確認すること
【procedure】
pre:SYNERGYPLOT.m  DevideExperiment.m(if you set setting_Target_date as 1)
post:?(coming soon)

【課題点】
pathなどの長くなってしまうものはUIで得られるように変更する
Target_dateをUIで変更できるようにしたほうがいい
TimeNormalizedの時のH_synergyのstackの図において，xlineじゃなくてヒストグラムのデータを読み込んで使用する
（%改善で改善点を見る）
%}
clear;
%% set parameter
% necessary param
setting_Target_date = 1; %0:手動でTarget_dateを設定したとき 1:devide_infoから日付を設定したとき(生成したグラフやディレクトリの名前を決定するときに、devide_infoを使用したことをわかるようにしたい)
minimum_trial = 0; %(setting_Tareget_date = 1)のとき、restrictの条件(devide_infoディレクトリから、.matファイルを読み込むときに使用する)
max_trial = 1000;
% Target_date = [20230208 20230220 20230221 20230222 20230224 20230227]; %相関を求めたい対象の実験日を配列にまとめる
nmf_fold = 'nmf_result';
monkey_name = 'Ni';
fold_detail = '_standard_filtNO5_'; %ファイルやフォルダに含まれている文字列(形容し難い)
Target_type = 'tim3'; %どのシナジー(EMG)の相関を求めるかを選択する(filtered:nmf解析に用いるEMGの相関,TimeNormalized:時間正規化シナジー,tim1:タイミング1周りのシナジー,tim2:タイミング2周りのシナジー,tim3:タイミング3周りのシナジー)
EMG_type = 'tim3'; %Tareget_typeでfilteredを選んだ時、どのタイミングの筋電を用いるか?('tim3')
triming_contents = '_tim3_pre-300_post-100.mat'; %Target_typeがfilteredの時に、どのEMGを使用するか(tim1周り:_tim1_pre-400_post200.mat,tim2周り:_tim2_pre-200_post-300.mat tim3周り:_tim3_pre-300_post-100.mat TimeNormalized:_TimeNormalized.mat )
line_wide=1.2; %change the width of lineT
analyze_period = 'pre'; %choose each 'pre' or 'post' or 'all'(all is used when you want to display all data (include pre & post) in one figure)※x_corrの解析をする時は'all'にする
pre_frame = 300; %図にxlineを引くために,pre_frameを設定する(tim3:300, tim1:400)
save_xcorr = 1; %(これを使用するときは必ずanalyze_period = 'all'とすること)x_corrを計算し、データや図を保存するかどうか?(デバッグの時に毎回この部分が実行されるのが邪魔なので,簡易的にオプションにした)
criterion_day = 'surgery_day'; %実験の基準日をどの日に設定するか　'pre_first'/'surgery_day'
correlation_type = 'pre_limited'; %【analyze_period = allの時】相関係数をどうやって求めるか？(pre_all:preデータ全体の平均,pre_limited:preの中でも限られたデータの平均(手術前n日分))
pre_range = 5; %correlation_typeがpre_limitedのとき、術前何日分までを考慮するか？
label_FontSize = 20;

% EMG_analysis
 %stack(or average) EMG analysis
save_movie = 0; %筋電解析の変遷を動画ファイルとして保存するかどうか
reference_day = 20220530; %please fill in sergery day (this is used to divide all data into two groups (pre and post))
video_framerate = 3; %stackEMGの動画を再生するときのフレームレート


%synergy_analysis
pcNum = [2]; %使用する筋シナジーの個数(Target_typeがfilteredではない時)
align_type = 'synergy_W'; %日ごとの筋シナジーを整合するときに、どっちのシナジーに合わせるか？(synergy_W,synergy_H)
save_figure = 1; %syenrgy_W,H,VAFのグラフなどを保存するかどうか

%used muscle 
EMGs=cell(16,1) ;
EMGs{1,1}= 'EDC-A';
EMGs{2,1}= 'EDC-B';
EMGs{3,1}= 'ED23';
EMGs{4,1}= 'ED45';
EMGs{5,1}= 'ECR';
EMGs{6,1}= 'ECU';
EMGs{7,1}= 'BRD';
EMGs{8,1}= 'EPL-B'; %untiledのところでも同じ間違いをしているので、そっちを修正しないとこっちを修正できない
EMGs{9,1}= 'FDS-A';
EMGs{10,1}= 'FDS-B';
EMGs{11,1}= 'FDP';
EMGs{12,1}= 'FCR';
EMGs{13,1}= 'FCU';
EMGs{14,1}= 'FPL';
EMGs{15,1}= 'Biceps';
EMGs{16,1}= 'Triceps';
EMG_num = 16;

%used muscle name_detail
EMGs_detail=cell(16,1) ;
EMGs_detail{1,1}= '総指伸筋-近位';
EMGs_detail{2,1}= '総指伸筋-遠位';
EMGs_detail{3,1}= '2,3指伸筋';
EMGs_detail{4,1}= '4,5指伸筋';
EMGs_detail{5,1}= '橈側手根筋';
EMGs_detail{6,1}= '尺側手根筋';
EMGs_detail{7,1}= '腕橈骨筋';
EMGs_detail{8,1}= '長母指伸筋'; %untiledのところでも同じ間違いをしているので、そっちを修正しないとこっちを修正できない
EMGs_detail{9,1}= '浅指屈筋-近位';
EMGs_detail{10,1}= '浅指屈筋-遠位';
EMGs_detail{11,1}= '深指屈筋';
EMGs_detail{12,1}= '橈側手根屈筋';
EMGs_detail{13,1}= '尺側手根屈筋';
EMGs_detail{14,1}= '長母指屈筋';
EMGs_detail{15,1}= '上腕二頭筋';
EMGs_detail{16,1}= '上腕三頭筋';


%% code section
%(setting_Target_date == 1のとき)、手動で設定したTarget_dateとdevide_infoをマージして、両者を満たす
%新しいTarget_dateを作る
if setting_Target_date == 1
    load('all_day_trial.mat', 'trial_day'); %全ての実験日の日付リストをロードする
    Target_date = GenerateTargetDate(trial_day ,analyze_period,minimum_trial,max_trial);
end

%必要な変数を作成
exp_file_num = num2str(length(Target_date));
exp_start = num2str(Target_date(1));
exp_end = num2str(Target_date(end));      
save_dir = ['control_data/' EMG_type '/' analyze_period '(' exp_start 'to' exp_end '_' exp_file_num ')']; %path of control data (this is to be concise this code)

%日ごとの筋シナジー(もしくはEMG)データを一つにまとめる
%↓改善(if文の中身が冗長)
if strcmp(Target_type,'filtered') %解析対象がEMGの時
    for ii = 1:length(Target_date)
        for jj = 1:EMG_num
            %改善(path名長すぎ，uiでgetできるようにする)
            load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) '_standard/' EMGs{jj,1} '(uV)' triming_contents])
            EMG_Data_sel{jj,1} = Data;
        end
        EMG_Data{ii,1} = EMG_Data_sel;
    end
elseif  strcmp(Target_type,'tim1')
    for ii = 1:length(Target_date)
        %↓この操作を他のTarget_typeの時にも追加する or この条件分岐の前にこの操作を行う
        if ii == 1
            load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim1' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'],'TargetName') %初日データのみ、空間シナジーのプロットの際の筋の並びのために必要
            x = categorical(TargetName');
        end
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim1' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
        %↓寄与率をまとめる
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim1' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'])
        all_r2{ii,1} = r2;
    end
elseif  strcmp(Target_type,'TimeNormalized') 
    for ii = 1:length(Target_date)
        %↓この操作を他のTarget_typeの時にも追加する or この条件分岐の前にこの操作を行う
        if ii == 1
            load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'TimeNormalized_task' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'],'TargetName') %初日データのみ、空間シナジーのプロットの際の筋の並びのために必要
            x = categorical(TargetName');
        end
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'TimeNormalized_task' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
        %↓寄与率をまとめる
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'TimeNormalized_task' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'])
        all_r2{ii,1} = r2;
    end
elseif  strcmp(Target_type,'tim2') 
    for ii = 1:length(Target_date)
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim2' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
    end
elseif  strcmp(Target_type,'tim3') 
    for ii = 1:length(Target_date)
        %↓この操作を他のTarget_typeの時にも追加する or この条件分岐の前にこの操作を行う
        if ii == 1
            load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim3' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'],'TargetName') %初日データのみ、空間シナジーのプロットの際の筋の並びのために必要
            x = categorical(TargetName');
        end
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim3' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
        %↓寄与率をまとめる
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim3' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'])
        all_r2{ii,1} = r2;
    end
end

if strcmp(Target_type,'filtered') %筋電ならば    
    if strcmp(analyze_period,'all') %pre post全部ひっくるめて解析するとき
        %split 'EMG_Data' into pre and post Data
        [pre_date,post_date,Elapsed_term,surgery_day_Elapsed,pre_EMG_Data,post_EMG_Data] =  DevideEMG(Target_date,reference_day,criterion_day,EMG_Data);
        
        %calculate and display all of xcorr
        %↓改善(関数にするべき)
        if save_xcorr == 1 
            %Correlation coefficient for individual data    
            h = figure;    
            h.WindowState = 'maximized';
            [EMG_save_dir, all_reference_data,x1,x2,y] = individual_correlation(EMG_num,correlation_type,pre_range,pre_date,pre_EMG_Data,EMG_Data,Elapsed_term,Target_date,surgery_day_Elapsed,EMGs,save_dir);
            close all;
            %↓(x_corr coeficcient vs eachEMG)各EMGに対する相互相関
            for ii = 1:EMG_num %reference_dataの方
                reference_data = all_reference_data{ii,1};
                h = figure;    
                h.WindowState = 'maximized';
                clear all_xcorr
                all_xcorr = cell(EMG_num,2);
                for jj = 1:EMG_num %vs reference_dataの方
                    clear correlation_value
                    correlation_value = zeros(length(Elapsed_term),1);
                    for kk = 1:length(EMG_Data) %日付分だけループ
                        vs_data = EMG_Data{kk,1}{jj,1};
                        R_array = xcorr(reference_data - mean(reference_data),vs_data - mean(vs_data),'coef'); %正規化とx軸の設定(lagsでx軸を管理し、xcorr()の中で正規化を行っている
                        R_xcorr = R_array(length(reference_data)+1);
                        %stem(lags,c) %離散信号のプロット、確認用だから本番では使用しないと思われる
                        correlation_value(kk) = R_xcorr;
                    end
                    subplot(4,4,jj)
                    hold on;
                    %xline(surgery_day_Elapsed,'--r','surgery day');
                    ylim([-1 1]); grid on;
                    xlim([Elapsed_term(1) Elapsed_term(end)])
                    title(EMGs{jj,1},'FontSize',25)
                    fi1 = fill(x1, y, 'k');
                    fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
                    fi1.EdgeColor = 'none';            % remove the line around the filled area
                    plot(Elapsed_term,correlation_value,'LineWidth',1.3);
                    fi2 = fill(x2,y,'k','LineWidth',1.3);
                    fi2.FaceColor = [1 1 1];       % make the filled area
                    hold off
                    all_xcorr{jj,1} = EMGs{jj};
                    all_xcorr{jj,2} = correlation_value;
                end
                saveas(gcf,[EMG_save_dir '/corration/x_correlation(vs ' EMGs{ii} ').png']);
                %↓compare_diffに保存(CompareDiff.mで使用する)
                save(['compare_diff/' 'x_corr(vs ' EMGs{ii} ').mat'],'all_xcorr');
                close all
            end
        else
            EMG_save_dir = [save_dir '/analyzed_EMG'];
        end
        
        %平均+標準偏差の筋電の図
        AveregeEMG(pre_EMG_Data,post_EMG_Data,EMG_num,EMGs,pre_frame,line_wide,EMG_save_dir)

        %筋電の図をstackして図示する + videoにして保存する
        figure('Position',[0 0 1280 720]) 
        for ii = 1:EMG_num
            subplot(4,4,ii)
            hold on;
            
            %plot & extract pre_data
            [frames] = VideoCreate(pre_date,pre_frame,'pre',pre_EMG_Data,ii,EMGs,save_movie);
            sel_frames{(2 * ii) - 1, 1} = frames;
            
            %plot & extract post_data
            [frames] = VideoCreate(post_date,pre_frame,'post',post_EMG_Data,ii,EMGs,save_movie);
            sel_frames{2 * ii, 1} = frames;
        end
        % save_videos
        if save_movie == 1
            stack_save_dir = [EMG_save_dir '/stack'];
            SaveVideo(sel_frames,EMG_num,stack_save_dir,video_framerate)
        end
        %save figure(下に図の保存に関する処理を記述)
        stack_save_dir = [ EMG_save_dir '/stack'];
        if not(exist(stack_save_dir))
            mkdir(stack_save_dir)
        end
        saveas(gcf,[stack_save_dir '/' 'around_' EMG_type '_stack(EMG).png'])
        close all;
    elseif or(strcmp(analyze_period,'pre'),strcmp(analyze_period,'post')) 
        if save_xcorr == 1
            h = figure;    
            h.WindowState = 'maximized';
            for ii = 1:EMG_num
                %reference_dataの作成
                clear reference_data %データに上書きできないので、毎回reference_dataをするクリアする必要がある
                for jj = 1:length(Target_date)
                    reference_data{jj,1} = EMG_Data{jj,1}{ii,:};
                end
                reference_data = mean(cell2mat(reference_data));
                for jj = 1:length(Target_date)
                   R = corrcoef(reference_data,EMG_Data{jj,1}{ii,:});
                   correlation_value(jj,1) = R(1,2);
                end
                subplot(4,4,ii)
                hold on;
                plot(correlation_value)
                xticks([1:length(Target_date)])
                ylim([0 1]);
                title(EMGs{ii,1})
                hold off
            end
        %save figure
            correlation_save_dir = [[save_dir '/analyzed_EMG/corration']];
            if not(exist(correlation_save_dir))
                mkdir(correlation_save_dir);
            end
            saveas(gcf,[correlation_save_dir '/filtered_EMG_individual_correlation(vs average_day).png']);
            close all;
        end
        %筋電の図をstackして図示する
        figure('Position',[0 0 1280 720]) 
        for ii = 1:EMG_num
            for jj = 1:length(Target_date)
                subplot(4,4,ii)
                hold on;
                p_color = ((40+((215/length(Target_date))*jj)) / 255) - 0.00001;
                plot(EMG_Data{jj,1}{ii,:},'color',[p_color,0,0],'LineWidth',line_wide);
            end
            ylim([0 2])
            grid on;
            if strcmp(EMG_type, 'TimeNormalized')
                % 中央値とヒストグラムの追加
            else
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',line_wide);
            end
            title([EMGs{ii,1} '(' EMGs_detail{ii,1} ')'],'FontSize',18);
            hold off;
        end
        EMG_save_dir = [save_dir '/analyzed_EMG'];
        mkdir([EMG_save_dir '/stack']);
        saveas(gcf,[ EMG_save_dir '/stack/around_' EMG_type '_stack.png']);
        close all;
        %平均+標準偏差の筋電の図
        figure('Position', [0 0 1280 720]);
        for ii = 1:EMG_num
            for jj = 1:length(Target_date)
                reference_sel{jj,1} = EMG_Data{jj,1}{ii,:}; %全日分の、ある筋肉からのデータを一つにまとめる
            end
            EMG_mean = mean(cell2mat(reference_sel));
            EMG_std = std(cell2mat(reference_sel));
            subplot(4,4,ii)
            hold on;
            grid on;
            plot(EMG_mean,'LineWidth',line_wide);
            title(EMGs{ii,1},'FontSize',24);
            ar1=area(transpose([EMG_mean-EMG_std;EMG_std+EMG_std]));
            set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r')
            set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') 
            ylim([0 2])
            if strcmp(EMG_type, 'TimeNormalized')
                % 中央値とヒストグラムの追加
            else
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',line_wide);
            end
            hold off;
        end   
        %save figure & data
        if not(exist([ EMG_save_dir '/average']))
            mkdir([ EMG_save_dir '/average'])
        end
        saveas(gcf,[ EMG_save_dir '/average/around_' EMG_type '_average.png']);
        close all;
    end
   
else %筋電じゃない(筋シナジー)なら
    %Wに関しての相関(日毎にbarを並べる(その前に、シナジーを揃える作業が必要)& 平均シナジーのプロットと標準偏差 & 相関係数を求める)
    %Hに関しての相関(平均を取って、標準偏差を背景に撮る & 積み重ねた図(凡例をつける) & 相関係数を求める)
    %再構成されたEMG(WH)の相関(計測したEMGの相関係数と同じ容量でやる)
    %W,Hともに大きさが日によって違うので、割合で比較できるようにあらかじめ平均で正規化する→正規化したものと正規化していないもので変数を分けたほうがいいかもしれない
    
    %use_Wの作成(正規化含む)
    for ii = pcNum(1,1) : pcNum(1,end)
        for jj = 1:length(Target_date)
            use_W{ii,1}{jj,1} = all_W{jj,1}{ii,1};
        end
        %use_Wを正規化する
        for jj = 1:length(Target_date)
            for kk = 1:ii
                average_value = mean(use_W{ii,1}{jj,1}(:,kk)); %平均で割るために、平均を算出する
                use_W{ii,1}{jj,1}(:,kk) = use_W{ii,1}{jj,1}(:,kk)/average_value;
            end
        end
    end
    %use_Hの作成(正規化含む)
    for tt = pcNum
        for jj = 1:length(Target_date)
            use_H{tt,1}{jj,1} = all_H{jj,1}{tt,1};
        end
    end
    %use_Hを平均値で正規化
    for tt = pcNum
        for jj = 1:length(Target_date)
            for kk = 1 : tt
                average_value = mean(use_H{tt,1}{jj,1}(kk,:));
                use_H{tt,1}{jj,1}(kk,:) = use_H{tt,1}{jj,1}(kk,:)/average_value;
            end
        end
    end
    %この下を変える必要がある(synergyの並び替え)
    if strcmp(align_type,'synergy_W')
        for ii = pcNum(1,1) : pcNum(1,end)
            align_use_W = use_W; %k_arrの作成用にuse_wを複製する
            k_arr{ii,1} = zeros(ii,length(Target_date)-1);
            for kk = 1:ii %初日のシナジー数
                eval(['synergy' num2str(kk) ' = align_use_W{ii,1}{1,1}(:,kk);']) %初日のsynergy1を全体のsynergy1とする
                e_value_sel = zeros(length(Target_date),2);
                
                for ll = 2:length(Target_date)
                    for mm = 1:ii
                        e_value_ind = sum(eval(['abs(align_use_W{ii,1}{ll,1}(:,mm) - synergy' num2str(kk) ')'])); %indはindividualの意味
                        e_value_sel(ll,mm) = e_value_ind; 
                    end
                    [~,I] = min(e_value_sel(ll,:));
                    align_use_W{ii,1}{ll,1}(:,I) = 1000;
                    k_arr{ii,1}(kk,ll-1) = I;
                end
            end   
        end
    %↓いらない(W_synergyのalignだけで十分，必要ができたら新たに作ればいい)
    elseif strcmp(align_type,'synergy_H')     
        for ii = pcNum
            for kk = 1:ii
                eval(['synergy' num2str(kk) ' = use_H{ii,1}{1,1}(kk,:);']) %初日のシナジーkk
                for ll = 1:length(Target_date)-1
                    for mm = 1:ii
                        e_value_ind = sum(eval(['abs(use_H{ii,1}{ll+1,1}(mm,:) - synergy' num2str(kk) ')'])); %indはindividualの意味
                        e_value_sel(ll,mm) = e_value_ind; 
                    end
                end
                e_value{ii,kk} = e_value_sel; %各シナジー数ごとのe_value_selを格納。次の追加操作のループで使用する
                for nn = 1:length(Target_date)-1
                    [~,I] = min(e_value_sel(nn,:)); %初日のシナジーkkがnn+1日目のどのシナジーに対応しているか？(Iは、最小要素の格納されている配列)
                    %最小値と2番目の最小値の差がほとんどない時(閾値を定める)、次の行の操作を保留するor全ての操作を終えた後に要素が重複している行に対して追加の操作をする
                    eval(['synergy_relation_pcNum' num2str(ii) '(nn,kk) = I;'])
                end
            end   
        end
         %↓全ての操作を終えた後に要素が重複している行に対して追加の操作をする(現状,synergy_Hで比較すると、何のトラブルもないので、追加の処理は入れていない)
    end
 %並べ替えデータ(synergy_relation_pcNum)を基に、それぞれのシナジー(W,H)の重ね合わせと、平均を図にする
  %Wについてのプロット(重ね合わせ)
    %barのグループ作成のために行列の形を変える
    for tt = pcNum %後付けでforループ作ったのでなんとなくttにした
        for ii = 1:tt %iiはシナジ－番号
            for jj=1:length(Target_date)
                if jj == 1
                    sorted_use_W{tt,1}{ii,1}{1,jj}(:,1) = use_W{tt,1}{jj,1}(:,ii); %tt:シナジー数,jj:何日目か? ii:シナジー番号
                else
                    sorted_use_W{tt,1}{ii,1}{1,jj}(:,1) = use_W{tt,1}{jj,1}(:, k_arr{tt}(ii, jj-1));
                end
            end
        end
    end
    % synergy_Hの並び替え
    for tt = pcNum
        for ii = 1:tt
            for jj = 1:length(Target_date)
                if jj == 1 %初日
                    sorted_use_H{tt,1}{ii,1}{jj,1} = use_H{tt}{jj}(ii,:);
                else
                    sorted_use_H{tt,1}{ii,1}{jj,1} = use_H{tt}{jj}(k_arr{tt}(ii, jj-1),:); 
                end
            end
        end
    end

    %}
    data_types = ["synergy_W","synergy_H","analyzed_EMG","recounst_EMG","r2"];
    HowToDisps = ["average","stack"];

    % データや図をセーブするディレクトリの構築
    for data_type = data_types
        if strcmp(data_type,'r2')
            data_type = char(data_type);
            synergy_save_dir = [save_dir '/' data_type '/stack'];
            if not(exist(synergy_save_dir))
                mkdir([save_dir '/' data_type '/stack'])
            end
            continue;
        end
            for HowToDisp = HowToDisps
                data_type = char(data_type);
                HowToDisp = char(HowToDisp);
                synergy_save_dir = [save_dir '/' data_type '/' HowToDisp];
                if not(exist(synergy_save_dir))
                    mkdir([save_dir '/' data_type '/' HowToDisp])
                end
            end        
    end
    
    %グループを作ってプロットする(W_synergyのプロット)
    if save_figure == 1
        for tt = pcNum
            figure('Position', [0 0 1280 720]);
            for ii = 1:tt
                synergy_portion = cell2mat(sorted_use_W{tt,1}{ii,1});
                subplot(tt,1,ii); 
                b = bar(x,synergy_portion,'FaceColor','flat');
                for k = 1:size(synergy_portion,2)
                    p_color = ((40+((215/length(Target_date))*k)) / 255) - 0.00001;
                    b(k).CData = [p_color 0 0];
                end
                ylim([0 4]);
                title(['synergy' num2str(ii)],'FontSize',25);

                if tt==2 %シナジー数が2の時
                    [row,~] = size(synergy_portion);
                    for jj = 1:row
                        eval(['W_synergy' num2str(ii) '{jj,1} = EMGs{jj};']);
                        eval(['W_synergy' num2str(ii) '{jj,2} = synergy_portion(jj,:);']);
                    end
                end
            end
            saveas(gcf,[ save_dir '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ').png']);
            saveas(gcf,[ save_dir '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ').fig']);
            if tt == 2
                save('compare_diff/W_synergy.mat','W_synergy1','W_synergy2')
            end
            close all;
        end
        % 極座標の図で図示する
        [pre_date,post_date] = DevideEMG(Target_date,reference_day,criterion_day);
        for tt = pcNum %シナジー数でのループ　
            for ii = 1:tt %各シナジーのループ　
                figure('Position',[100,100,1200,800]);
                synergy_portion = cell2mat(sorted_use_W{tt,1}{ii,1});
                for k = 1:size(synergy_portion,2) %dayでループ
                    %色の決定
                    p_color = ((40+((215/length(Target_date))*k)) / 255) - 0.00001;
                    %極座標のプロット
                    if k == 1
                        theta = linspace(0, 2*pi, EMG_num+1);  % 角度の配列(16だと0度と３６０度で値がバッティングしてしまうため)
                        labels = TargetName; %値とラベルがあっているかわからないから後で確認する
                        labels{end+1} = labels{1}; %閉じるため 
                    end
                    plotData = synergy_portion(:, k);% 値の配列
                    plotData(end+1) = plotData(1); %閉じるため
                    switch analyze_period
                        case 'all'
                            pre_p_color = ((40+((215/length(pre_date))*k)) / 255) - 0.00001;
                            post_p_color = ((40+((215/length(post_date))*(k-length(pre_date)))) / 255) - 0.00001;
                            if any(pre_date == Target_date(k))
                                
                                p = polarplot(theta, plotData, '-', 'LineWidth', line_wide,'color',[pre_p_color,0,0]);  % プロット
                            elseif any(post_date == Target_date(k))
                                p = polarplot(theta, plotData, '-', 'LineWidth', line_wide,'color',[0,1 - post_p_color,1]);  % プロット
                            end
                        otherwise
                            %色の決定
                            p_color = ((40+((215/length(Target_date))*k)) / 255) - 0.00001;
                            p = polarplot(theta, plotData, '-', 'LineWidth', line_wide,'color',[p_color,0,0]);  % プロット
                    end
                    if k == 1
                        thetaticks(rad2deg(theta));  % 角度軸の目盛りを設定
                        thetaticklabels(labels);     % 角度軸のラベルを設定
                        hold on;
                    end
                end
                hold off;
                %図の装飾
                % ラベルのフォントサイズと色を変更
                ax = gca;                        % 現在の軸オブジェクトを取得
                ax.FontSize = label_FontSize;  % ラベルのフォントサイズを設定
                max_factor = max(max(synergy_portion));
                rlim([0 ceil(max_factor)]) %極座標のrの範囲(ceilは繰り上げ)
                saveas(gcf,[ save_dir '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ')_PolarFigure pcNum = ' num2str(tt) ' synergy' num2str(ii) '.png']);
                saveas(gcf,[ save_dir '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ')_PolarFigure pcNum = ' num2str(tt) ' synergy' num2str(ii) '.fig']);
                close all;
            end
        end
        
        %r2をまとめた図を作る
        for ii = 1:length(Target_date)
            p_color = ((40+((215/length(Target_date))*ii)) / 255) - 0.00001; %p_colorは1未満でないといけないので,テキトーに引く
            plot(all_r2{ii,1},'color',[p_color,0,0],'LineWidth',line_wide)
            ylim([0 1])
            hold on;
        end
        plot(shuffle.r2,'Color',[0,0,0],'LineWidth',line_wide)
        plot([0 EMG_num + 1],[0.8 0.8],'color','b','LineWidth',line_wide);
        h_axes = gca;
        grid on;
        h_axes.XAxis.FontSize = 13;
        h_axes.YAxis.FontSize = 13;
        xlim([0 EMG_num]);
%         title([Target_type ' R^2']);
        saveas(gcf,[save_dir '/r2/stack/' Target_type '_r2.png'])
        close all;
        % 重ね合わせの図をプロットする(synergy_Hのプロット)
        for ii = pcNum
            figure('Position', [0 0 640 640]);
            for kk = 1:ii %初日のシナジーkk
                for jj = 1:length(Target_date) 
                    subplot(ii,1,kk)
                    hold on;
                    p_color = ((40+((215/length(Target_date))*jj)) / 255) - 0.00001;
                    plot(sorted_use_H{ii}{kk}{jj}(1,:),'color',[p_color,0,0],'LineWidth',line_wide)
                end
                ylim([0 6])
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',line_wide);
                title(['synergy' num2str(kk)],'FontSize',25)
            end
            hold off;
            saveas(gcf,[save_dir '/synergy_H/stack/all_H(' Target_type '_' 'pcNum =' num2str(ii) ').png']);
            close all;
        end
    end
   %x_corrの計算
   %↓改善(長すぎるので，関数を別で定義して簡潔にする)
   if save_xcorr == 1
        [pre_date,post_date,Elapsed_term,surgery_day_Elapsed] = DevideSynergy(Target_date,reference_day,criterion_day);
        switch correlation_type
            case 'pre_limited'
                control_days_index = [length(pre_date) - (pre_range-1):length(pre_date)];
            case 'pre_all'
                control_days_index = [1 : llength(pre_date)];
        end
        %synergyHについてのx_corr
        for tt = pcNum 
            for ii = 1:tt %tt個のシナジー数におけるシナジーttの解析
                figure('Position', [100 100 1200 800]);
                %コントロールデータ(reference_dataの作成)
                reference_data = mean(cell2mat(sorted_use_H{tt}{ii}(control_days_index(1):control_days_index(end))));
                clear all_xcorr
                all_xcorr = cell(tt,2);
                for jj = 1:tt %vs reference_dataの方
                    clear correlation_value
                    correlation_value = zeros(length(Elapsed_term),1);
                    for kk = 1:length(Elapsed_term) %日付分だけループ
                        vs_data = sorted_use_H{tt,1}{jj,1}{kk};
                        R_array = xcorr(reference_data - mean(reference_data),vs_data - mean(vs_data),'coef'); %正規化とx軸の設定(lagsでx軸を管理し、xcorr()の中で正規化を行っている
                        R_xcorr = R_array(length(reference_data)+1);
                        %stem(lags,c) %離散信号のプロット、確認用だから本番では使用しないと思われる
                        correlation_value(kk) = R_xcorr;
                    end
                    hold on;
                    xnoT = (0: min(Elapsed_term(Elapsed_term > 0)));
                    x1 = [Elapsed_term(control_days_index(1)) Elapsed_term(control_days_index(end)) Elapsed_term(control_days_index(end)) Elapsed_term(control_days_index(1))];
                    x2 = [0 xnoT(end) xnoT(end) 0];
                    y = [-1 -1 1 1];
                    %xline(surgery_day_Elapsed,'--r','surgery day');
                    ylim([-1 1]); grid on;
                    xlim([Elapsed_term(1) Elapsed_term(end)])
                    title(['vs pre-synergy' num2str(ii)],'FontSize',25)
                    fi1 = fill(x1, y, 'k');
                    fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
                    fi1.EdgeColor = 'none';            % remove the line around the filled area            
                    plot(Elapsed_term,correlation_value,'LineWidth',1.3);
                    if jj == tt
                        fi2 = fill(x2,y,'k','LineWidth',1.3);
                        fi2.FaceColor = [1 1 1];       % make the filled area
                        legend('control-data','synergy1','synergy2','task-disable','Location','east','FontSize',20)
                        h_axes = gca;
                        h_axes.XAxis.FontSize = 20;
                        h_axes.YAxis.FontSize = 20;
                        hold off
                        %図の保存
                        synergy_xcorr_save_dir = [save_dir '/synergy_xcorr/H_synergy'];
                        if not(exist(synergy_xcorr_save_dir))
                            mkdir(synergy_xcorr_save_dir)
                        end
                        saveas(gcf,[synergy_xcorr_save_dir '/H_xcorr(pcNum = ' num2str(tt) ' vs_synergy' num2str(ii) ').png']);
                        saveas(gcf,[synergy_xcorr_save_dir '/H_xcorr(pcNum = ' num2str(tt) ' vs_synergy' num2str(ii) ').fig']);
                        close all;
                    end
                    all_xcorr{jj,1} = ['vs synergy' num2str(ii) '-control'];
                    all_xcorr{jj,2} = correlation_value;
                end
            end
        end

        %synergy_Wのx_corr
        for tt = pcNum 
            for ii = 1:tt %tt個のシナジー数におけるシナジーttの解析
                figure('Position', [100 100 1200 800]);
                %コントロールデータ(reference_dataの作成)
                reference_data = mean(cell2mat(sorted_use_W{tt}{ii}(control_days_index(1):control_days_index(end))),2);
                clear all_xcorr
                all_xcorr = cell(tt,2);
                for jj = 1:tt %vs reference_dataの方
                    clear correlation_value
                    correlation_value = zeros(length(Elapsed_term),1);
                    for kk = 1:length(Elapsed_term) %日付分だけループ
                        vs_data = sorted_use_W{tt,1}{jj,1}{kk};
                        R_xcorr = corrcoef(reference_data, vs_data);
                        correlation_value(kk) = R_xcorr(2,1);
                    end
                    if jj == 1
                        hold on;
                        xnoT = (0: min(Elapsed_term(Elapsed_term > 0)));
                        x1 = [Elapsed_term(control_days_index(1)) Elapsed_term(control_days_index(end)) Elapsed_term(control_days_index(end)) Elapsed_term(control_days_index(1))];
                        x2 = [0 xnoT(end) xnoT(end) 0];
                        y = [-1 -1 1 1];
                        %xline(surgery_day_Elapsed,'--r','surgery day');
                        ylim([-1 1]); grid on;
                        xlim([Elapsed_term(1) Elapsed_term(end)])
                        title(['synergy' num2str(ii)],'FontSize',40)
                        fi1 = fill(x1, y, 'k');
                        fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
                        fi1.EdgeColor = 'none';            % remove the line around the filled area
                    end
                    plot(Elapsed_term,correlation_value,'LineWidth', 2);
                    if jj == tt
                        h_axes = gca;
                        h_axes.XAxis.FontSize = 40;
                        h_axes.YAxis.FontSize = 40;
                        fi2 = fill(x2,y,'k','LineWidth',1.3);
                        fi2.FaceColor = [1 1 1];       % make the filled area
                        legend('control-data','synergy1','synergy2','task-disable','Location','east','FontSize',40)
                        hold off
                        %図の保存
                        synergy_xcorr_save_dir = [save_dir '/synergy_xcorr/W_synergy'];
                        if not(exist(synergy_xcorr_save_dir))
                            mkdir(synergy_xcorr_save_dir)
                        end
                        saveas(gcf,[synergy_xcorr_save_dir '/W_xcorr(pcNum = ' num2str(tt) ' vs_synergy' num2str(ii) ').png']);
                        saveas(gcf,[synergy_xcorr_save_dir '/W_xcorr(pcNum = ' num2str(tt) ' vs_synergy' num2str(ii) ').fig']);
                        close all;
                    end
                    all_xcorr{jj,1} = ['vs synergy' num2str(ii) '-control'];
                    all_xcorr{jj,2} = correlation_value;
                end
            end
        end
   end
end


 
%% define function to be used in this code
%function1
function Target_date = GenerateTargetDate(Target_date,analyze_period,minimum_trial,max_trial)
    try
        %↓実験日ではないが、トライアルデータを持っている日付を除去する
        removed_day = [20220301, 20220324, 20220414 20220607]; 
        load(['devide_info/' analyze_period '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat'])
        Target_date = transpose(intersect(Target_date,trial_day));
        Target_date = setdiff(Target_date, removed_day);
    catch
        error([analyze_period '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat が存在しません.DevideExperimet.mを実行して、ファイルを作成してください'])
    end
end

%function2
function [pre_date,post_date,Elapsed_term,surgery_day_Elapsed,pre_EMG_Data,post_EMG_Data] = DevideEMG(Target_date,reference_day,criterion_day,EMG_Data)
    %devide all data into two groups(pre and post)
    pre_date = Target_date(Target_date < reference_day);
    post_date = Target_date(Target_date > reference_day);
    % devide all EMG_data into two groups
    switch nargin
        case 3
            %do nothing
        case 4 %EMG_Dataがあるとき
            pre_EMG_Data = EMG_Data(1:length(pre_date));
            post_EMG_Data = EMG_Data(1+length(pre_date):end);
    end

    %Calculate the number of days elapsed from the first experiment day
    Elapsed_term = zeros(length(Target_date),1);
    switch criterion_day
        case 'pre_first'
            for ii = 1:length(Target_date)
                if ii == 1 %first_day
                    first_day = trans_calrender(Target_date(ii));
                    Elapsed_term(ii) = 0;
                else
                    Elapsed_day = CountElapsedDate(Target_date(ii),first_day);
                    Elapsed_term(ii) = caldays(Elapsed_day);
                end
            end
            surgery_day_Elapsed = caldays(CountElapsedDate(reference_day,first_day));
        case 'surgery_day'
            surgery_day = trans_calrender(reference_day);
            for ii = 1:length(Target_date)
                Elapsed_day = CountElapsedDate(Target_date(ii),surgery_day);
                Elapsed_term(ii) = caldays(Elapsed_day);
            end
            surgery_day_Elapsed = 0;
    end
end

%function3
function [EMG_save_dir,all_reference_data,x1,x2,y] = individual_correlation(EMG_num,correlation_type,pre_range,pre_date,pre_EMG_Data,EMG_Data,Elapsed_term,Target_date,surgery_day_Elapsed,EMGs,save_dir)
    for ii = 1:EMG_num
        %reference_dataの作成
        clear reference_data %データに上書きできないので、毎回(対象の筋電毎に)reference_dataをするクリアする必要がある
        if strcmp(correlation_type,'pre_all')
            for jj = 1:length(pre_date)
                reference_data{jj,1} = pre_EMG_Data{jj,1}{ii,:};
            end
        elseif strcmp(correlation_type,'pre_limited')
            for jj = 1:pre_range
                reference_data{jj,1} = pre_EMG_Data{(end-pre_range)+jj,1}{ii,:};
            end
        end
        reference_data = mean(cell2mat(reference_data));
        %↓xcorrでreference_dataを使用したいので、ここでまとめて、出力する
        all_reference_data{ii,1} = reference_data;
        
        correlation_value = zeros(length(Elapsed_term),1);
        for jj = 1:length(Target_date)
           R = corrcoef(reference_data,EMG_Data{jj,1}{ii,:});
           correlation_value(jj) = R(1,2);
        end
        
        switch correlation_type
            case 'pre_limited'
                temp = Elapsed_term(Elapsed_term < 0);
                control_days = temp(end-(pre_range-1):end);
            case 'pre_all'
                control_days = Elapsed_term(Elapsed_term < 0);
        end
        xnoT = (0: min(Elapsed_term(Elapsed_term > 0)));
        x1 = [control_days(1) control_days(end) control_days(end) control_days(1)];
        x2 = [0 xnoT(end) xnoT(end) 0];
        y = [-1 -1 1 1];
        %plot correlation data
        subplot(4,4,ii)
        hold on;
        %xline(surgery_day_Elapsed,'--r','surgery day');
        ylim([-1 1]); grid on;
        xlim([Elapsed_term(1) Elapsed_term(end)])
        title(EMGs{ii,1},'FontSize',25)
        fi1 = fill(x1, y, 'k');
        fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
        fi1.EdgeColor = 'none';            % remove the line around the filled area
        plot(Elapsed_term,correlation_value,'LineWidth',1.3);
        fi2 = fill(x2,y,'k','LineWidth',1.3);
        fi2.FaceColor = [1 1 1];       % make the filled area
        hold off
        % all_correlaton_value{ii} = correlation_value;
    end
        
    %save figure
     %setting directly to save
    EMG_save_dir = [save_dir '/analyzed_EMG'];
    correlation_save_dir = [EMG_save_dir '/corration'];
    if not(exist(correlation_save_dir))
        mkdir(correlation_save_dir);
    end
    
    if strcmp(correlation_type,'pre_all')
        saveas(gcf,[correlation_save_dir '/filtered_EMG_individual_correlation(vs pre_average(include' num2str(pre_range) ' days before)).png']);
    elseif strcmp(correlation_type,'pre_limited')
        saveas(gcf,[correlation_save_dir '/filtered_EMG_individual_correlation(vs pre_average(all)).png']);
    end
    
    %save_data
%     if not(exist('compare_diff'))
%         mkdir('compare_diff');
%     end
%     save('compare_diff/correlation_value.mat','all_correlaton_value')
end

%funtion4(DevideEMGとかなり似通っている)
function [pre_date,post_date,Elapsed_term,surgery_day_Elapsed] = DevideSynergy(Target_date,reference_day,criterion_day)
    %devide all data into two groups(pre and post)
    pre_date = Target_date(Target_date < reference_day);
    post_date = Target_date(Target_date > reference_day);
    % devide all EMG_data into two groups
%     pre_EMG_Data = EMG_Data(1:length(pre_date));
%     post_EMG_Data = EMG_Data(1+length(pre_date):end);

    %Calculate the number of days elapsed from the first experiment day
    Elapsed_term = zeros(length(Target_date),1);
    switch criterion_day
        case 'pre_first'
            for ii = 1:length(Target_date)
                if ii == 1 %first_day
                    first_day = trans_calrender(Target_date(ii));
                    Elapsed_term(ii) = 0;
                else
                    Elapsed_day = CountElapsedDate(Target_date(ii),first_day);
                    Elapsed_term(ii) = caldays(Elapsed_day);
                end
            end
            surgery_day_Elapsed = caldays(CountElapsedDate(reference_day,first_day));
        case 'surgery_day'
            surgery_day = trans_calrender(reference_day);
            for ii = 1:length(Target_date)
                Elapsed_day = CountElapsedDate(Target_date(ii),surgery_day);
                Elapsed_term(ii) = caldays(Elapsed_day);
            end
            surgery_day_Elapsed = 0;
    end
end

%プロットの色をpreとpostで変更する
function [p_color] = set_color(Target_date,k,exp_term)
switch exp_term
    case 'pre'
        
    case 'post'
        
end
end

