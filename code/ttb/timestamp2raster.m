function [YData,XData]   = timestamp2raster(TimeStamp)

if(~iscell(TimeStamp))
    
    nData   = length(TimeStamp);
    XData   = repmat(TimeStamp,3,1);
    XData   = reshape(XData,1,numel(XData));
    
    YData   = repmat([-0.5 0.5 nan],1,nData);
    
else
    
    nTrials = length(TimeStamp);
    YData   = cell(nTrials,1);
    XData   = cell(nTrials,1);
    
    for iTrial=1:nTrials
        TimeStamp2   = TimeStamp{iTrial};
        
        nData   = length(TimeStamp2);
        XData{iTrial}   = repmat(TimeStamp2,3,1);
        XData{iTrial}   = reshape(XData{iTrial},1,numel(XData{iTrial}));
        
        YData{iTrial}   = repmat([-0.5 0.5 nan],1,nData);
    end
end