%{
Coded by: Naohito Ohta
Last modification : 2022/04/28
このコードの使い方：
1.カレントディレクトリをNibaliにする
2.必要な変数(monkeyname,exp_day等)を適宜変更する
以上を満たした状態で実行する
課題点:
全部の筋肉だけでなく,それぞれの筋の筋活動の相関も出す
計測した筋活動だけでなく、再構成された筋活動どうしの相関も出す
%やること:
求めた相関をプロットする(EMG)
同じ系統の色を、日の経過で濃くする(or薄くする)用にプロットする
筋肉全体ではなくて、各筋肉ごとの相関係数を求める
first_dayとaverage_dayでEMG_Dataの構造が異なっているのを直す(average_dayの方に合わせる)
寄与率もstackして出す
%}
clear;
%% set parameter
Target_date = [20220420 20220421 20220422 20220426 20220427 20220428 20220506 20220511 20220513 20220516]; %相関を求めたい対象の実験日を配列にまとめる
for ii = 1:length(Target_date)
    str_Target_date{1,ii} = num2str(Target_date(1,ii)); %Target_dateをstrに型変換したもの.凡例をつける際に使用する(cell配列であることに注意)
end
nmf_fold = 'nmf_result';
monkey_name = 'Ni';
fold_detail = '_standard_filtNO5_'; %ファイルやフォルダに含まれている文字列(形容し難い)
Target_type = 'tim3'; %どのシナジー(EMG)の相関を求めるかを選択する(filtered:nmf解析に用いるEMGの相関,TimeNormalized:時間正規化シナジー,tim1:タイミング1周りのシナジー,tim2:タイミング2周りのシナジー,tim3:タイミング3周りのシナジー)
EMG_type = 'tim3'; %Tareget_typeでfilteredを選んだ時、どの筋電を用いるか?
triming_contents = '_tim3_pre-300_post-100.mat'; %Target_typeがfilteredの時に、どのEMGを使用するか(tim1周り:_tim1_pre-400_post200.mat,tim2周り:_tim2_pre-200_post-300.mat tim3周り:_tim3_pre-300_post-100.mat TimeNormalized:_TimeNormalized.mat )
correlation_type = 'average_day'; %相関係数をどうやって求めるか？(初日データに対しての相関係数:first_day 全日データの平均に対する相関係数:average_day)
pcNum = [2 3]; %使用する筋シナジーの個数(Target_typeがfilteredではない時)
pre_frame = 300; %図にxlineを引くために,pre_frameを設定する

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
%% code section
%日ごとの筋シナジー(もしくはEMG)データを一つにまとめる
if strcmp(Target_type,'filtered') %解析対象がEMGの時
    for ii = 1:length(Target_date)
        for jj = 1:EMG_num
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
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'TimeNormalized_task' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
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

