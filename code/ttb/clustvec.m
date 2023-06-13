function y  = clustvec(x,kk,nn,mask,intrp)
% function y  = clustvec(x,kk,nn,mask,intrp)

if nargin<4
    mask    = ones(size(x));
    intrp   = zeros(size(x));
end

y   = false(size(x));

x       = logical(x);
mask    = logical(mask);
intrp   = logical(intrp);

mx  = (x & mask);
ix  = mx; ix(intrp)	= [];
ind = [1:length(x)]; ind(intrp) =[];

iy  = findcont(ix,kk,nn);
y(ind(iy))  = ones(1,sum(iy));

if(sum(intrp)~=0)
    if(y(find(intrp==1,1,'first')-1)==1 && y(find(intrp==1,1,'last')+1)==1)
        y(intrp)    = ones(1,sum(intrp));
    else
        y(intrp)    = zeros(1,sum(intrp));
    end
end