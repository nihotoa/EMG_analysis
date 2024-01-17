%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Last modification: 2024/01/08
Made by: Naohito Ohta

[procedure]
pre: plotTarget.m
post: nothing

[function]:
1.plot VAF from designated day data
2.Find the contribution from muscle synergy here.

【caustion!!】
基本的ににVAF_wayは'paper'を使用し，use_styleは'train'を使用すること
sort_dirの決め方が雑すぎ→UIでいじれるように改善する

VAFを個々のシナジーの寄与率に分解することは無理?(funato論文の方法でもおそらく無理? )
→ 他の指標を使用するしかない

ind_VAF_wayは???既存???VAFの方法だと?????子?????散が大きくなって??????イナスの値をとってしま??
都合が悪??ので??????イナスの値を取らな??ように,(都合???????ように)オリジナルでVAFっぽ??も???を作っ??
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
term_type = 'pre'; %pre / post / all 
ParentDir = pwd;
muscle_num = 10; %number of muscle which is used for NMF
use_style = 'test'; %test/train
VAF_plot_type = 'mean'; %'ind' or 'mean'
VAF_threshold = 0.8; % param to draw threshold_line
ref_syn_num = 4; % the number of synergy (please define this number by refering to VAF value)
calc_each_synergy_contribution = 1;
VAF_way = 'oya'; %'funato' / 'oya'
save_contribution_fig = 0; % whether you want to save contribution figure
%% code section

disp('Please select day fold which you want to include to calculate')
InputDirs   = uiselect(dirdir(ParentDir),1,'??????????Experiments???I??????????????');
InputDir = InputDirs{1};

% create EMG data array (X matrix)
Tarfiles = sortxls(dirmat(fullfile(ParentDir,InputDir)));
disp('Plese select used EMG Data for NMF')
Tarfiles    = uiselect(Tarfiles,1,'Target?');

% create the data array of VAF and Synergy
synergy_data = cell(length(InputDirs),1);
VAF_data = cell(length(InputDirs),1);
for ii = 1:length(InputDirs)
    ref_fold_name = InputDirs{ii};
    used_str = strrep(ref_fold_name, '_standard', '');
    synergy_data_name = [used_str '_' num2str(muscle_num) '_nmf.mat'];
    VAF_data_name = [used_str '_' num2str(muscle_num) '.mat'];
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

% decoration
yline(VAF_threshold,'Color','k','LineWidth',2)
xlim([0 muscle_num]);
grid on;
hold off

% save figure(as .fig & .png)
if not(exist(fullfile(pwd, 'VAF_result')))
    mkdir(fullfile(pwd, 'VAF_result'))
end
saveas(gcf,['VAF_result/VAF_result(' term_type ')_' VAF_plot_type '_' num2str(length(synergy_data)) 'days.png'])
saveas(gcf,['VAF_result/VAF_result(' term_type ')_' VAF_plot_type '_' num2str(length(synergy_data)) 'days.fig'])
close all


