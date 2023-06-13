clear
%% settings
monkeyname = 'Wa';
days = [180925 180926 180927 180928 181002 181019 181022 181025 181101 181108 181109 181112 181114 181121 181122 181126 181127];
%  days = [181101 181108 181109 181112 181114 181121 181122 181126 181127];
%  days = [181122 181126 181130];
 group_num = 5;
 syn_num = 5;
 
 EMGgroups = ones(1,length(days)).* group_num;
 
 switch group_num
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
 
% days = [180928 181019];
% EMGgroups = [1,1];
% EMG_num = 12;

save_data = 1;
save_fig = 1;
%% load
Wx =  cell(1,length(days));

for i = 1:length(days)
    cd([monkeyname mat2str(days(i))])
    cd([monkeyname mat2str(days(i)) '_syn_result_' sprintf('%d',EMG_num)])
    cd([monkeyname mat2str(days(i)) '_W'])
        load([monkeyname mat2str(days(i)) '_aveW_' sprintf('%d',syn_num)],'aveW');
        Wx{i} = aveW;
    cd ../../../
end

Wcom = zeros(EMG_num,syn_num);
Wt = cell(1,length(days));
Wt = Wx;
Wxs = Wx;
aveWt = Wt{1};
m = zeros(length(days),syn_num);
k_arr = ones(syn_num, length(days));
for i =  1:syn_num
    k_arr(i,1) = i;
    for j = 2:length(days)
        for l = 1:syn_num
            Wcom(:,l) = (Wx{1,1}(:,i) - Wx{1,j}(:,l)).^ 2;
            m(j,l) = sum(Wcom(:,l));
        end
        Wt{1,j}(:,i) = Wx{1,j}(:,find(m(j,:)==min(m(j,:))));
        Wx{1,j}(:,find(m(j,:)==min(m(j,:)))) = ones(EMG_num,1).*1000;
        k_arr(i,j) = find(m(j,:)==min(m(j,:)));
    end
end
Walt = cell2mat(Wt);
Wall = Walt;
for i = 1:length(days)  
    for j=1:syn_num
        Wall(:,(i-1)*syn_num+j) = Wall(:,(j-1)*syn_num+i);
    end
end

%% plot bar
x = categorical(EMGs');
f1 = figure('Position',[300,0,600,1000]);
for i=1:syn_num 
    subplot(syn_num,1,i);
    bar(x,[Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) ...
        Wt{10}(:,i) Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i)]);
    ylim([0 3]);
    title([monkeyname mat2str(days) '  Wt ']);
end
for j=1:length(days)
%     for i=1:syn_num 
%         subplot(syn_num,1,j + (i-1)*length(days));
%         bar(x,Wt{j}(:,i));
%         ylim([0 3]);
%     end
    aveWt = (aveWt.*(j-1) + Wt{j})./j;
end
f2 = figure('Position',[900,0,600,1000]);
x = 1:1:EMG_num;
errt = zeros(EMG_num,syn_num);
for i=1:syn_num
errt(:,i) = std(Wall(:,(i-1)*length(days)+1:i*length(days)),1,2)./sqrt(length(days));
subplot(syn_num,1,i);
bar(x,aveWt(:,i));
hold on;
e1 =errorbar(x,aveWt(:,i),errt(:,i),'MarkerSize',1);
ylim([-1 4])
e1.Color = 'r';
e1.LineWidth = 2;
e1.LineStyle = 'none';
title([monkeyname mat2str(days) '  aveWt, SEM']);
end
% for i=1:length(days)
%     Wt{i} = Wdata([monkeyname mat2str(days(i))],EMGgroups(i));
% end
%% save order for aveH plot
if save_fig == 1
     cd syn_figures;
        saveas(f1,['W' syn_num mat2str(days) '_hist.bmp']);
        saveas(f2,['aveW' syn_num mat2str(days) '_hist.bmp']);
     cd ../;
end

if save_data == 1
    cd order_tim_list
    mkdir([monkeyname mat2str(days)]);
    cd([monkeyname mat2str(days)])
    comment = 'this data were made for aveH plot';
    save([monkeyname mat2str(days) '_' syn_num '.mat'], 'k_arr','comment', 'days', 'EMG_num', 'syn_num');
    cd ../../
end
