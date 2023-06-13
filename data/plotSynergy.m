
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last modification : 2023/03/07

【function】
・guiで16個の図を読み込んで(4シナジー*4タイミング)Uchidaさんの修論のappendixの図のような形で，出力する

【caution!!!】
please set current dir as 'data'
【課題点】
・汎用性が低い(16個に限られている)ので改善する
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
monkey_name = 'SesekiL';
y_scale_type = 4; %1:Yachimun-pre 2:Yachimun-post 3:SesekiL-pre 4:SesekiL-post
%% code section
select_dir = [pwd '/' monkey_name '/' 'easyData/P-DATA'];
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

switch y_scale_type
    
    case 1
        y_scale = [2 2 5 3 2 5 2 3 2 3 3.5 1.5 3 3 3 2] * 0.6;
    case 2
        y_scale = [2 3 3.5 1.4 2 5 2 3 3 3 3 2 2 2 5 3] * 0.5;
    case 3
        y_scale = [2.5 1 1.5 1.5 1.5 1.5 1.5 1.5 2.5 1 1 1 2.5 1.5 1.5 1.5];
    case 4
        y_scale = [2.5 1 1.5 1.5 1.5 1.5 1.5 1.5 2.5 1 1 1 2.5 1.5 1.5 1.5];
end
%[]
% ファイルを選択する
disp('please select .fig file of each timing each synergy!!!!')
% [fileNames, pathName] = uigetfile('*.fig','Select a file',select_dir,'Select 16 fig files','MultiSelect','on');
[fileNames, pathName] = uigetfile('*.fig','Select a file',select_dir,'MultiSelect','on');
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
        current_figure = figure_decorate(current_figure,plotWindow,i,j,y_scale(figIndex));
        figIndex = figIndex + 1;
    end
end
% 画像ファイルを保存する
saveas(gcf, [pathName 'all_timing_synergy.fig']);
saveas(gcf, [pathName 'all_timing_synergy.png']);
close all;

%% internal function
function a = figure_decorate(current_figure,plotWindow,i,j,y_scale)
        figure(current_figure)
        title(['tirg' num2str(j) ' Synergy' num2str(i)],'FontName', 'Arial','FontWeight', 'bold')
        ylim([0 y_scale])
        xlim(plotWindow);
        xlabel('task range [%]')
        ylabel('coefficient')
        a = gca;
        a.FontWeight = 'bold';
        a.FontName = 'Arial';
end