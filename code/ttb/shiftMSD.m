function S  = shiftMSD(Unit,MSD)

S   =[];

BaseWindow  = [-0.03 -0.01];
% nsd         = 5;
nsd         = 3;
kk          = 3;
nn          = 10;

s   = sta(Unit,MSD,[-0.03 0.05],[0 inf],0,0);

[temp,BaseWindowInd(1)]   = nearest(s.XData,BaseWindow(1));
[temp,BaseWindowInd(2)]   = nearest(s.XData,BaseWindow(2));

Basemean    = mean(s.YData(BaseWindowInd(1):BaseWindowInd(2)));
YData       = s.YData - Basemean;

Basemean    = mean(YData(BaseWindowInd(1):BaseWindowInd(2)));
Basestd     = std(YData(BaseWindowInd(1):BaseWindowInd(2)),0);

yy  = false;

while(~yy)

    sigind      = abs(YData)>(Basemean+nsd*Basestd);
    sigind      = findcont(sigind,kk,nn);

    OnsetInd    = find(sigind,1,'first')-1;
    if(OnsetInd<1)
        OnsetInd    = 1;
    end
    OnsetTime   = s.XData(OnsetInd);

    disp(['Time shift: ',num2str(OnsetTime)]);

    clf
    subplot(2,1,1)
%     plot((s.XData-OnsetTime)*1000,abs(YData));
    plot(s.XData*1000,YData);
    hold on
    plot([s.XData(1) s.XData(end)]*1000,[nsd*Basestd,nsd*Basestd],'r');
    plot([s.XData(1) s.XData(end)]*1000,[-nsd*Basestd,-nsd*Basestd],'r');
    xlim(gca,[-10,10]+OnsetTime*1000)
    set(gca,'XTick',sort([OnsetTime*1000-10,OnsetTime*1000,0,OnsetTime*1000+10]))
    grid('on')
    title(s.Name)


    subplot(2,1,2)
    plot(s.XData*1000,YData);
    hold on
    plot([s.XData(1) s.XData(end)]*1000,[nsd*Basestd,nsd*Basestd],'r');
    plot([s.XData(1) s.XData(end)]*1000,[-nsd*Basestd,-nsd*Basestd],'r');
    xlim(gca,[-2,3]+OnsetTime*1000)
    set(gca,'XTick',sort([OnsetTime*1000-2,OnsetTime*1000,0,OnsetTime*1000+3]))
    grid('on')
    title(s.Name)

    %     uiwait(msgbox('確認してください','確認','modal'));
    [yy,nsd]   = localquestdlg(nsd);

end

S   = shiftTimestampChannel(MSD,OnsetTime);

    function [yy,nsd]   = localquestdlg(nsd)

        list    = {num2str(nsd),'1','2','3','3.5','3.8','4','5','7','10','15','20','30','50','100'};
        fig = figure('Name','確認',...
            'DeleteFcn',@close_callback,...
            'NumberTitle','off',...
            'MenuBar','none',...
            'ToolBar','none',...
            'Resize','off',...
            'Position',[1019         565         300         119]);
        h(1) = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Unit','Pixel',...
            'Callback',@h1_callback,...
            'Style','RadioButton',...
            'String','OK',...
            'Position',[50 90 100 20],...
            'Value',1,...
            'Enable','on');
        h(2)  = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Unit','Pixel',...
            'Callback',@h2_callback,...
            'Style','RadioButton',...
            'String','Change nsd',...
            'Position',[50 60 100 20],...
            'Value',0,...
            'Enable','on');

        h(3)  = uicontrol(fig,'BackgroundColor',[1 1 1],...
            'Unit','Pixel',...
            'Callback',[],...
            'Style','popupmenu',...
            'String',list,...
            'Position',[150 60 100 20],...
            'Value',1,...
            'Enable','off');


        h(4)  = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Unit','Pixel',...
            'Callback','close(gcf);',...
            'Style','pushbutton',...
            'String','Continue',...
            'Position',[120 10 60 30]);
        set(fig,'UserData',h);

        uiwait(fig)



        function close_callback(varargin)
            h   = get(gcf,'UserData');

            yy  = logical(get(h(1),'Value'));
            ind = get(h(3),'Value');
            nsd = str2double(list{ind});
        end


        function h1_callback(varargin)
            h   = get(gcf,'UserData');


            set(h(1),'Value',1)
            set(h(2),'Value',0)
            set(h(3),'Enable','off')
        end

        function h2_callback(varargin)
            h   = get(gcf,'UserData');


            set(h(1),'Value',0)
            set(h(2),'Value',1)
            set(h(3),'Enable','on')
        end
    end
end