function inaxeshandle   = isinaxes(fig)
haxes   = findobj(opt.fig,'Type','axes');
if isempty(haxes)
    return;
end
naxes   = length(haxes);

% get currentpoints in fig
Units   = get(FigureID, 'Units');
set(FigureID, 'Units', 'points');
MousePosition   = get(FigureID, 'CurrentPoint');
x       = MousePosition(1);
y       = MousePosition(2);
set(FigureID, 'Units', Units);

% test currentpoints is in axes
for ii=1:naxes
    Units   = get(haxes(ii),'Units');
    set(haxes(ii), 'Units', 'points');
    axesPosition   = get(haxes(ii),'Position');
    set(haxes(ii), 'Units', Units);
    isin(ii)    = (x >= axesPosition(1)) && (x <= axesPosition(1) + axesPosition(3)) && (y >= axesPosition(2)) && (y <= axesPosition(2) + axesPosition(4));
end

inaxeshandles   =haxes(logical(isin));
