%% Copy_of_sample_data_walkthrough�Ŏg����֐�,EMG1�̃f�[�^�s��START_NUM��EMG32�̃f�[�^�s��END_NUM�ɑ�����ĕԂ�
function [start_num,end_num] = get_EMG_file_num(hFile)
    for ii = 1:size(hFile.Entity,2)
        a{ii,1} = hFile.Entity(1,ii).Label;
    end
    b=string(a);
    start_num = find(b=='emg 1');
    end_num = find(b=='emg 32');
end

