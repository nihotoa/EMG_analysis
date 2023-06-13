function x  = expdesign(n)
% x = expdesign(n)
%
% zŠÂ–@‚ÅnğŒ‚ÌÀŒ±‡˜‚ğŒˆ‚ß‚é
% 
% ex)
% 
% cond    = randperm(6);
% ind     = expdesign(6);
% 
% cond(ind)
% 
% written by tomohiko takei 

x1  = [[1:n,0];[0,n:-1:1]];
x1  = reshape(x1,1,(n+1)*2);
x1  = x1(1:(n+1));
x1  = x1(x1>0);

x   = repmat((1:n)'-1,1,n);
x   = x+repmat(x1,n,1);

x   = mod(x-1,n) + 1;