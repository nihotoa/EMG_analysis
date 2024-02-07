%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%coded by Naoki Uchida
% last modification : 2023.2.6(by Ohta)

[Your operation]
1. Please complete the steps up to pre-procedure (refer to below ([procedure]))
2. Go to the directory named 'data' (directory where this code exists)
3. Change some parameters (please refer to 'set param' section)
4. Please run this code & select data by following guidance (which is displayed in command window after Running this code)

[role of this code]
1. plot EMG (or activty pattern of muslcle Synergy) around each timing and save as figure 
2. Preapare data for cross-correlation analysis

[caution!!]
1. Sometimes the function 'uigetfile' is not executed and an error occurs
-> please reboot MATLAB

[procedure]
pre : MakeDataForPlot_H_utb.m
post : calcXcorr.m(if you want to calculate & plot Xcorr) 【place】: /Volumes/Untitled/MATLAB/data/Yachimun/easyData/P-DATA(old filter TTakei delayed)
       or calVAF.m(to calculate the contribution of each synergy)
       or testWplot_tf.m file (to confirm whether there are no difference between pre and post synergy_W, location: EMG_analysis/synergyData)
(+a):When you want to check the H_synergy of each synergy cut out at each timing at once, use plotSynergy.m (contained in 'data' fold).
[改善点]
plotに使ったEMGデータ(Pall, Ptrig1...)がどこに保存されるのかをinformationとして書く
このデータは,normalizeされる場合とされない場合で区別されないで保存されている -> 名前で区別して保存する
シナジーのHはeasyData -> Pdata -> フォルダ名の中に保存されることを書く
pre初日のシナジーと,post初日のシナジーの入れ替えを自動で行う様に設定する(dispNMF_Wの方でも同様に)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%% set param

%Pall(Lever1 on) : Averaged dataset on each session -50:150%(triggered at hold_on1)
%Ptrig1(Lever1 off) : Averaged dataset on each session -50:50%(triggered at hold_off1)
%Ptrig2 : Averaged dataset on each session -50:50%(triggered at hold_on2)
%Ptrig3 : Averaged dataset on each session -25:105%(triggered at hold_on1)

