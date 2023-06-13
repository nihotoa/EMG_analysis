function goback(h)
% function goback(h)


if(nargin<1)
    h   =gco;
end

Parent	= get(h,'Parent');

if(iscell(Parent))
    Parent  = Parent{1};
end
Child   = get(Parent,'Children');
for ii =1:length(h)
ind     = find(Child==h(ii));
Child(ind)  = [];
end

Child   = [Child;h];

set(Parent,'Children',Child)
end