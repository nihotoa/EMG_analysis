function [YData,XData,BaseLine,BaseMean,BaseSD,YUnit]    = pseadjust(S,psename,method)

if(nargin < 3)
    method  = '%';
end

if(isfield(S,psename))
    PSES    = S.(psename);
    if(~isfield(PSES,'BaseLine'))
        BaseLine    = S.ISAData;
        BaseLine    = BaseLine+mean(S.YData(PSES.base.ind)-BaseLine(PSES.base.ind));
    else
        BaseLine    = PSES.BaseLine;
    end
    
    YData   = S.YData - BaseLine + PSES.base.mean;
    BaseLine    = ones(size(YData))*PSES.base.mean;
    
    
    XData   = S.XData;
    
    
    switch method
        case '%'
            YData       = YData ./ PSES.base.mean *100;
            BaseLine    = BaseLine ./ PSES.base.mean *100;
            BaseSD      = PSES.base.sd ./ PSES.base.mean *100;
            BaseMean    = PSES.base.mean ./ PSES.base.mean *100;
            YUnit       = '%';
        case 'sd'
            YData       = (YData - PSES.base.mean) ./ PSES.base.sd;
            BaseLine    = BaseLine - PSES.base.mean;
            BaseSD      = PSES.base.sd ./ PSES.base.sd;
            BaseMean    = PSES.base.mean - PSES.base.mean;
            YUnit       = 'sd';
    end
    
else
    XData   = S.XData;
    YData   = nan(size(XData));
    BaseLine    = nan(size(XData));
    BaseMean    = nan;
    BaseSD      = nan;
    
    switch method
        case '%'
            YUnit       = '%';
        case 'sd'
            YUnit       = 'sd';
    end
end