%まとめたデータを用いて相関を出していく
if strcmp(Target_type,'filtered') %筋電ならば
    %平均に対して相関を取る場合と、平均に対して相関を取る場合の二つをオプションとしてつける
    if strcmp(correlation_type,'first_day')
        for ii = 1:length(Target_date)
            EMG_Data{ii,1} = cell2mat(EMG_Data{ii,1});
        end
        %全体データに対しての相関
        for ii = 1:length(Target_date)
            if ii == 1 %初日データの時
               correlation_value(1,1) = 1;
               reference_data = EMG_Data{ii,1}; %reference_data:相関係数の参照データ、このデータを基に相関係数を算出する
            else
               relevant_data = EMG_Data{ii,1};  %該当日に対応するEMGデータ。reference_dataとの相関をだすのに用いる
               R = corrcoef(reference_data,relevant_data); %相関行列をRに代入
               correlation_value(ii,1) = R(1,2); 
            end
        end
        plot(correlation_value)
        xticks([1:length(Target_date)])
        ylim([0 1]);
        title(['EMG-correlation(vs first-day)'])
        mkdir(['control_data/' EMG_type '/analyzed_EMG/corration']);
        saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/corration/filtered_EMG_correlation(vs first_day).png']);
        close all;
        %個々のデータに対しての相関係数
        h = figure;
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
            reference_data = EMG_Data{1,1}(ii,:);
            correlation_value(1,1) = 1;
            for jj = 1:length(Target_date)-1
               R = corrcoef(reference_data,EMG_Data{jj+1,1}(ii,:));
               correlation_value(jj+1,1) = R(1,2);
            end
            subplot(4,4,ii)
            hold on;
            plot(correlation_value)
            xticks([1:length(Target_date)])
            ylim([0 1]);
            title(EMGs{ii,1})
            hold off
        end
        saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/corration/filtered_EMG_individual_correlation(vs first_day).png']);
        close all;
    elseif strcmp(correlation_type,'average_day')
        %reference_dataの作成
        for ii = 1:length(Target_date)
            EMG_Data{ii,1} = cell2mat(EMG_Data{ii,1});
        end
        for ii = 1:EMG_num
            for jj = 1:length(Target_date)
                average_matrix(jj,:) = EMG_Data{jj,1}(ii,:);
            end
            average_matrix = mean(average_matrix);
            reference_data{ii,1} = average_matrix;
        end
        reference_data = cell2mat(reference_data);
        %reference_dataを基に相関係数を求める
        for ii = 1:length(Target_date)
            relevant_data = EMG_Data{ii,1};  %該当日に対応するEMGデータ。reference_dataとの相関をだすのに用いる
            R = corrcoef(reference_data,relevant_data); %相関行列をRに代入
            correlation_value(ii,1) = R(1,2); 
        end
        plot(correlation_value)
        xticks([1:5])
        ylim([0 1]);
        title(['EMG_correlation(vs average)'])
        mkdir(['control_data/' EMG_type '/analyzed_EMG/corration']);
        saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/corration/filtered_EMG_correlation(vs average).png']);
        close all;
    end
    %個々のデータに対しての相関係数
    clear reference_data %全体データに対する相関係数の導出に使用したreference_dataを削除
    h = figure;
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        %reference_dataの作成
        clear reference_data %データに上書きできないので、毎回reference_dataをするクリアする必要がある
        for jj = 1:length(Target_date)
            reference_data{jj,1} = EMG_Data{jj,1}(ii,:);
        end
        reference_data = mean(cell2mat(reference_data));
        for jj = 1:length(Target_date)
           R = corrcoef(reference_data,EMG_Data{jj,1}(ii,:));
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
    saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/corration/filtered_EMG_individual_correlation(vs average_day).png']);
    close all;
    %筋電の図をstackして図示する
    h = figure;
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        for jj = 1:length(Target_date)
            subplot(4,4,ii)
            hold on;
            plot(EMG_Data{jj,1}(ii,:))
        end
        ylim([0 2])
        grid on;
        xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
        title(EMGs{ii,1});
        if ii == 1
            legend(str_Target_date);
        end
        hold off;
    end
    mkdir(['control_data/' EMG_type '/analyzed_EMG/stack']);
    saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/stack/around_' EMG_type '_stack.png']);
    close all;
    %平均+標準偏差の筋電の図
    figure('Position', [0 0 1280 720]);
    for ii = 1:EMG_num
        for jj = 1:length(Target_date)
            reference_sel{jj,1} = EMG_Data{jj,1}(ii,:); %全日分の、ある筋肉からのデータを一つにまとめる
        end
        EMG_mean = mean(cell2mat(reference_sel));
        EMG_std = std(cell2mat(reference_sel));
        subplot(4,4,ii)
        hold on;
        grid on;
        plot(EMG_mean);
        title(EMGs{ii,1});
        ar1=area(transpose([EMG_mean-EMG_std;EMG_std+EMG_std]));
        set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r')
        set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') 
        ylim([0 2])
        xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
        hold off;
    end   
    mkdir(['control_data/' EMG_type '/analyzed_EMG/average'])
    saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/average/around_' EMG_type '_average.png']);
    close all;
