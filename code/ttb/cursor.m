function tcursor

target  = gcf;
makefigure(target);
settarget;
applymode;

end

%----------------------------
function makefigure(target)
figsize = [300,75];

if(isempty(findobj('Tag','CURSORFIG')))

    figposition = getconfig(mfilename,'Position');

    screenunit  = get(0,'Units');
    if(strcmpi(screenunit,'pixels'))
        screensize  = get(0,'ScreenSize');
    else
        set(0,'Units','pixels');
        screensize  = get(0,'ScreenSize');
        set(0,'Units',screenunit);
    end
    centerXY    = [round(screensize(3)/2),round(screensize(4)/2)];
    
    if(isempty(figposition))
        figposition = [centerXY(1) - round(figsize(1)/2),centerXY(2) - round(UD.figsize(2)/2),figsize];
    else
        figposition(3:4)    = figsize;
        
        if(figposition(1) < 1)
            figposition(1) = 1;
        end
        if(figposition(1)+figposition(3) > screensize(3))
            figposition(1) = screensize(3) - figposition(3);
        end
        
        if(figposition(2) < 1)
            figposition(2) = 1;
        end
        if(figposition(2)+figposition(4) > screensize(4))
            figposition(2) = screensize(4) - figposition(4);
        end
    end
    
    UD.target   = target;
%     UD.figsize  = figposition(3:4);
    
    UD.fig  = figure('Name','cursor',...
        'Menubar','none',...
        'NumberTitle','Off',...
        'Position',figposition,...
        'Resize','Off',...
        'Tag','CURSORFIG',...
        'Toolbar','none',...
        'DeleteFcn',@fig_DeleteFcn);
    
    UD.h.display = uicontrol(UD.fig,'Units','pixels',...
        'BackgroundColor',get(UD.fig,'Color'),...
        'Callback',[],...
        'FontSize',16,...
        'FontWeight','Bold',...
        'max',100,...
        'min',0,...
        'Position',[0,0,figsize(1),figsize(2)],...
        'Style','text',...
        'String',[]);
    
    % UD.h.listbox    = uicontrol(fig,'Units','pixels',...
    %     'BackgroundColor',get(fig,'Color'),...
    %     'Position',[0 0 1 0.5],...
    %     'Style','edit',...
    %     'String',[]);
    
%     UD.h.optionpb  = uicontrol(UD.fig,'Units','pixels',...
%         'BackgroundColor',get(UD.fig,'Color'),...
%         'Callback',@optionpb_callback,...
%         'FontSize',6,...
%         'HorizontalAlignment','center',...
%         'String','v',...
%         'Style','pushbutton',...
%         'UserData',false,...
%         'Value', 1,...
%         'Position' ,[UD.figsize(2)-16 20 16 16]);
%     
    UD.mode = 'both';
    UD.drag = false;
    UD.hA   = get(UD.target,'CurrentAxes');
    
    guidata(UD.fig,UD);
end
end

% -----------------------
function applymode
UD  = guidata(findobj('Tag','CURSORFIG'));

switch UD.mode
    case 'both'
        set(UD.target,'Pointer','fullcrosshair');
    case 'none'
        set(UD.target,'Pointer','arrow');
    otherwise
        set(UD.target,'Pointer','arrow');
end
end

% -----------------------
function settarget(varargin)
UD  = guidata(findobj('Tag','CURSORFIG'));
UD.targetsetting    = get(UD.target);

set(UD.target,'KeyPressFcn',@target_kpfcn,...
    'WindowButtonDownFcn',@target_bdfcn,...
    'WindowButtonMotionFcn',@target_bmfcn,...
    'WindowButtonUpFcn',@target_bufcn);

guidata(UD.fig,UD);
end

% -----------------------
function fig_DeleteFcn(varargin)
UD  = guidata(findobj('Tag','CURSORFIG'));

try
set(UD.target,'KeyPressFcn',UD.targetsetting.KeyPressFcn,...
    'Pointer',UD.targetsetting.Pointer,...
    'WindowButtonDownFcn',UD.targetsetting.WindowButtonDownFcn,...
    'WindowButtonMotionFcn',UD.targetsetting.WindowButtonMotionFcn,...
    'WindowButtonUpFcn',UD.targetsetting.WindowButtonUpFcn);
end

setconfig(mfilename,'Position',get(UD.fig,'Position'));

end

