function drawfig

NB	=   load('L:\tkitom\data\tcohtrig\071016\T01308_Non-filtered-subsample(uV)__FDI-subsample(uV)_071016_128_128pts_.mat');
BB	=   load('L:\tkitom\data\tcohtrig\071016\AobaT00203_Non-filtered-subsample(uV)__FDI-subsample(uV)_071016_128_128pts_.mat');


FOI             = [4:50];
HUM             = [30:34];
chksigInd       = [4:29,35:50];
nn              = 5;
kk              = 3;
roifreq    = [0 100];
PowerLim1   = [0 200];
PowerLim2    = [0 40];

fig = figure;


%-------NB-----------------------------------
Selected = getfield(NB,'GripOff');

freq    = Selected.compiled.f(:,1);
px      = Selected.compiled.f(:,2);
py      = Selected.compiled.f(:,3)/64;
coh     = Selected.compiled.f(:,4);
phi     = Selected.compiled.f(:,5);
Ind     = [1:length(freq)]';

ch_cl   = Selected.compiled.cl.ch_c95;
seg_tot = Selected.compiled.cl.seg_tot;

chksig  = zeros(size(freq));
chksig(chksigInd)	= ones(size(chksigInd));
sig = coh > ch_cl;
sig = [sig & chksig];



FOImask = zeros(size(freq));
FOImask(FOI)    = ones(size(FOI));
HUMmask = zeros(size(freq));
HUMmask(HUM)    = ones(size(HUM));

sigcont = findcont(sig,kk,nn);


clssig  = clustvec(sig,kk,nn,FOImask,HUMmask);
clust   = findclust(clssig);
%     [maxN,maxInd]   = max(chksigInd([clust.last])-chksigInd([clust.first]));
[maxN,maxInd]   = max([clust.last]-[clust.first]);
maxclust    = clust(maxInd);
%     maxclustInd     = (Ind >= chksigInd(maxclust.first)) & (Ind <= chksigInd(maxclust.last));
maxclustInd     = (Ind >= maxclust.first) & (Ind <= maxclust.last);
%     clust   = findclust(sigcont);

%     disp(num2str(nansum(nanmask(nanmask(sig,FOImask),~HUMmask))))

cont    = uicontextmenu('Parent',fig);
uimenu(cont,'Label','uiregress2','callback','uiregress2(''sig'')')
warning('off')
% ----------------------------------------------------
h   = subplot(4,2,1,'Parent',fig);
cla(h);hold(h,'on')
plot(h,freq,px,'-k','LineWidth',0.75);
set(h, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'xlim',roifreq,...
    'XTickLabelMode', 'Auto',...
    'Ylim',PowerLim1,...
    'YTickLabelMode', 'Auto')
ylabel(h,'Power(uV^2)')


% ----------------------------------------------------
h   = subplot(4,2,3,'Parent',fig);
cla(h);hold(h,'on')
plot(h,freq,py,'-k','LineWidth',0.75);
set(h,   'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'Xlim',roifreq,...
    'XTickLabelMode', 'Auto',...
    'Ylim',PowerLim2,...
    'YTickLabelMode', 'Auto')
ylabel(h,'Power(uV^2)')
title(h,['n=',num2str(Selected.compiled.cl.seg_tot)])

% ----------------------------------------------------
h   = subplot(4,2,5,'Parent',fig);
cla(h);hold(h,'on')

