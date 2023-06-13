function y  = whiten(x)
[a,e]   = lpc(x);
a       = real(a);
e       = sqrt(e);

y       = filter(a,e,x)
