%% settings
monkeyname = 'Se' ; 
real_name = 'Seseki';
xpdate = '200106'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
arm = [];%'_standard'; %'L';
cd([monkeyname xpdate arm])
load([monkeyname xpdate '_alignedData_TTakei.mat'],'alignedData','alignedDataAVE')
load([monkeyname xpdate '_EasyData.mat'],'AllData_EMG','Tp','EMGs','EMG_Hz')
%% plot(normalized)
f1 = figure;
for s = 1:12
   subplot(3,4,s)
   hold on;
   for t = 1:length(alignedData{s}(:,1))
      plot(alignedData{s}(t,:),'k')
   end
   plot(alignedDataAVE{s},'r')
   hold off;
   ylim([0 100])
   xlim([0 length(alignedData{s}(1,:))])
end
%% plot(normalized)
[filteredData,info] = filtEMG(Monkey,Data,info,FilterSettings,[]);
rangeP = [500 500]; %time range[msec] before and after event timing
event = 3; % the order of target event ex) 3 means 'release lever1'
f2 = figure;
for s = 1:12
   subplot(3,4,s)
   hold on;
   for t = 1:length(Tp)
      plot(AllEMG_Data(...
                        Tp(t,event)-rangeP(1)*EMG_Hz/1000:Tp(t,event)+rangeP(2)*EMG_Hz/1000,s...
                        ))
   end
   plot(alignedDataAVE{s},'r')
   hold off;
   ylim([0 100])
   xlim([0 length(alignedData{s}(1,:))])
end