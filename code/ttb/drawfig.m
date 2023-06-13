function drawfig

NB	=   load('L:\tkitom\data\tcohtrig\070811\AobaT00101_Non-filtered-subsample(uV)__FDI-subsample(uV)_070811_256_64pts_.mat');
BB	=   load('L:\tkitom\data\tcohtrig\070811\AobaT00203_Non-filtered-subsample(uV)__FDI-subsample(uV)_070811_256_64pts_.mat');
NC	=   load('L:\tkitom\data\tcohtrig\070811\AobaT00201_Non-filtered-subsample(uV)__FDI-subsample(uV)_070811_256_64pts_.mat');
NB250	=   load('L:\tkitom\data\tcohtrig\070820\AobaT00101_Non-filtered-subsample-SR500Hz__FDI-subsample-SR500Hz_070820_512_512pts_.mat');
BB250	=   load('L:\tkitom\data\tcohtrig\070820\AobaT00203_Non-filtered-subsample-SR500Hz__FDI-subsample-SR500Hz_070820_512_512pts_.mat');
NC250	=   load('L:\tkitom\data\tcohtrig\070820\AobaT00201_Non-filtered-subsample-SR500Hz__FDI-subsample-SR500Hz_070820_512_512pts_.mat');
Selected = getfield(NB,'GripOn');

roifreq    = [5 95.7];
% roifreq    = [5 55];
PowerLim1   = [0 80];
PowerLim2    = [0 8];


kk  = 3;
nn  = 5;

FOI             = [12:99];
HUM             = [58:67];


freq    = Selected.compiled.f(:,1);

FOImask = zeros(size(freq));
FOImask(FOI)    = ones(size(FOI));
HUMmask = zeros(size(freq));
HUMmask(HUM)    = ones(size(HUM));

fig = figure;
 cont    = uicontextmenu('Parent',fig);
    uimenu(cont,'Label','uiregress','callback','uiregress([])')



%-------NB-----------------------------------
Selected = getfield(NB,'GripOn');


px      = Selected.compiled.f(:,2);
py      = Selected.compiled.f(:,3);
coh     = Selected.compiled.f(:,4);
phi     = Selected.compiled.f(:,5);

ch_cl   = Selected.compiled.cl.ch_c95;
seg_tot = Selected.compiled.cl.seg_tot;

sig     = coh > ch_cl;
sigclust= clustvec(sig,kk,nn,FOImask,HUMmask);
sigclustsig = sig & sigclust;
sigclustsig_hum = sigclustsig & ~HUMmask;

% sigcont = findcont(sig,kk,nn);
% clust   = findclust(sigcont);

h   = subplot(4,2,1,'Parent',fig);
    cla(h);hold(h,'on')
    plot(h,freq,px,'-k','LineWidth',0.75);
    set(h, 'Box', 'on',...
        'TickDir', 'out',...
        'TickDirMode', 'manual',...
        'xlim',roifreq,...
        'XTickLabelMode', 'Auto',...'Ylim',PowerLim1,...
        'YTickLabelMode', 'Auto',...
        'YLim',PowerLim1)
    ylabel(h,'Power(uV^2)')
%     title({filename;' ';' '},'HorizontalAlignment','center','Parent',h)
    
    % ----------------------------------------------------
    h   = subplot(4,2,3,'Parent',fig);
    cla(h);hold(h,'on')
    plot(h,freq,py,'-k','LineWidth',0.75);
    set(h,   'Box', 'on',...
        'TickDir', 'out',...
        'TickDirMode', 'manual',...
        'Xlim',roifreq,...
        'XTickLabelMode', 'Auto',...'Ylim',PowerLim2,...
        'YTickLabelMode', 'Auto',...
        'YLim',PowerLim2)
        ylabel(h,'Power(uV^2)')
        
    % ----------------------------------------------------    
    h   = subplot(4,2,5,'Parent',fig);
    cla(h);hold(h,'on')
