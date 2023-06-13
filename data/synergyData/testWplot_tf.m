%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
【重要!!】
図の出力にexportgraficsという関数を使用しているが、2020以降のMATLABじゃないとこの関数がbilt-in関数として用意されていない(おそらくツールボックスでもないと思う)
→このバージョンのMATLABを使用するか、代替案を考えるかのどっちか
まずは存在するデータで、一通り解析してみる

【事前準備】
new_nmf_result -> W_synergy_dataから()と()をコピーして、この関数の所属しているディレクトリに貼り付ける
【注意】
Statistics and Machine Learning Toolboxがないと解析できないので注意
(二元配置分散分析のための関数anovanがこのツールボックスに含まれている)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = testWplot_tf()
clear 
close all
% close all hidden1
realname = 'Yachimun';
% matlab_version = 'old' ;%old:before R2020b new: after R2020b(筋肉シナジープロットしたRい時に使う(検定の時には使わないからコメントアウトしておく))
merge_post_data = 1; %POSTをグループ分けするか?(PREに対してPOSTの数が多いから数を揃えるためにグループ分けする)
multiple_degree = 0; %自由度を1以上にするか?(pre/postにするかpre/pre1/pre2/pre3みたいにするか)
devide_group_num = 4; %merge_post_dataが1の時,POSTデータを何個のグループに分けるか? + (merge_post_data = 0 && multiple_degree = 1の時)postを何個のグループに分けるか?
mutually_interaction = 0; %相互相関を考慮するか？
% realname = 'SesekiL';

