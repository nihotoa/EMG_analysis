
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last modification : 2023/03/07

�yfunction�z
�Egui��16�̐}��ǂݍ����(4�V�i�W�[*4�^�C�~���O)Uchida����̏C�_��appendix�̐}�̂悤�Ȍ`�ŁC�o�͂���

�ycaution!!!�z
please set current dir as 'data'
�y�ۑ�_�z
�E�ėp�����Ⴂ(16�Ɍ����Ă���)�̂ŉ��P����
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
% �t�@�C����I������
disp('please select .fig file of each timing each synergy!!!!')
% [fileNames, pathName] = uigetfile('*.fig','Select a file',select_dir,'Select 16 fig files','MultiSelect','on');
[fileNames, pathName] = uigetfile('*.fig','Select a file',select_dir,'MultiSelect','on');
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
        current_figure = figure_decorate(current_figure,plotWindow,i,j,y_scale(figIndex));
        figIndex = figIndex + 1;
    end
end
% �摜�t�@�C����ۑ�����
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