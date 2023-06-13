function y = sigmoidfilt(x,a,threshold,amplitude)

if nargin<2
    a       = 1;
    threshold  = 0;
    amplitude     = 1;
elseif nargin<3
    threshold  = 0;
    amplitude     = 1;
elseif nargin<4
    amplitude     = 1;
end




y   = amplitude .* 1.0 ./ (1.0 + exp(-a*(x-threshold)));

y   = x.*y;
