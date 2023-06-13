%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% coded by Naoki Uchida
% last modification : 2019.07.05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [] = plotTarget()
clear
%% DATA LIST

%Pall : Averaged dataset on each session -50:150%(triggered at hold_on1)
%Ptrig1 : Averaged dataset on each session -50:50%(triggered at hold_off1)
%Ptrig2 : Averaged dataset on each session -50:50%(triggered at hold_on2)
%Ptrig3 : Averaged dataset on each session -25:105%(triggered at hold_on1)

realname = 'Suruku';
task = 'standard';
save_fold = 'easyData';
save_fig = 0;               %save figures
pColor = 'K';               %select 'K'(black plot) or 'C'(color plot) 
save_data = 0;              %save cut data for calculating cross-correlation(each session)
save_end_control = 0;       %save cut data for calculating cross-correlation(Pre Data as a control data)
fontS = 5; % 10;                 %font size in figures 
LineW = 1.3; %0.1;                %width of plot line 
CTC = 1;                    %plot Cross Talk 
AVEPre4List = [17 18 19 20];%170516,170517,170524,170526 (same as synergy analysis )
nomalizeAmp = 0;
EachFigPlot = 'on';         %'on':display each muscle in different figures, 'off':use subplot and make one figure

% xlim of each triggered figure
% % plotWindow1 = [-35 5];
% % plotWindow2 = [-20 20];
% % plotWindow3 = [-35 5];
% % plotWindow4 = [95 135];

plotWindow1 = [-35 5];
plotWindow2 = [-20 20];
plotWindow3 = [-35 5];
plotWindow4 = [95 135];

%select \Yachimun\easyData\P-DATA\(monkeyname)yymmdd_Pdata.mat as many as you want to plot 
Allfiles_S = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S,'_Pdata.mat','');
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
TimingPer = zeros(S(2),6);
% Timing.obj1s = zeros(S(2),6);
% Timing.obj1e = zeros(S(2),6);
% Timing.obj2s = zeros(S(2),6);
% Timing.obj2e = zeros(S(2),6);
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
    load(Allfiles_S{i},'AllT','Tp','TIME_W','D'); %AllT:all time
    %AllT
    AllT_AVE = (AllT_AVE*(i-1) + AllT)/i;
    Pall.Tlist(i,1) = AllT;
    %Tp
    Tp2 = [Tp(:,2) Tp(:,2) Tp(:,2) Tp(:,2) Tp(:,2) Tp(:,2)];
    Talt = mean(Tp - Tp2);
    TimingPer(i,:) = Talt./Talt(5);
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
load(Allfiles_S{i},'taskRange');
Pall.plotData_sel = cell(S(2),1);
Ptrig1.plotData_sel = cell(S(2),1);
Ptrig2.plotData_sel = cell(S(2),1);
Ptrig3.plotData_sel = cell(S(2),1);
sec = zeros(3,1);
%%%%%%%%%%%%%%    nomalize data   %%%%%%%%%%%%%%
%%%  ALL  %%%
for j = 1:S(2)%file=num loop
    load(Allfiles_S{j},'alignedDataAVE');
    Sk = size(alignedDataAVE);
    plotData = zeros(Sk(2),Pall.AllT_AVE);
    if Pall.Tlist(j,1) == Pall.AllT_AVE
        for k = 1:Sk(2)%EMG_num loop 
            sec(1,1) = sec(1,1)+1;
            plotData(k,:) = alignedDataAVE{1,k};
        end
    elseif Pall.Tlist(j,1)<Pall.AllT_AVE 
        for k = 1:Sk(2)%EMG_num loop 
            sec(2,1) = sec(2,1)+1;
            plotData(k,:) = interpft(alignedDataAVE{1,k},Pall.AllT_AVE);
        end
    else
        for k = 1:Sk(2)%EMG_num loop 
            sec(3,1) = sec(3,1)+1;
            plotData(k,:) = resample(alignedDataAVE{1,k},Pall.AllT_AVE,Pall.Tlist(j,1));
        end
    end
    if nomalizeAmp
       for mm = 1:Sk(2)          
          plotData(mm,:) = plotData(mm,:)./max(plotData(mm,:));        
       end
    end
    Pall.plotData_sel{j,1} = plotData;
