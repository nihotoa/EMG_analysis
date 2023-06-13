figure
% ---------------------------------------
wc  = load('L:\tkitom\data\wcoh\070819\AobaT00101_Non-filtered-subsample(uV)__FDI-subsample(uV).mat');

h   = subplot(4,2,[1,3]);
cl  = wc.cl.ch_c95;
freq    = wc.freq;
cxy     = wc.cxy;
t       = wc.t;
pcolor(t,freq,cxy);
shading('flat')
set(h,'CLim',[cl,0.1],...
    'XLim',[-1 3],...
    'YLim',[5 97.5]);
colormap(tmap2)
colorbar
title('coherence')
ylabel('frequency (Hz)')
% xlabel('time (s)')

% ---------------------------------------
wc  = load('L:\tkitom\data\wcoh\070819\AobaT00203_Non-filtered-subsample(uV)__FDI-subsample(uV).mat');
h   = subplot(4,2,[2,4]);
cl  = wc.cl.ch_c95;
freq    = wc.freq;
cxy     = wc.cxy;
t       = wc.t;
pcolor(t,freq,cxy);
shading('flat')
set(h,'CLim',[cl,0.1],...
    'XLim',[-1 3],...
    'YLim',[5 97.5]);
colormap(tmap2)
colorbar
title('coherence')
ylabel('frequency (Hz)')
% xlabel('time (s)')

% ---------------------------------------
force  = load('L:\tkitom\MDAdata\Analyses\STA\AobaT00101\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat');
XData   = force.XData;
YData   = force.YData;

h   = subplot(4,2,5);
plot(h,XData,YData,'-k')
set(h,'XLim',[-1 3]);
colorbar

% ---------------------------------------
force  = load('L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat');
XData   = force.XData;
YData   = force.YData;

h   = subplot(4,2,6);
plot(h,XData,YData,'-k')
set(h,'XLim',[-1 3]);
colorbar

% ---------------------------------------
force  = load('L:\tkitom\MDAdata\Analyses\STA\AobaT00101\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat');
XData   = force.XData;
YData   = force.YData;

h   = subplot(4,2,7);
plot(h,XData,YData,'-k')
set(h,'XLim',[-1 3]);
colorbar

% ---------------------------------------
force  = load('L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat');
XData   = force.XData;
YData   = force.YData;

h   = subplot(4,2,8);
plot(h,XData,YData,'-k')
set(h,'XLim',[-1 3]);
colorbar

set(gcf,'Position',[ 58         334        1074         569])