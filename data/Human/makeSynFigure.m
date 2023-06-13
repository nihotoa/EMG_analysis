%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
【未完成】
coded by: Naohito Ota
laset modification: 2023.05.12
【function】
・パワポでまとめるのが鬱陶しいため，筋シナジーを一つのグラフにまとめる
【procedure】
pre: temp_SynergyAnalysis.mat
post:?
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
syn_num = 4;
%% code section
%Wのプロット
W_dir = uigetdir;
W_fig_list = dir([W_dir '/*.fig']);

% 4x2のsubplotを作成
figure('Position',[100 100 1280 720]);
for i = 1:syn_num*2
    subplot(syn_num, 2, i)
    % i番目のfigureファイルを読み込んで、axesにコピー
    fig = openfig([W_dir '/' W_fig_list(i).name]);
    ax = gca;
    copyobj(allchild(fig), ax);
end

saveas(fig,'output_figure.fig');


