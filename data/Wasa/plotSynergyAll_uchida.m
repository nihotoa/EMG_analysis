function plotSynergyAll_uchida(fold_name,emg_group,pcNum,plk)
%% set para & get nmf result
% fold_name = 'Wa180928';
% 
% emg_group = 1;

switch emg_group
    case 1%without 'Deltoid'
        EMG_num = 12;
        EMGs = {'Biceps';'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';...
                'FDS';'Triceps'};
    case 2%only extensor
        EMG_num = 5;
        EMGs = {'ECR';'ECU';'ED23';'ED45';'EDC'};
    case 3%only flexor
        EMG_num = 4;
        EMGs = {'FCR';'FCU';'FDP';'FDS'};
    case 4%forearm?
        EMG_num = 10;
        EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS'};
    case 5%~11/27
        EMG_num = 11;
        EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'Triceps'}; 
    case 6%11/30~
        EMG_num = 10;
        EMGs = {'BRD';'ECR';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'Triceps'}; 
end

save_fold = 'new_nmf_result';
cd(save_fold)
cd(fold_name)
load([fold_name '_' sprintf('%02d',EMG_num) '.mat']);
load([fold_name '_' sprintf('%02d',EMG_num) '_nmf.mat']);

% pcNum = 3;
kf = 4;
freq = 100;
range_t = Info.TimeRange(1,2) - Info.TimeRange(1,2);
filt_on = 0;

save_fig_W = 0;
save_fig_H = 0;
save_fig_VAF = 0;
save_fig_r2 = 0; 

save_data = 1;
%% make W&T good by W 2
cell_selD = cell(1,kf);
cell_selH = cell(1,kf);
cell_selD{1,1} = test.W{pcNum,1};
cell_selH{1,1} = test.H{pcNum,1};
comD = zeros(EMG_num, pcNum);
comD_state = zeros(EMG_num, pcNum);
selD = zeros(EMG_num,pcNum);
selH = zeros(pcNum,length(test.H{pcNum,1}(1,:)));
m = zeros(1,pcNum);
for n = 1:kf-1%make no doubled!!!!!!
    k = zeros(1,pcNum);
    for i = 1:pcNum
        for j = 1:pcNum
            comD(:,j) = test.W{pcNum,1}(:,i);
        end
        comD_state = abs(comD - test.W{pcNum,n+1});
        for j = 1:pcNum
            m(1,j) = sum(comD_state(:,j)); 
            for l=1:pcNum              
                if j == k(1,l)
                    m(1,j) = 1000000;
                end
            end
        end
        min_ar = find( m(1,:) == min(m));
        k(1,i) = min_ar;
        selD(:,i) = test.W{pcNum,n+1}(:,min_ar);
        selH(i,:) = test.H{pcNum,n+1}(min_ar,:);
    end
    cell_selD{1,n+1} = selD;
    cell_selH{1,n+1} = selH;
end
%% plot W
f1 = figure('Position',[0,1000,800,1300]);
x = categorical(EMGs');
aveW = zeros(EMG_num,pcNum);
for i = 1:pcNum
    subplot(pcNum,1,i); 
    bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i) cell_selD{1,3}(:,i) cell_selD{1,4}(:,i)]);
    aveW(:,i) = (cell_selD{1,1}(:,i) + cell_selD{1,2}(:,i) + cell_selD{1,3}(:,i) + cell_selD{1,4}(:,i)) ./ 4;
%     bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i)]);
    ylim([0 3.5]);
    title([fold_name ' W pcNum = ' sprintf('%d',pcNum)]);
end
if save_data == 1
    cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
    cd ([fold_name '_W'])
    comment = 'this data will be used for dispW';
    save([fold_name '_aveW_' sprintf('%d',pcNum) '.mat'], 'aveW','k','pcNum','fold_name','comment');
    cd ../../
end
if save_fig_W ==1
    cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
    cd ([fold_name '_W'])
    saveas(gcf,[fold_name ' W pcNum = ' sprintf('%d',pcNum) '.bmp']);
    cd ../
    cd ../
