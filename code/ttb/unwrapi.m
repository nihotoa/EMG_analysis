function y  =unwrapi(x)
% y  =unwrapi(x)
% x��0<=y<2*pi�͈̔͂�unwrap����B

y   = atan2(sin(x),cos(x));

% y   = mod(x,2*pi);