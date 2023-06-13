function dcohplot
[S,filename]	= topen;
cl  = S.EndHold.compiled.cl.ch_c95;
f10_96  = S.EndHold.compiled.freq' >= 10 & S.EndHold.compiled.freq' <= 96;
f15_50  = S.EndHold.compiled.freq' >= 15 & S.EndHold.compiled.freq' <= 50;
freq    = S.EndHold.compiled.freq';

coh12   = squeeze(S.EndHold.compiled.coh(1,2,:));
coh21   = squeeze(S.EndHold.compiled.coh(2,1,:));
sig12   = coh12 > cl;
sig21   = coh21 > cl;
phase12 = squeeze(S.EndHold.compiled.phase(1,2,:));
phase21 = squeeze(S.EndHold.compiled.phase(2,1,:));
uwphase12   = unwrap(phase12);
uwphase21	= unwrap(phase21);


figure('Name',filename,...
    'NumberTitle','off');

subplot(3,2,1)
plot(freq,coh12,'k','Linewidth', 0.5)
line([freq(1) freq(end)],[cl cl],'Color','k');
set(gca, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',[15 50]);%,...
%     'YLim',[0 0.5]);
[Y,I12]   = max(coh12(f15_50));

% hist(S.EndHold.compiled.coh(1,2,:))
% mean(S.EndHold.compiled.coh(1,2,:))

subplot(3,2,2)
plot(freq,coh21,'k','Linewidth', 0.5)
line([freq(1) freq(end)],[cl cl],'Color','k');
set(gca, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',[15 50]);%,...
%     'YLim',[0 0.5]);
[Y,I21]   = max(coh21(f15_50));
freq15_50   = freq(f15_50);
disp(num2str([freq15_50(I12),freq15_50(I21)]));

% hist(S.EndHold.compiled.coh(2,1,:))
% mean(S.EndHold.compiled.coh(2,1,:))

subplot(3,2,3)
pplot(freq(sig12 & f10_96),phase12(sig12 & f10_96),'b')
set(gca, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',[10 100],...
    'YLim',[-3*pi pi]);

subplot(3,2,4)
pplot(freq(sig21 & f10_96),phase21(sig21 & f10_96),'b')
set(gca, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'Xlim',[10 100],...
    'YLim',[-3*pi pi]);

subplot(3,2,5)
plot(freq(sig12 & f10_96),uwphase12(sig12 & f10_96),'ob','MarkerFaceColor','b','MarkerSize',3)
regplot(freq(sig12 & f10_96),uwphase12(sig12 & f10_96),'-r')
set(gca, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',[10 100]);

subplot(3,2,6)
plot(freq(sig21 & f10_96),uwphase21(sig21 & f10_96) ,'ob','MarkerFaceColor','b','MarkerSize',3)
regplot(freq(sig21 & f10_96),uwphase21(sig21 & f10_96),'-r')
set(gca, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'XLim',[10 100]);

% subplot(2,2,5)
% hold on
% tau12   = phi2tau(squeeze(S.EndHold.compiled.phase(1,2,sig12)),S.EndHold.compiled.freq(sig12)');
% tau12   = [tau12;phi2tau(squeeze(S.EndHold.compiled.phase(1,2,sig12)) - 2*pi,S.EndHold.compiled.freq(sig12)')];
% hist(tau12,[-500:50:500]);
% set(gca,'Xlim',[-500 500]);
% % plot(S.EndHold.compiled.freq(sig12)',tau12,'ob','MarkerFaceColor','b','Ma
% % rkerSize',3)
% 
% subplot(2,2,6)
% hold on
% tau21   = phi2tau(squeeze(S.EndHold.compiled.phase(2,1,sig21)),S.EndHold.compiled.freq(sig21)');
% tau21   = [tau21;phi2tau(squeeze(S.EndHold.compiled.phase(2,1,sig21)) - 2*pi,S.EndHold.compiled.freq(sig21)')];
% hist(tau21,[-500:50:500]);
% set(gca,'Xlim',[-500 500]);
% % plot(S.EndHold.compiled.freq(sig21)',tau21,'ob','MarkerFaceColor','b','MarkerSize',3)
