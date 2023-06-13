function [coh,freqVec,PSD11,PSD22,X11,X22,X21,phi21] = trace2coh(S1,S2,Fs)

% [coh,freqVec,PSD11,PSD22,X11,X22,X21,phi21] = trace2coh(S1,S2,Fs)
% 
% Input:  
% S1,S2   Data(m [segments] x n [data length]).
% Fs      Sampling Frequency
% 
% Output:
% coh     coherence
% freqVec correcponding frequency vector
% PSD11,PSD22 Power spectrum density in V^2 (Reference: Witham and Baker (2007) eq.(1))
% X11,X22 Auto power spectrum
% X21     cross power spectrum
% phi21   phase difference

% written by Tomohiko Takei


% parsing 
if(~all(size(S1)==size(S2)))
    error('data size must be same')
end

[seg_tot,seg_size]  = size(S1);

% íºê¸ê¨ï™ÇÃèúãé
S1   = detrend(S1','constant')';
S2   = detrend(S2','constant')';

% hanningëãÇÃìKóp
winf = hanning(seg_size);
S1   = repmat(winf',seg_tot,1).*S1;
S2   = repmat(winf',seg_tot,1).*S2;


dfreq   = Fs / seg_size;    % Frequency resolution - spacing of Fourier frequencies in Hz.
freqVec    = ([1:(seg_size / 2)] - 1) * dfreq;

F1  = fft(S1,seg_size,2);          % fourier transform
F2  = fft(S2,seg_size,2);
F1  = F1(:,1:(seg_size / 2));    % one-side spectrum
F2  = F2(:,1:(seg_size / 2));

X21 = squeeze(mean((F2 .* conj(F1)), 1));        % cross power spectrum
X11 = squeeze(mean((F1 .* conj(F1)), 1));        % Auto power spectrum
X22 = squeeze(mean((F2 .* conj(F2)), 1));        % Auto power spectrum
% keyboard
coh = (abs(X21).^2) ./ ((X11).* (X22));
phi21 = angle(X21);

PSD11	= X11 * 2 / (seg_size ^ 2);     % Power spectrum density in V^2
PSD22	= X22 * 2 / (seg_size ^ 2);     % Reference: Witham and Baker (2007) eq.(1)

% phi11     = squeeze(mean(angle(F1),1));
% phi22     = squeeze(mean(angle(F2),1));

% cl.seg_size = seg_size;
% cl.seg_tot  = seg_tot;
% cl.samp_tot = seg_size * seg_tot;
% cl.Fs    = Fs;
% cl.df       = dfreq;
% cl.ch_c95   = 1 - 0.05^(1 / (seg_tot - 1));
% % keyboard


