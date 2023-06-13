function [y,t]  = cosf(N,fs,Hz);
%[y,t]  = cosf(N,fs,Hz);
% N   number of data points
% fs  sampling frequency
% Hz  signal frequency
% 
% y   data
% t   time

deltaT  = 1 / fs;
t       = [0 : N-1] * deltaT;
y       = cos(2 * pi * Hz * t);

