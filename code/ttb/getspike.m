function getspike(command)
global gsobj


if nargin < 1
    command = 'initialize';
end

switch command
    case 'initialize'
        clear global gsobj;
        getspike_display;
        getspike_scope;
        getspike_raster;

    case 'pathload'
        [gsobj.path]          = tgetdir;
        set(gsobj.handles.pathnametext,'String',gsobj.path)

        if(isfield(gsobj,'spike'))
            gsobj   = rmfield(gsobj,'spike');
        end
        if(isfield(gsobj.handles,'spike')&ishandle(gsobj.handles.spike))
            cla(gsobj.handles.spike)
        end

        if(isfield(gsobj,'scope'))
            gsobj   = rmfield(gsobj,'scope');
        end
        if(isfield(gsobj.handles,'scope')&ishandle(gsobj.handles.scope))
            cla(gsobj.handles.scope)
        end

        if(isfield(gsobj,'pca'))
            gsobj   = rmfield(gsobj,'pca');
        end
        if(isfield(gsobj.handles,'pca')&ishandle(gsobj.handles.pca))
            cla(gsobj.handles.pca)
        end

        if(isfield(gsobj,'psth'))
            gsobj   = rmfield(gsobj,'psth');
        end
        if(isfield(gsobj.handles,'raster')&ishandle(gsobj.handles.raster))
            cla(gsobj.handles.raster)
        end
        if(isfield(gsobj.handles,'psth')&ishandle(gsobj.handles.psth))
            cla(gsobj.handles.psth)
        end
        if(isfield(gsobj.handles,'sta')&ishandle(gsobj.handles.sta))
            cla(gsobj.handles.sta)
        end
        if(isfield(gsobj,'sta'))
            gsobj   = rmfield(gsobj,'sta');
        end
        if(isfield(gsobj,'tawindow'))
            gsobj   = rmfield(gsobj,'tawindow');
        end

        if(isfield(gsobj,'unit'))
            getspike('unitreload');
        end
        if(isfield(gsobj,'ref'))
            getspike('refreload');
        end
        if(isfield(gsobj,'msd'))
            getspike('msdreload');
        end
        if(isfield(gsobj,'trace'))
            getspike('tracereload');
        end
        %         getspike('unitreload');
        %         getspike('refreload');
        %         getspike('tracereload');


    case 'unitload'
        fig     = gsobj.handles.gsdisplay;
        h       = gsobj.handles.unit;
        
        if(isfield(gsobj,'path'))
            S   = gsobj.path;
            setconfig('topen','pathname',S);
        end
            
        [gsobj.unit,unitfile]          = topen;
        [gsobj.unit.path,gsobj.unit.filename]     =fileparts(unitfile);

        gsobj.unit.dt       = 1/gsobj.unit.SampleRate;
        nData   = length(gsobj.unit.Data);
        gsobj.unit.XData    = ([1:nData] - 1) * gsobj.unit.dt;
%         di      = max(round(nData/100000),1);
        %         di      = 50;
        %         disp(di)
        %         set(h,'Nextplot','Replace')
%         gsobj.unit.Data    =  abs((gsobj.unit.Data-mean( gsobj.unit.Data))/std(gsobj.unit.Data));   %%%%%%%%%
%         plot(h,gsobj.unit.XData([1:di:nData]), gsobj.unit.Data([1:di:nData]),'-b')
        tdsplot(h,gsobj.unit.XData,gsobj.unit.Data,'Color',[0 0 0.5]);
        set(gsobj.handles.unit,'XLim',[gsobj.unit.XData(1),gsobj.unit.XData(end)]);
%         set(gsobj.handles.bufferbutton,'String',['Buf(',num2str(di),')'])

        %         set(gsobj.handles.unitnametext,'String',fullfile(gsobj.unit.path,gsobj.unit.filename))
        set(gsobj.handles.unitnametext,'String',gsobj.unit.filename)

    case 'unitreload'
        fig     = gsobj.handles.gsdisplay;
        h       = gsobj.handles.unit;
        if(isfield(gsobj,'unit'))
            filename            = gsobj.unit.filename;
            gsobj.unit          = load(fullfile(gsobj.path,filename));
            gsobj.unit.path     = gsobj.path;
            gsobj.unit.filename = filename;
            gsobj.unit.dt       = 1/gsobj.unit.SampleRate;
            nData   = length(gsobj.unit.Data);
            gsobj.unit.XData   = ([1:nData] - 1) * gsobj.unit.dt;
%             di      = max(round(nData/100000),1);
            %         di      = 50;
            %         disp(di)
                    set(h,'Nextplot','Replace')
%                      gsobj.unit.Data    =  abs((gsobj.unit.Data-mean( gsobj.unit.Data))/std(gsobj.unit.Data));   %%%%%%%%%
%             plot(h,gsobj.unit.XData([1:di:nData]),
%             gsobj.unit.Data([1:di:nData]),'-b')
tdsplot(h,gsobj.unit.XData,gsobj.unit.Data,'Color',[0 0 0.5]);
            set(gsobj.handles.unit,'XLim',[gsobj.unit.XData(1),gsobj.unit.XData(end)]);
