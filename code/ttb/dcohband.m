function [coh, phase, F] = dcohband(x,P,nfft,Fs,armethod,dcohmethod)
% x   data arranged in columns
% P   ar model order
% nfft    fft points to calculate the transfer functions
% Fs  Sampling rate (Hz)
% armethod    [sbc] or fpe
% dcohmethod  nomalization method for directed coherence 'Kaminski' or 'Baker'
% 
% written by TT 070226

if(nargin < 5)
    armethod    = 'sbc';
    dcohmethod  = 'b';
elseif(nargin < 6)
    dcohmethod  = 'b';
end


[w,A,C,SBC,FPE,th]  = arfit(x,P,P,'sbc','zero');
P               = size(A,2)/size(A,1);
% disp(['AR order =',num2str(P)])
[Hf,Sf,F]       = artf(A,C,nfft,Fs);
[coh,phase]     = dcoh(Hf,Sf,F,dcohmethod);

