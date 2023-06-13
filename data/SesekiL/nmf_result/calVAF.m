%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Last modification: 2023/2/15
Made by: Naohito Ohta
function:
1.plot VAF from designated day data
2.Find the contribution from muscle synergy here.
【caution!!!】
基本的にVAF_wayは'paper'を使用し，use_styleは'train'を使用すること
sort_dirの決め方が雑すぎ→UIでいじれるように改善
VAFを個々のシナジーの寄与率に分解することは無理?(funato論文の方法でもおそらく無理)
→他の指標を使うしかない
ind_VAF_wayは従来のVAFの方法だと分子の分散が大きくなってマイナスの値をとってしま??
都合が悪いのでマイナスの値を取らないように,(都合がいいように)オリジナルでVAFっぽいのも作った
【procedure】
・pre:plotTarget.m
・post:nothing!
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
term_type = 'pre'; %pre/post
ParentDir = pwd;
muscle_num = 9; %number of muscle which is used for NMF
use_style = 'test'; %test/train
VAF_plot_type = 'mean'; %'ind' or 'mean'
VAF_threshold = 0.8; % param to draw threshold_line
ref_syn_num = 4; %個々のシナジー解析をするときの筋シナジー数
VAF_way = 'oya'; %'funato'/'oya'
calc_type = 'volume'; %'VAF'/'volume'
save_contribution_fig = 1; %whether save the figure of each synergy contribution or not
%% code section
%日付を選ぶ
disp('please select day fold which you want to include to calculate')
InputDirs   = uiselect(dirdir(ParentDir),1,'??????????Experiments???I??????????????');
InputDir = InputDirs{1};
%元筋電データXの作成
Tarfiles = sortxls(dirmat(fullfile(ParentDir,InputDir)));
disp('plese select used EMG Data for NMF')
Tarfiles    = uiselect(Tarfiles,1,'Target?');
%VAF,Synergyデータの作成
synergy_data = cell(length(InputDirs),1);
VAF_data = cell(length(InputDirs),1);
for ii = 1:length(InputDirs)
    calc_day = InputDirs{ii};
    synergy_data_name = [calc_day '_' sprintf('%02d',muscle_num) '_nmf.mat'];
    VAF_data_name = [calc_day '_' sprintf('%02d',muscle_num) '.mat'];
    synergy_data{ii} = load(synergy_data_name);
    VAF_data{ii} = load(VAF_data_name);
end