realname = 'SesekiL'; %monkey name 'Yachimun'/'SesekiL'/'Wasa'
monkeyname = 'Se'; %prefix of Raw data(ex) 'Se'/'Ya'/'F'/'Wa' 
Tar = 'EMG';  % the data which you want to plot -> 'EMG' or 'Synergy'
save_fold = 'easyData';     % you don't need to change
plot_fig = 1;               % wtherer you want to plot figures
pColor = 'K';               %select 'K'(black plot) or 'C'(color plot) 【recommend!!】pre-analysis:'K' post-analysis:'C'
save_data = 0;              %save cut data for calculating cross-correlation(each session)
save_end_control = 0;       %save cut data for calculating cross-correlation(Pre Data as a control data)
fontS = 5; % 10;            %font size in figures 
LineW = 1.5; %0.1;          %width of plot line 
CTC = 0;                    %plot Cross Talk(I don't confirm whether I can use this) 
nomalizeAmp = 0;            %normalize Amplitude 
YL = Inf;                   %(if nomalize Amp == 0) ylim of graph
save_xcorr_data = 0;        %save data to use of plot x_corr
plot_max_EMG_value = 0; % if you want to save each days & each muscles max EMG value
nmf_fold_name = 'nmf_result'; %(if you want to plot synergy data) folder name of nmf_fold
plot_figure_type = 'forHara';  %'default' / 'forHara' プロットするfigureのタイプ.default:フツーのやつ.forHara:一つのタイミングのsubplotに全ての筋肉(pColor='K'の時にしか設定していない)
eliminate_muscles = 0; %(if plot_figure_type=='forHara' & monkeyname== 'Se') if you want to ignore some muscles which is broken in post-section when you plot figures. 
synergy_order = [3,1,4,2];  %(pre1,2,3,4)に対応するpostのsynergy(Yachimun:[4,2,1,3], Seseki:[3,1,4,2])
%% code section
switch monkeyname
   case 'F'
      PreDays = [170516, 170517, 170524, 170526];
      AVEPre4List = [1 2 3 4];%170516,170517,170524,170526 (same as synergy analysis )_Yachimun
      % plot window (Xcorr data will be made in this range)
      plotWindow1 = [-25 5];
      plotWindow2 = [-15 15];
      plotWindow3 = [-15 15];
      plotWindow4 = [95 125];
   case 'Ya'
      PreDays = [170516, 170517, 170524, 170526];
      AVEPre4List = [1 2 3 4];%170516,170517,170524,170526 (same as synergy analysis )_Yachimun
      % plot window (Xcorr data will be made in this range)
      plotWindow1 = [-25 5];
      plotWindow2 = [-15 15];
      plotWindow3 = [-15 15];
      plotWindow4 = [95 125];
   case 'Se'
      PreDays = [200117, 200119, 200120];
      AVEPre4List = [1 2 3];%200117,200119,200120 (same as synergy analysis )
      % plot window (Xcorr data will be made in this range)
      plotWindow1 = [-30 15];
      plotWindow2 = [-10 15];
      plotWindow3 = [-15 15];
      plotWindow4 = [98 115];
  case 'Wa'
      PreDays = []; % to be decided
      AVEPre4List = []; % to be decided
      % plot window (Xcorr data will be made in this range)
      plotWindow1 = [-25 5];
      plotWindow2 = [-15 15];
      plotWindow3 = [-15 15];
      plotWindow4 = [95 125];
end
switch Tar
    case 'EMG'
        disp(['【please select Pdata.mat for all the dates you want to plot(location: ' realname ' -> easyData -> P-DATA)】'])
        Allfiles_S = uigetfile('*_Pdata.mat',...
                             'Select One or More Files', ...
                             'MultiSelect', 'on');
        if ischar(Allfiles_S)
            Allfiles_S = {Allfiles_S};
        end
        S = size(Allfiles_S);
    case 'Synergy'
        subN = 4; %subplot Num = num
        %please select all Pdata generated by MakeDataPlot_H_utb(Yachimun nmf_result synData→Ya4~_Pdata.mat)
        disp(['【please select all Pdata generated by MakeDataPlot_H_utb(' realname ' -> ' nmf_fold_name ' -> synData→' monkeyname 'Syn4~_Pdata.mat)】'])
        Allfiles_S = uigetfile('*.mat',...
                             'Select One or More Files', ...
                             'MultiSelect', 'on');
        if ischar(Allfiles_S)
            Allfiles_S = {Allfiles_S};
        end
        S = size(Allfiles_S);
end
Allfiles = strrep(Allfiles_S,'_Pdata.mat',''); 
AllDays = strrep(Allfiles,monkeyname,'');
if pColor == 'C'
    AllDaysN = strrep(AllDays,'Syn4','');
    AllDaysN =str2double(AllDaysN');
end
AllT_AVE = 0;
Pall.Tlist = zeros(S(2),1);
TaskT_AVE = 0;
TaskTlist = zeros(S(2),1);
D1_AVE = 0;
Ptrig1.Tlist = zeros(S(2),1);
D2_AVE = 0;
Ptrig2.Tlist = zeros(S(2),1);
D3_AVE = 0;
Ptrig3.Tlist = zeros(S(2),1);
cd([realname '/easyData/P-DATA'])
%% CT
%Daily variation of CrossTalk
if CTC == 1
    for r = 1:S(2)%file=num loop
        load(Allfiles_S{r},'Yave','Y3ave');
        if r==1
            A = Yave;
            A3 = Y3ave;
        elseif r>1
            A(:,:,r) = Yave;
            A3(:,:,r) = Y3ave;
        end 
    end
    %plot CT
    f1 = figure('Position',[0 0 2000 1200]);
    f2 = figure('Position',[0 0 2000 1200]);
    for k=1:12
        figure(f1);
        for l=1:12
            subplot(12,12,l+(k-1)*12);
            hold on
            plot([0 S(2)],[0.25 0.25],'k');
            plot(reshape(A(13-k,l,:),1,[]),'LineWidth',1.5);
            Xe = find(reshape(A(13-k,l,:),1,[])>0.25);
            plot(Xe,reshape(A(13-k,l,Xe),1,[]),'ro','MarkerSize',2,'MarkerFaceColor','r');
            hold off
            ylim([0 1.2]);
            xlim([0 S(2)]);
        end
        figure(f2);
        for l=1:12
            subplot(12,12,l+(k-1)*12);
            hold on
            plot([0 S(2)],[0.25 0.25],'k');
            plot(reshape(A3(13-k,l,:),1,[]),'LineWidth',1.5);
             Xe = find(reshape(A3(13-k,l,:),1,[])>0.25);
            plot(Xe,reshape(A3(13-k,l,Xe),1,[]),'ro','MarkerSize',2,'MarkerFaceColor','r');
            hold off
            ylim([0 1.2]);
            xlim([0 S(2)]);
        end
    end
    SaveFig(f1,[realname 'CrossTalk'])
    SaveFig(f2,[realname 'CrossTalk3rdDev'])
end
%% plot averaged Data
%get the average value of task time
for i = 1:S(2)
   switch Tar
    case {'EMG','EMG_NDfilt'}
        load(Allfiles_S{i},'AllT','Tp','TIME_W','D'); %AllT:all time
    case 'Synergy'
%         load(Allfiles_S{i},'Tp');
        cd ../../
%         load_dir = 'nmf_result/synData/';
        load_dir = [nmf_fold_name '/synData/'];
        load([load_dir monkeyname AllDays{i} '_Pdata.mat'],'AllT','TIME_W','D');
        cd('easyData/P-DATA')
    case 'Synfixed'
        load(Allfiles_S{i},'Tp');
        load([monkeyname 'Synfixed' AllDays{i} '_Pdata.mat'],'AllT','TIME_W','D');
   end
    %AllT
    AllT_AVE = (AllT_AVE*(i-1) + AllT)/i;
    Pall.Tlist(i,1) = AllT;
    %TIME_W
    TaskT_AVE = (TaskT_AVE*(i-1) + TIME_W)/i;
    TaskTlist(i,1) = TIME_W;
    %D.Ld1
    D1_AVE = (D1_AVE*(i-1) + D.Ld1)/i;
    Ptrig1.Tlist(i,1) = D.Ld1;
    %D.Ld2
    D2_AVE = (D2_AVE*(i-1) + D.Ld2)/i;
    Ptrig2.Tlist(i,1) = D.Ld2;
    %D.Ld3
    D3_AVE = (D3_AVE*(i-1) + D.Ld3)/i;
    Ptrig3.Tlist(i,1) = D.Ld3;
end
Pall.AllT_AVE = round(AllT_AVE);
TaskT_AVE = round(TaskT_AVE);
Ptrig1.AllT_AVE = round(D1_AVE);
Ptrig2.AllT_AVE = round(D2_AVE);
Ptrig3.AllT_AVE = round(D3_AVE);
%cd ../../
% load(Allfiles_S{i},'taskRange');
Pall.plotData_sel = cell(S(2),1);
Ptrig1.plotData_sel = cell(S(2),1);
Ptrig2.plotData_sel = cell(S(2),1);
Ptrig3.plotData_sel = cell(S(2),1);

%%%%%%%%%%%%%%    nomalize data   %%%%%%%%%%%%%%
% load all_task_data(pre:50%, post:50%) & resample & store Pall.plotData_sel
%%%  ALL  %%%
for j = 1:S(2)%file=num loop
    switch Tar
        case {'EMG','EMG_NDfilt'}
            load(Allfiles_S{j},'alignedDataAVE');
            load([monkeyname AllDays{j} '_dataTrig' Tar '.mat'],'alignedData_all');
            [trigData, ~] = AlignDatasets(alignedData_all,Pall.AllT_AVE ,'row'); % transpose 'alignedData_all' & resample(adjust data length to 'All_AVE')
            Pall.trigData_sel{j,1} = trigData;
            subN = length(alignedData_all); % number of muscle
        case 'Synergy'
            cd ../../
            load([load_dir monkeyname AllDays{j} '_Pdata.mat'],'alignedDataAVE');
            cd 'easyData/P-DATA'
        case 'Synfixed'
            load([monkeyname 'Synfixed' AllDays{j} '_Pdata.mat'],'alignedDataAVE');
    end
    Sk = size(alignedDataAVE); %synergy(or EMG) num
    [plotData, ~] = AlignDatasets(alignedDataAVE,Pall.AllT_AVE ,'row'); % transpose 'alignedDataAVE' & resample(adjust data length to 'All_AVE')
    if nomalizeAmp
       for mm = 1:Sk(2)          
          plotData{mm} = plotData{mm}./max(plotData{mm});
       end
    end
    Pall.plotData_sel{j,1} = plotData;
end

% load around each timing aligned data(pre:50%, post:50%) & resample & store Ptrig?.plotData_sel
%%%  trig obj1 end  %%%
switch Tar
    case 'EMG'
        [Ptrig1, Sk] = resampleEachtiming(Tar, Allfiles_S, Ptrig1, 1, nomalizeAmp);
        [Ptrig2, Sk] = resampleEachtiming(Tar, Allfiles_S, Ptrig2, 2, nomalizeAmp);
        [Ptrig3, Sk] = resampleEachtiming(Tar, Allfiles_S, Ptrig3, 3, nomalizeAmp);
        load(Allfiles_S{1},'EMGs','taskRange');
    case 'Synergy'
        [Ptrig1, Sk] = resampleEachtiming(Tar, Allfiles_S, Ptrig1, 1, nomalizeAmp, load_dir, monkeyname, AllDays);
        [Ptrig2, Sk] = resampleEachtiming(Tar, Allfiles_S, Ptrig2, 2, nomalizeAmp, load_dir, monkeyname, AllDays);
        [Ptrig3, Sk] = resampleEachtiming(Tar, Allfiles_S, Ptrig3, 3, nomalizeAmp, load_dir, monkeyname, AllDays);
        cd ../../
        load([load_dir Allfiles_S{1}],'taskRange');
        cd easyData/P-DATA
end

% switch Tar
%     case 'EMG'
%         load(Allfiles_S{1},'EMGs','taskRange');
%     case 'Synergy'
%         cd ../../
%         load(['nmf_result/synData/' Allfiles_S{1}],'taskRange');
%         cd easyData/P-DATA
% end

switch pColor
   case 'C'
      % P = load('PostDays.mat');
      switch Tar
          case 'EMG'
            [P.PostDays] = extract_post_days(PreDays);
          case 'Synergy'
              P.PostDays = AllDaysN;
      end

      switch monkeyname
         case 'Ya'
            PostDays = P.PostDays;
            Sp = length(PostDays);
            Csp = zeros(Sp,3);
            Csp(:,1) = ones(Sp,1).*linspace(0.3,1,Sp)';
         case 'F'
            PostDays = P.PostDays;
            Sp = length(PostDays);
%             cmap_cold = [0 200 255; 0 120 255; 0 40 255];
%             cmap_warm = [236 0 0];
%             Csp =  [cmap_cold; cmap_warm] / 255;
            Csp = zeros(Sp,3);
            Csp(:,1) = ones(Sp,1).*linspace(0.3,1,Sp)';
         case 'Se'
            PostDays = P.PostDays;
            Sp = length(PostDays);
%             cmap_cold = [0 200 255; 0 150 255; 0 100 255; 0 40 255];
%             cmap_warm = [236 0 0];
%             Csp =  [cmap_cold; cmap_warm] / 255;
            Csp = zeros(Sp,3);
            Csp(:,2) = ones(Sp,1).*linspace(0.3,1,Sp)';
         case 'Ma'
            PostDays = P.PostDays;
            Sp = length(PostDays);
            Csp = zeros(Sp,3);
            Csp(:,1) = ones(Sp,1).*linspace(0.3,1,Sp)';
      end
   case 'K'

end
%make data for SD plot
SDdata = cell(S(2),1);
Pall.SD = cell(Sk(2),1);
Pall.AVE = cell(Sk(2),1);
for m = 1:Sk(2)
   for d = 1:S(2)
      SDdata{d} = cell2mat(Pall.plotData_sel{d,1}(m,:));
   end
   Pall.SD{m} = std(cell2mat(SDdata),1,1);
   Pall.AVE{m} = mean(cell2mat(SDdata),1);
end
Ptrig1.SD = cell(Sk(2),1);
for m = 1:Sk(2)
   for d = 1:S(2)
      SDdata{d} = Ptrig1.plotData_sel{d,1}(m,:);
   end
   Ptrig1.SD{m} = std(cell2mat(SDdata),1,1);
   Ptrig1.AVE{m} = mean(cell2mat(SDdata),1);
end
Ptrig2.SD = cell(Sk(2),1);
for m = 1:Sk(2)
   for d = 1:S(2)
      SDdata{d} = Ptrig2.plotData_sel{d,1}(m,:);
   end
   Ptrig2.SD{m} = std(cell2mat(SDdata),1,1);
   Ptrig2.AVE{m} = mean(cell2mat(SDdata),1);
end
for m = 1:Sk(2)
   for d = 1:S(2)
      SDdata{d} = Ptrig3.plotData_sel{d,1}(m,:);
   end
   Ptrig3.SD{m} = std(cell2mat(SDdata),1,1);
   Ptrig3.AVE{m} = mean(cell2mat(SDdata),1);
end

%save data for calculating cross-correlation
if save_data==1
    %he range of data cutting
    cutWin1 = round((plotWindow1./100).*TaskT_AVE + Pall.AllT_AVE/4);
    cutWin2 = round((plotWindow2./100).*TaskT_AVE + Ptrig1.AllT_AVE/2);
    cutWin3 = round((plotWindow3./100).*TaskT_AVE + Ptrig2.AllT_AVE/2);
    cutWin4 = round((plotWindow4./100).*TaskT_AVE + Pall.AllT_AVE/4);
    %X-corr Data
    TrigData_Each.T1.data = cell(S);
    TrigData_Each.T2.data = cell(S);
    TrigData_Each.T3.data = cell(S);
    TrigData_Each.T4.data = cell(S);
    %次のmake struct dataが行えるように、データ構造を変更する
    for j = 1:S(2)
        Pall.plotData_sel{j} = cell2mat(Pall.plotData_sel{j});
    end
    %make struct data 
    for j = 1:S(2)
    %
%         TrigData_Each.T1.data{j} = Pall.plotData_sel{1,1}{j}(:,cutWin1(1)+1:cutWin1(2));
        TrigData_Each.T1.data{j} = Pall.plotData_sel{j}(:,cutWin1(1)+1:cutWin1(2));
        TrigData_Each.T2.data{j} = Ptrig2.plotData_sel{j}(:,cutWin2(1)+1:cutWin2(2));
        TrigData_Each.T3.data{j} = Ptrig3.plotData_sel{j}(:,cutWin3(1)+1:cutWin3(2));
%         TrigData_Each.T4.data{j} = Pall.plotData_sel{1,1}{j}(:,cutWin4(1)+1:cutWin4(2));
        TrigData_Each.T4.data{j} = Pall.plotData_sel{j}(:,cutWin4(1)+1:cutWin4(2));
    end
    %make end-control data (4days) Only Yachimun
    if save_end_control==1
        TrigData_Each.T1.AVEend4 = (TrigData_Each.T1.data{S(2)} + TrigData_Each.T1.data{S(2)-1} + TrigData_Each.T1.data{S(2)-2} + TrigData_Each.T1.data{S(2)-3})./4;
        TrigData_Each.T2.AVEend4 = (TrigData_Each.T2.data{S(2)} + TrigData_Each.T2.data{S(2)-1} + TrigData_Each.T2.data{S(2)-2} + TrigData_Each.T2.data{S(2)-3})./4;
        TrigData_Each.T3.AVEend4 = (TrigData_Each.T3.data{S(2)} + TrigData_Each.T3.data{S(2)-1} + TrigData_Each.T3.data{S(2)-2} + TrigData_Each.T3.data{S(2)-3})./4;
        TrigData_Each.T4.AVEend4 = (TrigData_Each.T4.data{S(2)} + TrigData_Each.T4.data{S(2)-1} + TrigData_Each.T4.data{S(2)-2} + TrigData_Each.T4.data{S(2)-3})./4;
        if S(2)==80
             TrigData_Each.T1.AVEPre4 = (TrigData_Each.T1.data{AVEPre4List(1)} + TrigData_Each.T1.data{AVEPre4List(2)} + TrigData_Each.T1.data{AVEPre4List(3)} + TrigData_Each.T1.data{AVEPre4List(4)})./4;
             TrigData_Each.T2.AVEPre4 = (TrigData_Each.T2.data{AVEPre4List(1)} + TrigData_Each.T2.data{AVEPre4List(2)} + TrigData_Each.T2.data{AVEPre4List(3)} + TrigData_Each.T2.data{AVEPre4List(4)})./4;
             TrigData_Each.T3.AVEPre4 = (TrigData_Each.T3.data{AVEPre4List(1)} + TrigData_Each.T3.data{AVEPre4List(2)} + TrigData_Each.T3.data{AVEPre4List(3)} + TrigData_Each.T3.data{AVEPre4List(4)})./4;
             TrigData_Each.T4.AVEPre4 = (TrigData_Each.T4.data{AVEPre4List(1)} + TrigData_Each.T4.data{AVEPre4List(2)} + TrigData_Each.T4.data{AVEPre4List(3)} + TrigData_Each.T4.data{AVEPre4List(4)})./4;
             TrigData_Each.AVEPre4List = AVEPre4List;
        end
        if or(S(2)==51, S(2)==37)
             TrigData_Each.T1.AVEPre4 = (TrigData_Each.T1.data{AVEPre4List(1)} + TrigData_Each.T1.data{AVEPre4List(2)} + TrigData_Each.T1.data{AVEPre4List(3)} + TrigData_Each.T1.data{AVEPre4List(4)})./4;
             TrigData_Each.T2.AVEPre4 = (TrigData_Each.T2.data{AVEPre4List(1)} + TrigData_Each.T2.data{AVEPre4List(2)} + TrigData_Each.T2.data{AVEPre4List(3)} + TrigData_Each.T2.data{AVEPre4List(4)})./4;
             TrigData_Each.T3.AVEPre4 = (TrigData_Each.T3.data{AVEPre4List(1)} + TrigData_Each.T3.data{AVEPre4List(2)} + TrigData_Each.T3.data{AVEPre4List(3)} + TrigData_Each.T3.data{AVEPre4List(4)})./4;
             TrigData_Each.T4.AVEPre4 = (TrigData_Each.T4.data{AVEPre4List(1)} + TrigData_Each.T4.data{AVEPre4List(2)} + TrigData_Each.T4.data{AVEPre4List(3)} + TrigData_Each.T4.data{AVEPre4List(4)})./4;
             TrigData_Each.AVEPre4List = AVEPre4List;
        end
        if or(S(2)==50, S(2)==49)
             TrigData_Each.T1.AVEPre4 = (TrigData_Each.T1.data{AVEPre4List(1)} + TrigData_Each.T1.data{AVEPre4List(2)} + TrigData_Each.T1.data{AVEPre4List(3)} + TrigData_Each.T1.data{AVEPre4List(4)})./4;
             TrigData_Each.T2.AVEPre4 = (TrigData_Each.T2.data{AVEPre4List(1)} + TrigData_Each.T2.data{AVEPre4List(2)} + TrigData_Each.T2.data{AVEPre4List(3)} + TrigData_Each.T2.data{AVEPre4List(4)})./4;
             TrigData_Each.T3.AVEPre4 = (TrigData_Each.T3.data{AVEPre4List(1)} + TrigData_Each.T3.data{AVEPre4List(2)} + TrigData_Each.T3.data{AVEPre4List(3)} + TrigData_Each.T3.data{AVEPre4List(4)})./4;
             TrigData_Each.T4.AVEPre4 = (TrigData_Each.T4.data{AVEPre4List(1)} + TrigData_Each.T4.data{AVEPre4List(2)} + TrigData_Each.T4.data{AVEPre4List(3)} + TrigData_Each.T4.data{AVEPre4List(4)})./4;
             TrigData_Each.AVEPre4List = AVEPre4List;
        end
        
        if or(S(2)==28, S(2)==27)
             TrigData_Each.T1.AVEPre4 = (TrigData_Each.T1.data{AVEPre4List(1)} + TrigData_Each.T1.data{AVEPre4List(2)} + TrigData_Each.T1.data{AVEPre4List(3)})./3;
             TrigData_Each.T2.AVEPre4 = (TrigData_Each.T2.data{AVEPre4List(1)} + TrigData_Each.T2.data{AVEPre4List(2)} + TrigData_Each.T2.data{AVEPre4List(3)})./3;
             TrigData_Each.T3.AVEPre4 = (TrigData_Each.T3.data{AVEPre4List(1)} + TrigData_Each.T3.data{AVEPre4List(2)} + TrigData_Each.T3.data{AVEPre4List(3)})./3;
             TrigData_Each.T4.AVEPre4 = (TrigData_Each.T4.data{AVEPre4List(1)} + TrigData_Each.T4.data{AVEPre4List(2)} + TrigData_Each.T4.data{AVEPre4List(3)})./3; 
             TrigData_Each.AVEPre4List = AVEPre4List;
        end
    end
end
mkdir([ Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end))]);
cd([ Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end))]);
Pall.x = linspace(taskRange(1),taskRange(2),Pall.AllT_AVE);
Ptrig1.x = linspace(-D.Range1(1),D.Range1(2),Ptrig1.AllT_AVE);
Ptrig2.x = linspace(-D.Range2(1),D.Range2(2),Ptrig2.AllT_AVE);
Ptrig3.x = linspace(-D.Range3(1),D.Range3(2),Ptrig3.AllT_AVE);