%     
%     for jj=1:length(clust)
%         first   = clust(jj).first;
%         last    = clust(jj).last;
%         area(h,freq(first:last),coh(first:last),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle',':');
%     end
    area(h,freq(sigclust),coh(sigclust),'FaceColor',[0.5 0.5 0.5],'LineStyle','none');
    plot(h,freq,coh,'-k','LineWidth',0.75);    
    
    plot(h,freq(sigclustsig_hum),coh(sigclustsig_hum),'ok','MarkerFaceColor','k','MarkerSize',1.5);
    line([freq(1),freq(end)],[ch_cl,ch_cl],'Parent',h,'Color',[0 0 0],'LineStyle',':')
    
    set(h,   'Box', 'on',...
        'TickDir', 'out',...
        'TickDirMode', 'manual',...
        'xlim',roifreq,...
        'XTickLabelMode', 'Auto',...
        'ylim',[0 ch_cl*4])
    ylabel(h,'Coherence')
%     title(['cl(95%) = ',num2str(ch_cl)],'Parent',h)
    
    
    % ----------------------------------------------------    
    h   = subplot(4,2,7,'Parent',fig);
    cla(h);hold(h,'on')

%     for jj=1:length(clust)
%         first   = clust(jj).first;
%         last    = clust(jj).last;
% %         line([freq(first),freq(last);freq(first),freq(last)],[get(h,'YLim')',get(h,'YLim')'],'Parent',h,'Color',[0.5 0.5 0.5],'LineStyle',':');
%         fill([freq(first),freq(last),freq(last),freq(first)],reshape([get(h,'YLim')',get(h,'YLim')']',[1,4]),[0.75 0.75 0.75],'Parent',h,'LineStyle',':');
%     end

    phi_cl  = phasecl(seg_tot,coh(sigclustsig));
    terrorbar(h,[freq(sigclustsig);freq(sigclustsig);freq(sigclustsig)],[phi(sigclustsig)-2*pi;phi(sigclustsig);phi(sigclustsig)+2*pi],[phi_cl;phi_cl;phi_cl],'ok','MarkerFaceColor','k','MarkerSize',1.5,'Tag','sig');
%     plot(h,[freq(sigclustsig_hum);freq(sigclustsig_hum);freq(sigclustsig_hum)],[phi(sigclustsig_hum)-2*pi;phi(sigclustsig_hum);phi(sigclustsig_hum)+2*pi],'ok','MarkerFaceColor','k','MarkerSize',1.5,'Tag','sig');
    
    set(h, 'Box', 'on',...
        'TickDir', 'out',...
        'TickDirMode', 'manual',...
        'UIContextMenu',cont,...
        'xlim',roifreq,...
        'XTickLabelMode', 'auto',...
        'ylim',[-2*pi 2*pi],...
        'yTickMode','manual',...
        'yTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
        'yTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'})
    ylabel(h,'Phase')
    xlabel(h,'Frequency(Hz)')
%     xlabel(h,{'Frequency(Hz)';...
%         ' ';...
%         ['(' num2str(Selected.compiled.cl.df) 'Hz resolution, ' num2str(Selected.compiled.cl.seg_tot) ' segments, ' num2str(Selected.compiled.cl.seg_size) ' points)']})

%-------BB-----------------------------------
Selected = getfield(BB,'GripOn');

px      = Selected.compiled.f(:,2);
py      = Selected.compiled.f(:,3);
coh     = Selected.compiled.f(:,4);
phi     = Selected.compiled.f(:,5);

ch_cl   = Selected.compiled.cl.ch_c95;
seg_tot = Selected.compiled.cl.seg_tot;

sig     = coh > ch_cl;
sigclust= clustvec(sig,kk,nn,FOImask,HUMmask);
sigclustsig = sig & sigclust;
sigclustsig_hum = sigclustsig & ~HUMmask;

% sigcont = findcont(sig,kk,nn);
% clust   = findclust(sigcont);

h   = subplot(4,2,2,'Parent',fig);
    cla(h);hold(h,'on')
    plot(h,freq,px,'-k','LineWidth',0.75);
    set(h, 'Box', 'on',...
        'TickDir', 'out',...
        'TickDirMode', 'manual',...
        'xlim',roifreq,...
        'XTickLabelMode', 'Auto',...'Ylim',PowerLim1,...
        'YTickLabelMode', 'Auto',...
        'YLim',PowerLim1)
%     ylabel(h,'Power(uV^2)')
%     title({filename;' ';' '},'HorizontalAlignment','center','Parent',h)
    
    % ----------------------------------------------------
    h   = subplot(4,2,4,'Parent',fig);
    cla(h);hold(h,'on')
    plot(h,freq,py,'-k','LineWidth',0.75);
    set(h,   'Box', 'on',...
        'TickDir', 'out',...
        'TickDirMode', 'manual',...
        'Xlim',roifreq,...
        'XTickLabelMode', 'Auto',...'Ylim',PowerLim2,...
        'YTickLabelMode', 'Auto',...
        'YLim',PowerLim2)
%         ylabel(h,'Power(uV^2)')
        
    % ----------------------------------------------------    
    h   = subplot(4,2,6,'Parent',fig);
    cla(h);hold(h,'on')
%     
%     for jj=1:length(clust)
%         first   = clust(jj).first;
%         last    = clust(jj).last;
%         area(h,freq(first:last),coh(first:last),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle',':');
%     end


    area(h,freq(sigclust),coh(sigclust),'FaceColor',[0.5 0.5 0.5],'LineStyle','none');
    plot(h,freq,coh,'-k','LineWidth',0.75);

    plot(h,freq(sigclustsig_hum),coh(sigclustsig_hum),'ok','MarkerFaceColor','k','MarkerSize',1.5);
    line([freq(1),freq(end)],[ch_cl,ch_cl],'Parent',h,'Color',[0 0 0],'LineStyle',':')
    
    set(h,   'Box', 'on',...
        'TickDir', 'out',...
        'TickDirMode', 'manual',...
        'xlim',roifreq,...
        'XTickLabelMode', 'Auto',...
        'ylim',[0 ch_cl*4])
%     ylabel(h,'Coherence')
%     title(['cl(95%) = ',num2str(ch_cl)],'Parent',h)
    
    
    % ----------------------------------------------------    
    h   = subplot(4,2,8,'Parent',fig);
    cla(h);hold(h,'on')

%     for jj=1:length(clust)
%         first   = clust(jj).first;
%         last    = clust(jj).last;
% %         line([freq(first),freq(last);freq(first),freq(last)],[get(h,'YLim')',get(h,'YLim')'],'Parent',h,'Color',[0.5 0.5 0.5],'LineStyle',':');
%         fill([freq(first),freq(last),freq(last),freq(first)],reshape([get(h,'YLim')',get(h,'YLim')']',[1,4]),[0.75 0.75 0.75],'Parent',h,'LineStyle',':');
%     end

    phi_cl  = phasecl(seg_tot,coh(sigclustsig_hum));
    terrorbar(h,[freq(sigclustsig_hum);freq(sigclustsig_hum);freq(sigclustsig_hum)],[phi(sigclustsig_hum)-2*pi;phi(sigclustsig_hum);phi(sigclustsig_hum)+2*pi],[phi_cl;phi_cl;phi_cl],'ok','MarkerFaceColor','k','MarkerSize',1.5,'Tag','sig');
%         plot(h,[freq(sigclustsig_hum);freq(sigclustsig_hum);freq(sigclustsig_hum)],[phi(sigclustsig_hum)-2*pi;phi(sigclustsig_hum);phi(sigclustsig_hum)+2*pi],'ok','MarkerFaceColor','k','MarkerSize',1.5,'Tag','sig');
        
    set(h, 'Box', 'on',...
        'TickDir', 'out',...
        'TickDirMode', 'manual',...
        'UIContextMenu',cont,...
        'xlim',roifreq,...
        'XTickLabelMode', 'auto',...
        'ylim',[-2*pi 2*pi],...
        'yTickMode','manual',...
        'yTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
        'yTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'})
    
%     ylabel(h,'Phase')
    xlabel(h,'Frequency(Hz)')
%     xlabel(h,{'Frequency(Hz)';...
%         ' ';...
%         ['(' num2str(Selected.compiled.cl.df) 'Hz resolution, ' num2str(Selected.compiled.cl.seg_tot) ' segments, ' num2str(Selected.compiled.cl.seg_size) ' points)']})

% %-------NC-----------------------------------
% Selected = getfield(NC,'GripOn');
% 
% px      = Selected.compiled.f(:,2);
% py      = Selected.compiled.f(:,3);
% coh     = Selected.compiled.f(:,4);
% phi     = Selected.compiled.f(:,5);
% 
% ch_cl   = Selected.compiled.cl.ch_c95;
% seg_tot = Selected.compiled.cl.seg_tot;
% 
% sig     = coh > ch_cl;
% sigclust= clustvec(sig,kk,nn,FOImask,HUMmask);
% sigclustsig = sig & sigclust;
% 
% % sigcont = findcont(sig,kk,nn);
% % clust   = findclust(sigcont);
% 
% h   = subplot(5,3,3,'Parent',fig);
%     cla(h);hold(h,'on')
%     plot(h,freq,px,'-k','LineWidth',0.75);
%     set(h, 'Box', 'on',...
%         'TickDir', 'out',...
%         'TickDirMode', 'manual',...
%         'xlim',roifreq,...
%         'XTickLabelMode', 'Auto',...'Ylim',PowerLim1,...
%         'YTickLabelMode', 'Auto',...
%         'YLim',PowerLim1)
% %     ylabel(h,'Power(uV^2)')
% %     title({filename;' ';' '},'HorizontalAlignment','center','Parent',h)
%     
%     % ----------------------------------------------------
%     h   = subplot(5,3,6,'Parent',fig);
%     cla(h);hold(h,'on')
%     plot(h,freq,py,'-k','LineWidth',0.75);
%     set(h,   'Box', 'on',...
%         'TickDir', 'out',...
%         'TickDirMode', 'manual',...
%         'Xlim',roifreq,...
%         'XTickLabelMode', 'Auto',...'Ylim',PowerLim2,...
%         'YTickLabelMode', 'Auto',...
%         'YLim',PowerLim2)
% %         ylabel(h,'Power(uV^2)')
%         
%     % ----------------------------------------------------    
%     h   = subplot(5,3,9,'Parent',fig);
%     cla(h);hold(h,'on')
% %     
% %     for jj=1:length(clust)
% %         first   = clust(jj).first;
% %         last    = clust(jj).last;
% %         area(h,freq(first:last),coh(first:last),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle',':');
% %     end
%     plot(h,freq,coh,'-k','LineWidth',0.75);    
% %     plot(h,freq(sigclustsig),coh(sigclustsig),'ok','MarkerFaceColor','k','MarkerSize',1.5);
%     line([freq(1),freq(end)],[ch_cl,ch_cl],'Parent',h,'Color',[0 0 0],'LineStyle',':')
%     
%     set(h,   'Box', 'on',...
%         'TickDir', 'out',...
%         'TickDirMode', 'manual',...
%         'xlim',roifreq,...
%         'XTickLabelMode', 'Auto',...
%         'ylim',[0 ch_cl*4])
% %     ylabel(h,'Coherence')
% %     title(['cl(95%) = ',num2str(ch_cl)],'Parent',h)
%     
%     
%     % ----------------------------------------------------    
%     h   = subplot(5,3,12,'Parent',fig);
%     cla(h);hold(h,'on')
% 
% %     for jj=1:length(clust)
% %         first   = clust(jj).first;
% %         last    = clust(jj).last;
% % %         line([freq(first),freq(last);freq(first),freq(last)],[get(h,'YLim')',get(h,'YLim')'],'Parent',h,'Color',[0.5 0.5 0.5],'LineStyle',':');
% %         fill([freq(first),freq(last),freq(last),freq(first)],reshape([get(h,'YLim')',get(h,'YLim')']',[1,4]),[0.75 0.75 0.75],'Parent',h,'LineStyle',':');
% %     end
% 
% %     phi_cl  = phasecl(seg_tot,coh(sigclustsig));
% %     terrorbar(h,[freq(sigclustsig);freq(sigclustsig);freq(sigclustsig)],[phi(sigclustsig)-2*pi;phi(sigclustsig);phi(sigclustsig)+2*pi],[phi_cl;phi_cl;phi_cl],'ok','MarkerFaceColor','k','MarkerSize',1.5,'Tag','sig');
%     
%     set(h, 'Box', 'on',...
%         'TickDir', 'out',...
%         'TickDirMode', 'manual',...
%         'UIContextMenu',cont,...
%         'xlim',roifreq,...
%         'XTickLabelMode', 'auto',...
%         'ylim',[-2*pi 2*pi],...
%         'yTickMode','manual',...
%         'yTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
%         'yTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'})
% %     ylabel(h,'Phase')
% %     xlabel(h,{'Frequency(Hz)';...
% %         ' ';...
% %         ['(' num2str(Selected.compiled.cl.df) 'Hz resolution, ' num2str(Selected.compiled.cl.seg_tot) ' segments, ' num2str(Selected.compiled.cl.seg_size) ' points)']})
% 
% 
% 
% % ----------250-------------------
% Selected = getfield(NB250,'GripOn');
% 
% roifreq    = [5 250];
% % roifreq    = [5 55];
% PowerLim1   = [0 100];
% PowerLim2    = [0 10];
% 
% 
% kk  = 3;
% nn  = 5;
% 
% FOI             = [12:99];
% HUM             = [58:67];
% 
% 
% freq    = Selected.compiled.f(:,1);
% FOImask = zeros(size(freq));
% FOImask(FOI)    = ones(size(FOI));
% HUMmask = zeros(size(freq));
% HUMmask(HUM)    = ones(size(HUM));
% 
% %-------NB-----------------------------------
% Selected = getfield(NB250,'GripOn');
% px      = Selected.compiled.f(:,2);
% py      = Selected.compiled.f(:,3);
% coh     = Selected.compiled.f(:,4);
% phi     = Selected.compiled.f(:,5);
% 
% ch_cl   = Selected.compiled.cl.ch_c95;
% seg_tot = Selected.compiled.cl.seg_tot;
% 
% sig     = coh > ch_cl;
% sigclust= clustvec(sig,kk,nn,FOImask,HUMmask);
% sigclustsig = sig & sigclust;
% 
%     h   = subplot(5,3,13,'Parent',fig);
%     cla(h);hold(h,'on')
% %     
% %     for jj=1:length(clust)
% %         first   = clust(jj).first;
% %         last    = clust(jj).last;
% %         area(h,freq(first:last),coh(first:last),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle',':');
% %     end
%     plot(h,freq,coh,'-k','LineWidth',0.75);    
%     plot(h,freq(sigclustsig),coh(sigclustsig),'ok','MarkerFaceColor','k','MarkerSize',1.5);
%     line([freq(1),freq(end)],[ch_cl,ch_cl],'Parent',h,'Color',[0 0 0],'LineStyle',':')
%     
%     set(h,   'Box', 'on',...
%         'TickDir', 'out',...
%         'TickDirMode', 'manual',...
%         'xlim',roifreq,...
%         'XTickLabelMode', 'Auto',...
%         'ylim',[0 ch_cl*4])
%     ylabel(h,'Coherence')
% %     title(['cl(95%) = ',num2str(ch_cl)],'Parent',h)
% 
% %-------BB-----------------------------------
% Selected = getfield(BB250,'GripOn');
% px      = Selected.compiled.f(:,2);
% py      = Selected.compiled.f(:,3);
% coh     = Selected.compiled.f(:,4);
% phi     = Selected.compiled.f(:,5);
% 
% ch_cl   = Selected.compiled.cl.ch_c95;
% seg_tot = Selected.compiled.cl.seg_tot;
% 
% sig     = coh > ch_cl;
% sigclust= clustvec(sig,kk,nn,FOImask,HUMmask);
% sigclustsig = sig & sigclust;
% 
%     h   = subplot(5,3,14,'Parent',fig);
%     cla(h);hold(h,'on')
% %     
% %     for jj=1:length(clust)
% %         first   = clust(jj).first;
% %         last    = clust(jj).last;
% %         area(h,freq(first:last),coh(first:last),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle',':');
% %     end
%     plot(h,freq,coh,'-k','LineWidth',0.75);    
%     plot(h,freq(sigclustsig),coh(sigclustsig),'ok','MarkerFaceColor','k','MarkerSize',1.5);
%     line([freq(1),freq(end)],[ch_cl,ch_cl],'Parent',h,'Color',[0 0 0],'LineStyle',':')
%     
%     set(h,   'Box', 'on',...
%         'TickDir', 'out',...
%         'TickDirMode', 'manual',...
%         'xlim',roifreq,...
%         'XTickLabelMode', 'Auto',...
%         'ylim',[0 ch_cl*4])
%     ylabel(h,'Coherence')
% %     title(['cl(95%) = ',num2str(ch_cl)],'Parent',h)
% 
% %-------NC-----------------------------------
% Selected = getfield(NC250,'GripOn');
% px      = Selected.compiled.f(:,2);
% py      = Selected.compiled.f(:,3);
% coh     = Selected.compiled.f(:,4);
% phi     = Selected.compiled.f(:,5);
% 
% ch_cl   = Selected.compiled.cl.ch_c95;
% seg_tot = Selected.compiled.cl.seg_tot;
% 
% sig     = coh > ch_cl;
% sigclust= clustvec(sig,kk,nn,FOImask,HUMmask);
% sigclustsig = sig & sigclust;
% 
%     h   = subplot(5,3,15,'Parent',fig);
%     cla(h);hold(h,'on')
% %     
% %     for jj=1:length(clust)
% %         first   = clust(jj).first;
% %         last    = clust(jj).last;
% %         area(h,freq(first:last),coh(first:last),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle',':');
% %     end
%     plot(h,freq,coh,'-k','LineWidth',0.75);    
%     plot(h,freq(sigclustsig),coh(sigclustsig),'ok','MarkerFaceColor','k','MarkerSize',1.5);
%     line([freq(1),freq(end)],[ch_cl,ch_cl],'Parent',h,'Color',[0 0 0],'LineStyle',':')
%     
%     set(h,   'Box', 'on',...
%         'TickDir', 'out',...
%         'TickDirMode', 'manual',...
%         'xlim',roifreq,...
%         'XTickLabelMode', 'Auto',...
%         'ylim',[0 ch_cl*4])
%     ylabel(h,'Coherence')
% %     title(['cl(95%) = ',num2str(ch_cl)],'Parent',h)
