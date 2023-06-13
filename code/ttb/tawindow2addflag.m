function tawindow2addflag
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

addflag     = logical(ones(size(timestamps)))';
focusflag   = logical(ones(size(timestamps)))';

if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'add') & ~isempty(gsobj.tawindow.add))
    ntawindow   = length(gsobj.tawindow.add);
    for ii  = 1:ntawindow
        tax = gsobj.tawindow.add(ii).XData;
        tay = gsobj.tawindow.add(ii).YData;
        if(any(scopeXData==tax))
            addflag = (addflag & (scopeYData(:,scopeXData==tax)>= tay(1) & scopeYData(:,scopeXData==tax)<= tay(2)));
            disp(['add',num2str(ii)])
        end

    end
end

if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'except') & ~isempty(gsobj.tawindow.except))
    ntawindow    = length(gsobj.tawindow.except);
    for ii  =1:ntawindow
        tax = gsobj.tawindow.except(ii).XData;
        tay = gsobj.tawindow.except(ii).YData;
        if(any(scopeXData==tax))
            addflag    = (addflag & (scopeYData(:,scopeXData==tax)< tay(1) | scopeYData(:,scopeXData==tax)> tay(2)));
            disp(['except',num2str(ii)])
        end
    end
end

gsobj.spike.addflag = addflag;