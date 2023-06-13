%{
Coded by: Naohito Ohta
Last modification : 2022/04/28
���̃R�[�h�̎g�����F
1.�J�����g�f�B���N�g����Nibali�ɂ���
2.�K�v�ȕϐ�(monkeyname,exp_day��)��K�X�ύX����
�ȏ�𖞂�������ԂŎ��s����
�ۑ�_:
�S���̋ؓ������łȂ�,���ꂼ��̋؂̋؊����̑��ւ��o��
�v�������؊��������łȂ��A�č\�����ꂽ�؊����ǂ����̑��ւ��o��
%��邱��:
���߂����ւ��v���b�g����(EMG)
�����n���̐F���A���̌o�߂ŔZ������(or��������)�p�Ƀv���b�g����
�ؓ��S�̂ł͂Ȃ��āA�e�ؓ����Ƃ̑��֌W�������߂�
first_day��average_day��EMG_Data�̍\�����قȂ��Ă���̂𒼂�(average_day�̕��ɍ��킹��)
��^����stack���ďo��
%}
clear;
%% set parameter
Target_date = [20220420 20220421 20220422 20220426 20220427 20220428 20220506 20220511 20220513 20220516]; %���ւ����߂����Ώۂ̎�������z��ɂ܂Ƃ߂�
for ii = 1:length(Target_date)
    str_Target_date{1,ii} = num2str(Target_date(1,ii)); %Target_date��str�Ɍ^�ϊ���������.�}�������ۂɎg�p����(cell�z��ł��邱�Ƃɒ���)
