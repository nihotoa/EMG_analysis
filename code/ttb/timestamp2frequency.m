function [YData,XData]  = timestamp2frequency(TimeStamp)


if(~iscell(TimeStamp))
    
    if(length(TimeStamp)>=1)
        XData   = TimeStamp;
        YData   = [nan 1./diff(XData)];
    else
        XData   = [];
        YData   = [];
    end
    
else
    
    nTrials = length(TimeStamp);
    YData   = cell(nTrials,1);
    XData   = cell(nTrials,1);
    
    for iTrial=1:nTrials
        TimeStamp2   = TimeStamp{iTrial};
        
        if(length(TimeStamp2)>=1)
            XData{iTrial}   = TimeStamp2;
            YData{iTrial}   = [nan 1./diff(XData{iTrial})];
        else
            XData{iTrial}   = [];
            YData{iTrial}   = [];
        end
    end
end