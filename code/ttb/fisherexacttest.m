function [p,P,X]  =fisherexacttest(x)


[nrow,ncol] = size(x);
nitem   = nrow*ncol;

Nrow    = sum(x,2);
Ncol    = sum(x,1);
N       = sum(Nrow);


minmtx  = min(repmat(Nrow,1,ncol),repmat(Ncol,nrow,1));
minmtx  = reshape(minmtx,1,nitem);

nn  = prod(prod(minmtx+1));
cmprod  = cumprod(minmtx+1);  
X   = [];

ii  = 0;
tic;
t0  = toc;
while(ii<=nn)
    res = ii;
    currX   = zeros(1,nrow*ncol);
    for iitem=nitem:-1:2
        currX(iitem)    = floor(res./cmprod(iitem-1));
        res = mod(res,cmprod(iitem-1));
    end
    currX(1)    = res;
    currX       = reshape(currX,nrow,ncol);
    
    if(all(sum(currX,2)==Nrow)&&all(sum(currX,1)==Ncol))
        if(isempty(X))
            X   = currX;
        else
            X   =cat(3,X,currX);
        end
    end
    ii  = ii+1;
    t1  = toc;
    if(t1>t0+5)
        disp([num2str(t1),'[sec] elapsed. ',num2str(ii/nn*100,'%g'),'[%] completed. ', num2str((t1.*(nn-ii))./ii),'[sec] remains.'])
        t0  = t1;
    end
end

nn  = size(X,3);
P   = zeros(nn,1);

A   = prod(factorial(Nrow))*prod(factorial(Ncol));
factN   = factorial(N);


for ii=1:nn
    currX   = X(:,:,ii);
    B   = factN*prod(prod(factorial(currX)));
    P(ii)   = A ./ B;
    
    if(all(currX==x))
        currind = ii;
    end
end

currX   = x;
currP   = P(currind);

p   = sum(P(P<=currP));
