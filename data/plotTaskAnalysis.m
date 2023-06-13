function plotTaskAnalysis()
%% DATA LIST

%Pall : Averaged dataset on each session -50:150%(triggered at hold_on1)
%Ptrig1 : Averaged dataset on each session -50:50%(triggered at hold_off1)
%Ptrig2 : Averaged dataset on each session -50:50%(triggered at hold_on2)
%Ptrig3 : Averaged dataset on each session -25:105%(triggered at hold_on1)

realname = 'Yachimun';
monkeyname = 'Ya';

% realname = 'SesekiL';
% monkeyname = 'Se';

% realname = 'Wasa';
% monkeyname = 'Wa';

% realname = 'Matatabi';
% monkeyname = 'Ma';

task = 'standard';
saveDAYfig = 'unsave';
saveEMGfig = 'unsave'; % save function for sampleEMGs
Vspace = 2;
LW = 1.2;
sampleEMGselect = 10; %please change here for plotting different sample EMGs (number means which trial will be plotted)
PlotSampleEMG = 1;
PlotTrial = 1;
PlotTrial_save = 0;
cd([realname '/easyData'])

%please select more than one file
[Allfiles_S,path] = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
Allfiles = strrep(Allfiles_S,['_' task '.mat'],'');

%% make dataset about task timing
dayL = length(Allfiles);
sucNums = zeros(dayL,1);
sampleEMGs = cell(dayL,1);
taskTime = cell(dayL,1);
taskRate = cell(dayL,1);
sampleTp3 = cell(dayL,1);
allEMGs = cell(dayL,1);
Tp3select = zeros(dayL,1);
for d = 1:dayL
   [taskTime{d},taskRate{d},sampleEMGs{d},sucNums(d),sampleTp3{d},allEMGs{d},Tp3select(d)] = getTask(Allfiles{d},task,saveDAYfig, PlotSampleEMG,sampleEMGselect);
end
% plot success trials
figure;
plot(sucNums)
title([monkeyname ' successful trials'])
% plot task time
skTm_mean = zeros(dayL,5);
TskTm_std = zeros(dayL,5);
for d = 1:dayL
   TskTm_mean(d,:) = mean(taskTime{d});
   TskTm_std(d,:)  = std(taskTime{d});
   if PlotTrial
      figure; 
      coulumn = 4;
      subplot(coulumn,1,1); plot(taskTime{d}(:,1)./5); xlabel('trials'); ylabel('rest time [msec]');
      subplot(coulumn,1,2); plot(taskTime{d}(:,2)./5); xlabel('trials'); ylabel('object1 hold [msec]');
      subplot(coulumn,1,3); plot(taskTime{d}(:,3)./5); xlabel('trials'); ylabel('moving & pull time [msec]');
      subplot(coulumn,1,4); plot(taskTime{d}(:,4)./5); xlabel('trials'); ylabel('object2 hold [msec]');
%       subplot(coulumn,1,5); plot(taskTime{d}(:,5)./5); xlabel('trials'); ylabel('system time [msec]');
      if PlotTrial_save
      end
      close;
   end
end
figure;
for t = 1:coulumn
   subplot(coulumn,1,t);
%    hold off
   fi = fill([1:1:dayL dayL:-1:1],[TskTm_mean(:,t)-TskTm_std(:,t); TskTm_mean(end:-1:1,t)+TskTm_std(end:-1:1,t)]./5,'k');
   fi.FaceColor = [0.9 0.9 0.9];
   fi.FaceAlpha = 1;
   fi.EdgeColor = 'none'; 
   hold on;
   plot(TskTm_mean(:,t)./5, 'LineWidth',1)
end
%plot sample EMGs
if PlotSampleEMG
   for d = 1:dayL
      figure('Position',[350,285,570,1300]);
      EMGave = max(sampleEMGs{d});
      base = 0:1:length(sampleEMGs{d}(1,:))-1;
      switch monkeyname
         case 'Se'
            base(11:12) = [base(9) base(10)];
            plotsampleEMGs = sampleEMGs{d}./repmat(EMGave,length(sampleEMGs{d}),1) + repmat(base,length(sampleEMGs{d}),1).*Vspace;
            ylim([-Vspace length(base)*Vspace])
            plot(plotsampleEMGs(:,[1 2 3 4 5 6 7 8 11 12]),'k','LineWidth',LW)
         otherwise
            plotsampleEMGs = sampleEMGs{d}./repmat(EMGave,length(sampleEMGs{d}),1) + repmat(base,length(sampleEMGs{d}),1).*Vspace;
            ylim([-Vspace length(base)*Vspace])
            plot(plotsampleEMGs,'k','LineWidth',LW)
      end
      hold on 
      e = 0;
      Ee = zeros(1,length(sampleTp3{d}));
      plot([e e],[-1000 1000],'r','LineWidth',LW)
      for event = 1:length(sampleTp3{d})
         e = e + sampleTp3{d}(event);
         plot([e e],[-1000 1000],'r--','LineWidth',LW)
         Ee(event) = e;
      end
      ylim([-Vspace length(base)*Vspace])
      xlim([Ee(8-1)-2000 Ee(11-1)+1000])
   %    yticks(0:2:2*(length(sampleEMGs{d}(1,:))-1))
   %    yticklabels(allEMGs{d});
   %    xticklabels([]);
      ax = gca;
      ax.FontSize = 20;
      ax.FontName = 'Arial';
      ax.FontWeight = 'bold';
      switch saveEMGfig
          case 'save'
              cd([Allfiles{d} '_' task])
              SaveFig(gcf, [Allfiles{d} '-trial' sprintf('%d',Tp3select(d))],'png')
              ax.Visible = 'off';
              SaveFig(gcf, [Allfiles{d} '-trial' sprintf('%d',Tp3select(d)) '_noaxis'],'png')
              cd ../
          case 'notsave'

      end
   end
