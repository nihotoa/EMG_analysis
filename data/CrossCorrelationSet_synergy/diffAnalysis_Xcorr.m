clear all
%% make data for analysis (load)

%Ya EDC
trig = 3;
ES = 'EMG';
monkeyname = 'Se';
% extflx   = 'extensor';
extflx   = 'flexor';

switch monkeyname
    case 'Ya'
        switch ES
            case 'EMG'
                LoadData = load(['YaXcorrResults_PREvsPOSTtrials_EMG_trig' sprintf('%d',trig) '.mat']);
                % LoadData = load('YaXcorrResults_PREvsPOSTtrials_EMG51days.mat');
%                 extflx   = 'extensor';
                tarEMG   = 'FDSdist';
            case 'Synergy'
                LoadData = load(['YaXcorrResults_PREvsPOSTtrials_Synergy_trig' sprintf('%d',trig) '.mat']);
%                 extflx   = 'extensor';
%                 extflx   = 'flexor';
        end
    case 'Se'
        switch ES
            case 'EMG'
                %Se EDC
                LoadData = load(['SeXcorrResults_PREvsPOSTtrials_EMG_trig' sprintf('%d',trig) '.mat']);
%                 extflx = 'extensor';
                tarEMG = 'FDP';
            case 'Synergy'
                LoadData = load(['SeXcorrResults_PREvsPOSTtrials_Synergy_trig' sprintf('%d',trig) '.mat']);
                
        end
end
method = 'interp1'; %interp1, spline, interpft

method2   = 'smooth';
filt_l    = 0.08;  %[Hz]
mvm_point = 14; %[point]
thresh    = 1;
stepSize  = 1; %1day
Lw        = 1.5; %LineWidth value for Data plot
Lwsub     = 0.75; %LineWidth value for threshold line

switch ES
    case 'EMG'
        switch extflx
            case 'extensor'
                for m = 1:length(LoadData.selectEMGe)
                   if length(LoadData.selectEMGe{m})==length(tarEMG)
                      if LoadData.selectEMGe{m}==tarEMG
                         data = LoadData.resEMGe(m,:);
                         data_std = LoadData.resEMGe_std(m,:);
                      end
                   end
                end
            case 'flexor'
                for m = 1:length(LoadData.selectEMGf)
                   if length(LoadData.selectEMGf{m})==length(tarEMG)
                      if LoadData.selectEMGf{m}==tarEMG
                         data = LoadData.resEMGf(m,:);
                         data_std = LoadData.resEMGf_std(m,:);
                      end
                   end
                end
        end
    case 'Synergy'
        switch extflx
            case 'extensor'
                 data = LoadData.resSYN(1,:);
                 data_std = LoadData.resSYN_std(1,:);
            case 'flexor'
                 data = LoadData.resSYN(2,:);
                 data_std = LoadData.resSYN_std(2,:);
        end     
end

%make xaxis value
days = LoadData.xpostdays;
xdays_every = days(1):days(end);
days_every = xdays_every - days(1) + 1;

%% make data for analysis (insert data)
switch method
   case 'interp1'
      data_every = interp1(days,data,xdays_every);
      data_every_std = interp1(days,data_std,xdays_every);
   case 'spline'
      data_every = interp1(days,data,xdays_every,'spline');
      data_every_std = interp1(days,data_std,xdays_every,'spline');
end
f1 = figure('Position',[819,882,1126,420]);
subplot(1,2,1)
% fi1 = fill([xdays_every xdays_every(end:-1:1)],[data_every-data_every_std data_every(end:-1:1)+data_every_std(end:-1:1)]);
plot(xdays_every,data_every)

%% smooth
%calc smooth
switch method2
   case 'smooth'
      mvData = movmean(data_every,mvm_point);
      mvData_std = movmean(data_every_std,mvm_point);
   case 'LPF'
      [B,A] = butter(6, (filt_l .* 2) ./ (1/stepSize), 'low');
      mvData = filtfilt(B,A,data_every);
      mvData_std = filtfilt(B,A,data_every_std);
end
figure(f1)
subplot(1,2,1)
hold on
% area plot for standard deviation
fi1 = fill([xdays_every xdays_every(end:-1:1)],[mvData-mvData_std mvData(end:-1:1)+mvData_std(end:-1:1)],'k');
fi1.FaceColor = [1 0 0];       % make the filled area
fi1.FaceAlpha = 0.2;
fi1.EdgeColor = 'none'; 
% average value
plot(xdays_every,mvData,'LineWidth',Lw)
xlim([xdays_every(1) xdays_every(end)])
%labels
switch ES
    case 'EMG'
        title([LoadData.name ' ' tarEMG ' trig' sprintf('%d',trig) ' : cross-correlation coefficient'])
    case 'Synergy'
        title([LoadData.name ' ' extflx ' Synergy trig' sprintf('%d',trig) ' : cross-correlation coefficient'])
end
xlabel('post days')
ylabel('cross-correlation coefficient')

%% differential
%make plot data
diffData = diff(mvData)/stepSize;
xdays_diff = xdays_every(1:end-1)+0.5;
dfD_mean = mean(diffData);
dfD_std = std(diffData);
threData_ux = find(diffData>dfD_mean+dfD_std);%up threshold
threData_u = diffData(threData_ux);
threData_dx = find(diffData<dfD_mean-dfD_std);%down threshold
threData_d = diffData(threData_dx);
%plot
figure(f1)
subplot(1,2,2)
hold on
plot(xdays_diff,diffData,'LineWidth',Lw)
plot([xdays_diff(1) xdays_diff(end)],[0 0],'k')
plot([xdays_diff(1) xdays_diff(end)],[dfD_mean dfD_mean],'r')
plot([xdays_diff(1) xdays_diff(end)],[dfD_mean-dfD_std dfD_mean-dfD_std],'r--')
plot([xdays_diff(1) xdays_diff(end)],[dfD_mean+dfD_std dfD_mean+dfD_std],'r--')
% plot(xdays_diff(threData_ux),threData_u,'ro')
% plot(xdays_diff(threData_dx),threData_d,'ro')
xlim([xdays_every(1) xdays_every(end)])
%label
switch ES
    case 'EMG'
        title([LoadData.name ' ' tarEMG ' trig' sprintf('%d',trig) ' : 1st differential value'])
    case 'Synergy'
        title([LoadData.name ' ' extflx ' Synergy trig' sprintf('%d',trig) ' : 1st differential value'])
