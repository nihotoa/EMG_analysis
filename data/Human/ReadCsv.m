%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last Modification:2023.05.01
�yprocedure�z
pre:nothing
post:ExtractEMGData.m or SuccessTiming_func.m

�yfunction�z
�E���搶����������csv�f�[�^��,.mat�t�@�C���ɕϊ����ē����f�B���N�g���ɕۑ����邽�߂̃R�[�h
�E���ׂĂ�csv�t�@�C����I�Ԃ���(motion�f�[�^���I�Ԃ���)
�E�����K���̂��߂̕ϐ����̕ύX�͋N�������G���[�ɑ΂��Čp�������ŏ����ݒ肵�Ă���̂ŐV���Ȗ�肪���������Ƃ��͂���ɑΉ��ł���悤�Ɍp����������
�y���ӓ_�z
readmatrix���C2019�ȍ~��MATLAB�o�Ȃ��Ǝg���Ȃ�
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
EMG_start_matrix = [6,3]; %csv�t�@�C���̕K�v�ȕ��������𒊏o���邽�߂ɁCstart�̃Z����I��
Marker_start_matrix = [6,3];
%% code section
[fileNames,pathName] = selectGUI(patient_name);
%���f�[�^���Z�[�u����t�H���_�̐ݒ�(�����csv�t�@�C���Ɠ����ꏊ)
save_fold = pathName;

% �t�@�C�����ƂɃf�[�^��ǂݍ���ŁA�t�@�C�����Ɠ����̕ϐ��ɑ������
for i = 1:length(fileNames)
    filename = fileNames{i}; % �X�̃t�@�C������
    variable_name = strrep(filename, '.csv', ''); % �g���q�����������O
    filePath = fullfile(pathName, filename);
    if contains(filePath,'Traj')
        start_row = Marker_start_matrix(1);
        start_col = EMG_start_matrix(2);
    else
        start_row = EMG_start_matrix(1);
        start_col = EMG_start_matrix(2);
    end
    %csv�t�@�C���̂���Ȃ�������[�܂邽�߂̏���
    opts = detectImportOptions(filePath);
    opts.DataLines = [start_row,Inf]; %����Ȃ��s������
    %���f�[�^�̑��
    data = readmatrix(filePath,opts); % csv�t�@�C���̃f�[�^��ǂݍ���
    data = data(:,start_col:end); %����Ȃ�����폜
    %�����K��������悤�ɕϐ�����ύX(.�Ƃ��͕ϐ����Ɋ܂܂��邱�Ƃ��ł��Ȃ��̂ŕύX)
    if contains(variable_name,'.') %�?字�?�に.を含�?場�?
        variable_name = strrep(variable_name,'.','_');
    end
    if isstrprop(variable_name(1), 'digit') %接頭語が数字�?�場�?
        variable_name = strrep(variable_name,[variable_name(1) 'th'],'');
    end
    if contains(variable_name,' ') %�?字�?�に を含�?場�?
        variable_name = strrep(variable_name,' ','_');
    end
%     assignin('base', variable_name, data); % 変数に�?ータを代入する   
    %�?ータのセー�?
    
    save([save_fold variable_name],'data')
end
