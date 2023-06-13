function [wcoh,timeVec,freqVec,P1,P2,P21,phi21] = trace2wcoh(S1,S2,freqVec,Fs,sigma);
 
%   function [wcoh,timeVec,freqVec,P1,P2,phi12] = trace2wcoh(S1,S2,freqVec,Fs,sigma);
%   Calculates the average of a time-frequency energy representation of
%   multiple trials using a complex Gabor wavelet.                            
%  
%   Input
%   -----
%   S1,S2 	: signals = Trials x time
%   freqVec : frequencies (Hz)        
%   Fs      : sampling frequency (Hz)
%   sigma   : sd of gabor wavelet (sec)
%   
%  
%   Output
%   ------
%   xcoh    : wavelet coherence (freq x time)
%   timeVec : time
%   freqVec : frequency
% 
%   P1,P2   : wavelet power
%   phi12   : coherence phase
%   
%   To visualize 'pcolor(timeVec,freqVec,wcoh),shading flat'
% 
%   Example
% % Two signals (SampleRate:250Hz, Duration:3sec, Trials:100trials) contains time-varing sinusoidal waves (20Hz, 1-2 sec).
% % Wavelet is defined as gabor (sigma:0.128sec).
% 
% % Preparing two signals
% S1          = rand(100,751)+0.1*repmat([zeros(1,250),sin((2*pi)*(1:251)*20/250),zeros(1,250)],100,1);
% S2          = rand(100,751)+0.1*repmat([zeros(1,250),cos((2*pi)*(1:251)*20/250),zeros(1,250)],100,1);
%
% % Setting parameters
% freqVec     = 1.25:1.25:100;    % Hz
% Fs          = 250;              % Hz
% sigma       = 0.128;            % sec
% 
% % Conducting wavelet transformation
% [wcoh,timeVec,freqVec,P1,P2,phi12] = trace2wcoh(S1,S2,freqVec,Fs,sigma);
% 
% % Displaying result.
% pcolor(timeVec,freqVec,wcoh),shading flat
% 
%  Refference : Baker MR, Baker SN "The effect of diazepam on motor cortical oscillations and corticomuscular coherence studied in man."
%  J Physiol (2003) 546, pp 931-42

% parsing
if(~all(size(S1)==size(S2)))
    error('Tkitom:  Data sizes are not same.')
end

[nTrials,nTime] = size(S1);
nFreq   = length(freqVec);
timeVec = (0:nTime-1)*(1/Fs);
X1      = zeros(nFreq,nTime);
X2      = X1;
P1      = X1;
P2      = X1;
P21     = X1;

for ii=1:nTrials
    X1  = cgt(S1(ii,:),freqVec,Fs,sigma);
    X2  = cgt(S2(ii,:),freqVec,Fs,sigma);
    P1	= P1 + (X1 .* conj(X1));
    P2	= P2 + (X2 .* conj(X2));
    P21	= P21 + (X1 .* conj(X2));
    indicator(ii,nTrials)
end

P1  = P1 / nTrials;  % eq.(3)
P2  = P2 / nTrials;  % eq.(3)

P21 = P21 / nTrials;  % eq.(4)
wcoh= (abs(P21).^2) ./ (P1.*P2);        % eq.(4)  0<=　wcoh　<=1にノーマライズするため分母のsqrtをはずした。

phi21   = angle(P21);

indicator(0,0)

function w  = gabor(t,f,sigma)
% function w  = gabor(t,f,sigma)
% Calculates the complex gabor wavelet function on specific Frequency              
% t   : time Vector
% f   : frequency of interest (scalar)
% sigma   : scalar
% 
% w   : complex gabor wavelet


w   = exp((2*pi.*f*t*i) - (t.^2) / (2*(sigma^2)));
