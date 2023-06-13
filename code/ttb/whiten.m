function y  = whiten(x)

y   = fft(x);
y   = y ./ abs(y);
y   = ifft(y);