function Y  = getTimeLabel(S,Name)

if(isfield(S,'TimeLabels'))
    ind     = strcmp({S.TimeLabels(:).Name},Name);
    if(sum(ind)>0)
        Y   = [S.TimeLabels(ind).Time];
    else
        Y   = [];
    end
else
    Y   = [];
end
    