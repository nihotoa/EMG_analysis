function y  = nancircmean(x,DIM)

if(nargin==1)

    Y   = nanmean(sin(x));
    X   = nanmean(cos(x));

    y   = atan2(Y,X);
else
    Y   = nanmean(sin(x),DIM);
    X   = nanmean(cos(x),DIM);

    y   = atan2(Y,X);

end