areaedged(h,freq,nanmask(coh,maxclustInd),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle','none');
plot(h,freq,coh,'-k','LineWidth',0.75);
line([freq(1),freq(end)],[ch_cl,ch_cl],'Parent',h,'Color',[0 0 0],'LineStyle',':')

set(h,   'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'xlim',roifreq,...
    'XTickLabelMode', 'Auto',...
    'ylim',[0 max(coh(chksigInd))])
ylabel(h,'Coherence')
title(['cl(95%) = ',num2str(ch_cl)],'Parent',h)


% ----------------------------------------------------
h   = subplot(4,2,7,'Parent',fig);
cla(h);hold(h,'on')

%     for jj=1:length(clust)
%         first   = clust(jj).first;
%         last    = clust(jj).last;
% %         line([freq(first),freq(last);freq(first),freq(last)],[get(h,'YLim')',get(h,'YLim')'],'Parent',h,'Color',[0.5 0.5 0.5],'LineStyle',':');
%         fill([freq(first),freq(last),freq(last),freq(first)],reshape([get(h,'YLim')',get(h,'YLim')']',[1,4]),[0.75 0.75 0.75],'Parent',h,'LineStyle',':');
%     end

phi_cl  = phasecl(seg_tot,coh(sig&maxclustInd));
terrorbar(h,[freq(sig&maxclustInd);freq(sig&maxclustInd);freq(sig&maxclustInd)],[phi(sig&maxclustInd)-2*pi;phi(sig&maxclustInd);phi(sig&maxclustInd)+2*pi],[phi_cl;phi_cl;phi_cl],'ok','MarkerFaceColor','k','MarkerSize',3,'Tag','sig');

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
xlabel(h,{'Frequency(Hz)';...
    ' ';...
    ['(' num2str(Selected.compiled.cl.df) 'Hz resolution, ' num2str(Selected.compiled.cl.seg_tot) ' segments, ' num2str(Selected.compiled.cl.seg_size) ' points)']})
%-------BB-----------------------------------
Selected = getfield(BB,'GripOff');

freq    = Selected.compiled.f(:,1);
px      = Selected.compiled.f(:,2);
py      = Selected.compiled.f(:,3);
coh     = Selected.compiled.f(:,4);
phi     = Selected.compiled.f(:,5);
Ind     = [1:length(freq)]';

ch_cl   = Selected.compiled.cl.ch_c95;
seg_tot = Selected.compiled.cl.seg_tot;

chksig  = zeros(size(freq));
chksig(chksigInd)	= ones(size(chksigInd));
sig = coh > ch_cl;
sig = [sig & chksig];



FOImask = zeros(size(freq));
FOImask(FOI)    = ones(size(FOI));
HUMmask = zeros(size(freq));
HUMmask(HUM)    = ones(size(HUM));

sigcont = findcont(sig,kk,nn);


clssig  = clustvec(sig,kk,nn,FOImask,HUMmask);
clust   = findclust(clssig);
%     [maxN,maxInd]   = max(chksigInd([clust.last])-chksigInd([clust.first]));
[maxN,maxInd]   = max([clust.last]-[clust.first]);
maxclust    = clust(maxInd);
%     maxclustInd     = (Ind >= chksigInd(maxclust.first)) & (Ind <= chksigInd(maxclust.last));
maxclustInd     = (Ind >= maxclust.first) & (Ind <= maxclust.last);
%     clust   = findclust(sigcont);

%     disp(num2str(nansum(nanmask(nanmask(sig,FOImask),~HUMmask))))

cont    = uicontextmenu('Parent',fig);
uimenu(cont,'Label','uiregress2','callback','uiregress2(''sig'')')
warning('off')
% ----------------------------------------------------
h   = subplot(4,2,2,'Parent',fig);
cla(h);hold(h,'on')
plot(h,freq,px,'-k','LineWidth',0.75);
set(h, 'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'xlim',roifreq,...
    'XTickLabelMode', 'Auto',...
    'Ylim',PowerLim1,...
    'YTickLabelMode', 'Auto')
ylabel(h,'Power(uV^2)')

% ----------------------------------------------------
h   = subplot(4,2,4,'Parent',fig);
cla(h);hold(h,'on')
plot(h,freq,py,'-k','LineWidth',0.75);
set(h,   'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'Xlim',roifreq,...
    'XTickLabelMode', 'Auto',...
    'Ylim',PowerLim2,...
    'YTickLabelMode', 'Auto')
ylabel(h,'Power(uV^2)')
title(h,['n=',num2str(Selected.compiled.cl.seg_tot)])

% ----------------------------------------------------
h   = subplot(4,2,6,'Parent',fig);
cla(h);hold(h,'on')

%     for jj=1:length(clust)
%         first   = clust(jj).first;
%         last    = clust(jj).last;
%         area(h,freq(first:last),coh(first:last),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle',':');
%     end
%     areaedged(h,freq,nanmask(coh,clssig),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle','none');
areaedged(h,freq,nanmask(coh,maxclustInd),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle','none');
plot(h,freq,coh,'-k','LineWidth',0.75);
%     plot(h,freq(sig),coh(sig),'ok','MarkerFaceColor','k','MarkerSize',3);
line([freq(1),freq(end)],[ch_cl,ch_cl],'Parent',h,'Color',[0 0 0],'LineStyle',':')

set(h,   'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'xlim',roifreq,...
    'XTickLabelMode', 'Auto',...
    'ylim',[0 max(coh(chksigInd))])
ylabel(h,'Coherence')
title(['cl(95%) = ',num2str(ch_cl)],'Parent',h)


% ----------------------------------------------------
h   = subplot(4,2,8,'Parent',fig);
cla(h);hold(h,'on')

%     for jj=1:length(clust)
%         first   = clust(jj).first;
%         last    = clust(jj).last;
% %         line([freq(first),freq(last);freq(first),freq(last)],[get(h,'YLim')',get(h,'YLim')'],'Parent',h,'Color',[0.5 0.5 0.5],'LineStyle',':');
%         fill([freq(first),freq(last),freq(last),freq(first)],reshape([get(h,'YLim')',get(h,'YLim')']',[1,4]),[0.75 0.75 0.75],'Parent',h,'LineStyle',':');
%     end

phi_cl  = phasecl(seg_tot,coh(sig&maxclustInd));
terrorbar(h,[freq(sig&maxclustInd);freq(sig&maxclustInd);freq(sig&maxclustInd)],[phi(sig&maxclustInd)-2*pi;phi(sig&maxclustInd);phi(sig&maxclustInd)+2*pi],[phi_cl;phi_cl;phi_cl],'ok','MarkerFaceColor','k','MarkerSize',3,'Tag','sig');

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
xlabel(h,{'Frequency(Hz)';...
    ' ';...
    ['(' num2str(Selected.compiled.cl.df) 'Hz resolution, ' num2str(Selected.compiled.cl.seg_tot) ' segments, ' num2str(Selected.compiled.cl.seg_size) ' points)']})
% ----------------------------------------------------------