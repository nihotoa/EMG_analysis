function displaydata(command,varargin)

if nargin<1
    command = 'initialize';
end


switch command
    case 'initialize'
        fig = figure('Color',[1 1 1],...
            'Menubar','none',...
            'Name','Channel Display',...
            'FileName','Channel Display',...
            'NumberTitle','off',...
            'PaperUnits','centimeters',...
            'PaperOrientation','portrait',...
            'PaperPosition',[0.634518 0.634517 19.715 28.4084],...
            'PaperPositionMode','manual',...
            'PaperSize',[20.984 29.6774],...
            'PaperType','a4',...
            'Position',[618 171 698 873],...
            'Renderer','None',...
            'RendererMode','auto',...
            'Tag','displaydata',...
            'ToolBar','figure');
        centerfig(fig);
        
        m = uimenu(fig,'Label','Display');
        uimenu(m,'Label','Open','Callback','displaydata(''open'')','Enable','on','Tag','display_open','Accelerator','o');
        uimenu(m,'Label','New','Callback','displaydata','Enable','on','Tag','display_new','Accelerator','n');
        uimenu(m,'Label','Reload','Callback','displaydata(''reload'')','Enable','on','Tag','display_reload','Accelerator','e');
        uimenu(m,'Label','Arrangement','Callback','displaydata(''arrangement'')','Enable','on','Tag','display_arrangement','Separator','On');
        uimenu(m,'Label','Switch','Callback','displaydata(''switch'')','Enable','on','Tag','display_switch');
        uimenu(m,'Label','Switch to near','Callback',[],'Enable','on','Tag','display_SwitchToNear');
        uimenu(m,'Label','Select PSE','Callback','displaydata(''select_pse'')','Enable','on','Separator','On');
        a   = uimenu(m,'Label','Show (STA)','Callback',[],'Enable','on','Separator','Off');
        uimenu(a,'Label','average','Checked','on','Callback','displaydata(''show(sta)_average'')','Enable','on','Tag','show(sta)_average');
        uimenu(a,'Label','average on BaseLine','Checked','off','Callback','displaydata(''show(sta)_average-on-BaseLine'')','Enable','on','Tag','show(sta)_average-on-BaseLine');
        uimenu(a,'Label','average with PSE','Checked','off','Callback','displaydata(''show(sta)_average-with-PSE'')','Enable','on','Tag','show(sta)_average-with-PSE');
        uimenu(a,'Label','average with PSE adjusted','Checked','off','Callback','displaydata(''show(sta)_average-with-PSE-adjusted'')','Enable','on','Tag','show(sta)_average-with-PSE-adjusted');
        uimenu(a,'Label','average with PSE adjusted (%)','Checked','off','Callback','displaydata(''show(sta)_average-with-PSE-adjusted-percent'')','Enable','on','Tag','show(sta)_average-with-PSE-adjusted-percent');
        uimenu(a,'Label','average with PSE adjusted (sd)','Checked','off','Callback','displaydata(''show(sta)_average-with-PSE-adjusted-sd'')','Enable','on','Tag','show(sta)_average-with-PSE-adjusted-sd');
        uimenu(a,'Label','average on SD','Checked','off','Callback','displaydata(''show(sta)_average-on-SD'')','Enable','on','Tag','show(sta)_average-on-SD');
        
        uimenu(a,'Label','trials','Checked','off','Callback','displaydata(''show(sta)_trials'')','Enable','on','Tag','show(sta)_trials');
        uimenu(a,'Label','trials (arranged)','Checked','off','Callback','displaydata(''show(sta)_trials-arranged'')','Enable','on','Tag','show(sta)_trials-arranged');
        uimenu(a,'Label','trials (cmap)','Checked','off','Callback','displaydata(''show(sta)_trials-cmap'')','Enable','on','Tag','show(sta)_trials-cmap');
        uimenu(a,'Label','trials (surf)','Checked','off','Callback','displaydata(''show(sta)_trials-surf'')','Enable','on','Tag','show(sta)_trials-surf');
        uimenu(a,'Label','trials (contourf)','Checked','off','Callback','displaydata(''show(sta)_trials-contourf'')','Enable','on','Tag','show(sta)_trials-contourf');

        uimenu(a,'Label','trials (stack)','Checked','off','Callback','displaydata(''show(sta)_trials-stack'')','Enable','on','Tag','show(sta)_trials-stack');
        a   = uimenu(m,'Label','Show (PSTH)','Callback',[],'Enable','on','Separator','Off');
        uimenu(a,'Label','histogram','Checked','on','Callback','displaydata(''show(psth)_histogram'')','Enable','on','Tag','show(psth)_histogram');
        uimenu(a,'Label','histogram with PSE','Checked','off','Callback','displaydata(''show(psth)_histogram-with-PSE'')','Enable','on','Tag','show(psth)_histogram-with-PSE');
        uimenu(a,'Label','raster','Checked','off','Callback','displaydata(''show(psth)_raster'')','Enable','on','Tag','show(psth)_raster');
        uimenu(a,'Label','raster (arranged)','Checked','off','Callback','displaydata(''show(psth)_raster-arranged'')','Enable','on','Tag','show(psth)_raster-arranged');
