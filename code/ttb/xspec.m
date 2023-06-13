function [f11,f22,f21,freq] = xspec(x1,x2,nfft,fs)
% [f11,f22,f21] = xspec(x1,x2,nfft)
% x1  reference data ex LFP
% x2  target data ex EMG
% nfft    fft points
% 重複を除くためには、f11,f22,f21,freqの1:(nfft/2-1)のみを使う。

x1  = x1';
x2  = x2';

x1  = detrend(x1,'constant');
x2  = detrend(x2,'constant');

d1 = fft(x1,nfft,1);                 % DFT across columns/segments ch 1, PBMB (4.1) or (4.2).
d2 = fft(x2,nfft,1);                 % DFT across columns/segments ch 2, PBMB (4.1) or (4.2).	

 
f11 = mean(real(d1 .* conj(d1)), 2);     % Spectrum 1, PBMB (5.2), NB Mag squared for auto spectra.
f22 = mean(real(d2 .* conj(d2)), 2);;    % Spectrum 2, PBMB (5.2), NB Mag squared for auto spectra.

f21 = mean((d2 .* conj(d1)), 2);        % Cross spectrum (complex valued),PBMB (5.2).    
                                        % NB 1/L included in mean() function.

f11 = f11';
f22 = f22';
f21 = f21';

freq    = freqz_freqvec(nfft,fs,1);