function getspike_align
global gsobj;

localmax    = get(gsobj.handles.rb_localmax,'Value');

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


if(localmax==1)     % local maxmum
    for ii = 1:ntimestamps
        oldInd        = find(XData==0);
        [temp,newInd] = max(YData(ii,:));
        shiftInd(ii)    = newInd - oldInd;
        timestamps(ii)  = timestamps(ii) + shiftInd(ii);
    end
else
    for ii = 1:ntimestamps
        oldInd        = find(XData==0);
        [temp,newInd] = min(YData(ii,:));
        shiftInd(ii)    = newInd - oldInd;
        timestamps(ii)  = timestamps(ii) + shiftInd(ii);
    end
end

StartWindowIndeces  = timestamps + WindowIndex(1);
StopWindowIndeces   = timestamps + WindowIndex(2);

timestamps  = timestamps(StartWindowIndeces >= 1 & StopWindowIndeces <= nUnitData);
meanshift   = round(mean(shiftInd(StartWindowIndeces >= 1 & StopWindowIndeces <= nUnitData)))  * dt * 1000 ;    % ms

gsobj.spike.Data = timestamps;
if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'add') & ~isempty(gsobj.tawindow.add))
    ntawindow   = length(gsobj.tawindow.add);
    for ii  = 1:ntawindow
        gsobj.tawindow.add(ii).XData    = nearest(XData,gsobj.tawindow.add(ii).XData - meanshift);     %ms
        if(gsobj.tawindow.add(ii).XData<XData(1) | gsobj.tawindow.add(ii).XData>XData(end))
            gsobj.tawindow.add(ii)  = [];
        end
            
    end
end

if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'except') & ~isempty(gsobj.tawindow.except))
    ntawindow    = length(gsobj.tawindow.except);
    for ii  =1:ntawindow
        gsobj.tawindow.except(ii).XData    = nearest(XData,gsobj.tawindow.except(ii).XData - meanshift);     %ms
        if(gsobj.tawindow.except(ii).XData<XData(1) | gsobj.tawindow.except(ii).XData>XData(end))
            gsobj.tawindow.except(ii)  = [];
        end
    end
end

