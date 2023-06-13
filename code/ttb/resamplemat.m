function s  = resamplemat(s,sr)

if(isfield(s,'Data'))
    if(s.SampleRate > sr)   % downsample
        dind    = ceil(s.SampleRate/sr);
        sr      = s.SampleRate./dind;

        s.Data  = resample(s.Data,1,dind,ones(1,dind)/dind);
        s.SampleRate    = sr;

    elseif(s.SampleRate < sr)   % upsample
        TotalTime   = s.TimeRange(2) - s.TimeRange(1);
        XData   = linspace(0,TotalTime,TotalTime*s.SampleRate+1);
        XData(end)  = [];
        XDatai  = linspace(0,TotalTime,TotalTime*sr+1);
        XDatai(end)  = [];
        s.Data  = interp1(XData,s.Data,XDatai,'*spline');
        s.SampleRate    = sr;
        
       
    end
elseif(isfield(s,'YData'))
    if(s.SampleRate > sr)   % downsample
        dind    = ceil(s.SampleRate/sr);
        sr      = s.SampleRate./dind;

        s.YData  = resample(s.YData,1,dind,ones(1,dind)/dind);
        s.SampleRate    = sr;
        s.XData  = ([1:length(s.YData)]-1)/s.SampleRate;

    elseif(s.SampleRate < sr)   % upsample
        TotalTime   = s.TimeRange(2) - s.TimeRange(1);
        XDatai      = linspace(s.TimeRange(1),s.TimeRange(2),TotalTime*sr+1);
        XDatai(end) = [];
        s.YData     = interp1(s.XData,s.YData,XDatai,'*spline');
        s.SampleRate    = sr;
        s.XData     = XDatai;

    end
end
