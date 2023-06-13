%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
�yexplanation�z
�y���P�_�z
exp_day��days�̈Ⴂ�𖾂炩�ɂ���
�ycaution!!�z
�Echanging param(in plotSynergyAll_Uchida.m)
pre_frame, synergy_type
�yprocedure�z
pre:makefold.m
post:EMG_correlation
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set param
monkey_name = 'Ni';
trim_package.type = 'trimmed'; %(analysis_type = 'all_data'�̎��Ɏg�p����)�ǂ̃^�C�~���O�Ƀt�H�[�J�X���āA���o���� ������tim3�����Ή����Ă��Ȃ�
analysis_type = 'trimmed'; %'all_data' or 'trimmed' (�؃V�i�W�[�f�[�^���A�S�̂���̂��̂Ȃ̂��A�g���~���O���ꂽ���̂���Ȃ̂�)����{'trimmed'�ł���
%���S�̃f�[�^����v���b�g����Ƃ��Ɏg���ϐ��C(�t�c�[�͎g��Ȃ�)
trim_package.pre_frame = 300;
trim_package.post_frame = 400;
setting_days = 0; %0:�蓮��days��ݒ肵���Ƃ� 1:devide_info������t��ݒ肵���Ƃ�(���������O���t��f�B���N�g���̖��O�����肷��Ƃ��ɁAdevide_info���g�p�������Ƃ��킩��悤�ɂ�����)
type = '_filtNO5';% _filt05 means'both' direction filtering used 'filtfilt' function
days = [...%pre-surgery
%           20220420
%         20221004;...
%         20221005;...
%         20221007;...
%         20221012;...
%         20221026;...
%         20221027;...
%         20221028;...
%         20221031;...
%         20221107;...
%         20221108;...
%         20221109;...
%         20221201;...
%           20230208;...
%           20230209;...
%           20230210;...
%         20230220
%         20230221
%          20230222
%         20230224
%         20230227
%           20230511
%           20230512
%           20230524
        20230524
        20230529
        ];

%% code section
if setting_days == 1
    load([pwd '/' 'devide_info' '/' 'all_day_trial.mat'], 'trial_day'); %�S�Ă̎������̓��t���X�g�����[�h����
    days = GenerateTargetDate(trial_day ,'all',0,1000,pwd); %��͂�����t��cell�z��Ɋi�[���邽�߂̕ϐ��D����܂�C�ɂ��Ȃ�
end

     
Ld = length(days);
     
for ii = 1:Ld
    exp_day = days(ii);
    fold_name = [monkey_name sprintf('%d',days(ii))];
    %sprintf('%d',days(ii)) days(ii)��sprint�^�ɕϊ�
    synergyplot_func(fold_name,monkey_name,exp_day,analysis_type,trim_package);
end
