thre	= -1;
jitter  = 1;
conIN   = 1;
conMN   = 7;
nfft    = 2560;
samp_rate   = 5000;
seg_size    = 2560;
seg_tot     = 200;


% serial IN
[Input,time]  = sinf(seg_size,samp_rate,15);
Input   = repmat(Input*0.1,seg_tot,1) + randn(seg_tot,seg_size);
time    = time *1000;

for(ii=1:seg_tot)
IN{ii}  = time(Input(ii,:) < thre);
IN{ii}  = IN{ii} + (randn(size(IN{ii})) - 0.5);
IN{ii}  = sort(IN{ii},2);
end

for(ii=1:seg_tot)
serialMN{ii}  = IN{ii} + conMN + (randn(size(IN{ii})) - 0.5);
serialMN{ii}  = sort(serialMN{ii},2);
end

for(ii=1:seg_tot)
serialEMGt{ii}= serialMN{ii} + conMN;
serialEMG(ii,:) = hist(serialEMGt{ii},time);
end

[serialf11,serialf22,serialf21,freq]  = xspec(Input,serialEMG,nfft,samp_rate);
[serialq11,serialq22,serialq21,t,serialc95]  = cumdens(serialf11,serialf22,serialf21,nfft,samp_rate,seg_size,seg_tot,[]);
t   = t*1000;


% sync IN

for(ii=1:seg_tot)
syncMN{ii}  = time(Input(ii,:) < thre);
syncMN{ii}  = syncMN{ii} + (randn(size(syncMN{ii})) - 0.5);
syncMN{ii}  = sort(syncMN{ii},2);
end

for(ii=1:seg_tot)
syncEMGt{ii}= syncMN{ii} + conMN;
syncEMG(ii,:) = hist(syncEMGt{ii},time);
end

[syncf11,syncf22,syncf21,freq]  = xspec(Input,syncEMG,nfft,samp_rate);
[syncq11,syncq22,syncq21,t,syncc95]  = cumdens(syncf11,syncf22,syncf21,nfft,samp_rate,seg_size,seg_tot,[]);
t   = t*1000;


% EMG = [0,1./diff(EMGt)];


% MN
for(ii=1:seg_tot)
MN{ii}  = time(Input(ii,:) < thre);
MN{ii}  = MN{ii} + (randn(size(MN{ii})) - 0.5);
MN{ii}  = sort(MN{ii},2);
end

for(ii=1:seg_tot)
MNEMGt{ii}= MN{ii} + conMN;
MNEMG(ii,:) = hist(MNEMGt{ii},time);
end

[MNf11,MNf22,MNf21,freq]  = xspec(Input,MNEMG,nfft,samp_rate);
[MNq11,MNq22,MNq21,t,MNc95]  = cumdens(MNf11,MNf22,MNf21,nfft,samp_rate,seg_size,seg_tot,[]);
t   = t*1000;



% plot


subplot(331)
plot(time,mean(Input,1),'-b')
xlim([0,500])

% subplot(412)
% plot(IN{1},ones(size(IN{1})),'.b')
% xlim([0,500]);
% 
% subplot(413)
% plot(MN{1},ones(size(MN{1})),'.b')
% xlim([0,500]);

subplot(334)
plot(time,mean(serialEMG,1),'-b')
xlim([0,500]);


subplot(337)
hold off
plot(t,serialq21)
hold on
plot([t(1),t(1);t(end),t(end)],[serialc95,-serialc95;serialc95,-serialc95],'-k');
plot([t(1),t(end)],[0,0],':k');

xlim([-250,250])



subplot(332)
plot(time,mean(Input,1),'-b')
xlim([0,500])

% subplot(412)
% plot(IN{1},ones(size(IN{1})),'.b')
% xlim([0,500]);
% 
% subplot(413)
% plot(MN{1},ones(size(MN{1})),'.b')
% xlim([0,500]);

subplot(335)
plot(time,mean(syncEMG,1),'-b')
xlim([0,500]);

subplot(338)
hold off
plot(t,syncq21)
hold on
plot([t(1),t(1);t(end),t(end)],[syncc95,-syncc95;syncc95,-syncc95],'-k');
plot([t(1),t(end)],[0,0],':k');
xlim([-250,250])



subplot(333)
plot(time,mean(Input,1),'-b')
xlim([0,500])

subplot(336)
plot(time,mean(MNEMG,1),'-b')
xlim([0,500]);

subplot(339)
hold off
plot(t,MNq21)
hold on
plot([t(1),t(1);t(end),t(end)],[MNc95,-MNc95;MNc95,-MNc95],'-k');
plot([t(1),t(end)],[0,0],':k');
xlim([-250,250])
