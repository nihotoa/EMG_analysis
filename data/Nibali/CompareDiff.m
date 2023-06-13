%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
【未完成(思った通りの結果にならない)】
筋シナジーの空間基底の重みと相互相関係数の変化を比較するグラフを作成するための関数
Nibaliをcdにして使用する
課題:
図のセーブ
図への凡例の追加
データがおかしい→筋肉名とデータの対応づけがあっているかどうか？(特に,空間シナジーのデータ)
NaN値を跨いで、線を結ぶ方法
一旦保留(Yachimunの方が優先度高い)
pre:EMG_correlatioon.m
post:nothing(coming soon!)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
%% set param
Target_date =  [20220728 20220729 20220802 20220803 20220804 20220805 20220809 20220810 20220812 20220815 20220816 20220817 20220819 ...
                20220825 20220826 20220830 20220831 20220901 20220906 20220907 20220908 20220909 20220913 20220915 20220916 20220920];
start_day = 20220420; %experiment start day
reference_day = 20220530; %surgery day
reference_muscles = {'FDS-A','FDS-B'}; %どの筋肉に対する相互相関の値を、この解析に使用するか？(複数選択可)
EMG_type = 'tim3';
synergy_num = 2;
EMG_num = 16; %ワークスペース変数から抽出しても良かったが、可読性のために手動で設定 
%% code section
% 1.Target_dateの,reference_dayからの経過日数を計算する
reference_cal_day = trans_calrender(reference_day);
day_info = cell(3,length(Target_date));
for ii = 1:length(Target_date)
    [Elapsed_date] = CountElapsedDate(Target_date(ii),reference_cal_day);
    day_info{1,ii} = Target_date(ii);
    day_info{2,ii} = split(Elapsed_date,'days');
end

%2.使用する相互相関のデータを読み込む
for ii = 1:length(reference_muscles)
    reference_muscle = reference_muscles{ii};
    file_list = dir('compare_diff');
    for jj = 1:length(file_list)
        if contains(file_list(jj).name,reference_muscle)
            load(['compare_diff/' file_list(jj).name])
            x_corr_data{ii,1} = ['vs ' reference_muscle] ;
            x_corr_data{ii,2} = all_xcorr;
        end
    end
end

%3.使用する空間シナジーのデータを読み込む
load('compare_diff/W_synergy.mat')

%4.読み込んだ筋シナジーデータと、x_corrデータのデータ構造をプロット用に整える
% ↓空間シナジーデータで、日付を考慮するように、データを作り替える
for ii = 1:synergy_num
    for jj = 1:EMG_num
        eval(['W' num2str(ii) '_sel = NaN(day_info{2,end},1);'])
        for kk = 1:length(day_info)
            eval(['W' num2str(ii) '_sel(day_info{2,kk}) = W_synergy' num2str(ii) '{jj,2}(kk);'])
            % W1(day_info(2,kk)) = W_synergy1{1,2}(kk)
        end
        if jj == 1 %W1のセル配列を作る
            eval(['W' num2str(ii) ' = cell(EMG_num,2);'])
            %↓筋肉の名前だけ1列目に代入して行く
            for ll = 1:EMG_num
                eval(['W' num2str(ii) '{ll,1} = W_synergy1{ll,1};'])
            end
        end
        eval(['W' num2str(ii) '{jj,2} = W' num2str(ii) '_sel;'])
    end
end

%x-corrデータで、preの日付を考慮しないようにデータを作り替える
start_calrender = trans_calrender(start_day);
eliminated_day = CountElapsedDate(reference_day,start_calrender);
for ii = 1:length(reference_muscles)
    for jj = 1:EMG_num 
        x_corr_data{ii,2}{jj,2}(1:split(eliminated_day,'days')+1) = [];
    end
end

%5.微分値を計算した後,正規化する
 %W_synergyについて
for ii = 1:synergy_num
    for jj = 1:EMG_num
        used_data = eval(['W' num2str(ii) '{jj,2};']);
        diff_data = special_diff(used_data);
        if jj == 1 %W1のセル配列を作る
            eval(['W' num2str(ii) '_diff = cell(EMG_num,2);'])
            %↓筋肉の名前だけ1列目に代入して行く
            for kk = 1:EMG_num
                eval(['W' num2str(ii) '_diff{kk,1} = W_synergy1{kk,1};'])
            end
        end
        eval(['W' num2str(ii) '_diff{jj,2} = diff_data;'])
    end
end
 %正規化(絶対値を取った後、平均で割る)
 for ii = 1:synergy_num
     for jj = 1:EMG_num
         average_value = nanmean(abs(eval(['W' num2str(ii) '_diff{jj,2}'])));
         eval(['W' num2str(ii) '_diff{jj,2} = abs(W' num2str(ii) '_diff{jj,2})/average_value;'])
     end
 end

 %x_corrについて
for ii = 1:length(reference_muscles)
    for jj = 1:EMG_num
        used_data = x_corr_data{ii,2}{jj,2};
        diff_data = special_diff(used_data);
        if jj == 1
            x_corr_diff{ii,1} = reference_muscles{ii};
            for ll = 1:EMG_num
                x_corr_diff{ii,2}{ll,1} = W_synergy1{ll,1};
            end
        end
        %eval(['W1_diff{jj,2} = diff_data;'])
        x_corr_diff{ii,2}{jj,2} = diff_data;
    end
end
  %正規化(絶対値を取った後、平均で割る)
for ii = 1:length(reference_muscles)
    for jj = 1:EMG_num
        average_value = nanmean(abs(x_corr_diff{ii,2}{jj,2}));
        x_corr_diff{ii,2}{jj,2} = abs(x_corr_diff{ii,2}{jj,2})/average_value;
    end
end

%プロットする
for ii = 1:length(reference_muscles) %作る画像の個数
    h = figure;    
    h.WindowState = 'maximized';
    %title(['compare multi data(vs)' reference_muscles{ii}],'FontSize',20)
    for jj = 1:EMG_num
        subplot(4,4,jj)
        hold on;
        plot(x_corr_diff{ii,2}{jj,2},'o')
        for kk = 1:synergy_num
            plot(eval(['W' num2str(kk) '_diff{jj,2}']),'o')
        end
        title(x_corr_diff{ii,2}{jj,1},'FontSize',24)
        xlim([0 round(length(diff_data),-1)])
        hold off
    end
    %↓図全体へのタイトル挿入
    sgt = sgtitle(['compare multi data(vs ' reference_muscles{ii} ')'],'FontSize',35);
    %↓ここにセーブのためのコードを書く
    
    close all;
end


%% create local function
%↓NaN値を加味した微分
function diff_data = special_diff(data)
    diff_data = NaN(length(data)-1,1); 
    hold_value = 0;%保留値
    count = 0;
    for ii = 2:length(data)
        if isnan(data(ii))
            count = count + 1; %連続してNaNが入った回数
        elseif not(isnan(data(ii))) %NaN値じゃなかった時        
            if hold_value == 0 %初めて値が入った時
                diff_data(ii-1) = NaN;
                count = 0;%countを0に戻す
                hold_value = data(ii);
            else %それ以前に値が入った経験がある時
                diff_data(ii-1) = (data(ii) - hold_value)/(count+1);
                count = 0; %countを0に戻す
                hold_value = data(ii);
            end
        end
    end
end