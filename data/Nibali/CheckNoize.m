%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ノイズを視覚化するためのプログラム
%頼まれたので書いた
%Nibariをカレントディレクトリにして使用する
%改善点:
%xlimとylimを設ける
%保存方法
%ハイパスかけるオプション
%関さんにサンプル画像見せたらOKもらえたから、改善点は改善されていない
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
exp_day = 20220414;
monkey_name = 'Ni';
pre = 2000; %1タスク目の前、何サンプリングまでトリミングするか
post = 2000; %3タスク目の後、何サンプリングまでトリミングするか
high_pass = 1; %基線の動揺をなくすためにハイパスをかけるかどうか
SR = 1375; %筋電データのサンプリングレート
filt_h = 50;%カットオフ周波数の値

selEMGs= 1:16;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
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
cd(num2str(exp_day))
load(['AllData_' monkey_name num2str(exp_day) '.mat'])
cd('EMG_Data/Data')
load('success_timing.mat')
%%define high-pass flter
if high_pass == 1
    for ii = 1 : EMG_num
        [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
        temp_EMG = eval(['CEMG_' sprintf('%03d',ii)]);
        temp_EMG = filtfilt(B,A,temp_EMG);
        eval(['CEMG_' sprintf('%03d',ii) ' = temp_EMG;'])
    end
else
    
end

%% 3タスク分をトリミング
h = figure();
h.WindowState = 'maximized';
for ii = 1:EMG_num
    subplot(4,4,ii)
    for jj = 1 %重ね合わせの回数
        %task_trim = CEMG_001(1,success_timing(3*jj-2,1)+1 : success_timing(3*jj,4));
        eval(['task_trim = CEMG_' sprintf('%03d',ii) '(1,(success_timing(3*jj-2,1)+1) - pre : success_timing(4,3*jj)+post);'])
        task_criterion = success_timing(1,1) - pre;
        task_tim{1,1} = [pre,success_timing(2,1)-task_criterion,success_timing(3,1)-task_criterion,success_timing(4,1)-task_criterion];
        task_tim{2,1} = [success_timing(1,2)-task_criterion,success_timing(2,2)-task_criterion,success_timing(3,2)-task_criterion,success_timing(4,2)-task_criterion];
        task_tim{3,1} = [success_timing(1,3)-task_criterion,success_timing(2,3)-task_criterion,success_timing(3,3)-task_criterion,success_timing(4,3)-task_criterion];
        plot(task_trim);
        hold on;
        xlim([0 length(task_trim)])
        %ylim([]) あとで追加する
        for kk = 1:3%表示するタスク数
            for ll = 1:4 %タスクタイミング
                if ll == 1
                    xline(task_tim{kk,1}(1,ll),'red','Color',[255 0 0]/255,'LineWidth',1);
                elseif ll == 2
                    xline(task_tim{kk,1}(1,ll),'red','Color',[186 85 211]/255,'LineWidth',1);
                elseif ll == 3
                    xline(task_tim{kk,1}(1,ll),'red','Color',[0 255 0]/255,'LineWidth',1);
                elseif ll == 4
                    xline(task_tim{kk,1}(1,ll),'red','Color',[0 0 255]/255,'LineWidth',1);
                end
            end
        end
    end
    title([EMGs{ii,1} '(uV)'])
end
cd ../
cd picture

if high_pass == 1
    saveas(gcf,['CheckNoize_HighPass(' num2str(filt_h) 'Hz)_pre-' num2str(pre) '_post' num2str(post) '.png'])
else 
    saveas(gcf,['CheckNoize_RAW_pre-' num2str(pre) '_post' num2str(post) '.png'])
end
close all
cd ../../../;
