function [Elapsed_date] = CountElapsedDate(exp_day,reference_day)
%���̊֐��̊T�v�������ɋL�q
%���͂Ƃ��Ď󂯎����double�^�̓��t(��:20220801)���Areference_day���牽���o�߂������t�Ȃ̂����v�Z���A�o�ߓ������o�͂���
%{
exp_day: type => double (ex.)20220801
reference_day: type => datatime(you can create this data type object by using 'trans_calrender.m')
%}
    analyzed_date = trans_calrender(exp_day);
    Elapsed_date = between(reference_day,analyzed_date,'Days');
end

