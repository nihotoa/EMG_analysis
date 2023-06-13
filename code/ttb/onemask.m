function y  = onemask(x,mask)

warning('off')
% y       = x .* mask;
x(~mask)    = 1;
y   = x;
warning('on')