% -----------------------
function target_kpfcn(src,event,varargin)
fig = findobj('Tag','CURSORFIG');
if(isempty(fig))
    set(gcf,'KeyPressFcn',[],...
        'Pointer','arrow',...
        'WindowButtonDownFcn',[],...
        'WindowButtonMotionFcn',[],...
        'WindowButtonUpFcn',[]);
    return;
end
UD  = guidata(fig);

switch event.Key
    case 'space'
        switch UD.mode
            case 'none'
                UD.mode = 'both';
            case 'both'
                UD.mode = 'none';
        end
        guidata(UD.fig,UD)
        applymode;

end
end

% -----------------------
function target_bdfcn(varargin)
fig = findobj('Tag','CURSORFIG');
if(isempty(fig))
    set(gcf,'KeyPressFcn',[],...
        'Pointer','arrow',...
        'WindowButtonDownFcn',[],...
        'WindowButtonMotionFcn',[],...
        'WindowButtonUpFcn',[]);
    return;
end
UD  = guidata(fig);
UD.hA   = get(UD.target,'CurrentAxes');
if(isempty(UD.hA))
    return;
end

CP  = get(UD.hA,'CurrentPoint');
UD.CP1  = [CP(1,1),CP(1,2)];
UD.drag = true;
guidata(UD.fig,UD);

rbbox
end

% -----------------------
function target_bufcn(varargin)
fig = findobj('Tag','CURSORFIG');
if(isempty(fig))
    set(gcf,'KeyPressFcn',[],...
        'Pointer','arrow',...
        'WindowButtonDownFcn',[],...
        'WindowButtonMotionFcn',[],...
        'WindowButtonUpFcn',[]);
    return;
end
UD  = guidata(fig);

UD.drag = false;

guidata(UD.fig,UD);
end


% -----------------------
function target_bmfcn(varargin)
fig = findobj('Tag','CURSORFIG');
if(isempty(fig))
    set(gcf,'KeyPressFcn',[],...
        'Pointer','arrow',...
        'WindowButtonDownFcn',[],...
        'WindowButtonMotionFcn',[],...
        'WindowButtonUpFcn',[]);
    return;
end
UD  = guidata(fig);

CM   = get(UD.target,'CurrentModifier');

if(ismember('control',CM))
    UD.fitdata  = true;
else
    UD.fitdata  = false;
end
if(ismember('shift',CM))
    UD.scale  = 1000;
else
    UD.scale  = 1;
end

UD.hA   = get(UD.target,'CurrentAxes');
if(isempty(UD.hA))
    return;
end
CP      = get(UD.hA,'CurrentPoint');
UD.CP   = [CP(1,1),CP(1,2)];

guidata(UD.fig,UD);
refreshdisplay

end

% -----------------------
function refreshdisplay(varargin)
UD  = guidata(findobj('Tag','CURSORFIG'));

switch UD.mode
    case 'both'
        if(UD.drag)
            CP1 = UD.CP1;
            CP2 = UD.CP;
            if(UD.fitdata)
                [CP1(1),CP1(2)] = fitdata(CP1(1),CP1(2),UD.hA);
                [CP2(1),CP2(2)] = fitdata(CP2(1),CP2(2),UD.hA);
                
                CP1 = CP1 * UD.scale;
                CP2 = CP2 * UD.scale;
                CP3 = CP2 - CP1;
                
                suffix  = '*';
                s   = {['x1:',num2str(CP1(1),'%g'),',  y1:',num2str(CP1(2),'%g'),suffix],...
                    ['x2:',num2str(CP2(1),'%g'),',  y2:',num2str(CP2(2),'%g'),suffix],...
                    ['dx:',num2str(CP3(1),'%g'),',  dy:',num2str(CP3(2),'%g'),suffix]};
            else
                CP1 = CP1 * UD.scale;
                CP2 = CP2 * UD.scale;
                CP3 = CP2 - CP1;
                
                suffix  = '';
                s   = {['x1:',num2str(CP1(1),'%0.2f'),',  y1:',num2str(CP1(2),'%0.2f'),suffix],...
                    ['x2:',num2str(CP2(1),'%0.2f'),',  y2:',num2str(CP2(2),'%0.2f'),suffix],...
                    ['dx:',num2str(CP3(1),'%0.2f'),',  dy:',num2str(CP3(2),'%0.2f'),suffix]};
            end
            set(UD.h.display,'String',s);
        else
            CP  = UD.CP;
            if(UD.fitdata)
                [CP(1),CP(2)]   =fitdata(CP(1),CP(2),UD.hA);
                CP = CP * UD.scale;
                
                suffix  = '*';
                s   = {['x:',num2str(CP(1),'%g'),',  y:',num2str(CP(2),'%g'),suffix]};
            else
                CP = CP * UD.scale;
                
                suffix  = '';
                s   = {['x:',num2str(CP(1),'%0.2f'),',  y:',num2str(CP(2),'%0.2f'),suffix]};
            end
            
            set(UD.h.display,'String',s);
        end
    case 'none'
        set(UD.h.display,'String',[])
