%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Nibaliのためだけのコードなので，汎用性を高める
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Target_date = GenerateTargetDate(Target_date,analyze_period,minimum_trial,max_trial,monkey_dir)
    try
        %↓実験日ではないが、トライアルデータを持っている日付を除去する
        removed_day = [20220301, 20220324, 20220414 20220607]; 
        load([monkey_dir '/' 'devide_info' '/' analyze_period '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat'])
        Target_date = transpose(intersect(Target_date,trial_day));
        Target_date = setdiff(Target_date, removed_day);
    catch
        error([analyze_period '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat が存在しません.DevideExperimet.mを実行して、ファイルを作成してください'])
    end
end