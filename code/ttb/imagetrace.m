function imagetrace(command)
if(nargin<1)
    command = 'initialize';
end

switch command
    case 'initialize'
        UD.fig = figure('Color',[0.8 0.8 0.8],...
            'Menubar','none',...
            'Name','Image Trace',...
            'FileName','Image Trace',...
            'NumberTitle','off',...
            'PaperUnits','centimeters',...
            'PaperOrientation','portrait',...
            'PaperPosition',[0.634518 0.634517 19.715 28.4084],...
            'PaperPositionMode','manual',...
            'PaperSize',[20.984 29.6774],...
            'PaperType','a4',...
            'Position',[20 20 1800 1100],...
            'Renderer','None',...
            'RendererMode','auto',...
            'Tag','Display_data',...
            'ToolBar','figure');
        centerfig(UD.fig);


        UD.h.imageax      = axes('Parent',UD.fig,'Position',[0.05 0.10 0.75 0.80]);

        UD.h.loadimage    = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''loadimage'')',...
            'ForegroundColor',[0 0 0],...
            'Position',[0.85 0.85 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Load Image');

        UD.h.setzero    = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''setzero'')',...
            'ForegroundColor',[0 0 0],...
            'Position',[0.85 0.80 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Set Zero');

        UD.h.rotateimage = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''rotateimage'')',...
            'ForegroundColor',[0 0 0],...
            'Position',[0.90 0.80 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Rotate Image');
        
        UD.h.fliph    = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''fliph'')',...
            'ForegroundColor',[0 0 0],...
            'Position',[0.85 0.75 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Flip Horizontal');

        UD.h.flipv = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''flipv'')',...
            'ForegroundColor',[0 0 0],...
            'Position',[0.90 0.75 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Flip Vertical');

        UD.h.addscale   = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''addscale'')',...
            'ForegroundColor',[0 0.75 0],...
            'Position',[0.85 0.70 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Add Scale');

        UD.h.scalevalue = uicontrol(UD.fig,'Unit','Normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',[],...
            'ForegroundColor',[0 0 0],...
            'Position',[0.90 0.70 0.035 0.025],...
            'Style','Edit',...
            'String','2');

        UD.h.drawWM    = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''drawWM'')',...
            'ForegroundColor',[0.8 0 0],...
            'Position',[0.85 0.65 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Trace WM');

        UD.h.deleteWM    = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''deleteWM'')',...
            'ForegroundColor',[0.8 0 0],...
            'Position',[0.90 0.65 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Delete WM');

        UD.h.drawGM    = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''drawGM'')',...
            'ForegroundColor',[0 0 0.75],...
            'Position',[0.85 0.60 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Trace GM');

        UD.h.deleteGM    = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''deleteGM'')',...
            'ForegroundColor',[0 0 0.75],...
            'Position',[0.90 0.60 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Delete GM');

        UD.h.savetrace  = uicontrol(UD.fig,'Unit','Normalized',...
            'Callback','imagetrace(''savetrace'')',...
            'ForegroundColor',[0 0 0],...
            'Position',[0.85 0.55 0.035 0.025],...
            'Style','Pushbutton',...
            'String','Save Trace');

        UD.pathname = [];
        UD.filename = [];
        UD.image.h  = [];
        UD.image.data   = [];
        UD.zero.h     = [];
        UD.zero.x     = [];
        UD.zero.y     = [];
        UD.scale.h  = [];
        UD.scale.x  = [];
        UD.scale.y  = [];
        UD.scale.l  = [];
        UD.scale.v  = [];
        UD.ml.x  = [];
        UD.ml.y  = [];
        UD.ml.d  = [];
        UD.WM.h     = [];
        UD.WM.x     = [];
        UD.WM.y     = [];
        UD.GM.h     = [];
        UD.GM.x     = [];
        UD.GM.y     = [];

        set(UD.fig,'UserData',UD);


    case 'loadimage'
       
        UD  = get(gcf,'UserData');
        
        if(isempty(UD.pathname) || ~exist(UD.pathname,'dir'))
            [UD.filename, UD.pathname] = uigetfile('*.*', 'Pick an image file');
        else
            [UD.filename, UD.pathname] = uigetfile('*.*', 'Pick an image file',[UD.pathname,'*.*']);
        end

        if(UD.filename==0)
            disp('ユーザーによってキャンセルされました。')
            return;
        end
        try
            delete(UD.image.h);
        end
        UD.image.h  = [];
        UD.image.data   = [];
        try
            delete(UD.zero.h);
        end
        UD.zero.h     = [];
        UD.zero.x     = [];
        UD.zero.y     = [];
        try
            delete(UD.scale.h);
        end
        UD.scale.h  = [];
        UD.scale.x  = [];
        UD.scale.y  = [];
        UD.scale.l  = [];
        UD.scale.v  = [];

        UD.ml.x  = [];
        UD.ml.y  = [];
        UD.ml.d  = [];
        try
            delete(UD.WM.h);
        end
        UD.WM.h     = [];
        UD.WM.x     = [];
        UD.WM.y     = [];
        try
            delete(UD.GM.h);
        end
        UD.GM.h     = [];
        UD.GM.x     = [];
        UD.GM.y     = [];

        switch UD.filename(end-2:end)
            case 'png'
                UD.image.data    = imread(fullfile(UD.pathname,UD.filename),'BackgroundColor',[1 1 1]);
            otherwise
                UD.image.data    = imread(fullfile(UD.pathname,UD.filename));
        end

        refreshimage;

        set(UD.fig,'UserData',UD);

    case 'setzero'
        UD  = get(gcf,'UserData');

        if(isempty(UD.image))
            return;
        end

        [x,y]   = ginput(1);

        UD.zero.x   = round(x);
        UD.zero.y   = round(y);

        centerizeimage;
        refreshimage;

        if(~isempty(UD.zero.h))
            try
                delete(UD.zero.h)
            end
        end
        hold(UD.h.imageax,'on')
        UD.zero.h   = plot(UD.zero.x,UD.zero.y,'ok');

        set(UD.fig,'UserData',UD);


    case 'addscale'
        UD  = get(gcf,'UserData');

        if(isempty(UD.image))
            return;
        end

        [x,y]   = ginput(2);

        UD.scale.x   = round(x);
        UD.scale.y   = round(y);
        UD.scale.l   = sqrt(diff(UD.scale.x).^2 + diff(UD.scale.y).^2 );


        if(~isempty(UD.scale.h))
            try
                delete(UD.scale.h)
            end
        end
        hold(UD.h.imageax,'on')
        UD.scale.h   = plot(UD.scale.x,UD.scale.y,'Color',[0 0.75 0],'LineWidth',2,'LineStyle','-');

        set(UD.fig,'UserData',UD);

    case 'rotateimage'
        UD  = get(gcf,'UserData');

        if(isempty(UD.image))
            return;
        end

        [x,y]   = ginput(2);

        UD.ml.x   = round(x);
        UD.ml.y   = round(y);
        UD.ml.d   = atand(-diff(UD.ml.x)/-diff(UD.ml.y));
        
        UD.image.data   = imrotate(UD.image.data,-UD.ml.d,'nearest','crop');
        refreshimage;


        set(UD.fig,'UserData',UD);
        
    case 'fliph'
        UD  = get(gcf,'UserData');

        if(isempty(UD.image))
            return;
        end

        UD.image.data   = UD.image.data(:,end:-1:1,:);
        refreshimage;

        set(UD.fig,'UserData',UD);

    case 'flipv'
        UD  = get(gcf,'UserData');

        if(isempty(UD.image))
            return;
        end

        UD.image.data   = UD.image.data(end:-1:1,:,:);
        refreshimage;

        set(UD.fig,'UserData',UD);

    case 'drawWM'
        UD  = get(gcf,'UserData');

        [UD.WM.h,UD.WM.x,UD.WM.y] = freehanddraw(UD.h.imageax,'Color',[0.75 0 0],'LineWidth',2,'LineStyle','-');

        set(UD.fig,'UserData',UD);


    case 'deleteWM'
        UD  = get(gcf,'UserData');

        if(~isempty(UD.WM.h))
            delete(UD.WM.h);
        end
        if(~isempty(UD.WM.x))
            UD.WM.x = [];
            UD.WM.y = [];
        end

        set(UD.fig,'UserData',UD);

    case 'drawGM'
        UD  = get(gcf,'UserData');

        [UD.GM.h,UD.GM.x,UD.GM.y] = freehanddraw(UD.h.imageax,'Color',[0 0 0.75],'LineWidth',2,'LineStyle','-');

        set(UD.fig,'UserData',UD);


    case 'deleteGM'
        UD  = get(gcf,'UserData');

        if(~isempty(UD.GM.h))
            delete(UD.GM.h);
        end
        if(~isempty(UD.GM.x))
            UD.GM.x = [];
            UD.GM.y = [];
        end

        set(UD.fig,'UserData',UD);
        
    case 'savetrace'
        UD  = get(gcf,'UserData');
        UD.scale.v  = str2double(get(UD.h.scalevalue,'String'));
        k   = UD.scale.v / UD.scale.l;
        
        OutData.Name    = [];
        OutData.WM.x    = k * (UD.WM.x - UD.zero.x);
        OutData.WM.y    = - k * (UD.WM.y - UD.zero.y);
        OutData.GM.x    = k * (UD.GM.x - UD.zero.x);
        OutData.GM.y    = - k * (UD.GM.y - UD.zero.y);
        
        fig = figure('DeleteFcn','uiresume');
        h   = axes('parent',fig);
        plot(h,OutData.WM.x,OutData.WM.y,'-k');
        hold(h,'on')
        plot(h,OutData.GM.x,OutData.GM.y,':k');
        plot(h,0,0,'ok')
        axis(h,'image');
        uiwait;
        
        
        outputfile      = [UD.pathname,deext(UD.filename)];
        [outfilename, outpathname] = uiputfile('*.mat', 'ファイルの保存',outputfile);
        if(outfilename==0)
            disp('ユーザーによってキャンセルされました。')
            return;
        end
        OutData.Name    = deext(outfilename);
        

        save([outpathname,outfilename],'-struct','OutData');
        disp([outpathname,outfilename,' was saved.'])
end

    function refreshimage
        if(~isempty(UD.image.h))
            try
                delete(UD.image.h);
            end
        end
        UD.image.h  = image(UD.image.data,'parent',UD.h.imageax);
        axis(UD.h.imageax,'equal')
        axis(UD.h.imageax,'tight')
        grid(UD.h.imageax,'on')
        title(UD.h.imageax,UD.filename)
        goback(UD.image.h)
    end

    function centerizeimage
        imagex  = size(UD.image.data,2);
        imagey  = size(UD.image.data,1);
        imagez  = size(UD.image.data,3);
        if(UD.zero.x > ceil((imagex - 1) / 2))
            UD.image.data   = cat(2,UD.image.data,zeros(imagey,(UD.zero.x*2 - imagex),imagez));
        elseif(UD.zero.x < ceil((imagex - 1) / 2))
            UD.image.data   = cat(2,zeros(imagey,(imagex - UD.zero.x*2),imagez),UD.image.data);
            UD.zero.x      = UD.zero.x + (imagex - UD.zero.x*2);
        end

        imagex  = size(UD.image.data,2);
        imagey  = size(UD.image.data,1);
        imagez  = size(UD.image.data,3);
        if(UD.zero.y > ceil((imagey - 1) / 2))
            UD.image.data   = cat(1,UD.image.data,zeros((UD.zero.y*2 - imagey),imagex,imagez));
        elseif(UD.zero.y < ceil((imagey - 1) / 2))
            UD.image.data   = cat(1,zeros((imagey - UD.zero.y*2),imagex,imagez),UD.image.data);
            UD.zero.y      = UD.zero.y + (imagey - UD.zero.y*2);
        end
    end
end
