function cohplot
[S,filename]	= topen;
cl  = S.EndHold.compiled.cl.ch_c95;
f10_96  = S.EndHold.compiled.f(:,1) >= 10 & S.EndHold.compiled.f(:,1) <= 96;

freq    = S.EndHold.compiled.f(:,1);

coh     = squeeze(S.EndHold.compiled.f(:,4));
sig     = coh > cl;
phase   = squeeze(S.EndHold.compiled.f(:,5));
uwphase = unwrap(phase);


figure('Name',filename,...
    'NumberTitle','off');

subplot(3,1,1)
plot(freq,coh,'k','Linewidth', 0.5)
line([freq(1) freq(end)],[cl cl],'Color','k');
set(gca, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',[10 100],...
    'YLim',[0 0.5]);

subplot(3,1,2)
pplot(freq(sig & f10_96),phase(sig & f10_96),'b')
set(gca, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',[10 100],...
    'YLim',[-3*pi pi]);

subplot(3,1,3)
plot(freq(sig & f10_96),uwphase(sig & f10_96) ,'ob','MarkerFaceColor','b','MarkerSize',3)
regplot(freq(sig & f10_96),uwphase(sig & f10_96),'-r')
set(gca, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',[10 100]);