%         uimenu(a,'Label','raster over histogram','Checked','off','Callback','displaydata(''show(psth)_raster-over-histogram'')','Enable','on','Tag','show(psth)_raster-over-histogram');
        uimenu(a,'Label','instantaneous frequency','Checked','off','Callback','displaydata(''show(psth)_instantaneous-frequency'')','Enable','on','Tag','show(psth)_instantaneous-frequency');
        a   = uimenu(m,'Label','Show (FMCMP)','Callback',[],'Enable','on','Separator','Off');
        uimenu(a,'Label','anova1','Checked','on','Callback','displaydata(''show(fmcmp)_anova1'')','Enable','on','Tag','show(fmcmp)_anova1');
        uimenu(a,'Label','friedman','Checked','off','Callback','displaydata(''show(fmcmp)_friedman'')','Enable','on','Tag','show(fmcmp)_friedman');
        a   = uimenu(m,'Label','Show (ANOVA1)','Callback',[],'Enable','on','Separator','Off');
        uimenu(a,'Label','anova1','Checked','on','Callback','displaydata(''show(anova1)_anova1'')','Enable','on','Tag','show(anova1)_anova1');
        uimenu(a,'Label','kruskalwallis','Checked','off','Callback','displaydata(''show(anova1)_kruskalwallis'')','Enable','on','Tag','show(anova1)_kruskalwallis');
        a   = uimenu(m,'Label','Show (SCAT)','Callback',[],'Enable','on','Separator','Off');
        uimenu(a,'Label','scatter','Checked','on','Callback','displaydata(''show(scat)_scatter'')','Enable','on','Tag','show(scat)_scatter');
        uimenu(a,'Label','scatter (sorted)','Checked','on','Callback','displaydata(''show(scat)_scatter-sorted'')','Enable','on','Tag','show(scat)_scatter-sorted');
        uimenu(a,'Label','cmap','Checked','off','Callback','displaydata(''show(scat)_cmap'')','Enable','on','Tag','show(scat)_cmap');
        uimenu(a,'Label','scatter on camp','Checked','off','Callback','displaydata(''show(scat)_scatter-on-cmap'')','Enable','on','Tag','show(scat)_scatter-on-cmap');
        uimenu(a,'Label','polar','Checked','off','Callback','displaydata(''show(scat)_polar'')','Enable','on','Tag','show(scat)_polar');
        uimenu(a,'Label','histogram','Checked','off','Callback','displaydata(''show(scat)_histogram'')','Enable','on','Tag','show(scat)_histogram');
        uimenu(a,'Label','histogramXData','Checked','off','Callback','displaydata(''show(scat)_histogramXData'')','Enable','on','Tag','show(scat)_histogramXData');
        uimenu(a,'Label','histogramYData','Checked','off','Callback','displaydata(''show(scat)_histogramYData'')','Enable','on','Tag','show(scat)_histogramYData');
        a   = uimenu(m,'Label','Show (HIST)','Callback',[],'Enable','on','Separator','Off');
        uimenu(a,'Label','bar','Checked','on','Callback','displaydata(''show(hist)_bar'')','Enable','on','Tag','show(hist)_bar');
        uimenu(a,'Label','pie','Checked','off','Callback','displaydata(''show(hist)_pie'')','Enable','on','Tag','show(hist)_pie');
        
        
        a   = uimenu(m,'Label','Show (MF)','Callback','displaydata(''show(mf)'')','Enable','on','Separator','Off');
        a   = uimenu(m,'Label','Show (AVEMF)','Callback','displaydata(''show(avemf)'')','Enable','on','Separator','Off');
        a   = uimenu(m,'Label','Show (EMGPCA)','Callback','displaydata(''show(emgpca)'')','Enable','on','Separator','Off');
        a   = uimenu(m,'Label','Show (AVEPCA)','Callback','displaydata(''show(avepca)'')','Enable','on','Separator','Off');
        a   = uimenu(m,'Label','Show (COVMTX)','Callback','displaydata(''show(covmtx)'')','Enable','on','Separator','Off');
        a   = uimenu(m,'Label','Show (AVECOV)','Callback','displaydata(''show(avecov)'')','Enable','on','Separator','Off');
        
        a   = uimenu(m,'Label','Show (COH)','Callback',[],'Enable','on','Separator','Off');
        uimenu(a,'Label','Cxy','Checked','on','Callback','displaydata(''show(coh)_Cxy'')','Enable','on','Tag','show(coh)_Cxy');
        uimenu(a,'Label','Pxx','Checked','off','Callback','displaydata(''show(coh)_Pxx'')','Enable','on','Tag','show(coh)_Pxx');
        uimenu(a,'Label','Pyy','Checked','off','Callback','displaydata(''show(coh)_Pyy'')','Enable','on','Tag','show(coh)_Pyy');
        uimenu(a,'Label','Phase','Checked','off','Callback','displaydata(''show(coh)_Phase'')','Enable','on','Tag','show(coh)_Phase');
        a   = uimenu(m,'Label','Show (DCOH)','Callback',[],'Enable','on','Separator','Off');
        %         b1  = uimenu(a,'Label','DCoh','Callback',[],'Enable','on','Separator','Off');
        %         b2  = uimenu(a,'Label','Phase','Callback',[],'Enable','on','Separator','Off');
        uimenu(a,'Label','Coh:   x->y','Checked','on' ,'Callback','displaydata(''show(dcoh)_Cyx'')','Enable','on','Tag','show(dcoh)_Cyx');
        uimenu(a,'Label','Coh:   y->x','Checked','off','Callback','displaydata(''show(dcoh)_Cxy'')','Enable','on','Tag','show(dcoh)_Cxy');
        uimenu(a,'Label','Coh:   x->x','Checked','off','Callback','displaydata(''show(dcoh)_Cxx'')','Enable','off','Tag','show(dcoh)_Cxx');
        uimenu(a,'Label','Coh:   y->y','Checked','off','Callback','displaydata(''show(dcoh)_Cyy'')','Enable','off','Tag','show(dcoh)_Cyy');
        uimenu(a,'Label','Phase: x->y','Checked','on' ,'Callback','displaydata(''show(dcoh)_Phaseyx'')','Enable','on','Tag','show(dcoh)_Phaseyx');
        uimenu(a,'Label','Phase: y->x','Checked','off','Callback','displaydata(''show(dcoh)_Phasexy'')','Enable','on','Tag','show(dcoh)_Phasexy');
        uimenu(a,'Label','Phase: x->x','Checked','off','Callback','displaydata(''show(dcoh)_Phasexx'')','Enable','off','Tag','show(dcoh)_Phasexx');
        uimenu(a,'Label','Phase: y->y','Checked','off','Callback','displaydata(''show(dcoh)_Phaseyy'')','Enable','off','Tag','show(dcoh)_Phaseyy');
        
        m = uimenu(fig,'Label','View','Tag','view');
        a = uimenu(m,'Label','Axes','Tag','rowcol');
        %         a = uimenu(m,'Label','Axes
        %         Arrangement','Callback',[],'Enable','on','Tag','rowcol');
        uimenu(a,'Label','col=1','Callback','displaydata(''rowcol'')','Enable','on','Tag','col1','Checked','on');
        uimenu(a,'Label','col=2','Callback','displaydata(''rowcol'')','Enable','on','Tag','col2','Checked','off');
        uimenu(a,'Label','col=3','Callback','displaydata(''rowcol'')','Enable','on','Tag','col3','Checked','off');
        %         uimenu(a,'Label','col=4','Callback','displaydata(''rowcol'')','Enable','on','Tag','col4','Checked','off');
        %         uimenu(a,'Label','col=5','Callback','displaydata(''rowcol'')','Enable','on','Tag','col5','Checked','off');
        uimenu(a,'Label','col=N','Callback','displaydata(''rowcol'')','Enable','on','Tag','coln','Checked','off');
        uimenu(a,'Label','row=1','Callback','displaydata(''rowcol'')','Enable','on','Tag','row1','Checked','off');
        uimenu(a,'Label','row=2','Callback','displaydata(''rowcol'')','Enable','on','Tag','row2','Checked','off');
        uimenu(a,'Label','row=3','Callback','displaydata(''rowcol'')','Enable','on','Tag','row3','Checked','off');
        %         uimenu(a,'Label','row=4','Callback','displaydata(''rowcol'')','Enable','on','Tag','row4','Checked','off');
        %         uimenu(a,'Label','row=5','Callback','displaydata(''rowcol'')','Enable','on','Tag','row5','Checked','off');
        uimenu(a,'Label','row=N','Callback','displaydata(''rowcol'')','Enable','on','Tag','rown','Checked','off');
        uimenu(a,'Label','custom','Callback','displaydata(''rowcol'')','Enable','on','Tag','custom','Checked','off','Separator','on');
        
        a = uimenu(m,'Label','Axis','Tag','Axis');
        b = uimenu(a,'Label','limmode x','Callback',[],'Enable','on','Tag','limmode_x','Checked','off');
        uimenu(b,'Label','auto','Callback','displaydata(''limmode_x(auto)'')','Enable','on','Tag','limmode_x(auto)','Checked','off');
        uimenu(b,'Label','tight','Callback','displaydata(''limmode_x(tight)'')','Enable','on','Tag','limmode_x(tight)','Checked','on');
        uimenu(b,'Label','manual','Callback','displaydata(''limmode_x(manual)'')','Enable','on','Tag','limmode_x(manual)','Checked','off');
        b = uimenu(a,'Label','limmode y','Callback',[],'Enable','on','Tag','limmode_y','Checked','off');
        uimenu(b,'Label','auto','Callback','displaydata(''limmode_y(auto)'')','Enable','on','Tag','limmode_y(auto)','Checked','off');
        uimenu(b,'Label','tight','Callback','displaydata(''limmode_y(tight)'')','Enable','on','Tag','limmode_y(tight)','Checked','on');
        uimenu(b,'Label','manual','Callback','displaydata(''limmode_y(manual)'')','Enable','on','Tag','limmode_y(manual)','Checked','off');
        
        b = uimenu(a,'Label','link x','Callback',[],'Enable','on','Tag','link_x','Checked','off');
        uimenu(b,'Label','all','Callback','displaydata(''link_xall'')','Enable','on','Tag','link_xall','Checked','on');
        uimenu(b,'Label','row','Callback','displaydata(''link_xrow'')','Enable','on','Tag','link_xrow','Checked','on');
        uimenu(b,'Label','column','Callback','displaydata(''link_xcol'')','Enable','on','Tag','link_xcol','Checked','on');
        
        b = uimenu(a,'Label','link y','Callback',[],'Enable','on','Tag','link_y','Checked','off');
        uimenu(b,'Label','all','Callback','displaydata(''link_yall'')','Enable','on','Tag','link_yall','Checked','off');
        uimenu(b,'Label','row','Callback','displaydata(''link_yrow'')','Enable','on','Tag','link_yrow','Checked','off');
        uimenu(b,'Label','column','Callback','displaydata(''link_ycol'')','Enable','on','Tag','link_ycol','Checked','off');
        
        
        uimenu(a,'Label','grid x','Callback','displaydata(''grid_x'')','Enable','on','Tag','grid_x','Checked','off');
        uimenu(a,'Label','grid y','Callback','displaydata(''grid_y'')','Enable','on','Tag','grid_y','Checked','off');
        uimenu(a,'Label','save x','Callback','displaydata(''save_x'')','Enable','on','Tag','save_x','Checked','off');
        uimenu(a,'Label','save y','Callback','displaydata(''save_y'')','Enable','on','Tag','save_y','Checked','off');
        uimenu(a,'Label','scale x','Callback','displaydata(''scale_x'')','Enable','on','Tag','scale_x','Checked','off');
        uimenu(a,'Label','scale y','Callback','displaydata(''scale_y'')','Enable','on','Tag','scale_y','Checked','off');
        uimenu(a,'Label','link prop','Callback','displaydata(''link_prop'')','Enable','on','Tag','link_prop','Checked','off','Separator','on');
        uimenu(m,'Label','Show Slider','Callback',{@slider,'on'},'Enable','on','Tag','show_slider','Checked','off','Separator','on');
        
        m = uimenu(fig,'Label','Tool');
        uimenu(m,'Label','Display Cursor','Callback','tcursor','Enable','on','Tag','tcursor','Checked','off');
        a = uimenu(m,'Label','Add Time Label','Callback',[],'Enable','on','Tag','AddTimeLabel','Checked','off');
        uimenu(a,'Label','manual','Callback','displaydata(''uiAddTimeLabel'',''manual'')','Enable','on','Tag','uiAddTimeLabel_manual','Checked','off');
        uimenu(a,'Label','Local extreme','Callback','displaydata(''uiAddTimeLabel'',''localextreme'')','Enable','on','Tag','uiAddTimeLabel_localextreme','Checked','off');
        uimenu(a,'Label','Local max','Callback','displaydata(''uiAddTimeLabel'',''localmax'')','Enable','on','Tag','uiAddTimeLabel_localmax','Checked','off');
        uimenu(a,'Label','Local min','Callback','displaydata(''uiAddTimeLabel'',''localmin'')','Enable','on','Tag','uiAddTimeLabel_localmin','Checked','off');
        uimenu(a,'Label','First local max','Callback','displaydata(''uiAddTimeLabel'',''firstlocalmax'')','Enable','on','Tag','uiAddTimeLabel_firstlocalmax','Checked','off');
        uimenu(a,'Label','Area start','Callback','displaydata(''uiAddTimeLabel'',''areastart'')','Enable','on','Tag','uiAddTimeLabel_areastart','Checked','off');
        uimenu(a,'Label','Area stop','Callback','displaydata(''uiAddTimeLabel'',''areastop'')','Enable','on','Tag','uiAddTimeLabel_areastop','Checked','off');
        uimenu(a,'Label','Delete','Callback','displaydata(''uiAddTimeLabel'',''delete'')','Enable','on','Tag','uiAddTimeLabel_delete','Checked','off','Accelerator','d');
        
        b = uimenu(a,'Label','Short cut ''command''','Callback',[],'Enable','on','Tag','uiAddTimeLabel-shortcut','Checked','off','Separator','on');
        uimenu(b,'Label','manual','Callback','displaydata(''uiAddTimeLabel-shortcut'',''manual'')','Enable','on','Tag','uiAddTimeLabel-shortcut_manual','Checked','off');
        uimenu(b,'Label','Local extreme','Callback','displaydata(''uiAddTimeLabel-shortcut'',''localextreme'')','Enable','on','Tag','uiAddTimeLabel-shortcut_localextreme','Checked','off');
        uimenu(b,'Label','Local max','Callback','displaydata(''uiAddTimeLabel-shortcut'',''localmax'')','Enable','on','Tag','uiAddTimeLabel-shortcut_localmax','Checked','off');
        uimenu(b,'Label','Local min','Callback','displaydata(''uiAddTimeLabel-shortcut'',''localmin'')','Enable','on','Tag','uiAddTimeLabel-shortcut_localmin','Checked','off');
        uimenu(b,'Label','Firest local max','Callback','displaydata(''uiAddTimeLabel-shortcut'',''firstlocalmax'')','Enable','on','Tag','uiAddTimeLabel-shortcut_firstlocalmax','Checked','off');
        uimenu(b,'Label','Area start','Callback','displaydata(''uiAddTimeLabel-shortcut'',''areastart'')','Enable','on','Tag','uiAddTimeLabel-shortcut_areastart','Checked','off');
        uimenu(b,'Label','Area stop','Callback','displaydata(''uiAddTimeLabel-shortcut'',''areastop'')','Enable','on','Tag','uiAddTimeLabel-shortcut_areastop','Checked','off');
        uimenu(a,'Label','Execute','Callback','displaydata(''uiAddTimeLabel-shortcut'',''execute'')','Enable','on','Tag','uiAddTimeLabel_delete','Checked','off','Accelerator','f');
        
        uimenu(m,'Label','Save Channel','Callback','uiSaveChannel','Enable','on','Tag','uisavechannel','Checked','off','Separator','on');
        uimenu(m,'Label','Select Invalid Trials','Callback','uiSelectInvalidTrial','Enable','on','Tag','select-invalid-trials','Checked','off','Separator','on');
        
        m = uimenu(fig,'Label','Print');
        uimenu(m,'Label','Print(printer)','Callback','displaydata(''print'',''dwinc'')','Enable','on','Tag','print','Checked','off');
        uimenu(m,'Label','Print(jpg)','Callback','displaydata(''print'',''jpg'')','Enable','on','Tag','print','Checked','off');
        uimenu(m,'Label','Print(eps)','Callback','displaydata(''print'',''eps'')','Enable','on','Tag','print','Checked','off');
        uimenu(m,'Label','Print(fig)','Callback','displaydata(''print'',''fig'')','Enable','on','Tag','print','Checked','off');
        uimenu(m,'Label','Print btc(printer)','Callback','displaydata(''print btc'',''dwinc'')','Enable','on','Tag','print_btc','Checked','off');
        uimenu(m,'Label','Print btc(jpg)','Callback','displaydata(''print btc'',''jpg'')','Enable','on','Tag','print_btc','Checked','off');
        uimenu(m,'Label','Print btc(eps)','Callback','displaydata(''print btc'',''eps'')','Enable','on','Tag','print_btc','Checked','off');
        uimenu(m,'Label','Print btc(fig)','Callback','displaydata(''print btc'',''fig'')','Enable','on','Tag','print_btc','Checked','off');
        uimenu(m,'Label','Page setup','Callback','pagesetupdlg(gcf)','Enable','on','Tag','pagesetupdlg','Checked','off','Separator','on');
        
        h   = uicontrol(fig,'Units','pixels',...
            'Callback',{@slider,'move'},...
            'Position',[124 1 450 20],...
            'Style','slider',...
            'Tag','slider',...
            'UserData',true,...
            'Visible','off');
        set(h,'Units','normalized');
        h   = uicontrol(fig,'Units','pixels',...
            'Callback',[],...
            'HorizontalAlignment','center',...
            'Position',[574 1  40 20],...
            'String','#Trigs',...
            'Style','text',...
            'Tag','slider_text',...
            'Visible','off');
        set(h,'Units','normalized');
        h   = uicontrol(fig,'Units','pixels',...
            'Callback',{@slider,'setStep'},...
            'BackgroundColor',[1 1 1],...
            'HorizontalAlignment','center',...
            'Position',[614 1  60 20],...
            'Style','edit',...
            'String',1,...
            'Tag','slider_setStep',...
            'Visible','off');
        set(h,'Units','normalized');
        
        
        
        %         set(fig,'Menubar','figure');
        displaydata('open');
%         tcursor;
        
    case 'open'
        UD.fig          = gcf;
        parentpath   = tgetdir;
        if(isempty(parentpath))
            return;
        else
            UD.parentpath   = parentpath;
        end
        UD.grandparentpath  = fileparts(UD.parentpath);
        
        try
            UD.filenames    = dirmat(UD.parentpath);
            UD.filenames    = strfilt(UD.filenames,'~._');
            UD.filenames    = sortxls(deext(UD.filenames));
            %             UD.filenames    = ['Grouping Plot',UD.filenames];
%             UD.filenames    = [UD.filenames,repmat({'<blank>'},1,5)];
            UD.filenames    = uiselect(UD.filenames,1,'ファイルの選択');
        catch
            UD.filenames    = cell(1);
        end
        
        UD.rowcol       = 'col1';
        
        % default parameters
        UD.axis.link_xall   = true;
        UD.axis.link_xrow   = false;
        UD.axis.link_xcol   = false;
        UD.axis.link_yall   = false;
        UD.axis.link_yrow   = false;
        UD.axis.link_ycol   = false;
        UD.axis.grid_x      = false;
        UD.axis.grid_y      = false;
        UD.axis.save_x      = false;
        UD.axis.save_y      = false;
        UD.axis.scale_x     = false;
        UD.axis.scale_y     = false;
        UD.axis.link_prop   = 'XGrid YGrid';
        UD.axis.limmode_x   = 'tight';
        UD.axis.limmode_y   = 'tight';
        set(findobj(UD.fig,'Tag','limmode_x(auto)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_x(tight)'),'Checked','on');
        set(findobj(UD.fig,'Tag','limmode_x(manual)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_y(auto)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_y(tight)'),'Checked','on');
        set(findobj(UD.fig,'Tag','limmode_y(manual)'),'Checked','off');
        set(findobj(UD.fig,'Tag','link_xall'),'Checked','on');
        set(findobj(UD.fig,'Tag','link_xrow'),'Checked','off');
        set(findobj(UD.fig,'Tag','link_xcol'),'Checked','off');
        set(findobj(UD.fig,'Tag','link_yall'),'Checked','off');
        set(findobj(UD.fig,'Tag','link_yrow'),'Checked','off');
        set(findobj(UD.fig,'Tag','link_ycol'),'Checked','off');
        set(findobj(UD.fig,'Tag','grid_x'),'Checked','off');
        set(findobj(UD.fig,'Tag','grid_y'),'Checked','off');
        set(findobj(UD.fig,'Tag','save_x'),'Checked','off');
        set(findobj(UD.fig,'Tag','save_y'),'Checked','off');
        set(findobj(UD.fig,'Tag','scale_x'),'Checked','off');
        set(findobj(UD.fig,'Tag','scale_y'),'Checked','off');
        
        UD.show_sta     = 'average';
        UD.psename      = [];
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        UD.trial_reffile    = [];
        
        UD.show_psth     = 'histogram';
        set(findobj(UD.fig,'Tag','show(psth)_histogram'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(psth)_histogram-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-over-histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_instantaneous-frequency'),'Checked','off');
        UD.psth_YUnit   = 'frequency';
        UD.raster_reffile   = [];
        
        UD.show_fmcmp    = 'anova1';
        set(findobj(UD.fig,'Tag','show(fmcmp)_anova1'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(fmcmp)_friedman'),'Checked','off');
        
        UD.show_anova1    = 'anova1';
        set(findobj(UD.fig,'Tag','show(anova1)_anova1'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(anova1)_kruskalwallis'),'Checked','off');
        
        UD.show_avemf      =[];
        UD.show_mf      =[];
        UD.show_emgpca   = [];
        UD.show_avepca   = [];
        UD.show_covmtx   = [];
        UD.show_avecov   = [];
        
        UD.show_coh = 'Cxy';
        set(findobj(UD.fig,'Tag','show(coh)_Cxy'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(coh)_Pxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Pyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Phase'),'Checked','off');
        
        UD.show_dcoh = 'Cyx';
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyx'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyy'),'Checked','off');
        
        UD.show_scat    = 'scatter';
        set(findobj(UD.fig,'Tag','show(scat)_scatter'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-sorted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-on-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_polar'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramXData'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramYData'),'Checked','off');
        
        UD.show_hist    = 'bar';
        set(findobj(UD.fig,'Tag','show(hist)_bar'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(hist)_pie'),'Checked','off');
        
        UD.AddTimeLabel_method  = 'manual';
        set(findobj(UD.fig,'Tag','uiAddTimeLabel-shortcut_manual'),'Checked','on');
        set(findobj(UD.fig,'Tag','uiAddTimeLabel-shortcut_localextreme'),'Checked','off');
        set(findobj(UD.fig,'Tag','uiAddTimeLabel-shortcut_localmax'),'Checked','off');
        set(findobj(UD.fig,'Tag','uiAddTimeLabel-shortcut_localmin'),'Checked','off');
        set(findobj(UD.fig,'Tag','uiAddTimeLabel-shortcut_areastart'),'Checked','off');
        set(findobj(UD.fig,'Tag','uiAddTimeLabel-shortcut_areastop'),'Checked','off');
        
        
        UD.Slider.MaxTrial  = 10;
        UD.Slider.nTrial    = 1;
        UD.Slider.Value = 1/UD.Slider.MaxTrial;
        UD.Slider.Step  = [1/UD.Slider.MaxTrial UD.Slider.nTrial/UD.Slider.MaxTrial];
        UD.StartIndex   = 1;
        UD.StopIndex    = 1;
        UD.Slider.On    = false;
        
        UD.CLim         = [0 0.25];
        UD.XLim         = [-inf inf];
        UD.HUM          = [55 65];
%         UD.FOI          = [5 95];
        UD.FOI          = [5 50];
        UD.COH_peak_th  = 0.08;
        UD.kkfreq       = 6;
        UD.nnfreq       = 10;
        
        UD.tdsplot_flag = true;
        UD.usetrialsoffset_flag    = false;
        UD.maxfilenamelength    = 50;
        %         UD.tdsplot_flag = false;
        
        
        set(UD.fig,'UserData',UD);
        %         set(0,'CurrentFigure',UD.fig);
        figure(UD.fig);
        try
            drawAxes;
            loadData;
            plotData;
            setSwitchToNear_menu;
        catch
            setSwitchToNear_menu;
            rethrow(lasterror);
        end
        
    case 'limmode_x(auto)'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','limmode_x(auto)'),'Checked','on');
        set(findobj(UD.fig,'Tag','limmode_x(tight)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_x(manual)'),'Checked','off');
        
        
        UD.axis.limmode_x   = 'auto';
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
        
    case 'limmode_x(tight)'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','limmode_x(auto)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_x(tight)'),'Checked','on');
        set(findobj(UD.fig,'Tag','limmode_x(manual)'),'Checked','off');
        
        
        UD.axis.limmode_x   = 'tight';
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'limmode_x(manual)'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','limmode_x(auto)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_x(tight)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_x(manual)'),'Checked','on');
        
        
        UD.axis.limmode_x   = 'manual';
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
        
    case 'limmode_y(auto)'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','limmode_y(auto)'),'Checked','on');
        set(findobj(UD.fig,'Tag','limmode_y(tight)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_y(manual)'),'Checked','off');
        
        
        UD.axis.limmode_y   = 'auto';
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'limmode_y(tight)'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','limmode_y(auto)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_y(tight)'),'Checked','on');
        set(findobj(UD.fig,'Tag','limmode_y(manual)'),'Checked','off');
        
        
        UD.axis.limmode_y   = 'tight';
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'limmode_y(manual)'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','limmode_y(auto)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_y(tight)'),'Checked','off');
        set(findobj(UD.fig,'Tag','limmode_y(manual)'),'Checked','on');
        
        
        UD.axis.limmode_y   = 'manual';
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
        
    case 'link_xall'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.link_xall;
        if(curr)
            UD.axis.link_xall  = false;
            set(findobj(UD.fig,'Tag','link_xall'),'Checked','off');
        else
            UD.axis.link_xall      = true;
            set(findobj(UD.fig,'Tag','link_xall'),'Checked','on');
            UD.axis.link_xcol   = false;
            set(findobj(UD.fig,'Tag','link_xcol'),'Checked','off');
            UD.axis.link_xrow   = false;
            set(findobj(UD.fig,'Tag','link_xrow'),'Checked','off');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'link_xrow'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.link_xrow;
        if(curr)
            UD.axis.link_xrow   = false;
            set(findobj(UD.fig,'Tag','link_xrow'),'Checked','off');
        else
            UD.axis.link_xrow   = true;
            set(findobj(UD.fig,'Tag','link_xrow'),'Checked','on');
            UD.axis.link_xall      = false;
            set(findobj(UD.fig,'Tag','link_xall'),'Checked','off');
            UD.axis.link_xcol   = false;
            set(findobj(UD.fig,'Tag','link_xcol'),'Checked','off');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;    
        
    case 'link_xcol'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.link_xcol;
        if(curr)
            UD.axis.link_xcol   = false;
            set(findobj(UD.fig,'Tag','link_xcol'),'Checked','off');
        else
            UD.axis.link_xcol   = true;
            set(findobj(UD.fig,'Tag','link_xcol'),'Checked','on');
            UD.axis.link_xall      = false;
            set(findobj(UD.fig,'Tag','link_xall'),'Checked','off');
            UD.axis.link_xrow   = false;
            set(findobj(UD.fig,'Tag','link_xrow'),'Checked','off');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'link_yall'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.link_yall;
        if(curr)
            UD.axis.link_yall  = false;
            set(findobj(UD.fig,'Tag','link_yall'),'Checked','off');
        else
            UD.axis.link_yall  = true;
            set(findobj(UD.fig,'Tag','link_yall'),'Checked','on');
            UD.axis.link_yrow   = false;
            set(findobj(UD.fig,'Tag','link_yrow'),'Checked','off');
            UD.axis.link_ycol   = false;
            set(findobj(UD.fig,'Tag','link_ycol'),'Checked','off');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'link_yrow'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.link_yrow;
        if(curr)
            UD.axis.link_yrow   = false;
            set(findobj(UD.fig,'Tag','link_yrow'),'Checked','off');
        else
            UD.axis.link_yrow   = true;
            set(findobj(UD.fig,'Tag','link_yrow'),'Checked','on');
            UD.axis.link_yall      = false;
            set(findobj(UD.fig,'Tag','link_yall'),'Checked','off');
            UD.axis.link_ycol      = false;
            set(findobj(UD.fig,'Tag','link_ycol'),'Checked','off');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'link_ycol'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.link_ycol;
        if(curr)
            UD.axis.link_ycol   = false;
            set(findobj(UD.fig,'Tag','link_ycol'),'Checked','off');
        else
            UD.axis.link_ycol   = true;
            set(findobj(UD.fig,'Tag','link_ycol'),'Checked','on');
            UD.axis.link_yall      = false;
            set(findobj(UD.fig,'Tag','link_yall'),'Checked','off');
            UD.axis.link_yrow      = false;
            set(findobj(UD.fig,'Tag','link_yrow'),'Checked','off');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
        
    case 'grid_x'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.grid_x;
        if(curr)
            UD.axis.grid_x  = false;
            set(findobj(UD.fig,'Tag','grid_x'),'Checked','off');
        else
            UD.axis.grid_x  = true;
            set(findobj(UD.fig,'Tag','grid_x'),'Checked','on');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'grid_y'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.grid_y;
        if(curr)
            UD.axis.grid_y  = false;
            set(findobj(UD.fig,'Tag','grid_y'),'Checked','off');
        else
            UD.axis.grid_y  = true;
            set(findobj(UD.fig,'Tag','grid_y'),'Checked','on');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'link_prop'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.link_prop;
        if(~iscell(curr))
            curr    = {curr};
        end
        
        UD.axis.link_prop   = inputdlg('PropertyNames','Link Axes Properties',1,curr);
        UD.axis.link_prop   = UD.axis.link_prop{1};
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
    case 'save_x'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.save_x;
        if(curr)
            UD.axis.save_x  = false;
            set(findobj(UD.fig,'Tag','save_x'),'Checked','off');
        else
            UD.axis.save_x  = true;
            set(findobj(UD.fig,'Tag','save_x'),'Checked','on');
        end
        set(UD.fig,'UserData',UD);
    case 'save_y'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.save_y;
        if(curr)
            UD.axis.save_y  = false;
            set(findobj(UD.fig,'Tag','save_y'),'Checked','off');
        else
            UD.axis.save_y  = true;
            set(findobj(UD.fig,'Tag','save_y'),'Checked','on');
        end
        set(UD.fig,'UserData',UD);
        
    case 'scale_x'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.scale_x;
        if(curr)
            UD.axis.scale_x  = false;
            set(findobj(UD.fig,'Tag','scale_x'),'Checked','off');
        else
            UD.axis.scale_x  = true;
            set(findobj(UD.fig,'Tag','scale_x'),'Checked','on');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;
    case 'scale_y'
        
        UD  = get(gcf,'UserData');
        curr    = UD.axis.scale_y;
        if(curr)
            UD.axis.scale_y  = false;
            set(findobj(UD.fig,'Tag','scale_y'),'Checked','off');
        else
            UD.axis.scale_y  = true;
            set(findobj(UD.fig,'Tag','scale_y'),'Checked','on');
        end
        
        set(UD.fig,'UserData',UD);
        setAxes;
        
             
    case 'uiAddTimeLabel'
        method  = varargin{1};
        hAx     = uiAddTimeLabel(method);
        plotData(hAx);
             
    case 'uiAddTimeLabel-shortcut'
        method  = varargin{1};
        UD      = get(gcf,'UserData');
        if(strcmp(method,'execute'))
            hAx = uiAddTimeLabel(UD.AddTimeLabel_method);
            plotData(hAx);
        else
            hObj    = gcbo;
            UD.AddTimeLabel_method  = method;
            
            set(get(get(hObj,'Parent'),'Children'),'Checked','off');
            set(hObj,'Checked','on')
            
            set(UD.fig,'UserData',UD);
        end
        
    case 'uiAddTimeLabel_localmax'
        
        hAx = uiAddTimeLabel('localmax');
        plotData(hAx);
        
    case 'uiAddTimeLabel_localmin'
        
        hAx = uiAddTimeLabel('localmin');
        plotData(hAx);
        
     case 'uiAddTimeLabel_areastart'
        
        hAx = uiAddTimeLabel('areastart');
        plotData(hAx);
        
    case 'uiAddTimeLabel_areastop'
        
        hAx = uiAddTimeLabel('areastop');
        plotData(hAx);
        
    case 'uiAddTimeLabel_firstlocalmax'
        
        hAx = uiAddTimeLabel('firstlocalmax');
        plotData(hAx);
        
    case 'uiAddTimeLabel_delete'
        
        hAx = uiAddTimeLabel('delete');
        plotData(hAx);
        
        
    case 'reload'
        
        UD  = get(gcf,'UserData');
        guiindicator(UD.fig,0,1,'Reloading...');
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        try
            UD.XLim = get(h(1),'XLim');
            UD.YLim = get(h(1),'YLim');
        catch
            UD.XLim = [];
            UD.YLim = [];
        end
        
        
        try
            drawAxes;
            loadData;
            plotData;
            setSwitchToNear_menu;
        catch
            setSwitchToNear_menu;
            rethrow(lasterror);
        end
        
    case 'print btc'
        
        UD  = get(gcf,'UserData');
        filetype    = varargin{1};
        guiindicator(UD.fig,0,1,'Printing...');
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        if(~strcmp(filetype,'dwinc'))
            outputpath      = uigetdir(UD.parentpath,'出力フォルダを選択してください。');
        end
        
        oldparentpath   = UD.parentpath;
        [grandparentpath,parentpath]    = fileparts(UD.parentpath);
        
        neardir = dirdir(grandparentpath);
        neardir = uiselect(deext(neardir));
        nDir    = length(neardir);
        
        for iDir =1:nDir
            warning('off')
            parentpath  = neardir{iDir};
            UD.parentpath  = fullfile(grandparentpath,parentpath);
            set(UD.fig,'UserData',UD);
            
            drawAxes;
            loadData;
            plotData;
            
            guiindicator(UD.fig,1,1,[UD.parentpath,' (', datestr(now),')']);
            
            switch filetype
                case 'jpg'
                    print(UD.fig,'-djpeg90','-r300',fullfile(outputpath,parentpath));
                case 'eps'
                    print(UD.fig,'-depsc2',fullfile(outputpath,parentpath));
                case 'fig'
                    saveas(UD.fig,fullfile(outputpath,parentpath),'fig');
                case 'dwinc'
                    print(UD.fig,'-dwinc');
                    disp([parentpath,' was printed out.'])
            end
            if(~strcmp(filetype,'dwinc'))
                disp([fullfile(outputpath,parentpath),'.',filetype,' was printed out.'])
            end
        end
        
        UD.parentpath   = oldparentpath;
        
        set(UD.fig,'UserData',UD);
        try
            drawAxes;
            loadData;
            plotData;
            setSwitchToNear_menu;
        catch
            setSwitchToNear_menu;
            rethrow(lasterror);
        end
        
    case 'print'
        
        UD  = get(gcf,'UserData');
        filetype    = varargin{1};
        guiindicator(UD.fig,0,1,'Printing...');
        [grandparentpath,outputfile]    = fileparts(UD.parentpath);
        
        guiindicator(UD.fig,1,1,[UD.parentpath,' (', datestr(now),')']);
        if(strcmp(filetype,'dwinc'))
            if(ispc)
                print(UD.fig,'-dwinc');
            else
                print(UD.fig,'-dpsc');
            end
            disp([outputfile,' was printed out.'])
        else
            
            outputpath      = getconfig('uiprint','parentpath');
            if(~ischar(outputpath))
                outputpath  = UD.parentpath;
            else
                if(~exist(outputpath,'dir'))
                    outputpath  = UD.parentpath;
                end
            end
            
            
            [outputfile,outputpath] = uiputfile(fullfile(outputpath,[outputfile,'.',filetype]),'ファイルの保存');
            
            %             guiindicator(UD.fig,1,1,[UD.parentpath,' (', datestr(now),')']);
            if(outputpath~=0)
                switch filetype
                    case 'jpg'
                        print(UD.fig,'-djpeg90','-r300',fullfile(outputpath,deext(outputfile)));
                    case 'eps'
                        print(UD.fig,'-depsc2',fullfile(outputpath,deext(outputfile)));
                    case 'fig'
                        saveas(UD.fig,fullfile(outputpath,deext(outputfile)),'fig');
                end
                disp([fullfile(outputpath,deext(outputfile)),'.',filetype,' was printed out.'])
                
                set(UD.fig,'UserData',UD);
            end
            
            setconfig('uiprint','parentpath',outputpath);
        end
        guiindicator(UD.fig,0,0);
        
    case 'arrangement'
        
        UD  = get(gcf,'UserData');
        oldfilenames    = UD.filenames;
        UD.filenames    = dirmat(UD.parentpath);
        UD.filenames    = strfilt(UD.filenames,'~._');
        UD.filenames    = sortxls(deext(UD.filenames));
        %             UD.filenames    = ['Grouping Plot',UD.filenames];
%         UD.filenames    = [UD.filenames,repmat({'<blank>'},1,5)];
        UD.filenames    = uiselect(UD.filenames,1,'ファイルの選択',oldfilenames);
        %         UD.XLim         = get(gca,'XLim');
        
        if(isempty(UD.filenames))
            return;
        end
        set(UD.fig,'UserData',UD);
        
        drawAxes;
        loadData;
        plotData;
        
    case 'switch'
        
        UD  = get(gcf,'UserData');
        guiindicator(UD.fig,0,1,'Switching...');
        
        UD.parentpath   = uigetdir(UD.parentpath,'Select Experiment Directory');
        UD.grandparentpath  = fileparts(UD.parentpath);
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        if(isempty(UD.parentpath))
            return;
        end
        
        set(UD.fig,'UserData',UD);
        try
            drawAxes;
            loadData;
            plotData;
            setSwitchToNear_menu;
        catch
            setSwitchToNear_menu;
            rethrow(lasterror);
        end
        
    case 'SwitchToPrevious'
        
        UD  = get(gcf,'UserData');
        guiindicator(UD.fig,0,1,'Switching to previous');
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        neardir  = dirdir(UD.grandparentpath);
        ndir    = length(neardir);
        
        [grandparentpath,parentpath]    = fileparts(UD.parentpath);
        ind = strmatch(parentpath,neardir);
        newind = max(ind-1,1);
        if(ind==newind)
            guiindicator(UD.fig,0,1,'No more previous');
            return;
        else
            ind = newind;
        end
        UD.parentpath   = fullfile(grandparentpath,neardir{ind});
        
        set(UD.fig,'UserData',UD);
        try
            drawAxes;
            loadData;
            plotData;
            setSwitchToNear_menu;
        catch
            setSwitchToNear_menu;
            rethrow(lasterror);
        end
        
    case 'SwitchToNext'
        
        UD  = get(gcf,'UserData');
        guiindicator(UD.fig,0,1,'Switching to next');
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        neardir  = dirdir(UD.grandparentpath);
        ndir    = length(neardir);
        
        [grandparentpath,parentpath]    = fileparts(UD.parentpath);
        ind = strmatch(parentpath,neardir);
        newind = min(ind+1,ndir);
        if(ind==newind)
            guiindicator(UD.fig,0,1,'No more next');
            return;
        else
            ind = newind;
        end
        UD.parentpath   = fullfile(grandparentpath,neardir{ind});
        
        set(UD.fig,'UserData',UD);
        try
            drawAxes;
            loadData;
            plotData;
            setSwitchToNear_menu;
        catch
            setSwitchToNear_menu;
            rethrow(lasterror);
        end
        
    case 'SwitchToNear'
        
        UD  = get(gcf,'UserData');
        guiindicator(UD.fig,0,1,'switching...');
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        h   = gcbo;
        
        UD.parentpath   = fullfile(UD.grandparentpath,get(h,'Label'));
        
        set(UD.fig,'UserData',UD);
        try
            drawAxes;
            loadData;
            plotData;
            setSwitchToNear_menu;
        catch
            setSwitchToNear_menu;
            rethrow(lasterror);
        end
        
        
    case 'select_pse'
        UD  = get(gcf,'UserData');
        
        UD  = select_pse(UD,'STA: pseの選択');
        
        set(UD.fig,'UserData',UD);
        
    case 'show(sta)_average'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'average';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(sta)_average-on-BaseLine'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'average-on-BaseLine';
        
        UD  = select_pse(UD,'STA: pseの選択');
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
        
    case 'show(sta)_average-with-PSE'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'average-with-PSE';
        %         S   = load(fullfile(UD.parentpath,filenames{1}));
        %         S   = fieldnames(S);
        %         S   = strfilt(S,'pse');
        %         UD.psename      = uichoice(S,'PSEの選択');
        %         UD.psename      = inputdlg({'PSE Name: '},'Input PSE Name.',1,{'pse1'});
        %         UD.psename      = UD.psename{1};
        
        UD  = select_pse(UD,'STA: pseの選択');
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(sta)_average-with-PSE-adjusted'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'average-with-PSE-adjusted';
        UD  = select_pse(UD,'STA: pseの選択');
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(sta)_average-with-PSE-adjusted-percent'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'average-with-PSE-adjusted-percent';
        UD  = select_pse(UD,'STA: pseの選択');
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
        
    case 'show(sta)_average-with-PSE-adjusted-sd'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'average-with-PSE-adjusted-sd';
        UD  = select_pse(UD,'STA: pseの選択');
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
     case 'show(sta)_average-on-SD'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'average-on-SD';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(sta)_trials'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'trials';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(sta)_trials-arranged'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'trials-arranged';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
      case 'show(sta)_trials-cmap'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'trials-cmap';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(sta)_trials-surf'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'trials-surf';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
        
    case 'show(sta)_trials-contourf'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','off');
        
        UD.show_sta     = 'trials-contourf';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
        
    case 'show(sta)_trials-stack'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(sta)_average'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-BaseLine'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-percent'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-with-PSE-adjusted-sd'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_average-on-SD'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-surf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-contourf'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(sta)_trials-stack'),'Checked','on');
        
        UD.show_sta     = 'trials-stack';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
     
        
    case 'show(psth)_histogram'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(psth)_histogram'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(psth)__histogram-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-over-histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_instantaneous-frequency'),'Checked','off');
        
        UD.show_psth     = 'histogram';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(psth)_histogram-with-PSE'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(psth)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_histogram-with-PSE'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(psth)_raster'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-over-histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_instantaneous-frequency'),'Checked','off');
        
        UD.show_psth     = 'histogram-with-PSE';
        UD  = select_pse(UD,'PSTH: pseの選択');
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(psth)_raster'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(psth)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)__histogram-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(psth)_raster-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-over-histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_instantaneous-frequency'),'Checked','off');
        
        UD.show_psth     = 'raster';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(psth)_raster-arranged'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(psth)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)__histogram-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-arranged'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(psth)_raster-over-histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_instantaneous-frequency'),'Checked','off');
        
        UD.show_psth     = 'raster-arranged';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(psth)_raster-over-histogram'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(psth)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)__histogram-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-over-histogram'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(psth)_instantaneous-frequency'),'Checked','off');
        
        UD.show_psth     = 'raster-over-histogram';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(psth)_instantaneous-frequency'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(psth)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)__histogram-with-PSE'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-arranged'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_raster-over-histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(psth)_instantaneous-frequency'),'Checked','on');
        
        UD.show_psth     = 'instantaneous-frequency';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
        
    case 'show(fmcmp)_anova1'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(fmcmp)_anova1'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(fmcmp)_friedman'),'Checked','off');
        
        UD.show_fmcmp   = 'anova1';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(fmcmp)_friedman'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(fmcmp)_anova1'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(fmcmp)_friedman'),'Checked','on');
        
        UD.show_fmcmp   = 'friedman';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(anova1)_anova1'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(anova1)_anova1'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(anova1)_kruskalwallis'),'Checked','off');
        
        UD.show_anova1   = 'anova1';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(anova1)_kruskalwallis'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(anova1)_anova1'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(anova1)_kruskalwallis'),'Checked','on');
        
        UD.show_anova1   = 'kruskalwallis';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
        
    case 'show(mf)'
        UD  = get(gcf,'UserData');
        if(isempty(UD.psename))
            UD  = select_pse(UD,'MF: pseの選択');
        end
        
        if(~isempty(UD.psename))
            psename = UD.psename;
            nfile   = length(UD.filenames);
            for ifile =1:nfile
                S   = load(fullfile(UD.parentpath,UD.filenames{ifile}));
                if(isfield(S,'AnalysisType'))
                    if(strcmp(S.AnalysisType,'MF'))
                        break;
                    else
                        S   =[];
                    end
                end
            end
            
            if(~isempty(S))
                
                UD.show_mf  = fieldnames(S.(psename));
                UD.show_mf  = uichoice(UD.show_mf,'変数の選択');
                
                h   = sort(findobj(UD.fig,'Tag','axis'));
                UD.XLim = get(h,'XLim');
                UD.YLim = get(h,'YLim');
                
                set(UD.fig,'UserData',UD);
                plotData;
            end
        end
        
        
    case 'show(avemf)'
        UD  = get(gcf,'UserData');
        %         if(isempty(UD.psename))
        %             UD  = select_pse(UD,'AVEMF: pseの選択');
        %         end
        
        %         if(~isempty(UD.psename))
        %             psename = UD.psename;
        nfile   = length(UD.filenames);
        for ifile =1:nfile
            S   = load(fullfile(UD.parentpath,UD.filenames{ifile}));
            if(isfield(S,'AnalysisType'))
                if(strcmp(S.AnalysisType,'AVEMF'))
                    break;
                else
                    S   =[];
                end
            end
        end
        
        if(~isempty(S))
            
            %                 UD.show_avemf  = fieldnames(S.(psename));
            UD.show_avemf  = fieldnames(S);
            UD.show_avemf  = uichoice(UD.show_avemf,'変数の選択');
            
            h   = sort(findobj(UD.fig,'Tag','axis'));
            UD.XLim = get(h,'XLim');
            UD.YLim = get(h,'YLim');
            
            set(UD.fig,'UserData',UD);
            plotData;
        end
        %         end
        
    case 'show(emgpca)'
        UD  = get(gcf,'UserData');
        nfile   = length(UD.filenames);
        for ifile =1:nfile
            S   = load(fullfile(UD.parentpath,UD.filenames{ifile}));
            if(isfield(S,'AnalysisType'))
                if(strcmp(S.AnalysisType,'EMGPCA') || strcmp(S.AnalysisType,'EMGICA')|| strcmp(S.AnalysisType,'EMGNMF'))
                    break;
                else
                    S   =[];
                end
            end
        end
        
        if(~isempty(S))
            
            UD.show_emgpca  = fieldnames(S);
            nPCA    = size(S.coeff,1);
            for iPCA=1:nPCA
                UD.show_emgpca  = [UD.show_emgpca; ['coeff(',num2str(iPCA,'%0.2d'),')']];
            end
            UD.show_emgpca  = uichoice(UD.show_emgpca,'変数の選択');
            
            h   = sort(findobj(UD.fig,'Tag','axis'));
            UD.XLim = get(h,'XLim');
            UD.YLim = get(h,'YLim');
            
            set(UD.fig,'UserData',UD);
            plotData;
        end
        
    case 'show(avepca)'
        UD  = get(gcf,'UserData');
        nfile   = length(UD.filenames);
        for ifile =1:nfile
            S   = load(fullfile(UD.parentpath,UD.filenames{ifile}));
            if(isfield(S,'AnalysisType'))
                if(strcmp(S.AnalysisType,'AVEPCA'))
                    break;
                else
                    S   =[];
                end
            end
        end
        
        if(~isempty(S))
            
            UD.show_avepca  = fieldnames(S);
            nPCA    = size(S.coeff,1);
            for iPCA=1:nPCA
                UD.show_avepca  = [UD.show_avepca; ['coeff(',num2str(iPCA,'%0.2d'),')']];
            end
            UD.show_avepca  = uichoice(UD.show_avepca,'変数の選択');
            
            h   = sort(findobj(UD.fig,'Tag','axis'));
            UD.XLim = get(h,'XLim');
            UD.YLim = get(h,'YLim');
            
            set(UD.fig,'UserData',UD);
            plotData;
        end
        
        
    case 'show(covmtx)'
        UD  = get(gcf,'UserData');
        nfile   = length(UD.filenames);
        for ifile =1:nfile
            S   = load(fullfile(UD.parentpath,UD.filenames{ifile}));
            if(isfield(S,'AnalysisType'))
                if(strcmp(S.AnalysisType,'COVMTX'))
                    break;
                else
                    S   =[];
                end
            end
        end
        
        if(~isempty(S))
            OneToOne_flag   = false;
            if(isfield(S,'OneToOne_flag'))
                if(S.OneToOne_flag)
                    OneToOne_flag   = true;
                end
            end
            
            if(~OneToOne_flag)
                
                UD.show_covmtx  = fieldnames(S);
                UD.show_covmtx  = [UD.show_covmtx; 'corrcoef^2'; 'corrcoef (vs Spike)'; 'xcorr(wave)'; 'xcorr(wave)(lag reverse)'];
            else
                UD.show_covmtx  = fieldnames(S);
                UD.show_covmtx  = [UD.show_covmtx; 'corrcoef^2'; 'xcorr(wave)'; 'xcorr(wave)(lag reverse)'];
                
            end
            
            UD.show_covmtx  = uichoice(UD.show_covmtx,'変数の選択');
            
            h   = sort(findobj(UD.fig,'Tag','axis'));
            UD.XLim = get(h,'XLim');
            UD.YLim = get(h,'YLim');
            
            set(UD.fig,'UserData',UD);
            plotData;
        end
        
    case 'show(avecov)'
        UD  = get(gcf,'UserData');
        nfile   = length(UD.filenames);
        for ifile =1:nfile
            S   = load(fullfile(UD.parentpath,UD.filenames{ifile}));
            if(isfield(S,'AnalysisType'))
                if(strcmp(S.AnalysisType,'AVECOV'))
                    break;
                else
                    S   =[];
                end
            end
        end
        
        if(~isempty(S))
            
            UD.show_avecov  = fieldnames(S);
            UD.show_avecov  = uichoice(UD.show_avecov,'AVECOV: 変数の選択');
            
            h   = sort(findobj(UD.fig,'Tag','axis'));
            UD.XLim = get(h,'XLim');
            UD.YLim = get(h,'YLim');
            
            set(UD.fig,'UserData',UD);
            plotData;
        end
        
    case 'show(coh)_Cxy'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(coh)_Cxy'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(coh)_Pxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Pyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Phase'),'Checked','off');
        
        UD.show_coh     = 'Cxy';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(coh)_Pxx'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(coh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Pxx'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(coh)_Pyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Phase'),'Checked','off');
        
        UD.show_coh     = 'Pxx';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(coh)_Pyy'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(coh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Pxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Pyy'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(coh)_Phase'),'Checked','off');
        
        
        UD.show_coh     = 'Pyy';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(coh)_Phase'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(coh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Pxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Pyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(coh)_Phase'),'Checked','on');
        
        
        UD.show_coh     = 'Phase';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
        
    case 'show(dcoh)_Cyx'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyx'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyy'),'Checked','off');
        
        
        UD.show_dcoh    = 'Cyx';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(dcoh)_Cxy'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxy'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyy'),'Checked','off');
        
        
        UD.show_dcoh    = 'Cxy';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(dcoh)_Cxx'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyx'),'Checked','of');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxx'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyy'),'Checked','off');
        
        
        UD.show_dcoh    = 'Cxx';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(dcoh)_Cyy'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyy'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyy'),'Checked','off');
        
        
        UD.show_dcoh    = 'Cyy';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(dcoh)_Phaseyx'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyx'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyy'),'Checked','off');
        
        
        UD.show_dcoh    = 'Phaseyx';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(dcoh)_Phasexy'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexy'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyy'),'Checked','off');
        
        
        UD.show_dcoh    = 'Phasexy';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(dcoh)_Phasexx'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexx'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyy'),'Checked','off');
        
        
        UD.show_dcoh    = 'Phasexx';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(dcoh)_Phaseyy'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cxx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Cyy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexy'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phasexx'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(dcoh)_Phaseyy'),'Checked','on');
        
        
        UD.show_dcoh    = 'Phaseyy';
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
        
    case 'show(scat)_scatter'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(scat)_scatter'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-sorted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-on-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_polar'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramXData'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramYData'),'Checked','off');
        
        UD.show_scat    = 'scatter';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(scat)_scatter-sorted'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(scat)_scatter'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-sorted'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(scat)_cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-on-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_polar'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramXData'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramYData'),'Checked','off');
        
        UD.show_scat    = 'scatter-sorted';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(scat)_cmap'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(scat)_scatter'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-sorted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_cmap'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-on-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_polar'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramXData'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramYData'),'Checked','off');
        
        UD.show_scat    = 'cmap';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(scat)_scatter-on-cmap'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(scat)_scatter'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-sorted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-on-cmap'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(scat)_polar'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramXData'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramYData'),'Checked','off');
        
        UD.show_scat    = 'scatter-on-cmap';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(scat)_polar'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(scat)_scatter'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-sorted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-on-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_polar'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(scat)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramXData'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramYData'),'Checked','off');
        
        UD.show_scat    = 'polar';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(scat)_histogram'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(scat)_scatter'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-sorted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-on-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_polar'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogram'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(scat)_histogramXData'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramYData'),'Checked','off');
        
        UD.show_scat    = 'histogram';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(scat)_histogramXData'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(scat)_scatter'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-sorted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-on-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_polar'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramXData'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(scat)_histogramYData'),'Checked','off');
        
        UD.show_scat    = 'histogramXData';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(scat)_histogramYData'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(scat)_scatter'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-sorted'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_scatter-on-cmap'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_polar'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogram'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramXData'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(scat)_histogramYData'),'Checked','on');
        
        UD.show_scat    = 'histogramYData';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(hist)_bar'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(hist)_bar'),'Checked','on');
        set(findobj(UD.fig,'Tag','show(hist)_pie'),'Checked','off');
        
        UD.show_hist    = 'bar';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'show(hist)_pie'
        
        UD  = get(gcf,'UserData');
        
        set(findobj(UD.fig,'Tag','show(hist)_bar'),'Checked','off');
        set(findobj(UD.fig,'Tag','show(hist)_pie'),'Checked','on');
        
        UD.show_hist    = 'pie';
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        plotData;
        
    case 'rowcol'
        
        UD  = get(gcf,'UserData');
        myh = gcbo;
        h   = get(findobj(UD.fig,'Tag','rowcol'),'Children');
        
        set(h,'Checked','off');
        set(myh,'Checked','on');
        
        
        UD.rowcol   = get(myh,'Tag');
        
        if(strcmp(UD.rowcol,'custom'))
            
            nfiles  = length(UD.filenames);
            nn      = inputdlg({'nrow','ncol'},'座標を定義してください。',1,{'3','3'});
            UD.rowcol   = ['custom_',nn{1},'_',nn{2}];
            
            nrow    = str2double(nn{1});
            ncol    = str2double(nn{2});
            
            prompt  = cell(1,nrow*ncol);
            dans    = prompt;
            %             [irow,icol] = meshgrid(1:nrow,1:ncol);
            rowcolind   = 1:(nrow*ncol);
            rowcolind   = reshape(rowcolind,ncol,nrow)';
            rowcolind   = rowcolind(:);
            
            ii = 0;
            for icol =1:str2double(nn{2})
                for irow =1:str2double(nn{1})
                    ii  = ii + 1;
                    prompt{ii}  = ['(',num2str(irow),',',num2str(icol),')'];
                    if(ii<=nfiles)
                        dans{ii}    = num2str(ii);
                    else
                        dans{ii}    = '';
                    end
                end
            end
            nn  = inputdlg(prompt,'配置してください。',1,dans);
            
            nfiles          = length(strvcat(nn));
            UD.rowcolind    = zeros(1,nfiles);
            for ifile = 1:nfiles
                temp    = strcmp(nn,num2str(ifile));
                if(any(temp))
                    temp    = rowcolind(temp);
                    UD.rowcolind(ifile) = temp(1);
                end
            end
            
            
            
            
        else
            if(strcmp(UD.rowcol(end),'n'))
                nn=inputdlg({UD.rowcol(1:end-1)},'数を入力して下さい。',1,{'6'});
                UD.rowcol    = [UD.rowcol(1:3),nn{1}];
            end
        end
        
        h   = sort(findobj(UD.fig,'Tag','axis'));
        UD.XLim = get(h,'XLim');
        UD.YLim = get(h,'YLim');
        
        set(UD.fig,'UserData',UD);
        drawAxes;
        loadData;
        plotData;
        
        
    case 'plotData'
        plotData(varargin{1})
        
end
end

function UD = select_pse(UD,str)
%         UD  = get(gcf,'UserData');
nfile   = length(UD.filenames);
S       = [];
for ifile =1:nfile
    try
        S   = load(fullfile(UD.parentpath,UD.filenames{ifile}));
        S   = fieldnames(S);
        S   = strfilt(S,'pse');
        if(~isempty(S))
            break;
        end
    
    end
end

if(~isempty(S))
    UD.psename  = uichoice(S,str);
    set(UD.fig,'UserData',UD);
end
end

function setSwitchToNear_menu
UD      = get(gcf,'UserData');
%         keyboard
neardir  = dirdir(UD.grandparentpath);

ndir    = length(neardir);
nrow    = 40;
ncol    = ceil(ndir./nrow);

a   = findobj(UD.fig,'Tag','display_SwitchToNear');

delete(findobj(UD.fig,'Tag','NearDirs'));

[grandparentpath,parentpath]    = fileparts(UD.parentpath);
ind = strmatch(parentpath,neardir);

idir    = 0;
for icol=1:ncol
    if(icol<ncol)
        b   = uimenu(a,'Label','More','Checked','off','Callback',[],'Enable','on','Tag','NearDirs');
    else
        b   = a;
    end
    
    if(icol==1)
        uimenu(a,'Label','Previous...',...
            'Accelerator','r',...
            'Checked','off',...
            'Callback','displaydata(''SwitchToPrevious'')',...
            'Enable','on',...
            'Tag','NearDirs');
        uimenu(a,'Label','Next...',...
            'Accelerator','t',...
            'Checked','off',...
            'Callback','displaydata(''SwitchToNext'')',...
            'Enable','on','Tag',...
            'NearDirs');
    end
    
    
    for irow    =1:nrow
        idir    = idir+1;
        if(idir<=ndir)
            
            c   = uimenu(a,'Label',neardir{idir},'Checked','off','Callback','displaydata(''SwitchToNear'')','Enable','on','Tag','NearDirs');
            if(irow==1 && icol<ncol)
                set(c,'Separator','On')
            end
            if(idir==ind)
                set(c,'Checked','On')
            end
        end
    end
    a   = b;
end
end

function drawAxes
UD      = get(gcf,'UserData');
nfiles  = length(UD.filenames);
delete(findobj(UD.fig,'Type','axes'));