end
%%%  trig obj1 end  %%%
for j = 1:S(2)%file=num loop
    load(Allfiles_S{j},'ResAVE');
    Sk = size(ResAVE.tData1_AVE);
    plotData = zeros(Sk(2),Ptrig1.AllT_AVE);
    if Ptrig1.Tlist(j,1) == Ptrig1.AllT_AVE
        for k = 1:Sk(2)%EMG_num loop 
            sec(1,1) = sec(1,1)+1;
            plotData(k,:) = ResAVE.tData1_AVE{1,k};
        end
    elseif Ptrig1.Tlist(j,1)<Ptrig1.AllT_AVE 
        for k = 1:Sk(2)%EMG_num loop 
            sec(2,1) = sec(2,1)+1;
            plotData(k,:) = interpft(ResAVE.tData1_AVE{1,k},Ptrig1.AllT_AVE);
        end
    else
        for k = 1:Sk(2)%EMG_num loop 
            sec(3,1) = sec(3,1)+1;
            plotData(k,:) = resample(ResAVE.tData1_AVE{1,k},Ptrig1.AllT_AVE,Ptrig1.Tlist(j,1));
        end
    end
    if nomalizeAmp
       for mm = 1:Sk(2)
         plotData(mm,:) = plotData(mm,:)./max(plotData(mm,:));
       end
    end
    Ptrig1.plotData_sel{j,1} = plotData;
end
%%%  trig obj2 start  %%%
for j = 1:S(2)%file=num loop
    load(Allfiles_S{j},'ResAVE');
    Sk = size(ResAVE.tData2_AVE);
    plotData = zeros(Sk(2),Ptrig2.AllT_AVE);
    if Ptrig2.Tlist(j,1) == Ptrig2.AllT_AVE
        for k = 1:Sk(2)%EMG_num loop 
            sec(1,1) = sec(1,1)+1;
            plotData(k,:) = ResAVE.tData2_AVE{1,k};
        end
    elseif Ptrig2.Tlist(j,1)<Ptrig2.AllT_AVE 
        for k = 1:Sk(2)%EMG_num loop 
            sec(2,1) = sec(2,1)+1;
            plotData(k,:) = interpft(ResAVE.tData2_AVE{1,k},Ptrig2.AllT_AVE);
        end
    else
        for k = 1:Sk(2)%EMG_num loop 
            sec(3,1) = sec(3,1)+1;
            plotData(k,:) = resample(ResAVE.tData2_AVE{1,k},Ptrig2.AllT_AVE,Ptrig2.Tlist(j,1));
        end
    end
    if nomalizeAmp
       for mm = 1:Sk(2)
         plotData(mm,:) = plotData(mm,:)./max(plotData(mm,:));
       end
    end
    Ptrig2.plotData_sel{j,1} = plotData;
end
%%%  trig 1task start  %%%
for j = 1:S(2)%file=num loop
    load(Allfiles_S{j},'ResAVE');
    Sk = size(ResAVE.tData3_AVE);
    plotData = zeros(Sk(2),Ptrig3.AllT_AVE);
    if Ptrig3.Tlist(j,1) == Ptrig3.AllT_AVE
        for k = 1:Sk(2)%EMG_num loop 
            sec(1,1) = sec(1,1)+1;
            plotData(k,:) = ResAVE.tData3_AVE{1,k};
        end
    elseif Ptrig3.Tlist(j,1)<Ptrig3.AllT_AVE 
        for k = 1:Sk(2)%EMG_num loop 
            sec(2,1) = sec(2,1)+1;
            plotData(k,:) = interpft(ResAVE.tData3_AVE{1,k},Ptrig3.AllT_AVE);
        end
    else
        for k = 1:Sk(2)%EMG_num loop 
            sec(3,1) = sec(3,1)+1;
            plotData(k,:) = resample(ResAVE.tData3_AVE{1,k},Ptrig3.AllT_AVE,Ptrig3.Tlist(j,1));
        end
    end
    if nomalizeAmp
       for mm = 1:Sk(2)
         plotData(mm,:) = plotData(mm,:)./max(plotData(mm,:));
       end
    end
    Ptrig3.plotData_sel{j,1} = plotData;
