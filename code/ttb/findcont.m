function y  = findcont(x,kk,nn)

[x,nshift]  = shiftdim(x);

x       = [zeros(nn,1);x;zeros(nn,1)];
nx      = length(x);

y   = false(nx,1);
for ii  =1:nx-nn+1
    sind    = ii:(ii+nn-1);
    sx      = x(sind);
    if(sum(double(sx))>=kk && sx(1))
        y(sind) = reversi(sx);
    end
end

y   = y((nn+1):(end-nn));
y   =shiftdim(y,-nshift);

function x  = reversi(x)

 ind1   = find(x,1,'first');
 ind2   = find(x,1,'last');

 x(ind1:ind2)   = true;