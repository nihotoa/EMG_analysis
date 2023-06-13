S1  = load('C:\data\tcohtrig\AobaT00201\control_combine\070123\Non-filtered-subsample__FDPr-subsample_070123_256_128pts_t2s.mat');
S2  = load('C:\data\tcohtrig\AobaT00203\control\070123\Non-filtered-subsample__FDPr-subsample_070123_256_128pts_t2s.mat');
S3  = load('C:\data\tcohtrig\AobaT00301\control\070123\Non-filtered-subsample__FDPr-subsample_070123_256_128pts_t2s.mat');
SS1  = load('C:\data\tcohtrig\AobaT00201\control_combine\070625\Non-filtered-subsample-SR500Hz__FDPr-subsample-SR500Hz_070625_512_128pts_t2s.mat');
SS2  = load('C:\data\tcohtrig\AobaT00203\control\070625\Non-filtered-subsample-SR500Hz__FDPr-subsample-SR500Hz_070625_512_128pts_t2s.mat');
SS3  = load('C:\data\tcohtrig\AobaT00301\control\070625\Non-filtered-subsample-SR500Hz__FDPr-subsample-SR500Hz_070625_512_128pts_t2s.mat');

figure
freq    = S1.EndHold.compiled.f(:,1);
freqSS  = SS1.EndHold.compiled.f(:,1);
xlim    = [10 55];
xlimSS  = [10 250];

h   = subplot(4,3,1);
plot(h,freq,S1.EndHold.compiled.f(:,2),'-k','LineWidth',0.75);
set(h, 'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlim,...
    'XTickLabelMode', 'Auto')
axis('square')

h   = subplot(4,3,2);
plot(h,freq,S2.EndHold.compiled.f(:,2),'-k','LineWidth',0.75);
set(h, 'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlim,...
    'XTickLabelMode', 'Auto')
axis('square')

h   = subplot(4,3,3);
plot(h,freq,S3.EndHold.compiled.f(:,2),'-k','LineWidth',0.75);
set(h, 'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlim,...
    'XTickLabelMode', 'Auto')
axis('square')

h   = subplot(4,3,4);
plot(h,freq,S1.EndHold.compiled.f(:,3),'-k','LineWidth',0.75);
set(h, 'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlim,...
    'XTickLabelMode', 'Auto')
axis('square')

h   = subplot(4,3,5);
plot(h,freq,S2.EndHold.compiled.f(:,3),'-k','LineWidth',0.75);
set(h, 'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlim,...
    'XTickLabelMode', 'Auto')
axis('square')

h   = subplot(4,3,6);
plot(h,freq,S3.EndHold.compiled.f(:,3),'-k','LineWidth',0.75);
set(h, 'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlim,...
    'XTickLabelMode', 'Auto')
axis('square')


h   = subplot(4,3,7);
coh = S1.EndHold.compiled.f(:,4);
cl  = S1.EndHold.compiled.cl.ch_c95;
sig = coh > cl;

plot(h,freq,coh,'-k','LineWidth',0.75);
hold(h,'on')
plot(h,freq(sig),coh(sig),'ok','MarkerFaceColor','k','MarkerSize',3);
line(xlim,ones(1,2) * cl,'Parent',h,'Color','k')
set(h,   'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlim,...
    'XTickLabelMode', 'Auto')
hold(h,'off')
axis('square')

h   = subplot(4,3,8);
coh = S2.EndHold.compiled.f(:,4);
cl  = S2.EndHold.compiled.cl.ch_c95;
sig = coh > cl;

plot(h,freq,coh,'-k','LineWidth',0.75);
hold(h,'on')
plot(h,freq(sig),coh(sig),'ok','MarkerFaceColor','k','MarkerSize',3);
line(xlim,ones(1,2) * cl,'Parent',h,'Color','k')
set(h,   'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlim,...
    'XTickLabelMode', 'Auto')
hold(h,'off')
axis('square')

h   = subplot(4,3,9);
coh = S3.EndHold.compiled.f(:,4);
cl  = S3.EndHold.compiled.cl.ch_c95;
sig = coh > cl;

plot(h,freq,coh,'-k','LineWidth',0.75);
hold(h,'on')
plot(h,freq(sig),coh(sig),'ok','MarkerFaceColor','k','MarkerSize',3);
line(xlim,ones(1,2) * cl,'Parent',h,'Color','k')
set(h,   'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlim,...
    'XTickLabelMode', 'Auto')
hold(h,'off')
axis('square')


h   = subplot(4,3,10);
coh = SS1.EndHold.compiled.f(:,4);
cl  = SS1.EndHold.compiled.cl.ch_c95;
sig = coh > cl;

plot(h,freqSS,coh,'-k','LineWidth',0.75);
hold(h,'on')
plot(h,freqSS(sig),coh(sig),'ok','MarkerFaceColor','k','MarkerSize',3);
line(xlimSS,ones(1,2) * cl,'Parent',h,'Color','k')
set(h,   'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlimSS,...
    'XTickLabelMode', 'Auto')
hold(h,'off')
axis('square')

h   = subplot(4,3,11);
coh = SS2.EndHold.compiled.f(:,4);
cl  = SS2.EndHold.compiled.cl.ch_c95;
sig = coh > cl;

plot(h,freqSS,coh,'-k','LineWidth',0.75);
hold(h,'on')
plot(h,freqSS(sig),coh(sig),'ok','MarkerFaceColor','k','MarkerSize',3);
line(xlimSS,ones(1,2) * cl,'Parent',h,'Color','k')
set(h,   'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlimSS,...
    'XTickLabelMode', 'Auto')
hold(h,'off')
axis('square')

h   = subplot(4,3,12);
coh = SS3.EndHold.compiled.f(:,4);
cl  = SS3.EndHold.compiled.cl.ch_c95;
sig = coh > cl;

plot(h,freqSS,coh,'-k','LineWidth',0.75);
hold(h,'on')
plot(h,freqSS(sig),coh(sig),'ok','MarkerFaceColor','k','MarkerSize',3);
line(xlimSS,ones(1,2) * cl,'Parent',h,'Color','k')
set(h,   'Box', 'off',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',xlimSS,...
    'XTickLabelMode', 'Auto')
hold(h,'off')
axis('square')