% Axesを事前に用意
subplotdir  = UD.rowcol(1:3);
subplotn    = UD.rowcol(4:end);
switch subplotdir
    case 'col'
        ncol    = str2double(subplotn);
        nrow    = ceil(nfiles./ncol);
        naxes   = ncol*nrow;
        rowcolind   = reshape(reshape(1:naxes,ncol,nrow)',1,naxes);
    case 'row'
        nrow    = str2double(subplotn);
        ncol    = ceil(nfiles./nrow);
        naxes   = ncol*nrow;
        rowcolind   = 1:naxes;
    case 'cus'
        ind     = strfind(subplotn,'_');
        nrow    = str2double(subplotn(ind(1)+1:ind(2)-1));
        ncol    = str2double(subplotn(ind(2)+1:end));
        naxes   = ncol*nrow;
        rowcolind   = UD.rowcolind;
        
end
h       = nan(1,nfiles);
hrowcol = nan(nfiles,2);
for ii=1:nfiles
    if(ii>length(rowcolind))
        continue;
    end
    if(rowcolind(ii)==0)
        continue;
    end
    h(ii)   = tsubplot(nrow,ncol,rowcolind(ii),'Parent',UD.fig,...
        'Box','off',...
        'Color',[1 1 1],...
        'FontName','Arial',...
        'NextPlot','replacechildren',...
        'TickDir','Out',...
        'XTickLabelMode','Manual',...
        'XTickLabel',[],...
        'UserData',[],...
        'Tag','axis');
    set(get(h(ii),'Title'),'Units','Normalized','BackGroundColor',[1 1 1],'FontName','Arial','FontSize',9,'HorizontalAlignment','right','Margin',0.01,'Position',[1.0 1.0],'String',[],'VerticalAlignment','Bottom');
    goback(get(h(ii),'Title'))
    set(get(h(ii),'YLabel'),'BackGroundColor',[1 1 1],'FontName','Arial','FontSize',9,'HorizontalAlignment','center','String',[],'VerticalAlignment','Bottom');
    set(get(h(ii),'XLabel'),'BackGroundColor',[1 1 1],'FontName','Arial','FontSize',9,'HorizontalAlignment','center','String',[],'VerticalAlignment','Cap');
    hrowcol(ii,:) = [floor((rowcolind(ii)-1)./ncol) + 1,mod(rowcolind(ii)-1,ncol) + 1];
    
end
%         h(h==0) =[];
%         hrowcol(hrowcol(:,1)==0,:) =[];
%         nfiles  = length(h);

ind = 1:nfiles;

% 各行で一番左にあるとき
for jj  = shiftdim(unique(hrowcol(:,1)))'
    if(isnan(jj))
        continue;
    end
    ii  = ind(hrowcol(:,1)==jj & hrowcol(:,2)==min(hrowcol(hrowcol(:,1)==jj,2)));
    ylabel(h(ii),'Y');
end

% 各列で一番下にあるとき
for jj  = shiftdim(unique(hrowcol(:,2)))'
    if(isnan(jj))
        continue;
    end
    ii  = ind(hrowcol(:,2)==jj & hrowcol(:,1)==max(hrowcol(hrowcol(:,2)==jj,1)));
    xlabel(h(ii),'X');
    set(h(ii),'XTickLabelMode','Auto');
end


UD.h        = h;
UD.hrowcol  = hrowcol;
set(UD.fig,'UserData',UD);

end

function loadData
UD      = get(gcf,'UserData');
nfiles  = length(UD.filenames);
UD.Data = cell(nfiles,1);
UD.subData  = cell(nfiles,1);

for ifiles=1:nfiles
    filename    = UD.filenames{ifiles};
    
    if(strcmp(filename,'<blank>'))
        S.identifier    = '<blank>';
        UD.Data{ifiles} = S;
    else
        fullfilename    = fullfile(UD.parentpath,[filename,'.mat']);
        guiindicator(UD.fig,ifiles-1,nfiles,['loading ', filename]);
        
        try
%             UD.Data{ifiles} = load(fullfilename);
            UD.Data{ifiles} = loaddata(fullfilename,'-full');
        catch
            UD.Data{ifiles} = lasterror;
        end
    end
end


set(UD.fig,'UserData',UD);
guiindicator(UD.fig,0,0)
end

function plotData(hAxes)
UD      = get(gcf,'UserData');
%         figure(UD.fig);

if(nargin<1)
    hAxes   = UD.h;
end

[temp,dirname] = fileparts(UD.parentpath);

set(UD.fig,'Name',['Channel Display for ',dirname,'(',temp,')'],...
    'FileName',['Channel Display for ',dirname,'(',temp,')']);

nAxes   = length(UD.h);
Axesind = 1:nAxes;
Axesind = Axesind(ismember(UD.h,hAxes));
nAxes   = length(Axesind);


for iAxes=1:nAxes
    ifiles      = Axesind(iAxes);
    
    filename    = UD.filenames{ifiles};
    guiindicator(UD.fig,iAxes-1,nAxes,['drawing ', filename]);
    hAx         = UD.h(ifiles);
    
    try
        S   = UD.Data{ifiles};
        if(isfield(S,'identifier')) % もしデータロードでエラーがあったら、、、
            H   = get(hAx,'Children');
            delete(H);
            set(get(hAx,'Title'),'String',S.identifier);
            continue;
        else
            set(hAx,'Nextplot','replacechildren')
            H   = get(hAx,'Children');
            delete(H);
        end
        
        if (isfield(S,'AnalysisType') && ~strcmp(S.AnalysisType,'STACONV'))               %% [Analysis file] or Data file
            switch S.AnalysisType
                %% STA
                case 'STA'                             % STA
                    show_sta    = UD.show_sta;
%                     YUnit   = '%base';  % Y軸をbasemeanの％表示にしたければ、ここを使う。
%                     sYUnit   = '%max';  % Y軸を％max表示にしたければ、ここを使う。
                    if(~isfield(S,'Unit'))
                        S.Unit  = '';
                    end
                    
                    switch show_sta
                        case 'average'
                            
                            if((isfield(S,'TrialsToUse') && isfield(S,'data_file')) || UD.Slider.On)
                                if(isempty(UD.subData{ifiles}))
                                    datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                    if(exist(datafile,'file'))
                                        SS      = load(datafile,'TrialData');
                                        UD.subData{ifiles}  = SS.TrialData;
                                    elseif(~isempty(S.TrialData))
                                        UD.subData{ifiles}  = S.TrialData;
                                    end
                                end
                                
                                
                                if(isfield(S,'TrialsToUse'))
                                    if(isempty(S.TrialsToUse))
                                        TrialsToUse = 1:size(UD.subData{ifiles},1);
                                    else
                                        TrialsToUse = S.TrialsToUse;
                                    end
                                else
                                    TrialsToUse = 1:size(UD.subData{ifiles},1);
                                end
                                
                                YData   = UD.subData{ifiles};
                                YData   = YData(TrialsToUse,:);
                                nTrials = size(YData,1);
                                
                                if(UD.Slider.On)
                                    StartIndex  = max(1,UD.Slider.StartIndex);
                                    StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                    
                                    YData       = YData(StartIndex:StopIndex,:);
                                    nDispTrials = size(YData,1);
                                    
                                end
                                
                                YData   = mean(YData,1);
                                
                                XData   = S.XData;
                                YUnit   = S.Unit;
                            else
                                YData   = S.YData;
                                XData   = S.XData;
                                YUnit   = S.Unit;
                                nTrials = S.nTrials;
                            end
                            
                            if(exist('sYUnit','var'))
                                switch sYUnit
                                    case '%max'
                                        YData   = YData./max(YData);
                                        YUnit   = sYUnit;
                                end
                            end
                            
                            hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                            
                        case 'average-on-SD'
                            
                            if(isempty(UD.subData{ifiles}))
                                datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                SS      = load(datafile,'TrialData');
                                UD.subData{ifiles}  = SS.TrialData;
                            end
                            
                            if(isfield(S,'TrialsToUse'))
                                if(isempty(S.TrialsToUse))
                                    TrialsToUse = 1:size(UD.subData{ifiles},1);
                                else
                                    TrialsToUse = S.TrialsToUse;
                                end
                            else
                                TrialsToUse = 1:size(UD.subData{ifiles},1);
                            end
                            YData   = UD.subData{ifiles};
                            YData   = YData(TrialsToUse,:);
                            nTrials = size(YData,1);
                            
                            if(UD.Slider.On)
                                StartIndex  = max(1,UD.Slider.StartIndex);
                                StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                
                                YData       = YData(StartIndex:StopIndex,:);
                                nDispTrials = size(YData,1);
                                
                            end
                            
                            YData_Std   = std(YData,0,1);
                            %                                 YData_Std   = std(YData,0,1) ./ sqrt(nTrials);
                            YData   = mean(YData,1);
                            
                            
                            XData   = S.XData;
                            YUnit   = S.Unit;
                            %                             keyboard
                            
                            hL  = terrorarea(hAx,XData,YData,YData_Std,'Color',[0 0 0],'Tag','data');
                            show_sta    = 'average';
                            %                             hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                            
                            
                        case 'average-on-BaseLine'
                            YData   = S.YData;
                            XData   = S.XData;
                            YUnit   = S.Unit;
                            if(isempty(UD.psename))
                                psename = strfilt(fieldnames(S),'pse');
                                psename = psename{1};
                                UD.psename = psename;
                            else
                                psename = UD.psename;
                            end
                            if(isfield(S,psename))
                                PSES    = S.(psename);
                                
                                
                                hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                set(hAx,'Nextplot','add');
                                
                                if(~isfield(PSES,'BaseLine'))
                                    BaseLine    = S.ISAData;
                                    BaseLine    = BaseLine+mean(S.YData(PSES.base.ind)-BaseLine(PSES.base.ind));
                                else
                                    BaseLine    = PSES.BaseLine;
                                end
                                
                                %
                                tdsplot(hAx,XData,BaseLine,'Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine+PSES.nsd(1)*PSES.base.sd,'--','Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine-PSES.nsd(1)*PSES.base.sd,'--','Color',[0.75 0 0]);
                                if(~strcmp(YUnit,'sps'))
                                    gofront(hL)
                                end
                                set(hAx,'Nextplot','replacechildren');
                            else
                                show_sta    = 'average';
                                YData   = S.YData;
                                XData   = S.XData;
                                YUnit   = S.Unit;
                                %
                                %                                     if(strcmp(YUnit,'sps'))
                                %                                         hL  = area(hAx,XData,YData,'EdgeColor',[0 0 0],'FaceColor','none','LineWidth',1);
                                %                                     else
                                hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                %                                     end
                            end
                        case 'average-with-PSE'
                            YData   = S.YData;
                            XData   = S.XData;
                            
                            YUnit   = S.Unit;
                            
                            if(isempty(UD.psename))
                                psename = strfilt(fieldnames(S),'pse');
                                psename = psename{1};
                                UD.psename = psename;
                            else
                                psename = UD.psename;
                            end
                            
                            if(isfield(S,psename))
                                PSES    = S.(psename);
                                hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                set(hAx,'Nextplot','add');
                                
                                if(~isfield(PSES,'BaseLine'))
                                    BaseLine    = S.ISAData;
                                    BaseLine    = BaseLine+mean(S.YData(PSES.base.ind)-BaseLine(PSES.base.ind));
                                else
                                    BaseLine    = PSES.BaseLine;
                                end
                                
                                plot(hAx,XData,BaseLine,'Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine+PSES.nsd(1)*PSES.base.sd,'--','Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine-PSES.nsd(1)*PSES.base.sd,'--','Color',[0.75 0 0]);
                                if(~isempty(PSES.nsigpeaks))
                                    if(~isfield(PSES,'search_TimeWindow'))
                                        for ipeaks=1:PSES.nsigpeaks
                                            ind = PSES.sigpeakind(ipeaks);
                                            xdata   = XData(PSES.peaks(ind).ind);
                                            ydata   = YData(PSES.peaks(ind).ind);
                                            baseline    = BaseLine(PSES.peaks(ind).ind);
                                            
                                            color   = [0.5 0.5 0.5]; % light gray
                                            if(isfield(S,'isXtalk'))
                                                if(PSES.isXtalk==0)
                                                    color   = [0 1 1];  % cyan
                                                else
                                                    color   = [1 1 0];  % yellow
                                                end
                                            end
                                            hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                            goback(hA)
                                            
                                        end
                                    else
                                        %                                     set(hAx,'Color',[1.0 0.98 0.98])
                                        min_YData   = min(YData);
                                        max_YData   = max(YData);
                                        %                                             hF  = fill([PSES.search_TimeWindow(1) PSES.search_TimeWindow(2) PSES.search_TimeWindow(2) PSES.search_TimeWindow(1)],[min_YData min_YData max_YData max_YData],[0.9 0.9 0.9],'Parent',hAx,'EdgeColor',[0.9 0.9 0.9]);
                                        
                                        if(~isempty(PSES.sigpeakindTW))
                                            for ipeaks=1:PSES.nsigpeaksTW
                                                ind = PSES.sigpeakindTW(ipeaks);
                                                %                                         if(~isempty(PSES.maxsigpeakindTW))
                                                %                                             ind = PSES.maxsigpeakindTW;
                                                xdata   = XData(PSES.peaks(ind).ind);
                                                ydata   = YData(PSES.peaks(ind).ind);
                                                baseline = BaseLine(PSES.peaks(ind).ind);
                                                
                                                if(ind==PSES.maxsigpeakindTW)
                                                    if(isfield(PSES,'isXtalk'))
                                                        if(PSES.isXtalk==0)
                                                            color   = [0 1 1];
                                                        else
                                                            color   = [1 1 0];
                                                        end
                                                    else
                                                        color   = [0.5 0.5 0.5];    % gray
                                                    end
                                                else
                                                    color   = [0.75 0.75 0.75];    % light gray
                                                    
                                                end
                                                hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                                goback(hA)
                                            end
                                        end
                                        %                                             goback(hF)
                                        
                                    end
                                    
                                end
                                
                                gofront(hL)
                                set(hAx,'Nextplot','replacechildren');
                                
                            else
                                show_sta    = 'average';
                                YData   = S.YData;
                                XData   = S.XData;
                                YUnit   = S.Unit;
                                nTrials = S.nTrials;
                                StartIndex  = 1;
                                
                                hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                
                            end
                        case 'average-with-PSE-adjusted'
                            if(isempty(UD.psename))
                                psename = strfilt(fieldnames(S),'pse');
                                if(iscell(psename))
                                    psename = psename{1};
                                end
                                UD.psename = psename;
                            else
                                psename = UD.psename;
                            end
                            
                            if(isfield(S,psename))
                                PSES    = S.(psename);
                                if(~isfield(PSES,'BaseLine'))
                                    BaseLine    = S.ISAData;
                                    BaseLine    = BaseLine+mean(S.YData(PSES.base.ind)-BaseLine(PSES.base.ind));
                                else
                                    BaseLine    = PSES.BaseLine;
                                end
                                
                                YData   = S.YData - BaseLine + PSES.base.mean;
                                BaseLine    = ones(size(YData))*PSES.base.mean;
                                
                                
                                XData   = S.XData;
                                
%                                 if(exist('YUnit','var'))
%                                     switch YUnit
%                                         case '%base'
%                                             basemean    = PSES.base.mean;
%                                             YData       = YData ./ basemean *100;
%                                             BaseLine    = BaseLine ./ basemean *100;
%                                             PSES.base.sd    = PSES.base.sd ./ basemean *100;
%                                             PSES.base.mean  = PSES.base.mean ./ basemean *100;
%                                             
%                                         otherwise
%                                             YUnit   = S.Unit;
%                                     end
%                                 else
                                    YUnit   = S.Unit;
%                                 end
                                
                                hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                
                                set(hAx,'Nextplot','add');
                                
                                plot(hAx,XData,BaseLine,'Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine+PSES.nsd*PSES.base.sd,'--','Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine-PSES.nsd*PSES.base.sd,'--','Color',[0.75 0 0]);
                                if(~isempty(PSES.nsigpeaks))
                                    if(~isfield(PSES,'search_TimeWindow'))
                                        for ipeaks=1:PSES.nsigpeaks
                                            ind = PSES.sigpeakind(ipeaks);
                                            xdata   = XData(PSES.peaks(ind).ind);
                                            ydata   = YData(PSES.peaks(ind).ind);
                                            baseline = BaseLine(PSES.peaks(ind).ind);
                                            
                                            color   = [0.5 0.5 0.5]; % light gray
                                            if(isfield(S,'isXtalk'))
                                                if(PSES.isXtalk==0)
                                                    color   = [0 1 1];  % cyan
                                                else
                                                    color   = [1 1 0];  % yellow
                                                end
                                            end
                                            hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                            goback(hA)
                                        end
                                    else
                                        %                                     set(hAx,'Color',[1.0 0.98 0.98])
                                        min_YData   = min(YData);
                                        max_YData   = max(YData);
                                        %                                             hF  = fill([PSES.search_TimeWindow(1) PSES.search_TimeWindow(2) PSES.search_TimeWindow(2) PSES.search_TimeWindow(1)],[min_YData min_YData max_YData max_YData],[0.9 0.9 0.9],'Parent',hAx,'EdgeColor',[0.9 0.9 0.9]);
                                        
                                        %                                         for ipeaks=1:PSES.nsigpeaksTW
                                        %                                             ind = PSES.sigpeakindTW(ipeaks);
                                        if(~isempty(PSES.maxsigpeakindTW))
                                            ind = PSES.maxsigpeakindTW;
                                            xdata   = XData(PSES.peaks(ind).ind);
                                            ydata   = YData(PSES.peaks(ind).ind);
                                            baseline = BaseLine(PSES.peaks(ind).ind);
                                            
                                            color   = [0.5 0.5 0.5];    % gray
                                            if(isfield(PSES,'isXtalk'))
                                                if(PSES.isXtalk==0)
                                                    color   = [0 1 1];
                                                else
                                                    color   = [1 1 0];
                                                end
                                            end
                                            hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                            goback(hA)
                                            
                                        end
                                        %                                             goback(hF)
                                    end
                                    
                                end
                                
                                gofront(hL)
                                set(hAx,'Nextplot','replacechildren');
                                
                            else
                                show_sta    = 'average';
                                YData   = S.YData;
                                XData   = S.XData;
                                YUnit   = S.Unit;
                                nTrials = S.nTrials;
                                
                                if(strcmp(YUnit,'sps'))
                                    hL  = area(hAx,XData,YData,'EdgeColor',[0 0 0],'FaceColor',[0 0 0.5],'Tag','data');
                                else
                                    hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                end
                            end
                            
                            
                            case 'average-with-PSE-adjusted-percent'
                            if(isempty(UD.psename))
                                psename = strfilt(fieldnames(S),'pse');
                                if(iscell(psename))
                                    psename = psename{1};
                                end
                                UD.psename = psename;
                            else
                                psename = UD.psename;
                            end
                            
                            if(isfield(S,psename))
                                PSES    = S.(psename);
                                if(~isfield(PSES,'BaseLine'))
                                    BaseLine    = S.ISAData;
                                    BaseLine    = BaseLine+mean(S.YData(PSES.base.ind)-BaseLine(PSES.base.ind));
                                else
                                    BaseLine    = PSES.BaseLine;
                                end
                                
                                YData   = S.YData - BaseLine + PSES.base.mean;
                                BaseLine    = ones(size(YData))*PSES.base.mean;
                                
                                
                                XData   = S.XData;
                                
%                                 if(exist('YUnit','var'))
%                                     switch YUnit
%                                         case '%base'
                                            basemean    = PSES.base.mean;
                                            YData       = YData ./ basemean *100;
                                            BaseLine    = BaseLine ./ basemean *100;
                                            PSES.base.sd    = PSES.base.sd ./ basemean *100;
                                            PSES.base.mean  = PSES.base.mean ./ basemean *100;
                                            YUnit       = '%';
%                                         otherwise
%                                             YUnit   = S.Unit;
%                                     end
%                                 else
%                                     YUnit   = S.Unit;
%                                 end
                                
                                hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                
                                set(hAx,'Nextplot','add');
                                
                                plot(hAx,XData,BaseLine,'Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine+PSES.nsd*PSES.base.sd,'--','Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine-PSES.nsd*PSES.base.sd,'--','Color',[0.75 0 0]);
                                if(~isempty(PSES.nsigpeaks))
                                    if(~isfield(PSES,'search_TimeWindow'))
                                        for ipeaks=1:PSES.nsigpeaks
                                            ind = PSES.sigpeakind(ipeaks);
                                            xdata   = XData(PSES.peaks(ind).ind);
                                            ydata   = YData(PSES.peaks(ind).ind);
                                            baseline = BaseLine(PSES.peaks(ind).ind);
                                            
                                            color   = [0.5 0.5 0.5]; % light gray
                                            if(isfield(S,'isXtalk'))
                                                if(PSES.isXtalk==0)
                                                    color   = [0 1 1];  % cyan
                                                else
                                                    color   = [1 1 0];  % yellow
                                                end
                                            end
                                            hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                            goback(hA)
                                        end
                                    else
                                        %                                     set(hAx,'Color',[1.0 0.98 0.98])
                                        min_YData   = min(YData);
                                        max_YData   = max(YData);
                                        %                                             hF  = fill([PSES.search_TimeWindow(1) PSES.search_TimeWindow(2) PSES.search_TimeWindow(2) PSES.search_TimeWindow(1)],[min_YData min_YData max_YData max_YData],[0.9 0.9 0.9],'Parent',hAx,'EdgeColor',[0.9 0.9 0.9]);
                                        
                                        %                                         for ipeaks=1:PSES.nsigpeaksTW
                                        %                                             ind = PSES.sigpeakindTW(ipeaks);
                                        if(~isempty(PSES.maxsigpeakindTW))
                                            ind = PSES.maxsigpeakindTW;
                                            xdata   = XData(PSES.peaks(ind).ind);
                                            ydata   = YData(PSES.peaks(ind).ind);
                                            baseline = BaseLine(PSES.peaks(ind).ind);
                                            
                                            color   = [0.5 0.5 0.5];    % gray
                                            if(isfield(PSES,'isXtalk'))
                                                if(PSES.isXtalk==0)
                                                    color   = [0 1 1];
                                                else
                                                    color   = [1 1 0];
                                                end
                                            end
                                            hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                            goback(hA)
                                            
                                        end
                                        %                                             goback(hF)
                                    end
                                    
                                end
                                
                                gofront(hL)
                                set(hAx,'Nextplot','replacechildren');
                                
                            else
                                show_sta    = 'average';
                                YData   = S.YData;
                                XData   = S.XData;
                                YUnit   = S.Unit;
                                nTrials = S.nTrials;
                                
                                if(strcmp(YUnit,'sps'))
                                    hL  = area(hAx,XData,YData,'EdgeColor',[0 0 0],'FaceColor',[0 0 0.5],'Tag','data');
                                else
                                    hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                end
                            end
                            
                            
                            case 'average-with-PSE-adjusted-sd'
                            if(isempty(UD.psename))
                                psename = strfilt(fieldnames(S),'pse');
                                if(iscell(psename))
                                    psename = psename{1};
                                end
                                UD.psename = psename;
                            else
                                psename = UD.psename;
                            end
                            
                            if(isfield(S,psename))
                                PSES    = S.(psename);
                                if(~isfield(PSES,'BaseLine'))
                                    BaseLine    = S.ISAData;
                                    BaseLine    = BaseLine+mean(S.YData(PSES.base.ind)-BaseLine(PSES.base.ind));
                                else
                                    BaseLine    = PSES.BaseLine;
                                end
                                
                                YData   = S.YData - BaseLine + PSES.base.mean;
                                BaseLine    = ones(size(YData))*PSES.base.mean;
                                
                                
                                XData   = S.XData;
                                
%                                 if(exist('YUnit','var'))
%                                     switch YUnit
%                                         case '%base'
%                                             basemean    = PSES.base.mean;
%                                             YData       = YData ./ basemean *100;
%                                             BaseLine    = BaseLine ./ basemean *100;
%                                             PSES.base.sd    = PSES.base.sd ./ basemean *100;
%                                             PSES.base.mean  = PSES.base.mean ./ basemean *100;
%                                             YUnit       = '%';
%                                          case 'sd'
                
%                                             basemean    = PSES.base.mean;
                                            YData       = (YData - PSES.base.mean) ./ PSES.base.sd;
                                            BaseLine    = BaseLine - PSES.base.mean;
                                            PSES.base.sd    = PSES.base.sd ./ PSES.base.sd;
                                            PSES.base.mean  = PSES.base.mean - PSES.base.mean;
                                            YUnit       = 'sd';
%                                         otherwise
%                                             YUnit   = S.Unit;
%                                     end
%                                 else
%                                     YUnit   = S.Unit;
%                                 end
                                
                                hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                
                                set(hAx,'Nextplot','add');
                                
                                plot(hAx,XData,BaseLine,'Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine+PSES.nsd*PSES.base.sd,'--','Color',[0.75 0 0]);
                                plot(hAx,XData,BaseLine-PSES.nsd*PSES.base.sd,'--','Color',[0.75 0 0]);
                                if(~isempty(PSES.nsigpeaks))
                                    if(~isfield(PSES,'search_TimeWindow'))
                                        for ipeaks=1:PSES.nsigpeaks
                                            ind = PSES.sigpeakind(ipeaks);
                                            xdata   = XData(PSES.peaks(ind).ind);
                                            ydata   = YData(PSES.peaks(ind).ind);
                                            baseline = BaseLine(PSES.peaks(ind).ind);
                                            
                                            color   = [0.5 0.5 0.5]; % light gray
                                            if(isfield(S,'isXtalk'))
                                                if(PSES.isXtalk==0)
                                                    color   = [0 1 1];  % cyan
                                                else
                                                    color   = [1 1 0];  % yellow
                                                end
                                            end
                                            hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                            goback(hA)
                                        end
                                    else
                                        %                                     set(hAx,'Color',[1.0 0.98 0.98])
                                        min_YData   = min(YData);
                                        max_YData   = max(YData);
                                        %                                             hF  = fill([PSES.search_TimeWindow(1) PSES.search_TimeWindow(2) PSES.search_TimeWindow(2) PSES.search_TimeWindow(1)],[min_YData min_YData max_YData max_YData],[0.9 0.9 0.9],'Parent',hAx,'EdgeColor',[0.9 0.9 0.9]);
                                        
                                        %                                         for ipeaks=1:PSES.nsigpeaksTW
                                        %                                             ind = PSES.sigpeakindTW(ipeaks);
                                        if(~isempty(PSES.maxsigpeakindTW))
                                            ind = PSES.maxsigpeakindTW;
                                            xdata   = XData(PSES.peaks(ind).ind);
                                            ydata   = YData(PSES.peaks(ind).ind);
                                            baseline = BaseLine(PSES.peaks(ind).ind);
                                            
                                            color   = [0.5 0.5 0.5];    % gray
                                            if(isfield(PSES,'isXtalk'))
                                                if(PSES.isXtalk==0)
                                                    color   = [0 1 1];
                                                else
                                                    color   = [1 1 0];
                                                end
                                            end
                                            hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                            goback(hA)
                                            
                                        end
                                        %                                             goback(hF)
                                    end
                                    
                                end
                                
                                gofront(hL)
                                set(hAx,'Nextplot','replacechildren');
                                
                            else
                                show_sta    = 'average';
                                YData   = S.YData;
                                XData   = S.XData;
                                YUnit   = S.Unit;
                                nTrials = S.nTrials;
                                
                                if(strcmp(YUnit,'sps'))
                                    hL  = area(hAx,XData,YData,'EdgeColor',[0 0 0],'FaceColor',[0 0 0.5],'Tag','data');
                                else
                                    hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                end
                            end
                            
                            
                            
                            
                        case 'trials'
                            
                            if(isempty(UD.subData{ifiles}))
                                if(isfield(S,'data_file'))
                                    datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                    SS      = load(datafile,'TrialData');
                                    UD.subData{ifiles}  = SS.TrialData;
                                else
                                    UD.subData{ifiles}  = S.TrialData;
                                end
                            end
                            
                            
                            if(isfield(S,'TrialsToUse'))
                                if(isempty(S.TrialsToUse))
                                    TrialsToUse = 1:size(UD.subData{ifiles},1);
                                else
                                    TrialsToUse = S.TrialsToUse;
                                end
                            else
                                TrialsToUse = 1:size(UD.subData{ifiles},1);
                            end
                            YData   = UD.subData{ifiles};
                            YData   = YData(TrialsToUse,:);
                            nTrials = size(YData,1);
                            XData   = S.XData;
                            YUnit   = S.Unit;
                            
                            
                            
                            
                            if(UD.usetrialsoffset_flag)
                                % use offset
                                offset_ratio    = 0.75;
                                
                                [nTrials,nData] = size(YData);
                                offset_size     = max(max(YData))-min(min(YData));
                                offsets         = repmat((((nTrials:-1:1)-1)*offset_size*offset_ratio)',1,nData);
                                YData           = YData + offsets;
                                %
                            end
                            
                            if(UD.Slider.On)
                                StartIndex  = max(1,UD.Slider.StartIndex);
                                StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                
                                YData       = YData(StartIndex:StopIndex,:);
                                TrialsToUse = TrialsToUse(StartIndex:StopIndex);
                                nDispTrials = size(YData,1);
                                
                            end
                            
                            %                             hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0.5],'Tag','data');
                            hL  = plot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                            
                            hCm = uicontextmenu;
                            uimenu(hCm, 'Label', 'Not to use', 'Callback', 'uiEditChannel(''not to use'')');
                            %                             uimenu(hCm, 'Label', 'To use', 'Callback', 'uiEditChannel(''to use'')');
                            uimenu(hCm, 'Label', 'Property', 'Callback', 'uiEditChannel(''property'')');
                            uimenu(hCm, 'Label', 'Edit', 'Callback', 'uiEditChannel(''edit'')');
                            uimenu(hCm, 'Label', 'Save', 'Callback', {@uiSaveChannel,hAx},'Separator','on');
                            set(hL,'uicontextmenu',hCm);
                            
                            
                            
                            for ihL=1:length(hL)
                                hLUD.iTrial = TrialsToUse(ihL);
                                if(isfield(S,'TimeStamps'))
                                    if(~iscell(S.TimeStamps))
                                        hLUD.TriggerTime    = S.TimeStamps(hLUD.iTrial)/S.SampleRate;
                                    end
                                end
                                set(hL(ihL),'UserData',hLUD)
                            end
                            
                            
                        case 'trials-arranged'
                            if(isempty(UD.subData{ifiles}))
                                if(isfield(S,'data_file'))
                                    datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                    SS      = load(datafile,'TrialData');
                                    UD.subData{ifiles}  = SS.TrialData;
                                else
                                    UD.subData{ifiles}  = S.TrialData;
                                end
                            end
                            if(isfield(S,'TrialsToUse'))
                                if(isempty(S.TrialsToUse))
                                    TrialsToUse = 1:size(UD.subData{ifiles},1);
                                else
                                    TrialsToUse = S.TrialsToUse;
                                end
                            else
                                TrialsToUse = 1:size(UD.subData{ifiles},1);
                            end
                            YData   = UD.subData{ifiles};
                            YData   = YData(TrialsToUse,:);
                            nTrials = size(YData,1);
                            XData   = S.XData;
                            YUnit   = S.Unit;
                            
                            
                            % Select reference for arrangement
                            if(isempty(UD.trial_reffile))
                                reffile = sortxls(strfilt(deext(dirmat(UD.parentpath)),'~._'));
                                reffile = uiselect(reffile,1,'Sort trials? Select Reference file for arrange the trials');
                                reffile = reffile{1};
                            else
                                reffile = UD.trial_reffile;
                            end
                            
                            if(~exist(fullfile(UD.parentpath,['._',reffile,'.mat']),'file'))
                                reffile = [];
                            else
                                UD.trial_reffile   = reffile;
                            end
                            
                            
                            % Load reference and set order
                            if(~isempty(reffile))
                                refdatafile = fullfile(UD.parentpath,['._',reffile,'.mat']);
                                ref         = loaddata(fullfile(UD.parentpath,[reffile,'.mat']),'-full');
                                refData     = load(refdatafile,'TrialData');
                                refData     = refData.TrialData;
                                if(isfield(ref,'TrialsToUse'))
                                    refTrialsToUse = ref.TrialsToUse;
                                else
                                    refTrialsToUse = 1:size(refData,1);
                                end
                                refData = refData(refTrialsToUse,:);
                                
                                refinds     = zeros(nTrials,1);
                                for iTrial=1:nTrials
                                    refinds(iTrial)  = find(refData(iTrial,:),1,'first');
                                end
                                [refinds,reforder]  = sort(refinds);
                                
                            else
                                reforder = 1:nTrials;
                            end
                            
                            % Arrange YData and TrialsToUse
                            YData           = YData(reforder,:);
                            TrialsToUse     = TrialsToUse(reforder);
                            
                            
                            
                            if(UD.usetrialsoffset_flag)
                                % use offset
                                offset_ratio    = 0.5;
                                
                                [nTrials,nData] = size(YData);
                                offset_size     = max(max(YData))-min(min(YData));
                                offsets         = repmat((((nTrials:-1:1)-1)*offset_size*offset_ratio)',1,nData);
                                YData           = YData + offsets;
                                %
                            end
                            
                            if(UD.Slider.On)
                                StartIndex  = max(1,UD.Slider.StartIndex);
                                StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                
                                YData       = YData(StartIndex:StopIndex,:);
                                TrialsToUse = TrialsToUse(StartIndex:StopIndex);
                                nDispTrials = size(YData,1);
                                
                            end
                            
                            
                            hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0.5],'Tag','data');
                            
                            hCm = uicontextmenu;
                            uimenu(hCm, 'Label', 'Not to use', 'Callback', 'uiEditChannel(''not to use'')');
                            %                             uimenu(hCm, 'Label', 'To use', 'Callback', 'uiEditChannel(''to use'')');
                            uimenu(hCm, 'Label', 'Property', 'Callback', 'uiEditChannel(''property'')');
                            uimenu(hCm, 'Label', 'Edit', 'Callback', 'uiEditChannel(''edit'')');
                            uimenu(hCm, 'Label', 'Save', 'Callback', {@uiSaveChannel,hAx},'Separator','on');
                            set(hL,'uicontextmenu',hCm);
                            
                            
                            for ihL=1:length(hL)
                                hLUD.iTrial = TrialsToUse(ihL);
                                hLUD.TriggerTime    = S.TimeStamps(TrialsToUse(ihL))/S.SampleRate;
                                set(hL(ihL),'UserData',hLUD)
                            end
                            
                        case {'trials-cmap','trials-surf','trials-contourf'}
                            
                            if(isempty(UD.subData{ifiles}))
                                if(isfield(S,'data_file'))
                                    datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                    SS      = load(datafile,'TrialData');
                                    UD.subData{ifiles}  = SS.TrialData;
                                else
                                    UD.subData{ifiles}  = S.TrialData;
                                end
                            end
                            
                            
                            if(isfield(S,'TrialsToUse'))
                                if(isempty(S.TrialsToUse))
                                    TrialsToUse = 1:size(UD.subData{ifiles},1);
                                else
                                    TrialsToUse = S.TrialsToUse;
                                end
                            else
                                TrialsToUse = 1:size(UD.subData{ifiles},1);
                            end
                            YData   = UD.subData{ifiles};
                            YData   = YData(TrialsToUse,:);
                            nTrials = size(YData,1);
                            XData   = S.XData;
                            YUnit   = S.Unit;
                            
                            
                            
                            
                            if(UD.usetrialsoffset_flag)
                                % use offset
                                offset_ratio    = 0.5;
                                
                                [nTrials,nData] = size(YData);
                                offset_size     = max(max(YData))-min(min(YData));
                                offsets         = repmat((((nTrials:-1:1)-1)*offset_size*offset_ratio)',1,nData);
                                YData           = YData + offsets;
                                %
                            end
                            
                            if(UD.Slider.On)
                                StartIndex  = max(1,UD.Slider.StartIndex);
                                StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                
                                YData       = YData(StartIndex:StopIndex,:);
                                TrialsToUse = TrialsToUse(StartIndex:StopIndex);
                                nDispTrials = size(YData,1);
                                
                            end
                            
                            
                            
                            % display
                            if(UD.Slider.On)
                                switch show_sta
                                    case 'trials-cmap'
                                        imagesc(XData,1:nDispTrials,YData,'Parent',hAx);
                                        
                                    case 'trials-surf'
                                        surf(hAx,XData,1:nDispTrials,YData);
                                        set(hAx,'YDir','reverse');
                                        shading(hAx,'interp');
                                        view(hAx,[-37.5,60]);
                                        
                                    case 'trials-contourf'
                                        contourf(XData,1:nDispTrials,YData,'Parent',hAx);
                                        set(hAx,'YDir','reverse');
                                        
                                end
                            else
                                nn  = 1;
                                YData   = conv2(YData-100,ones(nn)/(nn^2),'same')+100;
                                CLim    = [95,105];
%                                 ZLim    = [90,110];
                                        
                                switch show_sta
                                    case 'trials-cmap'
                                        imagesc(XData,1:nTrials,YData,'Parent',hAx);
                                        set(hAx,'CLim',CLim)
                                        
                                    case 'trials-surf'
                                        surf(hAx,XData,1:nTrials,YData);
                                        set(hAx,'YDir','reverse');
                                        shading(hAx,'interp');
                                        view(hAx,[-37.5,60]);
                                        set(hAx,'CLim',CLim)
%                                         set(hAx,'ZLim',ZLim)
                                        
                                        
                                    case 'trials-contourf'
                                        contourf(XData,1:nTrials,YData,(90:2.5:110),'Parent',hAx);
                                        set(hAx,'YDir','reverse');
                                        set(hAx,'CLim',CLim)
                                end

%                                 imagesc(XData,1:nTrials,YData,'Parent',hAx)
                            end
                            
                        case 'trials-stack'
                            
                            if(isempty(UD.subData{ifiles}))
                                if(isfield(S,'data_file'))
                                    datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                    SS      = load(datafile,'TrialData');
                                    UD.subData{ifiles}  = SS.TrialData;
                                else
                                    UD.subData{ifiles}  = S.TrialData;
                                end
                            end
                            
                            
                            if(isfield(S,'TrialsToUse'))
                                if(isempty(S.TrialsToUse))
                                    TrialsToUse = 1:size(UD.subData{ifiles},1);
                                else
                                    TrialsToUse = S.TrialsToUse;
                                end
                            else
                                TrialsToUse = 1:size(UD.subData{ifiles},1);
                            end
                            YData   = UD.subData{ifiles};
                            YData   = YData(TrialsToUse,:);
                            nTrials = size(YData,1);
                            XData   = S.XData;
                            YUnit   = S.Unit;
                            
                            
                            
                            
                            if(UD.usetrialsoffset_flag)
                                % use offset
                                offset_ratio    = 0.5;
                                
                                [nTrials,nData] = size(YData);
                                offset_size     = max(max(YData))-min(min(YData));
                                offsets         = repmat((((nTrials:-1:1)-1)*offset_size*offset_ratio)',1,nData);
                                YData           = YData + offsets;
                                %
                            end
                            
                            if(UD.Slider.On)
                                StartIndex  = max(1,UD.Slider.StartIndex);
                                StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                
                                YData       = YData(StartIndex:StopIndex,:);
                                TrialsToUse = TrialsToUse(StartIndex:StopIndex);
                                nDispTrials = size(YData,1);
                                
                            end
                            
                            
                            
                            % display
                            area(hAx,XData',YData');
                            
                            
                            
                    end
                    
                    if(isfield(S,'TimeLabels'))
                        nLabels = length(S.TimeLabels);
                        if(nLabels>0)
                            set(hAx,'Nextplot','add')
                            if(strcmp(show_sta,'trials-cmap'))
                                if(UD.Slider.On)
                                    min_YData   = 0.5;
                                    max_YData   = nDispTrials+0.5;
                                else
                                    min_YData   = 0.5;
                                    max_YData   = nTrials+0.5;
                                end
                            else
                                min_YData   = min(min(YData));
                                max_YData   = max(max(YData));
                            end
                            for iLabel=1:nLabels
                                plot(hAx,repmat(S.TimeLabels(iLabel).Time,1,2),[min_YData,max_YData],'Color',[1 0 0]);
                            end
                            set(hAx,'Nextplot','replacechildren')
                        end
                    end
                    
                    
                    
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        if(isfield(S,'Unit'))
                            ylabel(hAx,YUnit);
                        end
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'time (sec)');
                    end
                    
                    if(length(filename)>UD.maxfilenamelength)
                        filename    =[filename(1:UD.maxfilenamelength),'...'];
                    end
                    
                    switch show_sta
                        case 'average'
                            if(UD.Slider.On)
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                            else
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                            end
                            axis(hAx,'xy');
                        case 'average-on-BaseLine'
                            set(get(hAx,'Title'),'String',{filename;[psename,', ',num2str(S.(psename).nsd),'sd, n=',num2str(S.nTrials)]});
                            axis(hAx,'xy');
                        case 'average-with-PSE'
                            set(get(hAx,'Title'),'String',{filename;[psename,', ',num2str(S.(psename).nsd),'sd, n=',num2str(S.nTrials)]});
                            axis(hAx,'xy');
                        case 'average-with-PSE-adjusted'
                            set(get(hAx,'Title'),'String',{filename;[psename,', ',num2str(S.(psename).nsd),'sd, n=',num2str(S.nTrials)]});
                            axis(hAx,'xy');
                        case 'average-with-PSE-adjusted-percent'
                            set(get(hAx,'Title'),'String',{filename;[psename,', ',num2str(S.(psename).nsd),'sd, n=',num2str(S.nTrials)]});
                            axis(hAx,'xy');
                        case 'average-with-PSE-adjusted-sd'
                            set(get(hAx,'Title'),'String',{filename;[psename,', ',num2str(S.(psename).nsd),'sd, n=',num2str(S.nTrials)]});
                            axis(hAx,'xy');
                        case 'trials'
                            if(UD.Slider.On)
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                            else
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                            end
                            axis(hAx,'xy');
                        case 'trials-arranged'
                            if(UD.Slider.On)
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                            else
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                            end
                            axis(hAx,'xy');
                        case 'trials-cmap'
                            if(UD.Slider.On)
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                            else
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                            end
                            axis(hAx,'ij');
                        case 'trials-stack'
                            if(UD.Slider.On)
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                            else
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                            end
                            axis(hAx,'xy');
                    end
                    
                    gofront(get(hAx,'Title'));
                    
                    
                case 'diffSTA'                             % diffSTA
                    
                    if(~isfield(S,'Unit'))
                        S.Unit  = '';
                    end
                    
                    YData   = S.YData;
                    XData   = S.XData;
                    YUnit   = S.Unit;
                    
                    hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                    
                    if(isfield(S,'TimeLabels'))
                        nLabels = length(S.TimeLabels);
                        if(nLabels>0)
                            set(hAx,'Nextplot','add')
                            min_YData   = min(YData);
                            max_YData   = max(YData);
                            for iLabel=1:nLabels
                                plot(hAx,repmat(S.TimeLabels(iLabel).Time,1,2),[min_YData,max_YData],'Color',[1 0 0]);
                            end
                            set(hAx,'Nextplot','replacechildren')
                        end
                    end
                    
                    
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        if(isfield(S,'Unit'))
                            ylabel(hAx,YUnit);
                        end
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'time (sec)');
                    end
                    
                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(S.nTrials)]});
                    
                    gofront(get(hAx,'Title'));
                    
                    
                    
                                     %% PSTH
                case 'PSTH'
                    if (~isfield(S,'BinEdges')) % if old psth file created before 20110120
                        for iPSTH=1:1
                            switch UD.show_psth
                                case 'histogram'
                                    
                                    %
                                    %                             if((isfield(S,'TrialsToUse') && isfield(S,'data_file')) || UD.Slider.On)
                                    %                                 if(isempty(UD.subData{ifiles}))
                                    %                                     datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                    %                                     SS      = load(datafile,'TrialData');
                                    %                                     UD.subData{ifiles}  = SS.TrialData;
                                    %                                 end
                                    %
                                    %                                 if(isfield(S,'TrialsToUse'))
                                    %                                     TrialsToUse = S.TrialsToUse;
                                    %                                 else
                                    %                                     TrialsToUse = 1:size(UD.subData{ifiles},1);
                                    %                                 end
                                    %                                 YData   = UD.subData{ifiles};
                                    %                                 YData   = YData(TrialsToUse,:);
                                    %                                 nTrials = size(YData,1);
                                    %
                                    %                                 if(UD.Slider.On)
                                    %                                     StartIndex  = max(1,UD.Slider.StartIndex);
                                    %                                     StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                    %
                                    %                                     YData       = YData(StartIndex:StopIndex,:);
                                    %                                     nDispTrials = size(YData,1);
                                    %
                                    %                                 end
                                    %
                                    %                                 YData   = mean(YData,1);
                                    %
                                    %                                 XData   = S.XData;
                                    %                                 YUnit   = S.Unit;
                                    %                             else
                                    %                                 YData   = S.YData;
                                    %                                 XData   = S.XData;
                                    %                                 YUnit   = S.Unit;
                                    %                                 nTrials = S.nTrials;
                                    %                             end
                                    %
                                    %                             hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                    
                                    
                                    
                                    
                                    
                                    
                                    %                                 YData   = S.YData_sps;
                                    %                                 XData   = S.BinData;
                                    %                                 hL  = bar(hAx,XData,YData,'BarWidth',1,'EdgeColor',[0 0 0],'FaceColor',[0 0 0.5]);
                                    %                                 YUnit   = 'counts/trial';
                                    YUnit   = 'Frequency';
                                    hL  = psthplot(hAx,S,'EdgeColor',[0 0 0.5],'FaceColor',[0 0 0.5],'YUnit',YUnit);
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(hAx,YUnit);
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(hAx,'time (sec)');
                                    end
                                    
                                    if(isfield(S,'sigpeakind_ttest'))
                                        if(~isempty(S.sigpeakind_ttest))
                                            onsets  = [S.peaks(S.sigpeakind).onset];
                                            offsets = [S.peaks(S.sigpeakind).offset];
                                            nonsets = length(onsets);
                                            for ionset  =1:nonsets
                                                onset   = onsets(ionset);
                                                offset  = offsets(ionset);
                                                [onset,ind] = nearest(S.BinData,onset);
                                                set(hAx,'Nextplot','add');
                                                plot(hAx,[onset offset],ones(1,2)*S.YData_sps(ind),'-r','LineWidth',2,...
                                                    'Marker','s',...
                                                    'MarkerEdgeColor','r',...
                                                    'MarkerFaceColor','r',...
                                                    'MarkerSize',4);
                                                text(onset,S.YData_sps(ind),num2str(onset),'Parent',hAx,'Color',[1 0 0],'FontName','Arial','FontSize',11,'FontWeight','Bold','HorizontalAlignment','center','VerticalAlignment','Bottom');
                                                text(offset,S.YData_sps(ind),num2str(offset),'Parent',hAx,'Color',[1 0 0],'FontName','Arial','FontSize',11,'FontWeight','Bold','HorizontalAlignment','center','VerticalAlignment','Bottom');
                                            end
                                        else
                                            onsets  =NaN;
                                        end
                                    else
                                        onsets  =NaN;
                                    end
                                    
                                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(S.nTrials)]});
                                    gofront(get(hAx,'Title'));
                                    axis(hAx,'xy');
                                    
                                
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                case 'raster'
                                    
                                    datafile    = fullfile(UD.parentpath,['._',filename,'.mat']);
                                    SS          = load(datafile,'TrialData');
                                    
                                    
                                    
                                    
                                    if(isfield(S,'TrialsToUse'))
                                        if(isempty(S.TrialsToUse))
                                            TrialsToUse = 1:size(SS.TrialData,1);
                                        else
                                            TrialsToUse = S.TrialsToUse;
                                        end
                                    else
                                        TrialsToUse = 1:size(SS.TrialData,1);
                                    end
                                    
                                    SS.TrialData    = SS.TrialData(TrialsToUse,:);
                                    
                                    
                                    if(UD.Slider.On)
                                        StartIndex  = max(1,UD.Slider.StartIndex);
                                        StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                        
                                        SS.TrialData    = SS.TrialData(StartIndex:StopIndex,:);
                                        TrialsToUse     = TrialsToUse(StartIndex:StopIndex);
                                        nDispTrials     = size(SS.TrialData,1);
                                        
                                    end
                                    
                                    
                                    hL  = rasterplot(hAx,S,SS,'Color',[0 0 0]);
                                    nLine   = length(hL);
                                    for ihL=1:nLine
                                        hLUD.iTrial = ihL;
                                        hLUD.TriggerTime    = S.TimeStamps(ihL)/S.SampleRate;
                                        set(hL(ihL),'UserData',hLUD)
                                    end
                                    
                                    
                                    old_nextplot    = get(hAx,'Nextplot');
                                    set(hAx,'Nextplot','add');
                                    
                                    hDot    = plot(hAx,S.TimeRange,ones(1,2)*0.5,'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                    goback(hDot)
                                    hDot    = plot(hAx,S.TimeRange,ones(1,2)*0.5+nLine,'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                    goback(hDot)
                                    set(hAx,'Nextplot',old_nextplot);
                                    
                                    nTrials = size(SS.TrialData,1);
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(hAx,'#trial');
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(hAx,'time (sec)');
                                    end
                                    
                                    if(UD.Slider.On)
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                                    else
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                                    end
                                    
                                    
                                    
                                    gofront(get(hAx,'Title'));
                                    axis(hAx,'ij');
                                    
                                case 'raster-arranged'
                                    if(isempty(UD.raster_reffile))
                                        reffile = sortxls(strfilt(deext(dirmat(UD.parentpath)),'~._'));
                                        reffile = uiselect(reffile,1,'Sort raster? Select Reference file for arrange the raster');
                                        reffile = reffile{1};
                                    else
                                        reffile = UD.raster_reffile;
                                    end
                                    
                                    if(~exist(fullfile(UD.parentpath,['._',reffile,'.mat']),'file'))
                                        reffile = [];
                                    else
                                        UD.raster_reffile   = reffile;
                                    end
                                    
                                    datafile    = fullfile(UD.parentpath,['._',filename,'.mat']);
                                    SS          = load(datafile,'TrialData');
                                    
                                    if(~isempty(reffile))
                                        refdatafile = fullfile(UD.parentpath,['._',reffile,'.mat']);
                                        ref         = load(fullfile(UD.parentpath,[reffile,'.mat']));
                                        refData     = load(refdatafile,'TrialData');
                                        TrialData   = SS.TrialData;
                                        %                                     refData     = refData.TrialData;
                                        nTrials     = size(TrialData,1);
                                        ind         = zeros(nTrials,1);
                                        
                                        for iTrial=1:nTrials
                                            ind(iTrial)  = find(refData.TrialData(iTrial,:),1,'first');
                                        end
                                        [ind,reforder]  = sort(ind);
                                        
                                        SS.TrialData        = TrialData(reforder,:);
                                        refData.TrialData   = refData.TrialData(reforder,:);
                                        
                                        
                                    end
                                    
                                    
                                    
                                    hL  = rasterplot(hAx,S,SS,'Color',[0 0 0]);
                                    
                                    if(~isempty(reffile))
                                        iTrial  = 1:length(hL);
                                        iTrial  = iTrial(reforder);
                                        TimeStamps  = S.TimeStamps(reforder);
                                    end
                                    nLine   = length(hL);
                                    for ihL=1:nLine
                                        hLUD.iTrial = iTrial(ihL);
                                        hLUD.TriggerTime    = TimeStamps(ihL)/S.SampleRate;
                                        set(hL(ihL),'UserData',hLUD)
                                    end
                                    
                                    old_nextplot    = get(hAx,'Nextplot');
                                    set(hAx,'Nextplot','add');
                                    
                                    hDot    = plot(hAx,S.TimeRange,ones(1,2)*0.5,'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                    goback(hDot)
                                    hDot    = plot(hAx,S.TimeRange,ones(1,2)*0.5+nLine,'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                    goback(hDot)
                                    set(hAx,'Nextplot',old_nextplot);
                                    
                                    nTrials = size(SS.TrialData,1);
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(hAx,'#trial');
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(hAx,'time (sec)');
                                    end
                                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials),' (arranged)']});
                                    gofront(get(hAx,'Title'));
                                    axis(hAx,'ij');
                                    %                                 if(~isempty(reffile))
                                    %                                     if(iscell(hL))
                                    %                                         hL  = hL{1};
                                    %                                     end
                                    %                                     LW      = get(hL(1),'LineWidth');
                                    %                                     hRef    = rasterplot(hAx,ref,refData,'Color',[0.5 0 0],'LineWidth',LW*2);
                                    %                                 end
                                    
                                    
                                    
                                case 'raster-over-histogram'
                                    datafile     = fullfile(UD.parentpath,['._',filename,'.mat']);
                                    SS           = load(datafile,'TrialData');
                                    
                                    p   = get(hAx,'Position');
                                    ph1 = [p(1) p(2)+p(4)*0.51  p(3)    p(4)*0.49];
                                    ph2 = [p(1) p(2)            p(3)    p(4)*0.49];
                                    
                                    h1  = axes('Position', ph1, 'Tag', 'axis');
                                    set(hAx,'Position', ph2);h2=hAx;
                                    
                                    %                                     set(hAx,'Position', ph1);h1=hAx;
                                    %                                     h2  = axes('Position', ph2, 'Tag', 'axis');
                                    
                                    hL  = rasterplot(h1,S,SS,'Color',[0 0 0]);
                                    hL  = psthplot(h2,S,'EdgeColor',[0 0 0.5],'FaceColor',[0 0 0.5]);
                                    
                                    axis(h1,'off');
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(h1,'#trial');
                                        ylabel(h2,'sps');
                                        
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(h2,'time (sec)');
                                    end
                                    set(get(h1,'Title'),'Units','Normalized',...
                                        'BackGroundColor',[1 1 1],...
                                        'FontName','Arial',...
                                        'FontSize',9,...
                                        'HorizontalAlignment','right',...
                                        'Margin',0.01,...
                                        'Position',[1.0 1.0],...
                                        'String',{filename;['n=',num2str(S.nTrials)]},...
                                        'VerticalAlignment','Bottom');
                                    
                                    gofront(get(h1,'Title'));
                            end
                        end
                        %                         axis(hAx,'tight')
                    else   % if new psth created after 20110120
                        if(isfield(S,'CreationMethod'))
                            if(strcmp(S.CreationMethod,'combinepsth')) % if combined psth
                            end
                            %----------------------------------
                            YUnit   = S.YUnit;
