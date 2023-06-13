function p  = evansp(c,N)
% 2003 Evans and Baker

p   = (1 - N)*power((1 - c),N-2);
% p   = power((1-N)*(1-c),N-2);