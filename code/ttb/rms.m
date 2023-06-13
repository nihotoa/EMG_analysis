function y  = rms(x,dim,c)
% y  = rms(x)
% y  = rms(x,dim)
% y  = rms(x,dim,c)

error(nargchk(1,3,nargin,'struct'))
if(nargin<2)
    c   = 0;
    dim = [];
elseif(nargin<3)
    c   = 0;
end

if(isempty(dim))
   dim  = leastdim(x); 
end

if(nargin<2)
    y   = sqrt(mean((x-c).^2));
else
    y   = sqrt(mean((x-c).^2,dim));
end
end
    
function ind    =leastdim(x)

dims    = size(x);

ind     = find(dims>1,1,'first');
end