%% contribution of individual synergy
if calc_each_synergy_contribution == 1
    %繝励Ο繝?繝医ョ繝ｼ繧ｿ繧貞庶邏阪☆繧玖｡悟?励?ｮ菴懈??
    ind_VAF_value = cell(length(InputDirs),1);
    for ii = 1:length(ind_VAF_value)
        ind_VAF_value{ii} = zeros(1,ref_syn_num);
        ind_SST_value{ii} =  zeros(1,ref_syn_num);
    end
    
    for ii = 1:length(synergy_data) %譌･莉倥〒繝ｫ繝ｼ繝?
        clear realX; clear all_reconstX
        switch use_style
            case 'test'
                W_synergy = synergy_data{ii}.test.W{ref_syn_num,1};
                H_synergy = synergy_data{ii}.test.H{ref_syn_num,1};
            case 'train'
                W_synergy = synergy_data{ii}.train.W{ref_syn_num,1};
                H_synergy = synergy_data{ii}.train.H{ref_syn_num,1};
        end
        %蜈?縺ｮ繝?繝ｼ繧ｿ繧ｻ繝?繝?X繧剃ｽ懈?舌☆繧?(縺薙％縺悟､壼?髢馴＆縺｣縺ｦ縺?繧?)
        all_W_synergy{ii} = W_synergy;
        for jj = 1:length(Tarfiles)
            load([ParentDir '/' InputDirs{ii} '/' Tarfiles{jj}],'Data')
            if not(exist('realX'))
                realX = zeros(muscle_num,length(Data)); 
            end
            realX(jj,:) = Data;
        end
        %offset縺ｧ雋?蛟､繧偵↑縺上☆
        realX = offset(realX,'min');
        %謖ｯ蟷?縺ｮ豁｣隕丞喧
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
        %蜀肴ｧ区?千ｭ矩崕縺ｫ蟇ｾ蠢懊☆繧玖ｨ域ｸｬ遲矩崕繝?繝ｼ繧ｿ縺ｮ蛻?繧雁?ｺ縺?
        switch use_style
            case 'test'
                 XX = realX(:,1:length(all_reconstX));
            case 'train'
                 trash_data_length = length(Data) - length(all_reconstX);
                 XX =  realX(:,trash_data_length+1:end) ;%蠕後ｍ3/4繧呈歓蜃ｺ
        end
        %蛻?繧雁?ｺ縺励◆遽?蝗ｲ縺ｧ謖ｯ蟷?豁｣隕丞喧
        XX = normalize(XX,'mean');
        %繝輔ヤ繝ｼ縺ｮVAF繧呈ｱゅａ繧?
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
         
        %螟ｧ縺阪＆縺ｮ豈碑ｼ?縺ｫ繧医▲縺ｦ蟇?荳守紫繧ゅ←縺阪ｒ邂怜?ｺ
        XX_volume = sum((reshape(XX,[],1)).^2);
        %險育ｮ励?ｮ髢句ｧ?
        denominator = 0;
        for tt = 1:ref_syn_num %reconst縺ｮ螟ｧ縺阪＆繧呈ｱゅａ縺ｦ縺?縺?
            eval(['reconstX_' num2str(tt) '_volume = sum((reshape(reconstX_' num2str(tt) ',[],1)).^2);']);
            denominator = denominator + eval(['reconstX_' num2str(tt) '_volume']);
        end
        for tt = 1:ref_syn_num
            contribution = eval(['reconstX_' num2str(tt) '_volume']) / denominator;
            ind_VAF_value{ii}(tt) = contribution;
        end
    end
    
    %synergy縺ｮ荳ｦ縺ｳ譖ｿ縺?
    Wcom = zeros(muscle_num,ref_syn_num);
    % Wt = cell(1,length(synergy_data));
    Wt = all_W_synergy;
    aveWt = Wt{1};
    m = zeros(length(synergy_data),ref_syn_num);
    k_arr = ones(ref_syn_num, length(synergy_data));
    first_day = 2;
    if strcmp(term_type,'post')
        first_day = 1;
        ref_synergy_data = load('Ya170516_10_nmf.mat');
        switch use_style
            case 'test'
                ref_W_synergy = ref_synergy_data.test.W{ref_syn_num,1};
            case 'train'
                ref_W_synergy = ref_synergy_data.train.W{ref_syn_num,1};
        end
    end
    
    for i =  1:ref_syn_num
        k_arr(i,1) = i; %蛻晄律
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
    
    for ii = 1:length(synergy_data) %譌･莉俶焚蛻?縺?縺大屓縺?
        arr_id = k_arr(:,ii);
        ind_VAF_value{ii,1} = ind_VAF_value{ii,1}(arr_id);
    end
    %蜑ｲ蜷医ｒ蜃ｺ縺?
    for ii = 1:length(synergy_data) %譌･莉俶焚蛻?縺?縺大屓縺?
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
            bar(x,[zeroBar ind_VAF_value{1}(1,:)' ind_VAF_value{2}(1,:)' ind_VAF_value{3}(1,:)' ind_VAF_value{4}(1,:)'],'b','EdgeColor','none');
        case 'post'
            bar(x,[zeroBar ind_VAF_value{1}(1,:)' ind_VAF_value{2}(1,:)' ind_VAF_value{3}(1,:)' ind_VAF_value{4}(1,:)' ind_VAF_value{5}(1,:)' ind_VAF_value{6}(1,:)' ind_VAF_value{7}(1,:)' ind_VAF_value{8}(1,:)' ind_VAF_value{9}(1,:)' ind_VAF_value{10}(1,:)' ...
                ind_VAF_value{11}(1,:)' ind_VAF_value{12}(1,:)' ind_VAF_value{13}(1,:)' ind_VAF_value{14}(1,:)' ind_VAF_value{15}(1,:)' ind_VAF_value{16}(1,:)' ind_VAF_value{17}(1,:)' ind_VAF_value{18}(1,:)' ind_VAF_value{19}(1,:)' ind_VAF_value{20}(1,:)' ...
                ind_VAF_value{21}(1,:)' ind_VAF_value{22}(1,:)' ind_VAF_value{23}(1,:)' ind_VAF_value{24}(1,:)' ind_VAF_value{25}(1,:)' ind_VAF_value{26}(1,:)' ind_VAF_value{27}(1,:)' ind_VAF_value{28}(1,:)' ind_VAF_value{29}(1,:)' ind_VAF_value{30}(1,:)' ...
                ind_VAF_value{31}(1,:)' ind_VAF_value{32}(1,:)' ind_VAF_value{33}(1,:)' ind_VAF_value{34}(1,:)' ind_VAF_value{35}(1,:)' ind_VAF_value{36}(1,:)' ind_VAF_value{37}(1,:)' ind_VAF_value{38}(1,:)' ind_VAF_value{39}(1,:)' ind_VAF_value{40}(1,:)' ...
                ind_VAF_value{41}(1,:)' ind_VAF_value{42}(1,:)' ind_VAF_value{43}(1,:)' ind_VAF_value{44}(1,:)' ind_VAF_value{45}(1,:)' ind_VAF_value{46}(1,:)' ind_VAF_value{47}(1,:)'],'b','EdgeColor','none');
    end
    %蝗ｳ縺ｮ陬?鬟ｾ
    ylim([0,0.5])
    title('each synergy contribution','FontSize',25)
    ylabel('contribution','FontSize',20)
    %蝗ｳ縺ｮ菫晏ｭ?
    if save_contribution_fig == 1
        saveas(gcf,['VAF_result/each_synergy_contribution(' term_type ').png'])
        saveas(gcf,['VAF_result/each_synergy_contribution(' term_type ').fig'])
    end
    close all
end