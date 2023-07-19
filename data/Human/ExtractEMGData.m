%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last Modification:2023.05.01
【procedure】
pre:ReadCsv.m
post:filterEMG
【function】
・得られた.matファイルから個々の筋肉の筋電を抽出して.mat形式でタスクごとに保存
【課題点】
命名規則のための変数名の変更は，起こったエラーに対して継ぎ足しで条件設定しているので，新たな問題が発生したときは
それに対応できるように継ぎ足すこと．

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
use_val.processing_type = 'RAW'; %筋電の前処理内容 'RAW' (現状RAWしかない)
%↓この順番を守ること(ずれると筋電と筋肉の名前が混同するから絶対ダメ)
%pre1の時
% use_val.EMG_name = {
%                       'IOD-1'
%                       'APB'
%                       'APQ'
%                       'EDC'
%                       '2L'
%                       'ECR'
%                       'BRD'
%                       'FCU'
%                       '3L'
%                       'FCR'
%                       'FDS'
%                       'Biceps'
%                       '4L'
%                       'Triceps'
%                       'FSR'
%                                        };
%post1, post2の時,post3,post4の時
use_val.EMG_name = {
                      'IOD-1'
                      '2L'
                      '3L'
                      '4L'
                      'APB'
                      'ADQ'
                      'EDC'
                      'ECR'
                      'BRD'
                      'FCU'
                      'FCR'
                      'FDS'
                      'Biceps'
                      'Triceps'
                      'DLA'
                      'DLM'
                                       };

%% code section
disp('[Please select all EMG file(patinet -> day -> Task~.mat)]')
[fileNames,use_val.pathName] = selectGUI(patient_name, 'EMG');

%↓タスクの種類ごとに筋電を保存してく
for ii = 1:length(fileNames)
    use_val.fileName = fileNames{ii};
    calcEMG(use_val);
end

%% define internal function

function [] = calcEMG(use_val)
use_val.fold_name = strrep(use_val.fileName,'.mat','');
%↓フォルダの作成
use_val.file_save_dir = [use_val.pathName use_val.fold_name '/' use_val.processing_type];
if not(exist(use_val.file_save_dir,'dir'))
    mkdir([use_val.file_save_dir])
end
%データを各筋電ごとに分ける
load([use_val.pathName use_val.fileName],'data'); %データの読み込み
switch use_val.processing_type
    case 'RAW'
        for ii = 1:length(use_val.EMG_name)
            EMG_data = data(:,ii);
            EMG_data = transpose(EMG_data(~isnan(EMG_data))); %NaN値がある場合は除く
            muscle_name = use_val.EMG_name{ii}; 
            save([use_val.file_save_dir '/' use_val.EMG_name{ii} '_EMG'],'EMG_data','muscle_name')
        end        
end

end