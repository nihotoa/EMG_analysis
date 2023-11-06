%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last Modification:2023.05.01
【procedure】
pre:nothing
post:SuccessTiming_func.m

【前準備】
・患者さんのディレクトリ直下に日付のディレクトリを作成して，csvファイルを置いてください

【function】
・原先生からもらったcsvデータを,.matファイルに変換して同じディレクトリに保存するためのコード
・csvファイルは患者名 => 日付 の中に入っています(ex.) patientB => post1 => ココ!!
・ファイルを選択する画面が出たら,すべてのcsvファイルを選ぶこと(動作データも選ぶこと)
・ファイルの複数選択の方法はググってください(Macだとcommand押しながら選択)
【注意点】
readmatrixが，2019以降のMATLAB出ないと使えない
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
EMG_start_matrix = [6,3]; %csvファイルの必要な部分だけを抽出するために，startのセルを選択(基本的にイジらなくていい)
Marker_start_matrix = [6,3]; %基本的にイジらなくていい
%% code section
%csvファイルを選択(複数選択可能)
disp('解析に使用するすべてのcsvファイルを選んでください')
[fileNames,pathName] = selectGUI(patient_name);
%↓データをセーブするフォルダの設定(現状はcsvファイルと同じ場所)
save_fold = pathName;

% ファイルごとにデータを読み込んで、ファイル名と同名の変数に代入する
for i = 1:length(fileNames)
    filename = fileNames{i}; % 個々のファイル名を取得
    variable_name = strrep(filename, '.csv', ''); % 拡張子を除いた名前
    filePath = fullfile(pathName, filename);
    if contains(filePath,'Traj') %動作のデータならば
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
    try
        data = readmatrix(filePath,opts); % csvファイルのデータを読み込み
        data = data(:,start_col:end); %いらない列を削除
    catch %エラーが発生した場合
        data = readmatrix(filePath);
        data = data(4:end, 3:end);
    end
    %命名規則を守れるように変数名を変更(.とかは変数名に含ませることができないので変更)
    if contains(variable_name,'.') %.を_に変換する
        variable_name = strrep(variable_name,'.','_');
    end
    if isstrprop(variable_name(1), 'digit') %variable_nameの接頭語が1thとかの場合は消す.
        variable_name = strrep(variable_name,[variable_name(1) 'th'],'');
    end
    if contains(variable_name,' ') %空所を_に変換する
        variable_name = strrep(variable_name,' ','_');
    end
    % データのセーブ
    save([save_fold variable_name],'data')
end