%                             YUnit   = 'frequency';
                            %                                 YUnit   = 'counts/trial';
                            %                                 YUnit   = 'total counts';
                            
                           
                            
                            
                            
                            
                            YData   = S.YData;
                            XData   = S.XData;
                            nTrials = S.nFiles;
                                                        
                            hL      = bar(hAx,XData,YData,'BarWidth',1,'EdgeColor',[0 0 0],'FaceColor',[0 0 0.5]);
                            
                            
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,YUnit);
                            end
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,'time (sec)');
                            end
                            
                            
                            if(UD.Slider.On)
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                            else
                                set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                            end
                            gofront(get(hAx,'Title'));
                            axis(hAx,'xy');box(hAx,'off');
                            
                            
                            
                        else % if not combined psth
                            switch UD.show_psth
                                case 'histogram'
                                    
                                    %----------------------------------
                                    YUnit   = 'frequency';
                                    %                                 YUnit   = 'counts/trial';
                                    %                                 YUnit   = 'total counts';
                                    
                                    BinWidth    = S.BinWidth;
%                                                                     BinWidth    = 0.1;
                                    
                                    
                                    
                                    if(isempty(UD.subData{ifiles}))
                                        datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                        SS      = load(datafile,'TrialData');
                                        UD.subData{ifiles}  = SS.TrialData;
                                    end
                                    
                                    if(isempty(S.TrialsToUse))
                                        TrialsToUse = 1:size(UD.subData{ifiles},1);
                                    else
                                        TrialsToUse = S.TrialsToUse;
                                    end
                                    
                                    YData   = UD.subData{ifiles};
                                    YData   = YData(TrialsToUse,:);
                                    nTrials = size(YData,1);
                                    
                                    if(UD.Slider.On)
                                        StartIndex  = max(1,UD.Slider.StartIndex);
                                        StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                        
                                        YData       = YData(StartIndex:StopIndex,:);
                                        nDispTrials = size(YData,1);
                                    end
                                    
                                    [YData,XData]  = timestamp2psth(YData,S.TimeRange,BinWidth);
                                    
                                    switch lower(YUnit)
                                        case 'frequency'
                                            if(UD.Slider.On)
                                                YData   = YData./nDispTrials./BinWidth;
                                            else
                                                YData   = YData./nTrials./BinWidth;
                                            end
                                            
                                        case 'counts/trial'
                                            if(UD.Slider.On)
                                                YData   = YData./nDispTrials;
                                            else
                                                YData   = YData./nTrials;
                                            end
                                        case 'total counts'
                                            % do nothing
                                    end
                                    
                                    if(strcmp(S.ReferenceName,S.TargetName))
                                        disp(['Auto-correlation: ',filename])
%                                         [temp,ZeroLagInd]=nearest(XData,0);
                                        PeriZeroInd = XData<=0.001 & XData>=-0.001;
                                        YData(PeriZeroInd)   = 0;
                                    end
                                    
                                    hL      = bar(hAx,XData,YData,'BarWidth',1,'EdgeColor',[0 0 0],'FaceColor',[0 0 0.5]);
                                    
                                    
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(hAx,YUnit);
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(hAx,'time (sec)');
                                    end
                                    
                                    
                                    if(UD.Slider.On)
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                                    else
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                                    end
                                    gofront(get(hAx,'Title'));
                                    axis(hAx,'xy');box(hAx,'off');
                                    
                                case 'histogram-with-PSE'
                                    YData   = S.YData;
                                    XData   = S.XData;
                                    %                                     hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0.5]);
                                    %                                     if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    %                                         ylabel(hAx,'sps');
                                    %                                     end
                                    %                                     if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    %                                         xlabel(hAx,'time (sec)');
                                    %                                     end
                                    %                                     xlim(hAx,[XData(1) XData(end)])
                                    %
                                    %
                                    
                                    
                                    
                                    if(isempty(UD.psename))
                                        psename = strfilt(fieldnames(S),'pse');
                                        psename = psename{1};
                                        UD.psename = psename;
                                    else
                                        psename = UD.psename;
                                    end
                                    
                                    if(isfield(S,psename))
                                        PSES    = S.(psename);
                                        hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                        set(hAx,'Nextplot','add');
                                        
                                        if(~isfield(PSES,'BaseLine'))
                                            BaseLine    = S.ISAData;
                                            BaseLine    = BaseLine+mean(S.YData(PSES.base.ind)-BaseLine(PSES.base.ind));
                                        else
                                            BaseLine    = PSES.BaseLine;
                                        end
                                        
                                        plot(hAx,XData,BaseLine,'Color',[0.75 0 0]);
                                        plot(hAx,XData,BaseLine+PSES.nsd(1)*PSES.base.sd,'--','Color',[0.75 0 0]);
                                        plot(hAx,XData,BaseLine-PSES.nsd(1)*PSES.base.sd,'--','Color',[0.75 0 0]);
                                        if(~isempty(PSES.nsigpeaks))
                                            if(~isfield(PSES,'search_TimeWindow'))
                                                for ipeaks=1:PSES.nsigpeaks
                                                    ind = PSES.sigpeakind(ipeaks);
                                                    xdata   = XData(PSES.peaks(ind).ind);
                                                    ydata   = YData(PSES.peaks(ind).ind);
                                                    baseline    = BaseLine(PSES.peaks(ind).ind);
                                                    
                                                    color   = [0.5 0.5 0.5]; % light gray
                                                    
                                                    hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                                    goback(hA)
                                                    
                                                end
                                            else
                                                %                                     set(hAx,'Color',[1.0 0.98 0.98])
                                                min_YData   = min(YData);
                                                max_YData   = max(YData);
                                                %                                             hF  = fill([PSES.search_TimeWindow(1) PSES.search_TimeWindow(2) PSES.search_TimeWindow(2) PSES.search_TimeWindow(1)],[min_YData min_YData max_YData max_YData],[0.9 0.9 0.9],'Parent',hAx,'EdgeColor',[0.9 0.9 0.9]);
                                                
                                                if(~isempty(PSES.sigpeakindTW))
                                                    for ipeaks=1:PSES.nsigpeaksTW
                                                        ind = PSES.sigpeakindTW(ipeaks);
                                                        %                                         if(~isempty(PSES.maxsigpeakindTW))
                                                        %                                             ind = PSES.maxsigpeakindTW;
                                                        xdata   = XData(PSES.peaks(ind).ind);
                                                        ydata   = YData(PSES.peaks(ind).ind);
                                                        baseline = BaseLine(PSES.peaks(ind).ind);
                                                        
                                                        if(ind==PSES.maxsigpeakindTW)
                                                            if(isfield(PSES,'isXtalk'))
                                                                if(PSES.isXtalk==0)
                                                                    color   = [0 1 1];
                                                                else
                                                                    color   = [1 1 0];
                                                                end
                                                            else
                                                                color   = [0.5 0.5 0.5];    % gray
                                                            end
                                                        else
                                                            color   = [0.75 0.75 0.75];    % light gray
                                                            
                                                        end
                                                        hA  = fill([xdata, xdata(end:-1:1)],[baseline, ydata(end:-1:1)],color,'Parent',hAx,'edgecolor',color);
                                                        goback(hA)
                                                    end
                                                end
                                                %                                             goback(hF)
                                                
                                            end
                                            
                                        end
                                        
                                        gofront(hL)
                                        set(hAx,'Nextplot','replacechildren');
                                        
                                    else
                                        show_psth    = 'histogram';
                                        YData   = S.YData;
                                        XData   = S.XData;
