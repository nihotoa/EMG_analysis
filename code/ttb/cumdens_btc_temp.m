function cumdens_btc

nfft    = 2560;
filt    = [];                                           % filterなし
% filt    = zeros(1,nfft/2-1); filt([4:29,35:50])  = 1;   % filter　5-55、65-95


if(1)   % 実データを使うときは１、シミュレーションを行うときは０
% trig    = load('L:\tkitom\MDAdata\mat\AobaT00203\Grip Offset (success valid)');
trig    = load('L:\tkitom\MDAdata\mat\T01309\Grip Offset (success valid)');

% lfp     = load('L:\tkitom\MDAdata\mat\AobaT00203\Non-filtered-subsample-5000Hz(uV)');
lfp     = load('L:\tkitom\MDAdata\mat\T01309\Non-filtered-subsample-5000Hz(uV)');
x1      = getdata(lfp,trig,[0,nfft-1;nfft,2*nfft-1]);
clear lfp

% emg     = load('L:\tkitom\MDAdata\mat\AobaT00203\FDI-rect(uV)');
emg     = load('L:\tkitom\MDAdata\mat\T01309\FDI-rect(uV)');
x2      = getdata(emg,trig,[0,nfft-1;nfft,2*nfft-1]);
clear emg
else
    seg_size    = 2560;
    seg_tot     = 2;
    samp_tot    = seg_size*seg_tot;
    samp_rate   = 5000;
    fs          = 60;
    dt          = 4;   % ms
    dtind       = round(dt/(1000/samp_rate));
    
    [data,tt]    = sinf(seg_size+dtind,samp_rate,fs);
    data    = repmat(data,seg_tot,1);
    data    = data+randn(seg_tot,seg_size+dtind)*0.001;
    
    x1.Data = data(:,dtind:dtind+seg_size-1);
%     x1.Data     = randn(1,2560);
    x1.seg_size   = seg_size;
    x1.seg_tot  = seg_tot;
    x1.samp_tot    = samp_tot;
    x1.samp_rate    = samp_rate;
    
    x2.Data = data(:,1:seg_size);
%     x2.Data     = randn(1,2560);
    x2.seg_size   = seg_size;
    x2.seg_tot      = seg_tot;
    x2.samp_tot    = samp_tot;
    x2.samp_rate    = samp_rate;
end


[f11,f22,f21,freq]  = xspec(x1.Data,x2.Data,nfft,x1.samp_rate);
[q11,q22,q21,t,cl]  = cumdens(f11,f22,f21,nfft,x1.samp_rate,x1.seg_size,x1.seg_tot,filt);

figure

subplot(3,1,1);
plot(t,q11);

subplot(3,1,2);
plot(t,q22);

subplot(3,1,3);
hold off;
plot(t,q21);
hold on;
plot([t(1),t(1);t(end),t(end)],[cl,-cl;cl,-cl],'-k')
plot([t(1),t(end)],[0,0],':k')

keyboard

