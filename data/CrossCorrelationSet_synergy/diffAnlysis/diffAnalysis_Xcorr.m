%% make data for analysis (load)

% %Ya EDC
% LoadData = load('YaXcorrResults_PREvsPOSTtrials_EMG51days.mat');
% extflx = 'extensor';
% tarEMG = 'EDCdist';

%Se EDC
LoadData = load('SeXcorrResults_PREvsPOSTtrials_EMG.mat');
extflx = 'extensor';
tarEMG = 'EDC';

method = 'interp1'; %interp1, spline, interpft
mvm_point = 5;
stepSize = 1; %1day

% get EMG 
for m = 1:length(selectEMGe)
   if length(selectEMGe{m})==length(tarEMG)
      if selectEMGe{m}==tarEMG
         data = LoadData.resEMGe(m,:);
      end
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
   case 'spline'
      data_every = interp1(days,data,xdays_every,'spline');
end
f1 = figure('Position',[819,882,1126,420]);
subplot(1,2,1)
plot(xdays_every,data_every)

%% smooth
mvData = movmean(data_every,mvm_point);
figure(f1)
subplot(1,2,1)
hold on
plot(xdays_every,mvData)
title([LoadData.name tarEMG 'lever1 off : cross-correlation coefficient'])
xlabel('post days')
ylabel('cross-correlation coefficient')

%% differential
diffData = diff(mvData)/stepSize;
figure(f1)
subplot(1,2,2)
hold on
plot(xdays_every(1:end-1)+0.5,diffData)
title([LoadData.name tarEMG 'lever1 off : 1st differential value'])
xlabel('post days')
ylabel('1st differential value')


