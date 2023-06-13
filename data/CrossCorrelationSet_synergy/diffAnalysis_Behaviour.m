clear all
%% make data for analysis (load)

%Ya EDC
LoadData = load('YAtaxia.mat'); %load('YPull');%load('YTouch'); % 
% LoadData = load('SAtaxia.mat'); %load('SApert');%load('STouch'); % 

% %Se EDC
% LoadData  = load('SeBehaviouralResults.mat');

method1   = 'interp1'; %interp1, spline, interpft
method2   = 'smooth'; %smooth, LPF(low pass filter)
filt_l    = 0.08; %[Hz]
mvm_point = 14; %[point]
thresh    = 1;
stepSize  = 1; %1day
Lw        = 1.5; %LineWidth value for figures
Lwsub     = 0.75; %LineWidth value for figures
%get data
% data = LoadData.behaviouralData;
% data = LoadData.behaviouralDataTouch;
% data = LoadData.behaviouralDataPull;
data = LoadData.behaviouralDataAtaxia;
% data = LoadData.behaviouralDataApert;

%make xaxis value
days        = LoadData.xpostdays;
xdays_every = days(1):days(end);
days_every  = xdays_every - days(1) + 1;

%% make data for analysis (insert data)
switch method1
   case 'interp1'
      data_every = interp1(days,data,xdays_every);
   case 'spline'
      data_every = interp1(days,data,xdays_every,'spline');
end
f1 = figure('Position',[819,882,1126,420]);
subplot(1,2,1)
plot(xdays_every,data_every)

%% smooth
%calc smooth
switch method2
   case 'smooth'
      mvData = movmean(data_every,mvm_point);
   case 'LPF'
      [B,A]  = butter(6, (filt_l .* 2) ./ (1/stepSize), 'low');
      mvData = filtfilt(B,A,data_every);
end
figure(f1)
subplot(1,2,1)
hold on
% average value
plot(xdays_every,mvData,'LineWidth',Lw)
xlim([xdays_every(1) xdays_every(end)])
%labels
title([LoadData.name ' : behavioural time'])
xlabel('post days')
ylabel('behavioural time [msec]')

%% differential
%make plot data
diffData    = diff(mvData)/stepSize;
xdays_diff  = xdays_every(1:end-1)+0.5;
dfD_mean    = mean(diffData);
dfD_std     = std(diffData);
%threshold by 0
zero_ux = find(diffData>0);%up threshold
zero_u  = diffData(zero_ux);
zero_dx = find(diffData<0);%down threshold
zero_d  = diffData(zero_dx);
%threshold by mean value plus/minus standard deviation
threData_ux = find(diffData>dfD_mean+dfD_std);%up threshold
threData_u  = diffData(threData_ux);
threData_dx = find(diffData<dfD_mean-dfD_std);%down threshold
threData_d  = diffData(threData_dx);
%automatically extract peak days and value
[peak_u,peak_ux] = max(threData_u);
[peak_d,peak_dx] = min(threData_d);
% %detect one 'gyrus' contain this peak
% threZero_ux = zeros(1,length(xdays_diff));
% threZero_u  = zeros(1,length(xdays_diff));
% d = 1;
% while zero_ux(find(zero_ux==peak_ux)+d-1)==zero_ux(find(zero_ux==peak_ux))+d-1
%    threZero_ux(d) = zero_ux(find(zero_ux==peak_ux)+d-1);
%    threZero_u(d)  = zero_u(find(zero_ux==peak_ux)+d-1);
% end
% pre_state = 'f';
% for d = 1:length(xdays_diff)
%    switch pre_state
%       case 'f'
%          if find(zero_ux == xdays_diff(d))
%             state = 1;
%             pre_state = 'u';
%          else
%             state = 0;
%             pre_state = 'd';
%          end
%       case 'u'
%          if find(zero_ux == xdays_diff(d))
%             state = 1;
%          else
%             state = 0;
%             if find(threData_dx == xdays_diff(d))
%                
%             end
%          end
%       case 'd'
%          
%    end
% end
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
title([LoadData.name ' : 1st differential value'])
xlabel('post days')
ylabel('1st differential value')






% ADDED BY ROLAND
%% make data for analysis (insert data)
switch method1
   case 'interp1'
      data_every = interp1(xdays_diff,diffData,xdays_every);
   case 'spline'
      data_every = interp1(xdays_diff,diffData,xdays_every,'spline');
end
% f1 = figure('Position',[819,882,1126,420]);
subplot(1,2,2)
% plot(xdays_every,data_every)
%% smooth
%calc smooth
clear mvData B A 
switch method2
   case 'smooth'
      mvData = movmean(data_every,mvm_point);
   case 'LPF'
      [B,A]  = butter(6, (filt_l .* 2) ./ (1/stepSize), 'low');
      mvData = filtfilt(B,A,data_every);
end
figure(f1)
subplot(1,2,2)
hold on
% average value
plot(xdays_every,mvData,'LineWidth',Lw)
xlim([xdays_every(1) xdays_every(end)])
%labels
title([LoadData.name ' : behavioural time'])
xlabel('post days')
ylabel('behavioural time [msec]')




%%
preSTD=std(diffData(1:69))
MEAN=mean(diffData)
plot([xdays_diff(1) xdays_diff(end)],[MEAN-preSTD MEAN-preSTD],'k--')
plot([xdays_diff(1) xdays_diff(end)],[MEAN+preSTD MEAN+preSTD],'k--')

%% identify timining of the curve
% thre_zero = find()
% thre_std  = 
%% add threshold line
switch LoadData.name
   case 'Yachimun'
      %plot1
      subplot(1,2,1); a1 = gca; YL1 = a1.YLim; % keep Ylim
      %zero threshold
      plot([-25.5 -25.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([23.5 23.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([24.5 24.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([47.5 47.5],[-2000 2000],'b','LineWidth',Lwsub)
      %std threshold
      plot([-14.5 -14.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([22.5 22.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([24.5 24.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([42.5 42.5],[-2000 2000],'g','LineWidth',Lwsub)
      ylim(YL1)
      %plot2
      subplot(1,2,2); a2 = gca; YL2 = a2.YLim; % keep Ylim
      %zero threshold
      plot([-25.5 -25.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([23.5 23.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([24.5 24.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([47.5 47.5],[-2000 2000],'b','LineWidth',Lwsub)
      %std threshold
      plot([-14.5 -14.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([22.5 22.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([24.5 24.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([42.5 42.5],[-2000 2000],'g','LineWidth',Lwsub)
      ylim(YL2)
   case 'Seseki'
      %plot1
      subplot(1,2,1); a1 = gca; YL1 = a1.YLim; % keep Ylim
      %zero threshold
      plot([-3.5 -3.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([16.5 16.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([17.5 17.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([54.5 54.5],[-2000 2000],'b','LineWidth',Lwsub)
      %std threshold
      plot([3.5 3.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([16.5 16.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([27.5 27.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([52.5 52.5],[-2000 2000],'g','LineWidth',Lwsub)
      ylim(YL1)
      %plot2
      subplot(1,2,2); a2 = gca; YL2 = a2.YLim; % keep Ylim
      %zero threshold
      plot([-3.5 -3.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([16.5 16.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([17.5 17.5],[-2000 2000],'b','LineWidth',Lwsub)
      plot([54.5 54.5],[-2000 2000],'b','LineWidth',Lwsub)
      %std threshold
      plot([3.5 3.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([16.5 16.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([27.5 27.5],[-2000 2000],'g','LineWidth',Lwsub)
      plot([52.5 52.5],[-2000 2000],'g','LineWidth',Lwsub)
      ylim(YL2)
end