end
end
function [T,R,sampleEMGs,sucNum,sampleTp3,EMGs,Tp3select] = getTask(filename,task,savefig,PlotSampleEMG,Tp3select)
cd([filename '_' task])
Data = load([filename '_EasyData.mat'],'AllData_EMG','Tp','Tp3','SampleRate','EMGs');
sucNum = length(Data.Tp(:,1));
EMGs = Data.EMGs;
S = size(Data.Tp);
T = zeros(S(1),S(2)-1);
R = zeros(S(1),S(2)-1);
T(:,1) = Data.Tp(:,2) - Data.Tp(:,1);
T(:,2) = Data.Tp(:,3) - Data.Tp(:,2);
T(:,3) = Data.Tp(:,4) - Data.Tp(:,3);
T(:,4) = Data.Tp(:,5) - Data.Tp(:,4);
T(:,5) = Data.Tp(:,6) - Data.Tp(:,5);
time_w = Data.Tp(:,5) - Data.Tp(:,2);
R(:,1) = (Data.Tp(:,2) - Data.Tp(:,1))./time_w;
R(:,2) = (Data.Tp(:,3) - Data.Tp(:,2))./time_w;
R(:,3) = (Data.Tp(:,4) - Data.Tp(:,3))./time_w;
R(:,4) = (Data.Tp(:,5) - Data.Tp(:,4))./time_w;
R(:,5) = (Data.Tp(:,6) - Data.Tp(:,5))./time_w;
emgNum = length(Data.AllData_EMG(1,:));
sampleEMGs = cell(emgNum,1);
sampleTp3 = zeros(1,S(2)-1);

if ~isempty(Data.Tp3)
   startTpNum = find(Data.Tp(:,1) == Data.Tp3(Tp3select,1));
   altTp3 = [Data.Tp(startTpNum,:) Data.Tp(startTpNum+1,:) Data.Tp(startTpNum+2,:)];
   sampleTp3 = diff(altTp3);
   if PlotSampleEMG
      sampleEMGs = Data.AllData_EMG(Data.Tp3(Tp3select,1):Data.Tp3(Tp3select,end),:);
      filt_h = 20; %cut off frequency [Hz]
      filt_l = 1000; %cut off frequency [Hz]
      downdata_to = 100; %sampling frequency [Hz]
      EMG_num = length(sampleEMGs(1,:));
      for i = 1:EMG_num
          sampleEMGs(:,i) = sampleEMGs(:,i)-mean(sampleEMGs(:,i));
      end

      [B,A] = butter(6, (filt_h .* 2) ./ Data.SampleRate, 'high');
      for i = 1:EMG_num
          sampleEMGs(:,i) = filtfilt(B,A,sampleEMGs(:,i));
      end
   % 
   %    sampleEMGs = abs(sampleEMGs);
   % % 
      [B,A] = butter(6, (filt_l .* 2) ./ Data.SampleRate, 'low');
      for i = 1:EMG_num
          sampleEMGs(:,i) = filtfilt(B,A,sampleEMGs(:,i));
      end
   end
%    sampleEMGs = resample(sampleEMGs,downdata_to,SR);
%    newSR = downdata_to;
%    newTiming = Timing*newSR/SR;
%    filtP = struct('whose','Uchida','Hp',filt_h, 'Rect','on','Lp',filt_l,'down',downdata_to);
end
switch savefig 
   case 'save'
      figure;
      area(T(:,2:4));
      SaveFig(gcf,[filename '_taskTime'],'png')
      figure;
      area(R(:,2:4));
      SaveFig(gcf,[filename '_taskRate'],'png')
      close all
   otherwise
end
cd ../
end
