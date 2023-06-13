function taskphaseplot(filename)
% exobj   = gco;
% trange	= [57 :157];    % REST -0.8 - - 0.4sec
% trange	= [157:257];        % PreGrip -0.4 - 0 sec
% trange      = [57:57];        % Grip -0.8 sec
% trange      = [107:107];        % Grip -0.6 sec
% trange      = [132:132];        % Grip -0.5 sec
% trange      = [157:157];        % Grip -0.4 sec
% trange      = [207:207];        % Grip -0.2 sec
% trange      = [232:232];        % Grip -0.1 sec


% trange	= [257:357];        % Grip0 - 0.4 sec
% trange      = [257:257];        % Grip 0 sec
% trange	= [282:282];        % Grip 0.1 sec
% trange	= [307:307];        % Grip 0.2 sec
% trange	= [332:332];        % Grip 0.3 sec
% trange	= [357:357];        % Grip 0.4 sec
% trange	= [382:382];        % Grip 0.5 sec

% trange	= [507:607]; % HOLD 1.0 - 1.4 sec 
trange	= [507:657]; % HOLD 1.0 - 1.6 sec 
% trange	= [407:507]; % HOLD 0.6 - 1.0 sec 
% trange	= [407:407]; % HOLD 0.6 sec 
% trange	= [432:432]; % HOLD 0.7 sec 
% trange	= [457:457]; % HOLD 0.8 sec 
% trange	= [482:482]; % HOLD 1.0 sec 
% trange	= [507:507]; % HOLD 1.0 sec 
% trange	= [557:557]; % HOLD 1.2 sec 
% trange	= [582:582]; % HOLD 1.3 sec 
% trange	= [607:607]; % HOLD 1.4 sec 
% trange	= [632:757];% HOLD 1.5-2.0 sec
% trange    = [357:407]


% 
% FOI     = [8:32];   % 10-40 Hz
% FOI     = [8:44,52:76];   % 10-55 65-95 Hz
% FOI     = [4:28];   % 5-35 Hz                 NG
% FOI     = [19:23];   % 5-35 Hz                 NH
% FOI     = [4:43,53:76];   % 5-55 65-95 Hz    BG
% FOI     = [11:43,53:74];   % 13.75-55 65-92.5 Hz      BH
% FOI     = [4:20];   % 5-35 Hz                 080205
% FOI     = [4:11];   % 5-12.5 Hz    BG alpha
% FOI     = [12:43,53:76];   % 16.25-55 65-95Hz    BG non-alpha
% FOI     = [12:28];   % 10-40 Hz
% FOI     = [7:76];   % 10-95 Hz
FOI     = [4:44,52:76];   % 5-55 65-95 Hz

XLim    = [-1 3];
% XLim    = [inf inf];
% XLim    = [-2 2];
YLim    = [0 100];
CLim    = [0 0.5];
FOImask = logical(zeros(80,1));
FOImask(FOI)    = ones(length(FOI),1); 
% trange	= [1:1024];
% trange	= [232:257];
warning('off')
if nargin<1
    [s,filename]	= topen;
else
    s   = load(filename);
end
[fpath,fname,fext]	= fileparts(filename);

fig = findobj('Tag',mfilename);

if(isempty(fig))
    fig = figure('NumberTitle','off',...
        'Position',[576   116   382   783],...
        'Tag',mfilename);
end
set(fig,'FileName',fname,...
        'Name',fname)
    
    
cont    = uicontextmenu('Parent',fig);
uimenu(cont,'Label','uiregress','callback','uiregress2(''sig'')')

if(islogical(s.cxy))
    s.cxy   = double(s.cxy);
end
% s.cxy   = zeromask(s.cxy,s.csig);
cxy = s.cxy(:,trange);
% phi = s.phi(:,trange);
% cxy = nanmask(s.cxy,s.csig);
% cxy = cxy(:,trange);



s.csig  = s.cxy > s.cl.ch_c95;
phi = nanmask(s.phi,s.csig);
phi = s.phi(:,trange);
freq    = s.freq;
t       = s.t(trange);
cl      = s.cl.ch_c95;
seg_tot = s.cl.seg_tot;

s   = avewcohtime(s,[t(1) t(end)]);



h   = subplot(3,1,1,'Parent',fig);
cla(h);
H   =pcolor(h,s.t,s.freq,s.cxy);shading flat
set(H,'EdgeColor','none')
% keyboard
hold(h,'on')
if(t(end)~=t(1))
rectangle('Position',[t(1) freq(1) t(end)-t(1) freq(end)-freq(1)],'EdgeColor','w','Parent',h);
else
    plot(h,[t(1),t(1)],[freq(1) freq(end)],'-w')
end
% keyboard
% if(max(max(s.cxy))>cl)
% set(h,'Box','On',...
%     'CLim',[0,max(max(s.cxy))],...
%     'Clipping','Off',...
%     'LineWidth',2,...
%     'TickDir','Out',...
%     'XLim',XLim,...
%     'XTick',[-1:0.5:3],...
%     'YLim',YLim,...
%     'YTick',[0:20:100]);
% else
% keyboard
if(max(max(s.cxy))>=1)
    CLim    = [0 4];
