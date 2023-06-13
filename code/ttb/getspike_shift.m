function getspike_shift
global gsobj;

% shift	= -0.1;     % ms

% opointer    = get(gcf,'pointer');
set(gcf,'pointer','fullcrosshair');
waitforbuttonpress;
set(gcf,'pointer','arrow');
CP =get(gca,'CurrentPoint');

x   = CP(1,1);
shift   = x;

% shift   = str2double(get(gsobj.handles.shift,'string'))

timestamps  = gsobj.spike.Data;
YData       = gsobj.scope.YData;
XData       = gsobj.scope.XData;
ntimestamps = length(timestamps);

Window      = gsobj.scope.Window;
Reflactory  = gsobj.scope.Reflactory;
SampleRate  = gsobj.unit.SampleRate;
dt          = gsobj.unit.dt;
nUnitData   = length(gsobj.unit.Data);

WindowIndex = round((Window/1000) * SampleRate);
ReflactoryIndex = max(round((Reflactory/1000) * SampleRate),1);

shiftInd    = round((shift/1000) * SampleRate);
shift       = shiftInd * dt *1000;                  % ms

timestamps  = timestamps + shiftInd;

StartWindowIndeces  = timestamps + WindowIndex(1);
StopWindowIndeces   = timestamps + WindowIndex(2);

timestamps  = timestamps(StartWindowIndeces >= 1 & StopWindowIndeces <= nUnitData);

gsobj.spike.Data = timestamps;

if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'add') & ~isempty(gsobj.tawindow.add))
    ntawindow   = length(gsobj.tawindow.add);
    for ii  = 1:ntawindow
        gsobj.tawindow.add(ii).XData    = nearest(XData,gsobj.tawindow.add(ii).XData - shift);     %ms
        if(gsobj.tawindow.add(ii).XData<XData(1) | gsobj.tawindow.add(ii).XData>XData(end))
            gsobj.tawindow.add(ii)  = [];
        end
            
    end
end

if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'except') & ~isempty(gsobj.tawindow.except))
    ntawindow    = length(gsobj.tawindow.except);
    for ii  =1:ntawindow
        gsobj.tawindow.except(ii).XData    = nearest(XData,gsobj.tawindow.except(ii).XData - shift);     %ms
        if(gsobj.tawindow.except(ii).XData<XData(1) | gsobj.tawindow.except(ii).XData>XData(end))
            gsobj.tawindow.except(ii)  = [];
        end
    end
end

