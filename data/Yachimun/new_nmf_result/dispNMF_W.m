%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
how to use:
plase conduct 'SYNERGYPLOT' first and then conduct this code
please set current dir as 'new_nmf_result'

[procedure]
pre_operate:SYNERGYPLOT.m
post_operate:MakeDataForPlot_H_utb.m

[operation]
synergy_comibinationの変更
termgroupの変更
synergy_orderの変更
daysの変更
bar部分の変更

save_data:
【figure】Yachimun -> new_nmf_result -> syn_figures -> (ex) Ya170628to170929_47 ->
【data】Yachimun -> new_nmf_result -> order_tim_list -> (ex) Ya170628to170929_47 ->
【caution!!!】
please change group_num!!!!!!!
(変数group_numの値を適宜変更して!!!!)
please change synergy_order(0516と0628の対応関係から判断する)
【変更する変数】
term_group
synergy_order(IF term_group = 'post')
days
group_num
save_data

[改善点]
barのところ(要改善)
WDaySynergyの代入するところ(要改善)
シナジーの対応づけがpreとpostでうまくいっていない
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%% set param
monkeyname = 'F';
term_group = 'post'; %pre/post
group_num = 6; %デフォルトだと1になっていた
syn_num = 4;
save_WDaySynergy = 1;%WDaySynergyをセーブするか(anovaで使用するデータ)
save_data = 1; %order_tim_listへデータを保存するか(基本的に1にしておくべき)
save_fig = 1;
synergy_order = [4,2,1,3]; %0516と0628の比較
synergy_combination = 'all'; % dist-dist/pre-dist/all etc..

%% code section
switch term_group
    case 'pre'
        days = [...
                 170516; ...
                 170517; ...
                 170524; ...
                 170526; ...
                 ];
    case 'post'
                days = [...
                170628	; ...
                170629	; ...
                170630	; ...
                170703	; ...
                170704	; ...
        % % %         170705	; ...
                170706	; ...%orange
                170707	; ...
                170710	; ...
                170711	; ...
                170712	; ...
                170713	; ...
                170714	; ...
                170718	; ...
                170719	; ...
                170720	; ...
                170725	; ...
                170726	; ...
        % % %         170801	; ...
                170802	; ...
                170803	; ...
                170804	; ...
                170807	; ...
                170808	; ...
                170809	; ...
                170810	; ...
                170815	; ...
        % %         170816	; ...
                170817	; ...
                170818	; ...
                170822	; ...
                170823	; ...
                170824	; ...
                170825	; ...
                170829	; ...
                170830	; ...
                170831	; ...
                170901	; ...
                170904	; ...
                170905	; ...
                170906	; ...
                170907	; ...
                170908	; ...
                170911	; ...
                170913	; ...
                170914	; ...
                170925  ; ...
                170926  ; ...
                170927  ; ...
                170929  ; ...
                 ];
end

 EMGgroups = ones(1,length(days)).* group_num;
 c = jet(length(days));
 switch group_num
    case 1
        %without 'Deltoid'
        EMG_num = 12;
        EMGs = {'BRD';'ECR';'ECU';'ED23';'EDCdist';'EDCprox';'FCR';'FCU';'FDP';...
                'FDSdist';'FDSprox';'PL'};
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
    case 6
        %太田解析用(dist-dist)
        EMG_num = 10;
        EMGs = {'BRD';'ECR';'ECU';'ED23';'EDC';'FCR';'FCU';'FDP';'FDS';'PL'};  
    case 7
        %太田解析用(prox-prox)
        EMG_num = 10;
        EMGs = {'BRD';'ECR';'ECU';'ED45';'EDCprox';'FCR';'FCU';'FDP';'FDSprox';'PL'};  
     case 8 %prox-dist
        EMG_num = 10;
        EMGs = {'BRD';'ECR';'ECU';'ED45';'EDCprox';'FCR';'FCU';'FDP';'FDSdist';'PL'}; 
     case 9 %dist-prox
        EMG_num = 10;
        EMGs = {'BRD';'ECR';'ECU';'ED45';'EDCdist';'FCR';'FCU';'FDP';'FDSprox';'PL'}; 
 end
%% load
Wx =  cell(1,length(days));

