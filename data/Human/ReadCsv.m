%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last Modification:2023.05.01
�yprocedure�z
pre:nothing
post:SuccessTiming_func.m

�y�O�����z
�E���҂���̃f�B���N�g�������ɓ��t�̃f�B���N�g�����쐬���āCcsv�t�@�C����u���Ă�������

�yfunction�z
�E���搶����������csv�f�[�^��,.mat�t�@�C���ɕϊ����ē����f�B���N�g���ɕۑ����邽�߂̃R�[�h
�Ecsv�t�@�C���͊��Җ� => ���t �̒��ɓ����Ă��܂�(ex.) patientB => post1 => �R�R!!
�E�t�@�C����I�������ʂ��o����,���ׂĂ�csv�t�@�C����I�Ԃ���(����f�[�^���I�Ԃ���)
�E�t�@�C���̕����I���̕��@�̓O�O���Ă�������(Mac����command�����Ȃ���I��)
�y���ӓ_�z
readmatrix���C2019�ȍ~��MATLAB�o�Ȃ��Ǝg���Ȃ�
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
EMG_start_matrix = [6,3]; %csv�t�@�C���̕K�v�ȕ��������𒊏o���邽�߂ɁCstart�̃Z����I��(��{�I�ɃC�W��Ȃ��Ă���)
Marker_start_matrix = [6,3]; %��{�I�ɃC�W��Ȃ��Ă���
%% code section
%csv�t�@�C����I��(�����I���\)
disp('��͂Ɏg�p���邷�ׂĂ�csv�t�@�C����I��ł�������')
[fileNames,pathName] = selectGUI(patient_name);
%���f�[�^���Z�[�u����t�H���_�̐ݒ�(�����csv�t�@�C���Ɠ����ꏊ)
save_fold = pathName;

% �t�@�C�����ƂɃf�[�^��ǂݍ���ŁA�t�@�C�����Ɠ����̕ϐ��ɑ������
for i = 1:length(fileNames)
    filename = fileNames{i}; % �X�̃t�@�C�������擾
    variable_name = strrep(filename, '.csv', ''); % �g���q�����������O
    filePath = fullfile(pathName, filename);
    if contains(filePath,'Traj') %����̃f�[�^�Ȃ��
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
    try
        data = readmatrix(filePath,opts); % csv�t�@�C���̃f�[�^��ǂݍ���
        data = data(:,start_col:end); %����Ȃ�����폜
    catch %�G���[�����������ꍇ
        data = readmatrix(filePath);
        data = data(4:end, 3:end);
    end
    %�����K��������悤�ɕϐ�����ύX(.�Ƃ��͕ϐ����Ɋ܂܂��邱�Ƃ��ł��Ȃ��̂ŕύX)
    if contains(variable_name,'.') %.��_�ɕϊ�����
        variable_name = strrep(variable_name,'.','_');
    end
    if isstrprop(variable_name(1), 'digit') %variable_name�̐ړ��ꂪ1th�Ƃ��̏ꍇ�͏���.
        variable_name = strrep(variable_name,[variable_name(1) 'th'],'');
    end
    if contains(variable_name,' ') %�󏊂�_�ɕϊ�����
        variable_name = strrep(variable_name,' ','_');
    end
    % �f�[�^�̃Z�[�u
    save([save_fold variable_name],'data')
end
