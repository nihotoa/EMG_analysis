function y  =unwrapi(x)
% y  =unwrapi(x)
% x‚ð0<=y<2*pi‚Ì”ÍˆÍ‚Éunwrap‚·‚éB

y   = atan2(sin(x),cos(x));

% y   = mod(x,2*pi);