%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
caution!!!
focus_termいじることdaysを

pre_operate:SYNERGYPLOT.m
post_operate:MakeDataForPlot_H_utb.m
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%% settings
monkeyname = 'Se';
% task = 'standard_filtNO5';
focus_term = 'ore'; %pre/post 
task = 'standard';
days = [...%pre-surgery
        200117;...
        200119;...
        200120;...
%         200210;...%post surgery
%         200212;...
%         200213;...
%         200214;...
%         200217;...
%         200218;...
%         200219;...
%         200220;...
%         200221;...
%         200226;...
%         200303;...
%         200304;...
%         200305;...
%         200306;...
%         200309;...
%         200310;...
%         200316;...
%         200317;...
%         200318;...
%         200319;...
%         200323;...
%         200324;...
%         200325;...
%         200326;...
%         200330;...
         ];

% days = [170703 170707 170711 170714 170720 170802 170824 170830 170907 170914 170925];
%   days = [170517 170524 170526 170529];
 group_num = 1;
 syn_num = 4;
 
 EMGgroups = ones(1,length(days)).* group_num;
 c = jet(length(days));
switch group_num
    case 1
        EMG_num = 9;
        EMGs = {'BRD';'Deltoid';'ECR';'ECU';'ED23';'ED45';'EDC';'FDP';'PL'};
end

save_data = 1;
save_fig = 1;
%% load
Wx =  cell(1,length(days));

for i = 1:length(days)
    cd([monkeyname mat2str(days(i)) '_' task])
    cd([monkeyname mat2str(days(i)) '_syn_result_' sprintf('%02d',EMG_num)])
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
for i = 1:syn_num
    for j=1:length(days)
        Wall(:,(i-1)*length(days)+j) = Walt(:,(j-1)*syn_num+i);
    end
end

%% plot bar
if not(exist(fullfile(pwd, 'syn_figures')))
    mkdir('syn_figures')
end
cd syn_figures;

if not(exist(fullfile(pwd, [monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))])))
    mkdir([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
end
cd ../
x = categorical(EMGs');
% f1 = figure('Position',[300,0,450,750]);
zeroBar = zeros(EMG_num,1);
for i=1:syn_num 
%     subplot(syn_num,1,i);
    f1 = figure('Position',[300,250*i,750,400]);
    hold on;
    switch focus_term
        case 'pre'
            bar(x,[Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i)],'b','EdgeColor','none');
        case 'post'
            bar(x,[Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i)...zeroBar zeroBar zeroBar ...
               Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
               Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
               Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) Wt{25}(:,i)...
               ],'FaceColor','b','EdgeColor','none');
    end

    ylim([0 2.5]);
    a = gca;
    a.FontSize = 20;
    a.FontWeight = 'bold';
    a.FontName = 'Arial';
%     title([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) ' ' sprintf('%d',length(days)) '  Wt ']);
    if save_fig == 1
     cd syn_figures;
     cd([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
     saveas(f1,['W' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '.fig']);
     saveas(f1,['W' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '.png']);
     cd ../../;
    end
end
for j=1:length(days)
%     for i=1:syn_num 
%         subplot(syn_num,1,j + (i-1)*length(days));
%         bar(x,Wt{j}(:,i));
%         ylim([0 3]);
%     end
    aveWt = (aveWt.*(j-1) + Wt{j})./j;
end
% f2 = figure('Position',[900,0,450,750]);
% x = 1:1:EMG_num;
errt = zeros(EMG_num,syn_num);
for i=1:syn_num
f2 = figure('Position',[900,250*i,750,400]);
errt(:,i) = std(Wall(:,(i-1)*length(days)+1:i*length(days)),1,2)./sqrt(length(days));
% subplot(syn_num,1,i);
bar(x,aveWt(:,i));
hold on;
e1 =errorbar(x,aveWt(:,i),errt(:,i),'MarkerSize',1);
ylim([-1 4])
e1.Color = 'r';
e1.LineWidth = 2;
e1.LineStyle = 'none';
ylim([0 2.5]);
a = gca;
a.FontSize = 20;
a.FontWeight = 'bold';
a.FontName = 'Arial';
% title([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) ' ' sprintf('%d',length(days)) '  aveWt, SEM']);
if save_fig == 1
     cd syn_figures;
     cd([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
        saveas(f2,['aveW' sprintf('%d',syn_num) sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '.fig']);
        orient(f2,'landscape');
        saveas(f2,['aveW' sprintf('%d',syn_num) sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '.pdf']);
        saveas(f2,['aveW' sprintf('%d',syn_num) sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '.png']);
     cd ../../;
end
end
% for i=1:length(days)
%     Wt{i} = Wdata([monkeyname mat2str(days(i))],EMGgroups(i));
% end
%% save order for aveH plot

if save_data == 1
    if not(exist(fullfile(pwd, 'order_tim_list')))
        mkdir('order_tim_list')
    end
    cd order_tim_list
    mkdir([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
    cd([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))])
    comment = 'this data were made for aveH plot';
    save([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_' sprintf('%d',syn_num) '.mat'], 'k_arr','comment', 'days', 'EMG_num', 'syn_num');
    cd ../../
end
%%
plotW = zeros(EMG_num,length(days));
sel_plotW = cell(1,4);
for i = 1:4
    figure;
    hold on;
    for j = 1:length(days)
        plot(Wt{j}(:,i),'Color',c(j,:),'LineWidth',2);
        plotW(:,j) = Wt{j}(:,i);
    end
    sel_plotW{i} = plotW;
end

for i = 1:4
    figure;
    bar3(sel_plotW{i});
end
%%
figure;
for w = 1:4
   for m = 1:EMG_num
      subplot(4,EMG_num,(w-1)*EMG_num+m)
      plot(Wall(m,(w-1)*length(days)+1:w*length(days)))
      ylim([0 2])
   end
end

close all;