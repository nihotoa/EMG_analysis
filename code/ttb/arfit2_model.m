% ar_model.m
%
%  ＜　AR_model identification  ＞
%
clear
Fs = 250;   T = 4;   N = Fs*T; nfft = 256;
t = (0:1/Fs:T-1/Fs);
oscwin  = 50;
% osc = sin(2*pi*25*t(1:oscwin)).*gausswin(oscwin,oscwin/2)';
osc = sin(2*pi*25*t(1:oscwin));
rn1 = 0.02*randn(size(t));
rn2 = 0.02*randn(size(t));
% lag = 0.025; %sec 10Hzの成分はこのlagをおいて、x1からx2へと伝達している。
%
% ----------------------signal---------------------------
% x(:,1) = sin(2*pi*2*t) + sin(2*pi*10*t) + sin(2*pi*25*t) + rn1;
x(:,1) = sin(2*pi*2*t) +[zeros(1,oscwin) osc zeros(1,N-2*oscwin)] + 10*sin(2*pi*60*t)+ rn1;
% x(:,2) = sin(2*pi*2*t) + sin(2*pi*10*(t-lag)) + sin(2*pi*25*t) + rn2;
x(:,2) = sin(2*pi*2*t) +[zeros(1,2*oscwin) osc zeros(1,N-3*oscwin)] + 10*sin(2*pi*60*t)+ rn2;
% -------------FFT spectrum (Welch's method)-------------
[Pxx(1,:),f] = psd(x(:,1),256,Fs,hanning(256),128,'none'); 
[Pxx(2,:),f] = psd(x(:,2),256,Fs,hanning(256),128,'none'); 
% -------------------------------------------------------
%
%  AR model estimation 
%
Mmin = 1;   % order of AR model
Mmax = 100;

[w,A,C,SBC,FPE,th]  = arfit(x,Mmin,Mmax,'fpe','zero');
Mopt = size(A,2)/2;
Amatrix = reshape(A,2,2,Mopt);
% [w2,A2,C2,SBC2,FPE2,th2]  = arfit(x(:,1),Mopt,Mopt,'fpe');

Amatrix0 = cat(3,[1 0;0 1],-Amatrix);

for ii=1:2
    for jj=1:2
        temp        = fft(squeeze(Amatrix0(ii,jj,:)),nfft);
        Af(ii,jj,:) = temp(1:nfft/2);
          
%         acoef       = [1;-squeeze(Amatrix(ii,jj,:))]';
%         bcoef       = zeros(size(acoef));
%         bcoef(1)    = 1;
%         [Af(ii,jj,:),F]  = freqz(bcoef,acoef,N/2,Fs);          % AfはAのフーリエ展開
    end
end
% temp    = fftn(cat(3,[1 0;0 1],Amatrix),[2,2,N]);
% temp    = fftn(cat(3,[1 0;0 1],-Amatrix),[2,2,N]);
% Af      = temp(:,:,1:N/2);

F       = freqz_freqvec(nfft/2, Fs, 2);

for ii=1:length(F)
    Hf(:,:,ii)  = inv(Af(:,:,ii));                             % Hfは伝達関数
%     Hf(:,:,ii)      = 1./(Af(:,:,ii));                             % Hfは伝達関数    
%     Hf(:,:,ii)  = 1./(Af(:,:,ii));
end
% Hf  = 1./Af;
% Hf  = Af;

for ii=1:length(F)
    Pxx_arfit(:,:,ii)   = (Hf(:,:,ii))*C*(Hf(:,:,ii)');
%     Pxx_arfit(:,:,ii)   = (Hf(:,:,ii)).*conj(Hf(:,:,ii)).*C;
%     Pxx_arfit(1,1,ii)       = C(1,1)*(abs(Hf(1,1,ii))^2)+C(2,2)*(abs(Hf(1,2,ii))^2);
%     Pxx_arfit(2,2,ii)       = C(1,1)*(abs(Hf(2,1,ii))^2)+C(2,2)*(abs(Hf(2,2,ii))^2);    
end
DC(1,2,:)   = squeeze((abs(Hf(1,2,:)).^2)./sum((abs(Hf(1,:,:)).^2),2));
DC(2,1,:)   = squeeze((abs(Hf(2,1,:)).^2)./sum((abs(Hf(2,:,:)).^2),2));
% DC(1,2,:)   = (abs(squeeze(Hf(1,2,:))).^2).*squeeze(Pxx_arfit(2,2,:))./squeeze(Pxx_arfit(1,1,:));
% DC(2,1,:)   = (abs(squeeze(Hf(2,1,:))).^2).*squeeze(Pxx_arfit(1,1,:))./squeeze(Pxx_arfit(2,2,:));
% DC(1,2,:)   = abs(squeeze(Hf(1,2,:)))./sqrt(squeeze(Pxx_arfit(1,1,:)));
% DC(2,1,:)   = abs(squeeze(Hf(2,1,:)))./sqrt(squeeze(Pxx_arfit(2,2,:)));

Coh(1,:)    = (abs(squeeze(Pxx_arfit(1,2,:))).^2)./squeeze(Pxx_arfit(1,1,:))./squeeze(Pxx_arfit(2,2,:));
Coh(2,:)    = (abs(squeeze(Pxx_arfit(2,1,:))).^2)./squeeze(Pxx_arfit(1,1,:))./squeeze(Pxx_arfit(2,2,:));
% Pxx_arfit(1,:) = C(1,1)*((Hf(1,1,:)).*conj(Hf(1,1,:)));   % spectrum (AR model)
% Pxx_arfit(2,:) = C(2,2)*((Hf(2,2,:)).*conj(Hf(2,2,:)));   % spectrum (AR model)
% f_ar = (0:1/T:Fs/2-1/T);
%
subplot(321);plot(f,10*log10(Pxx(1,:)),'-b',F',10*log10(squeeze(Pxx_arfit(1,1,:))),':r');
legend('P11 (FFT spectrum)','P11 (ARfit spectrum)')
ylabel('Magnitude (dB)'); xlabel('Frequency (Hz)');title(['Popt = ',num2str(Mopt)])

subplot(322);plot(f,10*log10(Pxx(2,:)),'-b',F',10*log10(squeeze(Pxx_arfit(2,2,:))),':r');
legend('P22 (FFT spectrum)','P22 (ARfit spectrum)')
ylabel('Magnitude (dB)'); xlabel('Frequency (Hz)');title(['Popt = ',num2str(Mopt)])


% plot directed coherence
subplot(323);plot(F',Coh(1,:),'-b',F',Coh(2,:),':g',F',squeeze(DC(1,2,:)),'-r');
ylabel('Coherence'); xlabel('Frequency (Hz)');title('Dir Coh(2\rightarrow1)')

subplot(324);plot(F',Coh(1,:),'-b',F',Coh(2,:),':g',F',squeeze(DC(2,1,:)),'-r');
ylabel('Coherence'); xlabel('Frequency (Hz)');title('Dir Coh(1\rightarrow2)')



%  prediction by the AR model

y = zeros(N,2);
for I=Mopt+1:N
   for J=1:Mopt
      y(I,:)=y(I,:)+(Amatrix(:,:,J)*x(I-J,:)')';
   end
end


% ------------------------------

x_est    = y(Mopt+1:N,:);
t_est    = t(Mopt+1:N);

subplot(325);plot(t,x(:,1),'-b',t_est,x_est(:,1),':r');ylabel('Amplitude')
axis([0,T,-3,3]);legend('x (obserbed)','x (predicted)')
subplot(326);plot(t,x(:,2),'-b',t_est,x_est(:,2),':r');ylabel('Amplitude')
axis([0,T,-3,3]);legend('x (obserbed)','x (predicted)')

% 
% subplot(325);plot(t_est,x(Mopt+1:N,1)-x_est(:,1),'-r');
% axis([0,T,-0.5,0.5]);legend('x-xest')
% ylabel('Prediction Error'); xlabel('Time (sec)');
% subplot(326);plot(t_est,x(Mopt+1:N,2)-x_est(:,2),'-r');
% axis([0,T,-0.5,0.5]);legend('x-xest')
% ylabel('Prediction Error'); xlabel('Time (sec)');
% % % --------------------------------------------------------
% % %                                  2001.7.09  by K.Tsukada