switch realname
    case 'Yachimun'
        catX = categorical({'FDP';'FDSprox';'FDSdist';'FCUclc';'PL';'FCR';'BRD';'ECR';'EDCprox';'EDCdist';'ED23';'ECU'});
        Nd = 178;
        AllDays = datetime([2017,04,05])+caldays(0:Nd-1);
        dayX = {'2017/04/05','2017/04/10','2017/04/11','2017/04/12','2017/04/13',...
            '2017/04/19','2017/04/20','2017/04/21','2017/04/24','2017/04/25',...
            '2017/04/26','2017/05/01','2017/05/09','2017/05/11','2017/05/12',...
            '2017/05/15','2017/05/16','2017/05/17','2017/05/24','2017/05/26',...
            '2017/05/29','2017/06/06','2017/06/08','2017/06/12','2017/06/13',...
            '2017/06/14','2017/06/15','2017/06/16',...'2017/06/19',
            '2017/06/20',...
            '2017/06/21','2017/06/22','2017/06/23','2017/06/27','2017/06/28',...
            '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
            '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
            '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
            '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
            '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
            '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
            '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
            '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
            '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%80days
        AVEPre4Days = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26'};
        TaskCompletedDay = {'2017/08/07'};
        TTsurgD  = datetime([2017,05,30]);                %date of tendon transfer surgery
        TTtaskD  = datetime([2017,06,28]);                %date monkey started task by himself after surgery & over 100 success trials (he started to work on June.28)
        dayEarly =  1:20;
        dayLate  = 28:47;
        yRange   = 3;
    case 'SesekiL'
        catX = categorical({'EDC';'ED23';'ED45';'ECU';'ECR';'Deltoid';'FDP';'PL';'BRD'});
        Nd = 74;
        AllDays = datetime([2020,01,17])+caldays(0:Nd-1);
        dayX = {'2020/1/17', '2020/1/19', '2020/1/20',...
            '2020/2/10', '2020/2/12', '2020/2/13', '2020/2/14', '2020/2/17',...
            '2020/2/18', '2020/2/19', '2020/2/20', '2020/2/21', '2020/02/26',...
            '2020/3/3', '2020/3/4', '2020/3/5', '2020/3/6', ...
            '2020/3/9', '2020/3/10', '2020/3/16', '2020/3/17', ...
            '2020/3/18', '2020/3/19', '2020/3/23', '2020/3/24', '2020/3/25',...
            '2020/3/26', '2020/3/30'};
        AVEPre4Days = {'2020/01/17', '2020/01/19', '2020/01/20'};
        TaskCompletedDay = {'2020/02/10'};
        TTsurgD = datetime([2020,01,21]);                %date of tendon transfer surgery
        TTtaskD = datetime([2020,02,10]);                %date monkey started task by himself after surgery
        dayEarly =  1:10;
        dayLate  = 16:25;
        yRange   = 2.5;
end

%- Set figure colors -%
Xpost = zeros(size(AllDays));
Xpre4 = zeros(size(AllDays));
k=1;l=1;
for i=1:Nd
    if k>length(dayX)
    elseif AllDays(i)==dayX(k)
        Xpost(1,i) = i;
        k=k+1;
    end
    if l>length(AVEPre4Days)
    elseif AllDays(i)==AVEPre4Days(l)
        Xpre4(1,i) = i;
        l=l+1;
    end
    if AllDays(i)==TaskCompletedDay
        tcd = i;
    end
end
xdays = find(Xpost) - find(AllDays==TTsurgD);
cdays = find(Xpost) - find(AllDays==TTtaskD)+1;
cpostdays = xdays(find(xdays>0));
ctaskdays = xdays(find(cdays>0));
cSingle_e = linspace(0.3, 1, cpostdays(end))';
czero = zeros(cpostdays(end),1);
switch realname
    case 'Yachimun'
        cSingleC = [cSingle_e czero czero];
    case 'SesekiL'
        cSingleC = [czero cSingle_e czero];
end
%--%

%- Load data Files-%
%↓Wの変化の検定だけなら、Hの情報いらないのでは？と思ったので、コメントアウトした
% WHPre  = load(['WH_' realname '_pre.mat'],  'WDaySynergy', 'HDaySynergy');
% WHPost = load(['WH_' realname '_post.mat'], 'WDaySynergy', 'HDaySynergy');
disp('【please select ~(pre).mat】')
pre_file = uigetfile('*.mat',...
         'Select One or More Files', ...
         'MultiSelect', 'on');
WHPre  = load(pre_file,  'WDaySynergy');

disp('【please select ~(post).mat】')
post_file = uigetfile('*.mat',...
         'Select One or More Files', ...
         'MultiSelect', 'on');
WHPost = load(post_file, 'WDaySynergy');
%--%

% %- plot WH All Bar -%
% figure('Position',[0 0 1200 800]);
% plotWHAll(WHPre.WDaySynergy,  WHPre.HDaySynergy,  cSingleC, ctaskdays, catX, yRange)
% switch matlab_version
%     case 'old'
%         saveas(gcf,['sample1.png']);
%     case 'new'
%         exportgraphics(gcf,['Synergy' realname 'Pre.png'],'Resolution',300);
% end
% figure('Position',[0 0 1200 800]);
% plotWHAll(WHPost.WDaySynergy, WHPost.HDaySynergy, cSingleC, ctaskdays, catX, yRange)
% switch matlab_version
%     case 'old'
%         saveas(gcf,['sample2.png']);
%     case 'new'
%         exportgraphics(gcf,['Synergy' realname 'Post.png'],'Resolution',300);
% end
% close all;
% %--%

%- ANOVA Pre/Post -%
syn_num = length(WHPost.WDaySynergy);
data_num = length(WHPost.WDaySynergy{1});
muscle_num = size(WHPost.WDaySynergy{1},1);
if or(merge_post_data == 1, multiple_degree == 1)
    one_group_data_num = fix(data_num / devide_group_num);
    for ii = 1:devide_group_num
        if ii == devide_group_num %一番最後のグループの時
            eval(['group' num2str(ii) ' = [one_group_data_num*(ii-1)+1,data_num];'])
            %group4 = [one_group_data_num*(ii-1)+1,data_num];
        else
            eval(['group' num2str(ii) ' = [one_group_data_num*(ii-1)+1,one_group_data_num*ii];'])
            %group1 = [one_group_data_num*(ii-1)+1,one_group_data_num*ii];
        end
    end
end

if merge_post_data == 1
    for ii = 1:syn_num
        ref_data = WHPost.WDaySynergy{ii};
        merged_data = zeros(muscle_num,devide_group_num);
        for jj = 1:devide_group_num
            temp = mean(eval(['ref_data(:,group' num2str(jj) '(1):group' num2str(jj) '(end));']),2);
            merged_data(:,jj) = temp;
        end
        WHPost.WDaySynergy{ii} = merged_data;
    end
end

%calcurate Two-Way ANOVA
% syn_num = length(WHPre.WDaySynergy);
% p = zeros(2,syn_num);
disp('Two-Way ANOVA with [Muscle/prepost] P-Values: ')
tbl = cell(1,syn_num);
for s=1:syn_num
    WPre  = WHPre.WDaySynergy{s};
    WPreList =[];
    gDateList    =[];
    gEMGList     =[];
    gPrePostList ={};
    for i=1:size(WPre,2)
        WPreList = [WPreList; WPre(:,i)];
        gDateList    = [gDateList; repmat(i, size(WPre,1),1)]; % date
        gEMGList     = [gEMGList; (1:size(WPre,1))']; % EMG
        gPrePostList = [gPrePostList; repmat({'pre'}, size(WPre,1),1)]; % pre/post
    end
    WPost = WHPost.WDaySynergy{s};
    WPostList =[];
    for i=1:size(WPost,2)
        WPostList = [WPostList; WPost(:,i)];
        gDateList    = [gDateList; repmat(i+size(WPre,2), size(WPost,1),1)]; % date
        gEMGList     = [gEMGList; (1:size(WPost,1))']; % EMG
        gPrePostList = [gPrePostList; repmat({'post'}, size(WPost,1),1)];
%         if multiple_degree == 1
%             if merge_post_data == 1 
%                 gPrePostList = [gPrePostList; repmat({['post' num2str(i)]}, size(WPost,1),1)]; %iがグループのサイズになるので、そのまま代入
%             elseif merge_post_data == 0
%                 for jj = 1:devide_group_num
%                     if ismember(i,eval(['group' num2str(jj) '(1):group' num2str(jj) '(end)']))
%                         gPrePostList = [gPrePostList; repmat({['post' num2str(jj)]}, size(WPost,1),1)]; %iが日付数になるので、条件分岐する
%                     end
%                 end
%             end
%         else
%             gPrePostList = [gPrePostList; repmat({'post'}, size(WPost,1),1)]; % pre/post
%         end
    end
    WAll   = [WPreList;WPostList];
    if mutually_interaction == 1 %交互作用を考慮するかどうか
        [p(:,s), tbl{s}] = anovan(WAll,{gEMGList,gPrePostList},'model','interaction','varnames',{'EMG','pre/post'},'display','on');
    else
        [p(:,s), tbl{s}] = anovan(WAll,{gEMGList,gPrePostList},'varnames',{'EMG','pre/post'},'display','on');
    end
%     p(:,s) = anovan(WAll,{gEMGList,gPrePostList, gDateList},'varnames',{'EMG','pre/post', 'date'});
    disp([realname ', Synergy' num2str(s) ' Muscle:' num2str(p(1,s), '%.3f') ', Pre/Post:' num2str(p(2,s), '%.3f')])
    
    %save result(冗長?分岐多いのはしょうがない?)
    save_dir = 'result_anovan';
    if mutually_interaction
        save_dir = [save_dir '/include_interact'];
        if merge_post_data
            save_dir = [save_dir '/post' num2str(devide_group_num) 'devide'];
            if multiple_degree
                save_dir = [save_dir '/pre_and_post1_to_' num2str(devide_group_num)];
            else
                save_dir = [save_dir '/pre-post']
            end
        else
            save_dir = [save_dir '/NoMerge'];
            if multiple_degree
                save_dir = [save_dir '/pre_and_post1_to_' num2str(devide_group_num)];
            else
                save_dir = [save_dir '/pre-post'];
            end
        end
    else
        save_dir = [save_dir '/no_interact'];
        if merge_post_data
            save_dir = [save_dir '/post' num2str(devide_group_num) 'devide'];
            if multiple_degree
                save_dir = [save_dir '/pre_and_post1_to_' num2str(devide_group_num)];
            else
                save_dir = [save_dir '/pre-post'];
            end
        else
            save_dir = [save_dir '/NoMerge'];
            if multiple_degree
                save_dir = [save_dir '/pre_and_post1_to_' num2str(devide_group_num)];
            else
                save_dir = [save_dir '/pre-post'];
            end
        end
    end
    
    if not(exist(save_dir))
        mkdir(save_dir)
    end
    writetable(cell2table(tbl{s}), [save_dir '/synergy' num2str(s) '_anovan_result.csv'])
    
end
%--%


% %- plot Early/Late Bar -%
% WEarly = cell(1,syn_num);
% HEarly = cell(1,syn_num);
% WLate  = cell(1,syn_num);
% HLate  = cell(1,syn_num);
% for s=1:syn_num
%     WPost  = WHPost.WDaySynergy{s}; 
%     HPost  = WHPost.HDaySynergy{s}; 
%     WEarly{s} = WPost(:,dayEarly);
%     HEarly{s} = HPost(:,dayEarly);
%     WLate{s}  = WPost(:,dayLate);
%     HLate{s}  = HPost(:,dayLate);
% end
% figure('Position',[0 0 1200 800]);
% plotWHAll(WEarly,  HEarly,  cSingleC, ctaskdays, catX, yRange)
% exportgraphics(gcf,['Synergy' realname 'PostEarly.png'],'Resolution',300);
% figure('Position',[0 0 1200 800]);
% plotWHAll(WLate, HLate, cSingleC, ctaskdays, catX, yRange)
% exportgraphics(gcf,['Synergy' realname 'PostLate.png'],'Resolution',300);
% %--%

% %- ANOVA Post Early/Late -%
% syn_num = length(WHPre.WDaySynergy);
% p = zeros(2,syn_num);
% disp('Two-Way ANOVA with [Muscle/EarlyLate] P-Values: ')
% for s=1:syn_num
%     WPost  = WHPost.WDaySynergy{s}; 
%     WEarly = WPost(:,dayEarly);
%     gEMGList     =[];
%     gEarlyLateList ={};
%     %
%     WEarlyList = [];
%     for i=1:size(WEarly,2)
%         WEarlyList   = [WEarlyList; WEarly(:,i)];
%         gEMGList     = [gEMGList; (1:size(WEarly,1))']; % EMG
%         gEarlyLateList = [gEarlyLateList; repmat({'early'}, size(WEarly,1),1)]; % early/late
%     end
%     WLate  = WPost(:,dayLate);
%     WLateList = [];
%     for i=1:size(WLate,2)
%         WLateList   = [WLateList; WLate(:,i)];
%         gEMGList     = [gEMGList; (1:size(WLate,1))']; % EMG
%         gEarlyLateList = [gEarlyLateList; repmat({'late'}, size(WLate,1),1)]; % early/late
%     end
%     WAll   = [WEarlyList;WLateList];
%     p(:,s) = anovan(WAll,{gEMGList,gEarlyLateList},'varnames',{'EMG','early/late'});
%     disp([realname ', Synergy ' num2str(s) ' Muscle:' num2str(p(1,s), '%.3f') ', Early/Late:' num2str(p(2,s), '%.3f')])
% end
% %--%

end

%%
function plotWHAll(W,H, cSingleC, ctaskdays, catX, yRange)
syn_num = length(W);
for s=1:syn_num
    %plot W
    subplot(syn_num,2,2*s-1)
    bar(catX, W{s} ,'FaceColor','b')
    ylim([0 yRange])
    %plot H
    subplot(syn_num,2,2*s)
    hold on
    xHplot = linspace(-15,15,length(H{s}));
    for dayI = 1:size(H{s},2)
        plot(xHplot, H{s}(:,dayI), 'Color',cSingleC(ctaskdays(dayI),:),'LineWidth',2.5)
    end
    plot([0 0],[0 yRange],'k','LineWidth',2.5)
    hold off
    ylim([0 yRange])
end
end