end
load(Allfiles_S{1},'EMGs','taskRange');
cd ../

%make data for SD plot
SDdata = cell(S(2),1);
Pall.SD = cell(Sk(2),1);
Pall.AVE = cell(Sk(2),1);
for m = 1:Sk(2)
   for d = 1:S(2)
      SDdata{d} = Pall.plotData_sel{d,1}(m,:);
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
    %make struct data 
    for j = 1:S(2)
    TrigData_Each.T1.data{j} = Pall.plotData_sel{j}(:,cutWin1(1)+1:cutWin1(2));
    TrigData_Each.T2.data{j} = Ptrig1.plotData_sel{j}(:,cutWin2(1)+1:cutWin2(2));
    TrigData_Each.T3.data{j} = Ptrig2.plotData_sel{j}(:,cutWin3(1)+1:cutWin3(2));
    TrigData_Each.T4.data{j} = Pall.plotData_sel{j}(:,cutWin4(1)+1:cutWin4(2));
    end
    %make end-control data (4days)
    if (save_end_control==1 && S(2)>=4)
    TrigData_Each.T1.AVEend4 = (TrigData_Each.T1.data{S(2)} + TrigData_Each.T1.data{S(2)-1} + TrigData_Each.T1.data{S(2)-2} + TrigData_Each.T1.data{S(2)-3})./4;
    TrigData_Each.T2.AVEend4 = (TrigData_Each.T2.data{S(2)} + TrigData_Each.T2.data{S(2)-1} + TrigData_Each.T2.data{S(2)-2} + TrigData_Each.T2.data{S(2)-3})./4;
    TrigData_Each.T3.AVEend4 = (TrigData_Each.T3.data{S(2)} + TrigData_Each.T3.data{S(2)-1} + TrigData_Each.T3.data{S(2)-2} + TrigData_Each.T3.data{S(2)-3})./4;
    TrigData_Each.T4.AVEend4 = (TrigData_Each.T4.data{S(2)} + TrigData_Each.T4.data{S(2)-1} + TrigData_Each.T4.data{S(2)-2} + TrigData_Each.T4.data{S(2)-3})./4;
      if S(2)==81
         TrigData_Each.T1.AVEPre4 = (TrigData_Each.T1.data{AVEPre4List(1)} + TrigData_Each.T1.data{AVEPre4List(2)} + TrigData_Each.T1.data{AVEPre4List(3)} + TrigData_Each.T1.data{AVEPre4List(4)})./4;
         TrigData_Each.T2.AVEPre4 = (TrigData_Each.T2.data{AVEPre4List(1)} + TrigData_Each.T2.data{AVEPre4List(2)} + TrigData_Each.T2.data{AVEPre4List(3)} + TrigData_Each.T2.data{AVEPre4List(4)})./4;
         TrigData_Each.T3.AVEPre4 = (TrigData_Each.T3.data{AVEPre4List(1)} + TrigData_Each.T3.data{AVEPre4List(2)} + TrigData_Each.T3.data{AVEPre4List(3)} + TrigData_Each.T3.data{AVEPre4List(4)})./4;
         TrigData_Each.T4.AVEPre4 = (TrigData_Each.T4.data{AVEPre4List(1)} + TrigData_Each.T4.data{AVEPre4List(2)} + TrigData_Each.T4.data{AVEPre4List(3)} + TrigData_Each.T4.data{AVEPre4List(4)})./4;
         TrigData_Each.AVEPre4List = AVEPre4List;
      end
    end
end

