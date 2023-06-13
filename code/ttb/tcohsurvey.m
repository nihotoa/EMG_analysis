function [f,cl]  = tcohsurvey(Ref, Tar, trig,  TimeWindows, nfftPoints, seg_size)
% function [f,cl]  = tcohsurvey(Reffile, Tarfile, trigfile,  TimeWindows, nfftPoints, seg_size)
% function [f,cl]  = tcohsurvey(Reffile, Tarfile, trigfile,  TimeWindows, seg_size, nfftPoints)
% function [f,cl]  = tcohtrig(chan1file, chan2file, trigfile,  trigWindows, reffile, nfftPoints, movingStep)

% Ref     = load(Reffile);
% Tar     = load(Tarfile);
% trig    = load(trigfile);


TimeWindowIndex     = round(TimeWindows * Tar.SampleRate);
WindowLengthIndex   = TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
nseg                = floor(WindowLengthIndex / nfftPoints);

TimeWindow      = TimeWindowIndex / Tar.SampleRate;
timestamp       = round((trig.Data * Tar.SampleRate) / trig.SampleRate);
nstamps         = length(timestamp);
nTarData        = length(Tar.Data);
seg_tot         = nseg * nstamps;

StartIndices    = reshape(repmat(([1:nseg]'-1)*nfftPoints  + TimeWindowIndex(1) ,1,nstamps),seg_tot,1);
timestamp_tot   = reshape(repmat(timestamp,nseg,1),seg_tot,1);


StartIndices    = timestamp_tot + StartIndices;
StopIndices     = StartIndices + nfftPoints -1;
% StartIndices    = timestamp + TimeWindowIndex(1);
% StopIndices     = StartIndices + WindowLengthIndex -1;


jj      = 0;
data1   = zeros(seg_tot,nfftPoints);
data2   = zeros(seg_tot,nfftPoints);

for ii = 1:seg_tot
%     indicator(ii,nstamps,Tar.Name)
    if(StartIndices(ii)>0 & StopIndices(ii)<=nTarData)
        jj  = jj + 1;
        data1(jj,:) = Ref.Data([StartIndices(ii):StopIndices(ii)]);
        data2(jj,:) = Tar.Data([StartIndices(ii):StopIndices(ii)]);
    end
end
% keyboard
if jj~=seg_tot
    data1(jj+1:end,:)   = [];
    data2(jj+1:end,:)   = [];
end
seg_tot         = jj;



% % ’¼ü¬•ª‚Ìœ‹Ž
% data1   = detrend(data1','constant')';
% data2   = detrend(data2','constant')';
% 
% % hanning‘‹‚Ì“K—p
% % keyboard
% winf                = hanning(nfftPoints);
% data1   = repmat(winf',seg_tot,1).*data1;
% data2   = repmat(winf',seg_tot,1).*data2;



ncohloop        = floor(seg_tot / seg_size);


sample_rate = Ref.SampleRate;
% keyboard

for ii  = 1:ncohloop;
    istamps = [((ii-1) * seg_size + 1):((ii-1) * seg_size + seg_size)];
    [temp,cl]   = tcoh(data1(istamps,:),data2(istamps,:),sample_rate);
    f.freq(ii,:)      = temp.freq;
    f.PSD11(ii,:)     = temp.PSD11;
    f.PSD22(ii,:)     = temp.PSD22;
    f.coh(ii,:)       = temp.coh;
    f.phi21(ii,:)     = temp.phi21;
    f.phi11(ii,:)     = temp.phi11;
    f.phi22(ii,:)     = temp.phi22;
%         keyboard
end