%                                         YUnit   = S.Unit;
                                        nTrials = S.nTrials;
                                        StartIndex  = 1;
                                        
                                        hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0],'Tag','data');
                                        
                                    end
                                    
                                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(S.nTrials)]});
                                    gofront(get(hAx,'Title'));
                                    axis(hAx,'xy');
                                    
                                    
                                case 'raster'
                                    
                                    if(isempty(UD.subData{ifiles}))
                                        datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                        SS      = load(datafile,'TrialData');
                                        UD.subData{ifiles}  = SS.TrialData;
                                    end
                                    
                                    if(isempty(S.TrialsToUse))
                                        TrialsToUse = 1:size(UD.subData{ifiles},1);
                                    else
                                        TrialsToUse = S.TrialsToUse;
                                    end
                                    
                                    YData   = UD.subData{ifiles};
                                    YData   = YData(TrialsToUse,:);
                                    nTrials = size(YData,1);
                                    
                                    if(UD.Slider.On)
                                        StartIndex  = max(1,UD.Slider.StartIndex);
                                        StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                        
                                        YData       = YData(StartIndex:StopIndex,:);
                                        nDispTrials = size(YData,1);
                                    end
                                    
                                    [YData,XData]   = timestamp2raster(YData);
                                    
                                    if(~UD.Slider.On)
                                        hL  =nan(1,nTrials);
                                        
                                        for iTrial=1:nTrials
                                            hL(iTrial)  = plot(hAx,XData{iTrial},YData{iTrial}+iTrial,'Color',[0 0 0]);
                                            if(iTrial==1)
                                                old_nextplot    = get(hAx,'Nextplot');
                                                set(hAx,'Nextplot','add');
                                            end
                                        end
                                        
                                        hDot    = plot(hAx,S.TimeRange,ones(1,2)*0.5,'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                        goback(hDot)
                                        hDot    = plot(hAx,S.TimeRange,ones(1,2)*0.5+nTrials,'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                        goback(hDot)
                                        set(hAx,'Nextplot',old_nextplot);
                                        
                                    else
                                        hL  =nan(1,nDispTrials);
                                        
                                        for iTrial=1:nDispTrials
                                            hL(iTrial)  = plot(hAx,XData{iTrial},YData{iTrial}+iTrial+StartIndex-1,'Color',[0 0 0]);
                                            if(iTrial==1)
                                                old_nextplot    = get(hAx,'Nextplot');
                                                set(hAx,'Nextplot','add');
                                            end
                                        end
                                        
                                        hDot    = plot(hAx,S.TimeRange,ones(1,2)*(StartIndex-0.5),'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                        goback(hDot)
                                        hDot    = plot(hAx,S.TimeRange,ones(1,2)*(StopIndex+0.5),'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                        goback(hDot)
                                        set(hAx,'Nextplot',old_nextplot);
                                        
                                        
                                    end
                                    
                                    %                                 nLine   = length(hL);
                                    %                                 for ihL=1:nLine
                                    %                                     hLUD.iTrial = ihL;
                                    %                                     hLUD.TriggerTime    = S.TimeStamps(ihL);
                                    %                                     set(hL(ihL),'UserData',hLUD)
                                    %                                 end
                                    
                                    
                                    
                                    
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(hAx,'#trial');
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(hAx,'time (sec)');
                                    end
                                    
                                    if(UD.Slider.On)
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                                    else
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                                    end
                                    gofront(get(hAx,'Title'));
                                    axis(hAx,'ij');box(hAx,'off');
                                    
                                case 'raster-arranged'
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    if(isempty(UD.raster_reffile))
                                        reffile = sortxls(strfilt(deext(dirmat(UD.parentpath)),'~._'));
                                        reffile = uiselect(reffile,1,'Sort raster? Select Reference file for arrange the raster');
                                        reffile = reffile{1};
                                    else
                                        reffile = UD.raster_reffile;
                                    end
                                    
                                    if(~exist(fullfile(UD.parentpath,['._',reffile,'.mat']),'file'))
                                        reffile = [];
                                    else
                                        UD.raster_reffile   = reffile;
                                    end
                                    
                                    
                                    
                                    if(isempty(UD.subData{ifiles}))
                                        datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                        SS      = load(datafile,'TrialData');
                                        UD.subData{ifiles}  = SS.TrialData;
                                    end
                                    
                                    if(isempty(S.TrialsToUse))
                                        TrialsToUse = 1:size(UD.subData{ifiles},1);
                                    else
                                        TrialsToUse = S.TrialsToUse;
                                    end
                                    
                                    YData   = UD.subData{ifiles};
                                    YData   = YData(TrialsToUse,:);
                                    nTrials = size(YData,1);
                                    
                                    if(~isempty(reffile))
                                        RefData = load(fullfile(UD.parentpath,['._',reffile,'.mat']),'TrialData');
                                        RefData = RefData.TrialData;
                                        RefData = RefData(TrialsToUse,:);
                                        
                                        ind       = zeros(nTrials,1);
                                        
                                        for iTrial=1:nTrials
                                            ind(iTrial)  = RefData{iTrial}(1);
                                        end
                                        [ind,reforder]  = sort(ind);
                                        
                                        YData           = YData(reforder,:);
                                        RefData         = RefData(reforder,:);
                                        
                                    end
                                    
                                    if(UD.Slider.On)
                                        StartIndex  = max(1,UD.Slider.StartIndex);
                                        StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                        
                                        YData       = YData(StartIndex:StopIndex,:);
                                        nDispTrials = size(YData,1);
                                    end
                                    
                                    [YData,XData]   = timestamp2raster(YData);
                                    
                                    if(~UD.Slider.On)
                                        hL  =nan(1,nTrials);
                                        
                                        for iTrial=1:nTrials
                                            hL(iTrial)  = plot(hAx,XData{iTrial},YData{iTrial}+iTrial,'Color',[0 0 0]);
% % %                                             plot(hAx,RefData{iTrial}(1),iTrial,'d','MarkerSize',3,'MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5]);
                                            if(iTrial==1)
                                                old_nextplot    = get(hAx,'Nextplot');
                                                set(hAx,'Nextplot','add');
                                            end
                                        end
                                        
                                        hDot    = plot(hAx,S.TimeRange,ones(1,2)*0.5,'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                        goback(hDot)
                                        hDot    = plot(hAx,S.TimeRange,ones(1,2)*0.5+nTrials,'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                        goback(hDot)
                                        set(hAx,'Nextplot',old_nextplot);
                                        
                                    else
                                        hL  =nan(1,nDispTrials);
                                        
                                        for iTrial=1:nDispTrials
                                            hL(iTrial)  = plot(hAx,XData{iTrial},YData{iTrial}+iTrial+StartIndex-1,'Color',[0 0 0]);
                                            if(iTrial==1)
                                                old_nextplot    = get(hAx,'Nextplot');
                                                set(hAx,'Nextplot','add');
                                            end
                                        end
                                        
                                        hDot    = plot(hAx,S.TimeRange,ones(1,2)*(StartIndex-0.5),'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                        goback(hDot)
                                        hDot    = plot(hAx,S.TimeRange,ones(1,2)*(StopIndex+0.5),'.k');  % x-axisをtightにしても、dataに左右されずに、timerangeまでを描く。
                                        goback(hDot)
                                        set(hAx,'Nextplot',old_nextplot);
                                        
                                        
                                    end
                                    
                                    %                                 nLine   = length(hL);
                                    %                                 for ihL=1:nLine
                                    %                                     hLUD.iTrial = ihL;
                                    %                                     hLUD.TriggerTime    = S.TimeStamps(ihL);
                                    %                                     set(hL(ihL),'UserData',hLUD)
                                    %                                 end
                                    
                                    
                                    
                                    
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(hAx,'#trial');
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(hAx,'time (sec)');
                                    end
                                    
                                    if(UD.Slider.On)
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                                    else
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                                    end
                                    gofront(get(hAx,'Title'));
                                    axis(hAx,'ij');box(hAx,'off');
                                    
                                    
                                    
                                case 'raster-over-histogram'
                                    datafile     = fullfile(UD.parentpath,['._',filename,'.mat']);
                                    SS           = load(datafile,'TrialData');
                                    
                                    p   = get(hAx,'Position');
                                    ph1 = [p(1) p(2)+p(4)*0.51  p(3)    p(4)*0.49];
                                    ph2 = [p(1) p(2)            p(3)    p(4)*0.49];
                                    
                                    h1  = axes('Position', ph1, 'Tag', 'axis');
                                    set(hAx,'Position', ph2);h2=hAx;
                                    
                                    %                                     set(hAx,'Position', ph1);h1=hAx;
                                    %                                     h2  = axes('Position', ph2, 'Tag', 'axis');
                                    
                                    hL  = rasterplot(h1,S,SS,'Color',[0 0 0]);
                                    hL  = psthplot(h2,S,'EdgeColor',[0 0 0.5],'FaceColor',[0 0 0.5]);
                                    
                                    axis(h1,'off');
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(h1,'#trial');
                                        ylabel(h2,'sps');
                                        
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(h2,'time (sec)');
                                    end
                                    set(get(h1,'Title'),'Units','Normalized',...
                                        'BackGroundColor',[1 1 1],...
                                        'FontName','Arial',...
                                        'FontSize',9,...
                                        'HorizontalAlignment','right',...
                                        'Margin',0.01,...
                                        'Position',[1.0 1.0],...
                                        'String',{filename;['n=',num2str(S.nTrials)]},...
                                        'VerticalAlignment','Bottom');
                                    
                                    gofront(get(h1,'Title'));
                                    
                                case 'instantaneous-frequency'
                                    
                                    if(isempty(UD.subData{ifiles}))
                                        datafile= fullfile(UD.parentpath,['._',filename,'.mat']);
                                        SS      = load(datafile,'TrialData');
                                        UD.subData{ifiles}  = SS.TrialData;
                                    end
                                    
                                    if(isempty(S.TrialsToUse))
                                        TrialsToUse = 1:size(UD.subData{ifiles},1);
                                    else
                                        TrialsToUse = S.TrialsToUse;
                                    end
                                    
                                    YData   = UD.subData{ifiles};
                                    YData   = YData(TrialsToUse,:);
                                    nTrials = size(YData,1);
                                    
                                    if(UD.Slider.On)
                                        StartIndex  = max(1,UD.Slider.StartIndex);
                                        StopIndex   = min(nTrials,UD.Slider.StopIndex);
                                        
                                        YData       = YData(StartIndex:StopIndex,:);
                                        nDispTrials = size(YData,1);
                                    end
                                    
                                    [YData,XData]   = timestamp2frequency(YData);
                                    
                                    if(~UD.Slider.On)
                                        hL  =nan(1,nTrials);
                                        
                                        for iTrial=1:nTrials
                                            hL(iTrial)  = plot(hAx,XData{iTrial},YData{iTrial},'ok','Color',[0 0 0]);
                                            if(iTrial==1)
                                                old_nextplot    = get(hAx,'Nextplot');
                                                set(hAx,'Nextplot','add');
                                            end
                                        end
                                        
                                        set(hAx,'Nextplot',old_nextplot);
                                        
                                    else
                                        hL  =nan(1,nDispTrials);
                                        
                                        for iTrial=1:nDispTrials
                                            hL(iTrial)  = plot(hAx,XData{iTrial},YData{iTrial},'ok','Color',[0 0 0]);
                                            if(iTrial==1)
                                                old_nextplot    = get(hAx,'Nextplot');
                                                set(hAx,'Nextplot','add');
                                            end
                                        end
                                        
                                        set(hAx,'Nextplot',old_nextplot);
                                        
                                        
                                    end
                                    
                                    %                                 nLine   = length(hL);
                                    %                                 for ihL=1:nLine
                                    %                                     hLUD.iTrial = ihL;
                                    %                                     hLUD.TriggerTime    = S.TimeStamps(ihL);
                                    %                                     set(hL(ihL),'UserData',hLUD)
                                    %                                 end
                                    
                                    
                                    
                                    
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(hAx,'frequency');
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(hAx,'time (sec)');
                                    end
                                    
                                    if(UD.Slider.On)
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nDispTrials),' (Start=',num2str(StartIndex),', Total=',num2str(nTrials),')']});
                                    else
                                        set(get(hAx,'Title'),'String',{filename;['n=',num2str(nTrials)]});
                                    end
                                    gofront(get(hAx,'Title'));
                                    axis(hAx,'xy');box(hAx,'off');
                                    
                                    
                            end
                        end
                    end
                    
                    
                    
                    
                    
                    %%%% psth
                    
                case 'SEGPSTH'
                    YData   = S.YData * S.nTrials / S.BinWidth; % in freq
                    XData   = S.XData;
                    TrialData   = S.Shuffle.YData * S.nTrials / S.BinWidth; % in freq
                    PData   = median(TrialData,1);
                    ULData  = prctile(TrialData,97.5,1);
                    LLData  = prctile(TrialData,2.5,1);
                    
                    hL  = stairs(hAx,XData,YData,'k');
                    hold(hAx,'on');
                    stairs(hAx,XData,PData,'r');
                    stairs(hAx,XData,ULData,'r--');
                    stairs(hAx,XData,LLData,'r--');
                    
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        
                            ylabel(hAx,'freq (Hz)');
                        
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'time (sec)');
                    end
                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(S.nTrials)]});
                    
                    gofront(hL)
                    
                    
                    %% AVESTA
                case 'AVESTA'                              %% STA
                    YData   = S.YData * S.nTrials;
                    %                             YData   = conv2(YData,ones(1,100)/100);     %%% スムージング
                    %                             YData   = sigmoid(YData,1,5,1) .* YData;    %%% 非線形
                    XData   = S.XData;
                    
                    hL  = tdsplot(hAx,XData,YData,'Color',[0 0 0.5]);
                    
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        if(isfield(S,'Unit'))
                            ylabel(hAx,S.Unit);
                        end
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'time (sec)');
                    end
                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(S.nTrials)]});
                    
                    gofront(hL)
                    gofront(get(hAx,'Title'));
                    
                    
                    
                    %% WCOH
                case 'WCOH'
                    YData   = S.freqVec;
                    XData   = S.timeVec;
%                     HUMIND  = (YData>=UD.HUM(1) & YData<=UD.HUM(2));
                    FOIIND  = (YData>=UD.FOI(1) & YData<=UD.FOI(2));

                    
                    
                    switch UD.show_coh
                        case 'Cxy'
                            ZData   = S.Cxy;
%                             ZData(HUMIND,:,:) = NaN;
%                             CLim    = [S.c95,UD.CLim(2)];
                            CLim    = [S.c95,max(max(ZData(FOIIND,:,:)))];
                   
                        case 'Pxx'
                            ZData   = S.Pxx;
                            ZData   = log10(ZData);
%                             ZData(HUMIND,:,:) = NaN;
                            CLim    = [min(min(ZData)),max(max(ZData(FOIIND,:,:)))];
                    
                        case 'Pyy'
                            ZData   = S.Pyy;
                            ZData   = log10(ZData);
%                             ZData(HUMIND,:,:) = NaN;
                            CLim    = [min(min(ZData)),max(max(ZData(FOIIND,:,:)))];

                    end
                    
                    
                    
                    pcolor(hAx,XData,YData,ZData);
                    shading(hAx,'flat');
%                     colormap(hAx,tmap2);
                    colormap(hAx,'jet');
                    %                             axis(hAx,'tight')
                    set(hAx,'CLim',CLim,...
                        'YLim',UD.FOI);
                    
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        ylabel(hAx,'frequency (Hz)');
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'time (s)');
                    end
                    set(get(hAx,'Title'),'BackgroundColor',[1 1 1],'Color',[0 0 0],'FontSize',5.0,'Position',[1.0 1.1 0.0],'String',{filename;['n=',num2str(S.nTrials)]});
                    gofront(get(hAx,'Title'));
                    
                    %% AVEWCOH
                case 'AVEWCOH'
                    YData   = S.freqVec;
                    XData   = S.timeVec;
%                     HUMIND  = (YData>=UD.HUM(1) & YData<=UD.HUM(2));
                    FOIIND  = (YData>=UD.FOI(1) & YData<=UD.FOI(2));
                    
                    switch UD.show_coh
                        case 'Cxy'
                            ZData   = S.Cxy;
%                             ZData(HUMIND,:,:) = NaN;
                            CLim    = [S.c95,UD.CLim(2)];
%                             CLim    = [S.c95,max(max(ZData(FOIIND,:,:)))];
                   
                        case 'Pxx'
                            ZData   = S.Pxx;
                            ZData   = log10(ZData);
%                             ZData(HUMIND,:,:) = NaN;
                            CLim    = [min(min(ZData)),max(max(ZData(FOIIND,:,:)))];
                    
                        case 'Pyy'
                            ZData   = S.Pyy;
                            ZData   = log10(ZData);
%                             ZData(HUMIND,:,:) = NaN;
                            CLim    = [min(min(ZData)),max(max(ZData(FOIIND,:,:)))];

                    end

                    
                    pcolor(hAx,XData,YData,ZData);
                    shading(hAx,'flat');
