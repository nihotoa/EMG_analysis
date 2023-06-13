function drawfig

NB	=   load('L:\tkitom\data\wcohclssig\071106(combine)(-AobaT003)\T02101_Non-filtered-subsample(uV)__FDI-subsample(uV).mat');
BB	=   load('L:\tkitom\data\wcohclssig\071106(combine)(-AobaT003)\AobaT00203_Non-filtered-subsample(uV)__FDPr-subsample(uV).mat');
IndNB1S	=   load('L:\tkitom\MDAdata\Analyses\STA\T02101\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat');
IndNB2S	=   load('L:\tkitom\MDAdata\Analyses\STA\T02102\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat');
IndNB3S	=   load('L:\tkitom\MDAdata\Analyses\STA\T02103\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat');
ThuNB1S	=   load('L:\tkitom\MDAdata\Analyses\STA\T02101\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat');
ThuNB2S	=   load('L:\tkitom\MDAdata\Analyses\STA\T02102\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat');
ThuNB3S	=   load('L:\tkitom\MDAdata\Analyses\STA\T02103\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat');

IndBBS	=   load('L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat');
ThuBBS	=   load('L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat');


FLim    = [0 100];
FTick   = [0:20:100];
TLim    = [-1 1.5];
TTick    = [-1:0.5:1.5];

freq    = NB.freq;
time    = NB.t;
XData   = IndNB1S.XData;

IndNB   = mean([IndNB1S.TrialData;IndNB2S.TrialData;IndNB3S.TrialData],1);
ThuNB   = mean([ThuNB1S.TrialData;ThuNB2S.TrialData;ThuNB3S.TrialData],1);
IndBB   = mean(IndBBS.TrialData,1);
ThuBB   = mean(IndBBS.TrialData,1);

IndNB   = IndNB - mean(IndNB(1:1000));
ThuNB   = ThuNB - mean(ThuNB(1:1000));
IndBB   = IndBB - mean(IndBB(1:1000));
ThuBB   = ThuBB - mean(ThuBB(1:1000));


figure

h   =subplot(4,2,[1,3]);
H   = pcolor(time,freq,NB.cxy);
shading('flat')
set(h,'CLim',[NB.cl.ch_c95,0.15],...
    'TickDir','out',...
    'XLim',TLim,...
    'XTick',TTick,...
    'YLim',FLim,...
    'YTick',FTick);
colormap(tmap2)
colorbar

h   =subplot(4,2,[2,4]);
H   = pcolor(time,freq,BB.cxy);
shading('flat')
set(h,'CLim',[BB.cl.ch_c95,0.15],...
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
