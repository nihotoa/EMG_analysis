clear
%% settings
monkeyname = 'Wa';
 days = [181101 181108 181109 181112 181114 181121 181122 181126 181127];
%  days = [181122 181126 181130];
 group_num = 5;
 syn_num = 5;
 tRange = 1500;
 synH_Hz = 100;
 t_num = tRange/1000 * synH_Hz;
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
save_fig = 1;
%% load
Hx =  cell(1,length(days));

for i = 1:length(days)
    cd([monkeyname mat2str(days(i))])
    cd([monkeyname mat2str(days(i)) '_syn_result_' sprintf('%d',EMG_num)])
    cd([monkeyname mat2str(days(i)) '_H'])
        load([monkeyname mat2str(days(i)) '_aveH_' sprintf('%d',syn_num)],'aveH');
        Hx{i} = aveH;
    cd ../../../
end

cd order_tim_list
cd([monkeyname mat2str(days)])
    load([monkeyname mat2str(days) '_'  syn_num '.mat'],'k_arr');
    load Tim_per.mat;
cd ../../



Hcom = zeros(syn_num,t_num);
Ht = cell(1,length(days));
Ht = Hx;
Hxs = Hx; 
aveHt = Ht{1};
m = zeros(length(days),syn_num);
for i =  1:syn_num
    for j = 2:length(days)
        for l = 1:syn_num
            Hcom(l,:) = (Hx{1,1}(i,:) - Hx{1,j}(l,:)).^ 2;
            m(j,l) = sum(Hcom(l,:));
        end
%         Ht{1,j}(i,:) = Hx{1,j}(find(m(j,:)==min(m(j,:))),:);
%         Hx{1,j}(find(m(j,:)==min(m(j,:))),:) = ones(1,t_num).*1000;
        Ht{1,j}(i,:) = Hx{1,j}(k_arr(i,j),:);
        Hx{1,j}(k_arr(i,j),:) = ones(1,t_num).*1000;
    end
end

AVE = Ht{1,1};
SD = Ht{1,1};
SDf = Ht{1,1};
for i = 2:length(days)
    AVE = AVE + Ht{1,i};
end
AVE = AVE./length(days);
for j = 1:syn_num
    for i = 1:length(days)
        SDf(i,:) = Ht{1,i}(j,:);
    end
    SD(j,:) = std(SDf,1,1);
end
mSD = -SD;
%% plot
eval(['All_tim_per = ' monkeyname mat2str(days(1)) '_SUC_tim_per;'])
for i=1:length(days)
%     eval(['All_tim_per(i,:) = mean(' monkeyname mat2str(days(i)) '_SUC_tim_per);'])
eval(['All_tim_per = [All_tim_per; ' monkeyname mat2str(days(i)) '_SUC_tim_per];'])

end
All_tim_per = All_tim_per.*100;
f1 = figure('Position',[300,0,600,1000]);
x_per = linspace(0,100,t_num);
for i=1:syn_num 
    subplot(syn_num,1,i);
    yyaxis left;
    h1 = histogram(All_tim_per(:,2),'BinWidth',5,'FaceColor',[0.6 0 0.5]);
    hold on;
%     tim_per_m = mean(All_tim_per(:,1));
%     plot([tim_per_m tim_per_m],[0 30],'r');
%     hold on;
    h2 = histogram(All_tim_per(:,1),'BinWidth',5);
    hold on;
%     tim_per_m = mean(All_tim_per(:,2));
%     plot([tim_per_m tim_per_m],[0 30],'r');
    
    yyaxis right;
    tim_per_m = mean(All_tim_per(:,1));
    plot([tim_per_m tim_per_m],[0 30],'r');
    hold on;
    tim_per_m = mean(All_tim_per(:,2));
    plot([tim_per_m tim_per_m],[0 30],'r');
    hold on;
    for j = 1:length(days)
        plot(x_per,Ht{1,j}(i,:),'-','Color','k','LineWidth',1.1);
        hold on;
    end
    ylim([0 2]);
    xlabel('obj1 start - obj2 end [%]') % x-axis label
    title([monkeyname mat2str(days) '  Ht ']);
end
f2 = figure('Position',[900,0,600,1000]);
% x = 1:1:t_num;                     % create data for the line plot
for i=1:syn_num 
    sd = SD(i,:);
    y = AVE(i,:);
    xconf = [x_per x_per(end:-1:1)];
    yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
    subplot(syn_num,1,i);

    fi = fill(xconf,yconf,'k');
    fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
    fi.EdgeColor = 'none';            % remove the line around the filled area
    hold on
    tim_per_m = mean(All_tim_per(:,1));
    plot([tim_per_m tim_per_m],[0 30],'r');
    hold on;
    tim_per_m = mean(All_tim_per(:,2));
    plot([tim_per_m tim_per_m],[0 30],'r');
    hold on;
    plot(x_per, AVE(i,:),'Color','k','LineWidth',1.1);
    ylim([0 2]);
    xlabel('obj1 start - obj2 end [%]') % x-axis label
    title([monkeyname mat2str(days) '  Ht ']);
end
%% save
if save_fig == 1
     cd syn_figures;
        saveas(f1,['H' syn_num mat2str(days) '_hist.bmp']);
        saveas(f2,['aveH' syn_num mat2str(days) '_hist.bmp']);
     cd ../;
end
%%
% figure;
% x = 1:1:EMG_num;
% errt = zeros(EMG_num,syn_num);
% for i=1:syn_num
% errt(:,i) = std(Hall(:,(i-1)*length(days)+1:i*length(days)),1,2);
% subplot(syn_num,1,i);
% bar(x,aveHt(:,i));
% hold on;
% e1 =errorbar(x,aveHt(:,i),errt(:,i));
% ylim([-1 4])
% e1.Color = 'r';
% e1.LineStyle = 'none';
% title([monkeyname mat2str(days) '  aveHt, SD']);
% end
% for i=1:length(days)
%     Ht{i} = Hdata([monkeyname mat2str(days(i))],EMGgroups(i));
% end