end
%% plot T
load([fold_name '_SUC_Timing.mat']);
SUC_Timing_A = floor(SUC_Timing_A ./ 110);

if filt_on == 1
 [bH,aH]=butter(2,0.05/(freq/2),'high'); 
 [bL,aL]=butter(2,30/(freq/2),'low');
%smooth_num = 100;
end

if plk == 1
    len_kf = length(test.H{1,1}(1,:));
    All_T = zeros(pcNum,len_kf .* kf);
    for i = 1:pcNum
        for j = 1:kf
            All_T(i,((j-1) * len_kf + 1):(j * len_kf)) = cell_selH{1,j}(i,:);
        end
    end
     %SUC_num = 72;%length(T_timing(:,1));
    TIME_W = 150;
    ave = zeros(pcNum,TIME_W);
    pullData = zeros(SUC_num,TIME_W);
    sec = zeros(3,1);
    f2 = figure('Position',[900,1000,800,1300]);
    for j=1:pcNum
        for i=1:SUC_num
           subplot(pcNum,1,j);
           time_w = SUC_Timing_A(i,4) - SUC_Timing_A(i,1) +1;
           if time_w == TIME_W
               sec(1,1) = sec(1,1)+1;
               if filt_on == 1
                   pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)))));
               else
                   pullData(i,:) = All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4));
               end
           elseif time_w<TIME_W 
               sec(2,1) = sec(2,1)+1;
               if filt_on == 1
               pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W))));
               else
                   pullData(i,:) = interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W);
               end
           else
               sec(3,1) = sec(3,1)+1;
               if filt_on == 1
                   pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w))));
               else
                   pullData(i,:) = resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w);
               end
           end
           plot(pullData(i,:));
           ave(j,:) = ((ave(j,:) .* (i-1)) + pullData(i,:)) ./ i ;
           ylim([0 2]);
           hold on;
        end
    end
end

if plk == 2
    
end 

if save_data == 1
    cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
    cd ([fold_name '_H'])
    aveH = ave;
    comment = 'this data will be used for dispH';
    save([fold_name '_aveH_' sprintf('%d',pcNum) '.mat'], 'aveH','k','pcNum','fold_name','comment');
    cd ../../
end

if save_fig_H ==1
    cd ([fold_name '_syn_result_' sprintf('%02d',EMG_num)])
    cd ([fold_name '_H'])
    saveas(gcf,[fold_name ' H_2 pcNum = ' sprintf('%d',pcNum) '.fig']);
    saveas(gcf,[fold_name ' H_2 pcNum = ' sprintf('%d',pcNum) '.bmp']);
    cd ../;
    cd ../;
end

 f3=figure('Position',[900,1000,800,1300]);
 for j=1:pcNum
     subplot(pcNum,1,j);
     plot(ave(j,:),'r');
     ylim([0 2]);
     hold on;
 end
 
 if save_fig_H ==1
     cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
     cd ([fold_name '_H'])
     saveas(gcf,[fold_name ' H_ave pcNum = ' sprintf('%d',pcNum) '.fig']);
     saveas(gcf,[fold_name ' H_ave pcNum = ' sprintf('%d',pcNum) '.bmp']);
     cd ../;
     cd ../;
 end

%% plot r2
f5 = figure;
load([fold_name '_' sprintf('%02d',EMG_num) '.mat']);
for i= 1:kf
    %plot((1 - cell2mat(test.D(:,i)))*100);
    plot(test.r2(:,i));
    %plot((1 - cell2mat(train.D(:,i)))*100);
    ylim([0 1]);
    hold on;
    plot(shuffle.r2(:,i),'Color',[0,0,0]);
    hold on
end

    plot([0 EMG_num + 1],[0.8 0.8]);
    title([fold_name ' R^2']);
    
if save_fig_r2 ==1
    cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
    cd ([fold_name '_r2'])
    saveas(gcf,[fold_name ' R2 pcNum = ' sprintf('%d',pcNum) '.bmp']);
    cd ../;
    cd ../;
end

cd ../
cd ../
end