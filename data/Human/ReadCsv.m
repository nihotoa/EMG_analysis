%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last Modification:2023.05.01
【procedure】
pre:nothing
post:ExtractEMGData.m or SuccessTiming_func.m

【function】
・原先生からもらったcsvデータを,.matファイルに変換して同じディレクトリに保存するためのコード
・すべてのcsvファイルを選ぶこと(motionデータも選ぶこと)
・命名規則のための変数名の変更は起こったエラーに対して継ぎ足しで条件設定しているので新たな問題が発生したときはそれに対応できるように継ぎ足すこと
【注意点】
readmatrixが，2019以降のMATLAB出ないと使えない
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
EMG_start_matrix = [6,3]; %csvファイルの必要な部分だけを抽出するために，startのセルを選択
Marker_start_matrix = [6,3];
%% code section
[fileNames,pathName] = selectGUI(patient_name);
%↓データをセーブするフォルダの設定(現状はcsvファイルと同じ場所)
save_fold = pathName;

% ファイルごとにデータを読み込んで、ファイル名と同名の変数に代入する
for i = 1:length(fileNames)
    filename = fileNames{i}; % 個々のファイル名を
    variable_name = strrep(filename, '.csv', ''); % 拡張子を除いた名前
    filePath = fullfile(pathName, filename);
    if contains(filePath,'Traj')
        start_row = Marker_start_matrix(1);
        start_col = EMG_start_matrix(2);
    else
        start_row = EMG_start_matrix(1);
        start_col = EMG_start_matrix(2);
    end
    %csvファイルのいらない部分を端折るための処理
    opts = detectImportOptions(filePath);
    opts.DataLines = [start_row,Inf]; %いらない行を消去
    %↓データの代入
    data = readmatrix(filePath,opts); % csvファイルのデータを読み込み
    data = data(:,start_col:end); %いらない列を削除
    %命名規則を守れるように変数名を変更(.とかは変数名に含ませることができないので変更)
    if contains(variable_name,'.') %譁?蟄怜?励↓.繧貞性繧?蝣ｴ蜷?
        variable_name = strrep(variable_name,'.','_');
    end
    if isstrprop(variable_name(1), 'digit') %謗･鬆ｭ隱槭′謨ｰ蟄励?ｮ蝣ｴ蜷?
        variable_name = strrep(variable_name,[variable_name(1) 'th'],'');
    end
    if contains(variable_name,' ') %譁?蟄怜?励↓ 繧貞性繧?蝣ｴ蜷?
        variable_name = strrep(variable_name,' ','_');
    end
%     assignin('base', variable_name, data); % 螟画焚縺ｫ繝?繝ｼ繧ｿ繧剃ｻ｣蜈･縺吶ｋ   
    %繝?繝ｼ繧ｿ縺ｮ繧ｻ繝ｼ繝?
    
    save([save_fold variable_name],'data')
end
