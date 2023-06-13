function [w,T]  = cgabor(t,f,sigma)
% function [w,T]  = gabor(t,f,sigma)
% Calculates the complex gabor wavelet function on specific Frequency              
% t   : time Vector
% f   : frequency of interest (scalar)
% sigma   : scalar
% 
% w   : complex gabor wavelet
T   =[-t(end:-1:2),t];

w   = exp((2*pi.*f*T*i) - (T.^2) / (2*(sigma^2)));