% if you plot post Synergy, swap the row of data (to match pre-syenrgy)
if strcmp(Tar, 'Synergy') && strcmp(pColor, 'C')
    Pdata_list = {'Pall', 'Ptrig2', 'Ptrig3'};
    days_num = length(AllDays);
    for ii = 1:length(Pdata_list)
        for d = 1:days_num
            temp = eval([Pdata_list{ii} '.plotData_sel{d}(synergy_order, :);']);
            eval([Pdata_list{ii} '.plotData_sel{d} = temp;'])
        end
    end
end

% Rearrange post and concatenate it with pre
if strcmp(Tar, 'Synergy') && strcmp(pColor, 'K') && not(length(AllDays) == length(PreDays))
    Pdata_list = {'Pall', 'Ptrig2', 'Ptrig3'};
    for ii = 1:length(Pdata_list)
        for d = length(PreDays)+1:length(AllDays)
            temp = eval([Pdata_list{ii} '.plotData_sel{d}(synergy_order, :);']);
            eval([Pdata_list{ii} '.plotData_sel{d} = temp;'])
        end
    end
end
%% plot figure
disp('start %%%%%%%%%%%%%%%% PLOT DATA %%%%%%%%%%%%%%%%')
%% 1. plot all taks range data(all muscle) -> plot range follows 'plotWindow'
if plot_fig == 1
    % generate figure 
    f_stack = figure('position', [100, 100, 1000, 1000]);
    if strcmp(pColor, 'K')
        f_std = figure('position', [100, 100, 1000, 1000]);
    end

    max_EMG_list = zeros(Sk(2), S(2));
    %figure(plot Pall Data(the figure from -25% to 105%));
    for m = 1:Sk(2)%EMG_num loop 
       %plot data in 12 figures
       figure(f_stack)
       switch Tar
           case 'EMG'
               subplot(ceil(subN/4),4,m) %plot data in one figure   
           case 'Synergy'
               subplot(ceil(subN/2),2,m) %plot data in one figure   
       end
       hold on
       c = jet(S(2)); %?
       for d = 1:S(2)%file=num loop
          switch pColor
              case 'K'
                 try
                     plot(Pall.x,Pall.plotData_sel{d,1}{m,1},'k','LineWidth',LineW);
                     max_value = max(Pall.plotData_sel{d,1}{m,1});
                 catch
                     plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'k','LineWidth',LineW);
                     max_value = max(Pall.plotData_sel{d,1}(m,:));
                 end
              case 'C'
                 try
