
%{
Coded by: Naohito Ohta
Last modification : 2022/04/28
���̃R�[�h�̎g�����F
1.�J�����g�f�B���N�g����Nibali�ɂ���
2.�K�v�ȕϐ�(monkeyname,exp_day��)��K�X�ύX����
�ȏ�𖞂�������ԂŎ��s����
�y��ɕύX����p�����[�^�z
Target_date,Target_type,EMG_type,triming_contents,pre_frame,analyze period
��EMG_type��filtered�Ȃ�,�ؓd��͂��}�[�W���A���̑��Ȃ�,�؃V�i�W�[��̓f�[�^���}�[�W��
�y�ۑ�_�z
���[�J���֐�individual_correlation�ɂ���: ylim��[0 1]�Ȃ̂͂Ȃ�([-1 1]����Ȃ���?)
�S���̋ؓ������łȂ�,���ꂼ��̋؂̋؊����̑��ւ��o��
�v�������؊��������łȂ��A�č\�����ꂽ�؊����ǂ����̑��ւ��o��
pre�O���[�v��post�O���[�v�ŕ����ďo�͂ł���悤�ɂ���
���ݑ��ւ����ȑ��ւƓ��l���̊֐��ɂ܂Ƃ߂�,�L�q�����炷
synergy_xcorr��legend�̂Ƃ��������������(pcNum == 2�ɂ����Ή��ł��Ă��Ȃ�)
�y��邱�Ɓz:
���߂����ւ��v���b�g����(EMG)
�����n���̐F���A���̌o�߂ŔZ������(or��������)�p�Ƀv���b�g����
�ؓ��S�̂ł͂Ȃ��āA�e�ؓ����Ƃ̑��֌W�������߂�
first_day��average_day��EMG_Data�̍\�����قȂ��Ă���̂𒼂�(average_day�̕��ɍ��킹��)
��^����stack���ďo��
MEMO:
�������for���Ŏg���Ƃ���char�ł͂Ȃ�string���g��(394�s�ڕt�߂��Q��)
char��string�̈Ⴂ���悭�킩��
�y���ӓ_�z
setting_Target_date = 1�̎���,���炩����DevideExperiment.m���񂵂Ă�������
�t�@�C������minimum_trial��maximum_trial�Ŏw�肵���l���܂܂�Ă��邱�Ƃ��m�F���邱��
�yprocedure�z
pre:SYNERGYPLOT.m  DevideExperiment.m(if you set setting_Target_date as 1)
post:?(coming soon)

�y�ۑ�_�z
path�Ȃǂ̒����Ȃ��Ă��܂����̂�UI�œ�����悤�ɕύX����
Target_date��UI�ŕύX�ł���悤�ɂ����ق�������
TimeNormalized�̎���H_synergy��stack�̐}�ɂ����āCxline����Ȃ��ăq�X�g�O�����̃f�[�^��ǂݍ���Ŏg�p����
�i%���P�ŉ��P�_������j
%}
clear;
%% set parameter
% necessary param
setting_Target_date = 1; %0:�蓮��Target_date��ݒ肵���Ƃ� 1:devide_info������t��ݒ肵���Ƃ�(���������O���t��f�B���N�g���̖��O�����肷��Ƃ��ɁAdevide_info���g�p�������Ƃ��킩��悤�ɂ�����)
minimum_trial = 0; %(setting_Tareget_date = 1)�̂Ƃ��Arestrict�̏���(devide_info�f�B���N�g������A.mat�t�@�C����ǂݍ��ނƂ��Ɏg�p����)
max_trial = 1000;
% Target_date = [20230208 20230220 20230221 20230222 20230224 20230227]; %���ւ����߂����Ώۂ̎�������z��ɂ܂Ƃ߂�
nmf_fold = 'nmf_result';
monkey_name = 'Ni';
fold_detail = '_standard_filtNO5_'; %�t�@�C����t�H���_�Ɋ܂܂�Ă��镶����(�`�e���)
Target_type = 'tim3'; %�ǂ̃V�i�W�[(EMG)�̑��ւ����߂邩��I������(filtered:nmf��͂ɗp����EMG�̑���,TimeNormalized:���Ԑ��K���V�i�W�[,tim1:�^�C�~���O1����̃V�i�W�[,tim2:�^�C�~���O2����̃V�i�W�[,tim3:�^�C�~���O3����̃V�i�W�[)
EMG_type = 'tim3'; %Tareget_type��filtered��I�񂾎��A�ǂ̃^�C�~���O�̋ؓd��p���邩?('tim3')
triming_contents = '_tim3_pre-300_post-100.mat'; %Target_type��filtered�̎��ɁA�ǂ�EMG���g�p���邩(tim1����:_tim1_pre-400_post200.mat,tim2����:_tim2_pre-200_post-300.mat tim3����:_tim3_pre-300_post-100.mat TimeNormalized:_TimeNormalized.mat )
line_wide=1.2; %change the width of lineT
analyze_period = 'pre'; %choose each 'pre' or 'post' or 'all'(all is used when you want to display all data (include pre & post) in one figure)��x_corr�̉�͂����鎞��'all'�ɂ���
pre_frame = 300; %�}��xline���������߂�,pre_frame��ݒ肷��(tim3:300, tim1:400)
save_xcorr = 1; %(������g�p����Ƃ��͕K��analyze_period = 'all'�Ƃ��邱��)x_corr���v�Z���A�f�[�^��}��ۑ����邩�ǂ���?(�f�o�b�O�̎��ɖ��񂱂̕��������s�����̂��ז��Ȃ̂�,�ȈՓI�ɃI�v�V�����ɂ���)
criterion_day = 'surgery_day'; %�����̊�����ǂ̓��ɐݒ肷�邩�@'pre_first'/'surgery_day'
correlation_type = 'pre_limited'; %�yanalyze_period = all�̎��z���֌W�����ǂ�����ċ��߂邩�H(pre_all:pre�f�[�^�S�̂̕���,pre_limited:pre�̒��ł�����ꂽ�f�[�^�̕���(��p�On����))
pre_range = 5; %correlation_type��pre_limited�̂Ƃ��A�p�O�������܂ł��l�����邩�H
label_FontSize = 20;

% EMG_analysis
 %stack(or average) EMG analysis
save_movie = 0; %�ؓd��͂̕ϑJ�𓮉�t�@�C���Ƃ��ĕۑ����邩�ǂ���
reference_day = 20220530; %please fill in sergery day (this is used to divide all data into two groups (pre and post))
video_framerate = 3; %stackEMG�̓�����Đ�����Ƃ��̃t���[�����[�g


%synergy_analysis
pcNum = [2]; %�g�p����؃V�i�W�[�̌�(Target_type��filtered�ł͂Ȃ���)
align_type = 'synergy_W'; %�����Ƃ̋؃V�i�W�[�𐮍�����Ƃ��ɁA�ǂ����̃V�i�W�[�ɍ��킹�邩�H(synergy_W,synergy_H)
save_figure = 1; %syenrgy_W,H,VAF�̃O���t�Ȃǂ�ۑ����邩�ǂ���

%used muscle 
EMGs=cell(16,1) ;
EMGs{1,1}= 'EDC-A';
EMGs{2,1}= 'EDC-B';
EMGs{3,1}= 'ED23';
EMGs{4,1}= 'ED45';
EMGs{5,1}= 'ECR';
EMGs{6,1}= 'ECU';
EMGs{7,1}= 'BRD';
EMGs{8,1}= 'EPL-B'; %untiled�̂Ƃ���ł������ԈႢ�����Ă���̂ŁA���������C�����Ȃ��Ƃ��������C���ł��Ȃ�
EMGs{9,1}= 'FDS-A';
EMGs{10,1}= 'FDS-B';
EMGs{11,1}= 'FDP';
EMGs{12,1}= 'FCR';
EMGs{13,1}= 'FCU';
EMGs{14,1}= 'FPL';
EMGs{15,1}= 'Biceps';
EMGs{16,1}= 'Triceps';
EMG_num = 16;

%used muscle name_detail
EMGs_detail=cell(16,1) ;
EMGs_detail{1,1}= '���w�L��-�߈�';
EMGs_detail{2,1}= '���w�L��-����';
EMGs_detail{3,1}= '2,3�w�L��';
EMGs_detail{4,1}= '4,5�w�L��';
EMGs_detail{5,1}= '�����荪��';
EMGs_detail{6,1}= '�ڑ��荪��';
EMGs_detail{7,1}= '�r�􍜋�';
EMGs_detail{8,1}= '����w�L��'; %untiled�̂Ƃ���ł������ԈႢ�����Ă���̂ŁA���������C�����Ȃ��Ƃ��������C���ł��Ȃ�
EMGs_detail{9,1}= '��w����-�߈�';
EMGs_detail{10,1}= '��w����-����';
EMGs_detail{11,1}= '�[�w����';
EMGs_detail{12,1}= '�����荪����';
EMGs_detail{13,1}= '�ڑ��荪����';
EMGs_detail{14,1}= '����w����';
EMGs_detail{15,1}= '��r�񓪋�';
EMGs_detail{16,1}= '��r�O����';


%% code section
%(setting_Target_date == 1�̂Ƃ�)�A�蓮�Őݒ肵��Target_date��devide_info���}�[�W���āA���҂𖞂���
%�V����Target_date�����
if setting_Target_date == 1
    load('all_day_trial.mat', 'trial_day'); %�S�Ă̎������̓��t���X�g�����[�h����
    Target_date = GenerateTargetDate(trial_day ,analyze_period,minimum_trial,max_trial);
end

%�K�v�ȕϐ����쐬
exp_file_num = num2str(length(Target_date));
exp_start = num2str(Target_date(1));
exp_end = num2str(Target_date(end));      
save_dir = ['control_data/' EMG_type '/' analyze_period '(' exp_start 'to' exp_end '_' exp_file_num ')']; %path of control data (this is to be concise this code)

%�����Ƃ̋؃V�i�W�[(��������EMG)�f�[�^����ɂ܂Ƃ߂�
%�����P(if���̒��g���璷)
if strcmp(Target_type,'filtered') %��͑Ώۂ�EMG�̎�
    for ii = 1:length(Target_date)
        for jj = 1:EMG_num
            %���P(path���������Cui��get�ł���悤�ɂ���)
            load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) '_standard/' EMGs{jj,1} '(uV)' triming_contents])
            EMG_Data_sel{jj,1} = Data;
        end
        EMG_Data{ii,1} = EMG_Data_sel;
    end
elseif  strcmp(Target_type,'tim1')
    for ii = 1:length(Target_date)
        %�����̑���𑼂�Target_type�̎��ɂ��ǉ����� or ���̏�������̑O�ɂ��̑�����s��
        if ii == 1
            load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim1' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'],'TargetName') %�����f�[�^�̂݁A��ԃV�i�W�[�̃v���b�g�̍ۂ̋؂̕��т̂��߂ɕK�v
            x = categorical(TargetName');
        end
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim1' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
        %����^�����܂Ƃ߂�
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim1' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'])
        all_r2{ii,1} = r2;
    end
elseif  strcmp(Target_type,'TimeNormalized') 
    for ii = 1:length(Target_date)
        %�����̑���𑼂�Target_type�̎��ɂ��ǉ����� or ���̏�������̑O�ɂ��̑�����s��
        if ii == 1
            load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'TimeNormalized_task' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'],'TargetName') %�����f�[�^�̂݁A��ԃV�i�W�[�̃v���b�g�̍ۂ̋؂̕��т̂��߂ɕK�v
            x = categorical(TargetName');
        end
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'TimeNormalized_task' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
        %����^�����܂Ƃ߂�
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'TimeNormalized_task' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'])
        all_r2{ii,1} = r2;
    end
elseif  strcmp(Target_type,'tim2') 
    for ii = 1:length(Target_date)
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim2' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
    end
elseif  strcmp(Target_type,'tim3') 
    for ii = 1:length(Target_date)
        %�����̑���𑼂�Target_type�̎��ɂ��ǉ����� or ���̏�������̑O�ɂ��̑�����s��
        if ii == 1
            load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim3' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'],'TargetName') %�����f�[�^�̂݁A��ԃV�i�W�[�̃v���b�g�̍ۂ̋؂̕��т̂��߂ɕK�v
            x = categorical(TargetName');
        end
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim3' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
        %����^�����܂Ƃ߂�
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'tim3' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '.mat'])
        all_r2{ii,1} = r2;
    end
end

if strcmp(Target_type,'filtered') %�ؓd�Ȃ��    
    if strcmp(analyze_period,'all') %pre post�S���Ђ�����߂ĉ�͂���Ƃ�
        %split 'EMG_Data' into pre and post Data
        [pre_date,post_date,Elapsed_term,surgery_day_Elapsed,pre_EMG_Data,post_EMG_Data] =  DevideEMG(Target_date,reference_day,criterion_day,EMG_Data);
        
        %calculate and display all of xcorr
        %�����P(�֐��ɂ���ׂ�)
        if save_xcorr == 1 
            %Correlation coefficient for individual data    
            h = figure;    
            h.WindowState = 'maximized';
            [EMG_save_dir, all_reference_data,x1,x2,y] = individual_correlation(EMG_num,correlation_type,pre_range,pre_date,pre_EMG_Data,EMG_Data,Elapsed_term,Target_date,surgery_day_Elapsed,EMGs,save_dir);
            close all;
            %��(x_corr coeficcient vs eachEMG)�eEMG�ɑ΂��鑊�ݑ���
            for ii = 1:EMG_num %reference_data�̕�
                reference_data = all_reference_data{ii,1};
                h = figure;    
                h.WindowState = 'maximized';
                clear all_xcorr
                all_xcorr = cell(EMG_num,2);
                for jj = 1:EMG_num %vs reference_data�̕�
                    clear correlation_value
                    correlation_value = zeros(length(Elapsed_term),1);
                    for kk = 1:length(EMG_Data) %���t���������[�v
                        vs_data = EMG_Data{kk,1}{jj,1};
                        R_array = xcorr(reference_data - mean(reference_data),vs_data - mean(vs_data),'coef'); %���K����x���̐ݒ�(lags��x�����Ǘ����Axcorr()�̒��Ő��K�����s���Ă���
                        R_xcorr = R_array(length(reference_data)+1);
                        %stem(lags,c) %���U�M���̃v���b�g�A�m�F�p������{�Ԃł͎g�p���Ȃ��Ǝv����
                        correlation_value(kk) = R_xcorr;
                    end
                    subplot(4,4,jj)
                    hold on;
                    %xline(surgery_day_Elapsed,'--r','surgery day');
                    ylim([-1 1]); grid on;
                    xlim([Elapsed_term(1) Elapsed_term(end)])
                    title(EMGs{jj,1},'FontSize',25)
                    fi1 = fill(x1, y, 'k');
                    fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
                    fi1.EdgeColor = 'none';            % remove the line around the filled area
                    plot(Elapsed_term,correlation_value,'LineWidth',1.3);
                    fi2 = fill(x2,y,'k','LineWidth',1.3);
                    fi2.FaceColor = [1 1 1];       % make the filled area
                    hold off
                    all_xcorr{jj,1} = EMGs{jj};
                    all_xcorr{jj,2} = correlation_value;
                end
                saveas(gcf,[EMG_save_dir '/corration/x_correlation(vs ' EMGs{ii} ').png']);
                %��compare_diff�ɕۑ�(CompareDiff.m�Ŏg�p����)
                save(['compare_diff/' 'x_corr(vs ' EMGs{ii} ').mat'],'all_xcorr');
                close all
            end
        else
            EMG_save_dir = [save_dir '/analyzed_EMG'];
        end
        
        %����+�W���΍��̋ؓd�̐}
        AveregeEMG(pre_EMG_Data,post_EMG_Data,EMG_num,EMGs,pre_frame,line_wide,EMG_save_dir)

        %�ؓd�̐}��stack���Đ}������ + video�ɂ��ĕۑ�����
        figure('Position',[0 0 1280 720]) 
        for ii = 1:EMG_num
            subplot(4,4,ii)
            hold on;
            
            %plot & extract pre_data
            [frames] = VideoCreate(pre_date,pre_frame,'pre',pre_EMG_Data,ii,EMGs,save_movie);
            sel_frames{(2 * ii) - 1, 1} = frames;
            
            %plot & extract post_data
            [frames] = VideoCreate(post_date,pre_frame,'post',post_EMG_Data,ii,EMGs,save_movie);
            sel_frames{2 * ii, 1} = frames;
        end
        % save_videos
        if save_movie == 1
            stack_save_dir = [EMG_save_dir '/stack'];
            SaveVideo(sel_frames,EMG_num,stack_save_dir,video_framerate)
        end
        %save figure(���ɐ}�̕ۑ��Ɋւ��鏈�����L�q)
        stack_save_dir = [ EMG_save_dir '/stack'];
        if not(exist(stack_save_dir))
            mkdir(stack_save_dir)
        end
        saveas(gcf,[stack_save_dir '/' 'around_' EMG_type '_stack(EMG).png'])
        close all;
    elseif or(strcmp(analyze_period,'pre'),strcmp(analyze_period,'post')) 
        if save_xcorr == 1
            h = figure;    
            h.WindowState = 'maximized';
            for ii = 1:EMG_num
                %reference_data�̍쐬
                clear reference_data %�f�[�^�ɏ㏑���ł��Ȃ��̂ŁA����reference_data������N���A����K�v������
                for jj = 1:length(Target_date)
                    reference_data{jj,1} = EMG_Data{jj,1}{ii,:};
                end
                reference_data = mean(cell2mat(reference_data));
                for jj = 1:length(Target_date)
                   R = corrcoef(reference_data,EMG_Data{jj,1}{ii,:});
                   correlation_value(jj,1) = R(1,2);
                end
                subplot(4,4,ii)
                hold on;
                plot(correlation_value)
                xticks([1:length(Target_date)])
                ylim([0 1]);
                title(EMGs{ii,1})
                hold off
            end
        %save figure
            correlation_save_dir = [[save_dir '/analyzed_EMG/corration']];
            if not(exist(correlation_save_dir))
                mkdir(correlation_save_dir);
            end
            saveas(gcf,[correlation_save_dir '/filtered_EMG_individual_correlation(vs average_day).png']);
            close all;
        end
        %�ؓd�̐}��stack���Đ}������
        figure('Position',[0 0 1280 720]) 
        for ii = 1:EMG_num
            for jj = 1:length(Target_date)
                subplot(4,4,ii)
                hold on;
                p_color = ((40+((215/length(Target_date))*jj)) / 255) - 0.00001;
                plot(EMG_Data{jj,1}{ii,:},'color',[p_color,0,0],'LineWidth',line_wide);
            end
            ylim([0 2])
            grid on;
            if strcmp(EMG_type, 'TimeNormalized')
                % �����l�ƃq�X�g�O�����̒ǉ�
            else
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',line_wide);
            end
            title([EMGs{ii,1} '(' EMGs_detail{ii,1} ')'],'FontSize',18);
            hold off;
        end
        EMG_save_dir = [save_dir '/analyzed_EMG'];
        mkdir([EMG_save_dir '/stack']);
        saveas(gcf,[ EMG_save_dir '/stack/around_' EMG_type '_stack.png']);
        close all;
        %����+�W���΍��̋ؓd�̐}
        figure('Position', [0 0 1280 720]);
        for ii = 1:EMG_num
            for jj = 1:length(Target_date)
                reference_sel{jj,1} = EMG_Data{jj,1}{ii,:}; %�S�����́A����ؓ�����̃f�[�^����ɂ܂Ƃ߂�
            end
            EMG_mean = mean(cell2mat(reference_sel));
            EMG_std = std(cell2mat(reference_sel));
            subplot(4,4,ii)
            hold on;
            grid on;
            plot(EMG_mean,'LineWidth',line_wide);
            title(EMGs{ii,1},'FontSize',24);
            ar1=area(transpose([EMG_mean-EMG_std;EMG_std+EMG_std]));
            set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r')
            set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') 
            ylim([0 2])
            if strcmp(EMG_type, 'TimeNormalized')
                % �����l�ƃq�X�g�O�����̒ǉ�
            else
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',line_wide);
            end
            hold off;
        end   
        %save figure & data
        if not(exist([ EMG_save_dir '/average']))
            mkdir([ EMG_save_dir '/average'])
        end
        saveas(gcf,[ EMG_save_dir '/average/around_' EMG_type '_average.png']);
        close all;
    end
   
else %�ؓd����Ȃ�(�؃V�i�W�[)�Ȃ�
    %W�Ɋւ��Ă̑���(������bar����ׂ�(���̑O�ɁA�V�i�W�[�𑵂����Ƃ��K�v)& ���σV�i�W�[�̃v���b�g�ƕW���΍� & ���֌W�������߂�)
    %H�Ɋւ��Ă̑���(���ς�����āA�W���΍���w�i�ɎB�� & �ςݏd�˂��}(�}�������) & ���֌W�������߂�)
    %�č\�����ꂽEMG(WH)�̑���(�v������EMG�̑��֌W���Ɠ����e�ʂł��)
    %W,H�Ƃ��ɑ傫�������ɂ���ĈႤ�̂ŁA�����Ŕ�r�ł���悤�ɂ��炩���ߕ��ςŐ��K�����遨���K���������̂Ɛ��K�����Ă��Ȃ����̂ŕϐ��𕪂����ق���������������Ȃ�
    
    %use_W�̍쐬(���K���܂�)
    for ii = pcNum(1,1) : pcNum(1,end)
        for jj = 1:length(Target_date)
            use_W{ii,1}{jj,1} = all_W{jj,1}{ii,1};
        end
        %use_W�𐳋K������
        for jj = 1:length(Target_date)
            for kk = 1:ii
                average_value = mean(use_W{ii,1}{jj,1}(:,kk)); %���ςŊ��邽�߂ɁA���ς��Z�o����
                use_W{ii,1}{jj,1}(:,kk) = use_W{ii,1}{jj,1}(:,kk)/average_value;
            end
        end
    end
    %use_H�̍쐬(���K���܂�)
    for tt = pcNum
        for jj = 1:length(Target_date)
            use_H{tt,1}{jj,1} = all_H{jj,1}{tt,1};
        end
    end
    %use_H�𕽋ϒl�Ő��K��
    for tt = pcNum
        for jj = 1:length(Target_date)
            for kk = 1 : tt
                average_value = mean(use_H{tt,1}{jj,1}(kk,:));
                use_H{tt,1}{jj,1}(kk,:) = use_H{tt,1}{jj,1}(kk,:)/average_value;
            end
        end
    end
    %���̉���ς���K�v������(synergy�̕��ёւ�)
    if strcmp(align_type,'synergy_W')
        for ii = pcNum(1,1) : pcNum(1,end)
            align_use_W = use_W; %k_arr�̍쐬�p��use_w�𕡐�����
            k_arr{ii,1} = zeros(ii,length(Target_date)-1);
            for kk = 1:ii %�����̃V�i�W�[��
                eval(['synergy' num2str(kk) ' = align_use_W{ii,1}{1,1}(:,kk);']) %������synergy1��S�̂�synergy1�Ƃ���
                e_value_sel = zeros(length(Target_date),2);
                
                for ll = 2:length(Target_date)
                    for mm = 1:ii
                        e_value_ind = sum(eval(['abs(align_use_W{ii,1}{ll,1}(:,mm) - synergy' num2str(kk) ')'])); %ind��individual�̈Ӗ�
                        e_value_sel(ll,mm) = e_value_ind; 
                    end
                    [~,I] = min(e_value_sel(ll,:));
                    align_use_W{ii,1}{ll,1}(:,I) = 1000;
                    k_arr{ii,1}(kk,ll-1) = I;
                end
            end   
        end
    %������Ȃ�(W_synergy��align�����ŏ\���C�K�v���ł�����V���ɍ��΂���)
    elseif strcmp(align_type,'synergy_H')     
        for ii = pcNum
            for kk = 1:ii
                eval(['synergy' num2str(kk) ' = use_H{ii,1}{1,1}(kk,:);']) %�����̃V�i�W�[kk
                for ll = 1:length(Target_date)-1
                    for mm = 1:ii
                        e_value_ind = sum(eval(['abs(use_H{ii,1}{ll+1,1}(mm,:) - synergy' num2str(kk) ')'])); %ind��individual�̈Ӗ�
                        e_value_sel(ll,mm) = e_value_ind; 
                    end
                end
                e_value{ii,kk} = e_value_sel; %�e�V�i�W�[�����Ƃ�e_value_sel���i�[�B���̒ǉ�����̃��[�v�Ŏg�p����
                for nn = 1:length(Target_date)-1
                    [~,I] = min(e_value_sel(nn,:)); %�����̃V�i�W�[kk��nn+1���ڂ̂ǂ̃V�i�W�[�ɑΉ����Ă��邩�H(I�́A�ŏ��v�f�̊i�[����Ă���z��)
                    %�ŏ��l��2�Ԗڂ̍ŏ��l�̍����قƂ�ǂȂ���(臒l���߂�)�A���̍s�̑����ۗ�����or�S�Ă̑�����I������ɗv�f���d�����Ă���s�ɑ΂��Ēǉ��̑��������
                    eval(['synergy_relation_pcNum' num2str(ii) '(nn,kk) = I;'])
                end
            end   
        end
         %���S�Ă̑�����I������ɗv�f���d�����Ă���s�ɑ΂��Ēǉ��̑��������(����,synergy_H�Ŕ�r����ƁA���̃g���u�����Ȃ��̂ŁA�ǉ��̏����͓���Ă��Ȃ�)
    end
 %���בւ��f�[�^(synergy_relation_pcNum)����ɁA���ꂼ��̃V�i�W�[(W,H)�̏d�ˍ��킹�ƁA���ς�}�ɂ���
  %W�ɂ��Ẵv���b�g(�d�ˍ��킹)
    %bar�̃O���[�v�쐬�̂��߂ɍs��̌`��ς���
    for tt = pcNum %��t����for���[�v������̂łȂ�ƂȂ�tt�ɂ���
        for ii = 1:tt %ii�̓V�i�W�|�ԍ�
            for jj=1:length(Target_date)
                if jj == 1
                    sorted_use_W{tt,1}{ii,1}{1,jj}(:,1) = use_W{tt,1}{jj,1}(:,ii); %tt:�V�i�W�[��,jj:�����ڂ�? ii:�V�i�W�[�ԍ�
                else
                    sorted_use_W{tt,1}{ii,1}{1,jj}(:,1) = use_W{tt,1}{jj,1}(:, k_arr{tt}(ii, jj-1));
                end
            end
        end
    end
    % synergy_H�̕��ёւ�
    for tt = pcNum
        for ii = 1:tt
            for jj = 1:length(Target_date)
                if jj == 1 %����
                    sorted_use_H{tt,1}{ii,1}{jj,1} = use_H{tt}{jj}(ii,:);
                else
                    sorted_use_H{tt,1}{ii,1}{jj,1} = use_H{tt}{jj}(k_arr{tt}(ii, jj-1),:); 
                end
            end
        end
    end

    %}
    data_types = ["synergy_W","synergy_H","analyzed_EMG","recounst_EMG","r2"];
    HowToDisps = ["average","stack"];

    % �f�[�^��}���Z�[�u����f�B���N�g���̍\�z
    for data_type = data_types
        if strcmp(data_type,'r2')
            data_type = char(data_type);
            synergy_save_dir = [save_dir '/' data_type '/stack'];
            if not(exist(synergy_save_dir))
                mkdir([save_dir '/' data_type '/stack'])
            end
            continue;
        end
            for HowToDisp = HowToDisps
                data_type = char(data_type);
                HowToDisp = char(HowToDisp);
                synergy_save_dir = [save_dir '/' data_type '/' HowToDisp];
                if not(exist(synergy_save_dir))
                    mkdir([save_dir '/' data_type '/' HowToDisp])
                end
            end        
    end
    
    %�O���[�v������ăv���b�g����(W_synergy�̃v���b�g)
    if save_figure == 1
        for tt = pcNum
            figure('Position', [0 0 1280 720]);
            for ii = 1:tt
                synergy_portion = cell2mat(sorted_use_W{tt,1}{ii,1});
                subplot(tt,1,ii); 
                b = bar(x,synergy_portion,'FaceColor','flat');
                for k = 1:size(synergy_portion,2)
                    p_color = ((40+((215/length(Target_date))*k)) / 255) - 0.00001;
                    b(k).CData = [p_color 0 0];
                end
                ylim([0 4]);
                title(['synergy' num2str(ii)],'FontSize',25);

                if tt==2 %�V�i�W�[����2�̎�
                    [row,~] = size(synergy_portion);
                    for jj = 1:row
                        eval(['W_synergy' num2str(ii) '{jj,1} = EMGs{jj};']);
                        eval(['W_synergy' num2str(ii) '{jj,2} = synergy_portion(jj,:);']);
                    end
                end
            end
            saveas(gcf,[ save_dir '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ').png']);
            saveas(gcf,[ save_dir '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ').fig']);
            if tt == 2
                save('compare_diff/W_synergy.mat','W_synergy1','W_synergy2')
            end
            close all;
        end
        % �ɍ��W�̐}�Ő}������
        [pre_date,post_date] = DevideEMG(Target_date,reference_day,criterion_day);
        for tt = pcNum %�V�i�W�[���ł̃��[�v�@
            for ii = 1:tt %�e�V�i�W�[�̃��[�v�@
                figure('Position',[100,100,1200,800]);
                synergy_portion = cell2mat(sorted_use_W{tt,1}{ii,1});
                for k = 1:size(synergy_portion,2) %day�Ń��[�v
                    %�F�̌���
                    p_color = ((40+((215/length(Target_date))*k)) / 255) - 0.00001;
                    %�ɍ��W�̃v���b�g
                    if k == 1
                        theta = linspace(0, 2*pi, EMG_num+1);  % �p�x�̔z��(16����0�x�ƂR�U�O�x�Œl���o�b�e�B���O���Ă��܂�����)
                        labels = TargetName; %�l�ƃ��x���������Ă��邩�킩��Ȃ������Ŋm�F����
                        labels{end+1} = labels{1}; %���邽�� 
                    end
                    plotData = synergy_portion(:, k);% �l�̔z��
                    plotData(end+1) = plotData(1); %���邽��
                    switch analyze_period
                        case 'all'
                            pre_p_color = ((40+((215/length(pre_date))*k)) / 255) - 0.00001;
                            post_p_color = ((40+((215/length(post_date))*(k-length(pre_date)))) / 255) - 0.00001;
                            if any(pre_date == Target_date(k))
                                
                                p = polarplot(theta, plotData, '-', 'LineWidth', line_wide,'color',[pre_p_color,0,0]);  % �v���b�g
                            elseif any(post_date == Target_date(k))
                                p = polarplot(theta, plotData, '-', 'LineWidth', line_wide,'color',[0,1 - post_p_color,1]);  % �v���b�g
                            end
                        otherwise
                            %�F�̌���
                            p_color = ((40+((215/length(Target_date))*k)) / 255) - 0.00001;
                            p = polarplot(theta, plotData, '-', 'LineWidth', line_wide,'color',[p_color,0,0]);  % �v���b�g
                    end
                    if k == 1
                        thetaticks(rad2deg(theta));  % �p�x���̖ڐ����ݒ�
                        thetaticklabels(labels);     % �p�x���̃��x����ݒ�
                        hold on;
                    end
                end
                hold off;
                %�}�̑���
                % ���x���̃t�H���g�T�C�Y�ƐF��ύX
                ax = gca;                        % ���݂̎��I�u�W�F�N�g���擾
                ax.FontSize = label_FontSize;  % ���x���̃t�H���g�T�C�Y��ݒ�
                max_factor = max(max(synergy_portion));
                rlim([0 ceil(max_factor)]) %�ɍ��W��r�͈̔�(ceil�͌J��グ)
                saveas(gcf,[ save_dir '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ')_PolarFigure pcNum = ' num2str(tt) ' synergy' num2str(ii) '.png']);
                saveas(gcf,[ save_dir '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ')_PolarFigure pcNum = ' num2str(tt) ' synergy' num2str(ii) '.fig']);
                close all;
            end
        end
        
        %r2���܂Ƃ߂��}�����
        for ii = 1:length(Target_date)
            p_color = ((40+((215/length(Target_date))*ii)) / 255) - 0.00001; %p_color��1�����łȂ��Ƃ����Ȃ��̂�,�e�L�g�[�Ɉ���
            plot(all_r2{ii,1},'color',[p_color,0,0],'LineWidth',line_wide)
            ylim([0 1])
            hold on;
        end
        plot(shuffle.r2,'Color',[0,0,0],'LineWidth',line_wide)
        plot([0 EMG_num + 1],[0.8 0.8],'color','b','LineWidth',line_wide);
        h_axes = gca;
        grid on;
        h_axes.XAxis.FontSize = 13;
        h_axes.YAxis.FontSize = 13;
        xlim([0 EMG_num]);
%         title([Target_type ' R^2']);
        saveas(gcf,[save_dir '/r2/stack/' Target_type '_r2.png'])
        close all;
        % �d�ˍ��킹�̐}���v���b�g����(synergy_H�̃v���b�g)
        for ii = pcNum
            figure('Position', [0 0 640 640]);
            for kk = 1:ii %�����̃V�i�W�[kk
                for jj = 1:length(Target_date) 
                    subplot(ii,1,kk)
                    hold on;
                    p_color = ((40+((215/length(Target_date))*jj)) / 255) - 0.00001;
                    plot(sorted_use_H{ii}{kk}{jj}(1,:),'color',[p_color,0,0],'LineWidth',line_wide)
                end
                ylim([0 6])
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',line_wide);
                title(['synergy' num2str(kk)],'FontSize',25)
            end
            hold off;
            saveas(gcf,[save_dir '/synergy_H/stack/all_H(' Target_type '_' 'pcNum =' num2str(ii) ').png']);
            close all;
        end
    end
   %x_corr�̌v�Z
   %�����P(��������̂ŁC�֐���ʂŒ�`���ĊȌ��ɂ���)
   if save_xcorr == 1
        [pre_date,post_date,Elapsed_term,surgery_day_Elapsed] = DevideSynergy(Target_date,reference_day,criterion_day);
        switch correlation_type
            case 'pre_limited'
                control_days_index = [length(pre_date) - (pre_range-1):length(pre_date)];
            case 'pre_all'
                control_days_index = [1 : llength(pre_date)];
        end
        %synergyH�ɂ��Ă�x_corr
        for tt = pcNum 
            for ii = 1:tt %tt�̃V�i�W�[���ɂ�����V�i�W�[tt�̉��
                figure('Position', [100 100 1200 800]);
                %�R���g���[���f�[�^(reference_data�̍쐬)
                reference_data = mean(cell2mat(sorted_use_H{tt}{ii}(control_days_index(1):control_days_index(end))));
                clear all_xcorr
                all_xcorr = cell(tt,2);
                for jj = 1:tt %vs reference_data�̕�
                    clear correlation_value
                    correlation_value = zeros(length(Elapsed_term),1);
                    for kk = 1:length(Elapsed_term) %���t���������[�v
                        vs_data = sorted_use_H{tt,1}{jj,1}{kk};
                        R_array = xcorr(reference_data - mean(reference_data),vs_data - mean(vs_data),'coef'); %���K����x���̐ݒ�(lags��x�����Ǘ����Axcorr()�̒��Ő��K�����s���Ă���
                        R_xcorr = R_array(length(reference_data)+1);
                        %stem(lags,c) %���U�M���̃v���b�g�A�m�F�p������{�Ԃł͎g�p���Ȃ��Ǝv����
                        correlation_value(kk) = R_xcorr;
                    end
                    hold on;
                    xnoT = (0: min(Elapsed_term(Elapsed_term > 0)));
                    x1 = [Elapsed_term(control_days_index(1)) Elapsed_term(control_days_index(end)) Elapsed_term(control_days_index(end)) Elapsed_term(control_days_index(1))];
                    x2 = [0 xnoT(end) xnoT(end) 0];
                    y = [-1 -1 1 1];
                    %xline(surgery_day_Elapsed,'--r','surgery day');
                    ylim([-1 1]); grid on;
                    xlim([Elapsed_term(1) Elapsed_term(end)])
                    title(['vs pre-synergy' num2str(ii)],'FontSize',25)
                    fi1 = fill(x1, y, 'k');
                    fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
                    fi1.EdgeColor = 'none';            % remove the line around the filled area            
                    plot(Elapsed_term,correlation_value,'LineWidth',1.3);
                    if jj == tt
                        fi2 = fill(x2,y,'k','LineWidth',1.3);
                        fi2.FaceColor = [1 1 1];       % make the filled area
                        legend('control-data','synergy1','synergy2','task-disable','Location','east','FontSize',20)
                        h_axes = gca;
                        h_axes.XAxis.FontSize = 20;
                        h_axes.YAxis.FontSize = 20;
                        hold off
                        %�}�̕ۑ�
                        synergy_xcorr_save_dir = [save_dir '/synergy_xcorr/H_synergy'];
                        if not(exist(synergy_xcorr_save_dir))
                            mkdir(synergy_xcorr_save_dir)
                        end
                        saveas(gcf,[synergy_xcorr_save_dir '/H_xcorr(pcNum = ' num2str(tt) ' vs_synergy' num2str(ii) ').png']);
                        saveas(gcf,[synergy_xcorr_save_dir '/H_xcorr(pcNum = ' num2str(tt) ' vs_synergy' num2str(ii) ').fig']);
                        close all;
                    end
                    all_xcorr{jj,1} = ['vs synergy' num2str(ii) '-control'];
                    all_xcorr{jj,2} = correlation_value;
                end
            end
        end

        %synergy_W��x_corr
        for tt = pcNum 
            for ii = 1:tt %tt�̃V�i�W�[���ɂ�����V�i�W�[tt�̉��
                figure('Position', [100 100 1200 800]);
                %�R���g���[���f�[�^(reference_data�̍쐬)
                reference_data = mean(cell2mat(sorted_use_W{tt}{ii}(control_days_index(1):control_days_index(end))),2);
                clear all_xcorr
                all_xcorr = cell(tt,2);
                for jj = 1:tt %vs reference_data�̕�
                    clear correlation_value
                    correlation_value = zeros(length(Elapsed_term),1);
                    for kk = 1:length(Elapsed_term) %���t���������[�v
                        vs_data = sorted_use_W{tt,1}{jj,1}{kk};
                        R_xcorr = corrcoef(reference_data, vs_data);
                        correlation_value(kk) = R_xcorr(2,1);
                    end
                    if jj == 1
                        hold on;
                        xnoT = (0: min(Elapsed_term(Elapsed_term > 0)));
                        x1 = [Elapsed_term(control_days_index(1)) Elapsed_term(control_days_index(end)) Elapsed_term(control_days_index(end)) Elapsed_term(control_days_index(1))];
                        x2 = [0 xnoT(end) xnoT(end) 0];
                        y = [-1 -1 1 1];
                        %xline(surgery_day_Elapsed,'--r','surgery day');
                        ylim([-1 1]); grid on;
                        xlim([Elapsed_term(1) Elapsed_term(end)])
                        title(['synergy' num2str(ii)],'FontSize',40)
                        fi1 = fill(x1, y, 'k');
                        fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
                        fi1.EdgeColor = 'none';            % remove the line around the filled area
                    end
                    plot(Elapsed_term,correlation_value,'LineWidth', 2);
                    if jj == tt
                        h_axes = gca;
                        h_axes.XAxis.FontSize = 40;
                        h_axes.YAxis.FontSize = 40;
                        fi2 = fill(x2,y,'k','LineWidth',1.3);
                        fi2.FaceColor = [1 1 1];       % make the filled area
                        legend('control-data','synergy1','synergy2','task-disable','Location','east','FontSize',40)
                        hold off
                        %�}�̕ۑ�
                        synergy_xcorr_save_dir = [save_dir '/synergy_xcorr/W_synergy'];
                        if not(exist(synergy_xcorr_save_dir))
                            mkdir(synergy_xcorr_save_dir)
                        end
                        saveas(gcf,[synergy_xcorr_save_dir '/W_xcorr(pcNum = ' num2str(tt) ' vs_synergy' num2str(ii) ').png']);
                        saveas(gcf,[synergy_xcorr_save_dir '/W_xcorr(pcNum = ' num2str(tt) ' vs_synergy' num2str(ii) ').fig']);
                        close all;
                    end
                    all_xcorr{jj,1} = ['vs synergy' num2str(ii) '-control'];
                    all_xcorr{jj,2} = correlation_value;
                end
            end
        end
   end
end


 
%% define function to be used in this code
%function1
function Target_date = GenerateTargetDate(Target_date,analyze_period,minimum_trial,max_trial)
    try
        %���������ł͂Ȃ����A�g���C�A���f�[�^�������Ă�����t����������
        removed_day = [20220301, 20220324, 20220414 20220607]; 
        load(['devide_info/' analyze_period '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat'])
        Target_date = transpose(intersect(Target_date,trial_day));
        Target_date = setdiff(Target_date, removed_day);
    catch
        error([analyze_period '_day_more_' num2str(minimum_trial) '_and_less_' num2str(max_trial) '.mat �����݂��܂���.DevideExperimet.m�����s���āA�t�@�C�����쐬���Ă�������'])
    end
end

%function2
function [pre_date,post_date,Elapsed_term,surgery_day_Elapsed,pre_EMG_Data,post_EMG_Data] = DevideEMG(Target_date,reference_day,criterion_day,EMG_Data)
    %devide all data into two groups(pre and post)
    pre_date = Target_date(Target_date < reference_day);
    post_date = Target_date(Target_date > reference_day);
    % devide all EMG_data into two groups
    switch nargin
        case 3
            %do nothing
        case 4 %EMG_Data������Ƃ�
            pre_EMG_Data = EMG_Data(1:length(pre_date));
            post_EMG_Data = EMG_Data(1+length(pre_date):end);
    end

    %Calculate the number of days elapsed from the first experiment day
    Elapsed_term = zeros(length(Target_date),1);
    switch criterion_day
        case 'pre_first'
            for ii = 1:length(Target_date)
                if ii == 1 %first_day
                    first_day = trans_calrender(Target_date(ii));
                    Elapsed_term(ii) = 0;
                else
                    Elapsed_day = CountElapsedDate(Target_date(ii),first_day);
                    Elapsed_term(ii) = caldays(Elapsed_day);
                end
            end
            surgery_day_Elapsed = caldays(CountElapsedDate(reference_day,first_day));
        case 'surgery_day'
            surgery_day = trans_calrender(reference_day);
            for ii = 1:length(Target_date)
                Elapsed_day = CountElapsedDate(Target_date(ii),surgery_day);
                Elapsed_term(ii) = caldays(Elapsed_day);
            end
            surgery_day_Elapsed = 0;
    end
end

%function3
function [EMG_save_dir,all_reference_data,x1,x2,y] = individual_correlation(EMG_num,correlation_type,pre_range,pre_date,pre_EMG_Data,EMG_Data,Elapsed_term,Target_date,surgery_day_Elapsed,EMGs,save_dir)
    for ii = 1:EMG_num
        %reference_data�̍쐬
        clear reference_data %�f�[�^�ɏ㏑���ł��Ȃ��̂ŁA����(�Ώۂ̋ؓd����)reference_data������N���A����K�v������
        if strcmp(correlation_type,'pre_all')
            for jj = 1:length(pre_date)
                reference_data{jj,1} = pre_EMG_Data{jj,1}{ii,:};
            end
        elseif strcmp(correlation_type,'pre_limited')
            for jj = 1:pre_range
                reference_data{jj,1} = pre_EMG_Data{(end-pre_range)+jj,1}{ii,:};
            end
        end
        reference_data = mean(cell2mat(reference_data));
        %��xcorr��reference_data���g�p�������̂ŁA�����ł܂Ƃ߂āA�o�͂���
        all_reference_data{ii,1} = reference_data;
        
        correlation_value = zeros(length(Elapsed_term),1);
        for jj = 1:length(Target_date)
           R = corrcoef(reference_data,EMG_Data{jj,1}{ii,:});
           correlation_value(jj) = R(1,2);
        end
        
        switch correlation_type
            case 'pre_limited'
                temp = Elapsed_term(Elapsed_term < 0);
                control_days = temp(end-(pre_range-1):end);
            case 'pre_all'
                control_days = Elapsed_term(Elapsed_term < 0);
        end
        xnoT = (0: min(Elapsed_term(Elapsed_term > 0)));
        x1 = [control_days(1) control_days(end) control_days(end) control_days(1)];
        x2 = [0 xnoT(end) xnoT(end) 0];
        y = [-1 -1 1 1];
        %plot correlation data
        subplot(4,4,ii)
        hold on;
        %xline(surgery_day_Elapsed,'--r','surgery day');
        ylim([-1 1]); grid on;
        xlim([Elapsed_term(1) Elapsed_term(end)])
        title(EMGs{ii,1},'FontSize',25)
        fi1 = fill(x1, y, 'k');
        fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
        fi1.EdgeColor = 'none';            % remove the line around the filled area
        plot(Elapsed_term,correlation_value,'LineWidth',1.3);
        fi2 = fill(x2,y,'k','LineWidth',1.3);
        fi2.FaceColor = [1 1 1];       % make the filled area
        hold off
        % all_correlaton_value{ii} = correlation_value;
    end
        
    %save figure
     %setting directly to save
    EMG_save_dir = [save_dir '/analyzed_EMG'];
    correlation_save_dir = [EMG_save_dir '/corration'];
    if not(exist(correlation_save_dir))
        mkdir(correlation_save_dir);
    end
    
    if strcmp(correlation_type,'pre_all')
        saveas(gcf,[correlation_save_dir '/filtered_EMG_individual_correlation(vs pre_average(include' num2str(pre_range) ' days before)).png']);
    elseif strcmp(correlation_type,'pre_limited')
        saveas(gcf,[correlation_save_dir '/filtered_EMG_individual_correlation(vs pre_average(all)).png']);
    end
    
    %save_data
%     if not(exist('compare_diff'))
%         mkdir('compare_diff');
%     end
%     save('compare_diff/correlation_value.mat','all_correlaton_value')
end

%funtion4(DevideEMG�Ƃ��Ȃ莗�ʂ��Ă���)
function [pre_date,post_date,Elapsed_term,surgery_day_Elapsed] = DevideSynergy(Target_date,reference_day,criterion_day)
    %devide all data into two groups(pre and post)
    pre_date = Target_date(Target_date < reference_day);
    post_date = Target_date(Target_date > reference_day);
    % devide all EMG_data into two groups
%     pre_EMG_Data = EMG_Data(1:length(pre_date));
%     post_EMG_Data = EMG_Data(1+length(pre_date):end);

    %Calculate the number of days elapsed from the first experiment day
    Elapsed_term = zeros(length(Target_date),1);
    switch criterion_day
        case 'pre_first'
            for ii = 1:length(Target_date)
                if ii == 1 %first_day
                    first_day = trans_calrender(Target_date(ii));
                    Elapsed_term(ii) = 0;
                else
                    Elapsed_day = CountElapsedDate(Target_date(ii),first_day);
                    Elapsed_term(ii) = caldays(Elapsed_day);
                end
            end
            surgery_day_Elapsed = caldays(CountElapsedDate(reference_day,first_day));
        case 'surgery_day'
            surgery_day = trans_calrender(reference_day);
            for ii = 1:length(Target_date)
                Elapsed_day = CountElapsedDate(Target_date(ii),surgery_day);
                Elapsed_term(ii) = caldays(Elapsed_day);
            end
            surgery_day_Elapsed = 0;
    end
end

%�v���b�g�̐F��pre��post�ŕύX����
function [p_color] = set_color(Target_date,k,exp_term)
switch exp_term
    case 'pre'
        
    case 'post'
        
end
end

