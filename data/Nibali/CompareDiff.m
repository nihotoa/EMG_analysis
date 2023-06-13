%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
�y������(�v�����ʂ�̌��ʂɂȂ�Ȃ�)�z
�؃V�i�W�[�̋�Ԋ��̏d�݂Ƒ��ݑ��֌W���̕ω����r����O���t���쐬���邽�߂̊֐�
Nibali��cd�ɂ��Ďg�p����
�ۑ�:
�}�̃Z�[�u
�}�ւ̖}��̒ǉ�
�f�[�^�������������ؓ����ƃf�[�^�̑Ή��Â��������Ă��邩�ǂ����H(����,��ԃV�i�W�[�̃f�[�^)
NaN�l���ׂ��ŁA�������ԕ��@
��U�ۗ�(Yachimun�̕����D��x����)
pre:EMG_correlatioon.m
post:nothing(coming soon!)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
%% set param
Target_date =  [20220728 20220729 20220802 20220803 20220804 20220805 20220809 20220810 20220812 20220815 20220816 20220817 20220819 ...
                20220825 20220826 20220830 20220831 20220901 20220906 20220907 20220908 20220909 20220913 20220915 20220916 20220920];
start_day = 20220420; %experiment start day
reference_day = 20220530; %surgery day
reference_muscles = {'FDS-A','FDS-B'}; %�ǂ̋ؓ��ɑ΂��鑊�ݑ��ւ̒l���A���̉�͂Ɏg�p���邩�H(�����I����)
EMG_type = 'tim3';
synergy_num = 2;
EMG_num = 16; %���[�N�X�y�[�X�ϐ����璊�o���Ă��ǂ��������A�ǐ��̂��߂Ɏ蓮�Őݒ� 
%% code section
% 1.Target_date��,reference_day����̌o�ߓ������v�Z����
reference_cal_day = trans_calrender(reference_day);
day_info = cell(3,length(Target_date));
for ii = 1:length(Target_date)
    [Elapsed_date] = CountElapsedDate(Target_date(ii),reference_cal_day);
    day_info{1,ii} = Target_date(ii);
    day_info{2,ii} = split(Elapsed_date,'days');
end

%2.�g�p���鑊�ݑ��ւ̃f�[�^��ǂݍ���
for ii = 1:length(reference_muscles)
    reference_muscle = reference_muscles{ii};
    file_list = dir('compare_diff');
    for jj = 1:length(file_list)
        if contains(file_list(jj).name,reference_muscle)
            load(['compare_diff/' file_list(jj).name])
            x_corr_data{ii,1} = ['vs ' reference_muscle] ;
            x_corr_data{ii,2} = all_xcorr;
        end
    end
end

%3.�g�p�����ԃV�i�W�[�̃f�[�^��ǂݍ���
load('compare_diff/W_synergy.mat')

%4.�ǂݍ��񂾋؃V�i�W�[�f�[�^�ƁAx_corr�f�[�^�̃f�[�^�\�����v���b�g�p�ɐ�����
% ����ԃV�i�W�[�f�[�^�ŁA���t���l������悤�ɁA�f�[�^�����ւ���
for ii = 1:synergy_num
    for jj = 1:EMG_num
        eval(['W' num2str(ii) '_sel = NaN(day_info{2,end},1);'])
        for kk = 1:length(day_info)
            eval(['W' num2str(ii) '_sel(day_info{2,kk}) = W_synergy' num2str(ii) '{jj,2}(kk);'])
            % W1(day_info(2,kk)) = W_synergy1{1,2}(kk)
        end
        if jj == 1 %W1�̃Z���z������
            eval(['W' num2str(ii) ' = cell(EMG_num,2);'])
            %���ؓ��̖��O����1��ڂɑ�����čs��
            for ll = 1:EMG_num
                eval(['W' num2str(ii) '{ll,1} = W_synergy1{ll,1};'])
            end
        end
        eval(['W' num2str(ii) '{jj,2} = W' num2str(ii) '_sel;'])
    end
end

%x-corr�f�[�^�ŁApre�̓��t���l�����Ȃ��悤�Ƀf�[�^�����ւ���
start_calrender = trans_calrender(start_day);
eliminated_day = CountElapsedDate(reference_day,start_calrender);
for ii = 1:length(reference_muscles)
    for jj = 1:EMG_num 
        x_corr_data{ii,2}{jj,2}(1:split(eliminated_day,'days')+1) = [];
    end
end

%5.�����l���v�Z������,���K������
 %W_synergy�ɂ���
for ii = 1:synergy_num
    for jj = 1:EMG_num
        used_data = eval(['W' num2str(ii) '{jj,2};']);
        diff_data = special_diff(used_data);
        if jj == 1 %W1�̃Z���z������
            eval(['W' num2str(ii) '_diff = cell(EMG_num,2);'])
            %���ؓ��̖��O����1��ڂɑ�����čs��
            for kk = 1:EMG_num
                eval(['W' num2str(ii) '_diff{kk,1} = W_synergy1{kk,1};'])
            end
        end
        eval(['W' num2str(ii) '_diff{jj,2} = diff_data;'])
    end
end
 %���K��(��Βl���������A���ςŊ���)
 for ii = 1:synergy_num
     for jj = 1:EMG_num
         average_value = nanmean(abs(eval(['W' num2str(ii) '_diff{jj,2}'])));
         eval(['W' num2str(ii) '_diff{jj,2} = abs(W' num2str(ii) '_diff{jj,2})/average_value;'])
     end
 end

 %x_corr�ɂ���
for ii = 1:length(reference_muscles)
    for jj = 1:EMG_num
        used_data = x_corr_data{ii,2}{jj,2};
        diff_data = special_diff(used_data);
        if jj == 1
            x_corr_diff{ii,1} = reference_muscles{ii};
            for ll = 1:EMG_num
                x_corr_diff{ii,2}{ll,1} = W_synergy1{ll,1};
            end
        end
        %eval(['W1_diff{jj,2} = diff_data;'])
        x_corr_diff{ii,2}{jj,2} = diff_data;
    end
end
  %���K��(��Βl���������A���ςŊ���)
for ii = 1:length(reference_muscles)
    for jj = 1:EMG_num
        average_value = nanmean(abs(x_corr_diff{ii,2}{jj,2}));
        x_corr_diff{ii,2}{jj,2} = abs(x_corr_diff{ii,2}{jj,2})/average_value;
    end
end

%�v���b�g����
for ii = 1:length(reference_muscles) %���摜�̌�
    h = figure;    
    h.WindowState = 'maximized';
    %title(['compare multi data(vs)' reference_muscles{ii}],'FontSize',20)
    for jj = 1:EMG_num
        subplot(4,4,jj)
        hold on;
        plot(x_corr_diff{ii,2}{jj,2},'o')
        for kk = 1:synergy_num
            plot(eval(['W' num2str(kk) '_diff{jj,2}']),'o')
        end
        title(x_corr_diff{ii,2}{jj,1},'FontSize',24)
        xlim([0 round(length(diff_data),-1)])
        hold off
    end
    %���}�S�̂ւ̃^�C�g���}��
    sgt = sgtitle(['compare multi data(vs ' reference_muscles{ii} ')'],'FontSize',35);
    %�������ɃZ�[�u�̂��߂̃R�[�h������
    
    close all;
end


%% create local function
%��NaN�l��������������
function diff_data = special_diff(data)
    diff_data = NaN(length(data)-1,1); 
    hold_value = 0;%�ۗ��l
    count = 0;
    for ii = 2:length(data)
        if isnan(data(ii))
            count = count + 1; %�A������NaN����������
        elseif not(isnan(data(ii))) %NaN�l����Ȃ�������        
            if hold_value == 0 %���߂Ēl����������
                diff_data(ii-1) = NaN;
                count = 0;%count��0�ɖ߂�
                hold_value = data(ii);
            else %����ȑO�ɒl���������o�������鎞
                diff_data(ii-1) = (data(ii) - hold_value)/(count+1);
                count = 0; %count��0�ɖ߂�
                hold_value = data(ii);
            end
        end
    end
end