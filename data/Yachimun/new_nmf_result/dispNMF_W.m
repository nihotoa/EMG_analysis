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
%% settings
monkeyname = 'F';
term_group = 'post'; %pre/post
group_num = 6; %デフォルトだと1になっていた
syn_num = 4;
save_WDaySynergy = 0;%WDaySynergyをセーブするか(anovaで使用するデータ)
save_data = 1; %order_tim_listへデータを保存するか(基本的に1にしておくべき)
save_fig = 1;
synergy_order = [2,3,1,4]; %0516と0628の比較
synergy_combination = 'all'; % dist-dist/pre-dist/all etc..
% manual_sort = 1; %if you want to manualy sort synergy_W(make k_arr), please set 1
% ds_threshold = 5; %threshold(diff between most close and 2nd most close) 

days = [...
%        % pre-surgery
%          170405; ...
% %          170406; ...
%          170410; ...
%          170411; ...
%          170412; ...
%          170413; ...
% % %          170414; ...
%          170419; ...
%          170420; ...
% %          170421; ...
%          170424; ...
%          170425; ...
% %          170426; ...
%          170501; ...
% % %          170502; ...
%          170508; ...
%          170509; ...
% % %           170510; ...
%          170511; ...
%          170512; ...
%          170515; ...
%          170516; ...
%          170517; ...
%          170524; ...
%          170526; ...
%          170529; ...
% % %         170605	; ...%post-surgery()
%         170606	; ...
% %         170607	; ...
%         170608	; ...
%         170612	; ...
%         170613	; ...
%         170614	; ...
%         170615	; ...
%         170616	; ...
% % %         170619	; ...
%         170620	; ...
%         170621	; ...
%         170622	; ...
%         170623	; ...
%         170627	; ...
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

% days = [170703 170707 170711 170714 170720 170802 170824 170830 170907 170914 170925];
%   days = [170517 170524 170526 170529];
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
        EMGs = {'BRD';'ECR';'ECU';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'PL'};  
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
WDaySynergy = cell(1,syn_num);

for i=1:syn_num 
%     subplot(syn_num,1,i);
    f1 = figure('Position',[300,250*i,750,400]);
    hold on;
% %     bar(x,[Wt{1}(:,i) ...
% %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% %            ],'r','EdgeColor','none');
    %↓ここを適宜変更する
%      bar(x,[zeroBar Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i)],'b','EdgeColor','none');
%     bar(x,[zeroBar Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
%        Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
%        Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) Wt{25}(:,i) Wt{26}(:,i) Wt{27}(:,i) Wt{28}(:,i) Wt{29}(:,i) Wt{30}(:,i)...
%        Wt{31}(:,i) Wt{32}(:,i) Wt{33}(:,i) Wt{34}(:,i) Wt{35}(:,i) Wt{36}(:,i) Wt{37}(:,i) Wt{38}(:,i) Wt{39}(:,i) Wt{40}(:,i)...
%        Wt{41}(:,i) Wt{42}(:,i) Wt{43}(:,i) Wt{44}(:,i) Wt{45}(:,i) Wt{46}(:,i)],'b','EdgeColor','none');
    bar(x,[zeroBar Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
       Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
       Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) Wt{25}(:,i) Wt{26}(:,i) Wt{27}(:,i) Wt{28}(:,i) Wt{29}(:,i) Wt{30}(:,i)...
       Wt{31}(:,i) Wt{32}(:,i) Wt{33}(:,i) Wt{34}(:,i) Wt{35}(:,i) Wt{36}(:,i) Wt{37}(:,i) Wt{38}(:,i) Wt{39}(:,i) Wt{40}(:,i)...
       Wt{41}(:,i) Wt{42}(:,i) Wt{43}(:,i) Wt{44}(:,i) Wt{45}(:,i) Wt{46}(:,i) Wt{47}(:,i)],'b','EdgeColor','none');

%      bar(x,[zeroBar Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
%            Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
%            Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) Wt{25}(:,i) Wt{26}(:,i) Wt{27}(:,i) Wt{28}(:,i) Wt{29}(:,i) Wt{30}(:,i)...
%            Wt{31}(:,i) Wt{32}(:,i) Wt{33}(:,i) Wt{34}(:,i) Wt{35}(:,i) Wt{36}(:,i) Wt{37}(:,i) ],'b','EdgeColor','none');

%      bar(x,[zeroBar Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
%            Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
%            Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) Wt{25}(:,i) Wt{26}(:,i) Wt{27}(:,i) Wt{28}(:,i) Wt{29}(:,i) Wt{30}(:,i)...
%            Wt{31}(:,i) Wt{32}(:,i) Wt{33}(:,i)],'b','EdgeColor','none');

%     bar(x,[zeroBar Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
%        Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
%        Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) Wt{25}(:,i) Wt{26}(:,i) Wt{27}(:,i) Wt{28}(:,i) Wt{29}(:,i) Wt{30}(:,i)...
%        Wt{31}(:,i) Wt{32}(:,i) Wt{33}(:,i) Wt{34}(:,i) Wt{35}(:,i) Wt{36}(:,i) Wt{37}(:,i) Wt{38}(:,i) Wt{39}(:,i) Wt{40}(:,i)...
%        Wt{41}(:,i) Wt{42}(:,i) Wt{43}(:,i) Wt{44}(:,i) Wt{45}(:,i)  Wt{46}(:,i) Wt{47}(:,i) Wt{48}(:,i) Wt{49}(:,i)  Wt{50}(:,i)],'b','EdgeColor','none');
   