end
set(h,'Box','On',...
    'CLim',[cl CLim(2)],...
    'Clipping','Off',...
    'LineWidth',2,...
    'TickDir','Out',...
    'XLim',XLim,...
    'XTick',[-1:0.5:3],...
    'YLim',YLim,...
    'YTick',[0:20:100]);
% end    


colormap(h,tmap2)
% title({[fpath,'\'],[fname,fext]});
title(h,[num2str(seg_tot),' trials']);
% disp([num2str(seg_tot),' trials'])
colorbar('peer',h);

h   = subplot(3,1,2,'Parent',fig);
cla(h);hold on
% plot(h,freq,nanmask(cxy,cxy>cl),'.k');
% errorbar(freq,nanmean(nanmask(cxy,cxy>cl),2),nanstd(nanmask(cxy,cxy>cl),0,2),'*r','Tag','sig','Parent',h);
% plot(h,freq,mean(cxy,2),'-k','Tag','sig','LineWidth',1);
plot(h,freq,s.avetime.cxy,'-k','Tag','sig','LineWidth',1);
line(get(h,'xlim'),[cl cl],'Color',[0.5 0.5 0.5],'Parent',h)

set(h,'Box','On',...
    'Clipping','Off',...
    'LineWidth',2,...
    'TickDir','Out',...
    'UIContextMenu',cont,...
    'XLim',YLim,...
    'XTick',[0:20:100],...
    'YLim',[0 CLim(2)]);
colorbar('peer',h);

while(0)
h   = subplot(3,1,3,'Parent',fig);
cla(h);hold on
% plot(h,freq,[nanmask(phi,cxy>cl),nanmask(phi,cxy>cl)-2*pi],'.k');
% plot(h,freq,nanmask(phi,cxy>cl),'.k');
clcount = binocl(length(trange),0.05,0.05);

aa	= nanmask(nanmask(phi,cxy>cl),repmat(nansum(cxy>cl,2)>clcount,1,length(trange)));
% H   = plot(h,freq,aa,'ob');
% goback(H)
meanphi = nanmean(optunwrap(aa,-pi),2);
stdphi = nanstd(optunwrap(aa,-pi),0,2);

notmeanphi  = meanphi;
notstdphi   = stdphi;
meanphi = nanmask(meanphi,FOImask);
stdphi  = nanmask(stdphi,FOImask);

% terrorbar(h,[freq';freq';freq'],[notmeanphi-2*pi;notmeanphi;notmeanphi+2*pi],[notstdphi;notstdphi;notstdphi] ,'ok','MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',4,'Tag','nonsig');
terrorbar(h,[freq';freq';freq'],[meanphi-2*pi;meanphi;meanphi+2*pi],[stdphi;stdphi;stdphi] ,'ok','MarkerEdgeColor','none','MarkerFaceColor','k','MarkerSize',4,'Tag','sig');
% plot(h,freq,[meanphi-2*pi,meanphi,meanphi+2*pi],'*r','Tag','sig');
% plot(h,freq,meanphi,'*r','Tag','sig');
end

while(0)
h   = subplot(3,1,3,'Parent',fig);
cla(h);drawnow;hold(h,'on')

meanphi = nanmean(optunwrap(phi,-pi),2);
stdphi  = nanstd(optunwrap(phi,-pi),0,2);

meanphi = nanmask(meanphi,FOImask);
stdphi  = nanmask(stdphi,FOImask);

terrorbar(h,[freq';freq';freq'],[meanphi-2*pi;meanphi;meanphi+2*pi],[stdphi;stdphi;stdphi] ,'ok','MarkerEdgeColor','none','MarkerFaceColor','k','MarkerSize',4,'Tag','sig');
end

while(0)
h   = subplot(3,1,3,'Parent',fig);
cla(h);drawnow;hold(h,'on')

sig = cxy>cl;
phicl  = phasecl(seg_tot,cxy);
% keyboard
if(any(sig))
%     keyboardr
terrorbar(h,[freq(sig)';freq(sig)';freq(sig)'],[phi(sig)-2*pi;phi(sig);phi(sig)+2*pi],[phicl(sig);phicl(sig);phicl(sig)] ,'ok','MarkerEdgeColor','none','MarkerFaceColor','k','MarkerSize',4,'Tag','sig');
end
end


h   = subplot(3,1,3,'Parent',fig);
cla(h);drawnow;hold(h,'on')
phi = s.avetime.phi(:);
sig = s.avetime.cxy>cl;
phicl  = phasecl(seg_tot,s.avetime.cxy);
% keyboard
if(any(sig))
%     keyboardr
terrorbar(h,[freq(sig)';freq(sig)';freq(sig)'],[phi(sig)-2*pi;phi(sig);phi(sig)+2*pi],[phicl(sig)';phicl(sig)';phicl(sig)'] ,'ok','MarkerEdgeColor','none','MarkerFaceColor','k','MarkerSize',4,'Tag','sig');
end


set(h,'Box','On',...
    'Clipping','Off',...
    'LineWidth',2,...
    'TickDir','Out',...
    'UIContextMenu',cont,...
    'XLim',YLim,...
    'XTick',[0:20:100],...
    'YLim',[-3*pi pi],...
    'YTickMode','manual',...
    'YTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
    'YTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'});
% title(h,['n= ',num2str(sum(~isnan(meanphi)))]);
% keyboard
colorbar('peer',h);
warning('on')
colormap(h,tmap2)
% axes(exobj);