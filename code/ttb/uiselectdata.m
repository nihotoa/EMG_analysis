function [pointslist, xselect, yselect, hc, hAx] = uiselectdata(varargin)

hAx = uiSelectAxis;

ind = [];

for iargin=1:nargin
    if(ischar(varargin{iargin}))
        if(strmatch(lower(varargin{iargin}),'axes'))
            ind = iargin;
        end
    end
end
if(~isempty(ind))
    varargin{iargin+1}  = hAx;
else
    varargin    = {varargin{:},'Axes',hAx};
end
set(hAx,'selected','on')
[pointslist,xselect,yselect,hc] = selectdata(varargin{:});

set(hAx,'selected','off')