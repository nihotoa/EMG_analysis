function viewcohtrig(varargin)
% viewcohtrig(figureID,matfilenames,triggername)

warning('off')

if nargin < 1
    [allS,allfilename]=topen;
    Trigger     = 'GripOn';
elseif nargin < 2
    if(isnumeric(varargin{1}))
        fig = varargin{1};
        [allS,allfilename]=topen;
    elseif(ischar(varargin{1}))
        fig = basefigure;
        allfilename = varargin{1};
        allS   = load(allfilename);
    elseif(iscell(varargin{1}))
        fig = basefigure;
        allfilename = varargin{1};
        for ii =1:length(allfilename)
            allS{ii}   = load(allfilename{ii});
        end
    end
    Trigger     = 'GripOn';
elseif nargin < 3
    if(isnumeric(varargin{1}))
        fig = varargin{1};
    else
        disp('error')
        return;
    end
    if(ischar(varargin{2}))
        allfilename = varargin{2};
        allS   = load(allfilename);
    elseif(iscell(varargin{2}))
        allfilename = varargin{2};
        for ii =1:length(allfilename)
            allS{ii}   = load(allfilename{ii});
        end
    else
        disp('error')
        return;
    end
    Trigger     = 'GripOn';
else
    if(isnumeric(varargin{1}))
        fig = varargin{1};
    else
        disp('error')
        return;
    end
    if(ischar(varargin{2}))
        allfilename = varargin{2};
        allS   = load(allfilename);
    elseif(iscell(varargin{2}))
        allfilename = varargin{2};
        for ii =1:length(allfilename)
            allS{ii}   = load(allfilename{ii});
        end
    else
        disp('error')
        return;
    end
    if(ischar(varargin{3}))
        Trigger     = varargin{3};
    else
        disp('error')
        return;
    end
end

if(iscell(allS))
    nAnalyses   = length(allS);
else
    nAnalyses   =1;
end

