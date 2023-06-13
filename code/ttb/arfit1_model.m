% ar_model.m
%
%  ÅÉÅ@AR_model identification  ÅÑ
%
Fs = 200;   T = 1;   N = Fs*T;
t = (0:1/Fs:T-1/Fs);
rn = 0.02*randn(size(t));
%
% ----------------------signal---------------------------
x = sin(2*pi*2*t) + sin(2*pi*10*t) + sin(2*pi*25*t) + rn;
% -------------FFT spectrum (Welch's method)-------------
[Pxx,f] = psd(x,256,Fs,hanning(256),128,'none'); 
% -------------------------------------------------------
%
%  AR model estimation 
%
M = 10;                                  % order of AR model
% [a,e] = aryule(x,M);                    % Yule-Walker method
[a,e] = armcov(x,M);                    % covariance method
[w,A,C,SBC,FPE,th]  = arfit(x',1,50,'fpe');
Marfit  = size(A,2);

% [a,e] = arburg(x,M);                  % Burg method
% [af,f]  = freqz(1,a,N/2,Fs);
Pxx_ar = e*abs(freqz(1,a,N/2,Fs)).^2;   % spectrum (AR model)


% acoef       = [1,-A];
% bcoef       = zeros(size(acoef));
% bcoef(1)    = 1;
% 
% [Hf,F]  = freqz(bcoef,acoef,N/2,Fs);                 % HfÇÕì`íBä÷êî
temp    = fft([1,-A],N);
Af      = temp(1:N/2);
Hf      = 1./Af;
F       = freqz_freqvec(N/2, Fs, 2);

Pxx_arfit = C*((Hf).*conj(Hf));   % spectrum (AR model)
% Pxx_arfit = C*((Af).*conj(Af));   % spectrum (AR model)
f_ar = (0:1/T:Fs/2-1/T);
%
subplot(311);plot(f,10*log10(Pxx),'-b',f_ar,10*log10(Pxx_ar),':r',F',10*log10(Pxx_arfit),':g');
legend('Pxx (FFT spectrum)','Pxx (AR spectrum)','Pxx (ARfit spectrum)')
ylabel('Magnitude (dB)'); xlabel('Frequency (Hz)');title(['Popt = ',num2str(Marfit)])
%
%  prediction by the AR model

y = zeros(1,N);
a(1) = [];
for I=M+1:N
   for J=1:M
      y(I)=y(I)-a(J)*x(I-J);
   end
end
yarfit = zeros(1,N);
for I=Marfit+1:N
   for J=1:Marfit
      yarfit(I)=yarfit(I)+A(J)*x(I-J);
   end
end


% ------------------------------

xestarfit=yarfit(Marfit+1:N);
xest = y(M+1:N);
tarfit  = t(Marfit+1:N);
xarfit  = x(Marfit+1:N);
t(1:M) = [];
x(1:M) = [];
subplot(312);plot(t,x,'-b',t,xest,':r',tarfit,xestarfit,':g');ylabel('Amplitude')
axis([0,T,-3,3]);legend('x (obserbed)','x (predicted)')
x-subplot(313);plot(t,x-xest,'-r',tarfit,xarfit-xestarfit,':g');
axis([0,T,-0.5,0.5]);legend('x-xest','x-xest')
ylabel('Prediction Error'); xlabel('Time (sec)');
% --------------------------------------------------------
%                                  2001.7.09  by K.Tsukada