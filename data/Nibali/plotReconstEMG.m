%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last modification: 2023.02.15
[function]
plot & save the figure about reconst EMG
[how to use]
please change 'exlp_day' & 'tt'
まだ全然対応していない
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% code section
load('t_Ni20230208_standard_NoFold_TimeNormalized.mat');
EMG_num = length(W);
for tt = 15:16 %使用するシナジー数
    plot_reconstEMG(EMG_num,W,H,tt)
    %セーブ設定(場所とか名前とか)
%    save_fold = []
%    saveas(gcf,'sample.png')
    close all;
end

%% define function
function [] = plot_reconstEMG(EMG_num,W,H,tt)
W_synergy = W{tt};
H_synergy = H{tt}; 
reconst_EMG = W_synergy * H_synergy;
figure('Position',[100,100,1200,800]);
for ii = 1:EMG_num
    subplot(4,4,ii)
    plot(reconst_EMG(ii,:))
    hold on
    ylim([0,2])
    hold off
end
end