for ii=1:nAnalyses
    if(iscell(allS))
        S   =allS{ii};
        filename    =allfilename{ii};
    else
        S   =allS;
        filename    =allfilename;
    end
    Selected = getfield(S,Trigger);


    roifreq    = [0 100];
    roitime    = [Selected.t(1) Selected.t(end)];
    PowerLim1   = [0 200];
    PowerLim2    = [0 40];

    % >> nfftpoints(1)Ç…ÇÊÇ¡ÇƒÅAindexÇÃäÑÇËìñÇƒÇåàíËÇ∑ÇÈÅB
    nfftpoints  = getfield(Selected,'nfftpoints');

    switch nfftpoints(1)
        % FFTpoints = 256
        % 5   6  | 7  11  | 12   57  | 58   59   67  | 68   99  | 103  127 (Index)
        % 3.9 4.9| 5.8 9.7| 10.7 54.7| 55.7 56.6 64.5| 65.4 95.7| 99.6 123.0 (Hz)

        % FFTpoints = 128
        % 3   | 4   6  | 7    29  | 30   34  | 35   50  | 52   63   (Index)
        % 3.9 | 5.9 9.8| 11.7 54.7| 56.6 64.5| 66.4 95.7| 99.6 121.1(Hz)

        case 256
            disp('256')
            % FOI             = [12:99];
            FOI             = [7:99];
            HUM             = [58:67];
            chksigInd       = [7:57,68:99];

            nn              = 5;
            kk              = 3;

        case 128
            disp('128')
            % FOI             = [12:99];
            FOI             = [4:50];
            HUM             = [30:34];
            chksigInd       = [4:29,35:50];

            nn              = 5;
            kk              = 3;

        otherwise
            error('File type is not supported (nfftpoints)')
    end
    % <<



    %     chksigInd	= [6:57,68:99];
    %     chksigInd	= [4:29,35:50];
    %     kk  = 3;
    %     nn  = 5;

    %     FOI             = [12:99];
    %     HUM             = [58:67];
    %     FOI             = [4:50];
    %     HUM             = [30:34];


    if nargin < 1
        fig = basefigure;
    end

    % calculate parameters;

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

    if(~isempty(maxclust))

        maxclustInd     = (Ind >= maxclust.first) & (Ind <= maxclust.last);
    end
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
    title(h,{filename;' ';' '},'HorizontalAlignment','center','Parent',h)

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

    %     for jj=1:length(clust)
    %         first   = clust(jj).first;
    %         last    = clust(jj).last;
    %         area(h,freq(first:last),coh(first:last),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle',':');
    %     end
    %     areaedged(h,freq,nanmask(coh,clssig),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle','none');
    if(~isempty(maxclust))
        areaedged(h,freq,nanmask(coh,maxclustInd),'EdgeColor',[0 0 0],'FaceColor',[0.75 0.75 0.75],'LineStyle','none');
    end
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
    h   = subplot(4,2,7,'Parent',fig);
    cla(h);hold(h,'on')

    %     for jj=1:length(clust)
    %         first   = clust(jj).first;
    %         last    = clust(jj).last;
    % %         line([freq(first),freq(last);freq(first),freq(last)],[get(h,'YLim')',get(h,'YLim')'],'Parent',h,'Color',[0.5 0.5 0.5],'LineStyle',':');
    %         fill([freq(first),freq(last),freq(last),freq(first)],reshape([get(h,'YLim')',get(h,'YLim')']',[1,4]),[0.75 0.75 0.75],'Parent',h,'LineStyle',':');
    %     end
    if(~isempty(maxclust))
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
    end
    if(0)
        % ----------------------------------------------------
        h   = subplot(4,2,6,'Parent',fig);
        cla(h);hold(h,'on')

        %     clssig  = clustvec(sig,kk,nn,FOImask,HUMmask);
        %     keyboard

        %     plot(h,freq,coh,'-k','LineWidth',0.75);
        plot(h,freq,smoothing(coh,3,'boxcar'),'-k','LineWidth',0.75);
        stairs(h,freq,clssig*ch_cl*2,'-r','MarkerFaceColor','k','MarkerSize',3);
        line([freq(1),freq(end)],[ch_cl,ch_cl],'Parent',h,'Color',[0 0 0],'LineStyle',':')
        line([10,10;15,15;35,35;40,40;95,95]',[0,ch_cl*2;0,ch_cl*2;0,ch_cl*2;0,ch_cl*2;0,ch_cl*2]','Parent',h,'Linestyle','-','Color','k')
        set(h,   'Box', 'on',...
            'TickDir', 'out',...
            'TickDirMode', 'manual',...
            'xlim',roifreq,...
            'XTickLabelMode', 'Auto',...
            'ylim',[0 inf]);
        ylabel(h,'Coherence')
        title('smoothed (3bins ''boxcar'')','Parent',h)




        %     if(isfield(Selected,'timecoarse'))


        h   = subplot(4,2,2,'Parent',fig);
        colormap(h,'jet')
        cont    = uicontextmenu('Parent',fig);
        uimenu(cont,'Label','vertical section','callback','VerticalSection(2)')
        uimenu(cont,'Label','horizontal section','callback','HorizontalSection(1)')
        H   = pcolor(h,Selected.timecoarse.t(:),Selected.timecoarse.freq(:),Selected.timecoarse.px(:,:));shading(h,'flat')
        caxis(h,PowerLim1)
        %     set(gca,'CameraPosition',[-13.697 0 8.66]);

        set(h,   'Box', 'off',...
            'TickDir', 'out',...
            'TickDirMode', 'manual',...
            'UIContextMenu',cont,...
            'xlim',roitime,...
            'xTickLabelMode', 'Auto',...
            'ylim',roifreq,...
            'yTickLabelMode', 'Auto')
        set(H, 'UIContextMenu',cont,...
            'UserData',Selected.timecoarse.cl.f_c95);
        colorbar('peer',h)
        title(['n = ',num2str(Selected.timecoarse.cl.seg_tot)],'Parent',h)


        h   = subplot(4,2,4,'Parent',fig);
        colormap(h,'jet')
        cont    = uicontextmenu('Parent',fig);
        uimenu(cont,'Label','vertical section','callback','VerticalSection(2)')
        uimenu(cont,'Label','horizontal section','callback','HorizontalSection(1)')
        H   = pcolor(h,Selected.timecoarse.t(:),Selected.timecoarse.freq(:),Selected.timecoarse.py(:,:));shading(h,'flat')
        caxis(h,PowerLim2)
        %     set(gca,'CameraPosition',[-13.697 0 8.66]);
        set(h,   'Box', 'off',...
            'TickDir', 'out',...
            'TickDirMode', 'manual',...
            'UIContextMenu',cont,...
            'xlim',roitime,...
            'xTickLabelMode', 'Auto',...
            'ylim',roifreq,...
            'yTickLabelMode', 'Auto')
        set(H, 'UIContextMenu',cont,...
            'UserData',Selected.timecoarse.cl.f_c95);
        colorbar('peer',h)

        h   = subplot(4,2,6,'Parent',fig);
        cm  = colormap(h,'jet');
        cont    = uicontextmenu('Parent',fig);
        uimenu(cont,'Label','vertical section','callback','VerticalSection(2)')
        uimenu(cont,'Label','horizontal section','callback','HorizontalSection(1)')
        H   = pcolor(h,Selected.timecoarse.t(:),Selected.timecoarse.freq(:),Selected.timecoarse.cxy(:,:));shading(h,'flat')
        cmin    = Selected.timecoarse.cl.ch_c95;
        cmax    = max(max(Selected.timecoarse.cxy(Selected.timecoarse.freq>=roifreq(1)&Selected.timecoarse.freq<=roifreq(2),Selected.timecoarse.t>=roitime(1)&Selected.timecoarse.t<=roitime(2))));
        if cmin < cmax
            caxis(h,[cmin cmax])
        else
            caxis(h,[cmin cmin*1.1])
        end

        set(h,   'Box', 'off',...
            'TickDir', 'out',...
            'TickDirMode', 'manual',...
            'UIContextMenu',cont,...
            'xlim',roitime,...
            'xTickLabelMode', 'Auto',...
            'ylim',roifreq,...
            'yTickLabelMode', 'Auto')
        set(H, 'UIContextMenu',cont,...
            'UserData',Selected.timecoarse.cl.ch_c95);
        cbh = colorbar('peer',h);
        line([-0.5000 1.5000],[Selected.timecoarse.cl.ch_c95 Selected.timecoarse.cl.ch_c95],'Color','w','LineWidth',1,'Parent',cbh)
        title(['cl(95%) = ',num2str(Selected.timecoarse.cl.ch_c95)],'Parent',h)
        Positions1   = get(h,'Position');

        h   = subplot(4,2,8,'Parent',fig);
        set(h,'Nextplot','add')
        if(isfield(Selected.timecoarse,'ref'))
            plot(h,Selected.t(:),mean(Selected.data{3},2),'k','LineWidth',0.75);
            stairs(h,Selected.timecoarse.t(:),Selected.timecoarse.ref(:),':k','LineWidth',0.75)
        elseif(isfield(Selected,'triggerbased'))
            plot(h,Selected.t(:),mean(Selected.data{3},2),'k','LineWidth',0.75);
            stairs(h,Selected.timecoarse.t(:),mean(Selected.triggerbased.ref(:,:),2),':k','LineWidth',0.75)
        end
        Positions2   = get(h,'Position');
        Positions2(3)= Positions1(3);
        set(h,   'Box', 'off',...
            'TickDir', 'out',...
            'TickDirMode', 'manual',...
            'Position',Positions2,...
            'xlim',roitime,...
            'xTickLabelMode', 'Auto')
        xlabel(h,['Time from ',Trigger, '  (sec)'])
        title('Summed Torque','Parent',h)
    end
    set(h,'Nextplot','replace')
end
warning('on')

function fig    = basefigure
fig = figure('Name','T-viewer',...
    'Numbertitle','off',...
    'PaperUnits' ,'centimeters',...
    'PaperOrientation' , 'portrait',...
    'PaperPosition' , [0.634517 4.77064 19.715 20.1362],...
    'PaperPositionMode' , 'manual',...
    'PaperSize', [20.984 29.6774],...
    'PaperType','a4letter',...
    'Units' , 'pixels',...
    'Position' , [812    45   749   765],...
    'ToolBar' , 'figure');