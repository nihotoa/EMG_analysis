function deltawindow
global gsobj

if(isfield(gsobj,'tawindow'))
    gsobj   = rmfield(gsobj,'tawindow');
end