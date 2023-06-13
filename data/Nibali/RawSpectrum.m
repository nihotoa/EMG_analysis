%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coded by: Naohito Ohta
% Last modification: 2022/04/05
% EMG��RAW�f�[�^�ɑ΂��āA�X�y�N�g����͂��s���A���ʂ��v���b�g���A�}�݂̂�ۑ�����R�[�h
% ���O�����Ƃ���HighPass1Hz���s���I�v�V����������
% ���P�_�F
% �����RAW�f�[�^�ɑ΂��Ă����X�y�N�g����͂��ł��Ȃ��B(�t�B���^��̃f�[�^��ǂݍ���ŁA�X�y�N�g����͂���I�v�V����������ׂ�)y�����w�肳��Ă��Ȃ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set parameters
exp_day = 20220324;
save_fold = 'EMG_Data';
task = 'standard';
monkey_name = 'Ni';
plot_Raw = 1; %�Ӗ��𖼂��ĂȂ��ϐ��A���P���ׂ�(������IF�����Ńn�C�p�X���s���Ă��邩��t�B���^������ɂ��揑���Ȃ��ɂ��悱����1����Ȃ��Ƃ����Ȃ�)
conduct_highpass = 1;%���f�[�^�Ƀn�C�p�X�����邩�ǂ���(�J�b�g�I�t���g���͉���filt_h�Œ�`����)
filt_h = 5;%�n�C�p�X�̃J�b�g�I�t���g��


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
if strcmp(save_fold,'nmf_result')
    cd([num2str(exp_day) '/' save_fold '/' monkey_name num2str(exp_day) '_' task ])
elseif strcmp(save_fold,'EMG_Data')
    mkdir([num2str(exp_day) '/EMG_Data/picture'])
end
AnalyzeRaw(plot_Raw,EMG_num,EMGs,conduct_highpass,filt_h,exp_day,monkey_name)
cd ../../../
%% define spectrum analyze 
function  [] = AnalyzeRaw(plot_Raw,EMG_num,EMGs,conduct_highpass,filt_h,exp_day,monkey_name)
    if plot_Raw == 1
        figure('Position',[0,0,1000,1000]);
        cd(num2str(exp_day));
        load(['AllData_' monkey_name num2str(exp_day) '.mat'],'CEMG*');
        for ii=1:EMG_num
            subplot(4,4,ii);
            %set param
            L = length(eval(['CEMG_' sprintf('%03d',ii)])); %length of signal
            Fs = 1375; %sample rate
            %highpassfilter
            if conduct_highpass == 1
                %Data(1,:) = Data(1,:) - mean(Data(1,:));
                [B,A] = butter(6, (filt_h .* 2) ./ Fs, 'high');
                %CEMG_001(1,:) = filtfilt(B,A,CMEG_001(1,:));
                eval(['CEMG_' sprintf('%03d',ii) '(1,:) = filtfilt(B,A,CEMG_' sprintf('%03d',ii) '(1,:));'])
            end
            %conduct & plot the result of fft
            Y = fft(eval(['CEMG_' sprintf('%03d',ii)]));
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            f = Fs*(0:(L/2))/L;
            plot(f,P1) 
            title([EMGs{ii,1} '-PowerSpector'])
            hold on
        end
        
        hold off
        if conduct_highpass == 1
            saveas(gcf,['Raw-spector-check(' num2str(filt_h) 'Hz-highpass).png'])
            saveas(gcf,['Raw-spector-check(' num2str(filt_h) 'Hz-highpass).fig'])
        else
            saveas(gcf,'Raw-spector-check.png')
            saveas(gcf,'Raw-spector-check.fig')
        end
        close all;
    end
end