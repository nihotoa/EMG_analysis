%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
�y�d�v!!�z
�}�̏o�͂�exportgrafics�Ƃ����֐����g�p���Ă��邪�A2020�ȍ~��MATLAB����Ȃ��Ƃ��̊֐���bilt-in�֐��Ƃ��ėp�ӂ���Ă��Ȃ�(�����炭�c�[���{�b�N�X�ł��Ȃ��Ǝv��)
�����̃o�[�W������MATLAB���g�p���邩�A��ֈĂ��l���邩�̂ǂ�����
�܂��͑��݂���f�[�^�ŁA��ʂ��͂��Ă݂�

[procedure]
pre: plotTarget.m
post: nothing

[pre preparation]
1. Please conduct 'dispNMF_W.m' (please set 'save_WDaySynergy'' as 1)
2. Please transfer the data (nmf_result/W_synergy_data/~(pre).m &
~(post).m) from 'W_synergy_data' to 'synergyData' directory

�y���Ӂz
Statistics and Machine Learning Toolbox���Ȃ��Ɖ�͂ł��Ȃ��̂Œ���
(�ꌳ�z�u���U���͂̂��߂̊֐�anovan�����̃c�[���{�b�N�X�Ɋ܂܂�Ă���)

[���P�_]
�T���̖��O���蓮�ŕς��Ȃ���s���Ȃ��̂�,��Ƀt�@�C�������[�h���Ă����������ŃT���̖��O��ύX����悤�ɂ���.
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = testWplot_tf()
clear 
close all
realname = 'Seseki'; % 'Yachimun' / 'Seseki'
merge_post_data = 0; %POST���O���[�v�������邩?(PRE�ɑ΂���POST�̐����������琔�𑵂��邽�߂ɃO���[�v��������)
multiple_degree = 0; %���R�x��1�ȏ�ɂ��邩?(pre/post�ɂ��邩pre/pre1/pre2/pre3�݂����ɂ��邩)
devide_group_num = 4; %merge_post_data��1�̎�,POST�f�[�^�����̃O���[�v�ɕ����邩? + (merge_post_data = 0 && multiple_degree = 1�̎�)post�����̃O���[�v�ɕ����邩?
mutually_interaction = 0; %���ݑ��ւ��l�����邩�H


%% prepare dataset  for anova
%- Load data Files-%
disp('�yplease select ~(pre).mat�z')
pre_file = uigetfile('*.mat',...
         'Select One or More Files', ...
         'MultiSelect', 'on');
WHPre  = load(pre_file,  'WDaySynergy');

% load muscle name data for plotting synergy weight
load(pre_file,  'x');

disp('�yplease select ~(post).mat�z')
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
        if ii == devide_group_num %��ԍŌ�̃O���[�v�̎�
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
    if mutually_interaction == 1 %���ݍ�p���l�����邩�ǂ���
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
    % save result(�璷?���򑽂��̂͂��傤���Ȃ�?)
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
