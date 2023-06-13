clear
Fs = 250;   T = 100;   N = Fs*T; nfft = 256;
t = (0:1/Fs:T-1/Fs);
oscwin  = 50;
osc = 10*sin(2*pi*25*t(1:oscwin));
rn1 = 0.02*randn(size(t));
rn2 = 0.02*randn(size(t));
% ----------------------signal---------------------------
% x(:,1) = sin(2*pi*2*t) +[zeros(1,oscwin) osc zeros(1,N-2*oscwin)] + 10*sin(2*pi*60*t)+ rn1;
% x(:,2) = sin(2*pi*2*t) +[zeros(1,2*oscwin) osc zeros(1,N-3*oscwin)] + 10*sin(2*pi*60*t)+ rn2;
x(:,1) = sin(2*pi*2*t) + sin(2*pi*60*t)+ rn1;
x(:,2) = sin(2*pi*2*t) + cos(2*pi*60*t)+ rn2;

% -------------------------------------------------------
%
%  AR model estimation 
%
Mmin = 100;   % order of AR model
Mmax = 100;

[w,A,C,SBC,FPE,th]  = arfit(x,Mmin,Mmax,'fpe','zero');
P = size(A,2)/size(A,1);
disp(['AR order =',num2str(P)])
[Hf,Sf,F]           = artf(A,C,nfft,Fs);
dcoh(Hf,Sf,F,'b')
