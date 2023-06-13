function getspike_thcutting
global gsobj;

Window      = [-2.5 2.5]; % ms for unit
Reflactory  = 3;        % ms for unit

% Window      = [-10 20]; % ms for MEP
% Reflactory  = 10;       % ms for MEP

th_value    = str2double(get(gsobj.handles.threshold,'String'));
th_direction    = get(gsobj.handles.rb_rising,'Value');

YData       = gsobj.unit.Data;
XData       = gsobj.unit.XData;
SampleRate  = gsobj.unit.SampleRate;
dt          = gsobj.unit.dt;
nData       = length(YData);

WindowIndex = round((Window/1000) * SampleRate);
ReflactoryIndex = max(round((Reflactory/1000) * SampleRate),1);

% timestamps  = [];
jj  = 0;
ii          = max((1 - WindowIndex(1)),2);
maxIndex    = nData - WindowIndex(2);

if(th_direction == 1)   % rising threshold
    while(ii<= maxIndex)
        if((YData(ii-1) < th_value) & (YData(ii) >= th_value))
            jj  = jj + 1;
            timestamps(jj)  = ii;
            ii  = ii + ReflactoryIndex;
        else
            ii  = ii + 1;
        end
    end
else                    % falling threshold
    while(ii<= maxIndex)
        if((YData(ii-1) > th_value) & (YData(ii) <= th_value))
            jj  = jj + 1;
            timestamps(jj)  = ii;
            ii  = ii + ReflactoryIndex;
        else
            ii  = ii + 1;
        end
    end
end

addflag     = logical(ones(size(timestamps)))';

gsobj.spike.SampleRate  = SampleRate;
gsobj.spike.Data        = timestamps;
gsobj.spike.addflag     = addflag;
gsobj.spike.XData       = XData;
gsobj.scope.Window      = Window;
gsobj.scope.Reflactory    = Reflactory;

% gsobj.spike.scope.XData         = [WindowIndex(1):WindowIndex(end)] * dt;







    
