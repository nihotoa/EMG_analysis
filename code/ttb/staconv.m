function S  = staconv(name,TS,STA,psename)

S.TimeRange = TS.TimeRange;
S.Name      = name;
S.Class     = 'continuous channel';
S.TargetName    = STA.Name;
S.ReferenceName = TS.Name;
S.AnalysisType  = 'STACONV';
S.SampleRate    = STA.SampleRate;
S.pseName   = psename;
S.Data      = [];

if(isfield(STA,'Unit'))
    S.Unit      = STA.Unit;
else
    S.Unit  = [];
end
maxsigpeakindTW = STA.(psename).maxsigpeakindTW;

if(isfield(STA.(psename),'baseline'))
    baseline    = STA.(psename).baseline;
elseif(isfield(STA,'ISAData'))
    baseline    = STA.ISAData;
else
    baseline    = zeros(size(STA.YData));
end
kernel  = STA.YData - baseline;
kernel  = kernel - mean(kernel(STA.(psename).base.ind));
kernel  = zeromask(kernel,STA.(psename).peaks(maxsigpeakindTW).ind);
kernel  = zerocenter(kernel,STA.XData);

TS.Data = round((TS.Data * STA.SampleRate) / TS.SampleRate);
S.Data  = zeros(1,(S.TimeRange(2)-S.TimeRange(1))*S.SampleRate);
S.Data(TS.Data) = 1;
S.Data  = conv2(S.Data,kernel,'same');

% [YY,YY_data]    = psth(Tar, Ref, [TimeWindow(1)-5*SDF_sigma TimeWindow(2)+5*SDF_sigma], bw, []);
end

function [Y,X] = zerocenter(y,x)
    [y,nshift_y]  = shiftdim(y);
    [x,nshift_x]  = shiftdim(x);
    nx  = length(x);
    ny  = length(y);
    d       = x(2) - x(1);
    
    if(x(1) > 0)
        X   = [-x:d:x(end)]';
        
    elseif(x(end) < 0)
        X   = [x(1):d:-x(1)]';
    else
        X   = [-max(abs(x([1,end]))):d:max(abs(x([1,end])))]';
    end
    
    Y   = zeros(size(X));
    [temp,ind]  = nearest(X,x(1));
    Y(ind:ind+ny-1) = y;
    
    
    Y   = shiftdim(Y,nshift_y);
    X   = shiftdim(X,-nshift_x);    
    

end