%                     colormap(hAx,tmap2);
                    colormap(hAx,'jet');
                    %                             axis(hAx,'tight')
                    set(hAx,'CLim',CLim,...
                        'YLim',UD.FOI);
                    
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        if(isfield(S,'Unit'))
                            ylabel(hAx,S.Unit);
                        end
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'frequency (Hz)');
                    end
                    
                    set(get(hAx,'Title'),'BackgroundColor',[1 1 1],'Color',[1 1 1],'FontSize',5.0,'Position',[1.0 1.1 0.0],'String',{filename;['npairs=',num2str(length(S.nTrials))]});
                    gofront(get(hAx,'Title'));
                    
                    %% WCOHTIMEAVE
                case 'WCOHTIMEAVE'
                    XData   = S.freqVec;
                    HUMIND  = (XData>= UD.HUM(1) & XData<= UD.HUM(2));
                    
                    switch UD.show_coh
                        case 'Cxy'
                            YData   = S.Cxy;
                            %                                 YData(HUMIND)   = 0;
                        case 'Pxx'
                            YData   = S.Pxx;
                            %                                 YData(HUMIND)   = 0;
                        case 'Pyy'
                            YData   = S.Pyy;
                            %                                 YData(HUMIND)   = 0;
                        case 'Phase'
                            YData   = S.Phi;
                            YData(HUMIND)   = NaN;
                    end
                    %YData   = unit_adjustment(YData,S);
                    
                    
                    switch UD.show_coh
                        case 'Phase'
                            
                            sigind  = S.Cxy > S.c95;
                            if(isempty(S.maxclust))
                                isinmaxclust = false(size(sigind));
                            else
                                isinmaxclust = XData>=S.maxclust(1) & XData<=S.maxclust(end);
                            end
                            sigclustind  = sigind & isinmaxclust;
                            signonclustind  = sigind & ~isinmaxclust;
                            
                            
                            PhiCL   = phasecl(S.nTrials,S.Cxy);
                            if(any(sigind))
                                terrorbar(hAx,[XData';XData';XData'],...
                                    [nanmask(YData,signonclustind)'-2*pi;nanmask(YData,signonclustind)';nanmask(YData,signonclustind)'+2*pi],...
                                    [nanmask(PhiCL,signonclustind)';nanmask(PhiCL,signonclustind)';nanmask(PhiCL,signonclustind)'],...
                                    'o','Color',[0.75 0.75 0.75],'MarkerEdgeColor','none','MarkerFaceColor',[0.75 0.75 0.75],'MarkerSize',4,'Tag','signonclust');
                                
                                terrorbar(hAx,[XData';XData';XData'],...
                                    [nanmask(YData,sigclustind)'-2*pi;nanmask(YData,sigclustind)';nanmask(YData,sigclustind)'+2*pi],...
                                    [nanmask(PhiCL,sigclustind)';nanmask(PhiCL,sigclustind)';nanmask(PhiCL,sigclustind)'],...
                                    'ok','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0.5],'MarkerSize',4,'Tag','sigclust');
                                
                            else
                                
                            end
                            
                            cont    = uicontextmenu('Parent',UD.fig);
                            uimenu(cont,'Label','uiregress','callback','uiregress2(''sigclust'')')
                            
                            set(hAx,'UIContextMenu',cont,...
                                'XLim',UD.FOI,...
                                'YLim',[-3*pi pi],...
                                'YTickMode','manual',...
                                'YTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
                                'YTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'});
                        case 'Cxy'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            set(hAx,'Nextplot','add');
                            plot(hAx,[XData(1) XData(end)],[S.c95 S.c95],'--','Color',[0.5 0.5 0.5]);
                            %                                 axis(hAx,'tight')
                            set(hAx,'XLim',UD.FOI,...
                                'YLim',UD.CLim);
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'coh');
                            end
                            
                        case 'Pxx'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            %                                     axis(hAx,'tight')
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Power');
                            end
                        case 'Pyy'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            %                                     axis(hAx,'tight')
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Power');
                            end
                            
                    end
                    
                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(S.nTrials)]});
                    gofront(get(hAx,'Title'));
                    
                    %% AVEWCOHTIMEAVE
                case 'AVEWCOHTIMEAVE'
                    XData   = S.freqVec;
                    HUMIND  = (XData>= UD.HUM(1) & XData<= UD.HUM(2));
                    
                    switch UD.show_coh
                        case 'Cxy'
                            YData   = S.Cxy;
                            %                                 YData(HUMIND)   = 0;
                        case 'Pxx'
                            YData   = S.Pxx;
                            %                                 YData(HUMIND)   = 0;
                        case 'Pyy'
                            YData   = S.Pyy;
                            %                                 YData(HUMIND)   = 0;
                        case 'Phase'
                            YData   = S.Phi;
                            YData(HUMIND)   = NaN;
                    end
                    %YData   = unit_adjustment(YData,S);
                    
                    
                    switch UD.show_coh
                        case 'Phase'
                            
                            PhiCL   = S.PhiErr;
                            
                            terrorbar(hAx,[XData';XData';XData'],...
                                [YData'-2*pi;YData';YData'+2*pi],...
                                [PhiCL';PhiCL';PhiCL'],...
                                'ok','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0.5],'MarkerSize',4,'Tag','sigphi');
                            
                            
                            
                            
                            cont    = uicontextmenu('Parent',UD.fig);
                            uimenu(cont,'Label','uiregress','callback','uiregress2(''sigphi'')')
                            
                            set(hAx,'UIContextMenu',cont,...
                                'XLim',UD.FOI,...
                                'YLim',[-3*pi pi],...
                                'YTickMode','manual',...
                                'YTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
                                'YTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'});
                        case 'Cxy'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            set(hAx,'Nextplot','add');
                            plot(hAx,[XData(1) XData(end)],[S.c95 S.c95],'--','Color',[0.5 0.5 0.5]);
                            %                                 axis(hAx,'tight')
                            set(hAx,'XLim',UD.FOI,...
                                'YLim',UD.CLim);
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'coh');
                            end
                        case 'Pxx'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            %                                     axis(hAx,'tight')
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Power');
                            end
                        case 'Pyy'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            %                                     axis(hAx,'tight')
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Power');
                            end
                    end
                    
                    set(get(hAx,'Title'),'String',{filename;['npairs= ',num2str(length(S.nTrials))]});
                    gofront(get(hAx,'Title'));
                    %% COH
                case 'COH'
                    
                    XData   = S.freqVec;
                    HUMIND  = (XData>=UD.HUM(1) & XData<=UD.HUM(2));
                    FOIIND  = (XData>=UD.FOI(1) & XData<=UD.FOI(2));

                    
                    switch UD.show_coh
                        case 'Cxy'
                            YData   = S.Cxy;
                            CLim    = UD.CLim; 
                            %                                 YData(HUMIND)   = 0;
                        case 'Pxx'
                            YData   = S.Pxx;
                            YData   = log10(YData);
                            CLim    = [min(YData(FOIIND)),max(YData(FOIIND))];
                            %                                 YData(HUMIND)   = 0;
                        case 'Pyy'
                            YData   = S.Pyy;
                            YData   = log10(YData);
                            CLim    = [min(YData(FOIIND)),max(YData(FOIIND))];
                            %                                 YData(HUMIND)   = 0;
                        case 'Phase'
                            YData   = S.Phi;
                            YData(HUMIND)   = NaN;
                    end
                    %YData   = unit_adjustment(YData,S);
                    
                    switch UD.show_coh
                        case 'Phase'
                            
                            sigind  = S.Cxy > S.c95;
                            if(isfield(S,'maxclust'))
                                if(isempty(S.maxclust))
                                    isinmaxclust = false(size(sigind));
                                else
                                    if(S.maxclustpeak > UD.COH_peak_th)
                                        isinmaxclust = XData>=S.maxclust(1) & XData<=S.maxclust(end);
                                    else
                                        isinmaxclust = false(size(sigind));
                                    end
                                end
                            else
                                isinmaxclust = true(size(sigind));
                            end
                            sigclustind  = sigind & isinmaxclust;
                            signonclustind  = sigind & ~isinmaxclust;
                            
                            
                            PhiCL   = phasecl(S.nTrials,S.Cxy);
                            if(any(sigind))
                                %                                     terrorbar(hAx,[XData';XData';XData'],...
                                %                                         [nanmask(YData,signonclustind)'-2*pi;nanmask(YData,signonclustind)';nanmask(YData,signonclustind)'+2*pi],...
                                %                                         [nanmask(PhiCL,signonclustind)';nanmask(PhiCL,signonclustind)';nanmask(PhiCL,signonclustind)'],...
                                %                                         'o','Color',[0.75 0.75 0.75],'MarkerEdgeColor','none','MarkerFaceColor',[0.75 0.75 0.75],'MarkerSize',4,'Tag','signonclust');
                                
                                terrorbar(hAx,[XData';XData';XData'],...
                                    [nanmask(YData,sigclustind)'-2*pi;nanmask(YData,sigclustind)';nanmask(YData,sigclustind)'+2*pi],...
                                    [nanmask(PhiCL,sigclustind)';nanmask(PhiCL,sigclustind)';nanmask(PhiCL,sigclustind)'],...
                                    'ok','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0.5],'MarkerSize',4,'Tag','sigclust');
                                
                            else
                                
                            end
                            
                            cont    = uicontextmenu('Parent',UD.fig);
                            uimenu(cont,'Label','uiregress','callback','uiregress(''sigclust'',''phase'')')
                            
                            set(hAx,'UIContextMenu',cont,...
                                'XLim',UD.FOI,...
                                'YLim',[-3*pi pi],...
                                'YTickMode','manual',...
                                'YTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
                                'YTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'});
                            
                        case 'Cxy'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            set(hAx,'Nextplot','add');
                            plot(hAx,[XData(1) XData(end)],[S.c95 S.c95],'--','Color',[0.5 0.5 0.5]);
                            %                                 axis(hAx,'tight')
                            set(hAx,'XLim',UD.FOI,'YLim',CLim);
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'coh');
                            end
                            
                        case 'Pxx'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            %                                 axis(hAx,'tight')
                            set(hAx,'XLim',UD.FOI,'YLim',CLim);
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Log10(Power)');
                            end
                        case 'Pyy'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            %                                 axis(hAx,'tight')
                            set(hAx,'XLim',UD.FOI,'YLim',CLim);
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Log10(Power)');
                            end
                            
                    end
                    
                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(S.nSegments)]});
                    gofront(get(hAx,'Title'));
                    %% AVECOH
                case 'AVECOH'
                    
                    XData   = S.freqVec;
                    HUMIND  = (XData>=UD.HUM(1)&XData<=UD.HUM(2));
                    FOIIND  = (XData>=UD.FOI(1)&XData<=UD.FOI(2));
                    
                    switch UD.show_coh
                        case 'Cxy'
                            YData   = S.Cxy;
                            %                                 YData(HUMIND)   = 0;
                        case 'Pxx'
                            YData   = S.Pxx;
                            %                                 YData(HUMIND)   = 0;
                        case 'Pyy'
                            YData   = S.Pyy;
                            %                                 YData(HUMIND)   = 0;
                        case 'Phase'
                            YData   = S.Phi;
                            YData(HUMIND)   = NaN;
                    end
                    %YData   = unit_adjustment(YData,S);
                    
                    switch UD.show_coh
                        case 'Phase'
                            dfreq   = S.freqVec(2)-S.freqVec(1);
                            sigind  = (S.Cxy > S.c95 & FOIIND);
                            sigind  = findcont(sigind,floor(UD.kkfreq/dfreq),floor(UD.nnfreq/dfreq));
                            clssig  = findclust(sigind);
                            if(~isempty(clssig));
                                [temps,maxind]  = max([clssig(:).n]);
                                maxclust        = clssig(maxind);
                                isinmaxclust    = 1:length(XData);
                                isinmaxclust    = (isinmaxclust>=maxclust.first & isinmaxclust<=maxclust.last);
                            end
                            
                            sigind  = (S.Cxy > S.c95 & FOIIND);
                            sigind  = sigind & isinmaxclust;
                            %                                 if(isfield(S,'maxclust'))
                            %                                     if(isempty(S.maxclust))
                            %                                         isinmaxclust = false(size(sigind));
                            %                                     else
                            %                                         isinmaxclust = XData>=S.maxclust(1) & XData<=S.maxclust(end);
                            %                                     end
                            %                                 else
                            %                                     isinmaxclust = true(size(sigind));
                            %                                 end
                            %                                 sigclustind  = sigind & isinmaxclust;
                            %                                 signonclustind  = sigind & ~isinmaxclust;
                            
                            
                            PhiCL   = S.PhiErr;
                            %
                            %                                     terrorbar(hAx,[XData';XData';XData'],...
                            %                                         [YData'-2*pi;YData';YData'+2*pi],...
                            %                                         [PhiCL';PhiCL';PhiCL'],...
                            %                                         'o','Color',[0.75 0.75 0.75],'MarkerEdgeColor','none','MarkerFaceColor',[0.75 0.75 0.75],'MarkerSize',4,'Tag','signonclust');
                            
                            terrorbar(hAx,[XData';XData';XData'],...
                                [nanmask(YData,sigind)'-2*pi;nanmask(YData,sigind)';nanmask(YData,sigind)'+2*pi],...
                                [nanmask(PhiCL,sigind)';nanmask(PhiCL,sigind)';nanmask(PhiCL,sigind)'],...
                                'ok','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0.5],'MarkerSize',4,'Tag','sigclust');
                            
                            
                            
                            
                            
                            cont    = uicontextmenu('Parent',UD.fig);
                            uimenu(cont,'Label','uiregress','callback','uiregress2(''sigclust'')')
                            
                            set(hAx,'UIContextMenu',cont,...
                                'XLim',UD.FOI,...
                                'YLim',[-3*pi pi],...
                                'YTickMode','manual',...
                                'YTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
                                'YTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'});
                        case 'Cxy'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            set(hAx,'Nextplot','add');
                            plot(hAx,[XData(1) XData(end)],[S.c95 S.c95],'--','Color',[0.5 0.5 0.5]);
                            %                                 axis(hAx,'tight')
                            set(hAx,'XLim',UD.FOI,'YLim',UD.CLim);
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'coh');
                            end
                            
                        case 'Pxx'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            %                                 axis(hAx,'tight')
                            xlim(FOI)
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Power');
                            end
                        case 'Pyy'
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5])
                            %                                 axis(hAx,'tight')
                            xlim(FOI)
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Power');
                            end
                            
                    end
                    
                    set(get(hAx,'Title'),'String',{filename;['npairs=',num2str(length(S.nTrials))]});
                    gofront(get(hAx,'Title'));
                    
                    %% DCOH
                case 'DCOH'
                    %                     DCOHind         = strfind(fullfilename,'DCOH');
                    %                     COHfullfilename = [fullfilename(1:(DCOHind(1)-1)),fullfilename((DCOHind(1)+1):(DCOHind(2)-1)),fullfilename((DCOHind(2)+1):length(fullfilename))];
                    %
                    %                     if(exist(COHfullfilename,'file'))
                    %                         isCOHfile   = true;
                    %                         COH         = load(COHfullfilename);
                    %                     else
                    isCOHfile   = false;
                    %                     end
                    
                    show_maxclust   = false;
                    
                    XData   = S.freqVec;
                    HUMIND  = (XData>=UD.HUM(1)&XData<=UD.HUM(2));
                    
                    switch UD.show_dcoh(end-1:end)
                        case 'yx'       % LFP->EMG
                            CohData   = S.Cyx;
                            PhiData   = S.Phiyx;
                            if(show_maxclust)
                                if(isfield(S,'maxclustCyx'))
                                    maxclust    = S.maxclustCyx;
                                    if(isempty(maxclust))
                                        isinmaxclust = false(size(XData));
                                    else
                                        isinmaxclust = XData>=maxclust(1) & XData<=maxclust(end);
                                    end
                                else
                                    isinmaxclust = true(size(XData));
                                end
                            else
                                isinmaxclust = true(size(XData));
                            end
                            
                        case 'xy'       % EMG->LFP
                            CohData   = S.Cxy;
                            PhiData   = - S.Phixy;
                            if(show_maxclust)
                                if(isfield(S,'maxclustCxy'))
                                    maxclust    = S.maxclustCxy;
                                    if(isempty(maxclust))
                                        isinmaxclust = false(size(XData));
                                    else
                                        isinmaxclust = XData>=maxclust(1) & XData<=maxclust(end);
                                    end
                                else
                                    isinmaxclust = true(size(XData));
                                end
                                
                            else
                                isinmaxclust = true(size(XData));
                            end
                            
                        case 'xx'
                            CohData   = S.Cxx;
                            PhiData   = S.Phixx;
                            if(show_maxclust)
                                if(isfield(S,'maxclustCxx'))
                                    maxclust    = S.maxclustCxx;
                                    if(isempty(maxclust))
                                        isinmaxclust = false(size(XData));
                                    else
                                        isinmaxclust = XData>=maxclust(1) & XData<=maxclust(end);
                                    end
                                else
                                    isinmaxclust = true(size(XData));
                                end
                            else
                                isinmaxclust = true(size(XData));
                            end
                            
                        case 'yy'
                            CohData   = S.Cyy;
                            PhiData   = S.Phiyy;
                            if(show_maxclust)
                                if(isfield(S,'maxclustCyy'))
                                    maxclust    = S.maxclustCyy;
                                    if(isempty(maxclust))
                                        isinmaxclust = false(size(XData));
                                    else
                                        isinmaxclust = XData>=maxclust(1) & XData<=maxclust(end);
                                    end
                                else
                                    isinmaxclust = true(size(XData));
                                end
                            else
                                isinmaxclust = true(size(XData));
                            end
                    end
                    
                    if(isCOHfile)
                        if(show_maxclust)
                            if(isfield(COH,'maxclust'))
                                if(isempty(COH.maxclust))
                                    isinCOHmaxclust = false(size(XData));
                                else
                                    if(COH.maxclustpeak > UD.COH_peak_th)
                                        isinCOHmaxclust = XData>=COH.maxclust(1) & XData<=COH.maxclust(end);
                                    else
                                        isinCOHmaxclust = false(size(XData));
                                    end
                                end
                            else
                                isinCOHmaxclust = true(size(XData));
                            end
                        else
                            isinCOHmaxclust = true(size(XData));
                        end
                    end
                    
                    %                         CohData(HUMIND) =0;
                    PhiData(HUMIND)= NaN;
                    
                    
                    switch UD.show_dcoh(1)
                        case 'P'
                            sigind  = CohData > S.c95;
                            if(isCOHfile)
                                sigclustind  = sigind & isinCOHmaxclust;
                                signonclustind  = sigind & ~isinCOHmaxclust;
                            else
                                sigclustind  = sigind & isinmaxclust;
                                signonclustind  = sigind & ~isinmaxclust;
                            end
                            PhiCL   = abs(phasecl(S.nTrials,CohData));
                            
                            if(any(sigind))
                                %                                     terrorbar(hAx,[XData';XData';XData'],...
                                %                                         [nanmask(PhiData,signonclustind)'-2*pi;nanmask(PhiData,signonclustind)';nanmask(PhiData,signonclustind)'+2*pi],...
                                %                                         [nanmask(PhiCL,signonclustind)';nanmask(PhiCL,signonclustind)';nanmask(PhiCL,signonclustind)'],...
                                %                                         'o','Color',[0.75 0.75 0.75],'MarkerEdgeColor','none','MarkerFaceColor',[0.75 0.75 0.75],'MarkerSize',4,'Tag','signonclust');
                                
                                terrorbar(hAx,[XData';XData';XData'],...
                                    [nanmask(PhiData,sigclustind)'-2*pi;nanmask(PhiData,sigclustind)';nanmask(PhiData,sigclustind)'+2*pi],...
                                    [nanmask(PhiCL,sigclustind)';nanmask(PhiCL,sigclustind)';nanmask(PhiCL,sigclustind)'],...
                                    'ok','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0.5],'MarkerSize',4,'Tag','sigclust');
                            else
                                plot(XData,nan(size(XData)));
                            end
                            
                            cont    = uicontextmenu('Parent',UD.fig);
                            uimenu(cont,'Label','uiregress','callback','uiregress(''sigclust'',''phase'')')
                            
                            set(hAx,'UIContextMenu',cont,...
                                'XLim',UD.FOI,...
                                'YLim',[-3*pi pi],...
                                'YTickMode','manual',...
                                'YTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
                                'YTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'});
                        case 'C'
                            tdsplot(hAx,XData,CohData,'Color',[0 0 0.5])
                            set(hAx,'Nextplot','add');
                            plot(hAx,[XData(1) XData(end)],[S.c95 S.c95],'--','Color',[0.5 0.5 0.5]);
                            %                                 axis(hAx,'tight')
                            set(hAx,'XLim',UD.FOI,'YLim',UD.CLim);
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'coh');
                            end
                            
                    end
                    
                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(S.nTrials)]});
                    gofront(get(hAx,'Title'));
                    
                    
                    %% AVEDCOH
                case 'AVEDCOH'
                    XData   = S.freqVec;
                    HUMIND  = (XData>=UD.HUM(1)&XData<=UD.HUM(2));
                    FOIIND  = (XData>=UD.FOI(1)&XData<=UD.FOI(2));
                    switch UD.show_dcoh(end-1:end)
                        
                        case 'yx'       % LFP->EMG
                            CohData   = S.Cyx;
                            PhiData   = S.Phiyx;
                            PhiCL     = S.PhiyxErr;
                            
                        case 'xy'       % EMG->LFP
                            CohData   = S.Cxy;
                            PhiData   = - S.Phixy;
                            PhiCL     = S.PhixyErr;
                            
                        case 'xx'
                            CohData   = S.Cxx;
                            PhiData   = S.Phixx;
                            PhiCL     = S.PhixxErr;
                            
                        case 'yy'
                            CohData   = S.Cyy;
                            PhiData   = S.Phiyy;
                            PhiCL     = S.PhiyyErr;
                    end
                    
                    %                         CohData(HUMIND) =0;
                    PhiData(HUMIND)= NaN;
                    
                    switch UD.show_dcoh(1)
                        case 'P'
                            dfreq   = S.freqVec(2)-S.freqVec(1);
                            sigind  = (CohData > S.c95 & FOIIND);
                            sigind  = findcont(sigind,floor(UD.kkfreq/dfreq),floor(UD.nnfreq/dfreq));
                            clssig  = findclust(sigind);
                            if(~isempty(clssig));
                                [temps,maxind]  = max([clssig(:).n]);
                                maxclust        = clssig(maxind);
                                isinmaxclust    = 1:length(XData);
                                isinmaxclust    = (isinmaxclust>=maxclust.first & isinmaxclust<=maxclust.last);
                            end
                            
                            sigind  = (CohData > S.c95 & FOIIND);
                            sigind  = sigind & isinmaxclust;
                            
                            terrorbar(hAx,[XData';XData';XData'],...
                                [nanmask(PhiData,sigind)'-2*pi;nanmask(PhiData,sigind)';nanmask(PhiData,sigind)'+2*pi],...
                                [nanmask(PhiCL,sigind)';nanmask(PhiCL,sigind)';nanmask(PhiCL,sigind)'],...
                                'ok','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0.5],'MarkerSize',4,'Tag','sigclust');
                            
                            cont    = uicontextmenu('Parent',UD.fig);
                            uimenu(cont,'Label','uiregress','callback','uiregress2(''sigclust'')')
                            
                            set(hAx,'UIContextMenu',cont,...
                                'XLim',UD.FOI,...
                                'YLim',[-3*pi pi],...
                                'YTickMode','manual',...
                                'YTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
                                'YTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'});
                        case 'C'
                            %                                 disp('takei')
                            tdsplot(hAx,XData,CohData,'Color',[0 0 0.5])
                            set(hAx,'Nextplot','add');
                            plot(hAx,[XData(1) XData(end)],[S.c95 S.c95],'--','Color',[0.5 0.5 0.5]);
                            %                                 axis(hAx,'tight')
                            set(hAx,'XLim',UD.FOI,...
                                'YLim',UD.CLim);
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'coh');
                            end
                            
                    end
                    
                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(length(S.nTrials))]});
                    gofront(get(hAx,'Title'));

                    %% FMCMP
                case 'FMCMP'
                    
                    fname   = UD.show_fmcmp;
                    
                    if(isempty(S.(fname)))
                        FaceColor   = [0.5 0.5 0.5];
                    else
                        if(S.(fname).h)
                            FaceColor   = [0 0.5 0];
                        else
                            FaceColor   = [0.5 0.5 0.5];
                        end
                    end
                    
                    hL  = terrorbar_bar(hAx,1:length(S.mean),S.mean,S.std,'BarWidth',0.5,'FaceColor',FaceColor);
                    XTickLabel  = S.gnames;
                    
                    set(hAx,'XTick',1:length(S.mean),'XTickLabel',XTickLabel,'XLim',[0.5 length(S.mean)+0.5])
                    
                    if(~isempty(S.(fname)))
                        ncomp   = size(S.(fname).comparison,1);
                        ysigbar = max(S.mean+S.std)*(1+0.02*(1:ncomp));
                        
                        comp    = S.(fname).comparison(:,1:2);
                        order   = 1:ncomp;
                        
                        set(hAx,'Nextplot','add');
                        
                        for icomp = 1:ncomp
                            if(S.(fname).comparison(order(icomp),4)==1)
                                color   = [0.5 0 0];
                                plot(hAx,comp(order(icomp),:),ones(1,2)*ysigbar(icomp),...
                                    'Color',color,...
                                    'LineStyle','-',...
                                    'LineWidth',2,...
                                    'Marker','s',...
                                    'MarkerEdgeColor',color,...
                                    'MarkerFaceColor',color,...
                                    'MarkerSize',3);
                            else
                                color   = [0.5 0.5 0.5];
                                plot(hAx,comp(order(icomp),:),ones(1,2)*ysigbar(icomp),...
                                    'Color',color,...
                                    'LineStyle',':',...
                                    'LineWidth',1,...
                                    'Marker','s',...
                                    'MarkerEdgeColor',color,...
                                    'MarkerFaceColor',color,...
                                    'MarkerSize',1);
                            end
                        end
                        
                        % dot
                        plot(hAx,[0.5 length(S.mean)+0.5],ones(1,2)*max(S.mean+S.std)*(1+0.02*(ncomp+1)),'.k');
                        
                        set(get(hAx,'Title'),'String',{filename;[fname,', p=',num2str(S.(fname).p,'%0.3f'),', n=',num2str(size(S.Data,1))]});
                    else
                        set(get(hAx,'Title'),'String',{filename;['not tested, n=',num2str(size(S.Data,1))]});
                    end
                    gofront(hL)
                    gofront(get(hAx,'Title'));
                    
                    
                case 'ANOVA1'
                    fname   = UD.show_anova1;
                    
                    if(isfield(S.(fname),'P'))  % 090420までのuianova1では間違って大文字のPとしていた。
                        S.(fname).p = S.(fname).P;
                    end
                    
                    if(S.(fname).p < 0.05)
                        FaceColor   = [0 0.5 0];
                    else
                        FaceColor   = [0.5 0.5 0.5];
                    end
                    
                    hL  = terrorbar_bar(hAx,1:length(S.mean),S.mean,S.std,'BarWidth',0.5,'FaceColor',FaceColor);
                    
                    
                    
                    set(hAx,'XTick',1:length(S.mean),'XTickLabel',S.gnames,'XLim',[0.5 length(S.mean)+0.5])
                    
                    
                    ncomp   = size(S.(fname).multcompare.comparison,1);
                    ysigbar = max(S.mean+S.std)*(1+0.02*(1:ncomp));
                    
                    comp    = S.(fname).multcompare.comparison(:,1:2);
                    order   = 1:ncomp;
                    
                    set(hAx,'Nextplot','add');
                    
                    for icomp = 1:ncomp
                        if(S.(fname).multcompare.issig(order(icomp)))
                            color   = [0.5 0 0];
                            plot(hAx,comp(order(icomp),:),ones(1,2)*ysigbar(icomp),...
                                'Color',color,...
                                'LineStyle','-',...
                                'LineWidth',2,...
                                'Marker','s',...
                                'MarkerEdgeColor',color,...
                                'MarkerFaceColor',color,...
                                'MarkerSize',3);
                        else
                            color   = [0.5 0.5 0.5];
                            plot(hAx,comp(order(icomp),:),ones(1,2)*ysigbar(icomp),...
                                'Color',color,...
                                'LineStyle',':',...
                                'LineWidth',1,...
                                'Marker','s',...
                                'MarkerEdgeColor',color,...
                                'MarkerFaceColor',color,...
                                'MarkerSize',1);
                        end
                    end
                    
                    set(get(hAx,'Title'),'String',{filename;[fname,', p=',num2str(S.(fname).p,'%0.3f'),', n=',num2str(size(S.Data,1))]});
                    gofront(hL)
                    gofront(get(hAx,'Title'));
                    
                    
                    
                    
                    
                case 'ANOVA2'
                    fname   = 'anova2';
                    
                    if(isfield(S.(fname),'P'))  % 090420までのuianova1では間違って大文字のPとしていた。
                        S.(fname).p = S.(fname).P;
                    end
                    
                    %                         if(S.(fname).p(3) < 0.05)
                    %                             Color   = [0 0.5 0];
                    %                         else
                    %                             Color   = [0.5 0.5 0.5];
                    %                         end
                    %
                    
                    Color   = [0.5 0 0;...
                        0 0 0.5];
                    [ncond1,ncond2]  = size(S.mean);
                    
                    set(hAx,'Nextplot','replacechildren');
                    hL  =zeros(1,ncond1);
                    for icond1=1:ncond1
                        hL(icond1)  = terrorbar(hAx,1:ncond2,S.mean(icond1,:),S.std(icond1,:),'d-','Color',Color(icond1,:),'MarkerFaceColor',Color(icond1,:));
                        set(hAx,'Nextplot','add');
                    end
                    legend(hL,S.gnames1,'Location','Best')
                    
                    set(hAx,'XTick',1:ncond2,'XTickLabel',S.gnames2,'XLim',[0.5 ncond2+0.5])
                    
                    set(get(hAx,'Title'),'String',{filename;[fname,', p=[',num2str(S.(fname).p(1),'%0.3f'),',',num2str(S.(fname).p(2),'%0.3f'),',',num2str(S.(fname).p(3),'%0.3f'),'], n=',num2str(size(S.Data,1))]});
                    %                         gofront(hL)
                    gofront(get(hAx,'Title'));
                    
                    
                 case 'TTEST'
                                        
                                       
                    if(S.p < S.alpha)
                        FaceColor   = [0 0.5 0];
                    else
                        FaceColor   = [0.5 0.5 0.5];
                    end
                    
                    hL  = terrorbar_bar(hAx,1:length(S.mean),S.mean,S.std,'BarWidth',0.5,'FaceColor',FaceColor);
                    
                    
                    
                    set(hAx,'XTick',1:length(S.mean),'XTickLabel',S.gnames,'XLim',[0.5 length(S.mean)+0.5])
                    
                    
                    
                    set(get(hAx,'Title'),'String',{filename;[S.vartype,'p=',num2str(S.p,'%0.3f'),', n=',num2str(S.n)]});
                    gofront(hL)
                    gofront(get(hAx,'Title'));   
                    
                case 'AVEMF'
                    %                         if(isempty(UD.psename))
                    %                             psename   = fieldnames(S);
                    %                             psename   = strfilt(psename,'pse');
                    %                             UD.psename      = uichoice(psename,'AVEMF: PSEの選択');
                    %                         end
                    %                         psename = UD.psename;
                    
                    if(isempty(UD.show_avemf))
                        %                             fname   = fieldnames(S.(psename));
                        fname   = fieldnames(S);
                        UD.show_avemf      = uichoice(fname,'AVEMF: 変数の選択');
                    end
                    fname   = UD.show_avemf;
                    
                    %                             fname   =
                    try
                        if(strfind(lower(fname),'mtx'))
                            
                            %                                     YData   = S.(psename).(fname);
                            YData   = S.(fname);
                            YData   = zeromask(YData,~isnan(YData));
                            
                            EMGind     = EMGprop(S.EMGName);
                            if(isfield(S,'nGroup'))
                                if(size(YData,1)==S.nGroup)
                                    YData   = S.(fname);
                                    %                                             if(isfield(S,'GroupMFMTXSurpH'))
                                    %                                                 YData   = YData.* S.GroupMFMTXSurpH;
                                    %                                             end
                                    Label   = S.GroupName;
                                else
                                    %                                             if(isfield(S,'MFMTXSurpH'))
                                    %                                                 YData   = YData.* S.MFMTXSurpH;
                                    %                                             end
                                    Label   = EMGind.Name;
                                end
                            else
                                %                                         if(isfield(S,'MFMTXSurpH'))
                                %                                                 YData   = YData.* S.MFMTXSurpH;
                                %                                         end
                                Label   = EMGind.Name;
                                %                                         YData   = sortmtx(YData,EMGind.Order);
                                %                                         Label   = sortind(Label,EMGind.Order);
                            end
                            
                            nLabel  = length(Label);
                            XData   = 1:nLabel;
                            
                            %%% comment out to exclude leftbottom half
                            %                                     YData(logical(leftbottom(size(YData,1))))   = max(max(YData));
                            %                                     YData(logical(eye(size(YData,1))))          = max(max(YData));
                            %                                     YData(logical(eye(size(YData,1))))          = 0;
                            %%%
                            
                            %%% 画像として保存する場合はimagesc
                            imagesc(XData,XData,YData,'parent',hAx);
                            %%%
                            
                            %%% vectorとして保存する場合はpcolor
                            %                                     YData   = [YData, nan(size(YData,1),1)];
                            %                                     YData   = [YData; nan(1,size(YData,2))];
                            %                                     pcolor(hAx,[XData XData(end)+1],[XData XData(end)+1],YData);
                            %%%
                            
                            
                            set(hAx,'XAxisLocation','bottom',...
                                'XTick',XData,'XTickLabel',Label,...
                                'YTick',XData,'YTickLabel',Label);
                            axis(hAx,'ij','square')
                            %                                     clim(hAx,[-max(max(YData)) max(max(YData))])
                            colormap(hAx,hot2)
                            
                            
                            set(get(hAx,'Title'),'String',{filename,fname});
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Name');
                            end
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,'Name');
                            end
                        else
                            switch fname(1:3)
                                case 'clu'
                                    YData   = S.(psename).(fname);
                                    axes(hAx);
                                    dendrogram(YData,'LABEL',parseEMG(S.EMGName));
                                    
                                otherwise
                                    YData   = S.(psename).(fname);
                                    if(dimens(YData)==1);
                                        
                                        
                                        YData   = nanmask(S.(psename).(fname),S.(psename).(fname)~=0);
                                        %                                                     keyboard
                                        [YData,XData]   = hist(YData,1:max(YData));
                                        bar(hAx,XData,YData,1,'FaceColor',[0 0 0.5]);
                                        
                                        set(get(hAx,'Title'),'String',{filename,fname});
                                        if(~isempty(get(get(hAx,'YLabel'),'String')))
                                            ylabel(hAx,'Count');
                                        end
                                        if(~isempty(get(get(hAx,'XLabel'),'String')))
                                            xlabel(hAx,fname);
                                        end
                                    elseif(dimens(YData)==2);
                                        EMGind     = EitoEMG;
                                        if(size(YData,2)==length(EMGind.GroupName))
                                            Label   = EMGind.GroupName;
                                        else
                                            Label   = EMGind.Name;
                                            YData   = sortmtx(YData,EMGind.Order,2);
                                            Label   = sortind(Label,EMGind.Order);
                                            
                                        end
                                        nLabel  = length(Label);
                                        XData   = 1:nLabel;
                                        
                                        imagesc(XData,XData,YData,'parent',hAx);
                                        
                                        
                                        set(hAx,'XAxisLocation','bottom',...
                                            'XTick',XData,'XTickLabel',Label);
                                        axis(hAx,'ij','square')
                                        clim(hAx,[-max(max(YData)) max(max(YData))])
                                        colormap(hAx,tmap1)
                                        
                                        
                                        set(get(hAx,'Title'),'String',{filename,fname});
                                        if(~isempty(get(get(hAx,'YLabel'),'String')))
                                            ylabel(hAx,'Name');
                                        end
                                        if(~isempty(get(get(hAx,'XLabel'),'String')))
                                            xlabel(hAx,'Name');
                                        end
                                        
                                        
                                    end
                            end
                            
                            
                        end
                    catch
                        UD.show_avemf   = [];
                    end
                    
                    
                    %                             gofront(hL)
                    gofront(get(hAx,'Title'));
                    
                    %%
                case 'MF'
                    if(isempty(UD.psename))
                        psename   = fieldnames(S);
                        psename   = strfilt(psename,'pse');
                        UD.psename      = uichoice(psename,'MF: PSEの選択');
                    end
                    psename = UD.psename;
                    
                    
                    
                    %%%%% MFの場合は、PSF=赤　PSS=青　SF=赤抜き　SS=青抜き
                    
                    MarkerSize  = 15;
                    
                    EMGind = EMGprop(S.EMGName);
                    Label   = EMGind.Name;
                    
                    XData   = 1:length(Label);
                    
                    YPSF    = nanmask(ones(size(XData)),S.(psename).isPSF);
                    YPSS    = nanmask(ones(size(XData)),S.(psename).isPSS);
                    YSF     = nanmask(ones(size(XData)),S.(psename).isSF);
                    YSS     = nanmask(ones(size(XData)),S.(psename).isSS);
                    Ynone   = nanmask(ones(size(XData)),~S.(psename).isAny);
                    
                    Label   = sortind(Label,EMGind.Order);
                    YPSF    = sortind(YPSF,EMGind.Order);
                    YPSS    = sortind(YPSS,EMGind.Order);
                    YSF     = sortind(YSF,EMGind.Order);
                    YSS     = sortind(YSS,EMGind.Order);
                    Ynone   = sortind(Ynone,EMGind.Order);
                    
                    
                    hL  = zeros(1,5);
                    
                    hL(1)   = plot(hAx,XData,YPSF,...
                        'LineStyle','none',...
                        'Marker','s',...
                        'MarkerEdgeColor',[0.75 0 0],...
                        'MarkerFacecolor',[0.75 0 0],...
                        'MarkerSize',MarkerSize);
                    set(hAx,'Nextplot','add');
                    hL(2)   = plot(hAx,XData,YPSS,...
                        'LineStyle','none',...
                        'Marker','s',...
                        'MarkerEdgeColor',[0 0 0.75],...
                        'MarkerFacecolor',[0 0 0.75],...
                        'MarkerSize',MarkerSize);
                    hL(3)   = plot(hAx,XData,YSF,...
                        'LineStyle','none',...
                        'Marker','s',...
                        'MarkerEdgeColor',[1.0 0.6 0.784],...
                        'MarkerFacecolor',[1.0 0.6 0.784],...
                        'MarkerSize',MarkerSize);
                    hL(4)   = plot(hAx,XData,YSS,...
                        'LineStyle','none',...
                        'Marker','s',...
                        'MarkerEdgeColor',[0.68 0.92 1.0],...
                        'MarkerFacecolor',[0.68 0.92 1.0],...
                        'MarkerSize',MarkerSize);
                    hL(5)   = plot(hAx,XData,Ynone,...
                        'LineStyle','none',...
                        'Marker','s',...
                        'MarkerEdgeColor',[0 0 0],...
                        'MarkerFacecolor',[0 0 0],...
                        'MarkerSize',MarkerSize);
                    
                    %                             set(get(hAx,'Title'),'String',{filename,UD.show_mf});
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        %                                 ylabel(hAx,'mf');
                        ylabel(hAx,{filename,UD.show_mf},...
                            'HorizontalAlignment','right',...
                            'Rotation',0,...
                            'VerticalAlignment','middle');
                        set(hAx,'YTick',[],...
                            'YTickLabel',[])
                    else
                        set(hAx,'YColor',[1 1 1]);
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'Name');
                        set(hAx,'XTick',XData,...
                            'XTickLabel',Label);
                    else
                        set(hAx,'XColor',[1 1 1]);
                    end
                    %                             keyboard
                    
                    %%%%% MFの場合は、PSF=赤　PSS=青　SF=赤抜き　SS=青抜き
                    %                             if(isempty(UD.show_mf))
                    %                                 fname   = fieldnames(S.(psename));
                    %                                 UD.show_mf      = uichoice(fname,'MF: 変数の選択');
                    %                             end
                    %                             fname   = UD.show_mf;
                    %
                    %                             YData   = S.(psename).(fname);
                    %                             try
                    %                                 if(sum(size(YData)>1)==2)
                    %
                    %                                     %                                     YData   = S.(psename).(fname);
                    %
                    %                                     EMGind     = EitoEMG;
                    %                                     if(size(YData,1)==length(EMGind.GroupName))
                    %                                         Label   = EMGind.GroupName;
                    %                                     else
                    %                                         Label   = EMGind.Name;
                    %                                         YData   = sortmtx(YData,EMGind.Order);
                    %                                         Label   = sortind(Label,EMGind.Order);
                    %                                     end
                    %                                     nLabel  = length(Label);
                    %                                     XData   = 1:nLabel;
                    %
                    %                                     YData(logical(leftbottom(size(YData,1))))    = nan;
                    %                                         YData(logical(eye(size(YData,1))))    = nan;
                    %                                     imagesc(XData,XData,YData,'parent',hAx);
                    %
                    %
                    %                                     set(hAx,'XAxisLocation','bottom',...
                    %                                         'XTick',XData,'XTickLabel',Label,...
                    %                                         'YTick',XData,'YTickLabel',Label);
                    %                                     axis(hAx,'ij','square')
                    %
                    %                                     clim(hAx,[-1*max(max(max(YData)),1), max(max(max(YData)),1)])
                    %                                     colormap(hAx,tmap1)
                    %
                    %
                    %                                     set(get(hAx,'Title'),'String',{filename,UD.show_mf});
                    %                                     if(~isempty(get(get(hAx,'YLabel'),'String')))
                    %                                         ylabel(hAx,'Name');
                    %                                     end
                    %                                     if(~isempty(get(get(hAx,'XLabel'),'String')))
                    %                                         xlabel(hAx,'Name');
                    %                                     end
                    %                                 elseif(sum(size(YData)>1)==1)
                    %
                    %                                     EMGind = EMGprop(S.EMGName);
                    %                                     if(length(YData)==length(EMGind.GroupNames))
                    %
                    %                                         Label   = EMGind.GroupNames;
                    %                                                                                 keyboard
                    %                                     else
                    %                                         Label   = EMGind.Name;
                    %                                         YData   = sortind(YData,EMGind.Order);
                    %                                         Label   = sortind(Label,EMGind.Order);
                    %                                     end
                    %                                     nLabel  = length(Label);
                    %                                     XData   = 1:nLabel;
                    %
                    %                                     if(islogical(YData))
                    %                                         imagesc(1,XData,YData,'Parent',hAx);
                    %                                         colormap(hAx,'gray')
                    %                                         set(hAx,'CLim',[0 1])
                    %                                         box(hAx,'on')
                    %                                     else
                    %
                    %                                         bar(hAx,XData,YData,'Facecolor',[0 0 0.5]);
                    %
                    %                                     end
                    %
                    %                                     set(get(hAx,'Title'),'String',{filename,fname});
                    %                                     if(~isempty(get(get(hAx,'YLabel'),'String')))
                    %                                         ylabel(hAx,'Count');
                    %                                     end
                    %                                     if(~isempty(get(get(hAx,'XLabel'),'String')))
                    %                                         xlabel(hAx,fname);
                    %                                         set(hAx,'XTick',XData,...
                    %                                             'XTickLabel',Label)
                    %                                     end
                    %                                 elseif(sum(size(YData)>1)==0)
                    %                                     XData   = 1;
                    %                                     bar(hAx,XData,YData,'Facecolor',[0 0 0.5]);
                    %
                    %                                     set(get(hAx,'Title'),'String',{filename,fname});
                    %                                     if(~isempty(get(get(hAx,'YLabel'),'String')))
                    %                                         ylabel(hAx,'Count');
                    %                                     end
                    %                                     if(~isempty(get(get(hAx,'XLabel'),'String')))
                    %                                         xlabel(hAx,fname);
                    %                                     end
                    %
                    %                                 end
                    %                             catch
                    % %                                 keyboard
                    %                                 UD.show_mf  = [];
                    %                             end
                    % %
                    %
                    %                             %                             gofront(hL)
                    %                             gofront(get(hAx,'Title'));
                    %
                case 'LINKAGE'
                    Data    = S.linkage;
                    Label   = S.Label2;
                    th      = 0.7;
                    axes(hAx)
                    hL  = dendrogram(S.linkage,'Labels',S.Label2,...
                        'Colorthreshold',th,... % 0.7* * max(S.linkage(:,3))
                        'Orientation','top');
                    
                    set(hL,'LineWidth',2)
                    
                    set(get(hAx,'Title'),'String',{filename,'LINKAGE'});
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        ylabel(hAx,['Distance [',S.pdist_method,']']);
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'Name');
                    end
                    
                case 'XtalkMTX'
                    %                         otherwise
                    %                              index   = EitoEMG;
                    Labelprop   = EMGprop(S.EMGName);
                    imagesc(sortmtx(S.Xtalk,Labelprop.Order),'parent',hAx);
                    Label   = sortind(S.EMGName,Labelprop.Order);
                    
                    set(hAx,'XAxisLocation','bottom',...
                        'XTick',1:length(S.EMGName),'XTickLabel',Label,...
                        'YTick',1:length(S.EMGName),'YTickLabel',Label);
                    axis(hAx,'ij','square')
                    
                    
                    set(get(hAx,'Title'),'String',{filename,'XtalkMTX'});
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        ylabel(hAx,'EMG');
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'EMG');
                    end
                    
                case 'MFIELD'
                    
                    YData   = S.Data';
                    Label   = S.Label';
                    nData   = length(YData);
                    XData   = (0:(nData-1))*2*pi/nData;
                                        
                    polarfill(hAx,XData,YData,[0 0 0.75],Label)
                    
%                     mmpolar(XData,YData,...
%                         'Style','compass',...
%                         'RLimit',[0 1.5],...
%                         'RTickValue',[0 0.5 1.0],...
%                         'TTickValue',(0:(nData-1))*(360./nData),...
%                         'TTickLabel',Label);
                    
                    
                    
                    set(get(hAx,'Title'),'String',filename);
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        ylabel(hAx,'');
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'');
                    end
                    
                case 'EMGNMF'
%                     method  = 'hybrid';
%                     method  = 'fitshuffle';
%                     method  = 'diff2';
                    method  = 'ttest';
%                     method  = 'chueng2009';
%                     method  = 'chueng2005';
                    
                    
                    testr2= mean(S.test.r2,2)';
                    shuffler2= mean(S.shuffle.r2,2)';
                    
                    testr2slope= mean(S.test.r2slope,2)';
                    shuffler2slope= mean(S.shuffle.r2slope,2)';
                    
                    
                    plot(hAx,testr2,'b-o')
                    hold(hAx,'on')
                    plot(hAx,shuffler2,'r-o')
                    
                    
                    
                    
                    switch method
                        case 'hybrid'
                            th  = 10^-5;
                            nn  = length(testr2);
                            alpha   = 0.05/nn;
                            
                            mse = nan(1,nn);
                            for ii=1:nn
                                Y   = testr2(ii:nn);
                                X   = shuffler2(ii:nn);
                                A   = Y/[X;ones(size(X))];
                                Yhat    = A*[X;ones(size(X))];
                                mse(ii) = mean((Y-Yhat).^2);
                            end
                            nsynergy = find(mse<th,1,'first');
                            
                            Y   = testr2(nsynergy:nn);
                            X   = shuffler2(nsynergy:nn);
                            A   = Y/[X;ones(size(X))];
                            X   = shuffler2;
                            
                            
                            
                            
                            
                            
                            Yhat    = A*[X;ones(size(X))];
                            plot(hAx,1:nn,Yhat,'k-')
                            
                        testr2all= S.test.r2';
                    shuffler2all=S.shuffle.r2';
                    shuffler2allhat = nan(size(shuffler2all));
                    mm  = size(shuffler2all,1);
                    for ii=1:mm
                        shuffler2allhat(ii,:)=A*[shuffler2all(ii,:);ones(1,nn)];
                    end
                    
                    p   = nan(1,nn);
                    h   = nan(1,nn);
                    for ii=1:nn
                        [h(ii),p(ii)]   = ttest(shuffler2allhat(:,ii),testr2all(:,ii),alpha,'both');
                    end
                    nsynergy    = find(h<1,1,'first')-1;
                    
                        
                        case 'fitshuffle'
                            th  = 10^-5;
                            nn  = length(testr2);
                            
                            mse = nan(1,nn);
                            for ii=1:nn
                                Y   = testr2(ii:nn);
                                X   = shuffler2(ii:nn);
                                A   = Y/[X;ones(size(X))];
                                Yhat    = A*[X;ones(size(X))];
                                mse(ii) = mean((Y-Yhat).^2);
                            end
                            nsynergy = find(mse<th,1,'first');
                            
                            Y   = testr2(nsynergy:nn);
                            X   = shuffler2(nsynergy:nn);
                            A   = Y/[X;ones(size(X))];
                            X   = shuffler2;
                            Yhat    = A*[X;ones(size(X))];
                            plot(hAx,1:nn,Yhat,'k-')
                            
                        case 'diff2'
                            nn  = length(testr2);
                            alpha   = 0.05./nn;
                            
                            difftestr2slope = [S.test.r2slope(1,:);diff(S.test.r2slope,1,1)];
                            
                            p   = nan(1,nn);
                            h   = nan(1,nn);
                            
                            for ii=1:nn
                                [h(ii),p(ii)]   = ttest(difftestr2slope(ii,:));
                                h2(ii)   = p(ii)>=alpha;
                            end
                            nsynergy    = find(h2,1,'first');
                            
                            bar(2:nn,mean(difftestr2slope(2:nn,:),2)','Parent',hAx)
                            
                            
                            
                        case 'ttest'
                            th  = 0.75;
                            nn  = length(testr2);
                            
                            alpha   = 0.05./nn;
                            
                            p   = nan(1,nn);
                            h   = nan(1,nn);
                            
                            for ii=1:nn
                                [h(ii),p(ii)]   = ttest2(S.test.r2slope(ii,:),S.shuffle.r2slope(ii,:)*th,alpha,'both');
%                                 [p(ii),h(ii)]   = signrank(S.test.r2slope(ii,:),S.shuffle.r2slope(ii,:)*th,'Alpha',alpha);
%                                 [h(ii),p(ii)]   = ttest(S.test.r2slope(ii,:),S.shuffle.r2slope(ii,:)*th,alpha,'both');
                            end
                            h2  = testr2slope<shuffler2slope*th;
                            h   = h & h2;
                            nsynergy    = find(h,1,'first')-1;
                            
                            bar(2:nn,[testr2slope(2:nn);shuffler2slope(2:nn);shuffler2slope(2:nn)*th]','Parent',hAx);
                            
                            
                        case 'chueng2009'
                            th  = 0.75;
                            nsynergy    = find(testr2slope<(th.*shuffler2slope),1,'first')-1;
                            bar([testr2slope;shuffler2slope;shuffler2slope*th]','Parent',hAx)
                            
                        case 'chueng2005'
                            th  = 10^-5;
%                             th  = 0.0085;
                            
                            nn  = length(testr2);
                            mse = nan(1,nn);
                            for ii=1:nn
                                % test
                                Y   = testr2(ii:nn);
                                X   = ii:nn;
                                A   = Y/[X;ones(size(X))];
                                Xhat    = ii:nn;
                                Yhat    = A*[Xhat;ones(size(Xhat))];
                                %     plot(Xhat,Yhat,'k-')
                                mse(ii) = mean((Y-Yhat).^2);
                                
                                %     disp(mse)
                                
                            end
                            
                            % [mse;mse<10^-5]
                            nsynergy = find(mse<th,1,'first');
                            
                            
                            Y   = testr2(nsynergy:nn);
                            X   = nsynergy:nn;
                            A   = Y/[X;ones(size(X))];
                            Xhat    = 1:nn;
                            Yhat    = A*[Xhat;ones(size(Xhat))];
                            plot(hAx,Xhat,Yhat,'k-')
                            
                    end
                    
                    plot(hAx,nsynergy,testr2(nsynergy),'k*')
                    
                    set(hAx,'XAxisLocation','bottom',...
                        'XTick',1:length(S.TargetName));
                    %
                    set(get(hAx,'Title'),'String',{filename,['N = ',num2str(nsynergy),' (',method,')']});
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        ylabel(hAx,'%VAF');
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'Name');
                    end
                    
                    axis(hAx,'square')
                    
                    
                    
                    %
                    %                     YData   = S.test.r2;
                    %
                    %
                    %                     Label   = S.TargetName;
                    %                     nLabel  = length(Label);
                    %
                    %
                    %                     for iLabel=1:nLabel
                    %                         Label{iLabel}   = num2str(iLabel,'%0.2d');
                    %                     end
                    %
                    %                     plot(hAx,1:nLabel,YData,'Color',[0 0 0.5],'Marker','o');
                    %                     if(isfield(S,'shuffle'));
                    %                         EData_mean  = mean(S.shuffle.r2,2);
                    %                         EData_sd    = std(S.shuffle.r2,[],2);
                    %                         hold(hAx,'on')
                    %                         plot(hAx,1:nLabel,EData_mean,'Color',[0.5 0 0],'Marker','o');
                    %                         hold(hAx,'off')
                    %                     end
                    %
                    %
                    %                     set(hAx,'XAxisLocation','bottom',...
                    %                         'XTick',1:nLabel,'XTickLabel',Label);
                    %
                    %                     set(get(hAx,'Title'),'String',{filename,'R2'});
                    %                     if(~isempty(get(get(hAx,'YLabel'),'String')))
                    %                         ylabel(hAx,'%');
                    %                     end
                    %                     if(~isempty(get(get(hAx,'XLabel'),'String')))
                    %                         xlabel(hAx,'Name');
                    %                     end
                    
                    
                case {'EMGPCA' , 'EMGICA'}
                    
                    switch S.AnalysisType
                        case 'EMGPCA'
                            prefix  = 'PCA';
                        case 'EMGICA'
                            prefix  = 'ICA';
                        case 'EMGNMF'
                            prefix  = 'NMF';
                    end
                    if(isempty(UD.show_emgpca))
                        UD.show_emgpca  = fieldnames(S);
                        nPCA    = size(S.coeff,1);
                        for iPCA=1:nPCA
                            UD.show_emgpca  = [UD.show_emgpca; ['coeff(',num2str(iPCA,'%0.2d'),')']];
                        end
                        UD.show_emgpca  = uichoice(UD.show_emgpca,'変数の選択');
                    end
                    %                             EMGind     = EitoEMG;
                    
                    switch UD.show_emgpca
                        case 'coeff'
                            YData   = zeromask(S.coeff,~isnan(S.coeff));
                            
                            Labelprop   = EMGprop(S.Name);
                            YLabel       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            
                            %                                     YLabel  = parseEMG(S.Name);
                            nLabel  = length(YLabel);
                            %                                     Order   = sortEMGind(YLabel,sortind(EMGind.Name,EMGind.Order));
                            
                            YData   = sortmtx(YData,Order,1);
                            YLabel  = sortind(YLabel,Order);
                            
                            XLabel  = cell(size(YLabel));
                            for iLabel=1:nLabel
                                XLabel{iLabel}   = [prefix,num2str(iLabel,'%0.2d')];
                            end
                            
                            imagesc(YData,'parent',hAx);
                            
                            
                            set(hAx,'XAxisLocation','bottom',...
                                'XTick',1:nLabel,'XTickLabel',XLabel,...
                                'YTick',1:nLabel,'YTickLabel',YLabel);
                            axis(hAx,'ij','square')
                            clim(hAx,[-1 1])
                            colormap(hAx,tmap1)
                            
                            
                            set(get(hAx,'Title'),'String',{filename,'coef'});
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Name');
                            end
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,'Name');
                            end
                        case 'explained'
                            YData   = cumsum(S.explained);
                            Label   = S.Name;
                            nLabel  = length(Label);
                            
                            
                            for iLabel=1:nLabel
                                Label{iLabel}   = [prefix,num2str(iLabel,'%0.2d')];
                            end
                            
                            plot(hAx,1:nLabel,YData,'Color',[0 0 0.5],'Marker','o');
                            
                            
                            set(hAx,'XAxisLocation','bottom',...
                                'XTick',1:nLabel,'XTickLabel',Label);
                            
                            set(get(hAx,'Title'),'String',{filename,'explained'});
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'%');
                            end
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,'Name');
                            end
                        case 'r2_mean'
                            YData   = S.r2_mean;
                            EData   = S.r2_std;
                            
                            Label   = S.Name;
                            nLabel  = length(Label);
                            
                            
                            for iLabel=1:nLabel
                                Label{iLabel}   = [prefix,num2str(iLabel,'%0.2d')];
                            end
                            
                            terrorbar(hAx,1:nLabel,YData,EData,'Color',[0 0 0.5],'Marker','o');
                            
                            
                            set(hAx,'XAxisLocation','bottom',...
                                'XTick',1:nLabel,'XTickLabel',Label);
                            
                            set(get(hAx,'Title'),'String',{filename,'R2'});
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'%');
                            end
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,'Name');
                            end
                            
                        otherwise
                            switch UD.show_emgpca(1:6)
                                case 'coeff('
                                    iPCA    = str2double(UD.show_emgpca(7:8));
                                    YData   = (S.coeff(:,iPCA))';
                                    YData   = zeromask(YData,~isnan(YData));
                                    
                                    Label   = parseEMG(S.Name);
                                    %                                             Labelprop   = EMGprop(S.Name);
                                    %                                     Label       = Labelprop.Name;
                                    %                                     Order       = Labelprop.Order;
                                    
                                    %                                             YData   = sortind(YData,Order);
                                    %                                             Label   = sortind(Label,Order);
                                    
                                    nLabel  = length(Label);
                                    
                                    
                                    bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                                    
                                    
                                    set(hAx,'XAxisLocation','bottom',...
                                        'XTick',1:nLabel,'XTickLabel',Label);
                                    
                                    set(get(hAx,'Title'),'String',{filename,[prefix,num2str(iPCA,'%0.2d')]});
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(hAx,S.Unit);
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(hAx,'Name');
                                    end
                                    
                            end
                    end
                    
                    
                    
                    
                    
                case 'AVEPCA'
                    if(isempty(UD.show_avepca))
                        UD.show_avepca  = fieldnames(S);
                        nPCA    = size(S.coeff,1);
                        for iPCA=1:nPCA
                            UD.show_avepca  = [UD.show_avepca; ['coeff(',num2str(iPCA,'%0.2d'),')']];
                        end
                        UD.show_avepca  = uichoice(UD.show_avepca,'変数の選択');
                    end
                    EMGind     = EitoEMG;
                    
                    switch UD.show_avepca
                        case 'coeff'
                            YData   = zeromask(S.coeff,~isnan(S.coeff));
                            Labelprop   = EMGprop(Label);
                            YLabel       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            %                                     YLabel  = parseEMG(S.EMGName);
                            nLabel  = length(YLabel);
                            %                                     Order   = sortEMGind(YLabel,sortind(EMGind.Name,EMGind.Order));
                            
                            YData   = sortmtx(YData,Order,1);
                            YLabel  = sortind(YLabel,Order);
                            
                            XLabel  = cell(size(YLabel));
                            for iLabel=1:nLabel
                                XLabel{iLabel}   = ['PCA',num2str(iLabel,'%0.2d')];
                            end
                            
                            imagesc(YData,'parent',hAx);
                            
                            
                            set(hAx,'XAxisLocation','bottom',...
                                'XTick',1:nLabel,'XTickLabel',XLabel,...
                                'YTick',1:nLabel,'YTickLabel',YLabel);
                            axis(hAx,'ij','square')
                            clim(hAx,[-1 1])
                            colormap(hAx,tmap1)
                            
                            
                            set(get(hAx,'Title'),'String',{filename,'coef'});
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Name');
                            end
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,'Name');
                            end
                        case 'explained'
                            YData   = cumsum(S.explained);
                            SData   = S.explained_sd;
                            Label   = S.EMGName;
                            nLabel  = length(Label);
                            
                            
                            for iLabel=1:nLabel
                                Label{iLabel}   = ['PCA',num2str(iLabel,'%0.2d')];
                            end
                            
                            terrorbar(hAx,1:nLabel,YData,SData,'Color',[0 0 0.5],'Marker','o');
                            
                            
                            set(hAx,'XAxisLocation','bottom',...
                                'XTick',1:nLabel,'XTickLabel',Label);
                            
                            set(get(hAx,'Title'),'String',{filename,'explained'});
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'%');
                            end
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,'Name');
                            end
                            
                        otherwise
                            switch UD.show_avepca(1:6)
                                case 'coeff('
                                    iPCA    = str2double(UD.show_avepca(7:8));
                                    YData   = (S.coeff(:,iPCA))';
                                    YData   = zeromask(YData,~isnan(YData));
                                    SData   = (S.coeff_sd(:,iPCA))';
                                    SData   = zeromask(SData,~isnan(SData));
                                    
                                    Labelprop   = EMGprop(Label);
                                    Label       = Labelprop.Name;
                                    Order       = Labelprop.Order;
                                    %                                             Label   = parseEMG(S.EMGName);
                                    YData   = sortind(YData,Order);
                                    Label   = sortind(Label,Order);
                                    
                                    nLabel  = length(Label);
                                    
                                    
                                    terrorbar_bar(hAx,1:nLabel,YData,SData,'FaceColor',[0 0 0.5]);
                                    
                                    
                                    set(hAx,'XAxisLocation','bottom',...
                                        'XTick',1:nLabel,'XTickLabel',Label);
                                    
                                    set(get(hAx,'Title'),'String',{filename,['PCA',num2str(iPCA,'%0.2d')]});
                                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                                        ylabel(hAx,S.Unit);
                                    end
                                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                                        xlabel(hAx,'Name');
                                    end
                                    
                            end
                            
                            
                            
                            
                            
                    end
                    
                    
                    
                    
                    
                case 'COVMTX'
                    OneToOne_flag   = false;
                    if(isfield(S,'OneToOne_flag'))
                        if(S.OneToOne_flag)
                            OneToOne_flag   = true;
                        end
                    end
                    
                    if(~OneToOne_flag)
                        if(isempty(UD.show_covmtx))
                            
                            UD.show_covmtx  = fieldnames(S);
                            UD.show_covmtx  = [UD.show_covmtx; 'corrcoef^2'; 'corrcoef (vs Spike)'; 'xcorr(wave)'; 'xcorr(wave)(lag reverse)'];
                            UD.show_covmtx  = uichoice(UD.show_covmtx,'変数の選択');
                        end
                        %                                 EMGind     = EitoEMG;
                        switch UD.show_covmtx
                            case 'corrcoef (vs Spike)'
                                
                                YData   = (S.corrcoef(1,2:end)).^2;
                                Label   = S.Name(2:end);
                                nLabel  = length(Label);
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                YData   = sortind(YData,Order);
                                Label   = sortind(Label,Order);
                                
                                bar(hAx,1:nLabel, YData,'FaceColor',[0 0 0.5]);
                                [M,I]   = max(abs(YData));
                                set(hAx,'Nextplot','add');
                                bar(hAx,I,YData(I),'FaceColor',[0.5 0 0]);
                                
                                set(hAx,'XAxisLocation','bottom',...
                                    'XTick',1:nLabel,'XTickLabel',Label);
                                
                                set(get(hAx,'Title'),'String',{filename,'corrcoef^2'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'r');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Name');
                                end
                                
                            case 'corrcoef'
                                YData   = (zeromask(S.corrcoef,~isnan(S.corrcoef)));
                                Label   = S.Name;
                                nLabel  = length(Label);
                                
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                YData   = sortmtx(YData,Order);
                                Label   = sortind(Label,Order);
                                
                                
                                imagesc(YData,'parent',hAx);
                                
                                
                                set(hAx,'XAxisLocation','bottom',...
                                    'XTick',1:nLabel,'XTickLabel',Label,...
                                    'YTick',1:nLabel,'YTickLabel',Label);
                                axis(hAx,'ij','square')
                                clim(hAx,[-1 1])
                                colormap(hAx,tmap1)
                                
                                
                                set(get(hAx,'Title'),'String',{filename,'corrcoef'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'Name');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Name');
                                end
                                
                            case 'corrcoef^2'
                                YData   = (zeromask(S.corrcoef,~isnan(S.corrcoef))).^2;
                                Label   = S.Name;
                                nLabel  = length(Label);
                                
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                YData   = sortmtx(YData,Order);
                                Label   = sortind(Label,Order);
                                
                                
                                imagesc(YData,'parent',hAx);
                                
                                
                                set(hAx,'XAxisLocation','bottom',...
                                    'XTick',1:nLabel,'XTickLabel',Label,...
                                    'YTick',1:nLabel,'YTickLabel',Label);
                                axis(hAx,'ij','square')
                                clim(hAx,[-1 1])
                                colormap(hAx,tmap1)
                                
                                
                                set(get(hAx,'Title'),'String',{filename,'corrcoef^2'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'Name');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Name');
                                end
                                
                                
                            case 'xcorr(wave)'
                                CData   = (zeromask(S.xcorr,~isnan(S.xcorr)));
                                Label   = S.TargetName;
                                nLabel  = length(Label);
                                XData   = S.xcorrlag;
                                YData   = 1:nLabel;
                                
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                CData   = sortmtx(CData,Order,1);
                                Label   = sortind(Label,Order);
                                
                                hL  = plot(XData,CData,'parent',hAx);
                                
                                if(isfield(S,'xcorrLO'))
                                    set(hAx,'Nextplot','add');
                                    plot(hAx,XData,S.xcorrLOLim,':k','parent',hAx);
                                    plot(hAx,XData,S.xcorrUPLim,':k','parent',hAx);
                                end
                                
                                set(hAx,'XAxisLocation','bottom');
                                
                                set(get(hAx,'Title'),'String',{filename,'xcorr'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'R');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Lag (sec)');
                                end
                                activelegend(hL,Label,0,1,'Location','Best')
                                
                            case 'xcorr(wave)(lag reverse)'
                                CData   = (zeromask(S.xcorr,~isnan(S.xcorr)));
                                Label   = S.TargetName;
                                nLabel  = length(Label);
                                XData   = S.xcorrlag;
                                YData   = 1:nLabel;
                                
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                
                                CData   = sortmtx(CData,Order,1);
                                % lag reversed
                                CData   = CData(:,end:-1:1);
                                
                                Label   = sortind(Label,Order);
                                
                                hL  = plot(XData,CData,'parent',hAx);
                                
                                
                                set(hAx,'XAxisLocation','bottom');
                                
                                set(get(hAx,'Title'),'String',{filename,'xcorr(wave)(lag reverse)'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'R');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Lag (sec)');
                                end
                                activelegend(hL,Label,0,1,'Location','NorthEast')
                                
                                
                            case 'xcorr'
                                CData   = (zeromask(S.xcorr(2:end,:),~isnan(S.xcorr(2:end,:)))).^2;
                                Label   = S.Name(2:end);
                                nLabel  = length(Label);
                                XData   = S.xcorrlag;
                                YData   = 1:nLabel;
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                
                                CData   = sortmtx(CData,Order,1);
                                Label   = sortind(Label,Order);
                                
                                
                                imagesc(XData,YData,CData,'parent',hAx);
                                set(hAx,'Nextplot','add');
                                plot(hAx,[0 0],[0.5 nLabel+0.5],':w')
                                
                                
                                set(hAx,'XAxisLocation','bottom',...
                                    'YTick',1:nLabel,'YTickLabel',Label);
                                axis(hAx,'ij','tight')
                                clim(hAx,[-max(max(CData)) max(max(CData))])
                                colormap(hAx,tmap1)
                                
                                
                                set(get(hAx,'Title'),'String',{filename,'xcorr^2'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'Name');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Lag (sec)');
                                end
                                
                                
                            case {'mrA' 'smrA'}
                                %                                         YData   = abs(S.mrA(2:end));
                                YData   = S.(UD.show_covmtx)(2:end);
                                
                                Label   = S.Name(2:end);
                                nLabel  = length(Label);
                                
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                YData   = sortind(YData,Order);
                                Label   = sortind(Label,Order);
                                
                                bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                                [M,I]   = max(abs(YData));
                                set(hAx,'Nextplot','add');
                                bar(hAx,I,YData(I),'FaceColor',[0.5 0 0]);
                                
                                
                                set(hAx,'XAxisLocation','bottom',...
                                    'XTick',1:nLabel,'XTickLabel',Label);
                                
                                set(get(hAx,'Title'),'String',{filename,UD.show_covmtx});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'laul');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Name');
                                end
                                
                            case 'mrAH'
                                YData   = S.mrAH(2:end);
                                Label   = S.Name(2:end);
                                nLabel  = length(Label);
                                
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                YData   = sortind(YData,Order);
                                Label   = sortind(Label,Order);
                                
                                bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                                
                                
                                set(hAx,'XAxisLocation','bottom',...
                                    'XTick',1:nLabel,'XTickLabel',Label);
                                
                                set(get(hAx,'Title'),'String',{filename,'mrA'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'laul');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Name');
                                end
                                
                            case 'xmrA'
                                CData   = abs(zeromask(S.xmrA(2:end,:),~isnan(S.xmrA(2:end,:))));
                                Label   = S.Name(2:end);
                                nLabel  = length(Label);
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                XData   = S.xcorrlag;
                                YData   = 1:nLabel;
                                
                                CData   = sortmtx(CData,Order,1);
                                Label   = sortind(Label,Order);
                                
                                
                                imagesc(XData,YData,CData,'parent',hAx);
                                set(hAx,'Nextplot','add');
                                plot(hAx,[0 0],[0.5 nLabel+0.5],':w')
                                
                                
                                set(hAx,'XAxisLocation','bottom',...
                                    'YTick',1:nLabel,'YTickLabel',Label);
                                axis(hAx,'ij','tight')
                                clim(hAx,[-max(max(CData)) max(max(CData))])
                                colormap(hAx,tmap1)
                                
                                
                                set(get(hAx,'Title'),'String',{filename,'xmrA'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'Name');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Lag (sec)');
                                end
                                
                            case 'sw_corrcoef'
                                XData   = 1:S.sw_nTrials;
                                
                                YData       = S.sw_corrcoef.^2;
                                YData_mean  = nanmean(S.sw_corrcoef.^2,1);
                                YData_min   = min(S.sw_corrcoef.^2,[],1);
                                YData_max   = max(S.sw_corrcoef.^2,[],1);
                                
                                YData_std   = std(S.sw_corrcoef.^2,1,1);
                                
                                
                                %                                         c   = [0 0 0.75];
                                c   = [0 0 0];
                                
                                hh  = plot(hAx,XData,YData_mean,'Color',c,'LineStyle','-');
                                set(hAx,'Nextplot','add');
                                plot(hAx,XData,YData_min, 'Color',c,'LineStyle','--');
                                plot(hAx,XData,YData_max, 'Color',c,'LineStyle','--');
                                %                                         plot(hAx,XData,YData_mean + YData_std, 'Color',c,'LineStyle',':');
                                %                                         plot(hAx,XData,YData_mean - YData_std, 'Color',c,'LineStyle',':');
                                
                                %                                         plot(hAx,XData,YData,'Color',[0.75 0.75 0.75],'LineStyle','none',...
                                %                                             'Marker','o','MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[1 1 1]);
                                
                                terrorarea(hAx,XData,YData_mean,YData_std)
                                
                                gofront(hh);
                                set(get(hAx,'Title'),'String',{filename,'stepwise_corr'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'R^2');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Number of items');
                                end
                                
                                axis(hAx,'square')
                                
                                
                        end
                    else % OneToOne_flag =true
                        if(isempty(UD.show_covmtx))
                            UD.show_covmtx  = fieldnames(S);
                            UD.show_covmtx  = [UD.show_covmtx; 'xcorr(wave)'; 'xcorr(wave)(lag reverse)'];
                            UD.show_covmtx  = uichoice(UD.show_covmtx,'変数の選択');
                        end
                        EMGind     = EitoEMG;
                        switch UD.show_covmtx
                            case 'corrcoef'
                                YData   = (zeromask(S.corrcoef,~isnan(S.corrcoef)));
                                Label   = S.TargetName;
                                nLabel  = length(Label);
                                
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                YData   = sortind(YData,Order);
                                Label   = sortind(Label,Order);
                                nLabel  = length(Label);
                                XData   = 1:nLabel;
                                
                                bar(YData,'parent',hAx);
                                
                                
                                set(hAx,'XAxisLocation','bottom',...
                                    'XTick',1:nLabel,'XTickLabel',Label);
                                
                                
                                set(get(hAx,'Title'),'String',{filename,'corrcoef'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'R');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Name');
                                end
                                
                            case 'xcorr(wave)'
                                CData   = (zeromask(S.xcorr,~isnan(S.xcorr)));
                                Label   = S.TargetName;
                                nLabel  = length(Label);
                                
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                XData   = S.xcorrlag;
                                YData   = 1:nLabel;
                                
                                CData   = sortmtx(CData,Order,1);
                                Label   = sortind(Label,Order);
                                
                                hL  = plot(XData,CData,'parent',hAx);
                                
                                
                                set(hAx,'XAxisLocation','bottom');
                                
                                set(get(hAx,'Title'),'String',{filename,'xcorr'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'R');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Lag (sec)');
                                end
                                activelegend(hL,Label,0,1,'Location','NorthEast')
                                
                                
                            case 'xcorr(wave)(lag reverse)'
                                CData   = (zeromask(S.xcorr,~isnan(S.xcorr)));
                                Label   = S.TargetName;
                                nLabel  = length(Label);
                                
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                XData   = S.xcorrlag;
                                YData   = 1:nLabel;
                                
                                CData   = sortmtx(CData,Order,1);
                                %lag reverse
                                CData   = CData(:,end:-1:1);
                                Label   = sortind(Label,Order);
                                
                                hL  = plot(XData,CData,'parent',hAx);
                                
                                
                                set(hAx,'XAxisLocation','bottom');
                                
                                set(get(hAx,'Title'),'String',{filename,'xcorr(wave)(lag reverse)'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'R');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Lag (sec)');
                                end
                                activelegend(hL,Label,0,1,'Location','NorthEast')
                                
                            case 'xcorr'
                                CData   = (zeromask(S.xcorr,~isnan(S.xcorr)));
                                Label   = S.TargetName;
                                nLabel  = length(Label);
                                XData   = S.xcorrlag;
                                YData   = 1:nLabel;
                                Labelprop   = EMGprop(Label);
                                Label       = Labelprop.Name;
                                Order       = Labelprop.Order;
                                
                                
                                %                                         for iLabel=1:nLabel
                                %                                             if(~isempty(parseEMG(Label{iLabel})))
                                %                                                 Label{iLabel}   = parseEMG(Label{iLabel});
                                %
                                %                                             elseif(strcmp('EMGPCA',Label{iLabel}(1:6)))
                                %                                                 Label{iLabel}   = Label{iLabel}(7:end);
                                %                                             end
                                %                                         end
                                %
                                %
                                %                                         Order   = sortEMGind(Label,sortind(EMGind.Name,EMGind.Order));
                                
                                
                                CData   = sortmtx(CData,Order,1);
                                Label   = sortind(Label,Order);
                                
                                imagesc(XData,YData,CData,'parent',hAx);
                                set(hAx,'Nextplot','add');
                                plot(hAx,[0 0],[0.5 nLabel+0.5],':w')
                                
                                
                                set(hAx,'XAxisLocation','bottom',...
                                    'YTick',1:nLabel,'YTickLabel',Label);
                                axis(hAx,'ij','tight')
                                clim(hAx,[-max(max(CData)) max(max(CData))])
                                colormap(hAx,tmap1)
                                
                                
                                set(get(hAx,'Title'),'String',{filename,'xcorr'});
                                if(~isempty(get(get(hAx,'YLabel'),'String')))
                                    ylabel(hAx,'Name');
                                end
                                if(~isempty(get(get(hAx,'XLabel'),'String')))
                                    xlabel(hAx,'Lag (sec)');
                                end
                                
                        end
                        
                    end
                    
                    
                case {'TCORR','XCORR'}
                    XData   = S.xcorrlag;
                    YData   = S.xcorr;
                    if(isfield(S,'nTrigger'))
                        ntrigger    = S.nTrigger;
                    else
                        ntrigger    = [];
                    end
                    
                    % lag reversed
                    YData   = YData(:,end:-1:1);
                    
                    color   = [0 0 0];
                    hL  = plot(XData,YData,'parent',hAx,'Color',color);
                    set(hAx,'Nextplot','add');
                    
                    plot([XData(1),XData(end)],[S.xcorrRmax,S.xcorrRmax],'-r','parent',hAx);
                    plot([-S.xcorrRmaxlag,-S.xcorrRmaxlag],[0,S.xcorrRmax],'-r','parent',hAx);
                    
                    plot(-S.xcorrRmaxlag,S.xcorrRmax,'+r','parent',hAx);
                    
                    if(isfield(S,'xcorrPWHM'))
                        if(~isnan(S.xcorrPWHMOnset) && ~isnan(S.xcorrPWHMOffset))
                            plot(-[S.xcorrPWHMOnset,S.xcorrPWHMOffset],[S.xcorrRmax/2,S.xcorrRmax/2],'-*g','parent',hAx);
                        end
                    end
                    
                    gofront(hL)
                    
                    
                    set(hAx,'XAxisLocation','bottom');
                    axis(hAx,'square')
                    
                    
                    
                    set(get(hAx,'Title'),'String',{filename,['xcorr(wave)(lag reverse), ntrigger=',num2str(ntrigger)]});
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        ylabel(hAx,'R');
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'Lag (sec)');
                    end
                    
                case 'AVECOV'
                    if(isempty(UD.show_avecov))
                        
                        UD.show_avecov  = fieldnames(S);
                        UD.show_avecov  = uichoice(UD.show_avecov,'AVECOV: 変数の選択');
                    end
                    EMGind     = EitoEMG;
                    switch UD.show_avecov
                        case 'maxmrAhistp'
                            
                            YData   = S.maxmrAhistp;
                            Label   = S.Label;
                            nLabel  = length(Label);
                            
                            Labelprop   = EMGprop(Label);
                            Label       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            %                                     for iLabel=1:nLabel
                            %                                         if(~isempty(parseEMG(Label{iLabel})))
                            %                                             Label{iLabel}   = parseEMG(Label{iLabel});
                            %
                            %                                         elseif(strcmp('EMGPCA',Label{iLabel}(1:6)))
                            %                                              Label{iLabel}   = Label{iLabel}(7:end);
                            %                                         end
                            %                                     end
                            %                                     Order   = sortEMGind(Label,sortind(EMGind.Name,EMGind.Order));
                            YData   = sortind(YData,Order);
                            Label   = sortind(Label,Order);
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                        case 'maxmrAhist'
                            
                            YData   = S.maxmrAhist;
                            Label   = S.Label;
                            nLabel  = length(Label);
                            Labelprop   = EMGprop(Label);
                            Label       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            
                            %                                         for iLabel=1:nLabel
                            %                                         if(~isempty(parseEMG(Label{iLabel})))
                            %                                             Label{iLabel}   = parseEMG(Label{iLabel});
                            %
                            %                                         elseif(strcmp('EMGPCA',Label{iLabel}(1:6)))
                            %                                              Label{iLabel}   = Label{iLabel}(7:end);
                            %                                         end
                            %                                     end
                            %                                     Order   = sortEMGind(Label,sortind(EMGind.Name,EMGind.Order));
                            YData   = sortind(YData,Order);
                            Label   = sortind(Label,Order);
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                            
                        case 'GroupmaxmrAhistp'
                            
                            YData   = S.GroupmaxmrAhistp;
                            Label   = S.GroupLabel;
                            nLabel  = length(Label);
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                            
                        case 'GroupmaxmrAhist'
                            
                            YData   = S.GroupmaxmrAhist;
                            Label   = S.GroupLabel;
                            nLabel  = length(Label);
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                            
                            
                        case 'maxcorrcoefhistp'
                            
                            YData   = S.maxcorrcoefhistp;
                            Label   = S.Label;
                            nLabel  = length(Label);
                            Labelprop   = EMGprop(Label);
                            Label       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            
                            %                                         for iLabel=1:nLabel
                            %                                         if(~isempty(parseEMG(Label{iLabel})))
                            %                                             Label{iLabel}   = parseEMG(Label{iLabel});
                            %
                            %                                         elseif(strcmp('EMGPCA',Label{iLabel}(1:6)))
                            %                                             Label{iLabel}   = Label{iLabel}(7:end);
                            %                                         end
                            %                                     end
                            %                                     Order   = sortEMGind(Label,sortind(EMGind.Name,EMGind.Order));
                            YData   = sortind(YData,Order);
                            Label   = sortind(Label,Order);
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                        case 'maxcorrcoefhist'
                            
                            YData   = S.maxcorrcoefhist;
                            Label   = S.Label;
                            nLabel  = length(Label);
                            Labelprop   = EMGprop(Label);
                            Label       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            
                            %                                         for iLabel=1:nLabel
                            %                                         if(~isempty(parseEMG(Label{iLabel})))
                            %                                             Label{iLabel}   = parseEMG(Label{iLabel});
                            %
                            %                                         elseif(strcmp('EMGPCA',Label{iLabel}(1:6)))
                            %                                             Label{iLabel}   = Label{iLabel}(7:end);
                            %                                         end
                            %                                     end
                            %                                     Order   = sortEMGind(Label,sortind(EMGind.Name,EMGind.Order));
                            YData   = sortind(YData,Order);
                            Label   = sortind(Label,Order);
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                            
                        case 'mrAHhistp'
                            
                            YData   = S.mrAHhistp;
                            Label   = S.Label;
                            nLabel  = length(Label);
                            Labelprop   = EMGprop(Label);
                            Label       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            
                            %                                     for iLabel=1:nLabel
                            %                                         if(~isempty(parseEMG(Label{iLabel})))
                            %                                             Label{iLabel}   = parseEMG(Label{iLabel});
                            %
                            %                                         elseif(strcmp('EMGPCA',Label{iLabel}(1:6)))
                            %                                             Label{iLabel}   = Label{iLabel}(7:end);
                            %                                         end
                            %                                     end
                            %                                     Order   = sortEMGind(Label,sortind(EMGind.Name,EMGind.Order));
                            YData   = sortind(YData,Order);
                            Label   = sortind(Label,Order);
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                        case 'mrAHhist'
                            
                            YData   = S.mrAHhist;
                            Label   = S.Label;
                            nLabel  = length(Label);
                            Labelprop   = EMGprop(Label);
                            Label       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            %                                     for iLabel=1:nLabel
                            %                                         if(~isempty(parseEMG(Label{iLabel})))
                            %                                             Label{iLabel}   = parseEMG(Label{iLabel});
                            %
                            %                                         elseif(strcmp('EMGPCA',Label{iLabel}(1:6)))
                            %                                             Label{iLabel}   = Label{iLabel}(7:end);
                            %                                         end
                            %                                     end
                            %                                     Order   = sortEMGind(Label,sortind(EMGind.Name,EMGind.Order));
                            YData   = sortind(YData,Order);
                            Label   = sortind(Label,Order);
                            
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                            
                        case 'Groupmaxcorrcoefhistp'
                            
                            YData   = S.Groupmaxcorrcoefhistp;
                            Label   = S.GroupLabel;
                            nLabel  = length(Label);
                            
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                            
                        case 'Groupmaxcorrcoefhist'
                            
                            YData   = S.Groupmaxcorrcoefhist;
                            Label   = S.GroupLabel;
                            nLabel  = length(Label);
                            
                            bar(hAx,1:nLabel,YData,'FaceColor',[0 0 0.5]);
                            
                        case 'mrA_all'
                            YData   = mean(abs(S.mrA_all),1);
                            SData   = std(abs(S.mrA_all),1,1);
                            
                            Label   = S.Label;
                            nLabel  = length(Label);
                            Labelprop   = EMGprop(Label);
                            Label       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            
                            %                                     for iLabel=1:nLabel
                            %                                         if(~isempty(parseEMG(Label{iLabel})))
                            %                                             Label{iLabel}   = parseEMG(Label{iLabel});
                            %
                            %                                         elseif(strcmp('EMGPCA',Label{iLabel}(1:6)))
                            %                                             Label{iLabel}   = Label{iLabel}(7:end);
                            %                                         end
                            %                                     end
                            %                                     Order   = sortEMGind(Label,sortind(EMGind.Name,EMGind.Order));
                            YData   = sortind(YData,Order);
                            SData   = sortind(SData,Order);
                            Label   = sortind(Label,Order);
                            
                            terrorbar_bar(hAx,1:nLabel,YData,SData,'FaceColor',[0 0 0.5]);
                            
                        case 'corrcoef_all'
                            YData   = mean(S.corrcoef_all.^2,1);
                            SData   = std(S.corrcoef_all.^2,1,1);
                            
                            Label   = S.Label;
                            nLabel  = length(Label);
                            Labelprop   = EMGprop(Label);
                            Label       = Labelprop.Name;
                            Order       = Labelprop.Order;
                            
                            %                                     for iLabel=1:nLabel
                            %                                         if(~isempty(parseEMG(Label{iLabel})))
                            %                                             Label{iLabel}   = parseEMG(Label{iLabel});
                            %
                            %                                         elseif(strcmp('EMGPCA',Label{iLabel}(1:6)))
                            %                                             Label{iLabel}   = Label{iLabel}(7:end);
                            %                                         end
                            %                                     end
                            %                                     Order   = sortEMGind(Label,sortind(EMGind.Name,EMGind.Order));
                            YData   = sortind(YData,Order);
                            SData   = sortind(SData,Order);
                            Label   = sortind(Label,Order);
                            
                            terrorbar_bar(hAx,1:nLabel,YData,SData,'FaceColor',[0 0 0.5]);
                            
                            
                    end
                    
                    
                    
                    set(hAx,'XAxisLocation','bottom',...
                        'XTick',1:nLabel,'XTickLabel',Label);
                    
                    set(get(hAx,'Title'),'String',{filename,UD.show_avecov});
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        ylabel(hAx,'%');
                    end
                    if(~isempty(get(get(hAx,'XLabel'),'String')))
                        xlabel(hAx,'Name');
                    end
                    
                    
                case 'SCAT'
                    
                    switch UD.show_scat
                        case 'scatter'
                            UD.show_scat_test   = 'parametric';
                            %                             UD.show_scat_test   = 'nonparametric';
                            show_regressionline =1;

                            switch UD.show_scat_test
                                case 'parametric'
                                    if(isfield(S,'Pearson'))
                                        S.R   = S.Pearson.R;
                                        S.P   = S.Pearson.P;
                                    else
                                        S.R   = S.R;
                                        S.P   = S.P;
                                    end
                                case 'nonparametric'
                                    if(isfield(S,'Spearman'))
                                        S.R   = S.Spearman.R;
                                        S.P   = S.Spearman.P;
                                    else
                                        S.R   = S.R;
                                        S.P   = S.P;
                                    end
                            end
                            
                            hL  = plot(hAx,S.XData,S.YData,'ok','Markersize',3,'MarkerFacecolor',[0 0 0.5],'Tag','data');
                            axis(hAx,'equal','square')
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,S.XName);
                            end
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,S.YName);
                            end
                            
                            if(show_regressionline)
                                set(hAx,'Nextplot','add');
                                if(S.Pearson.P<0.05)
                                    Color   = [1 0 0];
                                else
                                    Color   = [0.5 0.5 0.5];
                                end
                                X   = [min(S.XData),max(S.XData)];
                                Y   = X*S.a(1) + S.a(2);
                                plot(hAx,X,Y,'-','Color',Color);
                                set(hAx,'Nextplot','replacechildren');
                            end
                            
                            set(get(hAx,'Title'),'String',{filename,['N=',num2str(S.N),' (',UD.show_scat_test,') R=',num2str(S.R),' P=',num2str(S.P)]});

                            
                        case 'scatter-sorted'
                            UD.show_scat_test   = 'parametric';
%                             compname        = 'Bin5';
%                             compname        = 'Bin2';
%                             compname        = 'OrderBin2';
                            compname        = 'OrderN10';
%                             compname        = 'OrderN10Index';
                            
                            show_regressionline = 1;
                            
                            switch UD.show_scat_test
                                case 'parametric'
                                    if(isfield(S.sort.(compname),'Pearson'))
                                        S.sort.(compname).R   = S.sort.(compname).Pearson.R;
                                        S.sort.(compname).P   = S.sort.(compname).Pearson.P;
                                    else
                                        S.sort.(compname).R   = S.sort.(compname).R;
                                        S.sort.(compname).P   = S.sort.(compname).P;
                                    end
                                case 'nonparametric'
                                    if(isfield(S,'Spearman'))
                                        S.sort.(compname).R   = S.sort.(compname).Spearman.R;
                                        S.sort.(compname).P   = S.sort.(compname).Spearman.P;
                                    else
                                        S.sort.(compname).R   = S.sort.(compname).R;
                                        S.sort.(compname).P   = S.sort.(compname).P;
                                    end
                            end
                            
                            %%%
                            hL  = plot(hAx,S.XData,S.YData,'ok','Markersize',3,'MarkerEdgecolor',[0.75 0.75 0.75],'MarkerFacecolor',[0.75 0.75 0.75],'Tag','data');
                            set(hAx,'Nextplot','add');
                            %%%
                            
                            hL  = plot(hAx,...
                                S.sort.(compname).XData(S.sort.(compname).IsValid),...
                                S.sort.(compname).YData(S.sort.(compname).IsValid),...
                                'sk','Markersize',6,'MarkerFacecolor',[0.75 0 0],'Tag','data');
                            set(hAx,'Nextplot','replacechildren');
                            axis(hAx,'equal','square')
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,S.XName);
                            end
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,S.YName);
                            end
                            
                            if(show_regressionline)
                                set(hAx,'Nextplot','add');
                                if(S.sort.(compname).Pearson.P<0.05)
                                    Color   = [1 0 0];
                                else
                                    Color   = [0.5 0.5 0.5];
                                end
                                X   = [min(S.sort.(compname).XData(S.sort.(compname).IsValid)),max(S.sort.(compname).XData(S.sort.(compname).IsValid))];
                                Y   = X*S.sort.(compname).a(1) + S.sort.(compname).a(2);
                                plot(hAx,X,Y,'-','Color',Color);
                                set(hAx,'Nextplot','replacechildren');
                            end


                            set(get(hAx,'Title'),'String',{filename,['N=',num2str(S.sort.(compname).nValid),' (',UD.show_scat_test,') R=',num2str(S.sort.(compname).R),' P=',num2str(S.sort.(compname).P)]});
                            
                            
                       
                            
                            
%                             if(isfield(S,'test'))
%                                 set(hAx,'Nextplot','add');
%                                 switch UD.show_scat_test
%                                     case 'parametric'
%                                         if(S.Pearson.P<0.05)
%                                             Color   = [1 0 0];
%                                         else
%                                             Color   = [0.5 0.5 0.5];
%                                         end
%                                         X   = [min(S.XData),max(S.XData)];
%                                         Y   = X*S.a(1) + S.a(2);
%                                         plot(hAx,X,Y,'-','Color',Color);
%                                     case 'nonparametric'
%                                         if(S.Spearman.P<0.05)
%                                             Color   = [1 0 0];
%                                         else
%                                             Color   = [0.5 0.5 0.5];
%                                         end
%                                         X   = [min(S.XData),max(S.XData)];
%                                         Y   = X*S.a(1) + S.a(2);
%                                         plot(hAx,X,Y,'-','Color',Color);
%                                 end
%                                 set(hAx,'Nextplot','replacechildren');
%                             end
%                             if(isfield(S,'test'))
%                                 set(hAx,'Nextplot','add');
%                                 switch UD.show_scat_test
%                                     case 'parametric'
%                                         if(S.test.ttest.h==1)
%                                             Color   = [1 0 0];
%                                         else
%                                             Color   = [0.5 0.5 0.5];
%                                         end
%                                         ind = S.ZData<S.test.limits(1) | S.ZData>S.test.limits(2);
%                                         delete(hL)
%                                         plot(hAx,S.XData(ind),S.YData(ind),'ok','Markersize',3,'MarkerFacecolor',[1 0 0],'Tag','data');
%                                         plot(hAx,S.XData(~ind),S.YData(~ind),'ok','Markersize',3,'MarkerFacecolor',[0 0 0.5],'Tag','data');
%                                         plot(hAx,S.test.Xmean,S.test.Ymean,':s','MarkerEdgeColor',Color,'MarkerFaceColor',Color,'Color',Color)
%                                         
%                                     case 'nonparametric'
%                                         if(S.test.ranksum.h==1)
%                                             Color   = [1 0 0];
%                                         else
%                                             Color   = [0.5 0.5 0.5];
%                                         end
%                                         ind = S.ZData<S.test.limits(1) | S.ZData>S.test.limits(2);
%                                         delete(hL)
%                                         plot(hAx,S.XData(ind),S.YData(ind),'ok','Markersize',3,'MarkerFacecolor',[1 0 0],'Tag','data');
%                                         plot(hAx,S.XData(~ind),S.YData(~ind),'ok','Markersize',3,'MarkerFacecolor',[0 0 0.5],'Tag','data');
%                                         plot(hAx,S.test.Xmedian,S.test.Ymedian,':s','MarkerEdgeColor',Color,'MarkerFaceColor',Color,'Color',Color)
%                                 end
%                                 set(hAx,'Nextplot','replacechildren');
%                             end
                                
                            
                            
                        case 'cmap'
                            
                            imagesc(S.hist.XData,S.hist.YData,S.hist.ZData,'Parent',hAx);
                            axis(hAx,'xy','equal','square')
                            colormap(hAx,tmap4)
                            
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,S.XName);
                            end
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,S.YName);
                            end
                            
                            set(get(hAx,'Title'),'String',{filename,['N=',num2str(S.N)]});
                                                        
                            
                        case 'scatter-on-cmap'
                            
                            imagesc(S.hist.XData,S.hist.YData,S.hist.ZData,'Parent',hAx);
                            axis(hAx,'xy','equal','square')
                            colormap(hAx,tmap4)
                            
                            set(hAx,'Nextplot','add');
                            plot(hAx,S.XData,S.YData,'ok','Markersize',3,'MarkerFacecolor',[0 0 0.5]);
                            
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,S.XName);
                            end
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,S.YName);
                            end
                            
                            set(get(hAx,'Title'),'String',{filename,['N=',num2str(S.N)]});

                            
                        case 'histogramXData'
                            bar(hAx,S.hist.XData,sum(S.hist.ZData,1),1,'EdgeColor',[0 0 0.5],'FaceColor',[0 0 0.5])
                            set(hAx,'YDir','reverse')
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,S.XName);
                            end

                            set(get(hAx,'Title'),'String',{filename,['N=',num2str(S.N)]});

                        case 'histogramYData'
                            barh(hAx,S.hist.YData,sum(S.hist.ZData,2),1,'EdgeColor',[0 0 0.5],'FaceColor',[0 0 0.5])
                            colormap('default')
                            set(hAx,'XDir','reverse')
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                ylabel(hAx,S.YName);
                            end
                            set(get(hAx,'Title'),'String',{filename,['N=',num2str(S.N)]});
                    end
                    
                    %                             linkprop(h,'CLim');
                    
                    if(numel(hAx)>1)
                        CLims  = cell2mat(get(hAx,'CLim'));
                        %                             set(h,'CLim',[min(CLims(:,1)),max(CLims(:,2))]);
                        set(hAx,'CLim',[0,max(CLims(:,2))]);
                    else
                        CLims  = get(hAx,'CLim');
                        set(hAx,'CLim',[0,CLims(2)]);
                    end
                    
                case 'HIST'
                    
                    switch UD.show_hist
                        case 'bar'
                            bar(hAx,S.XData,S.YData,1,'EdgeColor',[0 0 0.5],'FaceColor',[0 0 0.5]);
                            
                            set(hAx,'Nextplot','add');
                            plot(hAx,[S.mean-S.std,S.mean+S.std],ones(1,2)*max(S.YData)*1.1,...
                                'Color',[0.5 0 0],...
                                'LineWidth',2,...
                                'LineStyle','-',...
                                'Marker','none');
                            
                            plot(hAx,S.mean,max(S.YData)*1.1,...
                                'LineStyle','none',...
                                'Marker','V',...
                                'MarkerEdgeColor',[0   0 0],...
                                'MarkerFaceColor',[0.5 0 0],...
                                'MarkerSize',8);
                            %                             plot(hAx,S.median,max(S.YData)*1.1,...
                            %                                 'LineStyle','none',...
                            %                                 'Marker','V',...
                            %                                 'MarkerEdgeColor',[0 0   0],...
                            %                                 'MarkerFaceColor',[0 0.5 0],...
                            %                                 'MarkerSize',8);
                            
                            if(isfield(S,'PD'))
                                nX  = 5;
                                dX  = S.XData(2)-S.XData(1);
                                PDXData = (S.XData(1)-dX/2):(dX/nX):(S.XData(end)+dX/2);
                                PDYData = pdf(S.PD,PDXData) * (dX*sum(S.YData));
                                
                                plot(hAx,PDXData,PDYData,'r-');
                                plot(hAx,[S.PD.mean-S.PD.std,S.PD.mean,S.PD.mean+S.PD.std],repmat(max(PDYData),1,3),'r-s');
                                
                            end

                            if(isfield(S,'XLabel'))
                                set(hAx,'XTickMode','manual',...
                                    'XTick',S.XData,...
                                    'XTickLabelMode','manual',...
                                    'XTickLabel',S.XLabel);
                            end
                            if(~isempty(get(get(hAx,'XLabel'),'String')))
                                xlabel(hAx,S.VarName);
                                
                            end
                            if(~isempty(get(get(hAx,'YLabel'),'String')))
                                ylabel(hAx,'Counts');
                            end
                            
                        case 'pie'
                            pie(hAx,S.YData(end:-1:1),S.XLabel(end:-1:1));
                    end
                    
                    set(get(hAx,'Title'),'String',{filename;['N=',num2str(S.N),' mean=',num2str(S.mean),', std=',num2str(S.std),', median=',num2str(S.median)]});
                case 'ISIHIST'
                    
                    bar(hAx, S.XData,S.YData,1);
                    xlim(hAx,[0 0.1]);
                    
                    if(S.nonzero_flag)
                        Data   = S.ISIData(S.ISIData~=0);
                    else
                        Data   = S.ISIData;
                    end
                    set(get(hAx,'Title'),'String',{filename;['N=',num2str(S.nData),' <1ms:',num2str(S.PData(1)*100),'%, mean=',num2str(mean(Data)),', std=',num2str(std(Data))]});
                    
                case 'XTABLE'
                    if(0)
                        nXLabel = length(S.XLabel);
                        nYLabel = length(S.YLabel);
                        
                        imagesc(S.Table,'Parent',hAx);
                        axis(hAx,'ij','equal','square')
                        colormap(hAx,'gray');
                        
                        maxcount    = max(max(S.Table));
                        
                        for iX=1:nXLabel
                            for iY=1:nYLabel
                                c   = [1 1 1] * (S.Table(iX,iY)<(maxcount*0.6));
                                text(iY,iX,num2str(S.Table(iX,iY)),...
                                    'Parent',hAx,...
                                    'Color',c,...
                                    'HorizontalAlignment','Center');
                            end
                        end
                        
                        
                        set(hAx,'XAxisLocation','bottom',...
                            'XTick',1:nYLabel,'XTickLabel',S.YLabel,...
                            'YTick',1:nXLabel,'YTickLabel',S.XLabel);
                        
                        if(~isempty(get(get(hAx,'XLabel'),'String')))
                            xlabel(hAx,S.YName);
                        end
                        if(~isempty(get(get(hAx,'YLabel'),'String')))
                            ylabel(hAx,S.XName);
                        end
                    else
                        FontName    = 'SimHei';
                        %                                 FontName    = 'Lucida Console';
                        
                        tablestr = table2str(S.Table,S.YLabel,S.XLabel);
                        hL  = text(0.5,0.5,tablestr,...
                            'Parent',hAx,...
                            'BackGroundColor',[0.95 0.95 0.95],...
                            'FontName',FontName,...
                            'HorizontalAlignment','center',...
                            'VerticalAlignment','middle');
                        
                        set(hAx,'XAxisLocation','bottom',...
                            'Box','off',...
                            'XColor',[1 1 1],...
                            'YColor',[1 1 1]);
                        
                        set(hL,'Units','points')
                        
                        p1  = get(hL,'Extent');
                        p2  = get(hL,'Position');
                        p3  = get(hL,'Units');
                        
                        text(p2(1),p1(2)+p1(4),S.YName,...
                            'Parent',hAx,...
                            'FontName',FontName,...
                            'HorizontalAlignment','center',...
                            'VerticalAlignment','Bottom',...
                            'Rotation',0,...
                            'Units',p3)
                        
                        text(p1(1),p2(2),S.XName,...
                            'Parent',hAx,...
                            'FontName',FontName,...
                            'HorizontalAlignment','center',...
                            'VerticalAlignment','Bottom',...
                            'Rotation',90,...
                            'Units',p3)
                        %
                        if(~isempty(get(get(hAx,'XLabel'),'String')))
                            xlabel(hAx,S.YName);
                        end
                        if(~isempty(get(get(hAx,'YLabel'),'String')))
                            ylabel(hAx,S.XName);
                        end
                        
                    end
                    set(get(hAx,'Title'),'String',{filename;['N=',num2str(S.N),' p=',num2str(S.p),', chi2=',num2str(S.chi2),', df=',num2str(S.df),', V=',num2str(S.V)]});
                    
                    
                    
                    
                    
            end
            
        else                                        %% Analysis file or [Data file]
            
            switch  S.Class
                %%
                case 'continuous channel'               %% continuous
                    %                             S   = resamplemat(S,20);
                    YData   = S.Data;
                    %YData   = unit_adjustment(YData,S);
                    
%                     XData   = ((1:length(YData)) - 1) / S.SampleRate;
                            XData   = ((1:length(YData)) - 1) / S.SampleRate + S.TimeRange(1);
                    
                    if(~isempty(YData))
                        if(UD.tdsplot_flag)
                            tdsplot(hAx,XData,YData,'Color',[0 0 0.5]);
                        else
                            plot(hAx,XData,YData,'Color',[0 0 0.5]);
                        end
                    end
                    
                    %                             axis(hAx,'tight')
                    if(~isempty(get(get(hAx,'YLabel'),'String')))
                        if(isfield(S,'Unit'))
                            ylabel(hAx,S.Unit);
                        end
                    end
                    set(get(hAx,'Title'),'String',{filename,[num2str(S.SampleRate),' Hz']});
                    gofront(get(hAx,'Title'));
                    
                    
                case 'timestamp channel'                %% timestamp
                    XData   = S.Data;

                    
%                      XData   = XData/S.SampleRate;                   
                    XData   = XData/S.SampleRate + S.TimeRange(1);
                    
                    if(isfield(S,'TrialsToUse'))
                        if(isempty(S.TrialsToUse))
                            TrialsToUse = 1:size(XData,2);
                        else
                        TrialsToUse = S.TrialsToUse;
                        end
                    else
                        TrialsToUse = 1:size(XData,2);
                    end
                    TrialsToUse = ismember(1:size(XData,2),TrialsToUse);
                    
                    hCm = uicontextmenu;
                    uimenu(hCm, 'Label', 'Not to use', 'Callback', 'uiEditChannel(''not to use'')');
                    uimenu(hCm, 'Label', 'To use', 'Callback', 'uiEditChannel(''to use'')');
                    uimenu(hCm, 'Label', 'Delete', 'Callback', 'uiEditChannel(''delete'')');
                    uimenu(hCm, 'Label', 'Edit', 'Callback', 'uiEditChannel(''edit'')');
                    uimenu(hCm, 'Label', 'Save', 'Callback', {@uiSaveChannel,hAx},'Separator','on');

                    
                    
                    if(~isempty(XData))
                        
                        if(~isempty(XData(TrialsToUse)))
                            hL  = plot(hAx,repmat(XData(TrialsToUse),2,1),repmat([0;1],1,length(XData(TrialsToUse))),'Color',[0.5 0 0]);
                            set(hL,'uicontextmenu',hCm)
                            set(hAx,'Nextplot','add');
                        end
                        if(~isempty(XData(~TrialsToUse)))
                            hL  = plot(hAx,repmat(XData(~TrialsToUse),2,1),repmat([0;1],1,length(XData(~TrialsToUse))),'Color',[0.5 0.5 0.5]);
                            set(hL,'uicontextmenu',hCm)
                        end
                        
                    end
                    set(hAx,'YLim',[0 1],...
                        'YTick',[],...
                        'YTickMode','manual',...
                        'YTickLabel',[],...
                        'YTickLabelMode','manual')
                    
                    %                             axis(hAx,'tight')
                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(sum(TrialsToUse))]});
                    gofront(get(hAx,'Title'));
                    
                    
                case 'interval channel'                 %% interval
                    XData   = S.Data;