%make alighned data on obj1end and obj2start
% perR1e = [30 30];
% perR2s = [30 30];
% obj1e.RangeN = [sum(perR1e)+1, perR1e(1)/100, perR1e(2)/100];
% obj2s.RangeN = [sum(perR2s)+1, perR2s(1)/100, perR2s(2)/100];
% obj1e.Trig = zeros(S);
% obj2s.Trig = zeros(S);
% obj1e.pData = zeros(obj1e.RangeN);
% for j = 1:S(2)%file=num loop
%     obj1e.Trig(j) = round(TaskT_AVE*(abs(taskRange(1))+TimingPer(j,3)));
%     obj2s.Trig(j) = round(TaskT_AVE*(abs(taskRange(1))+TimingPer(j,4)));
%     obj1e.pData(j,:) = ;
% end
% load([realname 'PostFiles.mat']);
mkdir([ Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end))]);
cd([ Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end))]);
Pall.x = linspace(taskRange(1),taskRange(2),Pall.AllT_AVE);
Ptrig1.x = linspace(-D.Range1(1),D.Range1(2),Ptrig1.AllT_AVE);
Ptrig2.x = linspace(-D.Range2(1),D.Range2(2),Ptrig2.AllT_AVE);
Ptrig3.x = linspace(-D.Range3(1),D.Range3(2),Ptrig3.AllT_AVE);
% c = jet(45);%45days : the number of days after TT 
%%%%%%%%%%%%%%%% PLOT DATA %%%%%%%%%%%%%%%%
Fsub = cell(12,4); % for saving subplot configuration
FsubS = cell(12,4); % for saving subplot configuration (for SD plot)
Fig1Task = figure('Position',[700 720 600 400]);
if pColor=='K'
   Fig1TaskSD = figure('Position',[700 720 600 400]);
end
figure(Fig1Task);
for m = 1:Sk(2)%EMG_num loop 
   switch EachFigPlot
      case 'on'
         figure('Position',[0 720 600 400])         %plot data in 12 figures
      case 'off'
         subplot(3,4,m)                             %plot data in one figure   
   end
   hold on
   c = jet(S(2));
%    c = cool(S(2));
   for d = 1:S(2)%file=num loop
%     plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'Color',c(find(PostFiles{1,:}==Allfiles(d)),:),'LineWidth',LineW);
      switch pColor
         case 'C'
             plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'Color',c(d,:),'LineWidth',LineW);
         case 'K'
             plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'k','LineWidth',LineW);
      end
   end
   plot([0 0],[0 160],'-r','LineWidth',LineW);
   plot([100 100],[0 160],'-r','LineWidth',LineW);
%        title([EMGs{m,1} Allfiles{1,d}],'FontSize',25);
%    plot([0 0],[0 160],'-r');
%    plot([100 100],[0 160],'-r');
   hold off
   if nomalizeAmp == 1
      ylim([0 1]);
   else
      ylim([0 160]);
   end
   xlim([-25 105]);
%    title(EMGs{m,1},'FontSize',fontS);
   if save_fig == 1
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.epsc']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.png']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.fig']);
   end
   if pColor=='K'
      figure(Fig1TaskSD);
      sd = Pall.SD{m};
      y = Pall.AVE{m};
      xconf = [Pall.x Pall.x(end:-1:1)];
      yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
      subplot(3,4,m)
      hold on;
      fi = fill(xconf,yconf,'k');
      fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
      fi.EdgeColor = 'none';            % remove the line around the filled area
      plot(Pall.x,y,'k','LineWidth',LineW);
      plot([0 0],[0 160],'-r','LineWidth',LineW);
      plot([100 100],[0 160],'-r','LineWidth',LineW);
      hold off;
      if nomalizeAmp == 1
         ylim([0 1]);
      else
         ylim([0 160]);
      end
      xlim([-25 105]); 
      figure(Fig1Task);
   end
end
%new aligned plot
% Fsub = cell(12,4); % for saving subplot configuration
FigTrigAll = figure('Position',[0 0 700 1200]);
if pColor=='K'
   FigTrigSD = figure('Position',[0 0 700 1200]);
end
% TRIG1
figure(FigTrigAll);
for m = 1:Sk(2)%EMG_num loop 
   switch EachFigPlot
      case 'on'
         Fsub{m,1} = figure('Position',[0 720 600 400]);
      case 'off'
         f = subplot(12,4,4*(m-1)+1);
         f.FontSize = 5;
   end
   hold on
   c = jet(S(2));
%    c = cool(S(2));
   for d = 1:S(2)%file=num loop
