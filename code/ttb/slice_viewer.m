function slice_viewer(command)
si  = 1.5;

MLName  = 'ML';
RCName  = 'RC';
DVName  = 'Rel.Dpt(cc)';

cmap    = [0.75 0   0;...
    0   0   0.75;...
    0   0.75    0;...
    1   0   0;...
    0   0   1;...
    0   1   0];



if(nargin<1)
    command = 'initialize';
end

if(ischar(command))

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
                'Position',[20 20 1500 1000],...
                'Renderer','None',...
                'RendererMode','auto',...
                'Tag','Display_data',...
                'ToolBar','figure');
            centerfig(UD.fig);

            UD.h.loadhm = uicontrol(UD.fig,'Units','normalized',...
                'Backgroundcolor',[0.8 0.8 0.8],...
                'Callback','slice_viewer(''loadhm'')',...
                'Max',1,...
                'Min',0,...
                'Style','pushbutton',...
                'String','Load HM',...
                'Position',[0.088 0.90 0.07 0.035]);

            UD.h.loadxls = uicontrol(UD.fig,'Units','normalized',...
                'Backgroundcolor',[0.8 0.8 0.8],...
                'Callback','slice_viewer(''loadxls'')',...
                'Max',1,...
                'Min',0,...
                'Style','pushbutton',...
                'String','Load XLS',...
                'Position',[0.169 0.90 0.07 0.035]);
            
            UD.h.selectlabel = uicontrol(UD.fig,'Units','normalized',...
                'Backgroundcolor',[0.8 0.8 0.8],...
                'Callback','slice_viewer(''selectlabel'')',...
                'Max',1,...
                'Min',0,...
                'Style','pushbutton',...
                'String','Select Label',...
                'Position',[0.250 0.90 0.07 0.035]);

            
            UD.h.list   = uicontrol(UD.fig,'Units','normalized',...
                'Backgroundcolor',[1 1 1],...
                'Callback','slice_viewer(''plot'')',...
                'Max',2,...
                'Min',0,...
                'Style','listbox',...
                'Position',[0.087 0.085 0.241 0.80]);
            
            UD.h.ax2d   = axes('Units','normalized',...
                'Parent',UD.fig,...
                'Position',[0.435 0.584 0.494 0.341]);
            xlabel(UD.h.ax2d,'ML(mm)')
            ylabel(UD.h.ax2d,'Depth(mm)')

            UD.h.ax3d   = axes('Units','normalized',...
                'CameraPosition',[-40.8496 -25.6541 26.0858],...
                'CameraPositionMode','manual',...
                'CameraTarget',[0.212051 -9.75 0.486977],...
                'CameraTargetMode','manual',...
                'CameraUpVector',[0 0 1],...
                'CameraUpVectorMode','manual',...
                'CameraViewAngle',[10.274],...
                'CameraViewAngleMode','manual',...
                'Parent',UD.fig,...
                'Position',[0.435 0.11  0.494 0.341]);
            xlabel(UD.h.ax3d,'ML(mm)')
            ylabel(UD.h.ax3d,'RC(mm)')
            zlabel(UD.h.ax3d,'Depth(mm)')
            
            
            
            
            
            set(UD.fig,'UserData',UD);


        case 'loadhm'
            UD  = get(gcf,'UserData');

            UD.hist.ParentDir   = uigetdir(pwd,'Histology mapが入っているフォルダを選択してください。');
            UD.hist.files       = uiselect(sortxls(dirmat(UD.hist.ParentDir)),1,'使用するHistology mapを選択してください');
            UD.hist.RC      = inputdlg({'RC座標:'},...
                ['各Histology mapに対応したRC座標を入力してください。（',num2str(length(UD.hist.files)),' files)'],...
                1,...
                {['1:',num2str(length(UD.hist.files))]});
            eval(['UD.hist.RC=',UD.hist.RC{:}]);

            for ifile=1:length(UD.hist.files)
                UD.hist.s{ifile}   = load(fullfile(UD.hist.ParentDir,UD.hist.files{ifile}));
            end

            set(UD.h.list,'String',UD.hist.files);
            set(UD.fig,'UserData',UD);

        case 'loadxls'
            UD  = get(gcf,'UserData');
            UD.list.xlsfile = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
            [temp1,temp2,UD.list.cells]  = xlsread(UD.list.xlsfile,-1);
            UD.label        = uiselect(UD.list.cells(1,:),1,'Labelに用いる変数を選択して下さい。');

            set(UD.fig,'UserData',UD);

        
        case 'selectlabel'
            UD  = get(gcf,'UserData');

            [UD.label,UD.labelind]  = uiselect(UD.list.cells(1,:),1,'Labelに用いる変数を選択して下さい。');

            set(UD.fig,'UserData',UD);

        
        
        
        case 'plot'
            UD  = get(gcf,'UserData');

            shm    = get(UD.h.list,'Value');
            delete(get(UD.h.ax2d,'Children'));
            delete(get(UD.h.ax3d,'Children'));
            
            if(isfield(UD,'list'))
            RCind   = strmatch(RCName,UD.list.cells(1,:));
            MLind   = strmatch(MLName,UD.list.cells(1,:));
            DVind   = strmatch(DVName,UD.list.cells(1,:));

            RC      = [UD.list.cells{2:end,RCind}];
            ML      = [UD.list.cells{2:end,MLind}];
            DV      = [UD.list.cells{2:end,DVind}];

            nlabel  = length(UD.label);
            for ilabel=1:nlabel
                UD.labelind(ilabel)    = strmatch(UD.label{ilabel},UD.list.cells(1,:),'exact');
                temp    = [UD.list.cells{2:end,UD.labelind(ilabel)}];
                zeromask(temp,isnan(temp))
                label(:,ilabel)     = logical(zeromask(temp,~isnan(temp)));
            end
            
            h2d = zeros(1,nlabel);
            h3d = zeros(1,nlabel);
            end
            
            for ihm=shm
                s   = UD.hist.s{ihm};
                hmRC  = UD.hist.RC(ihm);

                % Gray matter
                hold(UD.h.ax2d,'on');
                plot(UD.h.ax2d,s.GM.x*si,s.GM.y*si,'Color',[0.8 0.8 0.8]);
                hold(UD.h.ax3d,'on');