%                     XData   = XData + S.TimeRange(1);
                    nRect   = size(XData,2);
                    
                    if(nRect~=0)
                        for jj=1:nRect
                            rectangle('Position',[XData(1,jj) 0 (XData(2,jj)-XData(1,jj)) 1],'FaceColor',[0 0.5 0],'Parent',hAx);
                            set(hAx,'Nextplot','add');
                        end
                    end
                    
                    set(hAx,'YLim',[0 1],...
                        'YTick',[],...
                        'YTickMode','manual',...
                        'YTickLabel',[],...
                        'YTickLabelMode','manual')
                    
                    %                             axis(hAx,'tight');
                    set(get(hAx,'Title'),'String',{filename;['n=',num2str(size(S.Data,2))]});
                    gofront(get(hAx,'Title'));
                    
            end
            
        end
        
    catch
        S           = lasterror;
        try
            H   = get(hAx,'Children');
            delete(H);
            
            %                 set(get(hAx,'Title'),'String',[filename,' (No Data)']);
            set(get(hAx,'Title'),'String',S.identifier);
        end
        continue;
    end
    % % % % %     end
    
end
try
    setAxes;
end
guiindicator(UD.fig,0,0);
set(UD.fig,'UserData',UD);

%         indicator(0,0)
end

function setAxes

