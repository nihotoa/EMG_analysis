function [wpow,timeVec,freqVec] = trace2wpow(S,freqVec,Fs,sigma);
 
%   function [wcoh,timeVec,freqVec] = trace2wcoh(S1,S2,freqVec,Fs,sigma);
%   Calculates the average of a time-frequency energy representation of
%   multiple trials using a complex Gabor wavelet.                            
%  
%   Input
%   -----
%   S    : signals = Trials x time
%   freqVec    : frequencies        
%   Fs   : sampling frequency
%   
%  
%   Output
%   ------
%   xpow    : wavelet power (freq x time)
%   timeVec : time
%   freqVec : frequency
%   
%  To visualize 'pcolor(timeVec,freqVec,wpow)'
% 
%  Refference : Baker MR, Baker SN "The effect of diazepam on motor cortical oscillations and corticomuscular coherence studied in man."
%  J Physiol (2003) 546, pp 931-42


[nTrials,nTime] = size(S);
nFreq   = length(freqVec);
timeVec = (0:nTime-1)*(1/Fs);
X       = zeros(nTrials,nFreq,nTime);

for ii=1:nTrials
    X(ii,:,:)    = cgt(S(ii,:),freqVec,Fs,sigma);
end
keyboard
wpow    = squeeze(mean(X .* conj(X),1));


function w  = gabor(t,f,sigma)
% function w  = gabor(t,f,sigma)
% Calculates the complex gabor wavelet function on specific Frequency              
% t   : time Vector
% f   : frequency of interest (scalar)
% sigma   : scalar
% 
% w   : complex gabor wavelet


w   = exp((2*pi.*f*t*i) - (t.^2) / (2*(sigma^2)));