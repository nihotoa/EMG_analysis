function gofront(h)
% function gofront(h)


if(nargin<1)
    h   =gco;
end

Parent	= get(h,'Parent');
Child   = get(Parent,'Children');

ind     = find(Child==h);
Child(ind)  = [];

Child   = [h;Child];

set(Parent,'Children',Child)
end