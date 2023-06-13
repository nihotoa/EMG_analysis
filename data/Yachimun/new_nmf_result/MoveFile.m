%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
���c��������֐�
makeEMGNMF�Ő������ꂽ�t�@�C����1�ӏ��ɕۑ�����Ă���(ex. Yachimun -> new_nmf_result ->dist-dist)�̂ŁA����𐳂����ꏊ�Ɉڂ��֐�
�J�����g�f�B���N�g����new_nmf_result�ɂ��Ďg�p����
�p�r��Yachimun�Ɍ��肳��Ă���̂ŁA�����Ɣėp�������߂����ꍇ�͐V�����ϐ�������ĊY���ӏ���ϐ��ɒu��������(�T�����A�g�p����ؓ��̐��Ȃ�)
pre_operate: makeEMGNMF
post_operate:SYNERGYPLOT.m
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
reference_dir = 'dist-dist';
dir_group = dir('Ya*');
first_day = 170516;
last_day = 170929;
remove_day = [170403 170510 170529 170605 170606 170607 170608 170612 170613 170614 170615 170616 170619 170620 170621 170622 170623 170627 170705 170801 170816];
muscle_num = 10;


%% code section
count = 1; 
for ii = 1:length(dir_group)
    fold_name = dir_group(ii).name;
    if contains(fold_name,'_standard_filtNO5')
        continue
    else
        experiment_day = str2double(extractAfter(fold_name,2));
        day_list(count,1) = experiment_day; 
        count = count + 1;
    end   
end

day_list = setdiff(day_list,remove_day);
day_list = rmmissing(day_list);
day_list = day_list(and(day_list >= first_day, day_list <= last_day));

% �S�Ẵf�[�^���i�[����Ă���t�H���_�ֈړ�(makeEMGNMF�̕ۑ���f�B���N�g��)
cd(reference_dir)
%�O�ׁ̈A�f�[�^�𕡐����Ă���
for ii = 1:length(day_list)
    copyfile(['Ya' num2str(day_list(ii)) '.mat'],['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '.mat'])
    copyfile(['t_Ya' num2str(day_list(ii)) '.mat'],['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '_nmf.mat'])
end
%���f�[�^��1�K�w��Ɉڂ�
for ii = 1:length(day_list)
    movefile(['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '.mat'],'../');
    movefile(['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '_nmf.mat'],'../');
end
cd ../

%�f�[�^���w�肵�����̊K�w�Ɉڂ�
for ii = 1:length(day_list)
    movefile(['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '.mat'],['Ya' num2str(day_list(ii))]);
    movefile(['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '_nmf.mat'],['Ya' num2str(day_list(ii))]);
end




