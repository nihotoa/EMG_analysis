%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota
Last Modification: 2023.05.01

【function】
・this function conduct the pre-processing of EMG (down_sampling, rect, etc...)

【procedure】
pre: ExtractEMGData.m
post: (if you want to devide all data into each trial data) devide filteredEMG (else)makeEMGNMF_Oya or Ohta (交差検証　必要→Oya　しない→Ohta) 
after-post: temp_SynergyAnalysis.m
''
【課題点】
・ローパスのカットオフ周波数のさじ加減がわからないから話し合って決める
・タスクが複数種類あるので，一気に回せるように変更する
・NMFのためのフォルダ構造の作り方をしっかり理解していないので，適宜変更する(nmf_fold_path)
・get_task_dirsで，欲しいディレクトリの階層をマニュアルで指定しているがwindowsとmacで階層構造が異なるため
　齟齬が生じている
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%% set param
patient_name = 'patientB';
use_val.SR = 1000; %筋電のサンプリングレート
use_val.DSR = 100; %
use_val.filter_h = 50; %ハイパスのカットオフ周波数
use_val.filter_l = 3;
use_val.medianfilter = 1; %wheter you apply median filter
use_val.med_window = 200; %medianフィルタの次数(窓の大きさ)
task_names = {'pre', 'post'}; %階層構造を指定せずに，特定の文字列を持ってくるために必要
confirm_filtered_data = 1; %filterされた後の波を主観的に判断するための機能(もっと詳細に知りたい場合はcheckRawEMG.mを回して)

%% code section
disp('【Please select .mat file which is created by ExtractEMGData.m(day -> task -> RAW)】')
[fileNames,def_pathName] = selectGUI(patient_name, 'EMG');
path_elements = split(def_pathName, filesep);
task_names = get_task_dirs(patient_name,path_elements, task_names); %タスクのディレクトリ情報を抽出

for task_num = 1:length(task_names)
    pathName = strrep(def_pathName, task_names{1}, task_names{task_num});
    for ii = 1:length(fileNames)
        file_path = [pathName fileNames{ii}];
        load(file_path, 'EMG_data', 'muscle_name');
        use_val.temp_EMG = EMG_data;
        %↓前処理を行うローカル関数を実行
        switch use_val.medianfilter
            case 1
                [processed_EMG,ex_spike_EMG] = EMG_filter(use_val);
            otherwise
                processed_EMG = EMG_filter(use_val);
        end

        %セーブデータをまとめる
        Data = processed_EMG;
        Name = [muscle_name '-hp' num2str(use_val.filter_h) 'Hz-rect-lp' num2str(use_val.filter_l) 'Hz' '-ds100Hz'];
        %データをセーブする
        if ii == 1
            idx = strfind(file_path, 'RAW');
            task_fold_path = file_path(1:idx-1);
            nmf_fold_path = [task_fold_path 'nmf_result' '/' patient_name '_standard'];
            if not(exist(nmf_fold_path))
                mkdir(nmf_fold_path)
            end
            Class = ['continuous channel'];
            SampleRate = use_val.DSR;
            TimeRange = [0 length(Data)/SampleRate];
            Unit = 'V';
        end

        %filteredEMGの確認
        if confirm_filtered_data == 1
            if and(task_num==1, ii == 1)
                index = strfind(task_fold_path, task_names{ii}); %一致する文字列の頭文字のindexを取得
                day_path = task_fold_path(1:index-1);
%                 tim_data = extract_tim_data(day_path, task_names{ii}, SampleRate);
                load([day_path task_names{ii} '_timing.mat'], 'all_timing_data')
                RAW_timing_data = all_timing_data * (use_val.SR/use_val.DSR); 
                figure('Position',[100 100 600 800]);
                hold on
                x = linspace(0,1,length(all_timing_data(1,1)+1:all_timing_data(2,1)));
                y = linspace(0,1,length(RAW_timing_data(1,1)+1:RAW_timing_data(2,1)));
                switch use_val.medianfilter
                    case 1
                        subplot(3,1,1)
                        plot(y, use_val.temp_EMG(1,RAW_timing_data(1,1)+1:RAW_timing_data(2,1)),LineWidth=1.3) %rawData
                        subplot(3,1,2)
                        plot(y, ex_spike_EMG(1,RAW_timing_data(1,1)+1:RAW_timing_data(2,1)),LineWidth=1.3) %rawData(spike_removed)
                        subplot(3,1,3)
                        plot(x, Data(1, all_timing_data(1,1)+1:all_timing_data(2,1)),LineWidth=1.7) %filtered_data
                    otherwise
                        subplot(2,1,1)
                        plot(y, use_val.temp_EMG(1,RAW_timing_data(1,1)+1:RAW_timing_data(2,1)),LineWidth=1.3) %rawData
                        subplot(2,1,2)
                        plot(x, Data(1, all_timing_data(1,1)+1:all_timing_data(2,1)),LineWidth=1.7) %filtered_data
                end
                hold off
                response = input("【処理を実行しますか?('yes'/'no')】");
                if or(isempty(response),strcmpi(response, 'yes') )
                    close all;
                else
                    disp('【処理を停止しました】')
                    close all;
                    return;
                end
            end
        end

        %データのセーブ
        save([nmf_fold_path '/' Name '.mat'],'Class', 'SampleRate', 'TimeRange', 'Unit', 'Data', 'Name')
    end
end
%% define local function

function [processed_EMG, ex_spike_EMG] = EMG_filter(use_val)
temp_EMG = use_val.temp_EMG;
%high_pass
[B,A] = butter(6, (use_val.filter_h .* 2) ./ use_val.SR, 'high');
temp_EMG = filtfilt(B,A,temp_EMG);
%rect''
temp_EMG = abs(temp_EMG);

%madianフィルタによって，spikeを除去
if use_val.medianfilter
    temp_EMG = medfilt1(temp_EMG,use_val.med_window);
    ex_spike_EMG = temp_EMG;
end

%パワースペクトルの確認(デバッガーで止めないかぎり見れない)
PowerSpectrumAnalyze(temp_EMG,use_val.SR, 50)
%smoothing(平滑化)→整流した後にタスクを重ね合わて、その後に平均をとって、その後にこの処理をするべき
[B,A] = butter(6, (use_val.filter_l .* 2) ./ use_val.SR, 'low');
processed_EMG = filtfilt(B,A,temp_EMG);

%ds100Hz
processed_EMG = resample(processed_EMG, use_val.DSR, use_val.SR);
end

function all_timing_data = extract_tim_data(day_path, task_name, EMG_SampleRate)
load([day_path task_name '_timing.mat'], 'all_timing_data', 'SamplingRate') %motionのSR
all_timing_data = all_timing_data * (EMG_SampleRate / SamplingRate);
end