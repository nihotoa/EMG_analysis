function [calender_day] = trans_calrender(exp_day)
%TRANS_CALRENDER 
%   �ڍא����������ɋL�q double�^�̓��t(��)20220801����͂Ƃ���,datatime�^�ɕϊ����ĕԂ��֐�.(�������̌o�ߓ����̎Z�o�ɕK�v�Ȃ��ߍ����)
    exp_day = string(exp_day); %string�^�֕ϊ�
    temp = char(exp_day);
    %�N�����ɕ�����
    year = str2double(string(temp(1:4)));
    month = str2double(string(temp(5:6)));
    day = str2double(string(temp(7:8)));
    
    % change to calender type
    calender_day = datetime(year,month,day);
end