for i = 1:length(days)
%     if days(i) == 170823 
%         a = 1;
%     end
    cd([monkeyname mat2str(days(i)) '_standard'])
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
    k_arr(i,1) = i; %初日
    for j = 2:length(days)
        for l = 1:syn_num
            Wcom(:,l) = (Wx{1,1}(:,i) - Wx{1,j}(:,l)).^ 2; %初日のシナジーIとj日目のシナジーlの差を2乗する
            m(j,l) = sum(Wcom(:,l)); %それを足し合わせる(一番小さかったものが、シナジーになるはず)
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
    mkdir(fullfile(pwd, 'syn_figures'))
end
cd syn_figures;
if not(exist(fullfile(pwd, [monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))])))
    mkdir([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
end
cd ../
x = categorical(EMGs');
muscle_name = x; 
% f1 = figure('Position',[300,0,450,750]);
zeroBar = zeros(EMG_num,1);

for i=1:syn_num 
%     subplot(syn_num,1,i);
    f1 = figure('Position',[300,250*i,750,400]);
    hold on;
    % create plotted_W
    plotted_W = nan(EMG_num, length(days));
    for jj = 1:length(days)
        switch term_group
            case 'pre'
                plotted_W(:, jj) = Wt{jj}(:, i);
            case 'post'
                plotted_W(:, jj) = Wt{jj}(:, synergy_order(i));
        end
    end
    bar(x,[zeroBar plotted_W],'b','EdgeColor','none');
    ylim([0 2.5]);
    a = gca;
    a.FontSize = 20;
    a.FontWeight = 'bold';
    a.FontName = 'Arial';
%     title([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) ' ' sprintf('%d',length(days)) '  Wt ']);
    if save_fig == 1
         cd syn_figures;
         cd([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
            saveas(f1,['W' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '(OHTA).fig']);
    %         orient(f1,'landscape');
    %         saveas(f1,['W' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '.pdf']);
            saveas(f1,['W' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '(OHTA).png']);
         cd ../../;
    end
end

if save_WDaySynergy == 1
    % create dicectory
    if not(exist('W_synergy_data'))
        mkdir('W_synergy_data')
    end

    % create saved data
    WDaySynergy = cell(1,syn_num);
    for ii = 1:syn_num
        for jj = 1:length(days)
            WDaySynergy{ii}(:, jj) = Wt{jj}(:, ii);
        end
    end

    % align synergy procedure
    if strcmp(term_group,'post')
        temp = cell(1,4);
        for ii = 1:syn_num
            temp{ii} = WDaySynergy{synergy_order(ii)};
        end
        WDaySynergy = temp;
    end
    save(['W_synergy_data/' monkeyname num2str(days(1)) 'to' num2str(days(end)) '_' num2str(length(days)) '(' term_group ').mat'], 'WDaySynergy', 'x')
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
x = 1:1:EMG_num;
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
        saveas(f2,['aveW' sprintf('%d',syn_num) sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '(OHTA).fig']);
%         orient(f2,'landscape');
%         saveas(f2,['aveW' sprintf('%d',syn_num) sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '.pdf']);
         saveas(f2,['aveW' sprintf('%d',syn_num) sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_syn' sprintf('%d',i) '(OHTA).png']);
     cd ../../;
end
end
close all;
% for i=1:length(days)
%     Wt{i} = Wdata([monkeyname mat2str(days(i))],EMGgroups(i));
% end
%% save order for aveH plot

if save_data == 1
    save_dir = 'spacial_synergy_data';
    save_dir = [save_dir '/' synergy_combination];
    if not(exist(save_dir))
        mkdir(save_dir)
    end
    save([save_dir '/' term_group '(' num2str(length(days)) 'days)_data.mat' ],"Wt","muscle_name","days")
    if not(exist(fullfile(pwd, 'order_tim_list')))
        mkdir(fullfile(pwd, 'order_tim_list'))
    end
    cd order_tim_list
    if not(exist(fullfile(pwd, [monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))])))
        mkdir([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
    end
    cd([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))])
    comment = 'this data were made for aveH plot';
    save([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days)) '_' sprintf('%d',syn_num) '.mat'], 'k_arr','comment', 'days', 'EMG_num', 'syn_num');
    cd ../../
end