end
nmf_fold = 'nmf_result';
monkey_name = 'Ni';
fold_detail = '_standard_filtNO5_'; %�t�@�C����t�H���_�Ɋ܂܂�Ă��镶����(�`�e���)
Target_type = 'tim3'; %�ǂ̃V�i�W�[(EMG)�̑��ւ����߂邩��I������(filtered:nmf��͂ɗp����EMG�̑���,TimeNormalized:���Ԑ��K���V�i�W�[,tim1:�^�C�~���O1����̃V�i�W�[,tim2:�^�C�~���O2����̃V�i�W�[,tim3:�^�C�~���O3����̃V�i�W�[)
EMG_type = 'tim3'; %Tareget_type��filtered��I�񂾎��A�ǂ̋ؓd��p���邩?
triming_contents = '_tim3_pre-300_post-100.mat'; %Target_type��filtered�̎��ɁA�ǂ�EMG���g�p���邩(tim1����:_tim1_pre-400_post200.mat,tim2����:_tim2_pre-200_post-300.mat tim3����:_tim3_pre-300_post-100.mat TimeNormalized:_TimeNormalized.mat )
correlation_type = 'average_day'; %���֌W�����ǂ�����ċ��߂邩�H(�����f�[�^�ɑ΂��Ă̑��֌W��:first_day �S���f�[�^�̕��ςɑ΂��鑊�֌W��:average_day)
pcNum = [2 3]; %�g�p����؃V�i�W�[�̌�(Target_type��filtered�ł͂Ȃ���)
pre_frame = 300; %�}��xline���������߂�,pre_frame��ݒ肷��

EMGs=cell(16,1) ;
EMGs{1,1}= 'EDC-A';
EMGs{2,1}= 'EDC-B';
EMGs{3,1}= 'ED23';
EMGs{4,1}= 'ED45';
EMGs{5,1}= 'ECR';
EMGs{6,1}= 'ECU';
EMGs{7,1}= 'BRD';
EMGs{8,1}= 'EPL-B';
EMGs{9,1}= 'FDS-A';
EMGs{10,1}= 'FDS-B';
EMGs{11,1}= 'FDP';
EMGs{12,1}= 'FCR';
EMGs{13,1}= 'FCU';
EMGs{14,1}= 'FPL';
EMGs{15,1}= 'Biceps';
EMGs{16,1}= 'Triceps';
EMG_num = 16;
%% code section
%�����Ƃ̋؃V�i�W�[(��������EMG)�f�[�^����ɂ܂Ƃ߂�
if strcmp(Target_type,'filtered') %��͑Ώۂ�EMG�̎�
    for ii = 1:length(Target_date)
        for jj = 1:EMG_num
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
        load([num2str(Target_date(1,ii)) '/' nmf_fold '/' monkey_name num2str(Target_date(1,ii)) fold_detail 'TimeNormalized_task' '/' monkey_name num2str(Target_date(1,ii)) fold_detail num2str(EMG_num) '_nmf.mat'])
        all_W{ii,1} = W ;
        all_H{ii,1} = H ;
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

%�܂Ƃ߂��f�[�^��p���đ��ւ��o���Ă���
if strcmp(Target_type,'filtered') %�ؓd�Ȃ��
    %���ςɑ΂��đ��ւ����ꍇ�ƁA���ςɑ΂��đ��ւ����ꍇ�̓���I�v�V�����Ƃ��Ă���
    if strcmp(correlation_type,'first_day')
        for ii = 1:length(Target_date)
            EMG_Data{ii,1} = cell2mat(EMG_Data{ii,1});
        end
        %�S�̃f�[�^�ɑ΂��Ă̑���
        for ii = 1:length(Target_date)
            if ii == 1 %�����f�[�^�̎�
               correlation_value(1,1) = 1;
               reference_data = EMG_Data{ii,1}; %reference_data:���֌W���̎Q�ƃf�[�^�A���̃f�[�^����ɑ��֌W�����Z�o����
            else
               relevant_data = EMG_Data{ii,1};  %�Y�����ɑΉ�����EMG�f�[�^�Breference_data�Ƃ̑��ւ������̂ɗp����
               R = corrcoef(reference_data,relevant_data); %���֍s���R�ɑ��
               correlation_value(ii,1) = R(1,2); 
            end
        end
        plot(correlation_value)
        xticks([1:length(Target_date)])
        ylim([0 1]);
        title(['EMG-correlation(vs first-day)'])
        mkdir(['control_data/' EMG_type '/analyzed_EMG/corration']);
        saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/corration/filtered_EMG_correlation(vs first_day).png']);
        close all;
        %�X�̃f�[�^�ɑ΂��Ă̑��֌W��
        h = figure;
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
            reference_data = EMG_Data{1,1}(ii,:);
            correlation_value(1,1) = 1;
            for jj = 1:length(Target_date)-1
               R = corrcoef(reference_data,EMG_Data{jj+1,1}(ii,:));
               correlation_value(jj+1,1) = R(1,2);
            end
            subplot(4,4,ii)
            hold on;
            plot(correlation_value)
            xticks([1:length(Target_date)])
            ylim([0 1]);
            title(EMGs{ii,1})
            hold off
        end
        saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/corration/filtered_EMG_individual_correlation(vs first_day).png']);
        close all;
    elseif strcmp(correlation_type,'average_day')
        %reference_data�̍쐬
        for ii = 1:length(Target_date)
            EMG_Data{ii,1} = cell2mat(EMG_Data{ii,1});
        end
        for ii = 1:EMG_num
            for jj = 1:length(Target_date)
                average_matrix(jj,:) = EMG_Data{jj,1}(ii,:);
            end
            average_matrix = mean(average_matrix);
            reference_data{ii,1} = average_matrix;
        end
        reference_data = cell2mat(reference_data);
        %reference_data����ɑ��֌W�������߂�
        for ii = 1:length(Target_date)
            relevant_data = EMG_Data{ii,1};  %�Y�����ɑΉ�����EMG�f�[�^�Breference_data�Ƃ̑��ւ������̂ɗp����
            R = corrcoef(reference_data,relevant_data); %���֍s���R�ɑ��
            correlation_value(ii,1) = R(1,2); 
        end
        plot(correlation_value)
        xticks([1:5])
        ylim([0 1]);
        title(['EMG_correlation(vs average)'])
        mkdir(['control_data/' EMG_type '/analyzed_EMG/corration']);
        saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/corration/filtered_EMG_correlation(vs average).png']);
        close all;
    end
    %�X�̃f�[�^�ɑ΂��Ă̑��֌W��
    clear reference_data %�S�̃f�[�^�ɑ΂��鑊�֌W���̓��o�Ɏg�p����reference_data���폜
    h = figure;
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        %reference_data�̍쐬
        clear reference_data %�f�[�^�ɏ㏑���ł��Ȃ��̂ŁA����reference_data������N���A����K�v������
        for jj = 1:length(Target_date)
            reference_data{jj,1} = EMG_Data{jj,1}(ii,:);
        end
        reference_data = mean(cell2mat(reference_data));
        for jj = 1:length(Target_date)
           R = corrcoef(reference_data,EMG_Data{jj,1}(ii,:));
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
    saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/corration/filtered_EMG_individual_correlation(vs average_day).png']);
    close all;
    %�ؓd�̐}��stack���Đ}������
    h = figure;
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        for jj = 1:length(Target_date)
            subplot(4,4,ii)
            hold on;
            plot(EMG_Data{jj,1}(ii,:))
        end
        ylim([0 2])
        grid on;
        xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
        title(EMGs{ii,1});
        if ii == 1
            legend(str_Target_date);
        end
        hold off;
    end
    mkdir(['control_data/' EMG_type '/analyzed_EMG/stack']);
    saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/stack/around_' EMG_type '_stack.png']);
    close all;
    %����+�W���΍��̋ؓd�̐}
    figure('Position', [0 0 1280 720]);
    for ii = 1:EMG_num
        for jj = 1:length(Target_date)
            reference_sel{jj,1} = EMG_Data{jj,1}(ii,:); %�S�����́A����ؓ�����̃f�[�^����ɂ܂Ƃ߂�
        end
        EMG_mean = mean(cell2mat(reference_sel));
        EMG_std = std(cell2mat(reference_sel));
        subplot(4,4,ii)
        hold on;
        grid on;
        plot(EMG_mean);
        title(EMGs{ii,1});
        ar1=area(transpose([EMG_mean-EMG_std;EMG_std+EMG_std]));
        set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r')
        set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') 
        ylim([0 2])
        xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
        hold off;
    end   
    mkdir(['control_data/' EMG_type '/analyzed_EMG/average'])
    saveas(gcf,['control_data/' EMG_type '/analyzed_EMG/average/around_' EMG_type '_average.png']);
    close all;
else %�ؓd����Ȃ�(�؃V�i�W�[)�Ȃ�
    %W�Ɋւ��Ă̑���(������bar����ׂ�(���̑O�ɁA�V�i�W�[�𑵂����Ƃ��K�v)& ���σV�i�W�[�̃v���b�g�ƕW���΍� & ���֌W�������߂�)
    %H�Ɋւ��Ă̑���(���ς�����āA�W���΍���w�i�ɎB�� & �ςݏd�˂��}(�}�������) & ���֌W�������߂�)
    %�č\�����ꂽEMG(WH)�̑���(�v������EMG�̑��֌W���Ɠ����e�ʂł��)
    %W,H�Ƃ��ɑ傫�������ɂ���ĈႤ�̂ŁA�����Ŕ�r�ł���悤�ɂ��炩���ߕ��ςŐ��K�����遨���K���������̂Ɛ��K�����Ă��Ȃ����̂ŕϐ��𕪂����ق���������������Ȃ�
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
        %�؃V�i�W�[�𑵂���(�����̃f�[�^�ɑ΂���W���΍�������āA��ԏ��������̂��̗p)
        for kk = 1:ii
            eval(['synergy' num2str(kk) ' = use_W{ii,1}{1,1}(:,kk);'])
            for ll = 1:length(Target_date)-1
                for mm = 1:ii
                    e_value_ind = sum(eval(['abs(use_W{ii,1}{ll+1,1}(:,mm) - synergy' num2str(kk) ')'])); %ind��individual�̈Ӗ�
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
     %���S�Ă̑�����I������ɗv�f���d�����Ă���s�ɑ΂��Ēǉ��̑��������
     for ii = pcNum(1,1) : pcNum(1,end)
         %unique���e�s�ɓK�p���āA�T�C�Y���ς�����珈�����s��
         for jj = 1:length(Target_date)-1
            judge_matrix = eval(['synergy_relation_pcNum' num2str(ii) '(jj,:);']); %�����Ώۂ�synergy_relation�̍s.
            [~,judge_size] = size(unique(judge_matrix)); %�����s�ɏd��������ꍇ�͗�()��ii(�V�i�W�[��)�ƈقȂ�̂ŁA�����Ȃ�����ǉ��̏������s��
            if ii ~= judge_size
                a = 1:ii;
                defective_synergy = setdiff(a,eval(['synergy_relation_pcNum' num2str(ii) '(jj,:);'])); %�ƍ�����Ă��Ȃ��V�i�W�[(�����̃V�i�W�[)��������
                %�ߓx�Ɏg�p����Ă���(�d���̂���)�V�i�W�[���o�͂���
                for kk = 1:ii
                     overlap_num_matrix = find(judge_matrix(1,:) == kk); %�d�����Ă���v�f������΁A�z��̗v�f����2�ȏ�ɂȂ�
                     [~,overlap_num] = size(overlap_num_matrix);
                    if overlap_num > 1
                        overlap_used_matrix = overlap_num_matrix;
                        for ll = overlap_used_matrix
                            if ll == overlap_used_matrix(1,1)
                                min_value = e_value{ii,defective_synergy}(jj,ll);
                                min_col = ll;
                            elseif min_value > e_value{ii,defective_synergy}(jj,ll)
                                min_value = e_value{ii,defective_synergy}(jj,ll);
                                min_col = ll;
                            end
                        end
                        eval(['synergy_relation_pcNum' num2str(ii) '(jj,min_col) = defective_synergy;']);
                    end
                end
            end
         end
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
                    sorted_use_W{tt,1}{ii,1}{1,jj}(:,1) = use_W{tt,1}{jj,1}(:,eval(['synergy_relation_pcNum' num2str(tt) '(jj-1,ii);']));
                end
            end
        end
    end
    %�ۑ���̃f�B���N�g�������
     mkdir(['control_data/' Target_type '/synergy_W/stack']);
     mkdir(['control_data/' Target_type '/synergy_W/average' ]);
     mkdir(['control_data/' Target_type '/synergy_H/stack' ]);
     mkdir(['control_data/' Target_type '/synergy_H/average' ]);
     mkdir(['control_data/' Target_type '/analyzed_EMG/stack'; ]);
     mkdir(['control_data/' Target_type '/analyzed_EMG/average' ]);
     mkdir(['control_data/' Target_type '/reconst_EMG/stack' ]);
     mkdir(['control_data/' Target_type '/reconst_EMG/average']);
     mkdir(['control_data/' Target_type '/r2/stack']);
    %�O���[�v������ăv���b�g����
    for tt = pcNum
        figure('Position', [0 0 1280 720]);
        for ii = 1:tt
            synergy_portion = cell2mat(sorted_use_W{tt,1}{ii,1});
            subplot(tt,1,ii); 
            bar(x,synergy_portion);
            ylim([0 4]);
            if ii == 1
                legend(str_Target_date);
                title(['all-W pcNum =' num2str(tt)]);
            end
        end
        saveas(gcf,['control_data/' Target_type '/synergy_W/stack/all_W(' Target_type '_' 'pcNum =' num2str(tt) ').png']);
        close all;
    end
    %�S���̕��ς̋�ԃV�i�W�[���o��
    for tt = pcNum
        figure('Position', [0 0 1280 720]);
        for ii = 1:tt
            synergy_portion = cell2mat(sorted_use_W{tt,1}{ii,1});
            synergy_std = std(synergy_portion,0,2);
            synergy_average = mean(synergy_portion,2);
            subplot(tt,1,ii); 
            bar(x,synergy_average);
            hold on;
            er = errorbar(x,synergy_average,synergy_std);    
            er.Color = [0 0 0];                            
            er.LineStyle = 'none';
            ylim([0 4]);
            if ii == 1
                title(['all_W pcNum =' num2str(tt)]);
            end
        end
        hold off;
        saveas(gcf,['control_data/' Target_type '/synergy_W/average/all_W(' Target_type '_' 'pcNum =' num2str(tt) ').png']);
        close all;
    end
    %r2���܂Ƃ߂��}�����
    for ii = 1:length(Target_date)
        plot(all_r2{ii,1})
        ylim([0 1])
        hold on;
    end
    plot(shuffle.r2,'Color',[0,0,0])
    plot([0 EMG_num + 1],[0.8 0.8]);
    legend(str_Target_date)
    title([Target_type ' R^2']);
    saveas(gcf,['control_data/' Target_type '/r2/stack/' Target_type '_r2.png'])
    %���ԃV�i�W�[(H)�ɂ���
    %all_H����use_H�����
    for ii = pcNum
        for jj = 1:length(Target_date)
            use_H{ii,1}{jj,1} = all_H{jj,1}{ii,1};
        end
    end
    %use_H�𕽋ϒl�Ő��K��
    for ii = pcNum
        for jj = 1:length(Target_date)
            for kk = 1 : ii
                average_value = mean(use_H{ii,1}{jj,1}(kk,:));
                use_H{ii,1}{jj,1}(kk,:) = use_H{ii,1}{jj,1}(kk,:)/average_value;
            end
        end
    end
    % �d�ˍ��킹�̐}���v���b�g����
    for ii = pcNum
        figure('Position', [0 0 640 640]);
        for kk = 1:ii
            for jj = 1:length(Target_date) 
                subplot(ii,1,kk)
                hold on;
                if jj == 1 %����
                    plot(use_H{ii,1}{jj,1}(kk,:))
                else
                    plot(use_H{ii,1}{jj,1}(eval(['synergy_relation_pcNum' num2str(ii) '(jj-1,kk)']),:))
                end
            end
            ylim([0 6])
            xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
            if kk == 1
                legend(str_Target_date);
                title(['all_H pcNum =' num2str(ii)])
            end
        end
        hold off;
        saveas(gcf,['control_data/' Target_type '/synergy_H/stack/all_H(' Target_type '_' 'pcNum =' num2str(ii) ').png']);
        close all;
    end
    %�S���̕��ς̎��ԃV�i�W�[���o��
    for ii = pcNum
        for kk = 1:ii
            clear ave_H_matrix;
            for jj = 1:length(Target_date)
                if jj == 1
                 ave_H_matrix{jj,1} = use_H{ii,1}{jj,1}(kk,:);
                else
                 ave_H_matrix{jj,1} = use_H{ii,1}{jj,1}(eval(['synergy_relation_pcNum' num2str(ii) '(jj-1,kk)']),:);
                end
            end
            ave_H_matrix = cell2mat(ave_H_matrix);
            ave_H = mean(ave_H_matrix);
            ave_H_std = std(ave_H_matrix);

            subplot(ii,1,kk)
            hold on;
            plot(ave_H)
            %�W���΍��̔w�i�\��
            %ar1=area(x,[Y1(1:11,1)-Y1(1:11,2) Y1(1:11,2)+Y1(1:11,2)]);
            %{
            ar1=area(ave_H-ave_H_std);
            set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r') %�т̉���
            set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') %�т̓���
            %}
            ar1=area(transpose([ave_H-ave_H_std;ave_H_std+ave_H_std]));
            set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r')
            set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') 
            ylim([0 6])
            xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',2);
            hold off;
            if kk == 1
                 title(['ave_H pcNum =' num2str(ii)])
            end
        end
        saveas(gcf,['control_data/' Target_type '/synergy_H/average/all_H(' Target_type '_' 'pcNum =' num2str(ii) ').png']);
        close all;
    end
end
           