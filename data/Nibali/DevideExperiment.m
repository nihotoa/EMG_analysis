%{
Coded by: Naohito Ohta
Last modification : 2022/09/16
how to use：
1.setting current directry as Nibali

【What you will get】
・List of experimental days when the number of trials was above (or below)the threshold()
 (this data is necessary when you confirm　Credibility of data)
パラメータの部分で、いろいろな条件を付加して,その条件を満たす実験日だけまとめてデータとして保存する関数.
メリットとしては、パラメータで条件設定すれば,いちいち手動で条件を満たしている日がどの日か探さなくて良くなる &
保存した日付データをループの要素として使える

【Notes】
・it is possible to validate multiple parameters
・the data which is created by using this code is saved in 'devide_info' fold
・please make current directry 'Nibali' when you use this code
・please conduct 'untitled.m' before conducting this func (to get 'success_timing.mat')

【procedure】
pre:untitled.mat (necessary)
post: you can use this func data in various function 
※but now, this data is only used in 'EMG_correlation.m' 


【目標】
・タスク回数だけでなく、いろいろな条件を複合的に満たすような日付をマージして保存できるような機能を持たせる(日付だけでなく,untitledで生成されたデータへの操作も記述する必要がある)
(ex)100回以上タスクをやった日のデータの1~50回目からEMG解析、100回以上かつタイミング1~2,2~3,3~4にかかる時間が閾値以内のEMGを抽出して解析→個のオプションを加えるとしたらここじゃない気がする
・「preの中で」a以上b以下,「postの中で」a以上b以下のデータを抽出できるようにする(現状は「全体の中で」しかオプションがない)
%}
clear;
%% set param
surgery_day = 20220530;
exp_dir = dir('2022*'); %日付フォルダを全て読み込む
term_type = 'post'; %'all' or 'pre' or 'post'
%all_day_trial param (to save number of trial per day)
all_day_trial = 1; %if you save number of trial per day, you have to fill 1 in this param
%restrict_param
restrict_trial = 1; %if you restrict trial_num, you have to fill 1 in this param 
max_trial = 1000; %upper limit of trial
minimum_trial =0; %lower limit of trial
%% code section
for ii = 1:length(exp_dir)
    exp_dir(ii).name = str2double(exp_dir(ii).name);
end

if strcmp(term_type,'all')
    target_day = exp_dir;
else
    [target_day] = defTarget(exp_dir,term_type,surgery_day); %(remove pre/post day to reference surgery_day (if you set term_type as pre or post))
end

for ii = 1:length(target_day)
    exp_days(ii) = target_day(ii).name;
end

count=1;
for exp_day = exp_days
    timing_pass = [num2str(exp_day) '/EMG_Data/Data']; %path to the directory which contains success_timing.mat
    try
        load([timing_pass '/success_timing.mat'])
        trial_num{count,1}(1) = exp_day;
        trial_num{count,1}(2) = length(success_timing);
        count = count + 1;
    catch
        continue; %success_timingが存在しない場合は次のループへ行く
    end
end
trial_data = cell2mat(trial_num);

if all_day_trial
    %sort trial_data
    [A,I] = sort(trial_data(:,2));
    trial_data = trial_data(I,:);
    if not(exist('devide_info'))
        mkdir('devide_info')
    end
    trial_day = sort(trial_data(:,1));
    save(['devide_info/' term_type '_day_trial.mat'],'trial_data','trial_day');
end

if restrict_trial
    I = trial_data(:,2) >= minimum_trial & trial_data(:,2) <= max_trial; %extract row which achieve term
    trial_data = trial_data(I,:);
    if all_day_trial
        trial_day = sort(trial_data(:,1)); 
    end
    save(['devide_info/' term_type '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat'],'trial_data','trial_day');
end

%% define function
 %function1
 function [target_day] = defTarget(exp_dir,term_type,surgery_day)
    count = 1;
    for ii = 1:length(exp_dir)
        if strcmp(term_type,'pre')
            if exp_dir(ii).name < surgery_day
                target_day(count) = exp_dir(ii);
                count = count + 1;
            end
        elseif strcmp(term_type,'post')
            if exp_dir(ii).name > surgery_day
                target_day(count) = exp_dir(ii);
                count = count + 1;
            end
        end
            
    end
 end

