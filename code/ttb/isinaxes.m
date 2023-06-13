function inaxeshandle   = isinaxes(fig)
inaxeshandle   = [];
haxes   = findobj(fig,'Type','axes');
if isempty(haxes)
    return;
end
naxes   = length(haxes);

% get currentpoints in fig
Units   = get(fig, 'Units');
set(fig, 'Units', 'points');
MousePosition   = get(fig, 'CurrentPoint');
set(fig, 'Units', Units);
x       = MousePosition(1);
y       = MousePosition(2);

% test currentpoints is in axes
for ii=1:naxes
    Units   = get(haxes(ii),'Units');
    set(haxes(ii), 'Units', 'points');
    axesPosition   = get(haxes(ii),'Position');
    set(haxes(ii), 'Units', Units);
    isin(ii)    = (x >= axesPosition(1)) && (x <= axesPosition(1) + axesPosition(3)) && (y >= axesPosition(2)) && (y <= axesPosition(2) + axesPosition(4));
end

inaxeshandle   =haxes(logical(isin))';