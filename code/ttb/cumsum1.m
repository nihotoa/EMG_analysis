function x = cumsum1(x)

[x,nshift]  = shiftdim(x);

x   = cumsum(x);    % 1st

x   = shiftdim(x,nshift);