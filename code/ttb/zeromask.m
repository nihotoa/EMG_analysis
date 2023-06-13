function y  = zeromask(x,mask)

warning('off')
% y       = x .* mask;
x(~mask)    = 0;
y   = x;
warning('on')