end
end




% -----------------------
function [X,Y] = fitdata(X,Y,hA)
XData   = get(findobj(hA,'-depth',1,'-property','XData'),'XData');
if(~isempty(XData))
    if(iscell(XData))
        XX  = cellfun(@nearest,XData,num2cell(repmat(X,size(XData))));
        X   = nearest(XX,X);
    else
        X   = nearest(XData,X);
    end
end

YData   = get(findobj(hA,'-depth',1,'-property','YData'),'YData');
if(~isempty(YData))
    if(iscell(YData))
        YY   = cellfun(@nearest,YData,num2cell(repmat(Y,size(XData))));
        Y   = nearest(YY,Y);
    else
        Y   = nearest(YData,Y);
    end
end
end


% -----------------------



%     oriname =get(fid,'Name');
%     set(fid,'pointer','fullcrosshair',...
%         'WindowButtonDownFcn',['tcursor(',num2str(fid),',''selected'')'],...
%         'WindowButtonMotionFcn',['tcursor(',num2str(fid),',''selecting'')']);
%     pos     = get(fid,'Position');
%
%     if(isempty(findobj('Tag','tcursor')))
%
%
% else
%     switch command
%         case 'listcallback'
%
%             h   = findobj('Tag','CursorSelected');
%             list    = get(h,'String');
%             nlist   = size(list,1);
%             v       = get(h,'value');
%
%             if(nlist > 3)
%                 if(v==2)
%                     list(4:nlist)   = [];
%                 elseif(v==3)
%                     %                     disp(list(4:nlist));
%                     l   = list(4:nlist);
%                     nl  = size(l,1);
%                     L   = zeros(nl,2);
%                     for ii=1:nl
%                         ind     = findstr(l{ii},':');
%                         L(ii,1) = str2num(l{ii}(ind(1)+1:ind(2)-5));
%                         L(ii,2) = str2num(l{ii}(ind(2)+1:end));
%                     end
%                     assignin('base','cursor_data',L);
%
%                     nLL = floor(nl/2);
%                     LL  = zeros(nLL,3);
%                     for ii=1:nLL
%                         LL(ii,1)    = round(mean(L(ii*2-1:ii*2,2)));
%                         LL(ii,2)    = round(L(ii*2-1,1));
%                         LL(ii,3)    = round(L(ii*2,1));
%                     end
%                     assignin('base','cursor_data2',LL);
%                 end
%             end
%
%             set(h,'String',list,...
%                 'Value',1);
%
%         case 'selecting'
%
%
%             CP =get(gca,'CurrentPoint');
%
%             h   = findobj('Tag','CursorSelecting');
%             set(h,'String',['x:',num2str(CP(1,1)),',  y:',num2str(CP(1,2))]);
%         case 'selected'
%
%
%             CP =get(gca,'CurrentPoint');
%
%             h   = findobj('Tag','CursorSelected');
%             list    = get(h,'String');
%
%             if(ischar(list))
%                 list    = {list;['x:',num2str(CP(1,1)),',  y:',num2str(CP(1,2))]};
%             elseif(iscell(list))
%                 list    = [list;['x:',num2str(CP(1,1)),',  y:',num2str(CP(1,2))]];
%             else
%                 list    = {['x:',num2str(CP(1,1)),',  y:',num2str(CP(1,2))]};
%             end
%             nlist   = size(list,1);
%             set(h,'String',list,...
%                 'Value',nlist);
%             %             drawnow;
%
%         case 'close'
%
%             %             fig = gcf;
%             %             fid = guidata(fig);
%             %             if(isobject(fid))
%             try
%                 set(fid,'pointer','arrow',...
%                     'WindowButtonMotionFcn','');
%
%             end
%
%             %             end
%
%     end
% end