%     plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'Color',c(find(PostFiles{1,:}==Allfiles(d)),:),'LineWidth',LineW);
      switch pColor
         case 'C'
            plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'Color',c(d,:),'LineWidth',LineW);
         case 'K'
            plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'k','LineWidth',LineW);
      end
   end
   plot([0 0],[0 160],'-r','LineWidth',LineW);
%    plot([100 100],[0 160],'-r','LineWidth',LineW);

%        title([EMGs{m,1} Allfiles{1,d}],'FontSize',25);
%    plot([0 0],[0 160],'-r','LineWidth',LineW);
%    plot([100 100],[0 160],'-r','LineWidth',LineW);
   hold off
   if nomalizeAmp == 1
      ylim([0 1]);
   else
      ylim([0 160]);
   end
   xlim(plotWindow1);
%    title(EMGs{m,1},'FontSize',fontS);
   if save_fig == 1
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.epsc']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.png']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.fig']);
   end
   if pColor=='K'
      figure(FigTrigSD);
      sd = Pall.SD{m};
      y = Pall.AVE{m};
      xconf = [Pall.x Pall.x(end:-1:1)];
      yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
      switch EachFigPlot
         case 'on'
            FsubS{m,1} = figure('Position',[0 720 600 400]);
         case 'off'
            fsd = subplot(12,4,4*(m-1)+1);
            fsd.FontSize = 5;
      end
      hold on;
      fi = fill(xconf,yconf,'k');
      fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
      fi.EdgeColor = 'none';            % remove the line around the filled area
      plot(Pall.x,y,'k','LineWidth',LineW);
      plot([0 0],[0 160],'-r','LineWidth',LineW);
      plot([100 100],[0 160],'-r','LineWidth',LineW);
      hold off;
      if nomalizeAmp == 1
         ylim([0 1]);
      else
         ylim([0 160]);
      end
      xlim(plotWindow1); 
      figure(FigTrigAll);
   end
end
% TRIG2
for m = 1:Sk(2)%EMG_num loop 
   switch EachFigPlot
      case 'on'
         Fsub{m,2} = figure('Position',[600 720 600 400]);
      case 'off'
         f = subplot(12,4,4*(m-1)+2);
         f.FontSize = 5;
   end
   hold on
   c = jet(S(2));
%    c = cool(S(2));
   for d = 1:S(2)%file=num loop
%     plot(Ptrig1.x,Ptrig1.plotData_sel{d,1}(m,:),'Color',c(find(PostFiles{1,:}==Allfiles(d)),:),'LineWidth',LineW);
      switch pColor
         case 'C'
             plot(Ptrig1.x,Ptrig1.plotData_sel{d,1}(m,:),'Color',c(d,:),'LineWidth',LineW);
         case 'K'
             plot(Ptrig1.x,Ptrig1.plotData_sel{d,1}(m,:),'k','LineWidth',LineW);
      end
       plot([0 0],[0 160],'-r','LineWidth',LineW);
%        plot([100 100],[0 160],'-r','LineWidth',LineW);
%        title([EMGs{m,1} Allfiles{1,d}],'FontSize',fontS);
   end
%    plot([0 0],[0 160],'-r');
%    plot([100 100],[0 160],'-r');
   hold off
   if nomalizeAmp == 1
      ylim([0 1]);
   else
      ylim([0 160]);
   end
%    xlim([-D.Range1(1) D.Range1(2)]);
   xlim(plotWindow2)
%    title(EMGs{m,1},'FontSize',fontS);
   if save_fig == 1
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_Trig1_' sprintf('%d',S(end)) '.epsc']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_Trig1_' sprintf('%d',S(end)) '.png']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_Trig1_' sprintf('%d',S(end)) '.fig']);
   end
   if pColor=='K'
      figure(FigTrigSD);
      sd = Ptrig1.SD{m};
      y = Ptrig1.AVE{m};
      xconf = [Ptrig1.x Ptrig1.x(end:-1:1)];
      yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
      switch EachFigPlot
         case 'on'
            FsubS{m,2} = figure('Position',[600 720 600 400]);
         case 'off'
            fsd = subplot(12,4,4*(m-1)+2);
            fsd.FontSize = 5;
      end
      hold on;
      fi = fill(xconf,yconf,'k');
      fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
      fi.EdgeColor = 'none';            % remove the line around the filled area
      plot(Ptrig1.x,y,'k','LineWidth',LineW);
      plot([0 0],[0 160],'-r','LineWidth',LineW);
      plot([100 100],[0 160],'-r','LineWidth',LineW);
      hold off;
      if nomalizeAmp == 1
         ylim([0 1]);
      else
         ylim([0 160]);
      end
      xlim(plotWindow2); 
      figure(FigTrigAll);
   end
