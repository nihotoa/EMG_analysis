function [Hf, Sf, F, P] = dtransf(x,P,nfft,Fs,armethod)
% x   data arranged in columns
% P   ar model order
% nfft    fft points to calculate the transfer functions
% Fs  Sampling rate (Hz)
% armethod    [sbc] or fpe
%
%      Hf     Transfer function matrix depending on frequency made by dtransf
%             (ex) Hf(1,2,:) indicates transfer function of signal 2 => signal 1. (see ref.[2] eq.(5))
%      Sf     Cross-spectral density matrix depending on frequency  made by dtransf
%             (ex) Sf(1,2,:) indicates Cross-spectrum between signal 1 and  signal 2. (see ref.[2] eq.(1))
%      F      Frequency vector specifying the frequcency of Hf and Sf. 
% written by TT 070226

if(nargin < 5)
    armethod    = 'sbc';
end


[w,A,C,SBC,FPE,th]  = arfit(x,P,P,armethod,'zero');

P                   = size(A,2)/size(A,1);
[Hf,Sf,F]           = artf(A,C,nfft,Fs);
