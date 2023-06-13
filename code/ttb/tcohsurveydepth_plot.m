function tcohsurveydepth_plot


ddepth  = 500;

[S,filename]    = topen;

nfiles  = length(S);
for ii =1:nfiles
    s   = S{ii};
    coh(ii,:)     = s.f.coh;
    PSD11(ii,:)   = s.f.PSD11;
    PSD22(ii,:)   = s.f.PSD22;
end

freq    = s.f.freq;

figure

subplot(3,1,1)
pcolor(freq,([1:nfiles]-1)*ddepth,PSD11);shading flat
set(gca,'YDir','Reverse')
title(filename{1})
disp(filename{1})
colorbar

subplot(3,1,2)
pcolor(freq,([1:nfiles]-1)*ddepth,PSD22);shading flat
set(gca,'YDir','Reverse')
colorbar

subplot(3,1,3)
pcolor(freq,([1:nfiles]-1)*ddepth,coh);shading flat
set(gca,'clim',[s.cl.ch_c95 0.25],...
    'YDir','Reverse')
colorbar
colormap(tmap2)