%plot VAF
f = figure('Position',[100,100,800,600]);
hold on;
switch VAF_plot_type
    case 'ind'
        for ii = 1:length(VAF_data)
            x_axis = 1:muscle_num;
            shuffle_value = mean(VAF_data{ii}.shuffle.r2,2);
            switch use_style
                case 'test'
                    VAF_value = mean(VAF_data{ii}.test.r2,2);
                    plot(VAF_value,'o','LineWidth',2)
                    if ii == 1
                        plot(x_axis,shuffle_value,'k','LineWidth',2)
                    end
                case 'train'
                    VAF_value = mean(VAF_data{ii}.train.r2,2);
                    plot(x_axis,VAF_value)
                    if ii == 1
                        plot(x_axis,shuffle_value)
                    end
            end
        end
    case 'mean'
        for ii = 1:length(VAF_data)
            x_axis = 1:muscle_num;
            switch use_style
                case 'test'
                    VAF_value(:,ii) = mean(VAF_data{ii}.test.r2,2);
                    shuffle_value(:,ii) = mean(VAF_data{ii}.shuffle.r2,2);
                case 'train'
                    VAF_value = mean(VAF_data{ii}.train.r2,2);
                    plot(x_axis,VAF_value)
                    if ii == 1
                        plot(x_axis,shuffle_value)
                    end
            end
        end
        VAF_mean = mean(VAF_value,2);
        VAF_std = std(VAF_value,0,2);
        shuffle_mean = mean(shuffle_value,2);
        shuffle_std = std(shuffle_value,0,2);
        errorbar((1:muscle_num)',VAF_mean,VAF_std,'o-','LineWidth',2)
        errorbar((1:muscle_num)',shuffle_mean,shuffle_std,'o-','LineWidth',2)
        
end

%陬?鬟ｾ(蛻､萓具ｼ後ち繧､繝医Ν?ｼ碁明蛟､縺ｮyline,繧ｰ繝ｪ繝?繝会ｼ?
yline(VAF_threshold,'Color','k','LineWidth',2)
xlim([0 muscle_num]);
ylim([0 1])
hold off
%蝗ｳ縺ｮ菫晏ｭ?(fig縺ｨpng)
saveas(gcf,['VAF_result/VAF_result(' term_type ')_' VAF_plot_type '_' num2str(length(synergy_data)) 'days.png'])
saveas(gcf,['VAF_result/VAF_result(' term_type ')_' VAF_plot_type '_' num2str(length(synergy_data)) 'days.fig'])
close all


%% 個々の筋シナジーの寄与率の計算
%プロットデータを収納する行列の作成
ind_VAF_value = cell(length(InputDirs),1);
for ii = 1:length(ind_VAF_value)
    ind_VAF_value{ii} = zeros(1,ref_syn_num);
    ind_SST_value{ii} =  zeros(1,ref_syn_num);
end

for ii = 1:length(synergy_data) %日付分回す
    clear realX; clear all_reconstX
    switch use_style
        case 'test'
            W_synergy = synergy_data{ii}.test.W{ref_syn_num,1};
            H_synergy = synergy_data{ii}.test.H{ref_syn_num,1};
        case 'train'
            W_synergy = synergy_data{ii}.train.W{ref_syn_num,1};
            H_synergy = synergy_data{ii}.train.H{ref_syn_num,1};
    end
    %再構成筋電を作る
    all_W_synergy{ii} = W_synergy;
    for jj = 1:length(Tarfiles)
        load([ParentDir '/' InputDirs{ii} '/' Tarfiles{jj}],'Data')
        if not(exist('realX'))
            realX = zeros(muscle_num,length(Data)); 
        end
        realX(jj,:) = Data;
    end
    %offsetする
    realX = offset(realX,'min');
    %振幅の正規化
    realX = normalize(realX,'mean');
    for jj = 1:ref_syn_num
        eval(['reconstX_' num2str(jj) ' = W_synergy(:,' num2str(jj) ') * H_synergy(' num2str(jj) ',:);']);
        %reconstX_1 = W_synergy(:,1) * H_synergy(1,:)
        if not(exist('all_reconstX'))
            [row, col] = size(eval(['reconstX_' num2str(jj)]));
            all_reconstX = zeros(row, col);
        end
        all_reconstX = all_reconstX + eval(['reconstX_' num2str(jj)]);
    end
    %再構成筋電に対応する部分の元筋電の切り出し
    switch use_style
        case 'test'
             XX = realX(:,1:length(all_reconstX));
        case 'train'
             trash_data_length = length(Data) - length(all_reconstX);
             XX =  realX(:,trash_data_length+1:end) ;%後3/4を抽出
    end
    %切り出した範囲で振幅正規化
    XX = normalize(XX,'mean');
    E = XX - all_reconstX;
    switch VAF_way
        case 'funato' 
            SSE = sum(reshape(E,[],1).^2);    
            SST = sum((reshape(XX,[],1)).^2);
        case 'oya'
%             SSE = var(reshape(E,[],1));     
%             SST = var(reshape(XX,[],1));
            SSE = sum(reshape(E,[],1).^2);
            SST= sum((reshape(XX,[],1)-mean(mean(XX))).^2);
    end
    VAF_result = 1 - SSE./SST;
    disp(['VAF_reslut(synergy_num:' num2str(ref_syn_num) ') = ' num2str(VAF_result)])
    clear VAF_result %後々，mkdirのために同名のフォルダを使用するため
     
    %二乗和を用いて，個々の寄与率っぽいものを計算する」
    XX_volume = sum((reshape(XX,[],1)).^2);
    %計算開始
    for tt = 1:4 %reconstの二乗和を求める
        eval(['reconstX_' num2str(tt) '_volume = sum((reshape(reconstX_' num2str(tt) ',[],1)).^2);']);
        %reconstX_1_volume = sum((reshape(reconstX_1,[],1)).^2);
        contribution = eval(['reconstX_' num2str(tt) '_volume']) / XX_volume;
        ind_VAF_value{ii}(tt) = contribution;
    end
end

%% synergyの並び替え
%必要な変数の準備
Wcom = zeros(muscle_num,ref_syn_num);
% Wt = cell(1,length(synergy_data));
Wt = all_W_synergy;
aveWt = Wt{1};
m = zeros(length(synergy_data),ref_syn_num);
k_arr = ones(ref_syn_num, length(synergy_data));
%↓pre初日のシナジーにそろえるための操作
first_day = 2;
if strcmp(term_type,'post')
    first_day = 1;
    ref_synergy_data = load('Se200117_standard_09_nmf.mat');
    switch use_style
        case 'test'
            ref_W_synergy = ref_synergy_data.test.W{ref_syn_num,1};
        case 'train'
            ref_W_synergy = ref_synergy_data.train.W{ref_syn_num,1};
    end
end
%↓並び替えのための行列(k_arr)の作成
for i =  1:ref_syn_num
    k_arr(i,1) = i; %初日
    for j = first_day:length(synergy_data)
        for l = 1:ref_syn_num
            switch term_type
                case 'pre'
                     Wcom(:,l) = (all_W_synergy{1,1}(:,i) - all_W_synergy{1,j}(:,l)).^ 2; %蛻晄律縺ｮ繧ｷ繝翫ず繝ｼI縺ｨj譌･逶ｮ縺ｮ繧ｷ繝翫ず繝ｼl縺ｮ蟾ｮ繧?2荵励☆繧?
                case 'post'
                     Wcom(:,l) = (ref_W_synergy(:,i) - all_W_synergy{1,j}(:,l)).^ 2; %蛻晄律縺ｮ繧ｷ繝翫ず繝ｼI縺ｨj譌･逶ｮ縺ｮ繧ｷ繝翫ず繝ｼl縺ｮ蟾ｮ繧?2荵励☆繧?
            end
            m(j,l) = sum(Wcom(:,l)); %縺昴ｌ繧定ｶｳ縺怜粋繧上○繧?(荳?逡ｪ蟆上＆縺九▲縺溘ｂ縺ｮ縺後?√す繝翫ず繝ｼ縺ｫ縺ｪ繧九?ｯ縺?)
        end
        Wt{1,j}(:,i) = all_W_synergy{1,j}(:,find(m(j,:)==min(m(j,:))));
        all_W_synergy{1,j}(:,find(m(j,:)==min(m(j,:)))) = ones(muscle_num,1).*1000;
        k_arr(i,j) = find(m(j,:)==min(m(j,:)));
    end
end

for ii = 1:length(synergy_data) %k_arrを参考に並び替え
    arr_id = k_arr(:,ii);
    ind_VAF_value{ii,1} = ind_VAF_value{ii,1}(arr_id);
end
%蜑ｲ蜷医ｒ蜃ｺ縺?
for ii = 1:length(synergy_data) %トータルを求めて，正規化する(全部足すと1になるように)
    total = sum(ind_VAF_value{ii});
    ind_VAF_value{ii} = ind_VAF_value{ii}/total;
end
%蝗ｳ縺ｮ菴懈??
zeroBar = zeros(4,1);
syn_label = {'synergy1','synergy2','synergy3','synergy4'};
x = categorical(syn_label);
f1 = figure('Position',[300,250,750,400]);
hold on;
switch term_type
    case 'pre'
        bar(x,[zeroBar ind_VAF_value{1}(1,:)' ind_VAF_value{2}(1,:)' ind_VAF_value{3}(1,:)'],'b','EdgeColor','none');
    case 'post'
%         bar(x,[zeroBar ind_VAF_value{1}(1,:)' ind_VAF_value{2}(1,:)' ind_VAF_value{3}(1,:)' ind_VAF_value{4}(1,:)' ind_VAF_value{5}(1,:)' ind_VAF_value{6}(1,:)' ind_VAF_value{7}(1,:)' ind_VAF_value{8}(1,:)' ind_VAF_value{9}(1,:)' ind_VAF_value{10}(1,:)' ...
%             ind_VAF_value{11}(1,:)' ind_VAF_value{12}(1,:)' ind_VAF_value{13}(1,:)' ind_VAF_value{14}(1,:)' ind_VAF_value{15}(1,:)' ind_VAF_value{16}(1,:)' ind_VAF_value{17}(1,:)' ind_VAF_value{18}(1,:)' ind_VAF_value{19}(1,:)' ind_VAF_value{20}(1,:)' ...
%             ind_VAF_value{21}(1,:)' ind_VAF_value{22}(1,:)' ind_VAF_value{23}(1,:)' ind_VAF_value{24}(1,:)' ind_VAF_value{25}(1,:)' ind_VAF_value{26}(1,:)' ind_VAF_value{27}(1,:)' ind_VAF_value{28}(1,:)' ind_VAF_value{29}(1,:)' ind_VAF_value{30}(1,:)' ...
%             ind_VAF_value{31}(1,:)' ind_VAF_value{32}(1,:)' ind_VAF_value{33}(1,:)' ind_VAF_value{34}(1,:)' ind_VAF_value{35}(1,:)' ind_VAF_value{36}(1,:)' ind_VAF_value{37}(1,:)' ind_VAF_value{38}(1,:)' ind_VAF_value{39}(1,:)' ind_VAF_value{40}(1,:)' ...
%             ind_VAF_value{41}(1,:)' ind_VAF_value{42}(1,:)' ind_VAF_value{43}(1,:)' ind_VAF_value{44}(1,:)' ind_VAF_value{45}(1,:)' ind_VAF_value{46}(1,:)' ind_VAF_value{47}(1,:)'],'b','EdgeColor','none');
        bar(x,[zeroBar ind_VAF_value{1}(1,:)' ind_VAF_value{2}(1,:)' ind_VAF_value{3}(1,:)' ind_VAF_value{4}(1,:)' ind_VAF_value{5}(1,:)' ind_VAF_value{6}(1,:)' ind_VAF_value{7}(1,:)' ind_VAF_value{8}(1,:)' ind_VAF_value{9}(1,:)' ind_VAF_value{10}(1,:)' ...
            ind_VAF_value{11}(1,:)' ind_VAF_value{12}(1,:)' ind_VAF_value{13}(1,:)' ind_VAF_value{14}(1,:)' ind_VAF_value{15}(1,:)' ind_VAF_value{16}(1,:)' ind_VAF_value{17}(1,:)' ind_VAF_value{18}(1,:)' ind_VAF_value{19}(1,:)' ind_VAF_value{20}(1,:)' ...
            ind_VAF_value{21}(1,:)' ind_VAF_value{22}(1,:)' ind_VAF_value{23}(1,:)' ind_VAF_value{24}(1,:)' ind_VAF_value{25}(1,:)'],'b','EdgeColor','none');
end
%蝗ｳ縺ｮ陬?鬟ｾ
ylim([0,0.5])
title('each synergy contribution','FontSize',25)
ylabel('contribution','FontSize',20)
%蝗ｳ縺ｮ菫晏ｭ?
if save_contribution_fig == 1
    if not(exist('VAF_result'))
        mkdir('VAF_result')
    end
    saveas(gcf,['VAF_result/each_synergy_contribution(' term_type ').png'])
    saveas(gcf,['VAF_result/each_synergy_contribution(' term_type ').fig'])
end
close all