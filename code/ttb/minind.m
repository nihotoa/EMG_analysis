function ind    = minind(x,varargin)

if(~isempty(varargin))
    [y,ind] = min(x,varargin{:});
else
    [y,ind] = min(x);
end