%                     plot(Pall.x,Pall.plotData_sel{d,1}{m,1},'Color',Csp(find(PostDays==AllDaysN(d)),:),'LineWidth',LineW);
                     plot(Pall.x,Pall.plotData_sel{d,1}{m,1},'Color',Csp(d,:),'LineWidth',LineW);
                     max_value = max(Pall.plotData_sel{d,1}{m,1});
                 catch
%                     plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'Color',Csp(find(PostDays==AllDaysN(d)),:),'LineWidth',LineW);
                     plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'Color',Csp(d,:),'LineWidth',LineW);
                     max_value = max(Pall.plotData_sel{d,1}(m,:));
                 end
          end
          max_EMG_list(m, d) = max_value;
       end

       if nomalizeAmp == 1
          ylim([0 1]);
       else
          ylim([0 YL]);
       end
       xlim([-25 105]); %narrow the range by following 'plotWindow'
       xline(0,'color','b','LineWidth',LineW)
       xline(100,'color','b','LineWidth',LineW)
       xlabel('task range[%]')
       if nomalizeAmp == 0
           ylabel('Amplitude[uV]')
       end       
       switch Tar
           case 'EMG'
               title(EMGs{m}, 'FontSize', 20)
           case 'Synergy'
               title(['Synergy' num2str(m)], 'FontSize', 20)
       end

       if pColor=='K'
          figure(f_std)  
          switch Tar
              case 'EMG'
                  subplot(ceil(subN/4),4,m) %plot data in one figure   
              case 'Synergy'
                  subplot(ceil(subN/2),2,m) %plot data in one figure   
          end
          sd = Pall.SD{m};
          y = Pall.AVE{m};
          xconf = [Pall.x Pall.x(end:-1:1)];
          yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
          hold on;
          fi = fill(xconf,yconf,'k');
          fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
          fi.EdgeColor = 'none';            % remove the line around the filled area
          plot(Pall.x,y,'k','LineWidth',LineW);
          xline(0,'color','b','LineWidth',LineW)
          xline(100,'color','b','LineWidth',LineW)
          xlim([-25 105]); %narrow the range by following 'plotWindow'
          xlabel('task range[%]')
          if nomalizeAmp == 0
              ylabel('Amplitude[uV]')
          end
          % title
          switch Tar
              case 'EMG'
                  title(EMGs{m}, 'FontSize', 20)
              case 'Synergy'
                  title(['Synergy' num2str(m)], 'FontSize', 20)
          end
          hold off;
          sgtitle(['Average ' Tar ' in task(from' num2str(AllDays{1}) 'to' num2str(AllDays{end}) '-' num2str(length(AllDays)) ')'], 'FontSize', 25)
       end
    end
    % save figures
    switch nomalizeAmp
        case 0
            nomalize_str = '';
        case 1
            nomalize_str = '_nomalirzed';
    end
    figure(f_stack)
    sgtitle(['Stack ' Tar ' in task(from' num2str(AllDays{1}) 'to' num2str(AllDays{end}) '-' num2str(length(AllDays)) ')'], 'FontSize', 25)    
    saveas(gcf, ['All_' Tar '(whole task)_stack' nomalize_str '.fig'])
    saveas(gcf, ['All_' Tar '(whole task)_stack' nomalize_str '.png'])
    if strcmp(pColor, 'K')
        figure(f_std)
        saveas(gcf, ['All_' Tar '(whole task)_std.fig'])
        saveas(gcf, ['All_' Tar '(whole task)_std.png'])
    end
    close all;

    % 
    if plot_max_EMG_value
        [muscle_num, day_num] = size(max_EMG_list);
        disp('please select Elapsed day file (P-DATA(TTakei-filter)/Combined_Data)')
        [file_name, path_name] = uigetfile();
        load(fullfile(path_name, file_name), 'combined_data_list')
        x = combined_data_list(2, :);
        post_flag = 0;
        if length(x) ~= day_num 
            used_data = combined_data_list(:, find(x>0));
            x = used_data(2, :);
            post_flag = 1;
        end
        figure("position", [100, 100, 1200, 800]);
        hold on;
        for ii = 1:muscle_num
            subplot(3,4, ii);
            plot(x, max_EMG_list(ii, :), LineWidth=1.2)
            % decoration
            xlabel('Elapsed day(criterion=surgery)', FontSize=12)
            ylabel('max amplitude[μV]', FontSize=12)
            title(EMGs{ii,1}, FontSize=15);
            ylim([0 inf]);
            switch post_flag
                case 0
                    xlim([x(1) inf]);
                case 1
                    xlim([0 inf]);
            end
        end
        % save figure
        saveas(gcf, 'max_amplitude_fig.fig')
        saveas(gcf, 'max_amplitude_fig.png')
        close all;
    end

    %% plot EMG(or Synergy) which is aligned in each timing(timing1~timing4)
    % decide the number of figure
    figure_num = ceil(subN/4); %plot 4 muscle's EMG   
    % Plots EMG of 4 muscles(or Synergies) per figure.

    % Create a struct array for figure to plot
    figure_str = struct;
    switch plot_figure_type
        case 'default'
            for ii = 1:figure_num
                eval(['figure_str.fig' num2str(ii) ' = figure("position", [100, 100, 1000, 1000])'])
                if strcmp(pColor, 'K') % prepare for the figure of mean+-std
                    eval(['figure_str.fig' num2str(ii) '_SD = figure("position", [100, 100, 1000, 1000])'])
                end
            end
        case 'forHara'
            figure_str.fig1 = figure("position", [100, 100, 1000, 1000]);
    end
    
    % if Yachimun
    timing_name_list = ["Lever1 on ", "Lever1 off ", "Lever2 on ", "Lever2 off"];
    
    for ii = 1:4 % timing_num
        timing_num = ii;
        timing_name = timing_name_list(timing_num);
        if or(ii==1, ii==4)
            Pdata = Pall; % Data(EMG or Synergy) to be plotted
        else
            Pdata = eval(['Ptrig' num2str(ii)]);
        end
        plotWindow = eval(['plotWindow' num2str(ii)]); % plotWindow at specified timing
        
        % collect data used for analysis into 'data_str' (struct array) 
        data_str = struct;
        variable_list = who;
        switch pColor
            case 'C'
                % sample.a = eval('a')
                use_variable_list = {'figure_str', 'timing_num', 'timing_name', 'Sk', 'S', 'pColor', 'Pdata', 'LineW', 'nomalizeAmp', 'YL','plotWindow', 'EMGs', 'Tar', 'Csp', 'PostDays', 'AllDaysN'};
                for ii = 1:length(variable_list)
                    if any(strcmp(use_variable_list, variable_list{ii}))
                        %(ex.) data_str.AllDays = eval("AllDays")
                        eval(['data_str.' variable_list{ii} ' = eval("' variable_list{ii} '");'])
                    end
                end
                plot_timing_figures(figure_str, data_str)
            case 'K'
                use_variable_list = {'figure_str', 'timing_num', 'timing_name', 'Sk', 'S', 'pColor', 'Pdata', 'LineW', 'nomalizeAmp', 'YL','plotWindow', 'EMGs', 'Tar'};
                for ii = 1:length(variable_list)
                    if any(strcmp(use_variable_list, variable_list{ii}))
                        %(ex.) data_str.AllDays = eval("AllDays")
                        eval(['data_str.' variable_list{ii} ' = eval("' variable_list{ii} '");'])
                    end
                end
                switch plot_figure_type
                    case 'default'
                        plot_timing_figures(figure_str, data_str)
                    case 'forHara'
                        %define_color_map(manual)
                        color_map_str = struct();
                        cmap = colormap(jet(12)); % FCU,FDSdist,FDSprox
                        switch realname
                            case 'Yachimun'
                                if eliminate_muscles
                                    for ii = 1:length(EMGs)
                                        if contains(EMGs{ii,1}, 'dist')
                                            EMGs{ii,1} = strrep(EMGs{ii,1}, 'dist', '');
                                        end
                                    end
                                    data_str.EMGs = EMGs;
                                end
                                eliminated_muscles_list = {'FDSprox', 'EDCprox'};
                            case 'SesekiL'
                                for ii = 1:length(EMGs)
                                    EMGs{ii,1} = strrep(EMGs{ii,1}, '_L', '');
                                end
                                data_str.EMGs = EMGs;
                                eliminated_muscles_list = {'FDS', 'FCU', 'FCR'};
                        end
                        for ii = 1:12
                            if and(any(strcmp(EMGs{ii,1}, eliminated_muscles_list)), eliminate_muscles == 1)
                                continue
                            end
                            eval(['color_map_str.' EMGs{ii,1} ' = cmap(' num2str(ii) ',:);'])
                        end
                        plot_timing_figures2(figure_str, data_str, color_map_str)
                end
        end
    end

    % save figure
    switch plot_figure_type
        case 'default'
            switch pColor
                case 'K'
                    added_info = 'monochrome';
                case 'C'
                    added_info = 'color';
            end
            for ii = 1:figure_num
                eval(['figure(figure_str.fig' num2str(ii) ')'])
                saveas(gcf, ['each_timing_stack_' num2str(ii) '_' added_info nomalize_str '.fig'])
                saveas(gcf, ['each_timing_stack_' num2str(ii) '_' added_info nomalize_str '.png'])
                if strcmp(pColor, 'K') % prepare for the figure of mean+-std
                    eval(['figure(figure_str.fig' num2str(ii) '_SD)'])
                    saveas(gcf, ['each_timing_stack_' num2str(ii) '_' added_info nomalize_str '_std.fig'])
                    saveas(gcf, ['each_timing_stack_' num2str(ii) '_' added_info nomalize_str '_std.png'])
                end
            end
        case 'forHara'
            saveas(gcf, 'stack_figure_forHara.fig')
            saveas(gcf, 'stack_figure_forHara.png')
    end
    close all;
    % save data
    save('alignedEMG_data.mat', 'Pall', 'Ptrig2', "Ptrig3")
