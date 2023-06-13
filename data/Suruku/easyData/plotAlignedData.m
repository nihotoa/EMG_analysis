%% settings
monkeyname = 'Su' ; 
real_name = 'Suruku';
xpdate = '200106'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %

cd([monkeyname xpdate])
load([monkeyname '_alignedData_TTakei.mat'],'alignedData','alignedDataAVE')
%% plot
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