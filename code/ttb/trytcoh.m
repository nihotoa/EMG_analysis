tdel1   = 16; % delay EMG to spinal 16ms;
tdel2   = 2; % delay spinal to EMG 8ms
p1      = 0.2; % proportion of emg signal affecting sp
p2      = 0.2; % proportion of sp signal affecting emg

SampleRate=250; %sampling rate of data

seg_tot     = 1000;
seg_size    = 128;

sp      = randn(1,seg_tot*seg_size);
emg     = randn(1,seg_tot*seg_size);

for ii=(tdel1+1):length(sp)
    sp(ii)  = (p1*emg(ii-tdel1))+((1-p1)*sp(ii));
    emg(ii)=(p2*sp(ii-tdel2))+((1-p2)*emg(ii));
end

sp  = reshape(sp,seg_size,seg_tot)';
emg = reshape(emg,seg_size,seg_tot)';

% ’¼ü¬•ª‚Ìœ‹Ž
sp  = detrend(sp','constant')';
emg = detrend(emg','constant')';

% hanning‘‹‚Ì“K—p
% keyboard
winf= hanning(seg_size);
sp  = repmat(winf',seg_tot,1).*sp;
emg = repmat(winf',seg_tot,1).*emg;


[f,cl]  = tcoh(sp,emg,SampleRate);
sig     = f.coh > cl.ch_c95;

figure
subplot(2,1,1)
plot(f.freq,f.coh)
hold on
plot([f.freq(1) f.freq(end)],[cl.ch_c95 cl.ch_c95],'--k')
subplot(2,1,2)
plot([f.freq(sig) f.freq(sig)],[f.phi21(sig) f.phi21(sig)-2*pi],'bo')