end

cd ../../../
if save_xcorr_data == 1
    save_fold = 'easyData/P-DATA(old filter TTakei delayed)/'; % location of the file saved
    AllTAVE = Pall.AllT_AVE;
    plotData_sel = Pall.plotData_sel;
    if not(exist(fullfile(pwd, save_fold)))
        mkdir(save_fold)
    end
    switch Tar
        case 'EMG'
            save([save_fold 'AllDataforXcorr_' num2str(length(Allfiles)) '_' num2str(subN) 'EMG.mat'],'Allfiles','AllTAVE','realname','taskRange','plotData_sel')
            save([save_fold 'DataSetforEachXcorr_' num2str(length(Allfiles)) '_' num2str(subN) 'EMG.mat'],'Allfiles','plotWindow1','plotWindow2','plotWindow3','plotWindow4','realname','TrigData_Each')
        case 'Synergy'
            save([save_fold 'AllDataforXcorr_' num2str(length(Allfiles)) '_' num2str(subN) 'syn.mat'],'Allfiles','AllTAVE','realname','taskRange','plotData_sel')
            save([save_fold 'DataSetforEachXcorr_' num2str(length(Allfiles)) '_' num2str(subN) 'syn.mat'],'Allfiles','plotWindow1','plotWindow2','plotWindow3','plotWindow4','realname','TrigData_Each')
    end
