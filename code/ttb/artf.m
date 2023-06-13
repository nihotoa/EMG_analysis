function [Hf,Sf,F]    = artf(A,C,nfft,Fs)
% ARTF Calculating transfer functions and cross-spectral density matrix.
%     [Hf,Sf,F]    = artf(A,C,nfft,Fs)
%     Input
%      A      Coefficient matrix of multivariate AR model calculated from ARFIT.
%      C      Covarience matrix of multivariate AR model calculated from ARFIT.
%      nfft   Length of FFT. nfft affect frequency resolutions of estimated values.
%      Fs     Sampling frequency of original signal. When this is specified, F is calculated. 
%         
%     Output
%      Hf     Transfer function matrix depending on frequency.  
%             (ex) Hf(1,2,:) indicates transfer function of signal 2 => signal 1. (see ref.[2] eq.(5))
%      Sf     Cross-spectral density matrix depending on frequency.
%             (ex) Sf(1,2,:) indicates Cross-spectrum between signal 1 and  signal 2. (see ref.[2] eq.(1))
%      F      Frequency vector specifying the frequcency of Hf and Sf. F is output only when output argment Fs is specified
%
% References
% [1] Kamiski MJ, Blinowska KJ "A new method of the description of the information flow in the brain structures." Biol Cybern  1991-v65-pp203-10  
% [2] Baccal LA, Sameshima K "Partial directed coherence: a new concept in neural structure determination." Biol Cybern  2001-v84-pp463-74  
% [3] Baker SN, Chiu M, Fetz EE "Afferent encoding of central oscillations in the monkey arm." J Neurophysiol  2006-v95-pp3904-10 



% reshape AR coefficients into compatible matrix  
k   = size(A,1);            % k-channels
p   = size(A,2) / k;          % AR order

Amatrix     = reshape(A,k,k,p);          % size(Amatrix)  = [k k p]
Amatrix0    = cat(3,eye(k),-Amatrix);   % modify the coefficiences to apply convolution theorem (size(Amatrix0)  = [k k p+1])

Af  = fft(Amatrix0,nfft,3);             % fourier transform of Amatrix0 to apply convolution therem A(f)*X(f)  = E(f)  ...ref.[3] eq.(3)
Af(:,:,ceil(nfft/2)+1:end) = [];              % reduce below Nyquist frequency

for ii=1:ceil(nfft/2)
    Hf(:,:,ii)  = inv(Af(:,:,ii));              % Hf is transfer function ...ref.[1](5), [3](5)
    Sf(:,:,ii)  = Hf(:,:,ii)*C*Hf(:,:,ii)';     % Sf is cross-spectral density matrix ...ref.[1](6), [2](1), [3](7)
end

F       = freqz_freqvec(ceil(nfft/2), Fs, 2);         % frequency domain of function





