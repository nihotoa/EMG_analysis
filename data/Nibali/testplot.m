%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
極座標プロットを確認するためのテストコード
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%% code section
% データの準備
theta = linspace(0, 2*pi, 16+1);  % 角度の配列(16だと0度と３６０度で値がバッティングしてしまうため)
rho = rand(1, 16);                % 値の配列
rho(end+1) = rho(1); %閉じるため
labels = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P'};  % 名前の配列
labels{end+1} = labels{1}; %閉じるため

% 極座標プロット
f1 = figure('Position',[100,100,1200,800]);
p = polarplot(theta, rho, '-', 'LineWidth', 3,'Color','r');  % プロット
thetaticks(rad2deg(theta));  % 角度軸の目盛りを設定
thetaticklabels(labels);     % 角度軸のラベルを設定
%図の装飾
% ラベルのフォントサイズと色を変更
ax = gca;                        % 現在の軸オブジェクトを取得
ax.FontSize = 20;  % ラベルのフォントサイズを設定
rlim([0 2]) %極座標のrの範囲
close all;

