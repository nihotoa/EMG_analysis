%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coded by: Naohito Ohta
% Last modification: 2022/04/05
% EMGのRAWデータに対して、スペクトル解析を行い、結果をプロットし、図のみを保存するコード
% 事前処理としてHighPass1Hzを行うオプションもある
% 改善点：
% 現状でRAWデータに対してしかスペクトル解析ができない。(フィルタ後のデータを読み込んで、スペクトル解析するオプションをつけるべき)y軸が指定されていない
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set parameters
exp_day = 20220324;
save_fold = 'EMG_Data';
task = 'standard';
monkey_name = 'Ni';
plot_Raw = 1; %意味を名してない変数、改善すべき(こいつのIF文中でハイパスが行われているからフィルタかけるにせよ書けないにせよこいつは1じゃないといけない)
conduct_highpass = 1;%生データにハイパスかけるかどうか(カットオフ周波数は下のfilt_hで定義する)
filt_h = 5;%ハイパスのカットオフ周波数


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