end

%% define local function
function [ref_Ptrig, Sk] = resampleEachtiming(Tar, Allfiles_S, ref_Ptrig, ref_timing, nomalizeAmp, load_dir, monkeyname, AllDays)
% load around each timing aligned data(pre:50%, post:50%) & resample & store Ptrig?.plotData_sel
% ref_Ptrig: (ex.)Ptrig2, ref_timing: (ex.) 2
    file_num = length(Allfiles_S);
    for j = 1: file_num%file=num loop
        switch Tar
        case {'EMG','EMG_NDfilt'}
            load(Allfiles_S{j},'ResAVE');
        case 'Synergy'
            cd ../../
            load([load_dir monkeyname AllDays{j} '_Pdata.mat'],'ResAVE');
            cd 'easyData/P-DATA'
        case 'Synfixed'
            load([monkeyname 'Synfixed' AllDays{j} '_Pdata.mat'],'ResAVE');
        end
        data = eval(['ResAVE.tData' num2str(ref_timing) '_AVE']);
        Sk = size(data);
        plotData = zeros(Sk(2),ref_Ptrig.AllT_AVE);
        if ref_Ptrig.Tlist(j,1) == ref_Ptrig.AllT_AVE
            for k = 1:Sk(2)%EMG_num loop 
                plotData(k,:) = data{1,k};
            end
        elseif ref_Ptrig.Tlist(j,1)<ref_Ptrig.AllT_AVE 
            for k = 1:Sk(2)%EMG_num loop 
                plotData(k,:) = interpft(data{1,k},ref_Ptrig.AllT_AVE);
            end
        else
            for k = 1:Sk(2)%EMG_num loop 
                plotData(k,:) = resample(data{1,k},ref_Ptrig.AllT_AVE,ref_Ptrig.Tlist(j,1));
            end
        end
        if nomalizeAmp
           for mm = 1:Sk(2)
             plotData(mm,:) = plotData(mm,:)./max(plotData(mm,:));
           end
        end
        ref_Ptrig.plotData_sel{j,1} = plotData;
    end
