function viewcumdens(filename)
warning('off')

if nargin<1
    
[s,filename]   = topen;
else
    s=load(filename);
end

t   = s.t*1000;
q11 = s.q11;
q22 = s.q22;
q21 = s.q21;
c95 = s.cl.c95;
seg_tot = s.cl.seg_tot;

TLim    = [-250,250];

[qmax,qmaxind]    = max(abs(q21));
qmax   = q21(qmaxind);
qmaxt   = t(qmaxind);

[PATH,NAME,EXT] = fileparts(filename);

h   = findobj(0,'Tag','viewcumdens');

if(isempty(h))

    fig = figure('Name',filename,...
        'Numbertitle','off',...
        'PaperUnits' ,'centimeters',...
        'PaperOrientation' , 'portrait',...
        'PaperPosition' , [0.634517 4.77064 19.715 20.1362],...
        'PaperPositionMode' , 'manual',...
        'PaperSize', [20.984 29.6774],...
        'PaperType','a4',...
        'Units' , 'pixels',...
        'Position' , [814   322   350   750],...
        'ToolBar' , 'figure');
else

    fig = h;
    set(fig,'Name',filename)
end

cont    = uicontextmenu('Parent',fig);
uimenu(cont,'Label','uiPWHM','callback','uiPWHM');

h   = subplot(3,1,1,'Parent',fig);
cla(h);hold(h,'on')
plot(h,t,q11,'-k','LineWidth',0.75);
set(h,   'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'Xlim',TLim,...
    'XTickLabelMode', 'Auto')
ylabel(h,'lfp')
title(h,{[PATH],[NAME,EXT],['n=',num2str(seg_tot)]});

h   = subplot(3,1,2,'Parent',fig);
cla(h);hold(h,'on')
plot(h,t,q22,'-k','LineWidth',0.75);
set(h,   'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'Xlim',TLim,...
    'XTickLabelMode', 'Auto')
ylabel(h,'emg')

h   = subplot(3,1,3,'Parent',fig);
cla(h);hold(h,'on')
plot(h,t,q21,'-k','LineWidth',0.75);
plot(h,[t(1),t(1);t(end),t(end)],[c95,-c95;c95,-c95],'-k');
plot(h,[t(1),t(end)],[0,0],':k');
plot(h,[t(1),t(end)],[qmax,qmax],'-b');

set(h,   'Box', 'on',...
    'TickDir', 'out',...
    'TickDirMode', 'manual',...
    'UIContextMenu',cont,...
    'Xlim',TLim,...
    'XTickLabelMode', 'Auto',...
    'YlimMode','Auto')
ylabel(h,'Cross-correlation')
xlabel(h,'Lag(ms)')
title(h,['c95=',num2str(c95)]);


warning('on')