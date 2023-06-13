%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%関数DefineTask.mの性能を評価するための関数。実用的な意味はない
%カレントディレクトリをNibaliにして使用する
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% Set Parameters
monkey_name = 'Ni';
exp_day = 220208;
save_fold = 'nmf_result';

%% conduct function
cd(num2str(exp_day));
DefineTask(monkey_name,exp_day,save_fold)
