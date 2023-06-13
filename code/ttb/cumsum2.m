function x = cumsum2(x)

[x,nshift]  = shiftdim(x);

x   = cumsum(x);    % 1st
x   = cumsum(x);    % 2nd

x   = shiftdim(x,nshift);