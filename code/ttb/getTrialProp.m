function [TrialProp,h] = getTrialProp(hAx,Color)
if(nargin<1)
    hAx     = gca;
    Color   = 'r';
elseif(nargin<2)
    Color   = 'r';
end
% axes(hAx)
[pl,xs,ys,h,hAx]    = uiselectdata('SelectionMode','Rect','FlagColor',Color);

if(~isempty(pl))
    if(iscell(pl))
        ind             =~cellfun(@isempty,pl);
    else
        ind         = 1;
    end
    h               = h(ind);

    TrialProp   = get(h,'UserData');
    if(iscell(TrialProp))
        TrialProp   = [TrialProp{:}];
    end
else
    TrialProp   = [];
    h           = [];
end





