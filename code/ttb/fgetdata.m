function Sout  = fgetdata(expName,channame,fieldname,TimeRange)
if nargin < 3
    timewindow = [0 Inf];
    fieldname    = [];
elseif nargin < 4
    timewindow   = [];
    fieldname    = fieldname;
else
    timewindow   = TimeRange;
    fieldname    = fieldname;
end
if(isempty(timewindow))
    timewindow  = [0 Inf];
end
if(ischar(channame))    % convert channame to cell array
    channame    = {channame};
end
Datapath    = ['c:\MDAdata\mat\',expName,'\'];

for ii=1:length(channame)
    S       = load([Datapath,channame{ii}]);
    switch S.Class
        case 'timestamp channel'
            xData   = S.Data / S.SampleRate;
            S.Data  = S.Data(xData >= timewindow(1) & xData <= timewindow(2));
        case 'continuous channel'
            xData   = ([1:length(S.Data)] - 1) / S.SampleRate;
            S.Data  = S.Data(xData >= timewindow(1) & xData <= timewindow(2));
    end

    if(isempty(fieldname))
        Sout{ii}    = S;
    else
        Sout{ii}    = getfield(S,fieldname);
    end

end