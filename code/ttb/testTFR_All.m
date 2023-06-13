% s1=topen;
% s2=topen;
s   = topen;
warning('off','MATLAB:divideByZero')

width=10; % in cycles
% srate=250; % in Hz
Freqs=2:2:120; % in Hz

% [y,x]=sinf(256,250,30);

% t1=repmat(y,100,1)+rand(100,256)*0.5;

srate   = s.EndHold.SampleRate;

% [TFR,TFTimeVec,TFFreqVec,TFRAll]=traces2TFR_All(t1',Freqs,srate,width);
% [TFR,TFTimeVec,TFFreqVec,TFRAll]=traces2TFR_All(double(s.TrialData(1:10,:)'),Freqs,s.SampleRate,width);
% [TFR,TFTimeVec,TFFreqVec,TFRAll]=traces2TFR_All(s.EndHold.data{1}(:,:),Freqs,srate,width);


cSmooth=5;
% d1      = double(s1.TrialData(1:20,:));
% d2      = double(s2.TrialData(1:20,:));
d1  = s.EndHold.data{1}(:,:)';
d2  = s.EndHold.data{2}(:,:)';
srate   = s.EndHold.SampleRate;
% [f,timeVec,freqVec] = ttraces2WCOH(d1,d2,Freqs,srate,width,cSmooth);
[COH,timeVec,freqVec] = traces2WCOH(d1,d2,Freqs,srate,width,cSmooth);
figure;

% imagesc(TFTimeVec*1000,TFFreqVec,TFR);
% imagesc(timeVec*1000,freqVec,squeeze(f(3,:,:)));
pcolor(timeVec*1000,freqVec,COH);shading interp
axis xy;
%colorbar;
xlabel('Time (ms)');
ylabel('Frequency (Hz)');
colorbar
warning('off','MATLAB:divideByZero')