end
% TRIG3
for m = 1:Sk(2)%EMG_num loop 
   switch EachFigPlot
      case 'on'
         Fsub{m,3} = figure('Position',[1200 720 600 400]);
      case 'off'
         f = subplot(12,4,4*(m-1)+3);
         f.FontSize = 5;
   end
   hold on
   c = jet(S(2));
%    c = cool(S(2));
   for d = 1:S(2)%file=num loop
%     plot(Ptrig2.x,Ptrig2.plotData_sel{d,1}(m,:),'Color',c(find(PostFiles{1,:}==Allfiles(d)),:),'LineWidth',LineW);
      switch pColor
         case 'C'
             plot(Ptrig2.x,Ptrig2.plotData_sel{d,1}(m,:),'Color',c(d,:),'LineWidth',LineW);
         case 'K'
             plot(Ptrig2.x,Ptrig2.plotData_sel{d,1}(m,:),'k','LineWidth',LineW);
      end
       plot([0 0],[0 160],'-r','LineWidth',LineW);
%        plot([100 100],[0 160],'-r','LineWidth',LineW);
%        title([EMGs{m,1} Allfiles{1,d}],'FontSize',fontS);
   end
%    plot([0 0],[0 160],'-r');
%    plot([100 100],[0 160],'-r');
   hold off
   if nomalizeAmp == 1
      ylim([0 1]);
   else
      ylim([0 160]);
   end
%    xlim([-D.Range2(1) D.Range2(2)]);
   xlim(plotWindow3)
%    title(EMGs{m,1},'FontSize',fontS);
   if save_fig == 1
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_Trig2_' sprintf('%d',S(end)) '.epsc']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_Trig2_' sprintf('%d',S(end)) '.png']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_Trig2_' sprintf('%d',S(end)) '.fig']);
   end
   if pColor=='K'
      figure(FigTrigSD);
      sd = Ptrig2.SD{m};
      y = Ptrig2.AVE{m};
      xconf = [Ptrig2.x Ptrig2.x(end:-1:1)];
      yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
      switch EachFigPlot
         case 'on'
            FsubS{m,3} = figure('Position',[1200 720 600 400]);
         case 'off'
            fsd = subplot(12,4,4*(m-1)+3);
            fsd.FontSize = 5;
      end
      hold on;
      fi = fill(xconf,yconf,'k');
      fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
      fi.EdgeColor = 'none';            % remove the line around the filled area
      plot(Ptrig2.x,y,'k','LineWidth',LineW);
      findpeaks(y);
      plot([0 0],[0 160],'-r','LineWidth',LineW);
      plot([100 100],[0 160],'-r','LineWidth',LineW);
      hold off;
      if nomalizeAmp == 1
         ylim([0 1]);
      else
         ylim([0 160]);
      end
      xlim(plotWindow3); 
      figure(FigTrigAll);
   end
end
% TRIG4
for m = 1:Sk(2)%EMG_num loop 
   switch EachFigPlot
      case 'on'
         Fsub{m,4} = figure('Position',[0 720 600 400]);
      case 'off'
         f = subplot(12,4,4*(m-1)+4);
         f.FontSize = 5;
   end
   hold on
   c = jet(S(2));
%    c = cool(S(2));
   for d = 1:S(2)%file=num loop
%     plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'Color',c(find(PostFiles{1,:}==Allfiles(d)),:),'LineWidth',LineW);
      switch pColor
         case 'C'
             plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'Color',c(d,:),'LineWidth',LineW);
         case 'K'
             plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'k','LineWidth',LineW);
      end
       plot([0 0],[0 160],'-r','LineWidth',LineW);
       plot([100 100],[0 160],'-r','LineWidth',LineW);
