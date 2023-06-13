%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
【explanation】
【改善点】
exp_dayとdaysの違いを明らかにする
【caution!!】
・changing param(in plotSynergyAll_Uchida.m)
pre_frame, synergy_type
【procedure】
pre:makefold.m
post:EMG_correlation
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set param
monkey_name = 'Ni';
trim_package.type = 'trimmed'; %(analysis_type = 'all_data'の時に使用する)どのタイミングにフォーカスして、取り出すか ※現状tim3しか対応していない
analysis_type = 'trimmed'; %'all_data' or 'trimmed' (筋シナジーデータが、全体からのものなのか、トリミングされたものからなのか)※基本'trimmed'でいい
%↓全体データからプロットするときに使う変数，(フツーは使わない)
trim_package.pre_frame = 300;
trim_package.post_frame = 400;
setting_days = 0; %0:手動でdaysを設定したとき 1:devide_infoから日付を設定したとき(生成したグラフやディレクトリの名前を決定するときに、devide_infoを使用したことをわかるようにしたい)
type = '_filtNO5';% _filt05 means'both' direction filtering used 'filtfilt' function
days = [...%pre-surgery
%           20220420
%         20221004;...
%         20221005;...
%         20221007;...
%         20221012;...
%         20221026;...
%         20221027;...
%         20221028;...
%         20221031;...
%         20221107;...
%         20221108;...
%         20221109;...
%         20221201;...
%           20230208;...
%           20230209;...
%           20230210;...
%         20230220
%         20230221
%          20230222
%         20230224
%         20230227
%           20230511
%           20230512
%           20230524
        20230524
        20230529
        ];

%% code section
if setting_days == 1
    load([pwd '/' 'devide_info' '/' 'all_day_trial.mat'], 'trial_day'); %全ての実験日の日付リストをロードする
    days = GenerateTargetDate(trial_day ,'all',0,1000,pwd); %解析する日付をcell配列に格納するための変数．あんまり気にしない
end

     
Ld = length(days);
     
for ii = 1:Ld
    exp_day = days(ii);
    fold_name = [monkey_name sprintf('%d',days(ii))];
    %sprintf('%d',days(ii)) days(ii)をsprint型に変換
    synergyplot_func(fold_name,monkey_name,exp_day,analysis_type,trim_package);
end
