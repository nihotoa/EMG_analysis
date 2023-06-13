function wvfview(varargin)

if nargin  < 1
% initialize

WVFobjs = [];
fig = figure('Menubar','figure',...
    'Name','WVF view',...
    'Numbertitle','off',...
    'PaperUnits' ,'centimeters',...
    'PaperOrientation' , 'landscape',...
    'PaperPosition' , [-2.08175 -1.12758 33.8409 23.2392],...
    'PaperPositionMode' , 'manual',...
    'Units' , 'pixels',...
    'Pointer','fullcross',...
    'Position' , [237 175 749 765],...
    'Tag','WVFview',...
    'ToolBar' , 'figure',...
    'UserData',WVFobjs);

H1  = uimenu(fig,'Label','&WVF',...
    'Position',1,...
    'Tag','WVF');
H11 = uimenu(H1,'Accelerator','o',...
    'Callback','wvfview(''OpenFile'')',...
    'Label','Open File',...
    'Tag','OpenFile');
H12 = uimenu(H1,'Accelerator','w',...
    'Callback','wvfview(''CloseFile'')',...
    'Label','Close File',...
    'Tag','CloseFile');
H13 = uimenu(H1,'Accelerator','p',...
    'Callback','wvfview(''PrintPreview'')',...
    'Label','Print Preview',...
    'Tag','PrintPreview');
H14 = uimenu(H1,'Accelerator','p',...
    'Callback','wvfview(''Print'')',...
    'Label','Print',...
    'Tag','Print');
H15 = uimenu(H1,'Accelerator','q',...
    'Callback','wvfview(''Quit'')',...
    'Label','Quit',...
    'Separator','on',...
    'Tag','Quit');

else
    command = varargin{1}
    switch command
        case 'OpenFile'
            fig     = hWVFview;
            WVFobjs = getUserdata(fig);
            nWVFobj = length(WVFobjs);
            
            [DATA,HDR,NAME]  = wvfload;
            [par, NAME, ext] = fileparts(NAME);   
            WVFobjs(nWVFobj + 1).NAME   = NAME;
            WVFobjs(nWVFobj + 1).HDR    = HDR;
            WVFobjs(nWVFobj + 1).DATA   = DATA;
            
            setUserdata(fig,WVFobjs);
            
            plotwvf(fig,WVFobjs)
        case 'CloseFile'
            fig     = hWVFview;
            WVFobjs = getUserdata(fig);
            WVFobjs = [];
            setUserdata(fig,WVFobjs);
            delete(findobj(fig,'Type','axes'))            
        
        case 'PrintPreview'
            fig = hWVFview;
            printpreview(fig);
        case 'Print'
            fig = hWVFview;
            printdlg(fig);
        case 'Quit'
            fig = hWVFview;
            close(fig)
    end
            
end

%-----------------------------------------
function fig    = hWVFview
fig = findobj(0,'Tag','WVFview');
    
%-----------------------------------------
function Userdata   = getUserdata(h)
Userdata    = get(h,'Userdata');

%-----------------------------------------
function setUserdata(h,x)
set(h,'Userdata',x);

%-----------------------------------------
function plotwvf(fig,WVFobjs)
nWVFobj = length(WVFobjs);

for ii=1:nWVFobj
    DATA    = WVFobjs(ii).DATA;
    HDR     = WVFobjs(ii).HDR;
    NAME    = WVFobjs(ii).NAME;
    figure(fig)
    h   = subplot(nWVFobj,1,ii,'align');
    
    % time scale
    t       = HDR.HResolution * ([1:HDR.BlockSize] - (HDR.DisplayPointNo + HDR.TriggerPointNo)) + HDR.HOffset;
    tTrigger    = t(HDR.DisplayPointNo + HDR.TriggerPointNo);
    DisplayRange(1) = t(HDR.DisplayPointNo);
    DisplayRange(2) = t(HDR.DisplayPointNo + HDR.DisplayBlockSize);

    % plot
    plot(h,t,DATA,'k')
    hold on
    plot(h,t,mean(DATA,2),'r')
    hold off
    axis([DisplayRange(1) DisplayRange(2) -Inf Inf])
    ylabel(h,{NAME,HDR.VUnit});
    xlabel(h,HDR.HUnit);
end
        
        