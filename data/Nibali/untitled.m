%{
Coded by: Naohito Ohta
Last modification : 2022/03/31
���̃R�[�h�̎g�����F
1.�J�����g�f�B���N�g����Nibali�ɂ���
2.�K�v�ȕϐ�(monkeyname,exp_day��)��K�X�ύX����
�ȏ�𖞂�������ԂŎ��s����

�y������f�[�^�z
�E�^�X�N�^�C�~���O�ƁA�^�X�N�̊e�Z�N�V����(timing1��timing2�Ƃ�)�ł̕��ώ��ԂƕW���΍�
�E�^�X�N�̊e�^�C�~���O�t�߂ł̋ؓd�f�[�^(�n�C�p�X�t�B���^�[�������邩�ǂ����̃I�v�V���������Ă���)
�E�ؓd�f�[�^�̐U�����(�؃V�i�W�[��͂Ŏg�p����A�t�B���^�ς݂̋ؓd�f�[�^)
�����̃f�[�^�ƃO���t���A���̊֐������s���邱�Ƃœ�����

�y���ӓ_�z:
filter��high_pass�͕��p�s��(����1:���܂��쓮���Ȃ�,filter�̂�1:�؃V�i�W�[��͗p�̉��������{�����ؓd��͂ƁA�������ς݂�EMG��nmf_result�ɕۑ������ high_pass�̂�1:filt_h�̃J�b�g�I�t���g���̃n�C�p�X���{���ꂽ�ؓd��͂��ۑ������ ����0:RAW�f�[�^�̋ؓd��͂��s����)
%�y���ׂ����Ɓz: �t�B���^�����O��̋ؓd�̐}�̔w�i�ɁA�W���΍��̔w�i������
 NaN�l���o�Ȃ��悤�Ȕ͈͂ŁA�^�C�~���O�O��̒l���g���~���O���ׂ�(NaN�l������ƁA���n��ɂ���ĎQ�Ƃ��Ă���^�X�N�����Ⴄ���߁A�_�����ɍڂ����Ȃ�)
 NMF�p�ɋؓd�ɑ΂��ăt�B���^�����O���������ۂɁA�ǂ̂悤�ȏ��������������f�[�^�Ȃ����}�̃^�C�g���ɏ����ׂ�

�y���P�_�z
�^�X�N�Ԃŕ��ς����}�̔w�i�Ƀf�[�^�̕W���΍���}������ 
���ꂼ��̐}��grid on����
noise_cri��after_rect_filter�̒l���A�܂߂��ق�������
�t�B���^�����O�O�̋ؓd(hp��rect�̂�)���A���K�����Ă���v���b�g������������(rect���Ă��Ȃ���ԂŐ��K������ƁA���ς�0�ɂȂ�̂ł��܂�Ӗ����ׂ��Ȃ��Ǝv���)
SYNERGYPLOT�̕���,TIM2��TIM3�̎��ԃV�i�W�[�̕���,�^�C�~���O�̏c�_(xlim)������
�@�\�����̊֐��ɏW�񂵂���(�@�\�𕪎U����,�����̊֐��ɕ�����)
task_type�������ŕύX����:���t��臒l��ݒ肵�āC����𒴂��Ă�����t�̎���drawer�ɂ���悤�ɕύX����
�����few_task�͎g���Ȃ��̂ŏ��������� �� �ʂ̊֐��ō����������������

�yprocedure�z
pre : CombineMatfile.m
post : makeEMGNMF_btcOhta.m
after-post: makefold.m
%}

function [] = untitled(exp_day)
%% set parameters
monkeyname='Ni';
% exp_day = '20220805';
save_NMF_fold='nmf_result'; %��save_fold
few_signal = 0; %few_signal(�^�C�~���Osignal��LED�J�[�e�������Ȃ�)���ǂ���
task_type = 'drawer'; %'default'/'drawer'
high_pass = 0; %����̓��h���Ȃ������߂Ƀn�C�p�X�������邩�ǂ���
SR = 1375; %�ؓd�f�[�^�̃T���v�����O���[�g
filt_h = 50;%�J�b�g�I�t���g���̒l
%���V�i�W�[��͗p�̃t�B���^�����O�Ɋւ���ϐ�
filter = 1; %�t�B���^�[�������邩�ǂ���
filter_h = 50; %�؃V�i�W�[�p�̃n�C�p�X�t�B���^�[�̃J�b�g�I�t���g��(�ؓd��͂̂��߂̃n�C�p�X�J�b�g�I�t���g��filt_h�ƍ������Ȃ��悤�ɒ��ӂ���)
filter_l = 500; %�؃V�i�W�[�p�̃��[�p�X�t�B���^�[�̃J�b�g�I�t���g��
after_rect_filter = 20;%����(rect)��̕������̂��߂̃��[�p�X�t�B���^�[�̃J�b�g�I�t���g��
% y_max = 10;
% around timing1
pre_frame1 = 400;
post_frame1 = 200;

% around timing2
pre_frame2 = 200;
post_frame2 = 300;

% around timing3
pre_frame3 = 300;
post_frame3 = 100;

% around timing4
pre_frame4 = 300;
post_frame4 = 400;

% selEMGs= 1:16;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
% EMGs=cell(16,1) ;
% EMGs{1,1}= 'EDC-A';
% EMGs{2,1}= 'EDC-B';
% EMGs{3,1}= 'ED23';
% EMGs{4,1}= 'ED45';
% EMGs{5,1}= 'ECR';
% EMGs{6,1}= 'ECU';
% EMGs{7,1}= 'BRD';
% EMGs{8,1}= 'EPL-B';
% EMGs{9,1}= 'FDS-A';
% EMGs{10,1}= 'FDS-B';
% EMGs{11,1}= 'FDP';
% EMGs{12,1}= 'FCR';
% EMGs{13,1}= 'FCU';
% EMGs{14,1}= 'FPL';
% EMGs{15,1}= 'Biceps';
% EMGs{16,1}= 'Triceps';
% EMG_num = 16;

selEMGs= 1:3;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
EMGs=cell(3,1) ;
EMGs{1,1}= 'FDS';
EMGs{2,1}= 'PL';
EMGs{3,1}= 'EPL';
EMG_num = 3;
%% make timing data
cd(num2str(exp_day))
load(['AllData_' monkeyname exp_day '.mat'],'CAI*','CTTL*','CEMG*','TimeRange')

%���ꂼ��̃f�[�^(�ؓd��^�C�~���O)���\���̔z��ɂ܂Ƃ߂�
workspaceVars = who; %���݂̃��[�N�X�y�[�X�ϐ��̖��O���擾
prefix_EMG = 'CEMG';
prefix_timing = 'CTTL';
%EMG�֘A���܂Ƃ߂�
EMG_matchedVars = MakeStruct(prefix_EMG, workspaceVars);
for ii = 1:length(EMG_matchedVars)
    varName = EMG_matchedVars{ii};
    EMG_struct.(varName) = eval(varName);
end
%timing�֘A���܂Ƃ߂�
timing_matchedVars = MakeStruct(prefix_timing, workspaceVars);
for ii = 1:length(timing_matchedVars)
    varName = timing_matchedVars{ii};
    timing_struct.(varName) = eval(varName);
end


%���A�i���O�M��(CAI_001)�̃f�W�^�C�Y��(timing1,timing4�̍쐬)
switch task_type
    case 'default'
        [timing1,timing4] = timing_func1(CAI_001, task_type);
    case 'drawer'
        [timing1,timing5] =  timing_func1(CAI_001, task_type);
end

%��timing2,timing3,timing5�̍쐬(CombineMatfile�ŁA�M���Ԃ̕΍��͕⊮�ς݂����炻�̂܂ܑ�����邾���ł���)
%��default
switch task_type    
    case 'default'
        if exist('CTTL_003_Up')
            [~,timing2, timing3, timing5] = timing_func2(timing_struct, task_type);
        else
            [~, timing2, timing3] = timing_func2(timing_struct, task_type);
        end
        all_timing = {timing1 timing2 timing3 timing4};
    case 'drawer'
        if exist('CTTL_003_Up')
            [timing2, timing3, timing4, timing6] = timing_func2(timing_struct, task_type);
        else
            [timing2, timing3,timing4] = timing_func2(timing_struct, task_type);
        end
        all_timing = {timing1 timing2 timing3 timing4 timing5};
end

%mege & sort
all_timing = cell2mat(all_timing);
all_timing = sort_timing(all_timing,1);

%timing�f�[�^�̕ۑ��ꏊ�̍쐬
Data_save_dir = 'EMG_Data/Data';
if not(isfolder(Data_save_dir))
    mkdir(Data_save_dir)
end
%success_timing�̍쐬
if few_signal == 1
    start_end = [timing1(1,:);timing4(1,:)];
    diff_sample = start_end(2,:) - start_end(1,:);
    ex_tim1 = timing1(1,:);
    ex_tim4 = timing4(1,:);
    timing1 = ex_tim1(and(diff_sample >= 2500, diff_sample <= 4000));
    timing4 = ex_tim4(and(diff_sample >= 2500, diff_sample <= 4000));
    success_timing = [timing1;timing4];
    %�f�[�^�̃Z�[�u
    save([Data_save_dir '/' 'success_timing.mat'],'success_timing')
else
    %success_timing�̒��o
    switch task_type
        case 'default'
            if exist('CTTL_003_Up')
                success_timing = timing_func3(all_timing,timing5);
            else
                success_timing = timing_func3(all_timing);
            end
        case 'drawer'
            %CAI,CTTL_002����̃f�[�^�ŁC�]�v�Ȃ��̂����O���Ă���
            %CAI�Ɋւ���,�m���Ƀ^�X�N����Ȃ�1,5�̋�Ԃ������Ă���
            data_diff = [timing5(1,:)-timing1(1,:)];
            task_index = find(data_diff>(SR*0.8)); %0.8�b�ȏォ�������
            timing1 = timing1(:,task_index);
            timing5 = timing5(:,task_index);
            %CTTL_002�Ɋւ���
            sensor_data = sort_timing([timing2, timing3, timing4], 1);
            sensor_procedure = sensor_data(2,:);
            sensor_index = [];
            for ii = 1:length(sensor_procedure)
                if ii+3 > length(sensor_procedure)
                    break
                end
                if sensor_procedure(ii) == 2 && sensor_procedure(ii+1) == 3 && sensor_procedure(ii+2) == 4 && sensor_procedure(ii+3) == 2
                    A = [ii; ii+1; ii+2; ii+3];
                    sensor_index = [sensor_index, A];
                end
            end
            timing2 = sensor_data(:,sensor_index(1,:));
            timing3 = sensor_data(:,sensor_index(2,:));
            timing4 = sensor_data(:,sensor_index(3,:));
            all_timing = sort_timing([timing1, timing2, timing3, timing4, timing5], 1);
            if exist('CTTL_003_Up')
                success_timing = timing_func3(all_timing,timing6);
            else
                success_timing = timing_func3(all_timing);
            end
    end
    %�Z�[�u�p�f�[�^���܂Ƃ߂�
    [tim_num,~] = size(success_timing); 
    success_timing = [success_timing;success_timing(tim_num,:) - success_timing(1,:)];
    sorted_success_timing = [sort_timing(success_timing,tim_num+1);sort_timing(success_timing(tim_num+1,:)/mean(success_timing(tim_num+1,:)),1)];%success_timing���^�X�N�̒������Ƀ\�[�g�������́B�ŏI�s�́A���σT���v�����ɑ΂��銄��
    %������ȍ~�́Cdrawer�^�X�N�ɑΉ����Ă��Ȃ��̂ŁC�K�v�ɂȂ�����ύX���邱��
    success_distance = [success_timing(2,:) - success_timing(1,:);success_timing(3,:) - success_timing(2,:);success_timing(4,:) - success_timing(3,:);success_timing(4,:) - success_timing(1,:)];%�O�̐M���Ƃ̃t���[������\��������(1��2,2��3,3��4)
    %��success_distance�����ƂɁA�e�Z�N�V�����ł̃T���v�����̕��ϒl�ƕW���΍���success_distance_std�ɑ������
    a1 = round(mean(success_distance(1,:)));
    a2 = round(std(success_distance(1,:)));
    b1 = round(mean(success_distance(2,:)));
    b2 = round(std(success_distance(2,:)));
    c1 = round(mean(success_distance(3,:)));
    c2 = round(std(success_distance(3,:)));
    d1 = round(mean(success_distance(4,:)));
    d2 = round(std(success_distance(4,:)));
    success_distance_std{1,1}= [num2str(a1) ' �} ' num2str(a2)];%[num2str(b1) ' �} ' num2str(b2)];[num2str(c1) ' �} ' num2str(c2)];[num2str(d1) ' �} ' num2str(d2)]];
    success_distance_std{2,1}= [num2str(b1) ' �} ' num2str(b2)];
    success_distance_std{3,1}= [num2str(c1) ' �} ' num2str(c2)];
    success_distance_std{4,1}= [num2str(d1) ' �} ' num2str(d2)];
    success_timing_video = round(success_timing * (240/1375));%success_timing�̒l���A�r�f�I��fps�ɕϊ����ďo�͂������́B����Ƃ̏̍��̂��߂Ɏg��
    success_distance_video = [round(success_distance * (240/1375));success_timing_video(1,:)];
    success_distance_video_std{1,1}= [num2str(round(a1*240/1375)) ' �} ' num2str(round(a2*240/1375))];%[num2str(b1) ' �} ' num2str(b2)];[num2str(c1) ' �} ' num2str(c2)];[num2str(d1) ' �} ' num2str(d2)]];
    success_distance_video_std{2,1}= [num2str(round(b1*240/1375)) ' �} ' num2str(round(b2*240/1375))];
    success_distance_video_std{3,1}= [num2str(round(c1*240/1375)) ' �} ' num2str(round(c2*240/1375))];
    success_distance_video_std{4,1}= [num2str(round(d1*240/1375)) ' �} ' num2str(round(d2*240/1375))];
    %�f�[�^�̃Z�[�u
    save([Data_save_dir '/' 'success_timing.mat'],'success*','sorted_success_timing')
end

%% filtering
 %����̓��h���Ȃ������߂Ƀ��R�[�hEMG�f�[�^�Ƀn�C�p�X�t�B���^�[��������I�v�V����
 %highpass==1�͋ؓd��͗p�Afilter==1�̓V�i�W�[��͗p�B������1�ł��鎞�͐���ɍ쓮���Ȃ����Ƃɒ���(������1�ł��_��)
if high_pass == 1
    for ii = 1 : EMG_num
        [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
        temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]);
        temp_EMG = filtfilt(B,A,temp_EMG);
        eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
    end
elseif filter == 1
    for ii = 1 : EMG_num
        %offset
        temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]);
        temp_EMG = offset(temp_EMG, 'mean');
        %high_pass
        [B,A] = butter(6, (filter_h .* 2) ./ SR, 'high');
        temp_EMG = filtfilt(B,A,temp_EMG);
        eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
        %rect
        eval(['CEMG_' sprintf('%03d',ii) ' = abs(CEMG_' sprintf('%03d',ii) ');'])
%         %offset
%         temp_EMG =  eval(['CEMG_' sprintf('%03d',ii)]);
%         offset_value = mean(temp_EMG(1:1000)); %�������Ă��Ȃ��Ƃ��́C���ϒl���Ƃ��Ă���
%         temp_EMG = temp_EMG - offset_value;
%         eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
        %low_pass
%         [B,A] = butter(6, (filter_l .* 2) ./ SR, 'low');
%         temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]);
%         temp_EMG = filtfilt(B,A,temp_EMG);
%         eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
    end    
end
%���n�C�p�X�����܂�

%% �e�^�C�~���O�A�^�X�N���ƂɃf�[�^��؂�o���Đ}��f�[�^��ۑ�����Z�N�V����
%�^�X�N������؂�o���āA���Ԑ��K�����Ĕ�r(�ꉞ�^�C�~���O2,3�̃q�X�g�O�����ƒ����l�̐�������.�^�C�~���O2,3�Ɠ����悤�ɂ��āA2�i�K�̐��K���Ńm�C�Y����������)
% �^�X�N����EMG�̃v���b�g
h = figure();
h.WindowState = 'maximized';
for ii=1:EMG_num
    Data = eval(['CEMG_' sprintf('%03d',ii)]); %�e�ؓ��̑S�̃f�[�^��Data�ɑ������
    task_EMG_sel={};
    %[~,col] = size(success_timing);
    for jj = 1:length(success_timing)
        if few_signal == 1
            task_trim = Data(success_timing(1,jj)+1:success_timing(2,jj));
            task_trim = resample(task_trim,1000,length(task_trim)); %�^�X�N�����Ԑ��K�������f�[�^����
            task_EMG_sel{jj,1} = task_trim;
        else
            task_trim = Data(success_timing(1,jj)+1:success_timing(tim_num,jj));
            tim_hist(1,jj) = ((success_timing(2,jj))-(success_timing(1,jj)+1)) * (1000/length(task_trim));
            tim_hist(2,jj) = ((success_timing(3,jj))-(success_timing(1,jj)+1)) * (1000/length(task_trim));
            if strcmp(task_type, 'drawer')
                tim_hist(3,jj) = ((success_timing(4,jj))-(success_timing(1,jj)+1)) * (1000/length(task_trim));
            end
            task_trim = resample(task_trim,1000,length(task_trim)); %�^�X�N�����Ԑ��K�������f�[�^����
            task_EMG_sel{jj,1} = task_trim;
        end
    end
    save([Data_save_dir '/' 'task_normalized_hist.mat'], "tim_hist")
    task_EMG = cell2mat(task_EMG_sel);
    ave_task_EMG = mean(task_EMG);
    subplot(4,ceil(EMG_num/4), ii)
    for kk = 1:length(task_EMG_sel) %kk:trial_num
        plot(task_EMG(kk,:));
        hold on;
        if filter == 1
            if kk == 1 
                yMax = quantile(max(task_EMG,[], 2), 0.75);
                ylim([0 ceil(ceil(yMax)/10)*10+10]);
            end
        else
            if kk == 1 
                yMax = max(task_EMG(kk,:));
                yMin = min(task_EMG(kk,:)); 
                ylim([yMin-10 yMax+10]);
            elseif max(task_EMG(kk,:)) > yMax
                yMax = max(task_EMG(kk,:));
                ylim([yMin-10 yMax+10]);
            elseif min(task_EMG(kk,:)) < yMin
                yMin = min(task_EMG(kk,:)); 
                ylim([yMin-10 yMax+10]);
            end
        end
        
    end
    if few_signal == 1
        yyaxis right; 
        ylim([0 40])
        title([EMGs{ii} '(uV)'])
        hold off
        All_task_EMG{ii,1} = task_EMG;
        All_ave_task_EMG{ii,1} = ave_task_EMG;
    else
        yyaxis right; 
        ylim([0 60])
        histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
        histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
        tim2_median = median(tim_hist(1,:));
        tim3_median = median(tim_hist(2,:));
        if strcmp(task_type, 'drawer')
            histogram(tim_hist(3,:),15,'FaceColor',[53 187 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
            tim4_median = median(tim_hist(3,:));
            xline(tim4_median , 'green','Color',[53 187 0]/255,'LineWidth',1);
        end
        xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
        xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
        title([EMGs{ii} '(uV)'])
        hold off
        All_task_EMG{ii,1} = task_EMG;
        All_ave_task_EMG{ii,1} = ave_task_EMG;
    end
end

Picture_save_dir = 'EMG_Data/picture';
if not(isfolder(Picture_save_dir))
    mkdir(Picture_save_dir)
end

if high_pass == 1
    saveas(gcf,[Picture_save_dir '/' 'filtered_taskEMG(highpass-' num2str(filt_h) 'Hz).png']);
elseif filter == 1
    saveas(gcf,[Picture_save_dir '/' 'filtered_taskEMG(highpass-' num2str(filter_h) 'Hz-rect).png']);
else
    saveas(gcf,[Picture_save_dir '/' 'RAW_taskEMG.png']);
end

close all;
All_ave_task_EMG = cell2mat(All_ave_task_EMG);

% �^�X�N����EMG�̕��ς��v���b�g
figure('Position',[100,100,800,1200]);

for ll = 1:EMG_num
    subplot(4,ceil(EMG_num/4), ll)
    plot(All_ave_task_EMG(ll,:))
%     ylim([0 ceil(max(All_ave_task_EMG(ll,:)))])
    if exist('y_max')
        ylim([0 y_max])
    end
    hold on;
    if few_signal == 0
        yyaxis right;
        ylim([0 40])
        histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
        histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
        if strcmp(task_type, 'drawer')
            histogram(tim_hist(3,:),15,'FaceColor',[53 187 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.3);
            tim4_median = median(tim_hist(3,:));
            xline(tim4_median , 'green','Color',[53 187 0]/255,'LineWidth',1);
        end
        tim2_median = median(tim_hist(1,:));
        tim3_median = median(tim_hist(2,:));
        xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
        xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
    end
    title([EMGs{ll} '(uV)'])
    hold on
end
hold off


if high_pass == 1
    saveas(gcf,[Picture_save_dir '/' 'ave_filtered_taskEMG(highpass-' num2str(filt_h) 'Hz).png']);
elseif filter == 1
    saveas(gcf,[Picture_save_dir '/' 'ave_filtered_taskEMG(highpass-' num2str(filter_h) 'Hz-rect).png']);
else
    saveas(gcf,[Picture_save_dir '/' 'ave_RAW_taskEMG.png']);
end
close all;

% �^�C�~���O���Ƃ̃v���b�g
if or(few_signal == 1,strcmp(task_type, 'drawer'))
else
%�^�C�~���O1��align����,���Ԑ��K�������Ƀ^�X�N���v���b�g����(ii:�ؓ��̐� jj:�^�X�N�̐�)
    for ii = 1:EMG_num
        for jj = 1:length(success_timing)
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '((success_timing(1,jj)-pre_frame1)+1 : success_timing(1,jj)+post_frame1);'])
            task_EMG_sel{jj,1} = task_trim;
        end
        eval(['task_tim1_EMG_' sprintf('%03d',ii) ' = cell2mat(task_EMG_sel);'])
    end
    
    %��task_EMG_tim1��p���āA�v���b�g(�������O�A������̏d�ˍ��킹�̐})
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        subplot(4,ceil(EMG_num/4), ii)
        for jj = 1:length(success_timing)
            hold on;
            plot(eval(['task_tim1_EMG_' sprintf('%03d',ii) '(jj,:)']))
        end
        xline(pre_frame1,'red','Color',[186 85 211]/255,'LineWidth',2);
        title([EMGs{ii,1} '(uV)'])
        hold off;
    end

    if high_pass == 0
        if filter == 1
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim1-pre' num2str(pre_frame1) '_post-' num2str(post_frame1) 'frame_filtered.png'])
        else
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim1-pre' num2str(pre_frame1) '_post-' num2str(post_frame1) 'frame_RAW.png'])
        end
    else
        saveas(gcf,[Picture_save_dir '/' 'task_aroundTim1-post' num2str(post_frame1) 'frame(high-pass' num2str(filt_h) 'Hz).png']);
    end
    close all;
    
    %���^�C�~���O2��3�łقƂ�Ǔ�����������Ă��邩��A�֐��ɂ��Ċ���������ׂ�
    %�^�C�~���O2��align����,���Ԑ��K�������Ƀ^�X�N���v���b�g����(ii:�ؓ��̐� jj:�^�X�N�̐�)
    timing1_2_maxframe = max(success_distance(1,:)); %�^�C�~���O1~2�̃t���[�����̍ő�l�A��������ƂɁA���̃^�X�N�f�[�^��NaN�ŕ⏞���� 
    for ii = 1:EMG_num
        for jj = 1:length(success_timing)
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(2,jj)+post_frame2);'])
            e_Maxframe = timing1_2_maxframe - success_distance(1,jj); %timing1_2_maxframe�Ƃ̃t���[�����̌덷�B���̒l������NaN����
            if e_Maxframe == 0 %�ő�l����鎞
                
            else
                comp_frame = NaN(1,e_Maxframe);
                task_trim = {comp_frame,task_trim};
                task_trim = cell2mat(task_trim);
            end
            task_EMG_sel{jj,1} = task_trim;
        end
        eval(['task_tim2_EMG_' sprintf('%03d',ii) ' = task_EMG_sel;'])
    end
    
    %��task_EMG_tim2��p���āA�v���b�g(�������O�A������̏d�ˍ��킹�̐})
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        subplot(4,ceil(EMG_num/4), ii)
        for jj = 1:length(success_timing)
            hold on;
            task_trim_tim2 = eval(['task_tim2_EMG_' sprintf('%03d',ii) '{jj,1}((timing1_2_maxframe-pre_frame2)+1 : (timing1_2_maxframe + post_frame2));']);
            plot(task_trim_tim2)
            task_EMG_sel{jj,1} = task_trim_tim2;
        end
        task_EMG_tim2{ii,1} = task_EMG_sel;
        xline(pre_frame2,'red','Color',[186 85 211]/255,'LineWidth',2);
        title([EMGs{ii,1} '(uV)'])
        if ii == 1 
            dim = [0.01 0.6 0.3 0.3];
            str = 'x-axis-unit = 1/1375 [s]';
            annotation('textbox',dim,'String',str,'FitBoxToText','on');
        end
        hold off;
    end
   
    if high_pass == 0
        if filter == 1
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim2-pre' num2str(pre_frame2) '-post' num2str(post_frame2) 'frame_filtered.png'])
        else
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim2-pre' num2str(pre_frame2) '-post' num2str(post_frame2) 'frame_RAW.png'])
        end
    else
        saveas(gcf,['task_aroundTim2-pre' num2str(pre_frame2) '-post' num2str(post_frame2) 'frame(high-pass' num2str(filt_h) 'Hz).png']);
    end
    close all;
    %�������܂�
    %�^�C�~���O3��align����,���Ԑ��K�������Ƀ^�X�N���v���b�g����(ii:�ؓ��̐� jj:�^�X�N�̐�)
    timing1_3_maxframe = max(success_distance(1,:) + success_distance(2,:)); %�^�C�~���O1~3�̃t���[�����̍ő�l�A��������ƂɁA���̃^�X�N�f�[�^��NaN�ŕ⏞���� 
    for ii = 1:EMG_num
        for jj = 1:length(success_timing)
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(3,jj)+post_frame3);'])
            e_Maxframe = timing1_3_maxframe - (success_distance(1,jj)+success_distance(2,jj)); %timing1_3_maxframe�Ƃ̃t���[�����̌덷�B���̒l������NaN����
            if e_Maxframe == 0 %�ő�l����鎞
                
            else
                comp_frame = NaN(1,e_Maxframe);
                task_trim = {comp_frame,task_trim};
                task_trim = cell2mat(task_trim);
            end
            task_EMG_sel{jj,1} = task_trim;
        end
        eval(['task_tim3_EMG_' sprintf('%03d',ii) ' = task_EMG_sel;'])
    end
    
    %��task_EMG_tim3��p���āA�v���b�g
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        subplot(4,ceil(EMG_num/4), ii)
        for jj = 1:length(success_timing)
            hold on;
            task_trim_tim3 = eval(['task_tim3_EMG_' sprintf('%03d',ii) '{jj,1}((timing1_3_maxframe-pre_frame3)+1 : (timing1_3_maxframe + post_frame3));']);
            plot(task_trim_tim3);
            task_EMG_sel{jj,1} = task_trim_tim3;
        end
        task_EMG_tim3{ii,1} = task_EMG_sel;
        xline(pre_frame3,'red','Color',[186 85 211]/255,'LineWidth',2);
        title([EMGs{ii,1} '(uV)'])
        if ii == 1 
            dim = [0.01 0.6 0.3 0.3];
            str = 'x-axis-unit = 1/1375 [s]';
            annotation('textbox',dim,'String',str,'FitBoxToText','on');
        end
        hold off;
    end
   
    if high_pass == 0
        if filter == 1
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim3-pre' num2str(pre_frame3) '-post' num2str(post_frame3) 'frame_filtered.png'])
        else
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim3-pre' num2str(pre_frame3) '-post' num2str(post_frame3) 'frame_RAW.png'])
        end
    else
        saveas(gcf,[Picture_save_dir '/' 'task_aroundTim3-pre' num2str(pre_frame3) '-post' num2str(post_frame3) 'frame(high-pass' num2str(filt_h) 'Hz).png']);
    end
    close all;
    
    %�^�C�~���O4��align����,���Ԑ��K�������Ƀ^�X�N���v���b�g����(ii:�ؓ��̐� jj:�^�X�N�̐�)
    for ii = 1:EMG_num
        for jj = 1:length(success_timing)
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(4,jj)-pre_frame4 + 1 : success_timing(4,jj)+post_frame4);'])
            task_EMG_sel{jj,1} = task_trim;
        end
        eval(['task_tim4_EMG_' sprintf('%03d',ii) ' = cell2mat(task_EMG_sel);'])
    end
    
    %��task_EMG_tim4��p���āA�v���b�g(�������O�A������̏d�ˍ��킹�̐})
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        subplot(4,ceil(EMG_num/4), ii)
        for jj = 1:length(success_timing)
            hold on;
            plot(eval(['task_tim4_EMG_' sprintf('%03d',ii) '(jj,:)']))
        end
        title([EMGs{ii,1} '(uV)'])
        xline(pre_frame4,'red','Color',[186 85 211]/255,'LineWidth',2);
        hold off;
    end

    if high_pass == 0
        if filter == 1
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim4-pre' num2str(pre_frame4) '_post' num2str(post_frame4) 'frame_filtered.png'])
        else
            saveas(gcf,[Picture_save_dir '/' 'task_aroundTim4-pre' num2str(pre_frame4) '_post' num2str(post_frame4) 'frame_RAW.png'])
        end
    else
        saveas(gcf,[Picture_save_dir '/' 'task_aroundTim4-pre' num2str(post_frame4) 'frame(high-pass' num2str(filt_h) 'Hz).png']);
    end
    close all;
end
%�g�p�����ϐ���.mat�t�@�C���ɕۑ�����
if and(few_signal == 0, strcmp(task_type, 'default'))
    if high_pass == 0
        save([Data_save_dir '/' 'task_tim2_pre-' num2str(pre_frame2) '_post-' num2str(post_frame2) 'RAW_EMG.mat'],'task_tim2_EMG*')
        save([Data_save_dir '/' 'task_tim3_pre-' num2str(pre_frame3) '_post-' num2str(post_frame3) 'RAW_EMG.mat'],'task_tim3_EMG*')
    else
        save([Data_save_dir '/' 'task_tim2_pre-' num2str(pre_frame2) '_post-' num2str(post_frame2) '_(highpass-' num2str(filt_h) 'Hz)EMG.mat'],'task_tim2_EMG*')
        save([Data_save_dir '/' 'task_tim3_pre-' num2str(pre_frame3) '_post-' num2str(post_frame3) '_(highpass-' num2str(filt_h) 'Hz)EMG.mat'],'task_tim3_EMG*')
    end
end

%align�������̂ł͂Ȃ��A�e�ؓ��A�e�^�X�N�̃^�X�N�S�̂̋ؓd��ۑ�����
for ii = 1:EMG_num
    for jj = 1:length(success_timing)
        if few_signal == 1
            eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(2,jj));'])
        else
            switch task_type
                case 'default'
                    eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(4,jj));'])
                case 'drawer'
                    eval(['task_trim = CEMG_' sprintf('%03d',ii) '(success_timing(1,jj)+1 : success_timing(5,jj));'])
            end   
        end
        task_EMG_sel{jj,1} = task_trim;
    end
    eval(['task_EMG_' sprintf('%03d',ii) ' = task_EMG_sel;'])
end
if high_pass == 0
    save([Data_save_dir '/' 'task_EMG(RAW_data).mat'],'task_EMG_0*')
else
    save([Data_save_dir '/' task_EMG(high_pass=' num2str(filt_h) ').mat'],'task_EMG_0*')
end

%% compile EMG to use synergy analysis (�؃V�i�W�[�p�̃t�B���^�����O�ς݂̋ؓd��NMF_RESULT��MAT�t�@�C���Ƃ��ĕۑ����邽�߂̃Z�N�V����)
if filter == 1
    nmf_save_fold = [save_NMF_fold '/' monkeyname num2str(exp_day) '_standard'];
    if not(isfolder(nmf_save_fold))
        mkdir(nmf_save_fold);
    end

    %���Ԑ��K�������^�X�N�f�[�^��U�����K����(�m�C�Y�����̂���2��)�A�^�X�N�Ԃ̕��ς����A�v���b�g����B���̌�ANMF�p�ɁA�e�ؓd��MAT�t�@�C���ɂ���nmf_result�̏���̃f�B���N�g���ɕۑ�
    for ii = 1:EMG_num
        clear temp_EMG_sel; %�O���[�v �ł�temp_EMG_sel������
        temp_EMG = All_task_EMG{ii,1}; %����ؓd�̑S�^�X�N�f�[�^��temp_EMG�ɑ��
        stack_EMG{ii,1} = temp_EMG; %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F���邽�߂̕ϐ�
        temp_EMG = median(temp_EMG); %�^�X�N�f�[�^�𕽋ς���(nanmean�̎g�p�ɂ�toolbox���K�v�ȏꍇ������)
        temp_EMG_std = std(temp_EMG); %�^�X�N�f�[�^�̕W���΍������߂�
        %�����[�p�X�t�B���^�[�������ĕ�����
        [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
        temp_EMG = filtfilt(B,A,temp_EMG);
        average_value = median(temp_EMG);
        temp_EMG = temp_EMG / average_value;
        temp_EMG = temp_EMG - min(temp_EMG); %offset
        all_temp_EMG{ii,1} = temp_EMG;
    end
    %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F������
    h = figure();
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
       subplot(4,ceil(EMG_num/4), ii)
       hold on
       [trial_num,~] = size(stack_EMG{ii,1}); %�m�C�Y�^�X�N������̃^�X�N��
       for jj = 1:trial_num
           plot(stack_EMG{ii,1}(jj,:))
       end
%        ylim([0 noize_cri+5]);
       yyaxis right;
       ylim([0 40])
       title([EMGs{ii,1} '(uV)'])
       if few_signal == 0
           histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
           histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
           xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
           xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
       end
       grid on;
    end
    saveas(gcf,[nmf_save_fold '/' 'EMG_stack_TaskTimeNormalized.png'])
    close all;
    %�������������ʂ��ǂ�Ȋ��������m�F������(for���Ńv���b�g�����}�ɂ���)
%     h = figure();
    figure('Position',[100,100,800,1200]);
    for ii = 1:EMG_num
       subplot(4,ceil(EMG_num/4), ii)
       hold on
       plot(all_temp_EMG{ii,1},'LineWidth',2)
       ylim([0 2])
       yyaxis right;
       ylim([0 40])
       title([EMGs{ii,1} '(uV)'])
       if few_signal == 0
           histogram(tim_hist(1,:),15,'FaceColor',[186 85 211]/255,'FaceAlpha',0.5,'EdgeAlpha',0.1);
           histogram(tim_hist(2,:),15,'FaceColor',[255 165 0]/255,'FaceAlpha',0.5,'EdgeAlpha',0.5);
           xline(tim2_median,'red','Color',[186 85 211]/255,'LineWidth',1);
           xline(tim3_median , 'blue','Color',[255 165 0]/255,'LineWidth',1);
       end
       grid on;
    end
    hold off
    saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_TaskTimeNormalized.png']) %�ۑ��ꏊ��nmf_result�̒��ł��邱�Ƃɒ���
    close all;
    %���ۑ�����ϐ����܂Ƃ߂�mat�t�@�C���ɕۑ�
    for ii = 1:EMG_num
        Name = cell2mat(EMGs(ii,1));
        Class = 'continuous channel';
        SampleRate = CEMG_001_KHz*1000;
        Data = all_temp_EMG{ii,1};
        Unit = 'uV';
        save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_TimeNormalized.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
    end

    if and(few_signal == 0, strcmp(task_type, 'default'))
         %tim1�̎���̋ؓd��MAT�t�@�C���ɂ܂Ƃ߂�
        for ii = 1:EMG_num
            clear temp_EMG_sel; %�O���[�v �ł�temp_EMG_sel������
            temp_EMG = eval(['task_tim1_EMG_' sprintf('%03d',ii)]); %����ؓd�̑S�^�X�N�f�[�^��temp_EMG�ɑ��(task_tim1��,pre_frame1,post_frame1����Ɏ��o����EMG)
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %���K���̂��߂ɁA�ؓd�̕��ϒl���o��
            temp_EMG = temp_EMG/ave_EMG; %���K��(1���) 
            noize_cri = 10; %�m�C�Y���肳���U����臒l(�U�����ς̉��{���H)
            %��臒l����ɁA�傫������U��(�����炭�m�C�Y)�����^�X�N����������
            count = 1;
            for jj = 1:length(success_timing) %�^�X�N�񐔕�
                max_amp = max(temp_EMG(jj,:));
                if max_amp < noize_cri
                    temp_EMG_sel{count,1} = temp_EMG(jj,:);
                    count = count+1;
                else
                end
            end
            temp_EMG = cell2mat(temp_EMG_sel);%�����𖞂����Ă�����̂��Ă�temp_EMG�ɑ��
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %�����𖞂������f�[�^�ł̐��K���̂��߂ɁA�ؓd�̕��ϒl���o��
            temp_EMG = temp_EMG/ave_EMG; %���K��(2���) 
            stack_EMG{ii,1} = temp_EMG; %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F���邽�߂̕ϐ�
            temp_EMG = nanmean(temp_EMG); %�n�C�p�X��������̃^�X�N�f�[�^�𕽋ς���(nanmean�̎g�p�ɂ�toolbox���K�v�ȏꍇ������)
            temp_EMG_std = nanstd(temp_EMG); %������̃^�X�N�f�[�^�̕W���΍������߂�
            %�����[�p�X�t�B���^�[�������ĕ�����
            [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
            temp_EMG = filtfilt(B,A,temp_EMG);
            all_temp_EMG{ii,1} = temp_EMG;
        end
        %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F������
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           [trial_num,~] = size(stack_EMG{ii,1}); %�m�C�Y�^�X�N������̃^�X�N��
           for jj = 1:trial_num
               plot(stack_EMG{ii,1}(jj,:))
           end
           ylim([0 noize_cri+5]);
           title([EMGs{ii,1} '(uV)'])
           grid on;
           xline(pre_frame1,'red','Color',[186 85 211]/255,'LineWidth',2);
        end
        saveas(gcf,[nmf_save_fold '/' 'EMG_stack_tim1_pre-' num2str(pre_frame1) '_post' num2str(post_frame1) '.png'])
        close all;
        
        %�������������ʂ��ǂ�Ȋ��������m�F������(for���Ńv���b�g�����}�ɂ���)
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           plot(all_temp_EMG{ii,1})
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame1,'red','Color',[186 85 211]/255,'LineWidth',2);
           ylim([0 2]);grid on;
        end
        hold off
        saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_tim1_pre-' num2str(pre_frame1) '_post' num2str(post_frame1) '.png']) %�ۑ��ꏊ��nmf_result�̒��ł��邱�Ƃɒ���
        close all;
        %���ۑ�����ϐ����܂Ƃ߂�mat�t�@�C���ɕۑ�
        for ii = 1:EMG_num
            Name = cell2mat(EMGs(ii,1));
            Class = 'continuous channel';
            SampleRate = CEMG_001_KHz*1000;
            Data = all_temp_EMG{ii,1};
            Unit = 'uV';
            save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_tim1_pre-' num2str(pre_frame1) '_post' num2str(post_frame1) '.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
        end
        
        %tim2�̎���̋ؓd��MAT�t�@�C���ɂ܂Ƃ߂�
        
        for ii = 1:EMG_num
            clear temp_EMG_sel; %�O���[�v �ł�temp_EMG_sel������
            temp_EMG = cell2mat(task_EMG_tim2{ii,1}); %����ؓd�̑S�^�X�N�f�[�^��temp_EMG�ɑ��
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %���K���̂��߂ɁA�ؓd�̕��ϒl���o��
            temp_EMG = temp_EMG/ave_EMG; %���K��(1���) 
            noize_cri = 10; %�m�C�Y���肳���U����臒l(�U�����ς̉��{���H)
            %��臒l����ɁA�傫������U��(�����炭�m�C�Y)�����^�X�N����������
            count = 1;
            for jj = 1:length(success_timing) %�^�X�N�񐔕�
                max_amp = max(temp_EMG(jj,:));
                if max_amp < noize_cri
                    temp_EMG_sel{count,1} = temp_EMG(jj,:);
                    count = count+1;
                else
                end
            end
            temp_EMG = cell2mat(temp_EMG_sel);%�����𖞂����Ă�����̂��Ă�temp_EMG�ɑ��
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %�����𖞂������f�[�^�ł̐��K���̂��߂ɁA�ؓd�̕��ϒl���o��
            temp_EMG = temp_EMG/ave_EMG; %���K��(2���) 
            stack_EMG{ii,1} = temp_EMG; %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F���邽�߂̕ϐ�
            temp_EMG = nanmean(temp_EMG); %�n�C�p�X��������̃^�X�N�f�[�^�𕽋ς���(nanmean�̎g�p�ɂ�toolbox���K�v�ȏꍇ������)
            temp_EMG_std = nanstd(temp_EMG); %������̃^�X�N�f�[�^�̕W���΍������߂�
            %�����[�p�X�t�B���^�[�������ĕ�����
            [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
            temp_EMG = filtfilt(B,A,temp_EMG);
            all_temp_EMG{ii,1} = temp_EMG;
        end
        %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F������
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           [trial_num,~] = size(stack_EMG{ii,1}); %�m�C�Y�^�X�N������̃^�X�N��
           for jj = 1:trial_num
               plot(stack_EMG{ii,1}(jj,:))
           end
           ylim([0 noize_cri+5]);
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame2,'red','Color',[186 85 211]/255,'LineWidth',2);
           grid on;
        end
        saveas(gcf,[nmf_save_fold '/' 'EMG_stack_tim2_pre-' num2str(pre_frame2) 'post-' num2str(post_frame2) '.png'])
        close all;
        
        %�������������ʂ��ǂ�Ȋ��������m�F������(for���Ńv���b�g�����}�ɂ���)
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           plot(all_temp_EMG{ii,1})
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame2,'red','Color',[186 85 211]/255,'LineWidth',2);
           ylim([0 2]);grid on;
        end
        hold off
        saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_tim2_pre-' num2str(pre_frame2) 'post-' num2str(post_frame2) '.png']) %�ۑ��ꏊ��nmf_result�̒��ł��邱�Ƃɒ���
        close all;
        %���ۑ�����ϐ����܂Ƃ߂�mat�t�@�C���ɕۑ�
        for ii = 1:EMG_num
            Name = cell2mat(EMGs(ii,1));
            Class = 'continuous channel';
            SampleRate = CEMG_001_KHz*1000;
            Data = all_temp_EMG{ii,1};
            Unit = 'uV';
            save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_tim2_pre-' num2str(pre_frame2) '_post-' num2str(post_frame2) '.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
        end
        
        %tim3�̎���̋ؓd��mat�t�@�C���ɂ܂Ƃ߂�
        for ii = 1:EMG_num
            clear temp_EMG_sel; %�O�f�[�^�Ŏg�p����temp_EMG������
            temp_EMG = cell2mat(task_EMG_tim3{ii,1}); %����ؓd�̑S�^�X�N�f�[�^��temp_EMG�ɑ��
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %���K���̂��߂ɁA�ؓd�̕��ϒl���o��
            temp_EMG = temp_EMG/ave_EMG; %���K��(1���)
            noize_cri = 10; %�m�C�Y���肳���U����臒l(�U�����ς̉��{���H)
            %��臒l����ɁA�傫������U��(�����炭�m�C�Y)�����^�X�N����������
            count = 1;
            for jj = 1:length(success_timing) %�^�X�N�񐔕�
                max_amp = max(temp_EMG(jj,:));
                if max_amp < noize_cri
                    temp_EMG_sel{count,1} = temp_EMG(jj,:);
                    count = count+1;
                else
                end
            end
            temp_EMG = cell2mat(temp_EMG_sel);
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %�����𖞂������f�[�^�ł̐��K���̂��߂ɁA�ؓd�̕��ϒl���o��
            temp_EMG = temp_EMG/ave_EMG; %���K��(2���) 
            stack_EMG{ii,1} = temp_EMG; %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F���邽�߂̕ϐ�
            temp_EMG = nanmean(temp_EMG); %�n�C�p�X��������̃^�X�N�f�[�^�𕽋ς���(nanmean�̎g�p�ɂ�toolbox���K�v�ȏꍇ������)
            %�����[�p�X�t�B���^�[�������ĕ�����
            [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
            temp_EMG = filtfilt(B,A,temp_EMG);
            all_temp_EMG{ii,1} = temp_EMG;
        end
        %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F������
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           [trial_num,~] = size(stack_EMG{ii,1}); %�m�C�Y�^�X�N������̃^�X�N��
           for jj = 1:trial_num
               plot(stack_EMG{ii,1}(jj,:))
           end
           ylim([0 noize_cri+5]);
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame3,'red','Color',[186 85 211]/255,'LineWidth',2);
           grid on;
        end
        saveas(gcf,[nmf_save_fold '/' 'EMG_stack_tim3_pre-' num2str(pre_frame3) 'post-' num2str(post_frame3) '.png'])
        close all;
        
        %�������������ʂ��ǂ�Ȋ��������m�F������(for���Ńv���b�g�����}�ɂ���)(�^�X�N�Ԃ̕W���΍����o���āA�w�i�Ƀv���b�g���ׂ�)
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           plot(all_temp_EMG{ii,1})
           ylim([0 2]);
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame3,'red','Color',[186 85 211]/255,'LineWidth',2);grid on;
        end
        hold off
        saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_tim3_pre-' num2str(pre_frame3) 'post-' num2str(post_frame3) '.png']) %�ۑ��ꏊ��nmf_result�̒��ł��邱�Ƃɒ���
        close all;
        %���ۑ�����ϐ����܂Ƃ߂�mat�t�@�C���ɕۑ�
        for ii = 1:EMG_num
            Name = cell2mat(EMGs(ii,1));
            Class = 'continuous channel';
            SampleRate = CEMG_001_KHz*1000;
            Data = all_temp_EMG{ii,1};
            Unit = 'uV';
            save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_tim3_pre-' num2str(pre_frame3) '_post-' num2str(post_frame3) '.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
        end
        %tim4�̎���̋ؓd��MAT�t�@�C���ɂ܂Ƃ߂�
        for ii = 1:EMG_num
            clear temp_EMG_sel; %�O���[�v �ł�temp_EMG_sel������
            temp_EMG = eval(['task_tim4_EMG_' sprintf('%03d',ii)]); %����ؓd�̑S�^�X�N�f�[�^��temp_EMG�ɑ��
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %���K���̂��߂ɁA�ؓd�̕��ϒl���o��
            temp_EMG = temp_EMG/ave_EMG; %���K��(1���) 
            noize_cri = 10; %�m�C�Y���肳���U����臒l(�U�����ς̉��{���H)
            %��臒l����ɁA�傫������U��(�����炭�m�C�Y)�����^�X�N����������
            count = 1;
            for jj = 1:length(success_timing) %�^�X�N�񐔕�
                max_amp = max(temp_EMG(jj,:));
                if max_amp < noize_cri
                    temp_EMG_sel{count,1} = temp_EMG(jj,:);
                    count = count+1;
                else
                end
            end
            temp_EMG = cell2mat(temp_EMG_sel);%�����𖞂����Ă�����̂��Ă�temp_EMG�ɑ��
            ave_EMG = nanmean(reshape(temp_EMG,1,[])); %�����𖞂������f�[�^�ł̐��K���̂��߂ɁA�ؓd�̕��ϒl���o��
            temp_EMG = temp_EMG/ave_EMG; %���K��(2���) 
            stack_EMG{ii,1} = temp_EMG; %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F���邽�߂̕ϐ�
            temp_EMG = nanmean(temp_EMG); %�n�C�p�X��������̃^�X�N�f�[�^�𕽋ς���(nanmean�̎g�p�ɂ�toolbox���K�v�ȏꍇ������)
            temp_EMG_std = nanstd(temp_EMG); %������̃^�X�N�f�[�^�̕W���΍������߂�
            %�����[�p�X�t�B���^�[�������ĕ�����
            [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
            temp_EMG = filtfilt(B,A,temp_EMG);
            all_temp_EMG{ii,1} = temp_EMG;
        end
        %���K�����m�C�Y�^�X�N��������EMG���ǂ�Ȋ������m�F������
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           [trial_num,~] = size(stack_EMG{ii,1}); %�m�C�Y�^�X�N������̃^�X�N��
           for jj = 1:trial_num
               plot(stack_EMG{ii,1}(jj,:))
           end
           ylim([0 noize_cri+5]);
           xline(pre_frame4,'red','Color',[186 85 211]/255,'LineWidth',2);
           title([EMGs{ii,1} '(uV)'])
           grid on;
        end
        saveas(gcf,[nmf_save_fold '/' 'EMG_stack_tim4_pre-' num2str(pre_frame4) '_post' num2str(post_frame4) '.png'])
        close all;
        
        %�������������ʂ��ǂ�Ȋ��������m�F������(for���Ńv���b�g�����}�ɂ���)
        h = figure();
        h.WindowState = 'maximized';
        for ii = 1:EMG_num
           subplot(4,ceil(EMG_num/4), ii)
           hold on
           plot(all_temp_EMG{ii,1})
           title([EMGs{ii,1} '(uV)'])
           xline(pre_frame4,'red','Color',[186 85 211]/255,'LineWidth',2);
           ylim([0 2]);grid on;
        end
        hold off
        saveas(gcf,[nmf_save_fold '/' 'EMG_filtered_tim4_pre-' num2str(pre_frame4) 'post-' num2str(post_frame2) '.png']) %�ۑ��ꏊ��nmf_result�̒��ł��邱�Ƃɒ���
        close all;
        %���ۑ�����ϐ����܂Ƃ߂�mat�t�@�C���ɕۑ�
        for ii = 1:EMG_num
            Name = cell2mat(EMGs(ii,1));
            Class = 'continuous channel';
            SampleRate = CEMG_001_KHz*1000;
            Data = all_temp_EMG{ii,1};
            Unit = 'uV';
            save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_tim4_pre-' num2str(pre_frame4) '_post' num2str(post_frame4) '.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
        end
    end
    %�S�̂���̋؃V�i�W�[���o�p�ɁA�S�̂���̃t�B���^�����OEMG���ۑ�����
    for ii = 1:EMG_num
        temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]); 
        %�����[�p�X�t�B���^�[�������ĕ�����
        [B,A] = butter(6, (after_rect_filter .* 2) ./ SR, 'low');
        temp_EMG = filtfilt(B,A,temp_EMG);
        all_temp_EMG{ii,1} = temp_EMG;
    end
    %���ۑ�����ϐ����܂Ƃ߂�mat�t�@�C���ɕۑ�
    for ii = 1:EMG_num
        Name = cell2mat(EMGs(ii,1));
        Class = 'continuous channel';
        SampleRate = CEMG_001_KHz*1000;
        Data = all_temp_EMG{ii,1};
        Unit = 'uV';
        save([nmf_save_fold '/' cell2mat(EMGs(ii,1)) '(uV)_filtered.mat'], 'Name', 'Class', 'SampleRate','TimeRange', 'Data', 'Unit');
    end
end
cd ../
end

%% set local function
%�^�C�~���O�؂�o���̊֐�
function [start_timing,end_timing] = timing_func1(CAI_001, task_type)
%�y�����z
%CAI001����task_start��task_end�̃^�C�~���O�𒊏o����

judge_arrange =  CAI_001(1,:) > -500; %-500�ȏと�^�X�N��(LED�J�[�e�����Ղ��Ă���)
judge_ID = find(judge_arrange);
%��trim_section�̍쐬(2�s�̔z��ŁA1�s�ڂ�timing1,2�s�ڂ�timing4�ɂȂ��Ă���)
trim_section(1,1) = judge_ID(1,1);
count = 1;
for ii = 2:length(judge_ID)
    disting = judge_ID(1,ii) - judge_ID(1,ii-1);
    if not(disting == 1)
        trim_section(2,count) = judge_ID(1,ii-1);
        count = count+1;
        trim_section(1,count) = judge_ID(1,ii);
    end
end
trim_section(2,end) = judge_ID(1,end);
switch task_type
    case 'default' %Nibali�̎����^�X�N�̎�(repmat��ID�t��������)
        start_timing = [trim_section(1,:);repmat(1,1,length(trim_section))];
        end_timing = [trim_section(2,:);repmat(4,1,length(trim_section))];
    case 'drawer' %drawer�^�X�N�̎�
        start_timing = [trim_section(1,:);repmat(1,1,length(trim_section))];
        end_timing = [trim_section(2,:);repmat(5,1,length(trim_section))];
end
end

% �\���̂̍쐬
function matchedVars = MakeStruct(prefix, workspaceVars)
matchedVars = cell(0);
for ii = 1:length(workspaceVars) 
    VarName = workspaceVars{ii};
    if startsWith(VarName, prefix)
        matchedVars{end+1} = VarName;
    end
end
end

%�^�C�~���O�؂�o���̊֐�2
function [pull_timing, food_on_timing, food_off_timing, success_botton_timing] = timing_func2(timing_struct, task_type)
%�y�����z
% CTLL����food on, food off, success_botton�̃^�C�~���O�𒊏o����

switch task_type
    case 'default' %Nibali��experiment
        pull_timing = ''; %�ꉞ����U���Ƃ��Ȃ��ƃG���[�f��
        food_on_timing = [timing_struct.CTTL_002_Down;repmat(2,1,length(timing_struct.CTTL_002_Down))];
        food_off_timing = [timing_struct.CTTL_002_Up;repmat(3,1,length(timing_struct.CTTL_002_Up))];
        if nargout > 3 %�w�肵���o�͌��ʂ�4�̎�(success_botton�����鎞)
            CTTL_003_Down = timing_struct.CTTL_003_Down;
            success_botton_timing = [CTTL_003_Down;repmat(5,1,length(CTTL_003_Down))]; %CTTL_003��Down�̕����̗p
        end
    case 'drawer' %�V�����^�X�N
        sensor_signal = [timing_struct.CTTL_002_Down;timing_struct.CTTL_002_Up];
        sensor_signal_diff = sensor_signal(2,:) - sensor_signal(1,:);
        time_threshold = 200; %��ς�臒l�ݒ�
        food_index = find(sensor_signal_diff > time_threshold);
        pull_index = setdiff(1:length(sensor_signal_diff), food_index);
        food_data = sensor_signal(:,food_index);
        pull_data = sensor_signal(:, pull_index);
        pull_timing = [pull_data(1,:);repmat(2,1,length(pull_data))];
        food_on_timing = [food_data(1,:); repmat(3,1,length(food_data))];
        food_off_timing = [food_data(2,:); repmat(4,1,length(food_data))]; 
        
        if nargout > 3 %�w�肵���o�͌��ʂ�4�̎�(success_botton�����鎞)
            CTTL_003_Down = timing_struct.CTTL_003_Down;
            success_botton_timing = [CTTL_003_Down;repmat(6,1,length(CTTL_003_Down))]; %CTTL_003��Down�̕����̗p
        end

end

end

%�^�C�~���O�؂�o���̊֐�3
function success_timing = timing_func3(all_timing,success_botton_timing)
% �^�C�~���O�f�[�^�𐮗����āC�����^�X�N�̏�񂾂��𒊏o����
all_timing_num = max(all_timing(2,:)); %4��default 5��drawer
%�^�X�N���Ƃɏ����𕪂���
switch all_timing_num
    case 4
        %1��2��3��4
        task_term1 = '(all_timing(2,ii+1)==2 && all_timing(2,ii+2)==3 && all_timing(2,ii+3)==4)';
        %122345 or 12354
        task_term2 = '(all_timing2(2,ii+1)==2 && all_timing2(2,ii+2)==3 && all_timing2(2,ii+3)==4 && all_timing2(2,ii+4)==5) || (all_timing2(2,ii+1)==2 && all_timing2(2,ii+2)==3 && all_timing2(2,ii+3)==5 && all_timing2(2,ii+4)==4)';
    case 5
        %1��2��3��4��5
        task_term1 = '(all_timing(2,ii+1)==2 && all_timing(2,ii+2)==3 && all_timing(2,ii+3)==4 && all_timing(2,ii+4)==5)';
        %123456
        task_term2 = '(all_timing2(2,ii+1)==2 && all_timing2(2,ii+2)==3 && all_timing2(2,ii+3)==4 && all_timing2(2,ii+4)==5 && all_timing2(2,ii+5)==6)';
end

%���^�X�N�^�C�~���O�̒�`�@(1~4�����Ԃɖ������Ă�����̂̒��o)
count = 1; 
for ii = 1:length(all_timing)
    if all_timing(2,ii) == 1
        if eval(task_term1)
            success_timing1{1,count} = all_timing(:,ii:ii+(all_timing_num-1));
            count = count+1;
        end
    end
end
success_timing1 = cell2mat(success_timing1);

switch nargin %success_timing�̍쐬(success_botton�����邩�ǂ�����)
    case 1 %success_botton���Ȃ���
        task_trial = length(success_timing1)/4; %�g���C�A����
        for ii = 1:task_trial
            success_timing{1,ii} =  transpose(success_timing1(1,4*(ii-1)+1:4*ii));
        end

    case 2 %success_botton����
        %���^�X�N�^�C�~���O�̒�`�A(�@�𖞂����Ă�����̂�timing5�������ē���������s��)
        all_timing2 = {success_timing1 success_botton_timing};
        all_timing2 = sort_timing(cell2mat(all_timing2),1); 
        count = 1;
        for ii = 1:length(all_timing2)
            if all_timing2(2,ii) == 1
                %���G���[������邽�߂ɕK�v
                if length(all_timing2) - ii < 5 
    
                elseif eval(task_term2) 
                    success_timing{1,count} =  transpose(all_timing2(1,ii:ii+(all_timing_num-1)));       
                    count = count+1;
                end
            end
        end
end
success_timing = cell2mat(success_timing); 
end