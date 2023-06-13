function tcohsurvey_plot

[s,filename]    = topen;

coh     = s.f.coh;
PSD11   = s.f.PSD11;
PSD22   = s.f.PSD22;

freq    = s.f.freq(1,:);
seg_tot = size(s.f.freq,1);

figure

subplot(3,1,1)
pcolor(freq,[1:seg_tot],PSD11); shading flat
% set(gca,'clim',[s.cl.ch_c95 0.25],...
%     'YDir','Reverse')
set(gca,'YDir','Reverse')
% colormap(tmap2)
title(filename)
colorbar

subplot(3,1,2)
pcolor(freq,[1:seg_tot],PSD22); shading flat
% set(gca,'clim',[s.cl.ch_c95 0.25],...
%     'YDir','Reverse')
set(gca,'YDir','Reverse')
% colormap(tmap2)
% title(filename)
colorbar

subplot(3,1,3)
pcolor(freq,[1:seg_tot],coh); shading flat
set(gca,'clim',[s.cl.ch_c95 0.25],...
    'YDir','Reverse')
colormap(tmap2)
% title(filename)
colorbar
% keyboard