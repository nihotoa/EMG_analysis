%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%coded by: Naohito Ohta
%last modification: 2022.02.09
%他のNibaliディレクトリ内関数から呼び出して使用する
%タスクの定義に従ってEMGデータ、筋シナジーの時間規定Hからタスクデータのみを抽出する
%関数にした方が汎用性が高いと思ったので作った
%改善点：
%NMFの仕方によってサンプリングレートが違うので(100HZと1350HZ)それぞれに応じた解析ができるように改良する
%このコードはとりあえず保留（時間かかりそうだから）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% define function
function DefineTask(monkey_name,exp_day,save_fold)

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
%↑trim_sectionここまで

 %↓CAI_001しかタイミングデータがなかったときの成功定義
min_sample_num = ((120/220)*(CAI_001_KHz*1000));
max_sample_num = ((240/220)*(CAI_001_KHz*1000));
trim_count = 1; 

for ii = 1:length(trim_section)
    width = trim_section(2,ii)-trim_section(1,ii);
    if and(min_sample_num<width,width<max_sample_num)
        final_trim(:,trim_count) = trim_section(:,ii);
        trim_count = trim_count + 1;
    else
        trim_section(:,ii) = 0;
    end
end
%↑ここまで
%{
%↓CAIデータが2個あるときの成功定義
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
cd([save_fold '/' monkey_name num2str(exp_day) '_standard' ]);
if tim_file_num == 1
    [All_task_EMG,All_ave_task_EMG] = trimingEMG(EMG_num,EMGs,final_trim,1); 
    cd ../../
    cd EMG_Data;
    %↓タスクの平均サンプル数。正規化した後のおおよそのサンプリングレートを導出するのに必要
    ave_sample_num = mean(final_trim(2,:) - final_trim(1,:));
    save('task_EMG_Data.mat','All_task_EMG','All_ave_task_EMG','ave_sample_num');
end
cd ../../;
%↑カレントディレクトリを日付に直す

%% trimming synergy_H section
trimingSynergyH(pcNum,All_T,final_trim,save_fold,monkey_name,exp_day,task);

end

