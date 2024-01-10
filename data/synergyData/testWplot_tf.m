%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
【重要!!】
図の出力にexportgraficsという関数を使用しているが、2020以降のMATLABじゃないとこの関数がbilt-in関数として用意されていない(おそらくツールボックスでもないと思う)
→このバージョンのMATLABを使用するか、代替案を考えるかのどっちか
まずは存在するデータで、一通り解析してみる

[procedure]
pre: plotTarget.m
post: nothing

[pre preparation]
1. Please conduct 'dispNMF_W.m' (please set 'save_WDaySynergy'' as 1)
2. Please transfer the data (nmf_result/W_synergy_data/~(pre).m &
~(post).m) from 'W_synergy_data' to 'synergyData' directory

【注意】
Statistics and Machine Learning Toolboxがないと解析できないので注意
(一元配置分散分析のための関数anovanがこのツールボックスに含まれている)

[改善点]
サルの名前を手動で変えなきゃ行けないので,先にファイルをロードしてから条件分岐でサルの名前を変更するようにする.
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = testWplot_tf()
clear 
close all
realname = 'Seseki'; % 'Yachimun' / 'Seseki'
merge_post_data = 0; %POSTをグループ分けするか?(PREに対してPOSTの数が多いから数を揃えるためにグループ分けする)
multiple_degree = 0; %自由度を1以上にするか?(pre/postにするかpre/pre1/pre2/pre3みたいにするか)
devide_group_num = 4; %merge_post_dataが1の時,POSTデータを何個のグループに分けるか? + (merge_post_data = 0 && multiple_degree = 1の時)postを何個のグループに分けるか?
mutually_interaction = 0; %相互相関を考慮するか？


%% prepare dataset  for anova
%- Load data Files-%
disp('【please select ~(pre).mat】')
pre_file = uigetfile('*.mat',...
         'Select One or More Files', ...
         'MultiSelect', 'on');
WHPre  = load(pre_file,  'WDaySynergy');

% load muscle name data for plotting synergy weight
load(pre_file,  'x');

disp('【please select ~(post).mat】')
post_file = uigetfile('*.mat',...
         'Select One or More Files', ...
         'MultiSelect', 'on');
WHPost = load(post_file, 'WDaySynergy');

%- ANOVA Pre/Post -%
syn_num = length(WHPost.WDaySynergy);
data_num = length(WHPost.WDaySynergy{1});
muscle_num = size(WHPost.WDaySynergy{1},1);

% devide post data into some groups & calc average weight of these group 
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

%% plot synergy_W (o visualize the synergies to be compared)
visualyze_synergy_W(WHPre, WHPost, x, syn_num, realname);

%% calcurate Two-Way ANOVA
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
    end
    WAll   = [WPreList;WPostList];
    if mutually_interaction == 1 %交互作用を考慮するかどうか
        [p(:,s), tbl{s}] = anovan(WAll,{gEMGList,gPrePostList},'model','interaction','varnames',{'EMG','pre/post'},'display','on');
    else
%         [p(:,s), tbl{s}] =
%         anovan(WAll,{gEMGList,gPrePostList},'varnames',{'EMG','pre/post'},'display','on'); 
%         [p(:,s), tbl{s}] = anova1(WAll,gPrePostList);
        [p(:,s), tbl{s}] = anovan(WAll,{gPrePostList},'varnames',{'pre/post'}, 'display', 'on');
    end
%     p(:,s) = anovan(WAll,{gEMGList,gPrePostList, gDateList},'varnames',{'EMG','pre/post', 'date'});
    disp([realname ', Synergy' num2str(s) ' Muscle:' num2str(p(1,s), '%.3f') ', Pre/Post:' num2str(p(s), '%.3f')])
    
    %% save_result
    % save result(冗長?分岐多いのはしょうがない?)
    save_dir = fullfile(pwd, 'result_anovan', realname);
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

end

%% define function
function visualyze_synergy_W(WHPre, WHPost, x, syn_num, realname)
zeroBar = zeros(length(x),1);

% create figure object
figure("position", [100, 100, 800, 200 * syn_num]);
hold on
for ii = 1:syn_num
    % plot pre synergy_W
    subplot(syn_num, 2, 2*(ii-1)+1)
    bar(x, [zeroBar WHPre.WDaySynergy{ii}], 'b','EdgeColor','none');
    title(['synergy' num2str(ii) ' (pre)'])

    % plot pre synergy_W
    subplot(syn_num, 2, 2*(ii-1)+2)
    bar(x, [zeroBar WHPost.WDaySynergy{ii}], 'b','EdgeColor','none');
    title(['synergy' num2str(ii) ' (post)'])
end

% save figure
save_fig_path = fullfile(pwd, 'save_figure', 'compair_synergy_W', realname);
if not(exist(save_fig_path))
    mkdir(save_fig_path)
end
saveas(gcf, fullfile(save_fig_path, 'compaired_synergy_W_fig.png'))
saveas(gcf, fullfile(save_fig_path, 'compaired_synergy_W_fig.fig'))
close all;
end
