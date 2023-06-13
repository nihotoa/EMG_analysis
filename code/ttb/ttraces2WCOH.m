function [f,timeVec,freqVec] = traces2WCOH(S1,S2,freqVec,Fs,width,cSmooth);
% function [COH,timeVec,freqVec] = traces2WCOH(S1,S2,freqVec,Fs,width,cSmooth);
%
% Calculates the average of a time-frequency energy representation of
% multiple trials using a Morlet wavelet method.                            
%
% Input
% -----
% S    : signals = time x Trials      
% freqVec    : frequencies over which to calculate TF energy        
% Fs   : sampling frequency
% width: number of cycles in wavelet (> 5 advisable)  
%
% Output
% ------
% t    : time
% f    : frequency
% B    : phase-locking factor = frequency x time
%     
%------------------------------------------------------------------------
% Ole Jensen, Brain Resarch Unit, Low Temperature Laboratory,
% Helsinki University of Technology, 02015 HUT, Finland,
% Report bugs to ojensen@neuro.hut.fi
%------------------------------------------------------------------------

%    Copyright (C) 2000 by Ole Jensen 
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You can find a copy of the GNU General Public License
%    along with this package (4DToolbox); if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


S1 = S1';
S2 = S2'; 
[ntime,ntrace]	= size(S1);
timeVec = (1:ntime)/Fs;
nfreq   = length(freqVec);


f	= zeros(6,nfreq,ntime);

for kk  = 1:ntrace          
    fprintf(1,'%d ',kk); 
    for jj=1:nfreq
            B1(jj,:,kk)	= compvec(freqVec(jj),detrend(S1(:,kk)),Fs,width) / ntime;
            B2(jj,:,kk)	= compvec(freqVec(jj),detrend(S2(:,kk)),Fs,width) / ntime;
    end
end

Cxy	= B1 .* conj(B2);       %abs(Cxy).^2= coscalogram
Cxx	= B1 .* conj(B1);       % wavelet power spectrgram
Cyy	= B2 .* conj(B2);

% nSmooth = floor(Fs*cSmooth/freqVec(j)) ;
% sCxy    = conv(boxcar(nSmooth),Cxy);
% sCxx    = conv(boxcar(nSmooth),Cxx);
% sCyy    = conv(boxcar(nSmooth),Cyy);
% sCxy    = sCxy(ceil(nSmooth/2):length(sCxy)-floor(nSmooth/2));
% sCxx    = sCxx(ceil(nSmooth/2):length(sCxx)-floor(nSmooth/2));
% sCxy    = sCyy(ceil(nSmooth/2):length(sCyy)-floor(nSmooth/2));

COH     = (abs(sCxy).^2)./(sCxx .* sCyy);
Pxy     = angle(Cxy);
Pxx     = angle(B1);
Pyy     = angle(B2);

f(1,:,:)    = mean(Cxx,3);
f(2,:,:)    = mean(Cyy,3);
f(3,:,:)    = mean(COH,3);
f(4,:,:)    = mean(Pxx,3);
f(5,:,:)    = mean(Pyy,3);
f(6,:,:)    = mean(Pxy,3);

function y = compvec(f,s,Fs,width)
% function y = compvec(f,s,Fs,width)
%
% Return a vector containing the complex representation as a
% function of time for frequency f. The energy
% is calculated using Morlet's wavelets. 
% s : signal
% Fs: sampling frequency

%
% 

dt = 1/Fs;
sf = f/width;
st = 1/(2*pi*sf);

t=-3.5*st:dt:3.5*st;
m = morlet(f,t,width);
y = conv(s,m);
y = y(ceil(length(m)/2):length(y)-floor(length(m)/2));



function y = morlet(f,t,width)
% function y = morlet(f,t,width)
% 
% Morlet's wavelet for frequency f and time t. 
% The wavelet will be normalized so the total energy is 1.
% width defines the ``width'' of the wavelet. 
% A value >= 5 is suggested.
%
% Ref: Tallon-Baudry et al., J. Neurosci. 15, 722-734 (1997)
%
% See also: PHASEGRAM, PHASEVEC, WAVEGRAM, ENERGY 
%
% Ole Jensen, August 1998 

sf = f/width;
st = 1/(2*pi*sf);
A = 1/(st*sqrt(2*pi));

y = A*exp(-t.^2/(2*st^2)).*exp(i*2*pi*f.*t);