%             set(gsobj.handles.bufferbutton,'String',['Buf(',num2str(di),'
%             )'])

            %             set(gsobj.handles.unitnametext,'String',fullfile(gsobj.unit.path,gsobj.unit.filename))
            set(gsobj.handles.unitnametext,'String',gsobj.unit.filename)
        end


    case 'plot_unit'
        h       = gsobj.handles.unit;
        XLim    = get(h,'XLim');
        dt      = gsobj.unit.dt;
        nData   = length(gsobj.unit.Data);
        di      = max(round(diff(XLim)/dt/100000),1);
        %         di  = 1;
        %         disp(di)
        bufferind   = logical(zeros(1,nData));
        bufferind(1:di:nData)   = 1;
        bufferind   = (bufferind & gsobj.unit.XData >= (XLim(1)-5*diff(XLim)) & gsobj.unit.XData <= (XLim(2) + 5*diff(XLim)) );


        set(h,'Nextplot','ReplaceChildren')
        plot(h,gsobj.unit.XData(bufferind), gsobj.unit.Data(bufferind),'-b');drawnow;
        set(gsobj.handles.bufferbutton,'String',['Buf(',num2str(di),')'])
        %         keyboard

    case 'unitsave'
        TimeRange   = gsobj.unit.TimeRange;
        Class       = 'timestamp channel';
        SampleRate  = gsobj.spike.SampleRate;
        Data        = gsobj.spike.Data(gsobj.spike.addflag);

        [Outputname, pathname] = uiputfile(fullfile(gsobj.unit.path,'Spike.mat'), 'Save as');
        [p,Name,e]  = fileparts(Outputname);

        save(fullfile(gsobj.unit.path,Outputname),'TimeRange','Name','Class','SampleRate','Data');
        disp(fullfile(gsobj.unit.path,Outputname));

    case 'refload'
        h       = gsobj.handles.ref;
        
        if(isfield(gsobj,'path'))
            S   = gsobj.path;
            setconfig('topen','pathname',S);
        end

        [gsobj.ref,reffile]          = topen;
        [gsobj.ref.path,gsobj.ref.filename]     =fileparts(reffile);
        gsobj.ref.dt       = 1/gsobj.ref.SampleRate;
        timestampTime       = gsobj.ref.Data / gsobj.ref.SampleRate;

        h2  = plot(h,repmat(timestampTime,2,1),repmat([1;0],1,length(timestampTime)),'-r');
        ylabel(h,[num2str(length(timestampTime)),' trials'])
        gsobj.ref.h     = h2;
        gsobj.ref.addflag   = logical(ones(size(gsobj.ref.Data)));
        set(gsobj.ref.h,'ButtonDownFcn','global gsobj;gsobj.ref.addflag(find(gsobj.ref.h==gco))=~gsobj.ref.addflag(find(gsobj.ref.h==gco));getspike(''refplot'');')
        %         set(gsobj.handles.refnametext,'String',fullfile(gsobj.ref.path,gsobj.ref.filename))
        set(gsobj.handles.refnametext,'String',gsobj.ref.filename)

    case 'refreload'
        h       = gsobj.handles.ref;
        if(isfield(gsobj,'ref'))
            filename            = gsobj.ref.filename;
            gsobj.ref          = load(fullfile(gsobj.path,filename));
            gsobj.ref.path     = gsobj.path;
            gsobj.ref.filename = filename;
            gsobj.ref.dt       = 1/gsobj.ref.SampleRate;
            timestampTime       = gsobj.ref.Data / gsobj.ref.SampleRate;

            h2   = plot(h,repmat(timestampTime,2,1),repmat([1;0],1,length(timestampTime)),'-r');
            ylabel(h,[num2str(length(timestampTime)),' trials'])
            gsobj.ref.h     = h2;
            gsobj.ref.addflag   = logical(ones(size(gsobj.ref.Data)));
            set(gsobj.ref.h,'ButtonDownFcn','global gsobj;gsobj.ref.addflag(find(gsobj.ref.h==gco))=~gsobj.ref.addflag(find(gsobj.ref.h==gco));getspike(''refplot'');')
            %             set(gsobj.handles.refnametext,'String',fullfile(gsobj.ref.path,gsobj.ref.filename))
            set(gsobj.handles.refnametext,'String',gsobj.ref.filename)
        end
    case 'refplot'
        h1  = gsobj.handles.ref;
        %         timestampTime       = gsobj.ref.Data / gsobj.ref.SampleRate;

        h               = gsobj.ref.h;
        addflag         = gsobj.ref.addflag;
        ntimestamps     = length(h);
        naddflag        = sum(addflag);

        if((ntimestamps - naddflag) ~= 0)
            set(h(~addflag),'YData',[0.5,0],'Color',[0.5 0.5 0.5]);
        end
        if(naddflag ~= 0)
            set(h(addflag),'YData',[1,0],'Color',[1 0 0]);
        end

    case 'refsave'
        TimeRange   = gsobj.ref.TimeRange;
        Class       = 'timestamp channel';
        SampleRate  = gsobj.ref.SampleRate;
        Data        = gsobj.ref.Data(gsobj.ref.addflag);

%         [Outputname, pathname] = uiputfile(fullfile(gsobj.ref.path,[gsobj.ref.filename,' 2.mat']), 'Save as');
        [Outputname, pathname] = uiputfile(fullfile(gsobj.ref.path,[gsobj.ref.filename,'.mat']), 'Save as');
        [p,Name,e]  = fileparts(Outputname);

        save(fullfile(gsobj.unit.path,Outputname),'TimeRange','Name','Class','SampleRate','Data');
        disp(fullfile(gsobj.unit.path,Outputname))
        
    case 'msdload'
        
        if(isfield(gsobj,'path'))
            S   = gsobj.path;
            setconfig('topen','pathname',S);
        end

        [gsobj.msd,msdfile]          = topen;
        [gsobj.msd.path,gsobj.msd.filename]     =fileparts(msdfile);

        %         set(gsobj.handles.tracenametext,'String',fullfile(gsobj.trace.path,gsobj.trace.filename))
        set(gsobj.handles.msdnametext,'String',gsobj.msd.filename)
    case 'msdreload'
        if(isfield(gsobj,'msd'))
            filename            = gsobj.msd.filename;
            gsobj.msd          = load(fullfile(gsobj.path,filename));
            gsobj.msd.path     = gsobj.path;
            gsobj.msd.filename = filename;
            %             set(gsobj.handles.tracenametext,'String',fullfile(gsobj.trace.path,gsobj.trace.filename))
            set(gsobj.handles.msdnametext,'String',gsobj.msd.filename)
        end


    case 'traceload'
        if(isfield(gsobj,'path'))
            S   = gsobj.path;
            setconfig('topen','pathname',S);
        end

        [gsobj.trace,tracefile]          = topen;
        [gsobj.trace.path,gsobj.trace.filename]     =fileparts(tracefile);

        %         set(gsobj.handles.tracenametext,'String',fullfile(gsobj.trace.path,gsobj.trace.filename))
        set(gsobj.handles.tracenametext,'String',gsobj.trace.filename)
    case 'tracereload'
        if(isfield(gsobj,'trace'))
            filename            = gsobj.trace.filename;
            gsobj.trace          = load(fullfile(gsobj.path,filename));
            gsobj.trace.path     = gsobj.path;
            gsobj.trace.filename = filename;
            %             set(gsobj.handles.tracenametext,'String',fullfile(gsobj.trace.path,gsobj.trace.filename))
            set(gsobj.handles.tracenametext,'String',gsobj.trace.filename)
        end



    case 'raster_plot'
        h1  = gsobj.handles.raster;
        h2  = gsobj.handles.psth;
        h3  = gsobj.handles.sta;

        s.TimeRange     = gsobj.unit.TimeRange;
        s.Name          = 'TempSpike';
        s.Class         = 'timestamp channel';
        s.SampleRate    = gsobj.spike.SampleRate;
        s.Data          = gsobj.spike.Data(gsobj.spike.addflag);
        %         keyboard
        s1              = gsobj.ref;
        if(isfield(s1,'addflag'))
            s1.Data     = s1.Data(s1.addflag);
        end
%         gsobj.psth  = psth(s,s1,[-1 2],0.02);%%%%%%%
        [gsobj.psth,gsobj.psth_dat]  = psth(s,s1,[-1.024 3.072],0.008);

        rasterplot(h1,gsobj.psth,gsobj.psth_dat,'k');
        title(h1,[num2str(gsobj.psth.nTrials),' trials'])

        psthplot(h2,gsobj.psth,'k');

%         gsobj.sta   = sta(gsobj.trace,gsobj.ref,[-1 2],0,0);   %%%%%
        gsobj.sta   = sta(gsobj.trace,gsobj.ref,[-1.024 3.072],0,0);
        plot(h3,gsobj.sta.XData,gsobj.sta.YData,'-k');
        axis(h3,'tight')

    case 'scope'

        fig1 = gsobj.handles.gsdisplay;

        if(isempty(findobj(0,'Tag','gsscope')))
            getspike_scope;
        end

        fig2 = gsobj.handles.gsscope;
        getspike('thcutting_and_plot')
    case 'thcutting_and_plot'
        getspike_thcutting;
        gsscope_plot;

    case 'scope_plot'
        gsscope_plot;
    
    case 'msdfilter'
        getspike_msdfilter;
        gsscope_plot;
        
    case 'pca'
        gspca;

    case 'pca_select'
        gspca_select;

    case 'align'
        getspike_align;
        gsscope_plot;

    case 'shift'
        getspike_shift;
        gsscope_plot;
    case 'wavplay'
        getspike_wavplay;

    otherwise

end