%        title([EMGs{m,1} Allfiles{1,d}],'FontSize',fontS);
   end
%    plot([0 0],[0 160],'-r','LineWidth',LineW);
%    plot([100 100],[0 160],'-r','LineWidth',LineW);
   hold off
   if nomalizeAmp == 1
      ylim([0 1]);
   else
      ylim([0 160]);
   end
   xlim(plotWindow4);
%    title(EMGs{m,1},'FontSize',fontS);
   if save_fig == 1
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.epsc']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.png']);
       saveas(gcf,[EMGs{m,1} '_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.fig']);
   end
   if pColor=='K'
      figure(FigTrigSD);
      sd = Pall.SD{m};
      y = Pall.AVE{m};
      xconf = [Pall.x Pall.x(end:-1:1)];
      yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
      switch EachFigPlot
         case 'on'
            FsubS{m,4} = figure('Position',[0 720 600 400]);
         case 'off'
            fsd = subplot(12,4,4*(m-1)+4);
            fsd.FontSize = 5;
      end
      hold on;
      fi = fill(xconf,yconf,'k');
      fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
      fi.EdgeColor = 'none';            % remove the line around the filled area
      plot(Pall.x,y,'k','LineWidth',LineW);
      plot([0 0],[0 160],'-r','LineWidth',LineW);
      plot([100 100],[0 160],'-r','LineWidth',LineW);
      hold off;
      if nomalizeAmp == 1
         ylim([0 1]);
      else
         ylim([0 160]);
      end
      xlim(plotWindow4); 
      figure(FigTrigAll);
   end
end
% f2.FontSize = 5;
 save_Allfig = 0;
if save_Allfig == 1
    SaveFig(f1,['PreAll_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end))])
    SaveFig(f2,['PreEach_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end))])
%    saveas(f1,['CrossTalk_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.epsc']);
%    saveas(f1,['CrossTalk_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.png']);
%    saveas(f1,['CrossTalk_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.fig']);
%    saveas(f2,['CrossTalk3rd_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.epsc']);
%    saveas(f2,['CrossTalk3rd_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.png']);
%    saveas(f2,['CrossTalk3rd_' Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',S(end)) '.fig']);
end
save_fingerFigs = 0;
if save_fingerFigs == 1
    cd('EachPlot')
    for tt = 1:4
        for mm = 1:Sk(2)
            SaveFig(Fsub{mm,tt},['PlotEachAlignedOnTask_' EMGs{mm,1} 'Aligned_' sprintf('%d',tt)])
        end
    end
    cd ../
end
cd ../../../
% end
%% Get each alighned timing 
% function [] = getTiming(Timing,Tp,i)
% Timing.obj1s(i,:) = mean(Tp - Tp(:,2));
% Timing.obj1s(i,:) = mean(Tp - Tp(:,3));
% end

% function [] = nomalizeData(Allfiles_S,S,dataName)
% for j = 1:S(2)%file=num loop
%      S = load(Allfiles_S{j},dataName);
%     Sk = size(S.alignedDataAVE);
%     plotData = zeros(Sk(2),AllT_AVE);
%     if AllTlist(j,1) == AllT_AVE
%         for k = 1:Sk(2)%EMG_num loop 
%             sec(1,1) = sec(1,1)+1;
%             plotData(k,:) = alignedDataAVE{1,k};
%         end
%     elseif AllTlist(j,1)<AllT_AVE 
%         for k = 1:Sk(2)%EMG_num loop 
%             sec(2,1) = sec(2,1)+1;
%             plotData(k,:) = interpft(alignedDataAVE{1,k},AllT_AVE);
%         end
%     else
%         for k = 1:Sk(2)%EMG_num loop 
%             sec(3,1) = sec(3,1)+1;
%             plotData(k,:) = resample(alignedDataAVE{1,k},AllT_AVE,AllTlist(j,1));
%         end
%     end
%     
%     plotData_sel{j,1} = plotData;
% end
% end