function [f,cl] = tcoh(d1,d2,samp_rate)

% parsing 
if(~all(size(d1)==size(d2)))
    error('data size must be same')
    return;
end
% d1  = d1';
% d2  = d2';
[seg_tot,seg_size]  = size(d1);

% íºê¸ê¨ï™ÇÃèúãé
d1   = detrend(d1','constant')';
d2   = detrend(d2','constant')';

% hanningëãÇÃìKóp
% keyboard
winf = hanning(seg_size);
d1   = repmat(winf',seg_tot,1).*d1;
d2   = repmat(winf',seg_tot,1).*d2;


dfreq   = samp_rate / seg_size;    % Frequency resolution - spacing of Fourier frequencies in Hz.
freq    = ([1:(seg_size / 2)] - 1) * dfreq;

F1  = fft(d1,seg_size,2);          % fourier transform
F2  = fft(d2,seg_size,2);
F1  = F1(:,1:(seg_size / 2));    % one-side spectrum
F2  = F2(:,1:(seg_size / 2));

X21 = squeeze(mean((F2 .* conj(F1)), 1));        % cross power spectrum
X11 = squeeze(mean((F1 .* conj(F1)), 1));        % Auto power spectrum
X22 = squeeze(mean((F2 .* conj(F2)), 1));        % Auto power spectrum
% keyboard
coh = (abs(X21).^2) ./ ((X11).* (X22));
phi = angle(X21);

PSD11	= X11 * 2 / (seg_size ^ 2);     % Power spectrum density in V^2
PSD22	= X22 * 2 / (seg_size ^ 2);     % Reference: Witham and Baker (2007) eq.(1)

f.freq      = freq;
f.PSD11     = PSD11;
f.PSD22     = PSD22;
f.coh       = coh;
f.phi21     = phi;
f.phi11     = squeeze(mean(angle(F1),1));
f.phi22     = squeeze(mean(angle(F2),1));

cl.seg_size = seg_size;
cl.seg_tot  = seg_tot;
cl.samp_tot = seg_size * seg_tot;
cl.samp_rate    = samp_rate;
cl.df       = dfreq;
cl.ch_c95   = 1 - 0.05^(1 / (seg_tot - 1));
% keyboard