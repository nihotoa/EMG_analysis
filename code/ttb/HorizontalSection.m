function HorizontalSection(varargin)
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
        YData   = get(currobj,'YData');
        XData   = get(currobj,'XData');
        CData   = get(currobj,'CData');
        YLim    = get(gca,'YLim');
        XLim    = get(gca,'XLim');
        [mindif,YInd] = min(abs(YData-Y));
        Y   =   YData(YInd);
        hfWindowSize    = round((WindowSize -1)/2);
        startWindow     = max(1,YInd-hfWindowSize);
        endWindow       = min(length(YData),YInd-hfWindowSize+WindowSize-1);
        
%         text(YData(endWindow),mean(XLim),[' ',num2str(YData(startWindow)),' - ',num2str(YData(endWindow)),' (',num2str(WindowSize),')'],'Parent',gca,'Tag','CPview','Color','w');
        text(mean(XLim),YData(endWindow),{[' ',num2str(YData(startWindow)),' - ',num2str(YData(endWindow))];['  (',num2str(WindowSize),')'];' '},'Parent',gca,'Tag','CPview','Color','w');
        plot(gca,[XLim(1) XLim(1) XLim(2) XLim(2) XLim(1)],[YData(startWindow) YData(endWindow) YData(endWindow) YData(startWindow) YData(startWindow)],'--w','LineWidth',2,'Tag','Selecting');
        set(currobj,'Tag','currobj');
        set(gcf,'KeyPressFcn',['HorizontalSection(',num2str(WindowSize),',''keypress'')'],...
            'WindowButtonMotionFcn',['HorizontalSection(',num2str(WindowSize),',''selecting'')'],...
            'WindowButtonUpFcn',['HorizontalSection(',num2str(WindowSize),',''selected'')']);
        
    case 'keypress'
        lastkey = get(gcf,'CurrentCharacter');
        if(lastkey == '=' || lastkey == '+')
            WindowSize = WindowSize + 1;
        elseif(lastkey == '-' || lastkey == '_')
            WindowSize = WindowSize - 1;
        end

        set(gcf,'KeyPressFcn',['HorizontalSection(',num2str(WindowSize),',''keypress'')'],...
            'WindowButtonMotionFcn',['HorizontalSection(',num2str(WindowSize),',''selecting'')'],...
            'WindowButtonUpFcn',['HorizontalSection(',num2str(WindowSize),',''selected'')']);
        
    case 'selecting'
        CP =get(gca,'CurrentPoint');
        X   =CP(1,1);
        Y   =CP(1,2);
        currobj =findobj(gca,'Tag','currobj');
        YData   = get(currobj,'YData');
        XData   = get(currobj,'XData');
        CData   = get(currobj,'CData');
        YLim    = get(gca,'YLim');
        XLim    = get(gca,'XLim');
        [mindif,YInd] = min(abs(YData-Y));
        Y   =   YData(YInd);
        hfWindowSize    = round((WindowSize -1)/2);
        startWindow     = max(1,YInd-hfWindowSize);
        endWindow       = min(length(YData),YInd-hfWindowSize+WindowSize-1);
        
        set(findobj(gca,'Tag','CPview'),'Position',[mean(XLim),YData(endWindow)],'String',{[' ',num2str(YData(startWindow)),' - ',num2str(YData(endWindow))];['  (',num2str(WindowSize),')'];' '});
        set(findobj(gca,'Tag','Selecting'),'YData',[YData(startWindow) YData(endWindow) YData(endWindow) YData(startWindow) YData(startWindow)]);
        
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
        YData   = get(currobj,'YData');
        XData   = get(currobj,'XData');
        CData   = get(currobj,'CData');
        UserData    = get(currobj,'UserData');
        YLim    = get(gca,'YLim');
        XLim    = get(gca,'XLim');
        
        [mindif,YInd] = min(abs(YData-Y));
        Y   =   YData(YInd);
        hfWindowSize    = round((WindowSize -1)/2);
        startWindow     = max(1,YInd-hfWindowSize);
        endWindow       = min(length(YData),YInd-hfWindowSize+WindowSize-1);
        
        Data    = mean(CData([startWindow:endWindow],:),1);

%         exbox   = findobj(gcf,'Tag','Selection');
%         if(~strcmp(B,'alt') && ~isempty(exbox))
%             delete(exbox)
%         end
%         set(h,'ButtonDownFcn','close(get(gco,''UserData''));delete(gco);',...
%             'Tag','Selection');
        
%         exfig   = findobj(0,'Tag','SectionFig');
%         if(~strcmp(B,'alt') && ~isempty(exfig))
%             fig = exfig(1);
%             set(fig,'Name',['Horizontal Section (Y=',num2str(Y),')'])
%             if(length(exfig)>1)
%                 close(exfig(2:length(exfig)))
%             end
%         else
            fig = figure('Name',['Horizontal Section (Y: ',num2str(YData(startWindow)),' - ',num2str(YData(endWindow)),', n: ',num2str(WindowSize),')'],...
                'NumberTitle','off',...
                'Tag','SectionFig');
%         end
%         set(h,'UserData',fig)
        set(0,'CurrentFigure',fig)
        
        plot(XData,Data,'Color','k')
        if(~isempty(UserData) && isnumeric(UserData))
            hold('on')
            plot(XLim,UserData*ones(size(XLim)),'Color',[0.5 0.5 0.5]);
            hold('off')
        end
        set(gca,'XLim',XLim)
%         propedit(gca)


end
        