end

%% make PostDays
function [PostDays] = extract_post_days(PreDays)
    files_struct = dir('*_Pdata.mat');
    file_names = {files_struct.name};
    count = 1;
    for i = 1:numel(file_names)
        match = regexp(file_names{i}, '\d+', 'match'); %extract number part
        if ~ismember(str2double(match{1}), PreDays)
            PostDays(count) = str2double(match{1});
            count = count + 1;
        end
    end
end
%% plot each timing figures
function plot_timing_figures(figure_str, data_str)
    % change center persentage from 100 to 0
    if data_str.timing_num == 4
        data_str.Pdata.x = data_str.Pdata.x-100;
        data_str.plotWindow = data_str.plotWindow-100;
    end
    
    for m = 1:data_str.Sk(2)%EMG_num(or Synergy_num) loop 
       plot_target = ceil(m/4); % figure number to plot
       eval(['figure(figure_str.fig' num2str(plot_target) ')'])
       % define subplot location
       k = m - 4*(plot_target-1) ;
       subplot_location = 4*(k-1) + data_str.timing_num; % if  
       subplot(4, 4, subplot_location);
       FontSize = 5;
       hold on
       for d = 1:data_str.S(2)%file=num loop
          switch data_str.pColor
             case 'C'
                try
                    plot(data_str.Pdata.x,cell2mat(data_str.Pdata.plotData_sel{d,1}(m,:)),'Color',data_str.Csp(d,:),'LineWidth',data_str.LineW);
                catch
                    plot(data_str.Pdata.x,data_str.Pdata.plotData_sel{d,1}(m,:),'Color',data_str.Csp(d,:), 'LineWidth',data_str.LineW);
                end
             case 'K'
                try
                    plot(data_str.Pdata.x,cell2mat(data_str.Pdata.plotData_sel{d,1}(m,:)),'k','LineWidth',data_str.LineW);
                catch
                    plot(data_str.Pdata.x,data_str.Pdata.plotData_sel{d,1}(m,:),'k','LineWidth',data_str.LineW);
                end
          end
       end
       % decoration
       xline(0,'color','r','LineWidth',data_str.LineW)
       hold off
       if data_str.nomalizeAmp == 1
          ylim([0 1]);
       else
          ylim([0 data_str.YL]);
       end
       xlim(data_str.plotWindow);
       xlabel('task range[%]')
       if data_str.nomalizeAmp == 0
           ylabel('Amplitude[uV]')
       end
       switch data_str.Tar
           case 'EMG'
               title([data_str.timing_name data_str.EMGs{m}])
           case 'Synergy'
               title([data_str.timing_name 'Synergy' num2str(m)])
       end
        
       % plot mean+-std
       if data_str.pColor=='K'
          % focus on FigTrigSD
          eval(['figure(figure_str.fig' num2str(plot_target) '_SD)']) %switch the focued figure
          sd = data_str.Pdata.SD{m};
          y = data_str.Pdata.AVE{m};
          xconf = [data_str.Pdata.x data_str.Pdata.x(end:-1:1)];
          yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
