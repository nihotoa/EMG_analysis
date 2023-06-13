%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LastModification 23/03/16 
% Coded by: Naohito Ohta
% how to use: Nibali���J�����g�f�B���N�g���ɂ��Ďg���BNMFbtcOya�����s���āANMF�f�[�^���������Ɏ��s����
% monkeyname,xpdate,EMG_numlist���w�肵�Ď��s����Ɠ��t�t�H���_ �� nmf_result��filtNO5�t�H���_������Ă����
% filtNO5�ɂ�SYNERGYPLOT�Ŏg�p����t�@�C��2��,SYNERGYPLOT�̉�͌��ʂ�ۑ�����f�B���N�g�������݂���
%�y���ɒ��ӂ���p�����[�^�z
% EMG_type �� filtNO5�t�H���_�̖������Ɏg����
% add_info �� makeEMGNMF_btcOhta�ō쐬���ꂽ�t�@�C��((ex.) MATLAB/data/Nibali/20221005/nmf_result/Ni20221005_standard/Ni20221005_standard_NoFold_tim3_pre-300_post-100.mat)
%�@��_NoFold_tim3_pre-300_post-100�̕������R�s�y����
%�y�ۑ�_�z
%�p�����[�^�ݒ肪�_�����DUI�Ŏg�p����f�[�^��I���ł���悤�ɂ���
%�yprocedure�z
%pre: makeEMGNMF_btcOhta(or Oya).m
%post: SYNERGYPLOT.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%% set param
setting_xpdate = 0; %0:�蓮��xpdate��ݒ肵���Ƃ� 1:devide_info������t��ݒ肵���Ƃ�(���������O���t��f�B���N�g���̖��O�����肷��Ƃ��ɁAdevide_info���g�p�������Ƃ��킩��悤�ɂ�����)
xpdate = [20230526, 20230529]; %(setting_xpdate��0�̎�)�蓮�Őݒ�
monkeyname = 'Ni';
EMG_type = 'task'; %�؃V�i�W�[���o�ɗp����EMG�̃^�C�v(tim1:�^�C�~���O1���� tim2:�^�C�~���O2����tim3:�^�C�~���O3���� task:�^�X�N�S��)
all_data = 0; %�S�̃f�[�^����؃V�i�W�[��͂����Ƃ�,1�ɂ���(EMG_type��task�̂Ƃ��̃I�v�V����)
% add_info = '_NoFold_tim3_pre-300_post-100'; %�؃V�i�W�[��MAT�t�@�C�����ɋL�q����Ă��鏈���̏ڍ�(standard�̌ォ��),�Y���ӏ���ǂݍ��ރR�[�h�������̂���ԂȂ̂ł����Ŏ蓮�Œ�`����
% key_sentence = 'NoFold_TimeNormalized';  %(ex.)'post_lpHz_20(lp_first)_NoFold_tim3_pre-300_post-100'
EMG_numlist = 9;
%% code section
original_dir = pwd;
if setting_xpdate == 1
    load([pwd '/' 'devide_info' '/' 'all_day_trial.mat'], 'trial_day'); %�S�Ă̎������̓��t���X�g�����[�h����
    xpdate = GenerateTargetDate(trial_day, 'all', 0, 1000, pwd); %��͂�����t��cell�z��Ɋi�[���邽�߂̊֐��D����܂�C�ɂ��Ȃ�
end

% cd([num2str(xpdate) '/nmf_result'])
%�t�H���_���̌���
switch EMG_type
    case 'tim1'
        fold_name = ['_standard_filtNO5_tim1'];
    case 'tim2'
        fold_name = ['_standard_filtNO5_tim2'];
    case 'tim3'
        fold_name = ['_standard_filtNO5_tim3'];
    case 'tim4'
        fold_name = ['_standard_filtNO5_tim4'];   
    case 'task'
        if all_data == 1
           fold_name = '_standard_filtNO5_allData_task';
        else
            fold_name = '_standard_filtNO5_TimeNormalized_task';
        end
end
%��EMG_type�ɉ����āA�؃V�i�W�[��͗p�̃f�B���N�g�����쐬
for ii = 1:length(xpdate)
    save_fold = [original_dir '/' num2str(xpdate(ii)) '/' 'nmf_result' '/' monkeyname num2str(xpdate(ii)) fold_name];
    if not(exist(save_fold)) %�����̃t�@�C��������
        mkdir(save_fold)
    end
    nmf_fold = [save_fold '/' monkeyname num2str(xpdate(ii)) '_syn_result_' sprintf('%02d',EMG_numlist)];
    if not(exist(nmf_fold))
        mkdir(nmf_fold)
        mkdir([nmf_fold '/' monkeyname num2str(xpdate(ii)) '_W'])
        mkdir([nmf_fold '/' monkeyname num2str(xpdate(ii)) '_H'])
        mkdir([nmf_fold '/' monkeyname num2str(xpdate(ii)) '_VAF'])
        mkdir([nmf_fold '/' monkeyname num2str(xpdate(ii)) '_r2'])
    end

    if ii == 1
        %��O�̊֐�(NMF)�œ���ꂽ2�̃t�@�C����I�������t�f�B���N�g���͂ǂ�ł�����
        disp('�yPlease select 2 files which is created by pre function!!�z')
        disp('(ex.)F:\MATLAB\data\Nibali\20220420\nmf_result\Ni20220420_standard\Ni20220420_standard_NoFold_TimeNormalized & t_Ni20220420_standard_NoFold_TimeNormalized')
        [use_file_list, pathName] = uigetfile(['*.mat'],'Select a file',pwd,'MultiSelect','on');
        temp = regexp(pathName, '\d+', 'match');
        num_part = temp{1};
    end
    pathNameEx= strrep(pathName, num_part, num2str(xpdate(ii)));
    cd(pathNameEx)
    use_file_listEx =  strrep(use_file_list, num_part, num2str(xpdate(ii)));
    
    if strcmp(['t_' use_file_listEx{1}], use_file_listEx{2})
        copyfile(use_file_listEx{1},[monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '.mat'])
        copyfile(use_file_listEx{2},[monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '_nmf.mat'])
    else
        copyfile(use_file_listEx{2},[monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '.mat'])
        copyfile(use_file_listEx{1},[monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '_nmf.mat'])
    end
    movefile([monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '.mat'], '../');
    movefile([monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '_nmf.mat'], '../');
    cd ../
    %��������2�̃f�[�^���w�肵�����̊K�w�Ɉڂ�
    movefile([monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '.mat'],[monkeyname num2str(xpdate(ii)) fold_name]);
    movefile([monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '_nmf.mat'],[monkeyname num2str(xpdate(ii)) fold_name]);
end
cd(original_dir)
