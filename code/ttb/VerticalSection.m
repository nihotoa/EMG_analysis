function VerticalSection(varargin)
if(nargin<1)
    WindowSize  = 1;
    command     = 'initialize';
elseif nargin < 2
    WindowSize  = varargin{1};
    command     = 'initialize';
elseif nargin < 3
    WindowSize  = varargin{1};
    command     = varargin{2};
end
switch command
    case 'initialize'
        hold(gca,'on');
        currobj =gco;
        CP =get(gca,'CurrentPoint');
        X   =CP(1,1);
        Y   =CP(1,2);
        XData   = get(currobj,'XData');
        YData   = get(currobj,'YData');
        CData   = get(currobj,'CData');
        XLim    = get(gca,'XLim');
        YLim    = get(gca,'YLim');
        [mindif,XInd] = min(abs(XData-X));
        X   =   XData(XInd);
        hfWindowSize    = round((WindowSize -1)/2);
        startWindow     = max(1,XInd-hfWindowSize);
        endWindow       = min(length(XData),XInd-hfWindowSize+WindowSize-1);
        
%         text(XData(endWindow),mean(YLim),[' ',num2str(XData(startWindow)),' - ',num2str(XData(endWindow)),' (',num2str(WindowSize),')'],'Parent',gca,'Tag','CPview','Color','w');
        text(XData(endWindow),mean(YLim),{[' ',num2str(XData(startWindow)),' - ',num2str(XData(endWindow))];['  (',num2str(WindowSize),')']},'Parent',gca,'Tag','CPview','Color','w');
        plot(gca,[XData(startWindow) XData(endWindow) XData(endWindow) XData(startWindow) XData(startWindow)],[YLim(1) YLim(1) YLim(2) YLim(2) YLim(1)],'--w','LineWidth',2,'Tag','Selecting');
        set(currobj,'Tag','currobj');
        set(gcf,'KeyPressFcn',['VerticalSection(',num2str(WindowSize),',''keypress'')'],...
            'WindowButtonMotionFcn',['VerticalSection(',num2str(WindowSize),',''selecting'')'],...
            'WindowButtonUpFcn',['VerticalSection(',num2str(WindowSize),',''selected'')']);
        
    case 'keypress'
        lastkey = get(gcf,'CurrentCharacter');
        if(lastkey == '=' || lastkey == '+')
            WindowSize = WindowSize + 1;
        elseif(lastkey == '-' || lastkey == '_')
            WindowSize = WindowSize - 1;
        end

        set(gcf,'KeyPressFcn',['VerticalSection(',num2str(WindowSize),',''keypress'')'],...
            'WindowButtonMotionFcn',['VerticalSection(',num2str(WindowSize),',''selecting'')'],...
            'WindowButtonUpFcn',['VerticalSection(',num2str(WindowSize),',''selected'')']);
        
    case 'selecting'
        CP =get(gca,'CurrentPoint');
        X   =CP(1,1);
        Y   =CP(1,2);
        currobj =findobj(gca,'Tag','currobj');
        XData   = get(currobj,'XData');
        YData   = get(currobj,'YData');
        CData   = get(currobj,'CData');
        XLim    = get(gca,'XLim');
        YLim    = get(gca,'YLim');
        [mindif,XInd] = min(abs(XData-X));
        X   =   XData(XInd);
        hfWindowSize    = round((WindowSize -1)/2);
        startWindow     = max(1,XInd-hfWindowSize);
        endWindow       = min(length(XData),XInd-hfWindowSize+WindowSize-1);
        
        set(findobj(gca,'Tag','CPview'),'Position',[XData(endWindow),mean(YLim)],'String',{[' ',num2str(XData(startWindow)),' - ',num2str(XData(endWindow))];['  (',num2str(WindowSize),')']});
        set(findobj(gca,'Tag','Selecting'),'XData',[XData(startWindow) XData(endWindow) XData(endWindow) XData(startWindow) XData(startWindow)]);
        
    case 'selected'
        hfWindowSize    = round((WindowSize -1)/2);
        delete(findobj(gca,'Tag','CPview'));
        set(gcf,'KeyPressFcn',[],...
            'WindowButtonMotionFcn',[],...
            'WindowButtonUpFcn',[]);
        B   = get(gcf,'SelectionType');
        
        h   =findobj(gca,'Tag','Selecting');
        
        CP =get(gca,'CurrentPoint');
        X   =CP(1,1);
        Y   =CP(1,2);
        currobj =findobj(gca,'Tag','currobj');
        XData   = get(currobj,'XData');
        YData   = get(currobj,'YData');
        CData   = get(currobj,'CData');
        UserData    = get(currobj,'UserData');
        XLim    = get(gca,'XLim');
        YLim    = get(gca,'YLim');
        
        [mindif,XInd] = min(abs(XData-X));
        X   =   XData(XInd);
        hfWindowSize    = round((WindowSize -1)/2);
        startWindow     = max(1,XInd-hfWindowSize);
        endWindow       = min(length(XData),XInd-hfWindowSize+WindowSize-1);
        
        Data    = mean(CData(:,[startWindow:endWindow]),2);

%         exbox   = findobj(gcf,'Tag','Selection');
%         if(~strcmp(B,'alt') && ~isempty(exbox))
%             delete(exbox)
%         end
%         set(h,'ButtonDownFcn','close(get(gco,''UserData''));delete(gco);',...
%             'Tag','Selection');
        
%         exfig   = findobj(0,'Tag','SectionFig');
%         if(~strcmp(B,'alt') && ~isempty(exfig))
%             fig = exfig(1);
%             set(fig,'Name',['Vertical Section (X=',num2str(X),')'])
%             if(length(exfig)>1)
%                 close(exfig(2:length(exfig)))
%             end
%         else
            fig = figure('Name',['Vertical Section (X: ',num2str(XData(startWindow)),' - ',num2str(XData(endWindow)),', n: ',num2str(WindowSize),')'],...
                'NumberTitle','off',...
                'Tag','SectionFig');
%         end
%         set(h,'UserData',fig)
        set(0,'CurrentFigure',fig)

        plot(YData,Data,'Color','k')
        if(~isempty(UserData) && isnumeric(UserData))
            hold('on')
            plot(YLim,UserData*ones(size(YLim)),'Color',[0.5 0.5 0.5]);
            hold('off')
        end
        set(gca,'XLim',YLim)
%         propedit(gca)


end
        
