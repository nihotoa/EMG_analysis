%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Last modification: 2023/2/15
Made by: Naohito Ohta
function:
1.plot VAF from designated day data
2.Find the contribution from muscle synergy here.
�ycaution!!!�z
��{�I��VAF_way��'paper'���g�p���Cuse_style��'train'���g�p���邱��
sort_dir�̌��ߕ����G������UI�ł������悤�ɉ��P
VAF���X�̃V�i�W�[�̊�^���ɕ������邱�Ƃ͖���?(funato�_���̕��@�ł������炭����)
�����̎w�W���g�������Ȃ�
ind_VAF_way�͏]����VAF�̕��@���ƕ��q�̕��U���傫���Ȃ��ă}�C�i�X�̒l���Ƃ��Ă���??
�s���������̂Ń}�C�i�X�̒l�����Ȃ��悤��,(�s���������悤��)�I���W�i����VAF���ۂ��̂������
�yprocedure�z
�Epre:plotTarget.m
�Epost:nothing!
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
ref_syn_num = 4; %�X�̃V�i�W�[��͂�����Ƃ��̋؃V�i�W�[��
VAF_way = 'oya'; %'funato'/'oya'
calc_type = 'volume'; %'VAF'/'volume'
save_contribution_fig = 1; %whether save the figure of each synergy contribution or not
%% code section
%���t��I��
disp('please select day fold which you want to include to calculate')
InputDirs   = uiselect(dirdir(ParentDir),1,'??????????Experiments???I??????????????');
InputDir = InputDirs{1};
%���ؓd�f�[�^X�̍쐬
Tarfiles = sortxls(dirmat(fullfile(ParentDir,InputDir)));
disp('plese select used EMG Data for NMF')
Tarfiles    = uiselect(Tarfiles,1,'Target?');
%VAF,Synergy�f�[�^�̍쐬
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

%�?飾(判例，タイトル?��閾値のyline,グリ�?ド�?
yline(VAF_threshold,'Color','k','LineWidth',2)
xlim([0 muscle_num]);
ylim([0 1])
hold off
%図の保�?(figとpng)
saveas(gcf,['VAF_result/VAF_result(' term_type ')_' VAF_plot_type '_' num2str(length(synergy_data)) 'days.png'])
saveas(gcf,['VAF_result/VAF_result(' term_type ')_' VAF_plot_type '_' num2str(length(synergy_data)) 'days.fig'])
close all


%% �X�̋؃V�i�W�[�̊�^���̌v�Z
%�v���b�g�f�[�^�����[����s��̍쐬
ind_VAF_value = cell(length(InputDirs),1);
for ii = 1:length(ind_VAF_value)
    ind_VAF_value{ii} = zeros(1,ref_syn_num);
    ind_SST_value{ii} =  zeros(1,ref_syn_num);
end

for ii = 1:length(synergy_data) %���t����
    clear realX; clear all_reconstX
    switch use_style
        case 'test'
            W_synergy = synergy_data{ii}.test.W{ref_syn_num,1};
            H_synergy = synergy_data{ii}.test.H{ref_syn_num,1};
        case 'train'
            W_synergy = synergy_data{ii}.train.W{ref_syn_num,1};
            H_synergy = synergy_data{ii}.train.H{ref_syn_num,1};
    end
    %�č\���ؓd�����
    all_W_synergy{ii} = W_synergy;
    for jj = 1:length(Tarfiles)
        load([ParentDir '/' InputDirs{ii} '/' Tarfiles{jj}],'Data')
        if not(exist('realX'))
            realX = zeros(muscle_num,length(Data)); 
        end
        realX(jj,:) = Data;
    end
    %offset����
    realX = offset(realX,'min');
    %�U���̐��K��
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
    %�č\���ؓd�ɑΉ����镔���̌��ؓd�̐؂�o��
    switch use_style
        case 'test'
             XX = realX(:,1:length(all_reconstX));
        case 'train'
             trash_data_length = length(Data) - length(all_reconstX);
             XX =  realX(:,trash_data_length+1:end) ;%��3/4�𒊏o
    end
    %�؂�o�����͈͂ŐU�����K��
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
    clear VAF_result %��X�Cmkdir�̂��߂ɓ����̃t�H���_���g�p���邽��
     
    %���a��p���āC�X�̊�^�����ۂ����̂��v�Z����v
    XX_volume = sum((reshape(XX,[],1)).^2);
    %�v�Z�J�n
    for tt = 1:4 %reconst�̓��a�����߂�
        eval(['reconstX_' num2str(tt) '_volume = sum((reshape(reconstX_' num2str(tt) ',[],1)).^2);']);
        %reconstX_1_volume = sum((reshape(reconstX_1,[],1)).^2);
        contribution = eval(['reconstX_' num2str(tt) '_volume']) / XX_volume;
        ind_VAF_value{ii}(tt) = contribution;
    end
end

%% synergy�̕��ёւ�
%�K�v�ȕϐ��̏���
Wcom = zeros(muscle_num,ref_syn_num);
% Wt = cell(1,length(synergy_data));
Wt = all_W_synergy;
aveWt = Wt{1};
m = zeros(length(synergy_data),ref_syn_num);
k_arr = ones(ref_syn_num, length(synergy_data));
%��pre�����̃V�i�W�[�ɂ��낦�邽�߂̑���
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
%�����ёւ��̂��߂̍s��(k_arr)�̍쐬
for i =  1:ref_syn_num
    k_arr(i,1) = i; %����
    for j = first_day:length(synergy_data)
        for l = 1:ref_syn_num
            switch term_type
                case 'pre'
                     Wcom(:,l) = (all_W_synergy{1,1}(:,i) - all_W_synergy{1,j}(:,l)).^ 2; %初日のシナジーIとj日目のシナジーlの差�?2乗す�?
                case 'post'
                     Wcom(:,l) = (ref_W_synergy(:,i) - all_W_synergy{1,j}(:,l)).^ 2; %初日のシナジーIとj日目のシナジーlの差�?2乗す�?
            end
            m(j,l) = sum(Wcom(:,l)); %それを足し合わせ�?(�?番小さかったものが�?�シナジーになる�?��?)
        end
        Wt{1,j}(:,i) = all_W_synergy{1,j}(:,find(m(j,:)==min(m(j,:))));
        all_W_synergy{1,j}(:,find(m(j,:)==min(m(j,:)))) = ones(muscle_num,1).*1000;
        k_arr(i,j) = find(m(j,:)==min(m(j,:)));
    end
end

for ii = 1:length(synergy_data) %k_arr���Q�l�ɕ��ёւ�
    arr_id = k_arr(:,ii);
    ind_VAF_value{ii,1} = ind_VAF_value{ii,1}(arr_id);
end
%割合を出�?
for ii = 1:length(synergy_data) %�g�[�^�������߂āC���K������(�S��������1�ɂȂ�悤��)
    total = sum(ind_VAF_value{ii});
    ind_VAF_value{ii} = ind_VAF_value{ii}/total;
end
%図の作�??
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
%図の�?飾
ylim([0,0.5])
title('each synergy contribution','FontSize',25)
ylabel('contribution','FontSize',20)
%図の保�?
if save_contribution_fig == 1
    if not(exist('VAF_result'))
        mkdir('VAF_result')
    end
    saveas(gcf,['VAF_result/each_synergy_contribution(' term_type ').png'])
    saveas(gcf,['VAF_result/each_synergy_contribution(' term_type ').fig'])
end
close all