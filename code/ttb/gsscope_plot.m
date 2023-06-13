function gsscope_plot
global gsobj

h1  = gsobj.handles.scope;
h2  = gsobj.handles.spike;

timestamps  = shiftdim(gsobj.spike.Data);
timestamps   = shiftdim(timestamps,1);
if(isempty(timestamps))
    warnbox('no timestamps')
    return;
end
SampleRate  = gsobj.spike.SampleRate;
XData       = gsobj.spike.XData;
YData       = gsobj.unit.Data;
spikeXLim   = get(h2,'XLim');
gsobj.spike.XLim    = spikeXLim;
timestampTime   = XData(timestamps);


ntimestamps     = length(timestamps);
dt          = 1000/SampleRate;         % ms
Window      = gsobj.scope.Window;

WindowIndex = [round((Window(1)/1000) * SampleRate):round((Window(2)/1000) * SampleRate)];
nWindowIndex    = length(WindowIndex);


Indices     = repmat(timestamps',1,nWindowIndex) + repmat(WindowIndex,ntimestamps,1);
scopeYData  = YData(Indices);
scopeXData  = WindowIndex * dt;     % ms
gsobj.scope.YData   = scopeYData;
gsobj.scope.XData   = scopeXData;

if(isfield(gsobj.spike,'addflag'))
    addflag     = gsobj.spike.addflag;
else
    addflag     = logical(ones(size(timestamps)))';
end
focusflag   = logical(ones(size(timestamps)))';

% if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'add') & ~isempty(gsobj.tawindow.add))
%     ntawindow   = length(gsobj.tawindow.add);
%     for ii  = 1:ntawindow
%         tax = gsobj.tawindow.add(ii).XData;
%         tay = gsobj.tawindow.add(ii).YData;
%         if(any(scopeXData==tax))
%             addflag = (addflag & (scopeYData(:,scopeXData==tax)>= tay(1) & scopeYData(:,scopeXData==tax)<= tay(2)));
%             disp(['add',num2str(ii)])
%         end
% 
%     end
% end
% 
% if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'except') & ~isempty(gsobj.tawindow.except))
%     ntawindow    = length(gsobj.tawindow.except);
%     for ii  =1:ntawindow
%         tax = gsobj.tawindow.except(ii).XData;
%         tay = gsobj.tawindow.except(ii).YData;
%         if(any(scopeXData==tax))
%             addflag    = (addflag & (scopeYData(:,scopeXData==tax)< tay(1) | scopeYData(:,scopeXData==tax)> tay(2)));
%             disp(['except',num2str(ii)])
%         end
%     end
% end


naddflag    = sum(addflag);
% atimestamps      = timestamps(addflag);
% etimestamps      = timestamps(~addflag);


% plot spike
delete(get(h2,'Children'));
if((ntimestamps - naddflag) ~= 0)
    plot(h2,repmat(timestampTime(~addflag),2,1),repmat([0.5;0],1,length(timestampTime(~addflag))),'LineStyle','-','Color',[0.5 0.5 0.5]);
end
set(h2,'Nextplot','Add');
if(naddflag ~= 0)
    plot(h2,repmat(timestampTime(addflag),2,1),repmat([1;0],1,length(timestampTime(addflag))),'-r');
end
set(h2,'Nextplot','ReplaceChildren');

focusflag       = ((timestampTime >= spikeXLim(1)) & (timestampTime <= spikeXLim(2)))';
nfocus          = sum(focusflag);
% keyboard
nfocusadd       = sum(focusflag & addflag);


%   plot scope 
delete(get(h1,'Children'));
if((nfocus - nfocusadd) ~= 0)
    Indices     = repmat(timestamps(focusflag & ~addflag)',1,nWindowIndex) + repmat(WindowIndex,nfocus-nfocusadd,1);
    scopeYData  = YData(Indices);
    plot(h1,repmat(scopeXData',1,nfocus-nfocusadd),scopeYData','LineStyle','-','Color',[0.7 0.7 0.7]);
end
set(h1,'Nextplot','Add');
if(nfocusadd ~= 0)
    Indices     = repmat(timestamps(focusflag & addflag)',1,nWindowIndex) + repmat(WindowIndex,nfocusadd,1);
    scopeYData  = YData(Indices);
    plot(h1,repmat(scopeXData',1,nfocusadd),scopeYData','-r');
end

        % plot tawindows
if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'except') & ~isempty(gsobj.tawindow.except))
    ntawindow    = length(gsobj.tawindow.except);
    for ii  =1:ntawindow
        tax = gsobj.tawindow.except(ii).XData;
        tay = gsobj.tawindow.except(ii).YData;
%         line([tax tax],tay,'Color','g','LineStyle','-','LineWidth',3,'Parent',h1,'Tag',['except',num2str(ii)]);
        h   = line([tax tax],tay,'Color','g','LineStyle','-','LineWidth',3,'Parent',h1,'ButtonDownFcn','gsmoveplot(gco,''y'');');
        gsobj.handles.tawindow.except(ii)   = h;
    end
end

if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'add') & ~isempty(gsobj.tawindow.add))
    ntawindow    = length(gsobj.tawindow.add);
    for ii  =1:ntawindow
        tax = gsobj.tawindow.add(ii).XData;
        tay = gsobj.tawindow.add(ii).YData;
%         line([tax tax],tay,'Color','b','LineStyle','-','LineWidth',3,'Parent',h1,'Tag',['add',num2str(ii)]);
        h   = line([tax tax],tay,'Color','b','LineStyle','-','LineWidth',3,'Parent',h1,'ButtonDownFcn','gsmoveplot(gco,''y'');');
        gsobj.handles.tawindow.add(ii)   = h;
    end
end
set(h1,'Nextplot','ReplaceChildren');

title(h1,[num2str(nfocusadd),'/',num2str(nfocus),' spikes  (total= ',num2str(naddflag),'/',num2str(ntimestamps),')'])


gsobj.spike.addflag = addflag;


