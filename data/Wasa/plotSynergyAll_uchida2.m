function plotSynergyAll_uchida(fold_name,emg_group,pcNum)
%% set para & get nmf result
% fold_name = 'Wa180928';
% 
% emg_group = 1;

switch emg_group
    case 1
        
        %first try
        EMG_num = 12;
        EMGs = {'Biceps';'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';...
                'FDS';'Triceps'};
    case 2
        %only extensor
        EMG_num = 5;
        EMGs = {'ECR';'ECU';'ED23';'ED45';'EDC'};
    case 3
        %only flexor
        EMG_num = 4;
        EMGs = {'FCR';'FCU';'FDP';'FDS'};
    case 4
        %forearm
        EMG_num = 10;
        EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS'};
    case 5
    %forearm
    EMG_num = 11;
    EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'Triceps'};     
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

save_fig_W = 0;
save_fig_H = 0;
save_fig_VAF = 0;

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
f1 = figure('Position',[0,0,800,1300]);
x = categorical(EMGs');
for i = 1:pcNum
    subplot(pcNum,1,i); 
    bar(x,[cell_selD{1,1}(:,i) cell_selD{1,2}(:,i) cell_selD{1,3}(:,i) cell_selD{1,4}(:,i)]);
    ylim([0 3.5]);
    title([fold_name ' W pcNum = ' sprintf('%d',pcNum)]);
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
 [bH,aH]=butter(2,0.05/(freq/2),'high'); 
 [bL,aL]=butter(2,20/(freq/2),'low');
%smooth_num = 100;

len_kf = length(test.H{1,1}(1,:));
All_T = zeros(pcNum,len_kf .* kf);
for i = 1:pcNum
    for j = 1:kf
        All_T(i,((j-1) * len_kf + 1):(j * len_kf)) = cell_selH{1,j}(i,:);
    end
end

%% normalizer1
%TIME_W = 150;
%ave = zeros(pcNum,TIME_W);
%pullData = zeros(SUC_num,TIME_W);
%sec = zeros(3,1);
%f2 = figure('Position',[900,0,800,1300]);
%for j=1:pcNum
%    for i=1:SUC_num
%       subplot(pcNum,1,j);
%       time_w = SUC_Timing_A(i,4) - SUC_Timing_A(i,1) +1;
%       if time_w == TIME_W
%           sec(1,1) = sec(1,1)+1;
%           pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)))));
%      elseif time_w<TIME_W 
%           sec(2,1) = sec(2,1)+1;
%           pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, interpft(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W))));
%       else
%           sec(3,1) = sec(3,1)+1;
%          pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, resample(All_T(j,SUC_Timing_A(i,1):SUC_Timing_A(i,4)),TIME_W,time_w))));
%       end
%      plot(pullData(i,:));
%       ave(j,:) = ((ave(j,:) .* (i-1)) + pullData(i,:)) ./ i ;
%       ylim([0 2]);
%       hold on;
%    end
%end
%% normalizer2
T1 = SUC_Timing_A(:,1:3);
T2 = SUC_Timing_A(:,2:4);
Tim_range = T2 - T1;
Tim_range_ave = floor(mean(Tim_range));
all_pullData = zeros(SUC_num,sum(Tim_range_ave)-2);
%ave = zeros(pcNum,TIME_W);
%pullData = zeros(SUC_num,TIME_W);
sec = zeros(3,1);
f2 = figure('Position',[900,0,800,1300]);
for j=1:pcNum
    for term =1:length(Tim_range_ave)
         pullData = zeros(SUC_num, Tim_range_ave(term));
        for i=1:SUC_num
           subplot(pcNum,1,j);
           time_w = SUC_Timing_A(i,term+1) - SUC_Timing_A(i,term) +1;
           if time_w == Tim_range_ave(term)
               sec(1,1) = sec(1,1)+1;
               pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, All_T(j,SUC_Timing_A(i,term):SUC_Timing_A(i,term+1)))));
           elseif time_w<Tim_range_ave(term)
               sec(2,1) = sec(2,1)+1;
               pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, interpft(All_T(j,SUC_Timing_A(i,term):SUC_Timing_A(i,term+1)),Tim_range_ave(term)))));
           else
               sec(3,1) = sec(3,1)+1;
               pullData(i,:) = filtfilt(bL,aL, abs(filtfilt(bH,aH, resample(All_T(j,SUC_Timing_A(i,term):SUC_Timing_A(i,term+1)),Tim_range_ave(term),time_w))));
           end
        end  
        if term == 1
            all_pullData(:,1:Tim_range_ave(term)) = pullData; 
        end
        if term == 2
            all_pullData(:,Tim_range_ave(term-1)+1:Tim_range_ave(term-1)+Tim_range_ave(term)-1) = pullData(:,2:Tim_range_ave(term)); 
        end
        if term == 3
            all_pullData(:,Tim_range_ave(term-2)+Tim_range_ave(term-1):sum(Tim_range_ave)-2) = pullData(:,2:Tim_range_ave(term)); 
        end
    end
    
     for i=1:SUC_num
                subplot(pcNum,1,j); plot(all_pullData(i,:),'Color',[0,0,0]);
                hold on;
     end
    plot([Tim_range_ave(1) Tim_range_ave(1)],[0 100],'r');
    hold on;
    plot([Tim_range_ave(1)+Tim_range_ave(2)-1 Tim_range_ave(1)+Tim_range_ave(2)-1],[0 100],'r');
    hold on;
    plot(mean(all_pullData),'r');
    ylim([0 3]);
    xlim([0 sum(Tim_range_ave)-2]);
    hold on;

   
end
%% plotH
if save_fig_H ==1
    cd ([fold_name '_syn_result_' sprintf('%02d',EMG_num)])
    cd ([fold_name '_H'])
    saveas(gcf,[fold_name ' H_nomalized pcNum = ' sprintf('%d',pcNum) '.fig']);
    saveas(gcf,[fold_name ' H_nomalized pcNum = ' sprintf('%d',pcNum) '.bmp']);
    cd ../;
    cd ../;
end
% f3=figure('Position',[900,0,800,1300]);
% for j=1:pcNum
%     subplot(pcNum,1,j);
%     plot(filtfilt(bL,aL, abs(filtfilt(bH,aH, ave(j,:)))),'r');
%     ylim([0 2]);
%     hold on;
% end
% 
% if save_fig_H ==1
%     cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
%     cd ([fold_name '_H'])
%     saveas(gcf,[fold_name ' H_ave pcNum = ' sprintf('%d',pcNum) '.fig']);
%     saveas(gcf,[fold_name ' H_ave pcNum = ' sprintf('%d',pcNum) '.bmp']);
%     cd ../;
%     cd ../;
% end

%% plot 
f4 = figure;
for i= 1:kf
    %plot((1 - cell2mat(test.D(:,i)))*100);
    plot((1 - cell2mat(test.D(:,i)))*100);
    %plot((1 - cell2mat(train.D(:,i)))*100);
    ylim([0 100]);
    hold on;
end
    plot([0 EMG_num + 1],[80 80]);
    title([fold_name ' VAF']);
if save_fig_VAF ==1
    cd([fold_name '_syn_result_' sprintf('%02d',EMG_num)]);
    cd ([fold_name '_VAF'])
    saveas(gcf,[fold_name ' VAF pcNum = ' sprintf('%d',pcNum) '.bmp']);
    cd ../;
    cd ../;
end
cd ../
cd ../
end