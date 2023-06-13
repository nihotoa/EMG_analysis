function drawfig_wcoh_ave

NB	=   load('avewcoh_narrow_071106(-AobaT003)');
BB	=   load('avewcoh_broad_071106(-AobaT003)');

IndNB	=   load('L:\tkitom\MATLAB\work\avewcoh_Narrow_smoothed Index Torque(N).mat');
ThuNB	=   load('L:\tkitom\MATLAB\work\avewcoh_Narrow_smoothed Thumb Torque(N).mat');
IndBB	=   load('L:\tkitom\MATLAB\work\avewcoh_Broad_smoothed Index Torque(N).mat');
ThuBB	=   load('L:\tkitom\MATLAB\work\avewcoh_Broad_smoothed Thumb Torque(N).mat');


FLim    = [0 100];
FTick   = [0:20:100];
TLim    = [-1 1.5];
TTick    = [-1:0.5:1.5];

freq    = NB.freq;
time    = NB.t;
XData   = IndNB.XData;


IndNB   = IndNB.YData - mean(IndNB.YData(1:1000));
ThuNB   = ThuNB.YData - mean(ThuNB.YData(1:1000));
IndBB   = IndBB.YData - mean(IndBB.YData(1:1000));
ThuBB   = ThuBB.YData - mean(ThuBB.YData(1:1000));


figure

h   =subplot(4,2,[1,3]);
H   = pcolor(time,freq,NB.pcxy);
shading('flat')
set(h,'CLim',[NB.cl,50],...
    'TickDir','out',...
    'XLim',TLim,...
    'XTick',TTick,...
    'YLim',FLim,...
    'YTick',FTick);
colormap(tmap2)
colorbar

h   =subplot(4,2,[2,4]);
H   = pcolor(time,freq,BB.pcxy);
shading('flat')
set(h,'CLim',[BB.cl,50],...
    'TickDir','out',...
    'XLim',TLim,...
    'XTick',TTick,...
    'YLim',FLim,...
    'YTick',FTick);
colormap(tmap2)
colorbar
    
h   =subplot(4,2,5);
plot(XData,IndNB,'-k','LineWidth',1);
set(h,'TickDir','out',...
    'XLim',TLim,...
    'XTick',TTick);
colorbar

h   =subplot(4,2,6);
plot(XData,IndBB,'-k','LineWidth',1);
set(h,'TickDir','out',...
    'XLim',TLim,...
    'XTick',TTick);
colorbar

h   =subplot(4,2,7);
plot(XData,ThuNB,'-k','LineWidth',1);
set(h,'TickDir','out',...
    'XLim',TLim,...
    'XTick',TTick);
colorbar

h   =subplot(4,2,8);
plot(XData,ThuBB,'-k','LineWidth',1);
set(h,'TickDir','out',...
    'XLim',TLim,...
    'XTick',TTick);
colorbar