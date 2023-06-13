%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last modification : 2023/03/02

【function】
・guiで16個の図を読み込んで(4シナジー*4タイミング)Uchidaさんのappendixの図のような形で，出力する

【課題点】
・汎用性が低い(16個に限られている)ので改善する
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
monkey_name = 'Yachimun';
%% code section
switch monkey_name
    case 'Yachimun'
        plotWindow1 = [-25 5];
        plotWindow2 = [-15 15];
        plotWindow3 = [-15 15];
        plotWindow4 = [95 125];
    case 'SesekiL'
        plotWindow1 = [-30 15];
        plotWindow2 = [-10 15];
        plotWindow3 = [-15 15];
        plotWindow4 = [98 115];
end

% ファイルを選択する
disp('please select .fig file of each timing each synergy!!!!')
[fileNames, pathName] = uigetfile('*.fig','Select 16 fig files','MultiSelect','on');
if ~iscell(fileNames) % ファイルが1つだけの場合にcellになっていないので、cellに変換する
    fileNames = {fileNames};
end
% figファイルを読み込む
for i = 1:length(fileNames)
    figFileName = fileNames{i}; % figファイル名を取得
    figPath = fullfile(pathName, figFileName); % figファイルのパスを生成
    figHandles(i) = openfig(figPath); % figファイルを開く
end

% 4×4の画像ファイルにまとめる
nRows = 4; % 行数
nCols = 4; % 列数
figIndex = 1;
figure('Position',[100 100 1800 1200]);

for i = 1:nRows
    for j = 1:nCols
        subplot(nRows,nCols,figIndex);
        figHandle = figHandles(figIndex); %figデータの取り出し
        %↓画像の取得とsubplotへのコピー
        figAxes = findall(figHandle, 'type', 'axes'); 
        copyobj(get(figAxes,'children'), gca); 
        current_figure = gcf;
        plotWindow = eval(['plotWindow' num2str(j)]);
        current_figure = figure_decorate(current_figure,plotWindow,i,j);
        figIndex = figIndex + 1;
    end
end
% 画像ファイルを保存する
saveas(gcf, [pathName 'all_timing_synergy.fig']);
saveas(gcf, [pathName 'all_timing_synergy.png']);
close all;

%% internal function
function a = figure_decorate(current_figure,plotWindow,i,j)
        figure(current_figure)
        title(['tirg' num2str(j) ' Synergy' num2str(i)],'FontName', 'Arial','FontWeight', 'bold')
        ylim auto
        xlim(plotWindow);
        xlabel('task range [%]')
        ylabel('coefficient')
        a = gca;
        a.FontWeight = 'bold';
        a.FontName = 'Arial';
end