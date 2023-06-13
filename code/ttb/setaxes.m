function h  = setaxes(varargin)

h   = findobj(get(gcf,'Children'),'Type','Axes');

if nargin>0
set(h,varargin{:})
end