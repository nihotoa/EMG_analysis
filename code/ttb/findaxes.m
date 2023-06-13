function H = findaxes(fig)

if(nargin<1)
    fig = gcf;
end

h = findobj(get(fig,'Children'),'Type','Axes');


if(nargout>0)
    H   = h;
end