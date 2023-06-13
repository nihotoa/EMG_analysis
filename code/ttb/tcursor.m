function tcursor(command)

if(nargin<1)
target  = gcf;

makefigure(target);
settarget(target);
applymode(target);
else
    switch lower(command)
        case 'delete'
            set(gcf,'KeyPressFcn',[],...
                'Pointer','arrow',...
                'WindowButtonDownFcn',[],...
                'WindowButtonMotionFcn',[],...
                'WindowButtonUpFcn',[]);
       
    end
end
end

%----------------------------
function makefigure(target)
figsize = [300,75];

if(isempty(findobj('Tag',['CURSORFIG',num2str(target)])))
    
    if(~isempty(get(target,'WindowButtonUpFcn')))
        zoom(target,'off');
        pan(target,'off');
        rotate3d(target,'off');
    end

    
    
    targetName  = get(target,'Name');
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
        figposition = [centerXY(1) - round(figsize(1)/2),centerXY(2) - round(figsize(2)/2),figsize];
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
    
    
    
    UD.fig  = figure('Name',['Cursor (',targetName,')'],...
        'Menubar','none',...
        'NumberTitle','Off',...
        'Position',figposition,...
        'Resize','Off',...
        'Tag',['CURSORFIG',num2str(target)],...
        'Toolbar','none',...
        'DeleteFcn',{@fig_DeleteFcn,target});
    
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
    
    UD.target   = target;
    UD.mode = 'both';
    UD.drag = false;
    UD.hA   = get(UD.target,'CurrentAxes');
    
    guidata(UD.fig,UD);
end
end

% -----------------------
function applymode(target)
UD  = guidata(findobj('Tag',['CURSORFIG',num2str(target)]));

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
function settarget(target)
UD  = guidata(findobj('Tag',['CURSORFIG',num2str(target)]));
UD.targetsetting    = get(UD.target);

set(UD.target,'KeyPressFcn',{@target_kpfcn,target},...
    'WindowButtonDownFcn',{@target_bdfcn,target},...
    'WindowButtonMotionFcn',{@target_bmfcn,target},...
    'WindowButtonUpFcn',{@target_bufcn,target});

guidata(UD.fig,UD);
end

% -----------------------
function fig_DeleteFcn(src,event,target)
UD  = guidata(findobj('Tag',['CURSORFIG',num2str(target)]));

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
function target_kpfcn(src,event,target)
fig = findobj('Tag',['CURSORFIG',num2str(target)]);
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
        applymode(target);

end
end

% -----------------------
function target_bdfcn(src,event,target)
fig = findobj('Tag',['CURSORFIG',num2str(target)]);
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
function target_bufcn(src,event,target)
fig = findobj('Tag',['CURSORFIG',num2str(target)]);
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
function target_bmfcn(src,event,target)
fig = findobj('Tag',['CURSORFIG',num2str(target)]);
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
refreshdisplay(target)

end

% -----------------------
function refreshdisplay(target)
UD  = guidata(findobj('Tag',['CURSORFIG',num2str(target)]));

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
        XData   = cellfun(@sort,XData,'UniformOutput',false);
        XData   = cellfun(@nearest,XData,num2cell(repmat(X,size(XData))),'UniformOutput',false);
        X   = nearest(sort([XData{:}]),X);
    else
        X   = nearest(sort(XData),X);
    end
end

YData   = get(findobj(hA,'-depth',1,'-property','YData'),'YData');
if(~isempty(YData))
    if(iscell(YData))
        YData   = cellfun(@sort,YData,'UniformOutput',false);
        YData   = cellfun(@nearest,YData,num2cell(repmat(Y,size(YData))),'UniformOutput',false);
        Y   = nearest(sort([YData{:}]),Y);
    else
        Y   = nearest(sort(YData),Y);
    end
end
end


% -----------------------



