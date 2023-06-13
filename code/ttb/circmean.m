function y  = circmean(x,DIM)

if(nargin==1)

    Y   = mean(sin(x));
    X   = mean(cos(x));

    y   = atan2(Y,X);
else
    Y   = mean(sin(x),DIM);
    X   = mean(cos(x),DIM);

    y   = atan2(Y,X);

end