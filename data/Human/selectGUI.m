%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by : Naohito Ohta
Last Modification : 2023.03.27
�yfunction�z
�g�p����f�[�^��GUI�őI�����邽�߂̊֐��D
(�p�ɂɎg���̂Ŋ֐�������)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fileNames,pathName] = selectGUI(patient_name,restrict_name)
select_dir = [pwd '/' patient_name];
% �t�@�C����I������
switch nargin
    case 1
        disp('please select .csv file (which is used to analyze)')
        [fileNames, pathName] = uigetfile('*.csv',select_dir,'MultiSelect','on');
    case 2
        %restrict_name �� GUI�őI�ׂ�mat�t�@�C�������肷�� 'EMG'/'Marker'
        if strcmp(restrict_name, 'none')
            [fileNames, pathName] = uigetfile('*.mat',select_dir,'MultiSelect','on');
        else
%             disp(['please select .mat file of ' restrict_name ' (which is used to analyze)'])
            [fileNames, pathName] = uigetfile(select_dir,'MultiSelect','on');
        end
end
end

