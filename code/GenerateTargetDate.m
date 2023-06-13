%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Nibali�̂��߂����̃R�[�h�Ȃ̂ŁC�ėp�������߂�
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Target_date = GenerateTargetDate(Target_date,analyze_period,minimum_trial,max_trial,monkey_dir)
    try
        %���������ł͂Ȃ����A�g���C�A���f�[�^�������Ă�����t����������
        removed_day = [20220301, 20220324, 20220414 20220607]; 
        load([monkey_dir '/' 'devide_info' '/' analyze_period '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat'])
        Target_date = transpose(intersect(Target_date,trial_day));
        Target_date = setdiff(Target_date, removed_day);
    catch
        error([analyze_period '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat �����݂��܂���.DevideExperimet.m�����s���āA�t�@�C�����쐬���Ă�������'])
    end
end