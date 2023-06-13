function [X,timeVec,freqVec] = cgt(x,freqVec,Fs,sigma);
%   function [wcoh,timeVec,freqVec] = trace2wcoh(S1,S2,freqVec,Fs,sigma);
%   Calculates the average of a time-frequency energy representation of
%   multiple trials using a complex Gabor wavelet.                            
%  
%   Input
%   -----
%   x    : signal
%   freqVec    : frequencies vector        
%   Fs   : sampling frequency
%   
%  
%   Output
%   ------
%   X    : complex Gabor transformation (freq x time)
%   timeVec : time
%   freqVec : frequency
%   
%  
% 
%  Refference : Baker MR, Baker SN "The effect of diazepam on motor cortical oscillations and corticomuscular coherence studied in man."
%  J Physiol (2003) 546, pp 931-42


nTime   = length(x);
nFreq   = length(freqVec);
timeVec = (0:nTime-1)*(1/Fs);
X       = zeros(nFreq,nTime);

for ii=1:nFreq
    f   = freqVec(ii);
    w   = cgabor(timeVec,f,sigma);
    tempcoh     = conv(x,w(end:-1:1));
    X(ii,:)  = tempcoh(nTime:end-nTime+1);
end



function [w,T]  = cgabor(t,f,sigma)
% function [w,T]  = gabor(t,f,sigma)
% Calculates the complex gabor wavelet function on specific Frequency              
% t   : time Vector
% f   : frequency of interest (scalar)
% sigma   : scalar
% 
% w   : complex gabor wavelet
T   =[-t(end:-1:2),t];

w   = exp((2*pi.*f*T*i) - (T.^2) / (2*(sigma^2)));