function y = compvec(f,s,Fs,width)
% function y = compvec(f,s,Fs,width)
%
% Return a vector containing the complex representation as a
% function of time for frequency f. The energy
% is calculated using Morlet's wavelets. 
% s : signal
% Fs: sampling frequency

%
% 

dt = 1/Fs;
sf = f/width;
st = 1/(2*pi*sf);

t=-3.5*st:dt:3.5*st;
m = morlet(f,t,width);
y = conv(s,m);
y = y(ceil(length(m)/2):length(y)-floor(length(m)/2));

