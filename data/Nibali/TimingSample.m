%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�֐�DefineTask.m�̐��\��]�����邽�߂̊֐��B���p�I�ȈӖ��͂Ȃ�
%�J�����g�f�B���N�g����Nibali�ɂ��Ďg�p����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% Set Parameters
monkey_name = 'Ni';
exp_day = 220208;
save_fold = 'nmf_result';

%% conduct function
cd(num2str(exp_day));
DefineTask(monkey_name,exp_day,save_fold)