%     bar(x,[Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i)...
% % %     bar(x,[Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
% % %            Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
% % %            Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            ],'b','EdgeColor','none');
% % %     bar(x,[zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar ...
% % %            Wt{25}(:,i) Wt{26}(:,i) Wt{27}(:,i) Wt{28}(:,i) Wt{29}(:,i) Wt{30}(:,i) ...
% % %            Wt{31}(:,i) Wt{32}(:,i) Wt{33}(:,i) Wt{34}(:,i) Wt{35}(:,i) Wt{36}(:,i) Wt{37}(:,i) Wt{38}(:,i)...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            ],'k','EdgeColor','none');
% % %        
% % %     bar(x,[zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar zeroBar ...
% % %            Wt{39}(:,i) Wt{40}(:,i)...
% % %            Wt{41}(:,i) Wt{42}(:,i) Wt{43}(:,i) Wt{44}(:,i) Wt{45}(:,i) Wt{46}(:,i) Wt{47}(:,i) Wt{48}(:,i) Wt{49}(:,i) Wt{50}(:,i) ...
% % %            Wt{51}(:,i) Wt{52}(:,i) Wt{53}(:,i) Wt{54}(:,i) Wt{55}(:,i) Wt{56}(:,i) Wt{57}(:,i) Wt{58}(:,i) Wt{59}(:,i) Wt{60}(:,i) ...
% % %            Wt{61}(:,i) Wt{62}(:,i) Wt{63}(:,i) Wt{64}(:,i) Wt{65}(:,i) Wt{66}(:,i) Wt{67}(:,i) Wt{68}(:,i) Wt{69}(:,i) Wt{70}(:,i) ...
% % %            Wt{71}(:,i) Wt{72}(:,i) Wt{73}(:,i) Wt{74}(:,i) Wt{75}(:,i) Wt{76}(:,i) Wt{77}(:,i) Wt{78}(:,i) Wt{79}(:,i) Wt{80}(:,i) ...
% % % %            Wt{81}(:,i) Wt{82}(:,i) Wt{83}(:,i)...Wt{84}(:,i) ...
% % %            ],'FaceColor',[0.9,0.4,0.1],'EdgeColor','none');
%     bar(x,[Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i)]);

%     WDaySynergy{1,i} = zeros(EMG_num,length(days));
%      WDaySynergy{1,i} = [Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i)];
%      WDaySynergy{1,i} = [Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
%                 Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
%                 Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) Wt{25}(:,i) Wt{26}(:,i) Wt{27}(:,i) Wt{28}(:,i) Wt{29}(:,i) Wt{30}(:,i)...
%                 Wt{31}(:,i) Wt{32}(:,i) Wt{33}(:,i)];
%           WDaySynergy{1,i} = [Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
%                 Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
%                 Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) Wt{25}(:,i) Wt{26}(:,i) Wt{27}(:,i) Wt{28}(:,i) Wt{29}(:,i) Wt{30}(:,i)...
%                 Wt{31}(:,i) Wt{32}(:,i) Wt{33}(:,i) Wt{34}(:,i) Wt{35}(:,i) Wt{36}(:,i) Wt{37}(:,i)];
%     WDaySynergy{1,i} = [Wt{1}(:,i) Wt{2}(:,i) Wt{3}(:,i) Wt{4}(:,i) Wt{5}(:,i) Wt{6}(:,i) Wt{7}(:,i) Wt{8}(:,i) Wt{9}(:,i) Wt{10}(:,i) ...
%                 Wt{11}(:,i) Wt{12}(:,i) Wt{13}(:,i) Wt{14}(:,i) Wt{15}(:,i) Wt{16}(:,i) Wt{17}(:,i) Wt{18}(:,i) Wt{19}(:,i) Wt{20}(:,i)... 
%                 Wt{21}(:,i) Wt{22}(:,i) Wt{23}(:,i) Wt{24}(:,i) Wt{25}(:,i) Wt{26}(:,i) Wt{27}(:,i) Wt{28}(:,i) Wt{29}(:,i) Wt{30}(:,i)...
%                 Wt{31}(:,i) Wt{32}(:,i) Wt{33}(:,i) Wt{34}(:,i) Wt{35}(:,i) Wt{36}(:,i) Wt{37}(:,i) Wt{38}(:,i) Wt{39}(:,i) Wt{40}(:,i)...
%                 Wt{41}(:,i) Wt{42}(:,i) Wt{43}(:,i) Wt{44}(:,i) Wt{45}(:,i) Wt{46}(:,i)];
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
    if not(exist('W_synergy_data'))
        mkdir('W_synergy_data')
    end
    if strcmp(term_group,'post')
        temp = cell(1,4);
        for ii = 1:syn_num
            temp{ii} = WDaySynergy{synergy_order(ii)};
        end
        WDaySynergy = temp;
    end
    save(['W_synergy_data/' monkeyname num2str(days(1)) 'to' num2str(days(end)) '_' num2str(length(days)) '(' term_group ').mat'], 'WDaySynergy')
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

%% ↓空間シナジーを3Dプロットしたりとかしていたセクション(たぶん作ったけどわかりにくかったんだと思う)→これ以降の図はSAVEされていなかったのでコメントアウトした
% %%
% plotW = zeros(EMG_num,length(days));
% sel_plotW = cell(1,4);
% for i = 1:4
%     figure;
%     hold on;
%     for j = 1:length(days)
%         plot(Wt{j}(:,i),'Color',c(j,:),'LineWidth',2);
%         plotW(:,j) = Wt{j}(:,i);
%     end
%     sel_plotW{i} = plotW;
% end
% 
% for i = 1:4
%     figure;
%     bar3(sel_plotW{i});
% end
% %%
% figure;
% for w = 1:4
%    for m = 1:12
%       subplot(4,12,(w-1)*12+m)
%       plot(Wall(m,(w-1)*length(days)+1:w*length(days)))
%    end
% end