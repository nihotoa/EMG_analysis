%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last modification : 2023/03/02

�yfunction�z
�Egui��16�̐}��ǂݍ����(4�V�i�W�[*4�^�C�~���O)Uchida�����appendix�̐}�̂悤�Ȍ`�ŁC�o�͂���

�y�ۑ�_�z
�E�ėp�����Ⴂ(16�Ɍ����Ă���)�̂ŉ��P����
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

% �t�@�C����I������
disp('please select .fig file of each timing each synergy!!!!')
[fileNames, pathName] = uigetfile('*.fig','Select 16 fig files','MultiSelect','on');
if ~iscell(fileNames) % �t�@�C����1�����̏ꍇ��cell�ɂȂ��Ă��Ȃ��̂ŁAcell�ɕϊ�����
    fileNames = {fileNames};
end
% fig�t�@�C����ǂݍ���
for i = 1:length(fileNames)
    figFileName = fileNames{i}; % fig�t�@�C�������擾
    figPath = fullfile(pathName, figFileName); % fig�t�@�C���̃p�X�𐶐�
    figHandles(i) = openfig(figPath); % fig�t�@�C�����J��
end

% 4�~4�̉摜�t�@�C���ɂ܂Ƃ߂�
nRows = 4; % �s��
nCols = 4; % ��
figIndex = 1;
figure('Position',[100 100 1800 1200]);

for i = 1:nRows
    for j = 1:nCols
        subplot(nRows,nCols,figIndex);
        figHandle = figHandles(figIndex); %fig�f�[�^�̎��o��
        %���摜�̎擾��subplot�ւ̃R�s�[
        figAxes = findall(figHandle, 'type', 'axes'); 
        copyobj(get(figAxes,'children'), gca); 
        current_figure = gcf;
        plotWindow = eval(['plotWindow' num2str(j)]);
        current_figure = figure_decorate(current_figure,plotWindow,i,j);
        figIndex = figIndex + 1;
    end
end
% �摜�t�@�C����ۑ�����
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