function [Y,hAx]  = uimean(name)

if(nargin<1)
    name    = [];
end

Color   = 'r';

[pl,XData,YData,hc,hAx]    = uiselectdata('SelectionMode','Rect','FlagColor',Color);

Y.X         = [];
Y.Y         = [];
Y.maxX_X    = [];
Y.maxX_Y    = [];
Y.minX_X    = [];
Y.minX_Y    = [];
Y.maxY_X    = [];
Y.maxY_Y    = [];
Y.minY_X    = [];
Y.minY_Y    = [];
Y.meanX     = [];
Y.stdX      = [];
Y.meanY     = [];
Y.stdY      = [];



if(~isempty(pl))
    if(iscell(pl))
        XData   = cat(1,XData{:});
        YData   = cat(1,YData{:});
    end
    XY              = [XData,YData];
    XY              = sortrows(XY,1);
    Y.XY            = XY;
    Y.X             = XY(:,1);
    Y.Y             = XY(:,2);
    
    [Y.maxX_X,ind]  = max(XData);
    Y.maxX_Y        = YData(ind);
    [Y.minX_X,ind]  = min(XData);
    Y.minX_Y        = YData(ind);

    [Y.maxY_Y,ind]  = max(YData);
    Y.maxY_X        = XData(ind);
    [Y.minY_Y,ind]  = min(YData);
    Y.minY_X        = XData(ind);
    
    Y.meanX         = mean(XData);
    Y.stdX          = std(XData);
    Y.meanY         = mean(YData);
    Y.stdY          = std(YData);
   
end

if(~isempty(name) && isfield(Y,name))
    Y   = Y.(name);
end