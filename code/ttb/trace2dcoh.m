function [dcoh12,dcoh21,dcoh11,dcoh22,freqVec,phi12,phi21,phi11,phi22,mHf,mSf,ar_order]  = trace2dcoh(data1, data2, Fs, ar_order,nfftPoints,DC_method)

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
%     [dcoh,phi]    = dcoh(Hf,Sf,F,opt)
%     Input
%      Hf     Transfer function matrix depending on frequency made by dtransf
%             (ex) Hf(1,2,:) indicates transfer function of signal 2 => signal 1. (see ref.[2] eq.(5))
%      Sf     Cross-spectral density matrix depending on frequency  made by dtransf
%             (ex) Sf(1,2,:) indicates Cross-spectrum between signal 1 and  signal 2. (see ref.[2] eq.(1))
%      F      Frequency vector specifying the frequcency of Hf and Sf.
%      opt    normalization method; 'Kaminski', 'Baker' or 'none'
% 
%     Output
%      dcoh,phi   
%
% References
% [1] Kamiski MJ, Blinowska KJ "A new method of the description of the information flow in the brain structures." Biol Cybern  1991-v65-pp203-10  
% [2] Baccal LA, Sameshima K "Partial directed coherence: a new concept in neural structure determination." Biol Cybern  2001-v84-pp463-74  
% [3] Baker SN, Chiu M, Fetz EE "Afferent encoding of central oscillations in the monkey arm." J Neurophysiol  2006-v95-pp3904-10 

% DC_method   = 'Baker';

nTrials = size(data1,1);

% preWhiten
% data1   = whiten(data1')';
% data2   = whiten(data2')';

% íºê¸ê¨ï™ÇÃèúãé
data1   = detrend(data1','constant')';
data2   = detrend(data2','constant')';

for ii=1:nTrials
    [Hf(ii,:,:,:), Sf(ii,:,:,:), freqVec, ar_order] = dtransf([data1(ii,:)',data2(ii,:)'],ar_order,nfftPoints,Fs,'fpe');
end
mHf = squeeze(nanmean(Hf,1));
mSf = squeeze(nanmean(Sf,1));

[DC,phi]    = dcoh(mHf,mSf,freqVec,DC_method);


dcoh11      = shiftdim(DC(1,1,:))';
dcoh12      = shiftdim(DC(1,2,:))';
dcoh21      = shiftdim(DC(2,1,:))';
dcoh22      = shiftdim(DC(2,2,:))';
dcoh11(1)   = 0;
dcoh12(1)   = 0;
dcoh21(1)   = 0;
dcoh22(1)   = 0;

phi11      = shiftdim(phi(1,1,:))';
phi12      = shiftdim(phi(1,2,:))';
phi21      = shiftdim(phi(2,1,:))';
phi22      = shiftdim(phi(2,2,:))';
