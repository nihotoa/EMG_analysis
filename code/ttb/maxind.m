function ind    = maxind(x,varargin)

if(nargin<2)
    [y,ind] = max(x);
else
    [y,ind] = max(x,varargin{:});
end