else %筋電じゃない(筋シナジー)なら
    %Wに関しての相関(日毎にbarを並べる(その前に、シナジーを揃える作業が必要)& 平均シナジーのプロットと標準偏差 & 相関係数を求める)
    %Hに関しての相関(平均を取って、標準偏差を背景に撮る & 積み重ねた図(凡例をつける) & 相関係数を求める)
    %再構成されたEMG(WH)の相関(計測したEMGの相関係数と同じ容量でやる)
    %W,Hともに大きさが日によって違うので、割合で比較できるようにあらかじめ平均で正規化する→正規化したものと正規化していないもので変数を分けたほうがいいかもしれない
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
        %筋シナジーを揃える(初日のデータに対する標準偏差を取って、一番小さいものを採用)
        for kk = 1:ii
            eval(['synergy' num2str(kk) ' = use_W{ii,1}{1,1}(:,kk);'])
            for ll = 1:length(Target_date)-1
                for mm = 1:ii
                    e_value_ind = sum(eval(['abs(use_W{ii,1}{ll+1,1}(:,mm) - synergy' num2str(kk) ')'])); %indはindividualの意味
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
     %↓全ての操作を終えた後に要素が重複している行に対して追加の操作をする
     for ii = pcNum(1,1) : pcNum(1,end)
         %uniqueを各行に適用して、サイズが変わったら処理を行う
         for jj = 1:length(Target_date)-1
            judge_matrix = eval(['synergy_relation_pcNum' num2str(ii) '(jj,:);']); %調査対象のsynergy_relationの行.
            [~,judge_size] = size(unique(judge_matrix)); %同じ行に重複がある場合は列数()がii(シナジー数)と異なるので、そうなったら追加の処理を行う
            if ii ~= judge_size
                a = 1:ii;
                defective_synergy = setdiff(a,eval(['synergy_relation_pcNum' num2str(ii) '(jj,:);'])); %照合されていないシナジー(初日のシナジー)を見つける
                %過度に使用されている(重複のある)シナジーを出力する
                for kk = 1:ii
                     overlap_num_matrix = find(judge_matrix(1,:) == kk); %重複している要素があれば、配列の要素数は2以上になる
                     [~,overlap_num] = size(overlap_num_matrix);
                    if overlap_num > 1
                        overlap_used_matrix = overlap_num_matrix;
                        for ll = overlap_used_matrix
                            if ll == overlap_used_matrix(1,1)
                                min_value = e_value{ii,defective_synergy}(jj,ll);
                                min_col = ll;
                            elseif min_value > e_value{ii,defective_synergy}(jj,ll)
                                min_value = e_value{ii,defective_synergy}(jj,ll);
                                min_col = ll;
                            end
                        end
                        eval(['synergy_relation_pcNum' num2str(ii) '(jj,min_col) = defective_synergy;']);
                    end
                end
            end
         end
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
                    sorted_use_W{tt,1}{ii,1}{1,jj}(:,1) = use_W{tt,1}{jj,1}(:,eval(['synergy_relation_pcNum' num2str(tt) '(jj-1,ii);']));
                end
            end
        end
    end
    %保存先のディレクトリを作る
     mkdir(['control_data/' Target_type '/synergy_W/stack']);
     mkdir(['control_data/' Target_type '/synergy_W/average' ]);
     mkdir(['control_data/' Target_type '/synergy_H/stack' ]);
     mkdir(['control_data/' Target_type '/synergy_H/average' ]);
     mkdir(['control_data/' Target_type '/analyzed_EMG/stack'; ]);
     mkdir(['control_data/' Target_type '/analyzed_EMG/average' ]);
     mkdir(['control_data/' Target_type '/reconst_EMG/stack' ]);
     mkdir(['control_data/' Target_type '/reconst_EMG/average']);
     mkdir(['control_data/' Target_type '/r2/stack']);
    %グループを作ってプロットする
    for tt = pcNum
        figure('Position', [0 0 1280 720]);
        for ii = 1:tt
            synergy_portion = cell2mat(sorted_use_W{tt,1}{ii,1});
            subplot(tt,1,ii); 
            bar(x,synergy_portion);
            ylim([0 4]);
            if ii == 1
                legend(str_Target_date);
                title(['all-W pcNum =' num2str(tt)]);
            end
        end
        saveas(gcf,['control_data/' Target_type '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ').png']);
        close all;
    end
    %全日の平均の空間シナジーを出す
    for tt = pcNum
        figure('Position', [0 0 1280 720]);
        for ii = 1:tt
            synergy_portion = cell2mat(sorted_use_W{tt,1}{ii,1});
            synergy_std = std(synergy_portion,0,2);
            synergy_average = mean(synergy_portion,2);
            subplot(tt,1,ii); 
            bar(x,synergy_average);
            hold on;
            er = errorbar(x,synergy_average,synergy_std);    
            er.Color = [0 0 0];                            
            er.LineStyle = 'none';
            ylim([0 4]);
            if ii == 1
                title(['all_W pcNum =' num2str(tt)]);
            end
        end
        hold off;
        saveas(gcf,['control_data/' Target_type '/synergy_W/average/all_W(' Target_type '_' 'pcNum =' num2str(tt) ').png']);
        close all;
    end
    %r2をまとめた図を作る
    for ii = 1:length(Target_date)
        plot(all_r2{ii,1})
        ylim([0 1])
        hold on;
    end
    plot(shuffle.r2,'Color',[0,0,0])
    plot([0 EMG_num + 1],[0.8 0.8]);
    legend(str_Target_date)
    title([Target_type ' R^2']);
    saveas(gcf,['control_data/' Target_type '/r2/stack/' Target_type '_r2.png'])
    %時間シナジー(H)について
    %all_Hからuse_Hを作る
    for ii = pcNum
        for jj = 1:length(Target_date)
            use_H{ii,1}{jj,1} = all_H{jj,1}{ii,1};
        end
    end
    %use_Hを平均値で正規化
    for ii = pcNum
        for jj = 1:length(Target_date)
            for kk = 1 : ii
                average_value = mean(use_H{ii,1}{jj,1}(kk,:));
                use_H{ii,1}{jj,1}(kk,:) = use_H{ii,1}{jj,1}(kk,:)/average_value;
            end
        end
    end
    % 重ね合わせの図をプロットする
    for ii = pcNum
        figure('Position', [0 0 640 640]);
        for kk = 1:ii
            for jj = 1:length(Target_date) 
                subplot(ii,1,kk)
                hold on;
                if jj == 1 %初日
                    plot(use_H{ii,1}{jj,1}(kk,:))
                else
                    plot(use_H{ii,1}{jj,1}(eval(['synergy_relation_pcNum' num2str(ii) '(jj-1,kk)']),:))
                end
            end
            ylim([0 6])
            xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
            if kk == 1
                legend(str_Target_date);
                title(['all_H pcNum =' num2str(ii)])
            end
        end
        hold off;
        saveas(gcf,['control_data/' Target_type '/synergy_H/stack/all_H(' Target_type '_' 'pcNum =' num2str(ii) ').png']);
        close all;
    end
    %全日の平均の時間シナジーを出す
    for ii = pcNum
        for kk = 1:ii
            clear ave_H_matrix;
            for jj = 1:length(Target_date)
                if jj == 1
                 ave_H_matrix{jj,1} = use_H{ii,1}{jj,1}(kk,:);
                else
                 ave_H_matrix{jj,1} = use_H{ii,1}{jj,1}(eval(['synergy_relation_pcNum' num2str(ii) '(jj-1,kk)']),:);
                end
            end
            ave_H_matrix = cell2mat(ave_H_matrix);
            ave_H = mean(ave_H_matrix);
            ave_H_std = std(ave_H_matrix);

            subplot(ii,1,kk)
            hold on;
            plot(ave_H)
            %標準偏差の背景表示
            %ar1=area(x,[Y1(1:11,1)-Y1(1:11,2) Y1(1:11,2)+Y1(1:11,2)]);
            %{
            ar1=area(ave_H-ave_H_std);
            set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r') %帯の下側
            set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') %帯の内側
            %}
            ar1=area(transpose([ave_H-ave_H_std;ave_H_std+ave_H_std]));
            set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r')
            set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') 
            ylim([0 6])
            xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
            hold off;
            if kk == 1
                 title(['ave_H pcNum =' num2str(ii)])
            end
        end
        saveas(gcf,['control_data/' Target_type '/synergy_H/average/all_H(' Target_type '_' 'pcNum =' num2str(ii) ').png']);
        close all;
    end
end
           