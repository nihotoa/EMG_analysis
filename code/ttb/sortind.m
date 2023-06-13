function x  = sortind(x,order,varargin)

if nargin<1
[temp,index]    = sort(order);
else
    [temp,index]    = sort(order,varargin{:});
end

x   = x(index);