end
xlabel('post days')
ylabel('1st differential value')

%% add threshold line
switch LoadData.name
   case 'Yachimun'
       switch ES
           case 'EMG'
               switch tarEMG
                   case 'EDCdist'
                       switch trig
                          case 1
                              zerD = [-2.5, 44.5, 45.5, 63.5]; 
                              stdD = [1.5, 42.5, 46.5, 60.5];
                          case 2
                              zerD = [-9.5, 34.5, 53.5, 84.5]; 
                              stdD = [0.5, 28.5, 59.5, 75.5];
                       end
                   case 'FDSdist'
                       switch trig
                          case 1
                              zerD = [29.5, 44.5, 63.5, 63.5]; 
                              stdD = [36.5, 43.5, 66.5, 83.5];
                          case 2
                              zerD = [-9.5, 36.5, 37.5, 100.5]; 
                              stdD = [1.5, 29.5, 59.5, 72.5];
                       end
               end
           case 'Synergy'
               switch trig
                   case 1
                       switch extflx
                           case 'extensor'
                               zerD = [-2.5, 29.5, 44.5, 61.5]; 
                               stdD = [1.5, 23.5, 45.5, 58.5];
                           case 'flexor'
                               zerD = [36.5, 43.5, 63.5, 81.5]; 
                               stdD = [37.5, 43.5, 67.5, 76.5];
                       end
                   case 2
                       switch extflx
                           case 'extensor'
                               zerD = [-9.5, 35.5, 59.5, 85.5]; 
                               stdD = [1.5, 29.5, 61.5, 80.5];
                           case 'flexor'
                               zerD = [-9.5, 37.5, 47.5, 98.5]; 
                               stdD = [2.5, 30.5, 59.5, 72.5];
                       end
               end
       end
       subplot(1,2,1); a1 = gca; YL1 = a1.YLim; % keep Ylim
       %zero threshold
       plot([zerD(1) zerD(1)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(2) zerD(2)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(3) zerD(3)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(4) zerD(4)],[-1 1],'b','LineWidth',Lwsub);
       %std threshold
       plot([stdD(1) stdD(1)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(2) stdD(2)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(3) stdD(3)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(4) stdD(4)],[-1 1],'g','LineWidth',Lwsub);
       ylim(YL1)
       xlim([-40 xdays_every(end)])
       %plot2
       subplot(1,2,2); a2 = gca; YL2 = a2.YLim; % keep Ylim
       %zero threshold
       plot([zerD(1) zerD(1)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(2) zerD(2)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(3) zerD(3)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(4) zerD(4)],[-1 1],'b','LineWidth',Lwsub);
       %std threshold
       plot([stdD(1) stdD(1)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(2) stdD(2)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(3) stdD(3)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(4) stdD(4)],[-1 1],'g','LineWidth',Lwsub);
       ylim(YL2)
       xlim([-40 xdays_every(end)])
   case 'SesekiL'
       switch ES
           case 'EMG'
               switch tarEMG
                   case 'EDC'
                       switch trig
                          case 3
                              zerD = [6.5, 34.5, 35.5, 61.5]; 
                              stdD = [15.5, 28.5, 39.5, 58.5];
                       end
                   case 'FDP'
                       switch trig
                          case 3
                              zerD = [39.5, 62.5, 15.5, 36.5]; 
                              stdD = [49.5, 56.5, 15.5, 28.5];
                       end
               end
           case 'Synergy'
               switch trig
                   case 3
                       switch extflx
                           case 'extensor'
                               zerD = [-3.5, 29.5, 30.5, 53.5]; 
                               stdD = [15.5, 27.5, 35.5, 52.5];
                           case 'flexor'
                               zerD = [47.5, 47.5, 17.5, 28.5]; 
                               stdD = [50.5, 62.5, 19.5, 27.5];
                       end
               end
       end
      subplot(1,2,1); a1 = gca; YL1 = a1.YLim; % keep Ylim
       %zero threshold
       plot([zerD(1) zerD(1)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(2) zerD(2)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(3) zerD(3)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(4) zerD(4)],[-1 1],'b','LineWidth',Lwsub);
       %std threshold
       plot([stdD(1) stdD(1)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(2) stdD(2)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(3) stdD(3)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(4) stdD(4)],[-1 1],'g','LineWidth',Lwsub);
       ylim(YL1)
%        xlim([-40 xdays_every(end)])
       %plot2
       subplot(1,2,2); a2 = gca; YL2 = a2.YLim; % keep Ylim
       %zero threshold
       plot([zerD(1) zerD(1)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(2) zerD(2)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(3) zerD(3)],[-1 1],'b','LineWidth',Lwsub);plot([zerD(4) zerD(4)],[-1 1],'b','LineWidth',Lwsub);
       %std threshold
       plot([stdD(1) stdD(1)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(2) stdD(2)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(3) stdD(3)],[-1 1],'g','LineWidth',Lwsub);plot([stdD(4) stdD(4)],[-1 1],'g','LineWidth',Lwsub);
       ylim(YL2)
%        xlim([-40 xdays_every(end)])
end