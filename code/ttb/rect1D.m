clear; close all;

N   = 512;
PulseWidth  = 20;
PulseStart  = 50;   PulseEnd    = PulseStart + PulseWidth -1;
Rect    = zeros(1,N);   Rect(PulseStart:PulseEnd)   = 1;

FT  = fft(Rect);
PowerSP = FT.*conj(FT); PowerSP = PowerSP/max(PowerSP);

Auto    = ifft(PowerSP);    Auto    = fftshift(Auto);
Auto    = real(Auto);       Auto    = Auto/max(Auto);

T   = 10;
Npl = 1:N/2;
PlotRect    = Rect(Npl);
X   = (Npl-1)*T/N;

subplot(311); plot(X,PlotRect);

PowerSP = fftshift(PowerSP);
Npl     = N/2-N/4:N/2+N/4-1;
PlotPower   = PowerSP(Npl);
df  = 1/T;
f   = ((-N/4:N/4-1)-1)*df;
subplot(312);plot(f,PlotPower);


Npl = N/2-N/4:N/2+N/4-1;
PlotAuto    =Auto(Npl);
t=  ((-N/4:N/4-1)-1).*T./N;
subplot(313);plot(t,PlotAuto)