%                 fsd = subplot(subN,4,4*(m-1)+1);
          subplot(4, 4, subplot_location);
          FontSize = 5;
          hold on;
          fi = fill(xconf,yconf,'k');
          fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
          fi.EdgeColor = 'none';            % remove the line around the filled area
          plot(data_str.Pdata.x,y,'k','LineWidth',data_str.LineW);
          % decoration
          xline(0,'color','r','LineWidth',data_str.LineW)
          xlabel('task range[%]')
          hold off;
          if data_str.nomalizeAmp == 1
             ylim([0 1]);
          else
             ylim([0 data_str.YL]);
             ylabel('Amplitude[uV]')
          end
          xlim(data_str.plotWindow); 
          % title
          switch data_str.Tar
            case 'EMG'
                title([data_str.timing_name data_str.EMGs{m}])
            case 'Synergy'
                title([data_str.timing_name 'Synergy' num2str(m)])
          end
       end
    end
end

%% plot all EMG per each timing subplot
function plot_timing_figures2(figure_str, data_str, colormap_str)
    % change center persentage from 100 to 0
    if data_str.timing_num == 4
        data_str.Pdata.x = data_str.Pdata.x-100;
        data_str.plotWindow = data_str.plotWindow-100;
    end

    figure(figure_str.fig1)
    plot_data = data_str.Pdata.plotData_sel{1};
   % define subplot location
   subplot(2, 2, data_str.timing_num);
   FontSize = 5;
   hold on
    for m = 1:data_str.Sk(2)%EMG_num(or Synergy_num) loop 
       try
            ref_data = plot_data{m};
       catch
           ref_data = plot_data(m,:);
       end
       try
            color = eval(['colormap_str.' data_str.EMGs{m,1}]);
       catch
           continue; %
       end
       plot(data_str.Pdata.x,ref_data, 'Color', color, 'LineWidth',data_str.LineW, 'DisplayName',data_str.EMGs{m, 1});
       % insert text into the figure
       % serch for the range of window
       x = data_str.Pdata.x;
       plotWindow = data_str.plotWindow;
       min_index = find(x>=plotWindow(1), 1);
       max_index = find(x>=plotWindow(2), 1)-1;
       max_value = max(ref_data(min_index:max_index));
       ref_index = find(ref_data==max_value);
%        text(x(ref_index)-1, ref_data(ref_index), data_str.EMGs{m, 1}, 'Color',color, 'FontSize', 15);
       % decoration
       if m==data_str.Sk(2)
           xline(0,'color','r','LineWidth',data_str.LineW)
           hold off
           if data_str.nomalizeAmp == 1
              ylim([0 1]);
           else
              ylim([0 data_str.YL]);
           end
           xlim(data_str.plotWindow);
           xlabel('task range[%]')
           if data_str.nomalizeAmp == 0
               ylabel('Amplitude[uV]' )
           end
           title([data_str.timing_name], 'FontSize',20)
       end
    end
    % decoration
    lgd = legend();
    set(lgd, 'FontSize',8);
    lgd.String = lgd.String(~strcmp(lgd.String, 'data1'));
end