UD      = get(gcf,'UserData');

% axisのセット
% h       = sort(findobj(UD.fig,'Tag','axis'));
h       = UD.h;
hrowcol = UD.hrowcol;
nfiles  = length(h);

% いろいろやる前にlinkをoffにする
for iisetAxis=1:nfiles
    %             setappdata(h(iisetAxis),'graphics_linkprop',[]);
    %             getappdata(h(iisetAxis),'graphics_linkprop');
    if(isappdata(h(iisetAxis),'graphics_linkprop'))
        rmappdata(h(iisetAxis),'graphics_linkprop');
    end
end
if(any(is2D(h)))
    linkaxes(h,'off');
end


% limmode

switch UD.axis.limmode_x
    case 'manual'
        set(h,'XLimMode','manual');
    case 'tight'
        if(iscell(get(h,'YLim')))
            maxYLim    = cell2mat(get(h,'YLim'));
        else
            maxYLim =get(h,'YLim');
        end
        axis(h,'tight')
        for iisetAxis =1:nfiles
            set(h(iisetAxis),'YLim',maxYLim(iisetAxis,:));
        end
        %                 set(h,'XLim',[-inf inf])
        
    otherwise
        set(h,'XLimMode','auto');
end

switch UD.axis.limmode_y
    case 'manual'
        set(h,'YLimMode','manual');
    case 'tight'
        if(iscell(get(h,'XLim')))
            maxXLim    = cell2mat(get(h,'XLim'));
        else
            maxXLim    = get(h,'XLim');
        end
        axis(h,'tight')
        for iisetAxis =1:nfiles
            set(h(iisetAxis),'XLim',maxXLim(iisetAxis,:));
        end
        %               set(h,'YLim',[-inf inf])
    otherwise
        set(h,'YLimMode','auto');
end


% scale
if(UD.axis.scale_x)
    maxLeng = get(h,'XLim');
    maxLeng = diff(cell2mat(maxLeng),1,2);
    maxLeng = max(maxLeng);
    for iisetAxis  = 1:nfiles
        newlim = get(h(iisetAxis),'XLim');
        newlim = [mean(newlim)-maxLeng/2 mean(newlim)+maxLeng/2];
        set(h(iisetAxis),'XLim',newlim,'XLimMode','manual');
    end
end
if(UD.axis.scale_y)
    maxLeng = get(h,'YLim');
    maxLeng = diff(cell2mat(maxLeng),1,2);
    maxLeng = max(maxLeng);
    for iisetAxis  = 1:nfiles
        newlim = get(h(iisetAxis),'YLim');
        newlim = [mean(newlim)-maxLeng/2 mean(newlim)+maxLeng/2];
        set(h(iisetAxis),'YLim',newlim,'YLimMode','manual');
    end
end

% save
if(UD.axis.save_x)
    for iisetAxis  = 1:nfiles
        if(iscell(UD.XLim))
            set(h(iisetAxis),'XLim',UD.XLim{iisetAxis},'XLimMode','manual')
        else
            set(h(iisetAxis),'XLim',UD.XLim,'XLimMode','manual')
        end
    end
end
if(UD.axis.save_y)
    for iisetAxis  = 1:nfiles
        if(iscell(UD.XLim))
            set(h(iisetAxis),'YLim',UD.YLim{iisetAxis},'YLimMode','manual')
        else
            set(h(iisetAxis),'YLim',UD.YLim,'YLimMode','manual')
        end
    end
end

% link
if(length(h)>1)
    %     if(UD.axis.link_x || UD.axis.link_y)
    %         maxXLim = cell2mat(get(h,'XLim'));
    %         maxXLim = [min(maxXLim(:,1)) max(maxXLim(:,2))];
    %
    %         maxYLim = cell2mat(get(h,'YLim'));
    %         maxYLim = [min(maxYLim(:,1)) max(maxYLim(:,2))];
    %
    %     end
    %     if(UD.axis.link_x && UD.axis.link_y)
    %         linkaxes(h,'xy');
    %         set(h,'XLim',maxXLim,'YLim',maxYLim);
    %     elseif(UD.axis.link_x && ~UD.axis.link_y)
    %         linkaxes(h,'x');
    %         set(h,'XLim',maxXLim);
    %     elseif(~UD.axis.link_x && UD.axis.link_y)
    %         linkaxes(h,'y');
    %         set(h,'YLim',maxYLim);
    %     else
    %         linkaxes(h,'off');
    %     end
    
    if(UD.axis.link_xall || UD.axis.link_yall || UD.axis.link_xrow || UD.axis.link_yrow || UD.axis.link_ycol || UD.axis.link_xcol)
        
        
        if(UD.axis.link_xall)
            maxXLim = get(h,'XLim');
            if(iscell(maxXLim))
                maxXLim = cell2mat(maxXLim);
                maxXLim = [min(maxXLim(:,1)) max(maxXLim(:,2))];
            end
            linkprop(h,'XLim');
            if(any(is2D(h)))
                linkaxes(h,'x',false);
            end
            set(h,'XLim',maxXLim);
        elseif(UD.axis.link_xrow)
            nrow    = max(hrowcol(:,1));
            for irow=1:nrow
                maxXLim = get(h(hrowcol(:,1)==irow),'XLim');
                if(iscell(maxXLim))
                    maxXLim = cell2mat(maxXLim);
                    maxXLim = [min(maxXLim(:,1)) max(maxXLim(:,2))];
                end
%                 disp(['xlink row',num2str(irow)])
                linkprop(h(hrowcol(:,1)==irow),'XLim');
                if(any(is2D(h(hrowcol(:,1)==irow))))
                    linkaxes(h(hrowcol(:,1)==irow),'x',false);
                end
                set(h(hrowcol(:,1)==irow),'XLim',maxXLim);
            end
        elseif(UD.axis.link_xcol)
            ncol    = max(hrowcol(:,2));
            for icol=1:ncol
                maxXLim = get(h(hrowcol(:,2)==icol),'XLim');
                if(iscell(maxXLim))
                    maxXLim = cell2mat(maxXLim);
                    maxXLim = [min(maxXLim(:,1)) max(maxXLim(:,2))];
                end
%                 disp(['xlink col',num2str(icol)])
                linkprop(h(hrowcol(:,2)==icol),'XLim');
                if(is2D(h(hrowcol(:,2)==icol)))
                    linkaxes(h(hrowcol(:,2)==icol),'x',false);
                end
                set(h(hrowcol(:,2)==icol),'XLim',maxXLim);
            end
        end
        
        if(UD.axis.link_yall)
            maxYLim = get(h,'YLim');
            if(iscell(maxYLim))
                maxYLim = cell2mat(maxYLim);
                maxYLim = [min(maxYLim(:,1)) max(maxYLim(:,2))];
            end
            linkprop(h,'YLim');
            if(is2D(h))
                linkaxes(h,'y',false);
            end
            set(h,'YLim',maxYLim);
        elseif(UD.axis.link_yrow)
            nrow    = max(hrowcol(:,1));
            for irow=1:nrow
                maxYLim = get(h(hrowcol(:,1)==irow),'YLim');
                if(iscell(maxYLim))
                    maxYLim = cell2mat(maxYLim);
                    maxYLim = [min(maxYLim(:,1)) max(maxYLim(:,2))];
                end
%                 disp(['ylink row',num2str(irow)])
                linkprop(h(hrowcol(:,1)==irow),'YLim');
                if(is2D(h(hrowcol(:,1)==irow)))
                    linkaxes(h(hrowcol(:,1)==irow),'y',false);
                end
                set(h(hrowcol(:,1)==irow),'YLim',maxYLim);
            end
        elseif(UD.axis.link_ycol)
            ncol    = max(hrowcol(:,2));
            for icol=1:ncol
                maxYLim = get(h(hrowcol(:,2)==icol),'YLim');
                if(iscell(maxYLim))
                    maxYLim = cell2mat(maxYLim);
                    maxYLim = [min(maxYLim(:,1)) max(maxYLim(:,2))];
                end
%                 disp(['ylink col',num2str(icol)])
                linkprop(h(hrowcol(:,2)==icol),'YLim');
                if(is2D(h(hrowcol(:,2)==icol)))
                    linkaxes(h(hrowcol(:,2)==icol),'y',false);
                end
                set(h(hrowcol(:,2)==icol),'YLim',maxYLim);
            end
        end
    else
        for iisetAxis=1:nfiles
            if(isappdata(h(iisetAxis),'graphics_linkprop'))
                rmappdata(h(iisetAxis),'graphics_linkprop');
            end
        end
        if(is2D(h))
            linkaxes(h,'off');
        end
    end
    
    
end
% % linkprop
% if(length(h)>1)
%     propcell    = UD.axis.link_prop;
%     if(iscell(propcell))
%         propcell    = propcell{1};
%     end
%     propcell    = strread(propcell,'%s');
%     
%     if(~isempty(propcell))
%         hlink   = linkprop(h,propcell);
%         for ih  =1:length(h)
%             setappdata(h(ih),'graphics_linkprop',hlink);
%         end
%         %         disp([deblank(sprintf('%s ',propcell{:})),' was linked.'])
%     end
% end

% grid
if(length(h)>1)
    if(UD.axis.grid_x)
        set(h,'XGrid','on');
    else
        set(h,'XGrid','off');
    end
    if(UD.axis.grid_y)
        set(h,'YGrid','on');
    else
        set(h,'YGrid','off');
    end
    
end

end

function    Data   = unit_adjustment(Data,S)
% Unit adjustment
if(~isfield(S,'Unit'))        %d.u. -> V
    VoltageRange    = 5;
    BitPrecision    = 16;
    cfactor         = VoltageRange / pow2(BitPrecision - 1);
    Data        = double(Data)* cfactor;
else
    switch S.Unit
        case 'uV'               %uV -> V
            Data    = Data/1000/1000;
        case 'mV'               %mV -> V
            Data    = Data/1000;
    end
end
end






function slider(svc,event,command)
if(nargin<1)
    command = 'on';
end
UD      = get(gcf,'UserData');
h(1)    = findobj(gcf,'Tag','slider');
h(2)    = findobj(gcf,'Tag','slider_text');
h(3)    = findobj(gcf,'Tag','slider_setStep');

% get MaxTrial
MaxTrial    = 0;
for iData=1:length(UD.Data)
    if(isfield(UD.Data{iData},'TrialsToUse'))
        if(~isempty(UD.Data{iData}.TrialsToUse))
            MaxTrial    = max(MaxTrial,length(UD.Data{iData}.TrialsToUse));
        else
            MaxTrial    = max(MaxTrial,UD.Data{iData}.nTrials);
        end
    else
        if(isfield(UD.Data{iData},'nTrials'))
            MaxTrial    = max(MaxTrial,UD.Data{iData}.nTrials);
        end
    end
end
UD.Slider.MaxTrial  = MaxTrial;

switch command
    case 'move'
    case 'setStep'
        UD.Slider.nTrial    = str2double(get(h(3),'String'));
        
    case 'on'
        if(~UD.Slider.On)
            m       = findobj(gcf,'Tag','show_slider');
            set(h,'Visible','on');
            set(m,'Label','Hide Slider');
            
            UD.Slider.On    = true;
        else
            m       = findobj(gcf,'Tag','show_slider');
            set(h,'Visible','off');
            set(m,'Label','Show Slider');
            
            UD.Slider.On    = false;
            
        end
        
end

UD.Slider.Value     = get(h(1),'Value');
UD.Slider.StartIndex= max(1,round(UD.Slider.MaxTrial*UD.Slider.Value));
UD.Slider.StopIndex = min(UD.Slider.MaxTrial,UD.Slider.StartIndex+UD.Slider.nTrial-1);

set(UD.fig,'UserData',UD);

UD.Slider.Step      = [1/UD.Slider.MaxTrial UD.Slider.nTrial/UD.Slider.MaxTrial];
set(h(1),'SliderStep',UD.Slider.Step);

plotData




end