function [Elapsed_date] = CountElapsedDate(exp_day,reference_day)
%���̊֐��̊T�v�������ɋL�q
%���͂Ƃ��Ď󂯎����double�^�̓��t(��:20220801)���Areference_day���牽���o�߂������t�Ȃ̂����v�Z���A�o�ߓ������o�͂���
%���ӓ_:���͈���reference_day��datetime�^����Ȃ��ƃ_��(���炩����trans_calrender.m��p���č쐬���Ă�������)
    analyzed_date = trans_calrender(exp_day);
    Elapsed_date = between(reference_day,analyzed_date,'Days');
end

