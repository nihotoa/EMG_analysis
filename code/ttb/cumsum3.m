function x = cumsum3(x)

[x,nshift]  = shiftdim(x);

x   = cumsum(x);    % 1st
x   = cumsum(x);    % 2nd
x   = cumsum(x);    % 3rd


x   = shiftdim(x,nshift);