figure('Clipping','off')
% FOI	=[12:57,68:99];

load('prctsig_071019');
load('depth_071019');
load('peakwidth_071019');
load('tau_071019');
cl_width    =25;

NB  = fnb(:,1);
BB  = fbb(:,1);
% Nnb = N1;
% Nbb = N2;
clNB    = (binocl(Nnb,0.05,0.05)-0.5) / Nnb * 100;
clBB    = (binocl(Nbb,0.05,0.05)-0.5) / Nbb * 100;

% FOI	=[12:99];
% FOI     = [4:50];
FOI     = [1:length(freq)];
FLim    = [0 100];
FOImask = logical(zeros(size(freq)));
FOImask(FOI)    = ones(size(FOI));
sigNB = NB.*(NB > clNB);
sigBB = BB.*(BB > clBB);

h   = subplot(3,2,1);
cla;hold on;

% areastairs(h,freq(FOImask),(sigNB(FOImask)),0,'FaceColor',[0.83 0.83 0.83],'LineStyle','none')
stairs(h,freq(FOImask),(NB(FOImask)),'LineStyle','-','Color','k','LineWidth',1.5)

% stairs(h,freq(:),NB,'Color','k')
line([0 125],[clNB clNB],'Color',[0.5 0.5 0.5],'LineStyle','-','LineWidth',1.5)
set(h,'XLim',FLim,...
    'XTick',[0:20:100],...
    'YLim',[0 60],...
    'YTick',[0:20:100],...
    'Box','on',...
    'TickDir','out')

title(['NarrowBand (n=',num2str(Nnb),')'])
xlabel('frequency (Hz)')
ylabel('% significant')

h   = subplot(3,2,2);
cla;hold on;

% areastairs(h,freq(:),(BB.*(~FOImask)),0,'FaceColor',[0.83 0.83 0.83],'LineStyle','none')
% areastairs(h,freq(:),(BB.*FOImask.*sigBB),0,'FaceColor',[0 0 0],'LineStyle','none')
% areastairs(h,freq(:),(BB.*FOImask.*(~sigBB)),0,'FaceColor',[1 1 1],'LineStyle','none')

% areastairs(h,freq(FOImask),(sigBB(FOImask)),0,'FaceColor',[0.83 0.83 0.83],'LineStyle','none')
stairs(h,freq(FOImask),(BB(FOImask)),'LineStyle','-','Color','k','LineWidth',1.5)

% stairs(h,freq(:),BB,'Color','k')
line([0 125],[clBB clBB],'Color',[0.5 0.5 0.5],'LineStyle','-','LineWidth',1.5)
set(h,'XLim',FLim,...
    'XTick',[0:20:100],...
    'YLim',[0 100],...
    'YTick',[0:20:100],...
    'Box','on',...
    'TickDir','out')

title(['BroadBand (n=',num2str(Nbb),')'])
xlabel('frequency (Hz)')
ylabel('% significant')

h   = subplot(3,2,3);
cla;hold on;

bar(tauX,nanmask(NBtau,NBtau~=0),'barwidth',1,'LineWidth',1.5)

set(h,...'XLim',[3.9 95.7],...    'XTick',[0:20:100],...    'YLim',[0 100],...    'YTick',[0:20:100],...
    'Box','on',...
    'TickDir','out')
title('Narrow')
xlabel('Slope (ms)')
ylabel('Count')

h   = subplot(3,2,4);
cla;hold on;

bar(tauX,BBtau,'barwidth',1,'LineWidth',1.5)

set(h,...'XLim',[3.9 95.7],...    'XTick',[0:20:100],...    'YLim',[0 100],...    'YTick',[0:20:100],...
    'Box','on',...
    'TickDir','out')
title('Broad')
xlabel('Slope (ms)')
ylabel('Count')



h   = subplot(3,2,5);
cla;hold on;
% 
% keyboard
bar(repmat([2.5:5:87.5]',1,2),peakwidth,'stack','BarWidth',1,'LineWidth',1.5)

set(h,...'XLim',[3.9 95.7],...    'XTick',[0:20:100],...    'YLim',[0 100],...    'YTick',[0:20:100],...
    'Box','on',...
    'TickDir','out')

title('PeakWidth')
xlabel('PeakWidth (Hz)')
ylabel('Counts')


h   = subplot(3,2,6);
cla;hold on;

bar([250:500:3250],depth,'stack','barwidth',0.8,'LineWidth',1.5)
set(h,...'XLim',[3.9 95.7],...    'XTick',[0:20:100],...    'YLim',[0 100],...    'YTick',[0:20:100],...
    'Box','on',...
    'TickDir','out')

title('Depth')
xlabel('Depth (um)')
ylabel('Proportion(%)')

set(gcf,'Position',[597   266   441   331])