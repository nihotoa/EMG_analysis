BB  = open('L:\tkitom\data\cumdens\071210(-hum)\AobaT00203_Grip Offset (success valid)_Non-filtered-subsample-5000Hz(uV)_FDI-rect(uV).mat');
NB  = open('L:\tkitom\data\cumdens\071210(-hum)\T01308_Grip Offset (success valid)_Non-filtered-subsample-5000Hz(uV)_FDI-rect(uV).mat');

TLim    = [-250 250];
NB.t    = NB.t * 1000;
BB.t    = BB.t * 1000;

fig = figure;

h   = subplot(1,2,1,'Parent',fig);
cla(h);hold(h,'on')
plot(h,NB.t,NB.q21,'-k','LineWidth',0.75);
plot(h,[NB.t(1),NB.t(1);NB.t(end),NB.t(end)],[NB.cl.c95,-NB.cl.c95;NB.cl.c95,-NB.cl.c95],'-k');
plot(h,[NB.t(1),NB.t(end)],[0,0],':k');

set(h,   'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'Xlim',TLim,...
    'XTickLabelMode', 'Auto',...
    'YlimMode','Auto')
ylabel(h,'Cumland Density')
xlabel(h,'Lag(ms)')
title(h,['c95=',num2str(NB.cl.c95)]);
axis(h,'square')




h   = subplot(1,2,2,'Parent',fig);
cla(h);hold(h,'on')
plot(h,BB.t,BB.q21,'-k','LineWidth',0.75);
plot(h,[BB.t(1),BB.t(1);BB.t(end),BB.t(end)],[BB.cl.c95,-BB.cl.c95;BB.cl.c95,-BB.cl.c95],'-k');
plot(h,[BB.t(1),BB.t(end)],[0,0],':k');

set(h,   'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'Xlim',TLim,...
    'XTickLabelMode', 'Auto',...
    'YlimMode','Auto')
ylabel(h,'Cumland Density')
xlabel(h,'Lag(ms)')
title(h,['c95=',num2str(BB.cl.c95)]);
axis(h,'square')