%                 plot3(UD.h.ax3d,s.GM.x*si,ones(size(s.GM.x))*hmRC,s.GM.y*si,'Color',[0.8 0.8 0.8]);

                fill3(s.GM.x*si,ones(size(s.GM.x))*hmRC,s.GM.y*si,[0.9 0.9 0.9],'parent',UD.h.ax3d);
                
                % central canal
                plot(UD.h.ax2d,0,0,'ok','MarkerSize',3,'MarkerFaceColor',[1 1 1])
                plot3(UD.h.ax3d,0,hmRC,0,'ok','MarkerSize',3,'MarkerFaceColor',[1 1 1])
                
                
                if(isfield(UD,'list'))
                                    ind = (round(RC)==hmRC)';

                    
                    
                % all points
                plot(UD.h.ax2d,ML(ind),DV(ind),'ok','MarkerSize',1,'MarkerFaceColor',[0 0 0])
                plot3(UD.h.ax3d,ML(ind),RC(ind),DV(ind),'ok','MarkerSize',1,'MarkerFaceColor',[0 0 0])


                % labeled points
                for ilabel=1:nlabel
                    if(sum(label(:,ilabel) & ind)~=0)
                        h2d(ilabel)   = plot(UD.h.ax2d,ML(label(:,ilabel) & ind),DV(label(:,ilabel) & ind),'ok','MarkerSize',4,'MarkerFaceColor',cmap(mod(ilabel,size(cmap,1)),:));
                        h3d(ilabel)   = plot3(UD.h.ax3d,ML(label(:,ilabel) & ind),RC(label(:,ilabel) & ind),DV(label(:,ilabel) & ind),'ok','MarkerSize',4,'MarkerFaceColor',cmap(mod(ilabel,size(cmap,1)),:));
                    else
                        h2d(ilabel)   = 0;
                        h3d(ilabel)   = 0;
                    end
                end
                end
            end
            axis(UD.h.ax2d,'equal')
            axis(UD.h.ax3d,'equal')
            
            if(isfield(UD,'Label'))
            legend(UD.h.ax2d,h2d,UD.label,'Location','NorthEast')
            legend(UD.h.ax3d,h3d,UD.label,'Location','NorthEast')
            
            
            title(UD.h.ax2d,UD.label)
            title(UD.h.ax3d,UD.label)
            end







            %         plot3(x,y,z,'ok','MarkerSize',2,'MarkerFaceColor',[0.75 0 0],'parent',h);
            %
            %         for ii=-12:-3
            %             s   = load(['L:\operation\Histology\Eito\Eito Spinal\Y',num2str(ii,'%0.2d'),'.mat']);
            %             hold(h,'on');
            %             plot3(s.GM.x*si,ones(size(s.GM.x))*ii,s.GM.y*si,'Color',[0.9 0.9 0.9]);
            %             %     fill3(s.GM.x*si,ones(size(s.GM.x))*ii,s.GM.y*si,[0.9 0.9 0.9],'EdgeColor',[0 0 0]);
            %         end
            %
            %
            %
            %
            %
            % axis(h,'equal')
    end


else
    close all

    figure
    fill(s.GM.x*si,s.GM.y*si,[0.9 0.9 0.9],'EdgeColor',[0 0 0]);
    title(s.Name)
    grid on
    set(gca,'XMinorGrid','on')
    axis equal
    tcursor
end